// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: css-properties-values-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class CSSPropertyRule {
  Object get name;
  Object get syntax;
  bool get inherits;
  Object get initialValue;
}

abstract interface class PropertyDefinition {
  String get name;
  set name(String value);
  String? get syntax;
  set syntax(String? value);
  bool get inherits;
  set inherits(bool value);
  String? get initialValue;
  set initialValue(String? value);
}

final class PropertyDefinitionValue implements PropertyDefinition {
  @override
  String name;
  @override
  String? syntax;
  @override
  bool inherits;
  @override
  String? initialValue;

  PropertyDefinitionValue({
    required this.name,
    this.syntax,
    required this.inherits,
    this.initialValue,
  });
}

