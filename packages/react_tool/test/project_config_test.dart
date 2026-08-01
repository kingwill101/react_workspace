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
