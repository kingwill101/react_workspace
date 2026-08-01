import 'dart:io';

import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_tool_build_test_');
    await File('${root.path}/pubspec.yaml').writeAsString('name: sample\n');
    await File('${root.path}/react.yaml').writeAsString('''
styles:
  - web/theme.scss
  - web/card.module.scss
foreign:
  - name: Card
    module: web/card.js
    props:
      label: String
      disabled: bool?
''');
    await Directory('${root.path}/web').create(recursive: true);
    await File(
      '${root.path}/web/index.html',
    ).writeAsString('<!doctype html><html><head></head><body></body></html>');
    await File('${root.path}/web/theme.scss').writeAsString(r'''
$accent: #336699;
.card {
  color: $accent;
  .title { font-weight: bold; }
}
''');
    await File('${root.path}/web/card.module.scss').writeAsString(r'''
.card { padding: 1rem; }
''');
    await File(
      '${root.path}/web/card.js',
    ).writeAsString('export default function Card() {}\n');
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  test('compiles configured Sass into the React output', () async {
    final config = ReactProjectConfig.load(root);
    final builder = ReactBuilder(config: config, release: false, log: (_) {});

    await builder.build();

    final index = await File(
      '${root.path}/build/react/index.html',
    ).readAsString();
    expect(index, contains('href="theme.css"'));
    expect(index, contains('href="card.module.css"'));

    final css = await File('${root.path}/build/react/theme.css').readAsString();
    expect(css, contains('.card'));
    expect(css, contains('color: #336699;'));
    expect(css, contains('.card .title'));
    expect(File('${root.path}/build/react/theme.scss').existsSync(), isFalse);

    final moduleCss = await File(
      '${root.path}/build/react/card.module.css',
    ).readAsString();
    expect(moduleCss, matches(RegExp(r'\.card__[0-9a-f]{6}')));
    final bindings = await File(
      '${root.path}/web/card.module.dart',
    ).readAsString();
    expect(bindings, contains('final class CardModuleStyles'));
    expect(
      bindings,
      matches(RegExp(r"static const card = 'card__[0-9a-f]{6}'")),
    );
    expect(
      File('${root.path}/build/react/card.module.scss').existsSync(),
      isFalse,
    );
    final foreignLoader = await File(
      '${root.path}/build/react/foreign_components.mjs',
    ).readAsString();
    expect(
      foreignLoader,
      contains("import _reactForeignComponent0 from './card.js';"),
    );
    expect(foreignLoader, contains("__reactDartRegisterComponent('Card'"));
    final foreignBindings = await File(
      '${root.path}/lib/foreign_components.g.dart',
    ).readAsString();
    expect(foreignBindings, contains('required String label'));
    expect(foreignBindings, contains('bool? disabled'));
    expect(foreignBindings, contains("'Card'"));
  });
}
