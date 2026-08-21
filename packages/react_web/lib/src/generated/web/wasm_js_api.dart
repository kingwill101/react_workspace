// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: wasm-js-api
// ignore_for_file: type=lint

abstract interface class GlobalDescriptor {
  ValueType get value;
  set value(ValueType value);
  bool? get mutable;
  set mutable(bool? value);
}

final class GlobalDescriptorValue implements GlobalDescriptor {
  @override
  ValueType value;
  @override
  bool? mutable;

  GlobalDescriptorValue({required this.value, this.mutable});
}

typedef ImportExportKind = String;

abstract interface class MemoryDescriptor {
  int get initial;
  set initial(int value);
  int? get maximum;
  set maximum(int? value);
}

final class MemoryDescriptorValue implements MemoryDescriptor {
  @override
  int initial;
  @override
  int? maximum;

  MemoryDescriptorValue({required this.initial, this.maximum});
}

abstract interface class ModuleExportDescriptor {
  String get name;
  set name(String value);
  ImportExportKind get kind;
  set kind(ImportExportKind value);
}

final class ModuleExportDescriptorValue implements ModuleExportDescriptor {
  @override
  String name;
  @override
  ImportExportKind kind;

  ModuleExportDescriptorValue({required this.name, required this.kind});
}

abstract interface class ModuleImportDescriptor {
  String get module;
  set module(String value);
  String get name;
  set name(String value);
  ImportExportKind get kind;
  set kind(ImportExportKind value);
}

final class ModuleImportDescriptorValue implements ModuleImportDescriptor {
  @override
  String module;
  @override
  String name;
  @override
  ImportExportKind kind;

  ModuleImportDescriptorValue({
    required this.module,
    required this.name,
    required this.kind,
  });
}

abstract interface class TableDescriptor {
  TableKind get element;
  set element(TableKind value);
  int get initial;
  set initial(int value);
  int? get maximum;
  set maximum(int? value);
}

final class TableDescriptorValue implements TableDescriptor {
  @override
  TableKind element;
  @override
  int initial;
  @override
  int? maximum;

  TableDescriptorValue({
    required this.element,
    required this.initial,
    this.maximum,
  });
}

typedef TableKind = String;

typedef ValueType = String;

abstract interface class WebAssemblyInstantiatedSource {
  Object get module;
  set module(Object value);
  Object get instance;
  set instance(Object value);
}

final class WebAssemblyInstantiatedSourceValue
    implements WebAssemblyInstantiatedSource {
  @override
  Object module;
  @override
  Object instance;

  WebAssemblyInstantiatedSourceValue({
    required this.module,
    required this.instance,
  });
}
