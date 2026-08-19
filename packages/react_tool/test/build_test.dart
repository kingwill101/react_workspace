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
    rolldown) ver="1.2.1" ;;
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
import { readFileSync, writeFileSync } from 'node:fs';
export const build = async (options) => {
  writeFileSync(options.outfile, readFileSync(options.entryPoints[0], 'utf8'));
  return { metafile: { inputs: {}, outputs: {} }, warnings: [] };
};
JS
echo 'export default {};' > "$rootdir/node_modules/react/index.js"
echo 'export default {};' > "$rootdir/node_modules/react-dom/index.js"
echo 'export default {};' > "$rootdir/node_modules/react-dom/server.js"
mkdir -p "$rootdir/node_modules/rolldown/dist"
cat > "$rootdir/node_modules/rolldown/package.json" <<JSON
{"name":"rolldown","version":"1.2.1","type":"module"}
JSON
cat > "$rootdir/node_modules/rolldown/dist/index.mjs" <<'JS'
import { readFileSync } from 'node:fs';
export const rolldown = async (options) => ({
  async generate(generateOptions) {
    const entry = options.input[0];
    const code = readFileSync(entry, 'utf8');
    const map = generateOptions.sourcemap
      ? JSON.stringify({ version: 3, sources: [entry], mappings: '' })
      : null;
    return {
      output: [{
        type: 'chunk',
        isEntry: true,
        fileName: entry,
        code,
        map,
      }],
    };
  },
});
JS
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

  test(
    'compiles the server entrypoint to a native binary with --server',
    () async {
      await Directory('${root.path}/bin').create(recursive: true);
      await File(
        '${root.path}/bin/server.dart',
      ).writeAsString('void main() {}\n');
      final config = ReactProjectConfig.load(root);
      final builder = ReactBuilder(
        config: config,
        release: false,
        server: true,
        log: (_) {},
        npmCommand: await writeNpmStub(root),
      );

      await builder.build();

      final binary = Platform.isWindows ? 'server.exe' : 'server';
      final serverFile = File('${root.path}/build/react/$binary');
      expect(
        serverFile.existsSync(),
        isTrue,
        reason: 'expected server binary at build/react/$binary',
      );
      final manifest =
          jsonDecode(
                await File(
                  '${root.path}/build/react/bundle_manifest.json',
                ).readAsString(),
              )
              as Map<String, Object?>;
      expect(manifest['server'], {'binary': './$binary'});
    },
  );

  test('skips the server compile when the entrypoint is missing', () async {
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(
      config: config,
      release: false,
      server: true,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    expect(File('${root.path}/build/react/server').existsSync(), isFalse);
    final manifest =
        jsonDecode(
              await File(
                '${root.path}/build/react/bundle_manifest.json',
              ).readAsString(),
            )
            as Map<String, Object?>;
    expect(manifest.containsKey('server'), isFalse);
  });

  test(
    'bundles project foreign components into per-target aggregates',
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
        expect(entry, contains("__reactDartRegisterComponent('Card'"));
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
    },
  );

  test(
    'bundles shims declared by dependency packages (react.js schema)',
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
      expect(
        logs.any((l) => l.startsWith("Installing JS environment into")),
        isTrue,
      );
      expect(
        File('${root.path}/.dart_tool/react/js/.installed').existsSync(),
        isTrue,
      );
      // The host package.json is never mutated.
      expect(File('${root.path}/package.json').existsSync(), isFalse);
    },
  );

  test('prebuilt wrappers ship bundles and skip npm installs', () async {
    // A wrapper distributing already-bundled per-target artifacts: react is
    // the only external, npm dependencies are inlined by the wrapper author.
    final dep = Directory('${root.path}/../fake_prebuilt');
    await dep.create(recursive: true);
    await File('${dep.path}/pubspec.yaml').writeAsString('''
name: fake_prebuilt
react:
  js:
    schema: 1
    prebuilt:
      browser: lib/prebuilt.browser.mjs
      ssr: lib/prebuilt.ssr.mjs
    peers:
      react: ">=18 <20"
      react-dom: ">=18 <20"
    externals:
      - react
      - react-dom
''');
    await Directory('${dep.path}/lib').create(recursive: true);
    for (final target in ['browser', 'ssr']) {
      await File('${dep.path}/lib/prebuilt.$target.mjs').writeAsString('''
import React from 'react';
globalThis.__reactDartRegisterComponent?.(
  'prebuilt.$target.Panel',
  () => React.createElement('div'),
);
''');
    }

    final dartTool = Directory('${root.path}/.dart_tool');
    await dartTool.create(recursive: true);
    await File('${dartTool.path}/package_config.json').writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {"name": "sample", "rootUri": "../", "packageUri": "lib/"},
    {"name": "fake_prebuilt", "rootUri": "../../fake_prebuilt", "packageUri": "lib/"}
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

    // entryFor(target) picks the prebuilt artifact for each target.
    for (final target in ['browser', 'ssr']) {
      final entry = await File(
        '${root.path}/build/react/foreign/$target/entry.mjs',
      ).readAsString();
      expect(
        entry,
        contains(
          "import \"${p.normalize('${dep.path}/lib/prebuilt.$target.mjs')}\";",
        ),
      );
    }

    // The environment installs only the framework singletons: the prebuilt
    // wrapper's (nonexistent) npm dependencies must not be requested, and
    // its peers still pin react/react-dom.
    final manifest =
        jsonDecode(
              await File(
                '${root.path}/.dart_tool/react/js/package.json',
              ).readAsString(),
            )
            as Map;
    final dependencies = manifest['dependencies'] as Map;
    expect(dependencies.keys.toSet(), {'react', 'react-dom'});
    expect(dependencies['react'], '18.3.1');
    expect(dependencies['react-dom'], '18.3.1');
    // Host manifest untouched.
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
    final manifest =
        jsonDecode(
              await File(
                '${root.path}/.dart_tool/react/js/package.json',
              ).readAsString(),
            )
            as Map;
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

  test(
    'generates target bootstraps, index rewrite, and bundle manifest',
    () async {
      await File('${root.path}/react.yaml').writeAsString('''
client:
  entrypoint: web/client.dart
ssr:
  entrypoint: lib/ssr.dart
foreign:
  - name: Card
    module: web/card.js
    props:
      label: String
''');
      await File(
        '${root.path}/web/client.dart',
      ).writeAsString('void main() {}\n');
      await Directory('${root.path}/lib').create(recursive: true);
      await File('${root.path}/lib/ssr.dart').writeAsString('void main() {}\n');
      await File('${root.path}/web/index.html').writeAsString('''<!doctype html>
<html>
<head>
<script type="importmap">
{"imports":{"react":"https://esm.sh/react@18.2.0","react-dom":"https://esm.sh/react-dom@18.2.0","react-dom/":"https://esm.sh/react-dom@18.2.0/"}}
</script>
</head>
<body>
<div id="app">{{SSR}}</div>
<script id="__props" type="application/json">{{PROPS}}</script>
<script type="module">
import React from 'react';
import ReactDOM from 'react-dom/client';
globalThis.React = React;
globalThis.ReactDOM = ReactDOM;
</script>
<script type="module" src="client.js"></script>
</body>
</html>
''');

      final config = ReactProjectConfig.load(root);
      final builder = ReactBuilder(
        config: config,
        release: false,
        log: (_) {},
        npmCommand: await writeNpmStub(root),
      );

      await builder.build();

      final browserEntry = await File(
        '${root.path}/build/react/browser.entry.mjs',
      ).readAsString();
      expect(browserEntry, contains("import React from 'react';"));
      expect(browserEntry, contains('globalThis.React = React;'));
      expect(
        browserEntry,
        contains("await import('./callback_trampoline.mjs');"),
      );
      expect(
        browserEntry,
        contains("await import('./foreign/browser/bundle.mjs');"),
      );
      expect(browserEntry, contains("await import('./client.js');"));

      final index = await File(
        '${root.path}/build/react/index.html',
      ).readAsString();
      expect(index, contains('<script type="module" src="browser.entry.mjs">'));
      expect(index, isNot(contains('src="client.js"')));
      expect(index, isNot(contains('globalThis.React')));
      expect(index, contains('react@18.3.1'));
      expect(index, contains('react-dom@18.3.1'));

      final ssrEntry = await File(
        '${root.path}/build/react/ssr.entry.mjs',
      ).readAsString();
      expect(ssrEntry, contains('node_modules/react/index.js'));
      expect(ssrEntry, contains('node_modules/react-dom/server.js'));
      expect(ssrEntry, contains('createRequire'));
      expect(ssrEntry, contains("await import('./ssr_runtime.mjs');"));

      final ssrRuntime = await File(
        '${root.path}/build/react/ssr_runtime.mjs',
      ).readAsString();
      expect(ssrRuntime, contains('http.createServer'));
      expect(ssrRuntime, contains('__REACT_RENDER_FALLBACK__'));
      expect(ssrRuntime, contains('globalThis.ReactDOMServer.renderToString'));

      final manifest =
          jsonDecode(
                await File(
                  '${root.path}/build/react/bundle_manifest.json',
                ).readAsString(),
              )
              as Map;
      expect(manifest['schema'], 1);
      expect(manifest['bundler'], 'esbuild');
      expect(manifest['mode'], 'development');
      final browser = manifest['browser'] as Map;
      expect(browser['entry'], 'browser.entry.mjs');
      expect(browser['dart'], 'client.js');
      expect(browser['foreign'], 'foreign/browser/bundle.mjs');
      expect((browser['bytes'] as Map)['dart'], greaterThan(0));
      final ssr = manifest['ssr'] as Map;
      expect(ssr['entry'], 'ssr.entry.mjs');
      expect(ssr['dart'], 'ssr.js');
      expect(ssr['runtime'], 'ssr_runtime.mjs');
      expect(ssr['foreign'], 'foreign/ssr/bundle.mjs');

      final parsed = BundleManifest.load(Directory('${root.path}/build/react'));
      expect(parsed.bundler, 'esbuild');
      expect(parsed.browserEntry, 'browser.entry.mjs');
      expect(parsed.ssrEntry, 'ssr.entry.mjs');
      expect(parsed.ssr?.runtime, 'ssr_runtime.mjs');

      final report =
          jsonDecode(
                await File(
                  '${root.path}/build/react/bundle_report.json',
                ).readAsString(),
              )
              as Map;
      expect(report['schema'], 1);
      expect(report['mode'], 'development');
      for (final target in ['browser', 'ssr']) {
        final targetReport = report[target] as Map;
        expect(targetReport['artifacts'], 1);
        expect((targetReport['uncompressedBytes'] as int), greaterThan(0));
        expect((targetReport['gzipBytes'] as int), greaterThan(0));
        expect(targetReport['externals'], contains('react'));
        expect(targetReport['externals'], contains('react-dom'));
        // The stub app is `void main() {}`, so application-level pruning
        // drops the unused `Card` registration from both targets.
        expect(targetReport['retainedExports'], isEmpty);
        expect(targetReport['retainedHookNamespaces'], isEmpty);
        expect(targetReport['usedComponents'], isEmpty);
        expect(targetReport['usedHooks'], isEmpty);
      }
      for (final target in ['browser', 'ssr']) {
        final bundle = await File(
          '${root.path}/build/react/foreign/$target/bundle.mjs',
        ).readAsString();
        expect(bundle, isNot(contains("__reactDartRegisterComponent('Card'")));
      }
    },
  );

  test('builds through the rolldown backend via the node driver', () async {
    await Directory('${root.path}/lib').create(recursive: true);
    await File(
      '${root.path}/web/client.dart',
    ).writeAsString('void main() {}\n');
    await File('${root.path}/lib/ssr.dart').writeAsString('void main() {}\n');
    await File('${root.path}/react.yaml').writeAsString('''
bundling:
  backend: rolldown
foreign:
  - name: Card
    module: web/card.js
    props:
      label: String
''');
    final config = ReactProjectConfig.load(root);
    expect(config.bundlingBackend, 'rolldown');

    final builder = ReactBuilder(
      config: config,
      release: false,
      log: (_) {},
      npmCommand: await writeNpmStub(root),
    );

    await builder.build();

    expect(
      File('${root.path}/.dart_tool/react/js/rolldown_driver.mjs').existsSync(),
      isTrue,
    );
    for (final target in ['browser', 'ssr']) {
      final bundle = await File(
        '${root.path}/build/react/foreign/$target/bundle.mjs',
      ).readAsString();
      // The stub app uses no foreign components, so the aggregate is pruned.
      expect(bundle, isNot(contains("__reactDartRegisterComponent('Card'")));
    }

    final manifest =
        jsonDecode(
              await File(
                '${root.path}/build/react/bundle_manifest.json',
              ).readAsString(),
            )
            as Map;
    expect(manifest['bundler'], 'rolldown');

    final report =
        jsonDecode(
              await File(
                '${root.path}/build/react/bundle_report.json',
              ).readAsString(),
            )
            as Map;
    for (final target in ['browser', 'ssr']) {
      final targetReport = report[target] as Map;
      expect((targetReport['artifacts'] as int), greaterThanOrEqualTo(1));
      expect((targetReport['uncompressedBytes'] as int), greaterThan(0));
      expect(targetReport['retainedExports'], isEmpty);
    }
  });
}
