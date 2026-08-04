// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-parser-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class CSSParserAtRule {
  String get name;
  List<CSSParserValue> get prelude;
  List<CSSParserRule>? get body;
}

abstract interface class CSSParserBlock {
  String get name;
  List<CSSParserValue> get body;
}

abstract interface class CSSParserDeclaration {
  String get name;
  List<CSSParserValue> get body;
}

abstract interface class CSSParserFunction {
  String get name;
  List<List<CSSParserValue>> get args;
}

abstract interface class CSSParserOptions {
  Object get atRules;
  set atRules(Object value);
}

abstract interface class CSSParserQualifiedRule {
  List<CSSParserValue> get prelude;
  List<CSSParserRule> get body;
}

abstract interface class CSSParserRule {
}

abstract interface class CSSParserValue {
}

typedef CSSStringSource = Object;

typedef CSSToken = Object;

