import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;
import 'package:react_tool/src/component.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  test('adds a component to an existing structured foreign block', () {
    const source = '''
client: web/client.dart
foreign:
  components:
    - name: design.Button
      module: web/button.tsx
      export: Button
  modules:
    - web/legacy.mjs
''';

    final updated = addForeignComponentYaml(
      source,
      name: 'design.Card',
      module: 'web/card.tsx',
      exportName: 'Card',
      props: {'className': 'String?', 'onClick': 'Function?'},
    );

    expect(
      updated.indexOf("name: 'design.Card'"),
      lessThan(updated.indexOf('modules:')),
    );
    expect(updated, contains("className: 'String?'"));
    expect(updated, contains("onClick: 'Function?'"));
  });

  test('adds a new foreign block without disturbing other configuration', () {
    final updated = addForeignComponentYaml(
      'client: web/client.dart\n',
      name: 'design.Button',
      module: 'web/button.tsx',
      exportName: 'Button',
    );

    expect(updated, startsWith('client: web/client.dart\n'));
    expect(updated, contains('foreign:\n  components:'));
    expect(updated, contains("name: 'design.Button'"));
  });

  test('records npm dependencies for bare package modules', () {
    final updated = addForeignComponentYaml(
      'client: web/client.dart\n',
      name: 'library.DialogRoot',
      module: '@radix-ui/react-dialog',
      exportName: 'Dialog.Root',
      dependencies: {'@radix-ui/react-dialog': '^1.0.0'},
    );

    expect(updated, contains("'@radix-ui/react-dialog': '^1.0.0'"));
    expect(updated, contains("export: 'Dialog.Root'"));
  });

  test('rejects the legacy list-shaped foreign block', () {
    expect(
      () => addForeignComponentYaml(
        'foreign:\n  - name: Old\n    module: web/old.js\n',
        name: 'New',
        module: 'web/new.js',
        exportName: 'default',
      ),
      throwsA(isA<ReactToolException>()),
    );
  });

  test('adds a stylesheet to the normal style entrypoint pipeline', () {
    const source = '''
styles:
  entrypoints:
    - web/styles.css
  output: styles.css
''';

    final updated = addStylesheetYaml(source, 'web/components/dialog.css');

    expect(updated, contains('- web/styles.css'));
    expect(updated, contains("- 'web/components/dialog.css'"));
    expect(updated, contains('output: styles.css'));
  });

  test('creates a style entrypoint section when none exists', () {
    final updated = addStylesheetYaml(
      'client: web/client.dart\n',
      'web/components/dialog.css',
    );

    expect(updated, contains('styles:\n  entrypoints:'));
    expect(updated, contains("- 'web/components/dialog.css'"));
  });

  test('infers props from an installed npm component declaration', () async {
    final root = await Directory.systemTemp.createTemp('react_component_');
    try {
      final package = Directory(p.join(root.path, 'node_modules', 'fake-pkg'))
        ..createSync(recursive: true);
      File(p.join(package.path, 'package.json')).writeAsStringSync(
        '{"name":"fake-pkg","version":"1.0.0","types":"./index.d.ts"}',
      );
      File(p.join(package.path, 'index.d.ts')).writeAsStringSync('''
export interface GreetingProps {
  name?: string;
  count: number;
  variant?: "primary" | "secondary";
  priority?: 1 | 2;
  visible?: true | false;
  mixed?: "a" | 1;
  tags?: string[];
  scores?: [number, number];
}
export declare function Greeting(props: GreetingProps): React.ReactElement;
export interface RootProps {
  open?: boolean;
}
export const Dialog: {
  Root: React.FC<RootProps>;
};
''');

      final config = ReactProjectConfig(
        root: root,
        packageName: 'fixture',
        clientEntrypoint: null,
        ssrEntrypoint: null,
        serverEntrypoint: null,
        staticDirectory: 'web',
        outputDirectory: 'build/react',
        styleEntrypoints: const [],
        styleOutput: null,
        foreignComponents: const [],
      );
      final inferred = await inferForeignComponentProps(
        config: config,
        module: 'fake-pkg',
        exportName: 'Greeting',
      );

      expect(inferred, {
        'name': 'String?',
        'count': 'num',
        'variant': 'String?',
        'priority': 'num?',
        'visible': 'bool?',
        'mixed': 'Object?',
        'tags': 'List<String>?',
        'scores': 'List<num>?',
      });

      final nested = await inferForeignComponentProps(
        config: config,
        module: 'fake-pkg',
        exportName: 'Dialog.Root',
      );
      expect(nested, {'open': 'bool?'});

      File(p.join(root.path, 'web', 'table.tsx'))
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import * as React from 'react';
export const Table = React.forwardRef<HTMLTableElement, React.HTMLAttributes<HTMLTableElement>>((props, ref) => null);
export const TableHeader = React.forwardRef<HTMLTableSectionElement, React.HTMLAttributes<HTMLTableSectionElement>>((props, ref) => null);
export const TableCell = React.forwardRef<HTMLTableCellElement, React.TdHTMLAttributes<HTMLTableCellElement>>((props, ref) => null);
''');
      final exports = await enumerateForeignComponentExports(
        config: config,
        module: 'web/table.tsx',
      );
      expect(exports.declarations.map((declaration) => declaration.name), [
        'Table',
        'TableHeader',
        'TableCell',
      ]);
    } finally {
      await root.delete(recursive: true);
    }
  });

  test('derives npm runtime names from exports and package names', () {
    expect(defaultNpmComponentName('@radix-ui/react-dialog'), 'ReactDialog');
    expect(defaultNpmComponentName('react-router-dom'), 'ReactRouterDom');
  });

  test('restores the manifest when generation fails', () async {
    final root = await Directory.systemTemp.createTemp('react_component_');
    try {
      final file = File(p.join(root.path, 'react.yaml'))
        ..writeAsStringSync('client: web/client.dart\n');
      const original = 'client: web/client.dart\n';
      const updated = '$original\nforeign:\n  components:\n';

      await expectLater(
        runForeignComponentManifestTransaction(
          file: file,
          original: original,
          updated: updated,
          action: () async => throw StateError('validation failed'),
        ),
        throwsStateError,
      );
      expect(file.readAsStringSync(), original);
    } finally {
      await root.delete(recursive: true);
    }
  });

  test(
    'component command supports npm shorthand without changing cwd',
    () async {
      final root = await Directory.systemTemp.createTemp('react_component_');
      try {
        File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync(
          'name: fixture\nenvironment:\n  sdk: ">=3.12.0 <4.0.0"\n',
        );
        File(
          p.join(root.path, 'react.yaml'),
        ).writeAsStringSync('client: web/client.dart\n');

        final runner = CommandRunner<void>('react', '')
          ..addCommand(ComponentCommand(workingDirectory: root));
        await runner.run([
          'component',
          'add',
          '@radix-ui/react-dialog',
          '--export',
          'Dialog.Root',
          '--no-validate',
        ]);

        final manifest = File(
          p.join(root.path, 'react.yaml'),
        ).readAsStringSync();
        expect(manifest, contains("name: 'Dialog.Root'"));
        expect(manifest, contains("module: '@radix-ui/react-dialog'"));
      } finally {
        await root.delete(recursive: true);
      }
    },
  );

  test('component command infers props from an npm module', () async {
    final root = await Directory.systemTemp.createTemp('react_component_');
    try {
      File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync(
        'name: fixture\nenvironment:\n  sdk: ">=3.12.0 <4.0.0"\n',
      );
      File(
        p.join(root.path, 'react.yaml'),
      ).writeAsStringSync('client: web/client.dart\n');
      final package = Directory(p.join(root.path, 'node_modules', 'fake-pkg'))
        ..createSync(recursive: true);
      File(p.join(package.path, 'package.json')).writeAsStringSync(
        '{"name":"fake-pkg","version":"1.0.0","types":"./index.d.ts"}',
      );
      File(p.join(package.path, 'index.d.ts')).writeAsStringSync('''
export interface GreetingProps {
  name?: string;
  count: number;
}
export declare function Greeting(props: GreetingProps): React.ReactElement;
''');

      final runner = CommandRunner<void>('react', '')
        ..addCommand(ComponentCommand(workingDirectory: root));
      await runner.run([
        'component',
        'add',
        'fake.Greeting',
        'fake-pkg',
        '--export',
        'Greeting',
        '--infer',
        '--no-validate',
      ]);

      final manifest = File(p.join(root.path, 'react.yaml')).readAsStringSync();
      expect(manifest, contains("name: 'fake.Greeting'"));
      expect(manifest, contains("name: 'String?'"));
      expect(manifest, contains("count: 'num'"));
      expect(
        File(
          p.join(root.path, 'lib', '.generated', 'foreign_components.g.dart'),
        ).readAsStringSync(),
        contains('fakeGreeting'),
      );
    } finally {
      await root.delete(recursive: true);
    }
  });
}
