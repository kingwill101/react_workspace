import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

/// Writes a fixture npm root with a small two-file TypeScript package.
Future<String> writeFixtureNpmRoot(Directory root) async {
  final pkgDir = Directory(p.join(root.path, 'node_modules', 'fake-pkg'))
    ..createSync(recursive: true);
  File(p.join(pkgDir.path, 'package.json')).writeAsStringSync('''
{"name":"fake-pkg","version":"1.0.0","types":"./dist/index.d.ts"}
''');
  File(p.join(pkgDir.path, 'dist', 'index.d.ts')).createSync(recursive: true);
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

      final byName = {for (final prop in decl.props) prop.name: prop};
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

    test('extracts a local TypeScript entry override', () async {
      final local = File(p.join(npmRoot, 'button.d.ts'))
        ..writeAsStringSync('''
export interface ButtonProps {
  label?: string;
  onClick?: (event: MouseEvent) => void;
}
export const Button: React.FC<ButtonProps>;
''');

      final result = await TsBindingExtractor(npmRoot).extract(
        specifier: './button.d.ts',
        names: ['Button'],
        entry: local.path,
      );

      final declaration = result.declarations.single;
      expect(declaration.kind, 'component');
      expect(
        {for (final prop in declaration.props) prop.name},
        {'label', 'onClick'},
      );
    });

    test('infers props from a forwardRef initializer', () async {
      final local = File(p.join(npmRoot, 'forward_ref.tsx'))
        ..writeAsStringSync('''
export interface ButtonProps {
  label?: string;
  disabled: boolean;
}
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (props, ref) => null,
);
''');

      final result = await TsBindingExtractor(npmRoot).extract(
        specifier: './forward_ref.tsx',
        names: ['Button'],
        entry: local.path,
      );

      final declaration = result.declarations.single;
      expect(declaration.kind, 'component');
      expect(
        {for (final prop in declaration.props) prop.name},
        {'label', 'disabled'},
      );

      final discovered = await TsBindingExtractor(npmRoot).extract(
        specifier: './forward_ref.tsx',
        names: const [],
        all: true,
        entry: local.path,
      );
      expect(discovered.declarations.map((declaration) => declaration.name), [
        'Button',
      ]);

      final jsxLocal = File(p.join(npmRoot, 'table.tsx'))
        ..writeAsStringSync('''
export const Table = React.forwardRef<HTMLTableElement, React.HTMLAttributes<HTMLTableElement>>(
  (props, ref) => <table ref={ref} {...props} />,
);
export const TableHeader = React.forwardRef<HTMLTableSectionElement, React.HTMLAttributes<HTMLTableSectionElement>>(
  (props, ref) => <thead ref={ref} {...props} />,
);
''');
      final jsxDiscovered = await TsBindingExtractor(npmRoot).extract(
        specifier: './table.tsx',
        names: const [],
        all: true,
        entry: jsxLocal.path,
      );
      expect(
        jsxDiscovered.declarations.map((declaration) => declaration.name),
        ['Table', 'TableHeader'],
      );

      final reExported = File(p.join(npmRoot, 'textarea.tsx'))
        ..writeAsStringSync('''
const Textarea = React.forwardRef<HTMLTextAreaElement, React.ComponentProps<"textarea">>(
  (props, ref) => <textarea ref={ref} {...props} />,
);
function Field(props: React.ComponentProps<"div">) {
  return <div {...props} />;
}
export { Textarea };
export { Field };
''');
      final reExportedResult = await TsBindingExtractor(npmRoot).extract(
        specifier: './textarea.tsx',
        names: const [],
        all: true,
        entry: reExported.path,
      );
      expect(
        reExportedResult.declarations.map((declaration) => declaration.name),
        ['Textarea', 'Field'],
      );
    });

    test('infers props from an object member component export', () async {
      final local = File(p.join(npmRoot, 'members.d.ts'))
        ..writeAsStringSync('''
export interface RootProps {
  open?: boolean;
}
export const Dialog: {
  Root: React.FC<RootProps>;
};
''');

      final result = await TsBindingExtractor(npmRoot).extract(
        specifier: './members.d.ts',
        names: ['Dialog.Root'],
        entry: local.path,
      );

      final declaration = result.declarations.single;
      expect(declaration.name, 'Dialog.Root');
      expect(declaration.kind, 'component');
      expect(declaration.props.single.name, 'open');
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
              TsIrProp(
                name: 'item',
                required: true,
                type: TsIrType(kind: 'string'),
              ),
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
      expect(code, contains('ReactNode greeting('));
      expect(code, contains('  ReactChildren children = const [],'));
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
      expect(
        code,
        contains(
          'typedef GreetingOnSelectCallback = void Function(String item, num index);',
        ),
      );
      expect(
        code,
        contains(
          'ReactCallback greetingOnSelectCallback(GreetingOnSelectCallback fn)',
        ),
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
      expect(code, contains("if (name != null) 'name': name,"));
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
      expect(code, contains('  ReactChildren children = const [],'));
      expect(code, contains("if (badge != null) 'badge': badge,"));
      // children must NOT also appear in the props map.
      expect(
        code.split("if (children != null) 'children': children,").length,
        1,
      );
    });

    test('keys any non-function children prop as the children parameter', () {
      const decl = TsIrDeclaration(
        name: 'Card',
        kind: 'component',
        props: [
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
      expect(code, contains('  ReactChildren children = const [],'));
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
      expect(
        shim,
        contains("import { Greeting as __reactDartGreeting } from 'fake-pkg';"),
      );
      expect(shim, contains("'fakePkg.Greeting': __reactDartGreeting,"));
      expect(shim, contains('__reactDartRegisterComponent'));
    });

    test('generateShim imports only the referenced exports', () {
      const decl = TsIrDeclaration(
        name: 'useThing',
        kind: 'hook',
        props: [],
        params: [
          TsIrProp(
            name: 'key',
            required: true,
            type: TsIrType(kind: 'string'),
          ),
        ],
        returns: TsIrType(kind: 'string'),
      );
      final shim = generateShim(
        specifier: 'fake-pkg',
        prefix: 'fakePkg',
        declarations: const [greetingDecl, decl],
        commandLine: 'x',
      );
      // No namespace import; both referenced exports are named imports.
      expect(shim, isNot(contains('import * as')));
      expect(
        shim,
        contains(
          "import { Greeting as __reactDartGreeting, "
          "useThing as __reactDartUseThing } from 'fake-pkg';",
        ),
      );
      // Hook bodies call the aliased import, not a namespace member.
      expect(shim, contains('useThing: (a0) => __reactDartUseThing(a0),'));
    });

    test('hooks extension types bind renamed props back to the JS name', () {
      const decl = TsIrDeclaration(
        name: 'useLocation',
        kind: 'hook',
        props: [],
        params: [],
        returns: TsIrType(
          kind: 'object',
          name: 'Location',
          members: [
            TsIrProp(
              name: 'pathname',
              required: true,
              type: TsIrType(kind: 'string'),
            ),
            TsIrProp(
              name: 'key',
              required: true,
              type: TsIrType(kind: 'string'),
            ),
          ],
        ),
      );
      final code = generateHooks(
        specifier: 'fake-pkg',
        declarations: const [decl],
        commandLine: 'react ts bind fake-pkg useLocation --hooks',
      );
      // The Dart-safe name renames `key` → `elementKey`…
      expect(code, contains('external JSString get elementKey;'));
      // …but the extension getter must read the real JS property `key`.
      expect(code, contains("@JS('key') external JSString get elementKey;"));
      expect(code, contains('elementKey: v.elementKey.toDart,'));
      expect(code, isNot(contains('final _LocationJs _value;')));
    });

    test('function object returns emit nullable types and JS decoders', () {
      const decl = TsIrDeclaration(
        name: 'createThing',
        kind: 'function',
        props: [],
        params: [],
        returns: TsIrType(
          kind: 'object',
          members: [
            TsIrProp(
              name: 'id',
              required: true,
              type: TsIrType(kind: 'string'),
            ),
            TsIrProp(
              name: 'state',
              required: true,
              type: TsIrType(kind: 'any'),
            ),
          ],
        ),
      );

      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [decl],
        commandLine: 'react ts bind fake-pkg createThing',
      );

      expect(code, contains('CreateThingReturn? createThing()'));
      expect(code, contains('factory CreateThingReturn.fromJs(JSObject js)'));
      expect(
        code,
        contains('return CreateThingReturn.fromJs(raw as JSObject);'),
      );
      expect(code, contains('required Object? this.state'));
      expect(code, contains('state: rawState,'));
      expect(code, isNot(contains('Object??')));
    });

    test('nested callbacks keep their positional TypeScript shape', () {
      const options = TsIrType(
        kind: 'object',
        members: [
          TsIrProp(
            name: 'state',
            required: false,
            type: TsIrType(kind: 'any'),
          ),
        ],
      );
      const callback = TsIrType(
        kind: 'function',
        params: [
          TsIrProp(
            name: 'state',
            required: true,
            type: TsIrType(kind: 'any'),
          ),
          TsIrProp(name: 'opts', required: true, type: options),
        ],
        returns: TsIrType(kind: 'void'),
      );
      const decl = TsIrDeclaration(
        name: 'createNavigator',
        kind: 'function',
        props: [],
        params: [],
        returns: TsIrType(
          kind: 'object',
          members: [
            TsIrProp(name: 'push', required: true, type: callback),
            TsIrProp(
              name: '__ref',
              required: false,
              type: TsIrType(kind: 'string'),
            ),
          ],
        ),
      );

      final code = generateBindings(
        specifier: 'fake-pkg',
        declarations: const [decl],
        commandLine: 'react ts bind fake-pkg createNavigator',
      );

      expect(code, contains('void Function(Object? state, Object? opts)'));
      expect(code, contains('String? this.privateRef'));
      expect(code, isNot(contains('Object? state, {')));
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
      final workspace = p.normalize(p.join(Directory.current.path, '..', '..'));
      final npmRoot = p.join(workspace, '.dart_tool', 'react', 'js');
      if (!File(
        p.join(npmRoot, 'node_modules', 'react-router-dom', 'package.json'),
      ).existsSync()) {
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
