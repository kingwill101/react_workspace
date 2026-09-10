import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:react_tool/src/project_setup.dart';
import 'package:test/test.dart';

void main() {
  for (final workspace in [false, true]) {
    test(
      'configured local analyzer reports invalid hooks (workspace: $workspace)',
      () async {
        final root = await Directory.systemTemp.createTemp(
          'react_analyzer_consumer_',
        );
        addTearDown(() => root.delete(recursive: true));
        final toolUri = await Isolate.resolvePackageUri(
          Uri.parse('package:react_tool/react_tool.dart'),
        );
        final packages = p.dirname(p.dirname(p.dirname(p.fromUri(toolUri!))));
        expect(
          File(p.join(packages, 'react_core/pubspec.yaml')).existsSync(),
          isTrue,
        );
        final project = workspace ? Directory('${root.path}/app') : root;
        await project.create(recursive: true);
        if (workspace) {
          await File('${root.path}/pubspec.yaml').writeAsString('''
name: analyzer_workspace
environment:
  sdk: '>=3.13.0 <4.0.0'
workspace: [app]
''');
          await File('${project.path}/analysis_options.yaml').writeAsString(
            'analyzer:\n  errors:\n    non_constant_identifier_names: ignore\n',
          );
        }
        await File('${project.path}/pubspec.yaml').writeAsString('''
name: analyzer_consumer
${workspace ? 'resolution: workspace' : ''}
environment:
  sdk: '>=3.13.0 <4.0.0'
dependencies:
  react_core:
    path: ${p.join(packages, 'react_core')}
  react_dom:
    path: ${p.join(packages, 'react_dom')}
dependency_overrides:
  react_core:
    path: ${p.join(packages, 'react_core')}
''');
        enableReactAnalyzer(project, packagesPath: packages);
        await Directory('${project.path}/lib').create();
        await File('${project.path}/lib/valid.dart').writeAsString(
          "import 'package:react_dom/react_dom.dart';\n"
          "const value = Text('portable');\n",
        );
        final get = await Process.run(Platform.resolvedExecutable, [
          'pub',
          'get',
        ], workingDirectory: project.path);
        expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
        final valid = await Process.run(Platform.resolvedExecutable, [
          'analyze',
          '--fatal-infos',
        ], workingDirectory: project.path);
        expect(valid.exitCode, 0, reason: '${valid.stdout}\n${valid.stderr}');
        await File('${project.path}/lib/counter.dart').writeAsString('''
import 'package:react_core/react.dart';

@reactComponent
ReactNode Counter(({bool enabled}) props) {
  if (props.enabled) {
    useState(0);
  }
  return const Text('counter');
}
''');
        final analysis = await Process.run(Platform.resolvedExecutable, [
          'analyze',
          '--format=machine',
        ], workingDirectory: project.path);
        final output = '${analysis.stdout}\n${analysis.stderr}';
        expect(analysis.exitCode, isNot(0), reason: output);
        expect(output, isNot(contains('included_file_warning')));
        expect(
          output.toLowerCase(),
          contains('invalid_hook_call'),
          reason: output,
        );
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  }
}
