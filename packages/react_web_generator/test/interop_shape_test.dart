import 'package:react_web_generator/src/complete/interop_shape.dart';
import 'package:test/test.dart';

void main() {
  group('InteropShape', () {
    test('PrimitiveShape stores name and constants', () {
      expect(PrimitiveShape.string.name, 'String');
      expect(PrimitiveShape.int_.name, 'int');
      expect(PrimitiveShape.double_.name, 'double');
      expect(PrimitiveShape.bool_.name, 'bool');
      expect(PrimitiveShape.void_.name, 'void');
    });

    test('InterfaceShape stores interfaceName', () {
      const shape = InterfaceShape('Storage');
      expect(shape.interfaceName, 'Storage');
    });

    test('PromiseShape wraps inner', () {
      const inner = PrimitiveShape('String');
      const shape = PromiseShape(inner);
      expect(shape.inner, inner);
    });

    test('SequenceShape wraps element', () {
      const inner = InterfaceShape('Node');
      const shape = SequenceShape(inner);
      expect(shape.element, inner);
    });

    test('FrozenArrayShape wraps element', () {
      const inner = PrimitiveShape('int');
      const shape = FrozenArrayShape(inner);
      expect(shape.element, inner);
    });

    test('DictionaryShape stores dictionaryName', () {
      const shape = DictionaryShape('StorageEventInit');
      expect(shape.dictionaryName, 'StorageEventInit');
    });

    test('CallbackShape stores parameters and result', () {
      const shape = CallbackShape([
        InterfaceShape('MessageEvent'),
      ], PrimitiveShape('void'));
      expect(shape.parameters, hasLength(1));
      expect(shape.result, isA<PrimitiveShape>());
    });

    test('UnionShape stores options', () {
      const shape = UnionShape([
        PrimitiveShape('String'),
        PrimitiveShape('int'),
      ]);
      expect(shape.options, hasLength(2));
    });

    test('NullableShape wraps inner', () {
      const inner = PrimitiveShape('String');
      const shape = NullableShape(inner);
      expect(shape.inner, inner);
    });

    test('RecordShape stores key and value', () {
      const mapShape = RecordShape(
        PrimitiveShape('String'),
        PrimitiveShape('int'),
      );
      expect(mapShape.key, isA<PrimitiveShape>());
      expect(mapShape.value, isA<PrimitiveShape>());
    });

    test('TypedArrayShape stores name', () {
      const shape = TypedArrayShape('Uint8Array');
      expect(shape.name, 'Uint8Array');
    });

    test('all shapes are InteropShape subtypes', () {
      const shapes = [
        PrimitiveShape('String'),
        InterfaceShape('Blob'),
        PromiseShape(PrimitiveShape('String')),
        SequenceShape(PrimitiveShape('int')),
        RecordShape(PrimitiveShape('String'), PrimitiveShape('int')),
        DictionaryShape('RequestInit'),
        CallbackShape([], PrimitiveShape('void')),
        UnionShape([PrimitiveShape('String')]),
        NullableShape(PrimitiveShape('String')),
        TypedArrayShape('Uint8Array'),
        FrozenArrayShape(PrimitiveShape('String')),
      ];
      for (final s in shapes) {
        expect(s, isA<InteropShape>());
      }
    });
  });
}
