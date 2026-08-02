import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

/// Writes a fixture npm root with a small two-file TypeScript package.
Future<String> writeFixtureNpmRoot(Directory root) async {
  final pkgDir = Directory(
    p.join(root.path, 'node_modules', 'fake-pkg'),
  )..createSync(recursive: true);
  File(p.join(pkgDir.path, 'package.json')).writeAsStringSync('''
{"name":"fake-pkg","version":"1.0.0","types":"./dist/index.d.ts"}
''');
  File(
    p.join(pkgDir.path, 'dist', 'index.d.ts'),
  ).createSync(recursive: true);
  File(p.join(pkgDir.path, 'dist', 'index.d.ts')).writeAsStringSync('''
import type { Shared } from "./shared";
export declare function Greeting(props: GreetingProps): React.ReactElement;
export interface GreetingProps {
  name?: string;
  count: number;
  items?: string[];
  meta?: Partial<Meta>;
  variant?: "primary" | "secondary";
  onSelect?: (item: string, index: number) => void;
  children?: React.ReactNode;
  action?: Shared;
  badge?: React.ReactElement;
}
export type GreetingPropsList = GreetingProps[];
''');
  File(p.join(pkgDir.path, 'dist', 'shared.d.ts')).writeAsStringSync('''
export interface Shared { id: string; }
''');
  return root.path;
}

