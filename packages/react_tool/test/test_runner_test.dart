import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/test_runner.dart';
import 'package:test/test.dart';

void main() {
  test('forwards native test selection and reporter arguments unchanged', () {
    expect(
      dartTestArguments(
        forwarded: [
          'test/counter_test.dart',
          '--name',
          'updates state',
          '--reporter',
          'expanded',
          '--concurrency=1',
        ],
      ),
      [
        'test',
        'test/counter_test.dart',
        '--name',
        'updates state',
        '--reporter',
        'expanded',
        '--concurrency=1',
      ],
    );
    expect(dartTestArguments(), ['test']);
    expect(dartTestArguments(path: 'test', coverageDirectory: '/tmp/run'), [
      'test',
      'test',
      '--coverage',
      '/tmp/run',
    ]);
  });

  for (final linked in [false, if (!Platform.isWindows) true]) {
    test('writes filtered LCOV hit counts (symlink: $linked)', () async {
      final root = await Directory.systemTemp.createTemp('react_lcov_test_');
      addTearDown(() => root.delete(recursive: true));
      final source = File('${root.path}/lib/counter.dart');
      await source.parent.create();
      await source.writeAsString('int counter() => 1;\n');
      final testSource = File('${root.path}/test/counter_test.dart');
      await testSource.parent.create();
      await testSource.writeAsString('void main() {}\n');
      final config = File('${root.path}/.dart_tool/package_config.json');
      await config.parent.create();
      await config.writeAsString(
        jsonEncode({'configVersion': 2, 'packages': []}),
      );
      final input = await Directory('${root.path}/raw').create();
      await File('${input.path}/coverage.json').writeAsString(
        jsonEncode({
          'coverage': [
            {
              'source': source.uri.toString(),
              'hits': [1, 3],
            },
            {
              'source': testSource.uri.toString(),
              'hits': [1, 1],
            },
          ],
        }),
      );
      var project = root;
      if (linked) {
        final alias = Link('${root.path}/project_alias');
        await alias.create(await root.resolveSymbolicLinks());
        project = Directory(alias.path);
      }
      final report = await writeTestLcov(input, project);
      final text = await report.readAsString();
      expect(text, contains('SF:lib/counter.dart'));
      expect(text, contains('DA:1,3'));
      expect(text, isNot(contains('counter_test.dart')));
    });
  }

  test('missing coverage fails rather than advertising a report', () async {
    final root = await Directory.systemTemp.createTemp('react_lcov_empty_');
    addTearDown(() => root.delete(recursive: true));
    await expectLater(writeTestLcov(root, root), throwsStateError);
  });
}
