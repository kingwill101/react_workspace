import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

/// Stub package manager: answers `npm view <spec> version` with a semver and
/// provisions a minimal resolvable node_modules on `npm install` (react,
/// react-dom, esbuild, and any declared dependency).
Future<String> writeNpmStub(Directory root) async {
  final npmStub = File('${root.path}/stub_npm.sh');
  await npmStub.writeAsString(r'''#!/bin/sh
if [ "$1" = "view" ]; then
  name="$2"
  case "$name" in
    react|react-dom) ver="18.3.1" ;;
    esbuild) ver="0.28.1" ;;
    *) ver="2.1.0" ;;
  esac
  case "$*" in
    *--json*) echo "[\"$ver\"]" ;;
    *) echo "$ver" ;;
  esac
  exit 0
fi
rootdir="$(pwd)"
mkdir -p "$rootdir/node_modules/esbuild/lib" \
  "$rootdir/node_modules/react" \
  "$rootdir/node_modules/react-dom"
for pkg in esbuild react react-dom; do
  cat > "$rootdir/node_modules/$pkg/package.json" <<JSON
{"name":"$pkg","version":"1.2.3","main":"index.js","type":"module"}
JSON
done
cat > "$rootdir/node_modules/esbuild/lib/main.js" <<'JS'
export const build = async (options) => {};
JS
echo 'export default {};' > "$rootdir/node_modules/react/index.js"
echo 'export default {};' > "$rootdir/node_modules/react-dom/index.js"
echo 'export default {};' > "$rootdir/node_modules/react-dom/server.js"
for name in fake-widget-lib missing-widget zustand react-router-dom; do
  if [ ! -d "$rootdir/node_modules/$name" ]; then
    mkdir -p "$rootdir/node_modules/$name"
    echo "{\"name\":\"$name\",\"version\":\"1.2.3\",\"main\":\"index.js\"}" \
      > "$rootdir/node_modules/$name/package.json"
    echo 'export default {};' > "$rootdir/node_modules/$name/index.js"
  fi
done
exit 0
''');
  await Process.run('chmod', ['+x', npmStub.path]);
  return npmStub.path;
}

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_tool_build_test_');
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
styles:
  - web/theme.scss
  - web/card.module.scss
foreign:
  - name: Card
    module: web/card.js
    props:
      label: String
      disabled: bool?
''');
    await Directory('${root.path}/web').create(recursive: true);
    await File(
      '${root.path}/web/index.html',
    ).writeAsString('<!doctype html><html><head></head><body></body></html>');
    await File('${root.path}/web/theme.scss').writeAsString(r'''
$accent: #336699;
.card {
  color: $accent;
  .title { font-weight: bold; }
}
''');
    await File('${root.path}/web/card.module.scss').writeAsString(r'''
.card { padding: 1rem; }
''');
    await File(
      '${root.path}/web/card.js',
    ).writeAsString('export default function Card() {}\n');
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  test('compiles configured Sass into the React output', () async {
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    final index = await File(
      '${root.path}/build/react/index.html',
    ).readAsString();
    expect(index, contains('href="theme.css"'));
    expect(index, contains('href="card.module.css"'));

    final css = await File('${root.path}/build/react/theme.css').readAsString();
    expect(css, contains('.card'));
    expect(css, contains('color: #336699;'));
    expect(css, contains('.card .title'));
    expect(File('${root.path}/build/react/theme.scss').existsSync(), isFalse);

    final moduleCss = await File(
      '${root.path}/build/react/card.module.css',
    ).readAsString();
    expect(moduleCss, matches(RegExp(r'\.card__[0-9a-f]{6}')));
    final bindings = await File(
      '${root.path}/web/card.module.dart',
    ).readAsString();
    expect(bindings, contains('final class CardModuleStyles'));
    expect(
      bindings,
      matches(RegExp(r"static const card = 'card__[0-9a-f]{6}'")),
    );
    expect(
      File('${root.path}/build/react/card.module.scss').existsSync(),
      isFalse,
    );
  });

  test('bundles project foreign components into per-target aggregates',
      () async {
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    final cardPath = '${root.path}/web/card.js';
    for (final target in ['browser', 'ssr']) {
      final entry = await File(
        '${root.path}/build/react/foreign/$target/entry.mjs',
      ).readAsString();
      expect(entry, contains("import _foreignDefault from \"$cardPath\";"));
      expect(
        entry,
        contains("__reactDartRegisterComponent('Card'"),
      );
    }
    final foreignBindings = await File(
      '${root.path}/lib/foreign_components.g.dart',
    ).readAsString();
    expect(foreignBindings, contains('required String label'));
    expect(foreignBindings, contains('bool? disabled'));
    expect(foreignBindings, contains("'Card'"));
    // The managed environment was provisioned, not the host package.json.
    expect(
      File('${root.path}/.dart_tool/react/js/package.json').existsSync(),
      isTrue,
    );
    expect(File('${root.path}/package.json').existsSync(), isFalse);
  });

  test('bundles shims declared by dependency packages (react.js schema)',
      () async {
    // A fake wrapper package shipping a self-registering shim.
    final dep = Directory('${root.path}/../fake_router');
    await dep.create(recursive: true);
    await File('${dep.path}/pubspec.yaml').writeAsString('''
