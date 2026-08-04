// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: performance-measure-memory
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class MemoryAttribution {
  String get url;
  set url(String value);
  MemoryAttributionContainer get container;
  set container(MemoryAttributionContainer value);
  String get scope;
  set scope(String value);
}

abstract interface class MemoryAttributionContainer {
  String get id;
  set id(String value);
  String get src;
  set src(String value);
}

abstract interface class MemoryBreakdownEntry {
  int get bytes;
  set bytes(int value);
  List<MemoryAttribution> get attribution;
  set attribution(List<MemoryAttribution> value);
  List<String> get types;
  set types(List<String> value);
}

abstract interface class MemoryMeasurement {
  int get bytes;
  set bytes(int value);
  List<MemoryBreakdownEntry> get breakdown;
  set breakdown(List<MemoryBreakdownEntry> value);
}

