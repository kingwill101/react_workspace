/// Web IDL member / parameter IR shared by the complete model definitions.
library;

import '../model/type_ref.dart';

/// A preserved Web IDL extended attribute.
final class ExtAttr {
  final String name;

  /// Raw right-hand-side text (e.g. `Window`, `*`, `8,14`) or null.
  final String? rhs;

  const ExtAttr({required this.name, this.rhs});

  Map<String, Object?> toJson() => {'name': name, if (rhs != null) 'rhs': rhs};
}

/// An IDL argument / parameter.
final class IdlParameter {
  final String name;
  final TypeRef type;
  final bool required;

  /// Raw default expression text, if any (e.g. `0`, `""`, `true`).
  final String? defaultValue;
  final bool variadic;
  final List<ExtAttr> extAttrs;

  const IdlParameter({
    required this.name,
    required this.type,
    this.required = true,
    this.defaultValue,
    this.variadic = false,
    this.extAttrs = const [],
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'type': type.toJson(),
    'required': required,
    if (defaultValue != null) 'default': defaultValue,
    'variadic': variadic,
    'extAttrs': extAttrs.map((e) => e.toJson()).toList(),
  };
}

sealed class IdlMember {
  final String name;
  final List<ExtAttr> extAttrs;
  final bool staticMember;

  const IdlMember({
    required this.name,
    this.extAttrs = const [],
    this.staticMember = false,
  });

  Map<String, Object?> toJson();
}

final class IdlAttribute extends IdlMember {
  final TypeRef type;
  final bool readonly;

  /// Web IDL `special` field: `static`, `stringifier`, `inherit`, or empty.
  final String special;

  const IdlAttribute({
    required super.name,
    required this.type,
    required this.readonly,
    this.special = '',
    super.extAttrs = const [],
    super.staticMember = false,
  });

  @override
  Map<String, Object?> toJson() => {
    'kind': 'attribute',
    'name': name,
    'type': type.toJson(),
    'readonly': readonly,
    'special': special,
    'static': staticMember,
    'extAttrs': extAttrs.map((e) => e.toJson()).toList(),
  };
}

final class IdlOperation extends IdlMember {
  final TypeRef returnType;
  final List<IdlParameter> parameters;

  /// `getter`, `setter`, `deleter`, `stringifier`, `static`, or empty.
  final String special;

  const IdlOperation({
    required super.name,
    required this.returnType,
    this.parameters = const [],
    this.special = '',
    super.extAttrs = const [],
    super.staticMember = false,
  });

  @override
  Map<String, Object?> toJson() => {
    'kind': 'operation',
    'name': name,
    'returnType': returnType.toJson(),
    'parameters': parameters.map((p) => p.toJson()).toList(),
    'special': special,
    'static': staticMember,
    'extAttrs': extAttrs.map((e) => e.toJson()).toList(),
  };
}

final class IdlConstructor extends IdlMember {
  final List<IdlParameter> parameters;

  const IdlConstructor({required this.parameters, super.extAttrs = const []})
    : super(name: r'constructor');

  @override
  Map<String, Object?> toJson() => {
    'kind': 'constructor',
    'parameters': parameters.map((p) => p.toJson()).toList(),
  };
}

final class IdlConstant extends IdlMember {
  final TypeRef type;

  /// Raw value text from the snapshot (e.g. `0`, `""`, `1.5`, `true`).
  final String? value;

  const IdlConstant({
    required super.name,
    required this.type,
    this.value,
    super.extAttrs = const [],
  });

  @override
  Map<String, Object?> toJson() => {
    'kind': 'constant',
    'name': name,
    'type': type.toJson(),
    if (value != null) 'value': value,
  };
}

final class IdlIterable extends IdlMember {
  final List<TypeRef> types;
  final bool async;

  const IdlIterable({
    required this.types,
    this.async = false,
    super.extAttrs = const [],
  }) : super(name: async ? 'asyncIterable' : 'iterable');

  @override
  Map<String, Object?> toJson() => {
    'kind': 'iterable',
    'async': async,
    'types': types.map((t) => t.toJson()).toList(),
  };
}

final class IdlMaplike extends IdlMember {
  final TypeRef keyType;
  final TypeRef valueType;
  final bool readonly;

  const IdlMaplike({
    required this.keyType,
    required this.valueType,
    required this.readonly,
    super.extAttrs = const [],
  }) : super(name: 'maplike');

  @override
  Map<String, Object?> toJson() => {
    'kind': 'maplike',
    'key': keyType.toJson(),
    'value': valueType.toJson(),
    'readonly': readonly,
  };
}

final class IdlSetlike extends IdlMember {
  final TypeRef valueType;
  final bool readonly;

  const IdlSetlike({
    required this.valueType,
    required this.readonly,
    super.extAttrs = const [],
  }) : super(name: 'setlike');

  @override
  Map<String, Object?> toJson() => {
    'kind': 'setlike',
    'value': valueType.toJson(),
    'readonly': readonly,
  };
}

/// A dictionary field.
final class IdlField extends IdlMember {
  final TypeRef type;
  final bool required;
  final String? defaultValue;

  const IdlField({
    required super.name,
    required this.type,
    this.required = false,
    this.defaultValue,
    super.extAttrs = const [],
  });

  @override
  Map<String, Object?> toJson() => {
    'kind': 'field',
    'name': name,
    'type': type.toJson(),
    'required': required,
    if (defaultValue != null) 'default': defaultValue,
  };
}