name: fake_router
react:
  js:
    schema: 1
    entries:
      shared: lib/fake_router_shim.mjs
    dependencies:
      fake-widget-lib: ^2.1.0
    peers:
      react: ">=18 <20"
    externals:
      - react
      - react-dom
''');
    await Directory('${dep.path}/lib').create(recursive: true);
    await File('${dep.path}/lib/fake_router_shim.mjs').writeAsString('''
globalThis.__reactDartRegisterComponent?.(
  'fakeRouter.Panel',
  () => null,
);
''');

    // package_config.json mapping `fake_router` to the dependency.
    final dartTool = Directory('${root.path}/.dart_tool');
    await dartTool.create(recursive: true);
    await File('${dartTool.path}/package_config.json').writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {"name": "sample", "rootUri": "../", "packageUri": "lib/"},
    {"name": "fake_router", "rootUri": "../../fake_router", "packageUri": "lib/"}
  ]
}
''');

    final logs = <String>[];
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      log: logs.add,
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    final shimPath = '${dep.path}/lib/fake_router_shim.mjs';
    for (final target in ['browser', 'ssr']) {
      final entry = await File(
        '${root.path}/build/react/foreign/$target/entry.mjs',
      ).readAsString();
      expect(entry, contains("import \"${p.normalize(shimPath)}\";"));
    }
    expect(logs.any((l) => l.startsWith("Installing JS environment into")), isTrue);
    expect(
      File('${root.path}/.dart_tool/react/js/.installed').existsSync(),
      isTrue,
    );
    // The host package.json is never mutated.
    expect(File('${root.path}/package.json').existsSync(), isFalse);
  });

  test('accepts the legacy react.shims / react.npm fields', () async {
    final dep = Directory('${root.path}/../fake_legacy');
    await dep.create(recursive: true);
    await File('${dep.path}/pubspec.yaml').writeAsString('''
name: fake_legacy
react:
  shims:
    - fake_legacy_shim.mjs
  npm:
    fake-widget-lib: ^2.1.0
''');
    await Directory('${dep.path}/lib').create(recursive: true);
    await File('${dep.path}/lib/fake_legacy_shim.mjs').writeAsString(
      'globalThis.__reactDartRegisterComponent?.("fakeLegacy.Panel", () => null);\n',
    );

    final dartTool = Directory('${root.path}/.dart_tool');
    await dartTool.create(recursive: true);
    await File('${dartTool.path}/package_config.json').writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {"name": "sample", "rootUri": "../", "packageUri": "lib/"},
    {"name": "fake_legacy", "rootUri": "../../fake_legacy", "packageUri": "lib/"}
  ]
}
''');

    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    final shimPath = '${dep.path}/lib/fake_legacy_shim.mjs';
    for (final target in ['browser', 'ssr']) {
      final entry = await File(
        '${root.path}/build/react/foreign/$target/entry.mjs',
      ).readAsString();
      expect(entry, contains("import \"${p.normalize(shimPath)}\";"));
    }
    final manifest = jsonDecode(
      await File(
        '${root.path}/.dart_tool/react/js/package.json',
      ).readAsString(),
    ) as Map;
    // Managed mode resolves exact versions (never mutating the host
    // package.json); the stub npm reports 2.1.0 for every `npm view`.
    expect((manifest['dependencies'] as Map)['fake-widget-lib'], '2.1.0');
  });

  test('fails loudly when bundling without a JS environment', () async {
    // Force host mode with no host JS project present: validation must fail
    // with a clear message instead of a fallback copy.
    await File('${root.path}/react.yaml').writeAsString('''
foreign:
  host: true
  components:
    - name: Card
      module: web/card.js
''');
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await expectLater(builder.build(), throwsA(isA<JsEnvironmentException>()));
  });
}
