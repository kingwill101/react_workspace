import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

void main() {
  test(
    'fresh workspace scaffold resolves, analyzes, tests, and builds',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'react_workspace_consumer_',
      );
      addTearDown(() => root.delete(recursive: true));
      final uri = await Isolate.resolvePackageUri(
        Uri.parse('package:react_tool/react_tool.dart'),
      );
      final packages = p.dirname(p.dirname(p.dirname(p.fromUri(uri!))));
      File('${root.path}/pubspec.yaml').writeAsStringSync('''
name: consumer_workspace
publish_to: none
environment:
  sdk: '>=3.13.0 <4.0.0'
workspace: []
''');
      final app = Directory('${root.path}/apps/client');
      await ScaffoldGenerator().generate(
        name: 'consumer_client',
        packagesPath: packages,
        target: app,
        template: 'client',
        workspace: root,
      );
      final get = await Process.run(Platform.resolvedExecutable, [
        'pub',
        'get',
      ], workingDirectory: app.path);
      expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
      final config = File('${root.path}/.dart_tool/package_config.json');
      expect(config.existsSync(), isTrue);
      final entries =
          (jsonDecode(config.readAsStringSync()) as Map)['packages'] as List;
      for (final name in [
        'react_core',
        'react_tool',
        'react_codegen',
        'react_analysis',
        'react_testing',
      ]) {
        final entry = entries.singleWhere((entry) => entry['name'] == name);
        expect(
          p.normalize(config.uri.resolve(entry['rootUri']).toFilePath()),
          p.normalize(p.join(packages, name)),
          reason: '$name must resolve locally',
        );
      }
      expect(
        File('${app.path}/.dart_tool/package_config.json').existsSync(),
        isFalse,
      );
      for (final arguments in <List<String>>[
        ['run', 'react_tool:react', 'generate'],
        ['analyze', '--fatal-infos'],
        ['test', '--reporter', 'expanded'],
        ['run', 'react_tool:react', 'build'],
      ]) {
        print('[workspace consumer] dart ${arguments.join(' ')}');
        final result = await Process.run(
          Platform.resolvedExecutable,
          arguments,
          workingDirectory: app.path,
        );
        expect(
          result.exitCode,
          0,
          reason:
              'dart ${arguments.join(' ')}\n'
              '${result.stdout}\n${result.stderr}',
        );
      }
      expect(File('${app.path}/build/react/browser.js').existsSync(), isTrue);
      final invalid = File('${app.path}/lib/invalid_hooks.dart');
      await invalid.writeAsString('''
import 'package:react_core/react.dart';
@reactComponent
ReactNode Invalid(({bool enabled}) props) {
  if (props.enabled) { useState(0); }
  return const Text('invalid');
}
''');
      final analysis = await Process.run(Platform.resolvedExecutable, [
        'analyze',
        '--format=machine',
      ], workingDirectory: app.path);
      expect(analysis.exitCode, isNot(0));
      expect(
        '${analysis.stdout}\n${analysis.stderr}'.toLowerCase(),
        contains('invalid_hook_call'),
      );
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}
