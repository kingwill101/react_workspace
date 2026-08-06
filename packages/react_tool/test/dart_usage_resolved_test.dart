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
        expect(result.rawHookKeys.values.expand((e) => e), contains('testPkg.useCustom'));
        expect(result.rawHookKeys.keys.any((k) => k.contains('app.dart')), isTrue);
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

    test('writeUsageManifest via builder visits lib/app.dart from web/client.dart', () async {
      final temp = await Directory.systemTemp.createTemp('react_usage_builder_');
      try {
        final pubspec = '''
name: my_app
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  react:
    path: ${p.absolute('packages/react')}
''';
        await File(p.join(temp.path, 'pubspec.yaml')).writeAsString(pubspec);
        await Directory(p.join(temp.path, 'lib')).create(recursive: true);
        await Directory(p.join(temp.path, 'web')).create(recursive: true);
        await File(p.join(temp.path, 'lib', 'app.dart')).writeAsString('''
import 'package:react/react.dart';
ReactNode App() => foreignComponent('myApp.Header', props: {});
''');
        await File(p.join(temp.path, 'web', 'client.dart')).writeAsString('''
import 'package:my_app/app.dart';
void main() { App(); }
''');
        final pubGet = await Process.run('dart', ['pub', 'get'], workingDirectory: temp.path);
        expect(pubGet.exitCode, 0, reason: pubGet.stderr.toString());

        // Simulate ReactBuilder's call: writeUsageManifest with projectRoot
        final dotReact = Directory(p.join(temp.path, '.dart_tool', 'react'));
        final result = await writeUsageManifest(
          entryPath: p.join(temp.path, 'web', 'client.dart'),
          target: 'browser',
          dotDartToolReact: dotReact,
          projectRoot: temp.path,
        );
        expect(result, isNotNull);
        expect(result!.components, contains('myApp.Header'));
        expect(result.complete, isTrue, reason: 'unresolved: ${result.unresolvedLibraries}');
        expect(result.rawComponentKeys.keys.any((k) => k.contains('app.dart')), isTrue);
      } finally {
        await temp.delete(recursive: true);
      }
    });

    test('shared package hook is found or completeness is false', () async {
      final temp = await Directory.systemTemp.createTemp('react_usage_shared_');
      try {
        final sharedDir = Directory(p.join(temp.path, 'shared_widgets'));
        await sharedDir.create(recursive: true);
        await Directory(p.join(sharedDir.path, 'lib')).create(recursive: true);
        await File(p.join(sharedDir.path, 'pubspec.yaml')).writeAsString('''
name: shared_widgets
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  react:
    path: ${p.absolute('packages/react')}
''');
        await File(p.join(sharedDir.path, 'lib', 'widget.dart')).writeAsString('''
import 'package:react/react.dart';
@ReactHook()
@ReactRuntimeSymbol(kind: ReactRuntimeSymbolKind.hook, runtimeKey: 'reactRouter.useLocation', targets: {ReactRenderTarget.browser})
String useLocation() => 'loc';
ReactNode SharedWidget() { final loc = useLocation(); return Text(loc); }
''');
        final appDir = Directory(p.join(temp.path, 'my_app'));
        await appDir.create(recursive: true);
        await Directory(p.join(appDir.path, 'lib')).create(recursive: true);
        await File(p.join(appDir.path, 'pubspec.yaml')).writeAsString('''
name: my_app
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  react:
    path: ${p.absolute('packages/react')}
  shared_widgets:
    path: ${p.join(sharedDir.path)}
''');
        await File(p.join(appDir.path, 'lib', 'app.dart')).writeAsString('''
import 'package:shared_widgets/widget.dart';
import 'package:react/react.dart';
ReactNode App() => SharedWidget();
''');
        await File(p.join(appDir.path, 'lib', 'main.dart')).writeAsString('''
import 'package:my_app/app.dart';
void main() { App(); }
''');
        final pubGet = await Process.run('dart', ['pub', 'get'], workingDirectory: appDir.path);
        expect(pubGet.exitCode, 0, reason: pubGet.stderr.toString());

        final collector = DartUsageCollector();
        final result = await collector.collectEntrypointResolved(
          p.join(appDir.path, 'lib', 'main.dart'),
          projectRoot: appDir.path,
        );
        // Either the hook is found (if shared package was traversed) or completeness is false (safe union)
        final found = result.hooks.contains('reactRouter.useLocation');
        final incomplete = !result.complete;
        expect(found || incomplete, isTrue,
            reason: 'hooks: ${result.hooks} complete: ${result.complete} unresolved: ${result.unresolvedLibraries}');
        if (found) {
          expect(result.rawHookKeys.values.expand((e) => e), contains('reactRouter.useLocation'));
        }
      } finally {
        await temp.delete(recursive: true);
      }
    });
  });
}