void main() {
  group('TsBindingExtractor (native oxc)', () {
    late String npmRoot;

    setUpAll(() async {
      final root = await Directory.systemTemp.createTemp('react_ts_');
      npmRoot = await writeFixtureNpmRoot(root);
    });

    test('extracts component props with cross-file types', () async {
      final extractor = TsBindingExtractor(npmRoot);
      final result = await extractor.extract(
        specifier: 'fake-pkg',
        names: ['Greeting'],
      );
      expect(result.files, greaterThanOrEqualTo(2));
      final decl = result.declarations.single;
      expect(decl.name, 'Greeting');
      expect(decl.kind, 'component');

      final byName = {
        for (final prop in decl.props) prop.name: prop,
      };
      expect(byName['name']!.type.kind, 'string');
      expect(byName['name']!.required, isFalse);
      expect(byName['count']!.type.kind, 'number');
      expect(byName['count']!.required, isTrue);
      expect(byName['items']!.type.kind, 'array');
      expect(byName['items']!.type.element!.kind, 'string');
      // Partial<Meta> → all-optional object members, name preserved.
      final meta = byName['meta']!.type;
      expect(meta.kind, 'object');
      expect(meta.name, 'Meta');
      expect(meta.members!.single.required, isFalse);
      // literal union
      final variant = byName['variant']!.type;
      expect(variant.kind, 'literal');
      expect(variant.literals, ['"primary"', '"secondary"']);
      // callback
      final onSelect = byName['onSelect']!.type;
      expect(onSelect.kind, 'function');
      expect(onSelect.params!.length, 2);
      expect(onSelect.params![0].type.kind, 'string');
      expect(onSelect.returns!.kind, 'void');
      // children
      expect(byName['children']!.type.kind, 'reactNode');
      // cross-file interface resolution carries the declared name.
      final action = byName['action']!.type;
      expect(action.kind, 'object');
      expect(action.name, 'Shared');
      expect(action.members!.single.name, 'id');
    });

    test('reports missing declarations as errors', () async {
      final extractor = TsBindingExtractor(npmRoot);
      await expectLater(
        extractor.extract(specifier: 'fake-pkg', names: ['Nope']),
        throwsA(
          isA<TsBindingException>().having(
            (e) => e.message,
            'message',
            contains('Nope'),
          ),
        ),
      );
    });
  });

  group('generateBindings', () {
    const greetingDecl = TsIrDeclaration(
      name: 'Greeting',
      kind: 'component',
      props: [
        TsIrProp(
          name: 'name',
          required: false,
          type: TsIrType(kind: 'string'),
        ),
        TsIrProp(
          name: 'count',
          required: true,
          type: TsIrType(kind: 'number'),
        ),
        TsIrProp(
          name: 'items',
          required: false,
          type: TsIrType(
            kind: 'array',
            element: TsIrType(kind: 'string'),
          ),
        ),
        TsIrProp(
          name: 'meta',
          required: false,
          type: TsIrType(
            kind: 'object',
            members: [
              TsIrProp(
                name: 'theme',
                required: false,
                type: TsIrType(kind: 'boolean'),
              ),
            ],
          ),
        ),
        TsIrProp(
          name: 'variant',
          required: false,
          type: TsIrType(
            kind: 'literal',
            literals: ['"primary"', '"secondary"'],
          ),
        ),
        TsIrProp(
          name: 'onSelect',
          required: false,
          type: TsIrType(
            kind: 'function',
            params: [
              TsIrProp(name: 'item', required: true, type: TsIrType(kind: 'string')),
              TsIrProp(
                name: 'index',
                required: true,
                type: TsIrType(kind: 'number'),
              ),
            ],
            returns: TsIrType(kind: 'void'),
          ),
        ),
        TsIrProp(
          name: 'children',
          required: false,
          type: TsIrType(kind: 'reactNode'),
        ),
        TsIrProp(
          name: 'action',
          required: false,
          type: TsIrType(
            kind: 'object',
            members: [
              TsIrProp(
                name: 'id',
                required: true,
                type: TsIrType(kind: 'string'),
              ),
            ],
          ),
        ),
        TsIrProp(
          name: 'badge',
          required: false,
          type: TsIrType(kind: 'reactNode'),
        ),
      ],
    );

    test('emits a typed foreign-component helper', () {
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [greetingDecl],
        commandLine: 'react ts bind fake-pkg Greeting',
      );
      // Typed props (classes, enum, callback typedef).
      expect(code, contains('ReactNode fakePkgGreeting('));
      expect(code, contains('  List<ReactNode> children = const [],'));
      expect(code, contains('String? name,'));
      expect(code, contains('required num count,'));
      expect(code, contains('List<String>? items,'));
      expect(code, contains('GreetingMeta? meta,'));
      expect(code, contains('GreetingVariant? variant,'));
      expect(code, contains('GreetingOnSelectCallback? onSelect,'));
      expect(code, contains('GreetingAction? action,'));
      expect(code, contains('ReactNode? badge,'));
      // Props map encodes nested types as JSON-safe values.
      expect(code, contains("if (meta != null) 'meta': meta.toJson(),"));
      expect(code, contains("if (variant != null) 'variant': variant.value,"));
      expect(code, contains("if (action != null) 'action': action.toJson(),"));
      expect(code, contains("'count': count,"));
      // Emitted type declarations.
      expect(code, contains('class GreetingMeta {'));
      expect(code, contains('class GreetingAction {'));
      expect(code, contains('enum GreetingVariant {'));
      expect(code, contains('typedef GreetingOnSelectCallback = void Function(String item, num index);'));
      expect(
        code,
        contains('ReactCallback greetingOnSelectCallback(GreetingOnSelectCallback fn)'),
      );
    });

    test('emits a typed class for interface declarations', () {
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [
          TsIrDeclaration(
            name: 'GreetingProps',
            kind: 'interface',
            props: [
              TsIrProp(
                name: 'name',
                required: false,
                type: TsIrType(kind: 'string'),
              ),
            ],
          ),
        ],
        commandLine: 'react ts bind fake-pkg GreetingProps',
      );
      expect(code, contains('class GreetingProps {'));
      expect(code, contains('String? this.name,'));
      expect(code, contains('final String? name;'));
      expect(
        code,
        contains("if (name != null) 'name': name,"),
      );
    });

    test('emits a typedef for primitive aliases', () {
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [
          TsIrDeclaration(
            name: 'GreetingId',
            kind: 'alias',
            props: [
              TsIrProp(
                name: 'value',
                required: true,
                type: TsIrType(kind: 'string'),
              ),
            ],
          ),
        ],
        commandLine: 'react ts bind fake-pkg GreetingId',
      );
      expect(code, contains('typedef GreetingId = String;'));
    });

    test('emits keyed children only for reactNode children props', () {
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [greetingDecl],
        commandLine: 'x',
      );
      expect(code, contains('  List<ReactNode> children = const [],'));
      expect(code, contains("if (badge != null) 'badge': badge,"));
      // children must NOT also appear in the props map.
      expect(
        code.split("if (children != null) 'children': children,").length,
        1,
      );
    });

    test('keys any non-function children prop as the children parameter', () {
      final decl = TsIrDeclaration(
        name: 'Card',
        kind: 'component',
        props: const [
          TsIrProp(
            name: 'children',
            required: false,
            type: TsIrType(kind: 'any'),
          ),
        ],
      );
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: [decl],
        commandLine: 'x',
      );
      expect(code, contains('  List<ReactNode> children = const [],'));
      expect(code, contains('  children: children,'));
      expect(
        code.split("if (children != null) 'children': children,").length,
        1,
      );
    });

    test('generateShim registers components under the prefix', () {
      final shim = generateShim(
        specifier: 'fake-pkg',
        prefix: 'fakePkg',
        declarations: const [greetingDecl],
        commandLine: 'react ts bind fake-pkg Greeting --shim',
      );
      expect(shim, contains("import * as FakePkg from 'fake-pkg';"));
      expect(shim, contains("'fakePkg.Greeting': FakePkg.Greeting,"));
      expect(shim, contains('__reactDartRegisterComponent'));
    });

    test('typePrefix namespaces generated type names', () {
      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [greetingDecl],
        commandLine: 'x',
        typePrefix: 'Server',
      );
      expect(code, contains('GreetingMeta? meta,'));
      expect(code, contains('class ServerGreetingMeta {'));
      expect(code, contains('GreetingVariant? variant,'));
      expect(code, contains('enum ServerGreetingVariant {'));
      // The unprefixed names must not be emitted.
      expect(code, contains('GreetingMeta'));
    });
  });

  group('live react-router-dom extraction', () {
    test('extracts MemoryRouter from the managed env', () async {
      final workspace = p.normalize(
        p.join(Directory.current.path, '..', '..'),
      );
      final npmRoot = p.join(workspace, '.dart_tool', 'react', 'js');
      if (!File(p.join(npmRoot, 'node_modules', 'react-router-dom', 'package.json'))
          .existsSync()) {
        markTestSkipped('managed env react-router-dom not installed');
        return;
      }
      final extractor = TsBindingExtractor(npmRoot);
      final result = await extractor.extract(
        specifier: 'react-router-dom',
        names: ['MemoryRouter', 'Route'],
      );
      final names = result.declarations.map((d) => d.name).toList();
      expect(names, ['MemoryRouter', 'Route']);
      final memory = result.declarations.first;
      final propNames = memory.props.map((p) => p.name).toSet();
      expect(
        propNames,
        containsAll(['basename', 'children', 'initialEntries', 'initialIndex']),
      );
    });
  });
}
