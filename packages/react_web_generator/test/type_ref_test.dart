import 'package:react_web_generator/src/model/type_ref.dart';
import 'package:test/test.dart';

void main() {
  group('NamedTypeRef', () {
    test('stores typeId', () {
      const ref = NamedTypeRef(typeId: 'Storage');
      expect(ref.typeId, 'Storage');
      expect(ref.nullable, isFalse);
    });

    test('nullable variant', () {
      const ref = NamedTypeRef(typeId: 'String', nullable: true);
      expect(ref.nullable, isTrue);
    });

    test('with arguments', () {
      const arg = NamedTypeRef(typeId: 'String');
      const ref = NamedTypeRef(typeId: 'Array', arguments: [arg]);
      expect(ref.arguments, hasLength(1));
      expect((ref.arguments.first as NamedTypeRef).typeId, 'String');
    });

    test('equality', () {
      const a = NamedTypeRef(typeId: 'Int', nullable: false);
      const b = NamedTypeRef(typeId: 'Int', nullable: false);
      const c = NamedTypeRef(typeId: 'String', nullable: false);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toJson round-trip', () {
      const ref = NamedTypeRef(
        typeId: 'Promise',
        arguments: [NamedTypeRef(typeId: 'String')],
      );
      final json = ref.toJson();
      expect(json['kind'], 'named');
      final decoded = typeRefFromJson(json);
      expect(decoded, equals(ref));
    });
  });

  group('UnionTypeRef', () {
    test('stores options', () {
      const u = UnionTypeRef(
        options: [
          NamedTypeRef(typeId: 'String'),
          NamedTypeRef(typeId: 'int'),
        ],
      );
      expect(u.options, hasLength(2));
    });

    test('nullable union', () {
      const u = UnionTypeRef(
        nullable: true,
        options: [NamedTypeRef(typeId: 'String')],
      );
      expect(u.nullable, isTrue);
    });

    test('toJson round-trip', () {
      const u = UnionTypeRef(
        options: [
          NamedTypeRef(typeId: 'String'),
          NamedTypeRef(typeId: 'int'),
        ],
      );
      final json = u.toJson();
      final decoded = typeRefFromJson(json) as UnionTypeRef;
      expect(decoded.options, hasLength(2));
    });
  });

  group('TypeParameterRef', () {
    test('stores name', () {
      const r = TypeParameterRef(name: 'T');
      expect(r.name, 'T');
      expect(r.nullable, isFalse);
    });

    test('toJson round-trip', () {
      const r = TypeParameterRef(name: 'T', nullable: true);
      final decoded = typeRefFromJson(r.toJson()) as TypeParameterRef;
      expect(decoded.name, 'T');
      expect(decoded.nullable, isTrue);
    });
  });

  group('TypeRef.listEq', () {
    test('equal lists', () {
      const a = [NamedTypeRef(typeId: 'A'), NamedTypeRef(typeId: 'B')];
      const b = [NamedTypeRef(typeId: 'A'), NamedTypeRef(typeId: 'B')];
      expect(TypeRef.listEq(a, b), isTrue);
    });

    test('different lengths', () {
      const a = [NamedTypeRef(typeId: 'A')];
      const b = [NamedTypeRef(typeId: 'A'), NamedTypeRef(typeId: 'B')];
      expect(TypeRef.listEq(a, b), isFalse);
    });
  });
}
