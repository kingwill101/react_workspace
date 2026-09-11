import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/doctor.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  test(
    'explicit missing targets are errors and stale generated sources warn',
    () async {
      final project = await Directory.systemTemp.createTemp(
        'react_doctor_stale_',
      );
      addTearDown(() => project.delete(recursive: true));
      File('${project.path}/pubspec.yaml').writeAsStringSync('name: app\n');
      File(
        '${project.path}/react.yaml',
      ).writeAsStringSync('client:\n  entrypoint: web/missing.dart\n');
      final generated = File('${project.path}/lib/.generated/app.dart');
      generated.parent.createSync(recursive: true);
      generated.writeAsStringSync('// generated');
      generated.setLastModifiedSync(DateTime.utc(2020));
      File('${project.path}/lib/app.dart').writeAsStringSync('// newer');
      final findings = await inspectReactProject(
        ReactProjectConfig.load(project),
        probe: (name, args) async => ProcessResult(0, 0, 'version', ''),
      );
      expect(
        findings.singleWhere((f) => f.id == 'entry:client').status,
        'error',
      );
      expect(
        findings.singleWhere((f) => f.id == 'codegen').message,
        contains('newer'),
      );
      expect(findings.singleWhere((f) => f.id == 'codegen').status, 'warning');
    },
  );
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_doctor_test_');
    File('${root.path}/pubspec.yaml').writeAsStringSync('name: app\n');
  });
  tearDown(() => root.delete(recursive: true));
  Future<ProcessResult> available(String executable, List<String> args) async =>
      ProcessResult(0, 0, 'version', '');

  for (final path in ['pubspec.yaml', 'react.yaml', 'analysis_options.yaml']) {
    for (final content in ['value: [', '[not, a, mapping]']) {
      test(
        'doctor reports invalid $path and continues tool checks: $content',
        () async {
          File('${root.path}/$path').writeAsStringSync(content);
          final findings = await inspectReactProject(
            null,
            root: root,
            probe: available,
          );
          expect(
            findings.where(
              (f) => f.id.startsWith('configuration') && f.status == 'error',
            ),
            isNotEmpty,
          );
          expect(findings.singleWhere((f) => f.id == 'tool:node').status, 'ok');
          expect(
            () => jsonEncode(findings.map((f) => f.toJson()).toList()),
            returnsNormally,
          );
        },
      );
    }
  }

  test('empty pubspec produces structured findings', () async {
    File('${root.path}/pubspec.yaml').writeAsStringSync('');
    final findings = await inspectReactProject(
      null,
      root: root,
      probe: available,
    );
    expect(
      findings.any(
        (f) => f.status == 'error' && f.id.startsWith('configuration'),
      ),
      isTrue,
    );
    expect(findings.any((f) => f.id == 'tool:dart'), isTrue);
  });

  test('malformed include is safe for text and JSON output', () async {
    File(
      '${root.path}/analysis_options.yaml',
    ).writeAsStringSync('include: "%"\n');
    final findings = await inspectReactProject(
      null,
      root: root,
      probe: available,
    );

    final text = findings
        .map(
          (finding) =>
              '[${finding.status}] ${finding.message}${finding.fix == null ? '' : '\n  ${finding.fix}'}',
        )
        .join('\n');
    expect(text, contains('React analyzer is not configured'));

    final json = jsonEncode(
      findings.map((finding) => finding.toJson()).toList(),
    );
    expect(jsonDecode(json), isA<List<dynamic>>());
  });

  test('fresh codegen has no redundant fix', () async {
    final generated = File('${root.path}/lib/.generated/app.dart');
    generated.parent.createSync(recursive: true);
    generated.writeAsStringSync('// generated');
    final findings = await inspectReactProject(
      null,
      root: root,
      probe: available,
    );
    final codegen = findings.singleWhere((f) => f.id == 'codegen');
    expect(codegen.status, 'ok');
    expect(codegen.fix, isNull);
  });

  test('missing resolution and tools produce actionable findings', () async {
    final findings = await inspectReactProject(
      ReactProjectConfig.load(root),
      probe: (name, args) async => throw ProcessException(name, args),
    );
    expect(findings.singleWhere((f) => f.id == 'packages').status, 'error');
    expect(
      findings.singleWhere((f) => f.id == 'packages').fix,
      contains('dart pub get'),
    );
    expect(findings.singleWhere((f) => f.id == 'tool:node').status, 'error');
    expect(
      findings.singleWhere((f) => f.id == 'analyzer').fix,
      contains('setup'),
    );
  });

  test('client apps do not fail for absent optional server targets', () async {
    for (final name in [
      'react_core',
      'react_tool',
      'react_codegen',
      'build_runner',
    ]) {
      final spec = File('${root.path}/$name/pubspec.yaml');
      spec.parent.createSync();
      spec.writeAsStringSync('name: $name\n');
    }
    Directory('${root.path}/web').createSync();
    File('${root.path}/web/client.dart').writeAsStringSync('void main() {}');
    File(
      '${root.path}/analysis_options.yaml',
    ).writeAsStringSync('plugins:\n  react_analyzer: ^0.1.0\n');
    Directory('${root.path}/.dart_tool').createSync();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync(
      jsonEncode({
        'configVersion': 2,
        'packages': [
          for (final name in [
            'react_core',
            'react_tool',
            'react_codegen',
            'build_runner',
          ])
            {'name': name, 'rootUri': root.uri.resolve('$name/').toString()},
        ],
      }),
    );
    final findings = await inspectReactProject(
      ReactProjectConfig.load(root),
      probe: available,
    );
    expect(findings.where((f) => f.status == 'error'), isEmpty);
    expect(findings.singleWhere((f) => f.id == 'entry:ssr').status, 'optional');
    expect(
      findings.singleWhere((f) => f.id == 'entry:server').status,
      'optional',
    );
    expect(findings.singleWhere((f) => f.id == 'analyzer').status, 'ok');
    expect(
      findings.singleWhere((f) => f.id == 'codegen').fix,
      contains('generate'),
    );
  });

  test('stale package and analyzer paths are not reported healthy', () async {
    Directory('${root.path}/.dart_tool').createSync();
    File('${root.path}/.dart_tool/package_config.json').writeAsStringSync(
      jsonEncode({
        'packages': [
          {'name': 'react_core', 'rootUri': '../gone/'},
        ],
      }),
    );
    File(
      '${root.path}/analysis_options.yaml',
    ).writeAsStringSync('plugins:\n  react_analyzer: {path: gone_plugin}\n');
    final findings = await inspectReactProject(
      ReactProjectConfig.load(root),
      probe: available,
    );
    expect(
      findings.singleWhere((f) => f.id == 'package:react_core').status,
      'error',
    );
    expect(findings.singleWhere((f) => f.id == 'analyzer').status, 'error');
  });

  test(
    'workspace members inspect root package and analyzer configuration',
    () async {
      File(
        '${root.path}/pubspec.yaml',
      ).writeAsStringSync('name: root\nworkspace: [app]\n');
      final app = Directory('${root.path}/app')..createSync();
      File(
        '${app.path}/pubspec.yaml',
      ).writeAsStringSync('name: app\nresolution: workspace\n');
      File(
        '${root.path}/analysis_options.yaml',
      ).writeAsStringSync('plugins:\n  react_analyzer: ^0.1.0\n');
      final findings = await inspectReactProject(
        ReactProjectConfig.load(app),
        probe: available,
      );
      expect(
        findings.singleWhere((f) => f.id == 'analyzer').message,
        contains('${root.path}/analysis_options.yaml'),
      );
      final member = File('${app.path}/analysis_options.yaml');
      member.writeAsStringSync('analyzer:\n  exclude: [build/**]\n');
      final isolated = await inspectReactProject(
        ReactProjectConfig.load(app),
        probe: available,
      );
      expect(isolated.singleWhere((f) => f.id == 'analyzer').status, 'warning');
      expect(
        isolated.singleWhere((f) => f.id == 'analyzer').message,
        contains('does not inherit'),
      );
      member.writeAsStringSync('include: ../analysis_options.yaml\n');
      final inherited = await inspectReactProject(
        ReactProjectConfig.load(app),
        probe: available,
      );
      expect(inherited.singleWhere((f) => f.id == 'analyzer').status, 'ok');
    },
  );

  test('local plugins need their own local engine override', () async {
    for (final name in ['react_analyzer', 'react_analysis']) {
      final spec = File('${root.path}/$name/pubspec.yaml');
      spec.parent.createSync();
      spec.writeAsStringSync('name: $name\n');
    }
    final options = File('${root.path}/analysis_options.yaml');
    const plugin = 'plugins:\n  react_analyzer: {path: react_analyzer}\n';
    for (final state in ['unconfigured', 'missing', 'configured']) {
      options.writeAsStringSync(
        '$plugin${state == 'unconfigured' ? '' : '''
  dependency_overrides:
    react_analysis: {path: ${state == 'missing' ? 'gone' : 'react_analysis'}}
'''}',
      );
      final findings = await inspectReactProject(
        ReactProjectConfig.load(root),
        probe: available,
      );
      expect(
        findings.singleWhere((f) => f.id == 'analyzer:engine').status,
        {
          'unconfigured': 'warning',
          'missing': 'error',
          'configured': 'ok',
        }[state],
      );
    }
  });
}
