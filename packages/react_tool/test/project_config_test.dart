import 'dart:io';

import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_tool_test_');
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  test('uses conventional entrypoints when react.yaml is absent', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');

    final config = ReactProjectConfig.load(root);

    expect(config.packageName, 'sample');
    expect(config.clientEntrypoint, 'web/client.dart');
    expect(config.ssrEntrypoint, 'lib/ssr.dart');
    expect(config.serverEntrypoint, 'bin/server.dart');
    expect(config.hasReactYaml, isFalse);
  });

  test('reads configuration from react.yaml', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
client:
  entrypoint: app/client.dart
ssr:
  entrypoint: app/ssr.dart
server:
  entrypoint: server/main.dart
static: public
output: build/output
''');

    final config = ReactProjectConfig.load(root);

    expect(config.clientEntrypoint, 'app/client.dart');
    expect(config.ssrEntrypoint, 'app/ssr.dart');
    expect(config.serverEntrypoint, 'server/main.dart');
    expect(config.staticDirectory, 'public');
    expect(config.outputDirectory, 'build/output');
    expect(config.hasReactYaml, isTrue);
  });

  test('reads the Fetch SSR runtime', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
ssr:
  entrypoint: lib/ssr.dart
  runtime: fetch
''');

    final config = ReactProjectConfig.load(root);

    expect(config.ssrRuntime, 'fetch');
  });

  test('rejects an unknown SSR runtime', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
ssr:
  runtime: deno
''');

    expect(
      () => ReactProjectConfig.load(root),
      throwsA(
        isA<ReactToolException>().having(
          (error) => error.message,
          'message',
          contains('Unsupported SSR runtime'),
        ),
      ),
    );
  });

  test('configures Sass entrypoints and output', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
styles:
  entrypoints:
    - web/theme.scss
  output: assets/theme.css
''');

    final config = ReactProjectConfig.load(root);

    expect(config.styleEntrypoints, ['web/theme.scss']);
    expect(config.styleOutput, 'assets/theme.css');
  });

  test('selects the bundling backend from react.yaml', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
bundling:
  backend: rolldown
''');

    final config = ReactProjectConfig.load(root);

    expect(config.bundlingBackend, 'rolldown');
  });

  test('defaults to esbuild and rejects unknown backends', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
bundling:
  backend: webpack
''');

    expect(
      () => ReactProjectConfig.load(root),
      throwsA(
        isA<ReactToolException>().having(
          (e) => e.message,
          'message',
          contains('Unsupported bundling backend'),
        ),
      ),
    );

    await File('${root.path}/react.yaml').writeAsString('name: sample\n');
    final defaults = ReactProjectConfig.load(root);
    expect(defaults.bundlingBackend, 'esbuild');
  });

  test('reads declarative js.bind groups from react.yaml', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
js:
  bind:
    - specifier: react-router-dom
      output: lib/react_router_dom_bindings.g.dart
      shim: lib/react_router_dom_bindings_shim.mjs
      hooks: lib/react_router_dom_hooks.g.dart
      namespace: reactRouter
      prefix: reactRouter
    - specifier: react-router-dom/server
      names: [StaticRouter]
      output: lib/react_router_dom_server_bindings.g.dart
      exclude: [UNSAFE_Something]
''');

    final config = ReactProjectConfig.load(root);

    expect(config.jsBindGroups, hasLength(2));
    final main = config.jsBindGroups.first;
    expect(main.specifier, 'react-router-dom');
    expect(main.names, isEmpty);
    expect(main.output, 'lib/react_router_dom_bindings.g.dart');
    expect(main.shim, 'lib/react_router_dom_bindings_shim.mjs');
    expect(main.hooks, 'lib/react_router_dom_hooks.g.dart');
    expect(main.namespace, 'reactRouter');
    expect(main.prefix, 'reactRouter');
    final server = config.jsBindGroups.last;
    expect(server.names, ['StaticRouter']);
    expect(server.exclude, ['UNSAFE_Something']);
  });

  test('reads foreign component module mappings', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
components:
  - name: Button
    module: web/button.js
    export: Button
    props:
      label: String
      disabled: bool?
''');

    final config = ReactProjectConfig.load(root);

    expect(config.foreignComponents, hasLength(1));
    expect(config.foreignComponents.single.name, 'Button');
    expect(config.foreignComponents.single.module, 'web/button.js');
    expect(config.foreignComponents.single.exportName, 'Button');
    expect(config.foreignComponents.single.props, {
      'label': 'String',
      'disabled': 'bool?',
    });
  });

  test('reads foreign npm dependencies', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
foreign:
  dependencies:
    '@radix-ui/react-dialog': ^1.0.0
  components: []
''');

    final config = ReactProjectConfig.load(root);

    expect(config.foreignDependencies, {'@radix-ui/react-dialog': '^1.0.0'});
  });

  test('uses styles from pubspec when react.yaml is absent', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('''
name: sample
react:
  styles:
    - web/app.scss
''');

    final config = ReactProjectConfig.load(root);

    expect(config.styleEntrypoints, ['web/app.scss']);
  });

  test('reads a react map from pubspec when react.yaml is absent', () async {
    await File('${root.path}/pubspec.yaml').writeAsString('''
name: sample
react:
  client:
    entrypoint: src/client.dart
''');

    final config = ReactProjectConfig.load(root);

    expect(config.clientEntrypoint, 'src/client.dart');
    expect(config.ssrEntrypoint, 'lib/ssr.dart');
  });
}
