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
}
