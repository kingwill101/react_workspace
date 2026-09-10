import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/debug_environment.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;
  late File manifest;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_poll_support_');
    await File('${root.path}/pubspec.yaml').writeAsString('name: app\n');
    final generator = await Directory(
      '${root.path}/resolved_generator',
    ).create();
    await Directory('${generator.path}/lib').create();
    manifest = File('${generator.path}/react_tooling.json');
    final config = File('${root.path}/.dart_tool/package_config.json');
    await config.parent.create();
    await config.writeAsString(
      jsonEncode({
        'configVersion': 2,
        'packages': [
          {
            'name': 'react_codegen',
            'rootUri': generator.uri.toString(),
            'packageUri': 'lib/',
          },
        ],
      }),
    );
  });
  tearDown(() => root.delete(recursive: true));

  final unsupported = throwsA(
    isA<ReactToolException>().having(
      (error) => error.toString(),
      'guidance',
      contains('--poll requires'),
    ),
  );
  test('accepts capability from the resolved generator', () async {
    await manifest.writeAsString(
      '{"schemaVersion":1,"features":["polling_watcher"]}',
    );
    await ensurePollingSupport(root);
  });
  test('rejects an older generator without a manifest', () async {
    await expectLater(ensurePollingSupport(root), unsupported);
  });
  test('rejects malformed or incompatible manifests', () async {
    for (final content in [
      '{',
      'null',
      '{"schemaVersion":2,"features":["polling_watcher"]}',
      '{"schemaVersion":1,"features":[]}',
    ]) {
      await manifest.writeAsString(content);
      await expectLater(ensurePollingSupport(root), unsupported);
    }
  });
  test('rejects unresolved projects', () async {
    await File('${root.path}/.dart_tool/package_config.json').delete();
    await expectLater(ensurePollingSupport(root), unsupported);
  });
}
