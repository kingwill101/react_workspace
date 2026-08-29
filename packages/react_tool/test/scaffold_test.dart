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

  test('init command exposes routed-minimal template option and text', () {
    final command = InitCommand(workingDirectory: root);
    final templateOption = command.argParser.options['template'];
    expect(templateOption, isNotNull);
    expect(
      templateOption!.allowed,
      containsAll(<String>['ssr', 'client', 'routed', 'routed-minimal']),
    );
    expect(
      templateOption.help ?? '',
      allOf(contains('routed'), contains('routed-minimal')),
    );
  });

  test('prerender command exposes route and output options', () {
    final command = PrerenderCommand();
    expect(command.name, 'prerender');
    expect(command.argParser.options['routes'], isNotNull);
    expect(command.argParser.options['manifest'], isNotNull);
    expect(command.argParser.options['output'], isNotNull);
    expect(command.argParser.options['port'], isNotNull);
    expect(command.argParser.options['ssr-port'], isNotNull);
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
      'lib/react/app.dart',
      'lib/react/greeting.dart',
      'lib/react/ssr.dart',
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
      'lib/react/app.dart',
      'lib/react/greeting.dart',
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
      'lib/react/ssr.dart',
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
    expect(pubspec, contains('react_core: ^0.1.0'));
    expect(pubspec, contains('react_codegen: ^0.1.0'));
    expect(pubspec, contains('react_server_shelf: ^0.1.1'));
    expect(pubspec, contains('react_tool: ^0.2.4'));
    expect(pubspec, contains('react_core: {path: ../packages/react_core}'));
    expect(pubspec, contains('build_runner: ^2.15.3'));

    final gitignore = read('.gitignore');
    expect(gitignore, contains('lib/.generated/'));

    final html = read('web/index.html');
    expect(html, contains('<title>My App</title>'));
    expect(html, contains('{{SSR}}'));
    expect(html, contains('{{PROPS}}'));

    final client = read('web/client.dart');
    expect(client, contains("import 'package:react_dom/react_dom.dart';"));
    expect(
      client,
      isNot(contains("import 'package:react_web/react_web.dart'")),
    );
    expect(client, contains('package:my_app/.generated/react/app.react.dart'));
    expect(
      client,
      contains('package:my_app/.generated/react_components.g.dart'),
    );

    final server = read('bin/server.dart');
    expect(server, contains('package:my_app/.generated/server_actions.g.dart'));
    expect(server, contains('_defaultRootComponent'));
    expect(server, contains("'title': 'Hello from SSR'"));

    final app = read('lib/react/app.dart');
    expect(app, contains("import 'package:react_dom/react_dom.dart';"));
    expect(app, isNot(contains("import 'package:react_core/react.dart';")));
    expect(app, contains("fontFamily: 'system-ui, sans-serif'"));
    expect(app, contains("children: [props.title]"));
    expect(app, contains("dataAttributes({'app': 'react-dart'})"));
    expect(app, contains('@reactComponent'));
    expect(app, contains("greetAction(name: 'world')"));

    final greeting = read('lib/react/greeting.dart');
    expect(greeting, contains('@serverFunction'));
    expect(greeting, contains('Future<String> greet'));

    final ssr = read('lib/react/ssr.dart');
    expect(ssr, contains("package:my_app/.generated/react/app.react.dart"));
    expect(ssr, contains('SsrComponentRegistry.register'));
    expect(ssr, contains('registerGlobalRenderer'));

    final dockerfile = read('Dockerfile');
    expect(dockerfile, contains('my_app/Dockerfile'));
    expect(dockerfile, contains('dart run react_tool:react build --server'));
    expect(dockerfile, contains('node build/react/ssr.entry.mjs'));

    final readme = read('README.md');
    expect(readme, contains('# My App'));
    expect(readme, contains('lib/react/app.dart'));
    expect(readme, isNot(contains('dart test -t integration')));

    final vscodeSettings = read('.vscode/settings.json');
    expect(vscodeSettings, contains('"files.exclude"'));
    expect(vscodeSettings, contains('.generated'));
    expect(vscodeSettings, contains('build'));
  });

  test('uses hosted packages by default', () async {
    final target = Directory(p.join(root.path, 'hosted_app'));
    final generator = ScaffoldGenerator();
    await generator.generate(
      name: 'hosted_app',
      packagesPath: '',
      target: target,
    );

    final pubspec = File(
      p.join(target.path, 'pubspec.yaml'),
    ).readAsStringSync();
    expect(pubspec, contains('react_core: ^0.1.0'));
    expect(pubspec, contains('react_tool: ^0.2.4'));
    expect(pubspec, isNot(contains('dependency_overrides:')));
    expect(pubspec, isNot(contains('path: ../packages')));
  });

  test('init command with --template routed scaffolds a routed app', () async {
    final runner = CommandRunner<void>('react', '')
      ..addCommand(InitCommand(workingDirectory: root));
    await runner.run(['init', '--template', 'routed', 'routed_app']);

    expect(
      File(p.join(root.path, 'routed_app', 'pubspec.yaml')).existsSync(),
      isTrue,
    );
    expect(
      File(p.join(root.path, 'routed_app', 'bin/server.dart')).existsSync(),
      isTrue,
    );
    expect(
      File(
        p.join(root.path, 'routed_app', 'lib', 'react', 'ssr.dart'),
      ).existsSync(),
      isTrue,
    );

    final pubspec = await File(
      p.join(root.path, 'routed_app', 'pubspec.yaml'),
    ).readAsString();
    expect(pubspec, contains('name: routed_app'));
    expect(pubspec, isNot(contains('react_server_shelf')));
    expect(pubspec, contains('react_server_routed'));
    expect(pubspec, contains('routed_core'));
    expect(pubspec, contains('routed_io'));
    expect(pubspec, contains('routed_testing'));
    expect(pubspec, contains('routed_core: ^0.5.1'));
    expect(pubspec, contains('routed_io: ^0.1.2'));
    expect(pubspec, contains('routed_testing: ^0.4.1'));
    expect(pubspec, contains('path: ^1.9.1'));
    expect(pubspec, isNot(contains('git:')));
    expect(pubspec, isNot(contains('\n  shelf:')));

    final server = await File(
      p.join(root.path, 'routed_app', 'bin/server.dart'),
    ).readAsString();
    expect(
      server,
      contains('import \'package:routed_core/routed_core.dart\';'),
    );
    expect(server, contains('import \'package:routed_io/routed_io.dart\';'));
    expect(server, contains('RoutedReactApplication'));

    final readme = await File(
      p.join(root.path, 'routed_app', 'README.md'),
    ).readAsString();
    expect(readme, contains('Routed'));
    expect(readme, contains('Dockerfile'));
    expect(readme, contains('docker build'));

    final vscodeSettings = await File(
      p.join(root.path, 'routed_app', '.vscode', 'settings.json'),
    ).readAsString();
    expect(vscodeSettings, contains('"files.exclude"'));
    expect(vscodeSettings, contains('.generated'));
    expect(vscodeSettings, contains('build'));

    expect(
      File(p.join(root.path, 'routed_app', 'Dockerfile')).existsSync(),
      isTrue,
    );
    expect(
      File(p.join(root.path, 'routed_app', '.dockerignore')).existsSync(),
      isTrue,
    );
  });

  test(
    'init command with --template routed-minimal scaffolds smaller routed app',
    () async {
      final runner = CommandRunner<void>('react', '')
        ..addCommand(InitCommand(workingDirectory: root));
      await runner.run(['init', '--template', 'routed-minimal', 'routed_mini']);

      final appDir = Directory(p.join(root.path, 'routed_mini'));
      expect(File(p.join(appDir.path, 'pubspec.yaml')).existsSync(), isTrue);
      expect(File(p.join(appDir.path, 'bin/server.dart')).existsSync(), isTrue);
      expect(
        File(p.join(appDir.path, 'lib', 'react', 'ssr.dart')).existsSync(),
        isTrue,
      );
      expect(File(p.join(appDir.path, 'README.md')).existsSync(), isTrue);

      for (final relative in <String>[
        'test/app_test.dart',
        'test/greeting_test.dart',
      ]) {
        expect(
          File(p.join(appDir.path, relative)).existsSync(),
          isTrue,
          reason: 'expected $relative',
        );
      }

      final notExpected = <String>['Dockerfile', '.dockerignore'];
      for (final relative in notExpected) {
        expect(
          File(p.join(appDir.path, relative)).existsSync(),
          isFalse,
          reason: 'did not expect $relative',
        );
      }

      final pubspec = await File(
        p.join(appDir.path, 'pubspec.yaml'),
      ).readAsString();
      expect(pubspec, contains('name: routed_mini'));
      expect(pubspec, contains('react_server_routed'));
      expect(pubspec, contains('routed_io'));
      expect(pubspec, isNot(contains('react_server_shelf')));
      expect(pubspec, isNot(contains('\n  shelf:')));

      final vscodeSettings = await File(
        p.join(appDir.path, '.vscode', 'settings.json'),
      ).readAsString();
      expect(vscodeSettings, contains('"files.exclude"'));
      expect(vscodeSettings, contains('.generated'));
      expect(vscodeSettings, contains('build'));

      final readme = await File(
        p.join(appDir.path, 'README.md'),
      ).readAsString();
      expect(readme, contains('Routed'));
      expect(readme, isNot(contains('Dockerfile')));
      expect(readme, isNot(contains('docker build')));

      await appDir.delete(recursive: true);
    },
  );

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

  test(
    'init command with --template client scaffolds a client-only project',
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
        File(
          p.join(root.path, 'client_app', 'lib', 'react', 'ssr.dart'),
        ).existsSync(),
        isFalse,
      );
      final pubspec = await File(
        p.join(root.path, 'client_app', 'pubspec.yaml'),
      ).readAsString();
      expect(pubspec, contains('name: client_app'));
      expect(pubspec, isNot(contains('server_testing')));
      expect(pubspec, isNot(contains('server_testing_shelf')));
      expect(pubspec, isNot(contains('react_server')));
      expect(pubspec, isNot(contains('\n  shelf:')));
      final clientSource = await File(
        p.join(root.path, 'client_app', 'web', 'client.dart'),
      ).readAsString();
      expect(
        clientSource,
        contains("import 'package:react_dom/react_dom.dart';"),
      );
      expect(
        clientSource,
        isNot(contains("import 'package:react_web/react_web.dart'")),
      );
      final appSource = await File(
        p.join(root.path, 'client_app', 'lib', 'react', 'app.dart'),
      ).readAsString();
      expect(appSource, contains("import 'package:react_dom/react_dom.dart';"));
      expect(
        appSource,
        isNot(contains("import 'package:react_core/react.dart';")),
      );
      final reactYaml = await File(
        p.join(root.path, 'client_app', 'react.yaml'),
      ).readAsString();
      expect(reactYaml, isNot(contains('ssr:')));
      expect(reactYaml, isNot(contains('server:')));
      final clientReadme = await File(
        p.join(root.path, 'client_app', 'README.md'),
      ).readAsString();
      expect(clientReadme, contains('lib/react/app.dart'));
      expect(clientReadme, isNot(contains('lib/greeting.dart')));
      final vscodeSettings = await File(
        p.join(root.path, 'client_app', '.vscode', 'settings.json'),
      ).readAsString();
      expect(vscodeSettings, contains('"files.exclude"'));
      expect(vscodeSettings, contains('.generated'));
      expect(vscodeSettings, contains('build'));
    },
  );

  test('init command rejects an invalid project name', () async {
    final runner = CommandRunner<void>('react', '')
      ..addCommand(InitCommand(workingDirectory: root));
    await runner.run(['init', 'Bad Name']);

    // The runner reports usage errors without throwing; no project should
    // be created.
    expect(Directory(p.join(root.path, 'Bad Name')).existsSync(), isFalse);
  });

  test(
    'init command with invalid template does not scaffold project',
    () async {
      final runner = CommandRunner<void>('react', '')
        ..addCommand(InitCommand(workingDirectory: root));

      await runner.run(['init', '--template', 'bad-template', 'bad_app']);
      expect(Directory(p.join(root.path, 'bad_app')).existsSync(), isFalse);
    },
  );
}
