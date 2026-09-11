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
    await rootConfig.writeAsString(
      jsonEncode({
        'configVersion': 2,
        'packages': [
          {
            'name': 'app',
            'rootUri': child.uri.toString(),
            'packageUri': 'lib/',
          },
        ],
      }),
    );
    await File(
      '${root.path}/pubspec.yaml',
    ).writeAsString('name: root\nworkspace: [app]\n');
    await File(
      '${child.path}/pubspec.yaml',
    ).writeAsString('name: app\nresolution: workspace\n');
    expect((await findProjectPackageConfig(child))?.file.path, rootConfig.path);
  });

  test(
    'unresolved workspace does not borrow an enclosing repository config',
    () async {
      await rootConfig.delete();
      await File(
        '${root.path}/pubspec.yaml',
      ).writeAsString('name: root\nworkspace: [app]\n');
      await File(
        '${child.path}/pubspec.yaml',
      ).writeAsString('name: app\nresolution: workspace\n');
      expect(await findProjectPackageConfig(child), isNull);
    },
  );

  test('malformed pubspec fails closed through the Future API', () async {
    await File('${child.path}/pubspec.yaml').writeAsString('resolution: [');
    final result = findProjectPackageConfig(child);
    expect(await result, isNull);
  });

  test(
    'unregistered workspace fixture cannot inherit an outer checkout',
    () async {
      await rootConfig.delete();
      await File(
        '${child.path}/pubspec.yaml',
      ).writeAsString('name: app\nresolution: workspace\n');
      expect(await findProjectPackageConfig(child), isNull);
    },
  );

  test('standalone projects use their own resolution', () async {
    await File('${child.path}/pubspec.yaml').writeAsString('name: app\n');
    final config = File('${child.path}/.dart_tool/package_config.json');
    await config.parent.create();
    await rootConfig.copy(config.path);
    expect((await findProjectPackageConfig(child))?.file.path, config.path);
  });
}
