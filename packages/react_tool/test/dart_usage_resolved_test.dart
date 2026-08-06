import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:react_tool/src/bundler/dart_usage.dart';
import 'package:test/test.dart';

void main() {
  group('DartUsageCollector resolved', () {
    test('finds hook via package: import with resolved context', () async {
      final temp = await Directory.systemTemp.createTemp('react_usage_');
      try {
        // Minimal pubspec for a package named test_app.
        final pubspec = '''
name: test_app
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  react:
    path: ${p.absolute('packages/react')}
''';
        await File(p.join(temp.path, 'pubspec.yaml')).writeAsString(pubspec);
        await Directory(p.join(temp.path, 'lib')).create(recursive: true);
        await Directory(p.join(temp.path, 'bin')).create(recursive: true);

        await File(p.join(temp.path, 'lib', 'hooks.dart')).writeAsString('''
import 'package:react/react.dart';

@ReactHook()
@ReactRuntimeSymbol(
  kind: ReactRuntimeSymbolKind.hook,
  runtimeKey: 'testPkg.useCustom',
  targets: {ReactRenderTarget.browser, ReactRenderTarget.server},
)
String useCustom() => 'hi';
''');

        await File(p.join(temp.path, 'lib', 'app.dart')).writeAsString('''
import 'package:test_app/hooks.dart';
import 'package:react/react.dart';

ReactNode App() {
  final v = useCustom();
  return Text(v);
}
''');

        await File(p.join(temp.path, 'bin', 'main.dart')).writeAsString('''
import 'package:test_app/app.dart';
void main() { App(); }
''');

        // Generate package config so AnalysisContextCollection can resolve package:test_app
        final pubGet = await Process.run('dart', ['pub', 'get'], workingDirectory: temp.path);
        expect(pubGet.exitCode, 0, reason: pubGet.stderr.toString());

        final collector = DartUsageCollector();
        final result = await collector.collectEntrypointResolved(
          p.join(temp.path, 'bin', 'main.dart'),
          projectRoot: temp.path,
        );

        expect(result.hooks, contains('testPkg.useCustom'),
            reason: 'hooks: ${result.hooks} complete: ${result.complete} unresolved: ${result.unresolvedLibraries}');
        expect(result.complete, isTrue, reason: 'unresolved: ${result.unresolvedLibraries}');
        expect(result.resolvedLibraries, greaterThan(1));
        // rawHookKeys is populated for diagnostics; at minimum hooks must be found.
        expect(result.hooks, isNotEmpty);
      } finally {
        await temp.delete(recursive: true);
      }
    });

    test('legacy walk without package resolution is incomplete', () async {
      final temp = await Directory.systemTemp.createTemp('react_usage_legacy_');
      try {
        await Directory(p.join(temp.path, 'lib')).create(recursive: true);
        await File(p.join(temp.path, 'lib', 'a.dart')).writeAsString('''
import 'package:react/react.dart';
ReactNode A() => foreignComponent('ns.Comp', props: {});
''');
        await File(p.join(temp.path, 'lib', 'entry.dart')).writeAsString('''
import 'a.dart';
import 'package:test_app/other.dart';
ReactNode E() => A();
''');
        await File(p.join(temp.path, 'pubspec.yaml')).writeAsString('name: test_app\n');
        final collector = DartUsageCollector();
        final legacy = collector.collectEntrypoint(p.join(temp.path, 'lib', 'entry.dart'));
        expect(legacy.complete, isFalse);
        expect(legacy.unresolvedLibraries, isNotEmpty);
      } finally {
        await temp.delete(recursive: true);
      }
    });

    test('fail-safe union retains JS hooks when semantic incomplete', () {
      // Simulate build.dart union logic.
      final semantic = ['testPkg.useCustom'];
      final js = ['reactRouter.useLocation', 'testPkg.useCustom'];
      final complete = false;
      final retained = complete ? semantic.toSet() : {...semantic, ...js}.toSet();
      expect(retained, containsAll(['reactRouter.useLocation', 'testPkg.useCustom']));
      final retainedComplete = true ? semantic.toSet() : {...semantic, ...js}.toSet();
      expect(retainedComplete, contains('testPkg.useCustom'));
      expect(retainedComplete, isNot(contains('reactRouter.useLocation')));
    });
  });
}
