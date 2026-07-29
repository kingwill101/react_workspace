import 'type_ref.dart';

sealed class MemberDecl {
  const MemberDecl();
  String get name;
  Map<String, Object?> toJson();
}

final class AttributeDecl extends MemberDecl {
  @override
  final String name;
  final bool readable;
  final bool writable;
  final TypeRef type;

  const AttributeDecl({
    required this.name,
    this.readable = true,
    this.writable = false,
    required this.type,
  });

  @override
  Map<String, Object?> toJson() => {
    'name': name,
    'kind': 'attribute',
    'readable': readable,
    'writable': writable,
    'type': type.toJson(),
  };
}

final class OperationDecl extends MemberDecl {
  @override
  final String name;
  final List<ParameterDecl> parameters;
  final TypeRef returnType;

  const OperationDecl({
    required this.name,
    this.parameters = const [],
    required this.returnType,
  });

  @override
  Map<String, Object?> toJson() => {
    'name': name,
    'kind': 'operation',
    'parameters': parameters.map((p) => p.toJson()).toList(),
    'returnType': returnType.toJson(),
  };
}

final class ParameterDecl {
  final String name;
  final bool required;
  final TypeRef type;

  const ParameterDecl({
    required this.name,
    this.required = true,
    required this.type,
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'required': required,
    'type': type.toJson(),
  };
}

MemberDecl memberDeclFromJson(Map<String, dynamic> json) {
  final kind = json['kind'] as String;
  return switch (kind) {
    'attribute' => AttributeDecl(
      name: json['name'] as String,
      readable: json['readable'] as bool? ?? true,
      writable: json['writable'] as bool? ?? false,
      type: typeRefFromJson(json['type'] as Map<String, dynamic>),
    ),
    'operation' => OperationDecl(
      name: json['name'] as String,
      parameters:
          (json['parameters'] as List<dynamic>?)
              ?.map((p) => parameterDeclFromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      returnType: typeRefFromJson(json['returnType'] as Map<String, dynamic>),
    ),
    _ => throw ArgumentError('Unknown MemberDecl kind: $kind'),
  };
}

ParameterDecl parameterDeclFromJson(Map<String, dynamic> json) {
  return ParameterDecl(
    name: json['name'] as String,
    required: json['required'] as bool? ?? true,
    type: typeRefFromJson(json['type'] as Map<String, dynamic>),
  );
}
