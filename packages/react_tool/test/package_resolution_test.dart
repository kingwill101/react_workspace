import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/package_resolution.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;
  late Directory child;
  late File rootConfig;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_resolution_test_');
    child = await Directory('${root.path}/app').create();
    rootConfig = File('${root.path}/.dart_tool/package_config.json');
    await rootConfig.parent.create();
    await rootConfig.writeAsString(
      jsonEncode({'configVersion': 2, 'packages': []}),
    );
  });
  tearDown(() => root.delete(recursive: true));

  test(
    'unresolved standalone projects do not inherit parent resolution',
    () async {
      await File('${child.path}/pubspec.yaml').writeAsString('name: app\n');
      expect(await findProjectPackageConfig(child), isNull);
    },
  );

  test('declared workspace members use parent resolution', () async {
    await File(
      '${child.path}/pubspec.yaml',
    ).writeAsString('name: app\nresolution: workspace\n');
    expect((await findProjectPackageConfig(child))?.file.path, rootConfig.path);
  });

  test('standalone projects use their own resolution', () async {
    await File('${child.path}/pubspec.yaml').writeAsString('name: app\n');
    final config = File('${child.path}/.dart_tool/package_config.json');
    await config.parent.create();
    await rootConfig.copy(config.path);
    expect((await findProjectPackageConfig(child))?.file.path, config.path);
  });
}
