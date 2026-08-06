// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-properties-values-api
// ignore_for_file: type=lint


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

