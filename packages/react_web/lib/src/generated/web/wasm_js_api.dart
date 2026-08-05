// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: wasm-js-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class GlobalDescriptor {
  ValueType get value;
  set value(ValueType value);
  bool get mutable;
  set mutable(bool value);
}

typedef ImportExportKind = String;

abstract interface class MemoryDescriptor {
  int get initial;
  set initial(int value);
  int get maximum;
  set maximum(int value);
}

abstract interface class ModuleExportDescriptor {
  String get name;
  set name(String value);
  ImportExportKind get kind;
  set kind(ImportExportKind value);
}

abstract interface class ModuleImportDescriptor {
  String get module;
  set module(String value);
  String get name;
  set name(String value);
  ImportExportKind get kind;
  set kind(ImportExportKind value);
}

abstract interface class TableDescriptor {
  TableKind get element;
  set element(TableKind value);
  int get initial;
  set initial(int value);
  int get maximum;
  set maximum(int value);
}

typedef TableKind = String;

typedef ValueType = String;

abstract interface class WebAssemblyInstantiatedSource {
  Object get module;
  set module(Object value);
  Object get instance;
  set instance(Object value);
}

