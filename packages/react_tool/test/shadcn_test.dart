import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:react_tool/src/shadcn.dart';
import 'package:test/test.dart';

void main() {
  test('normalizes conventional shadcn component names', () {
    expect(shadcnComponentName('button'), 'button');
    expect(shadcnComponentName('button.tsx'), 'button');
    expect(shadcnComponentName('alert-dialog'), 'alert-dialog');
  });

  test('derives named exports from kebab-case names', () {
    expect(shadcnPascalCase('button'), 'Button');
    expect(shadcnPascalCase('alert-dialog'), 'AlertDialog');
  });

  test('rejects unsafe component names', () {
    expect(() => shadcnComponentName('../button'), throwsA(isA<Exception>()));
  });

  test('declares a local component through the CLI adapter', () async {
    final root = await Directory.systemTemp.createTemp('react_tool_shadcn_');
    try {
      await File('${root.path}/pubspec.yaml').writeAsString(
        'name: shadcn_fixture\nenvironment:\n  sdk: ">=3.12.0 <4.0.0"\n',
      );
      await File(
        '${root.path}/react.yaml',
      ).writeAsString('client: web/client.dart\n');
      await Directory('${root.path}/web/components/ui').create(recursive: true);
      await File(
        '${root.path}/web/components/ui/button.tsx',
      ).writeAsString('export const Button = () => null;\n');

      final runner = CommandRunner<void>('react', '')
        ..addCommand(ShadcnCommand(workingDirectory: root));
      await runner.run(['shadcn', 'add', '--no-validate', 'button']);

      final manifest = await File('${root.path}/react.yaml').readAsString();
      expect(manifest, contains("name: 'shadcn.Button'"));
      expect(manifest, contains("module: 'web/components/ui/button.tsx'"));
      expect(manifest, contains("export: 'Button'"));
    } finally {
      await root.delete(recursive: true);
    }
  });
}
