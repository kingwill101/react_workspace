import 'package:react_codegen/src/model/model.dart';
import 'package:test/test.dart';

void main() {
  group('ReactTypeRef hierarchy', () {
    test('NamedTypeRef stores symbol and nullable', () {
      const ref = NamedTypeRef(symbol: 'String', nullable: false);
      expect(ref.symbol, 'String');
      expect(ref.nullable, isFalse);
    });

    test('HostTypeRef stores namespace and typeId', () {
      const ref = HostTypeRef(hostNamespace: 'web', typeId: 'HTMLInputElement');
      expect(ref.hostNamespace, 'web');
      expect(ref.typeId, 'HTMLInputElement');
      expect(ref.nullable, isFalse);
    });

    test('RecordTypeRef stores fields', () {
      const ref = RecordTypeRef(
        positional: [
          RecordFieldRef(
            name: '\$0',
            type: NamedTypeRef(symbol: 'String'),
          ),
        ],
        named: [
          RecordFieldRef(
            name: 'count',
            type: NamedTypeRef(symbol: 'int'),
          ),
        ],
      );
      expect(ref.positional, hasLength(1));
      expect(ref.named, hasLength(1));
      expect(ref.named.first.name, 'count');
    });

    test('FunctionTypeRef stores params and result', () {
      const ref = FunctionTypeRef(
        positional: [
          FunctionParameterRef(
            name: 'value',
            type: NamedTypeRef(symbol: 'int'),
          ),
        ],
        result: NamedTypeRef(symbol: 'void'),
        asynchronous: true,
      );
      expect(ref.positional, hasLength(1));
      expect(ref.asynchronous, isTrue);
    });
  });

  group('ReactTypes', () {
    test('primitive constants exist', () {
      expect(ReactTypes.string.symbol, 'String');
      expect(ReactTypes.integer.symbol, 'int');
      expect(ReactTypes.boolean.symbol, 'bool');
      expect(ReactTypes.reactNode.symbol, 'ReactNode');
      expect(ReactTypes.voidType.symbol, 'void');
    });

    test('webHostTypes contains synthetic events', () {
      expect(ReactTypes.webHostTypes.containsKey('ReactMouseEvent'), isTrue);
      expect(ReactTypes.webHostTypes['ReactMouseEvent'], (
        'web',
        'ReactMouseEvent',
      ));
    });

    test('webHostTypes contains Web platform interfaces', () {
      for (final name in [
        'Storage',
        'BroadcastChannel',
        'FileReader',
        'Blob',
        'MessageEvent',
        'Window',
      ]) {
        expect(
          ReactTypes.webHostTypes.containsKey(name),
          isTrue,
          reason: 'Missing $name',
        );
      }
    });

    test(
      'webHostTypes values are (namespace, typeId) tuples with namespace web',
      () {
        for (final entry in ReactTypes.webHostTypes.entries) {
          expect(
            entry.value.$1,
            'web',
            reason: 'Wrong namespace for ${entry.key}',
          );
          expect(entry.value.$2, isNotEmpty);
        }
      },
    );
  });

  group('ReactCallbackModel', () {
    test('stores positional and result', () {
      const model = ReactCallbackModel(
        positional: [
          ReactCallbackParameter(
            name: 'value',
            type: NamedTypeRef(symbol: 'int', nullable: false),
            valueSpec: ReactValueSpecModel(
              kind: ReactValueKind.integer,
              nullable: false,
            ),
          ),
        ],
        resultType: NamedTypeRef(symbol: 'void'),
        result: ReactValueSpecModel(
          kind: ReactValueKind.void_,
          nullable: false,
        ),
        nullable: false,
        asynchronous: false,
      );
      expect(model.positional, hasLength(1));
      expect(model.asynchronous, isFalse);
      expect(model.nullable, isFalse);
    });
  });

  group('ReactComponentModel', () {
    test('stores name, componentId and props', () {
      const model = ReactComponentModel(
        name: 'Foo',
        componentId: 'package:app/lib/foo.dart#Foo',
        returnType: NamedTypeRef(symbol: 'ReactNode'),
        propsRecord: RecordTypeRef(
          named: [
            RecordFieldRef(
              name: 'title',
              type: NamedTypeRef(symbol: 'String'),
            ),
          ],
        ),
        props: [
          ReactPropModel(
            name: 'title',
            type: NamedTypeRef(symbol: 'String', nullable: false),
            required: true,
          ),
        ],
      );
      expect(model.name, 'Foo');
      expect(model.componentId, 'package:app/lib/foo.dart#Foo');
      expect(model.props, hasLength(1));
    });
  });
}
