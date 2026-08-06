import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;

import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_tool_scaffold_test_');
  });

  tearDown(() async {
    if (root.existsSync()) {
      await root.delete(recursive: true);
    }
  });

  test('generates the full project skeleton', () async {
    final target = Directory(p.join(root.path, 'my_app'));
    await ScaffoldGenerator().generate(
      name: 'my_app',
      packagesPath: '../packages',
      target: target,
    );

    final expectedFiles = <String>[
      'pubspec.yaml',
      'analysis_options.yaml',
      '.gitignore',
      'react.yaml',
      'package.json',
      'web/index.html',
      'web/styles.scss',
      'web/client.dart',
      'lib/app.dart',
      'lib/greeting.dart',
      'lib/ssr.dart',
      'bin/server.dart',
      'Dockerfile',
      '.dockerignore',
      'README.md',
      'test/app_test.dart',
      'test/greeting_test.dart',
    ];
    for (final relative in expectedFiles) {
      expect(
        File(p.join(target.path, relative)).existsSync(),
        isTrue,
        reason: 'expected $relative',
      );
    }
  });

  test('generates a client-only project skeleton', () async {
    final target = Directory(p.join(root.path, 'my_app'));
    await ScaffoldGenerator().generate(
      name: 'my_app',
      packagesPath: '../packages',
      target: target,
      template: 'client',
    );

    final expectedFiles = <String>[
      'pubspec.yaml',
      'analysis_options.yaml',
      '.gitignore',
      'react.yaml',
      'package.json',
      'web/index.html',
      'web/styles.scss',
      'web/client.dart',
      'lib/app.dart',
      'lib/greeting.dart',
      'README.md',
      'test/app_test.dart',
    ];
    for (final relative in expectedFiles) {
      expect(
        File(p.join(target.path, relative)).existsSync(),
        isTrue,
        reason: 'expected $relative',
      );
    }

    final notExpected = <String>[
      'lib/ssr.dart',
      'bin/server.dart',
      'Dockerfile',
      '.dockerignore',
    ];
    for (final relative in notExpected) {
      expect(
        File(p.join(target.path, relative)).existsSync(),
        isFalse,
        reason: 'did not expect $relative',
      );
    }
  });

  test('interpolates project data and preserves SSR placeholders', () async {
    final target = Directory(p.join(root.path, 'my_app'));
    await ScaffoldGenerator().generate(
      name: 'my_app',
      packagesPath: '../packages',
      target: target,
    );

    String read(String relative) =>
        File(p.join(target.path, relative)).readAsStringSync();

    final pubspec = read('pubspec.yaml');
    expect(pubspec, contains('name: my_app'));
    expect(pubspec, contains('react: {path: ../packages/react}'));
    expect(pubspec, contains('react_codegen: {path: ../packages/react_codegen}'));
    expect(pubspec, contains('react_tool: {path: ../packages/react_tool}'));
    expect(pubspec, contains('build_runner: ^2.15.3'));

    final html = read('web/index.html');
    expect(html, contains('<title>My App</title>'));
    expect(html, contains('{{SSR}}'));
    expect(html, contains('{{PROPS}}'));

    final client = read('web/client.dart');
    expect(client, contains('package:my_app/app.react.dart'));
    expect(client, contains('package:my_app/react_components.g.dart'));

    final server = read('bin/server.dart');
    expect(server, contains('package:my_app/server_actions.g.dart'));
    expect(server, contains('_defaultRootComponent'));
    expect(server, contains("'title': 'Hello from SSR'"));

    final app = read('lib/app.dart');
    expect(app, contains('@reactComponent'));
    expect(app, contains("greetAction(name: 'world')"));

    final greeting = read('lib/greeting.dart');
    expect(greeting, contains('@serverFunction'));
    expect(greeting, contains('Future<String> greet'));

    final ssr = read('lib/ssr.dart');
    expect(ssr, contains('SsrComponentRegistry.register'));
    expect(ssr, contains('registerGlobalRenderer'));

    final dockerfile = read('Dockerfile');
    expect(dockerfile, contains('my_app/Dockerfile'));
    expect(dockerfile, contains('dart run react_tool:react build --server'));
    expect(dockerfile, contains('node build/react/ssr.entry.mjs'));

    final readme = read('README.md');
    expect(readme, contains('# My App'));
  });

  test('refuses to overwrite without force and allows it with force', () async {
    final target = Directory(p.join(root.path, 'my_app'));
    await ScaffoldGenerator().generate(
      name: 'my_app',
      packagesPath: '../packages',
      target: target,
    );

    await expectLater(
      ScaffoldGenerator().generate(
        name: 'my_app',
        packagesPath: '../packages',
        target: target,
      ),
      throwsA(isA<ReactToolException>()),
    );

    await ScaffoldGenerator().generate(
      name: 'my_app',
      packagesPath: '../packages',
      target: target,
      force: true,
    );
    expect(File(p.join(target.path, 'pubspec.yaml')).existsSync(), isTrue);
  });

  test('init command scaffolds into the working directory', () async {
    final runner = CommandRunner<void>('react', '')
      ..addCommand(InitCommand(workingDirectory: root));
    await runner.run(['init', 'widgets_app']);

    expect(
      File(p.join(root.path, 'widgets_app', 'pubspec.yaml')).existsSync(),
      isTrue,
    );
    expect(
      File(p.join(root.path, 'widgets_app', 'Dockerfile')).existsSync(),
      isTrue,
    );
    final pubspec = await File(
      p.join(root.path, 'widgets_app', 'pubspec.yaml'),
    ).readAsString();
    expect(pubspec, contains('name: widgets_app'));
  });

  test('init command with --template client scaffolds a client-only project',
      () async {
    final runner = CommandRunner<void>('react', '')
      ..addCommand(InitCommand(workingDirectory: root));
    await runner.run(['init', '--template', 'client', 'client_app']);

    expect(
      File(p.join(root.path, 'client_app', 'pubspec.yaml')).existsSync(),
      isTrue,
    );
    expect(
      File(p.join(root.path, 'client_app', 'Dockerfile')).existsSync(),
      isFalse,
    );
    expect(
      File(p.join(root.path, 'client_app', 'lib', 'ssr.dart')).existsSync(),
      isFalse,
    );
    final pubspec = await File(
      p.join(root.path, 'client_app', 'pubspec.yaml'),
    ).readAsString();
    expect(pubspec, contains('name: client_app'));
    expect(pubspec, isNot(contains('react_server')));
    expect(pubspec, isNot(contains('\n  shelf:')));
    final reactYaml = await File(
      p.join(root.path, 'client_app', 'react.yaml'),
    ).readAsString();
    expect(reactYaml, isNot(contains('ssr:')));
    expect(reactYaml, isNot(contains('server:')));
  });

  test('init command rejects an invalid project name', () async {
    final runner = CommandRunner<void>('react', '')
      ..addCommand(InitCommand(workingDirectory: root));
    await runner.run(['init', 'Bad Name']);

    // The runner reports usage errors without throwing; no project should
    // be created.
    expect(Directory(p.join(root.path, 'Bad Name')).existsSync(), isFalse);
  });
}
