import 'dart:io';

import 'package:react_tool/src/project_setup.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_setup_test_');
  });
  tearDown(() => root.delete(recursive: true));

  File write(String path, String content) {
    final file = File('${root.path}/$path');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
    return file;
  }

  test(
    'preserves existing diagnostics, plugins, and comments on repeated setup',
    () {
      write('pubspec.yaml', 'name: app\n');
      final options = write(
        'analysis_options.yaml',
        '# Keep my rules\nlinter:\n  rules: [avoid_print]\nplugins:\n  other: ^1.0.0\n',
      );
      enableReactAnalyzer(root);
      final first = options.readAsStringSync();
      enableReactAnalyzer(root);
      expect(options.readAsStringSync(), first);
      expect(first, contains('# Keep my rules'));
      final yaml = loadYaml(first) as YamlMap;
      expect(yaml['plugins']['other'], '^1.0.0');
      expect(yaml['plugins']['react_analyzer']['version'], '^0.1.0');
      expect(yaml['plugins']['react_analyzer']['diagnostics'], {
        'invalid_hook_call': 'error',
        'invalid_react_component': 'error',
      });
      expect(yaml['linter']['rules'], ['avoid_print']);
    },
  );

  test(
    'configures workspace root and preserves member rules while inheriting it',
    () {
      write('pubspec.yaml', 'name: workspace\nworkspace: [apps/app]\n');
      write('apps/app/pubspec.yaml', 'name: app\nresolution: workspace\n');
      final inner = write(
        'apps/app/analysis_options.yaml',
        'include: package:lints/recommended.yaml\nanalyzer:\n  exclude: [build/**]\n',
      );
      final output = enableReactAnalyzer(Directory('${root.path}/apps/app'));
      expect(output.path, '${root.path}/analysis_options.yaml');
      final options = loadYaml(inner.readAsStringSync());
      expect(options['analyzer']['exclude'], ['build/**']);
      expect(options['include'], [
        'package:lints/recommended.yaml',
        '../../analysis_options.yaml',
      ]);
      final first = inner.readAsStringSync();
      enableReactAnalyzer(Directory('${root.path}/apps/app'));
      expect(inner.readAsStringSync(), first);
    },
  );

  test(
    'local analyzer path is absolute and existing configuration is retained',
    () {
      write('pubspec.yaml', 'name: app\n');
      write('packages/react_analyzer/pubspec.yaml', 'name: react_analyzer\n');
      write('packages/react_analysis/pubspec.yaml', 'name: react_analysis\n');
      final file = enableReactAnalyzer(
        root,
        packagesPath: '${root.path}/packages',
      );
      final yaml = loadYaml(file.readAsStringSync()) as YamlMap;
      expect(
        yaml['plugins']['react_analyzer']['path'],
        '${root.path}/packages/react_analyzer',
      );
      expect(
        yaml['plugins']['dependency_overrides']['react_analysis']['path'],
        '${root.path}/packages/react_analysis',
      );
      final before = file.readAsStringSync();
      enableReactAnalyzer(root);
      expect(file.readAsStringSync(), before);
    },
  );

  test('missing local plugin fails before modifying options', () {
    write('pubspec.yaml', 'name: app\n');
    final file = write('analysis_options.yaml', '# original\n{}\n');
    expect(
      () => enableReactAnalyzer(root, packagesPath: '${root.path}/missing'),
      throwsA(isA<ReactToolException>()),
    );
    expect(file.readAsStringSync(), '# original\n{}\n');
  });

  test(
    'explicit local setup switches plugin and engine while preserving diagnostics',
    () {
      write('pubspec.yaml', 'name: app\n');
      write('packages/react_analyzer/pubspec.yaml', 'name: react_analyzer\n');
      write('packages/react_analysis/pubspec.yaml', 'name: react_analysis\n');
      final options = write('analysis_options.yaml', '''
# Preserve my engine source
plugins:
  react_analyzer:
    version: ^0.1.0
    diagnostics: {invalid_hook_call: warning}
  dependency_overrides:
    react_analysis: {path: another_checkout}
''');
      enableReactAnalyzer(root, packagesPath: '${root.path}/packages');
      final plugins = loadYaml(options.readAsStringSync())['plugins'];
      expect(plugins['react_analyzer']['version'], isNull);
      expect(
        plugins['react_analyzer']['path'],
        '${root.path}/packages/react_analyzer',
      );
      expect(
        plugins['react_analyzer']['diagnostics']['invalid_hook_call'],
        'warning',
      );
      expect(
        plugins['dependency_overrides']['react_analysis']['path'],
        '${root.path}/packages/react_analysis',
      );
      final updated = options.readAsStringSync();
      expect(
        () => enableReactAnalyzer(root, packagesPath: '${root.path}/missing'),
        throwsA(isA<ReactToolException>()),
      );
      expect(options.readAsStringSync(), updated);
    },
  );

  for (final invalid in [null, '', '[not, a, map]', 'workspace: [']) {
    test('workspace registration reports invalid root pubspec: $invalid', () {
      if (invalid != null) write('pubspec.yaml', invalid);
      final member = write('app/pubspec.yaml', 'name: app\n');
      expect(
        () => registerWorkspaceMember(member.parent, root),
        throwsA(isA<ReactToolException>()),
      );
      expect(member.readAsStringSync(), 'name: app\n');
    });
  }

  test('workspace plugin-engine conflicts do not register the member', () {
    final rootSpec = write('pubspec.yaml', 'name: root\nworkspace: []\n');
    final memberSpec = write('app/pubspec.yaml', 'name: app\n');
    final options = write('analysis_options.yaml', '''
plugins:
  dependency_overrides:
    react_analysis: {path: original_engine}
''');
    final memberOptions = write('app/analysis_options.yaml', '''
plugins:
  react_analyzer: {path: ../packages/react_analyzer}
  dependency_overrides:
    react_analysis: {path: ../packages/react_analysis}
''');
    final originals = {
      for (final file in [rootSpec, memberSpec, options, memberOptions])
        file: file.readAsStringSync(),
    };
    expect(
      () => registerWorkspaceMember(Directory('${root.path}/app'), root),
      throwsA(isA<ReactToolException>()),
    );
    for (final entry in originals.entries) {
      expect(entry.key.readAsStringSync(), entry.value);
    }
  });

  test('empty analysis options can be initialized', () {
    write('pubspec.yaml', 'name: app\n');
    write('analysis_options.yaml', '');
    final file = enableReactAnalyzer(root);
    expect(
      loadYaml(file.readAsStringSync())['plugins']['react_analyzer']['version'],
      '^0.1.0',
    );
  });

  test(
    'workspace registration relocates overrides and plugins idempotently',
    () {
      write('pubspec.yaml', 'name: root\nworkspace: []\n');
      write('analysis_options.yaml', '''
plugins:
  dependency_overrides:
    other_engine: {path: packages/other_engine}
''');
      write('apps/app/pubspec.yaml', '''
name: app
dependency_overrides:
  react_core: {path: ../../packages/react_core}
''');
      write('apps/app/analysis_options.yaml', '''
# local rules
plugins:
  react_analyzer:
    path: ../../packages/react_analyzer
    diagnostics:
      invalid_hook_call: error
  dependency_overrides:
    react_analysis: {path: ../../packages/react_analysis}
linter:
  rules: [avoid_print]
''');
      final app = Directory('${root.path}/apps/app');
      registerWorkspaceMember(app, root);
      registerWorkspaceMember(app, root);
      final spec = loadYaml(
        File('${root.path}/pubspec.yaml').readAsStringSync(),
      );
      final child = loadYaml(
        File('${app.path}/pubspec.yaml').readAsStringSync(),
      );
      expect(spec['workspace'], ['apps/app']);
      expect(
        spec['dependency_overrides']['react_core']['path'],
        '${root.path}/packages/react_core',
      );
      expect(child['resolution'], 'workspace');
      expect(child['dependency_overrides'], isNull);
      final options = loadYaml(
        File('${root.path}/analysis_options.yaml').readAsStringSync(),
      );
      expect(
        options['plugins']['react_analyzer']['path'],
        '${root.path}/packages/react_analyzer',
      );
      expect(
        options['plugins']['dependency_overrides']['react_analysis']['path'],
        '${root.path}/packages/react_analysis',
      );
      expect(
        options['plugins']['dependency_overrides']['other_engine']['path'],
        'packages/other_engine',
      );
      expect(
        options['plugins']['react_analyzer']['diagnostics']['invalid_hook_call'],
        'error',
      );
      final inner = File(
        '${app.path}/analysis_options.yaml',
      ).readAsStringSync();
      expect(loadYaml(inner)['plugins'], isNull);
      expect(loadYaml(inner)['include'], '../../analysis_options.yaml');
      expect(inner, contains('# local rules'));
    },
  );

  test('workspace registration preserves Git paths and ignores map order', () {
    write('pubspec.yaml', '''
name: root
workspace: []
dependency_overrides:
  shared:
    git: {url: https://example.com/repo.git, ref: pinned, path: packages/shared}
''');
    write('app/pubspec.yaml', '''
name: app
dependency_overrides:
  shared:
    git: {path: packages/shared, ref: pinned, url: https://example.com/repo.git}
  another:
    git: {url: https://example.com/repo.git, path: packages/another}
''');
    registerWorkspaceMember(Directory('${root.path}/app'), root);
    final spec = loadYaml(File('${root.path}/pubspec.yaml').readAsStringSync());
    expect(
      spec['dependency_overrides']['shared']['git']['path'],
      'packages/shared',
    );
    expect(
      spec['dependency_overrides']['another']['git']['path'],
      'packages/another',
    );
  });

  test('workspace conflicts leave root and member files unchanged', () {
    final rootSpec = write(
      'pubspec.yaml',
      'name: root\nworkspace: []\ndependency_overrides:\n  react_core: ^0.1.0\n',
    );
    final appSpec = write(
      'app/pubspec.yaml',
      'name: app\ndependency_overrides:\n  react_core: ^0.2.0\n',
    );
    final beforeRoot = rootSpec.readAsStringSync();
    final beforeApp = appSpec.readAsStringSync();
    expect(
      () => registerWorkspaceMember(Directory('${root.path}/app'), root),
      throwsA(isA<ReactToolException>()),
    );
    expect(rootSpec.readAsStringSync(), beforeRoot);
    expect(appSpec.readAsStringSync(), beforeApp);
  });
}
