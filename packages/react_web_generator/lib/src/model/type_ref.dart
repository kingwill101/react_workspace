sealed class TypeRef {
  const TypeRef();
  bool get nullable;
  Map<String, Object?> toJson();

  static bool listEq(List<TypeRef> a, List<TypeRef> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

final class NamedTypeRef extends TypeRef {
  final String typeId;
  @override
  final bool nullable;
  final List<TypeRef> arguments;

  const NamedTypeRef({
    required this.typeId,
    this.nullable = false,
    this.arguments = const [],
  });

  NamedTypeRef copyWith({bool? nullable, List<TypeRef>? arguments}) =>
      NamedTypeRef(
        typeId: typeId,
        nullable: nullable ?? this.nullable,
        arguments: arguments ?? this.arguments,
      );

  @override
  Map<String, Object?> toJson() => {
    'kind': 'named',
    'typeId': typeId,
    'nullable': nullable,
    'arguments': arguments.map((a) => a.toJson()).toList(),
  };

  @override
  String toString() =>
      'NamedTypeRef($typeId${nullable ? '?' : ''}${arguments.isEmpty ? '' : '<${arguments.join(', ')}>'})';

  @override
  bool operator ==(Object other) =>
      other is NamedTypeRef &&
      other.typeId == typeId &&
      other.nullable == nullable &&
      TypeRef.listEq(other.arguments, arguments);

  @override
  int get hashCode => Object.hash(typeId, nullable, Object.hashAll(arguments));
}

final class TypeParameterRef extends TypeRef {
  final String name;
  @override
  final bool nullable;

  const TypeParameterRef({required this.name, this.nullable = false});

  @override
  Map<String, Object?> toJson() => {
    'kind': 'typeParameter',
    'name': name,
    'nullable': nullable,
  };

  @override
  String toString() => 'TypeParameterRef($name${nullable ? '?' : ''})';

  @override
  bool operator ==(Object other) =>
      other is TypeParameterRef &&
      other.name == name &&
      other.nullable == nullable;

  @override
  int get hashCode => Object.hash(name, nullable);
}

final class UnionTypeRef extends TypeRef {
  @override
  final bool nullable;
  final List<TypeRef> options;

  const UnionTypeRef({this.nullable = false, required this.options});

  @override
  Map<String, Object?> toJson() => {
    'kind': 'union',
    'nullable': nullable,
    'options': options.map((o) => o.toJson()).toList(),
  };

  @override
  String toString() => 'UnionTypeRef(${options.join(' | ')})';

  @override
  bool operator ==(Object other) =>
      other is UnionTypeRef &&
      other.nullable == nullable &&
      TypeRef.listEq(other.options, options);

  @override
  int get hashCode => Object.hash(nullable, Object.hashAll(options));
}

TypeRef typeRefFromJson(Map<String, dynamic> json) {
  final kind = json['kind'] as String;
  return switch (kind) {
    'named' => NamedTypeRef(
      typeId: json['typeId'] as String,
      nullable: json['nullable'] as bool? ?? false,
      arguments:
          (json['arguments'] as List<dynamic>?)
              ?.map((a) => typeRefFromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    ),
    'typeParameter' => TypeParameterRef(
      name: json['name'] as String,
      nullable: json['nullable'] as bool? ?? false,
    ),
    'union' => UnionTypeRef(
      nullable: json['nullable'] as bool? ?? false,
      options: (json['options'] as List<dynamic>)
          .map((o) => typeRefFromJson(o as Map<String, dynamic>))
          .toList(),
    ),
    _ => throw ArgumentError('Unknown TypeRef kind: $kind'),
  };
}
