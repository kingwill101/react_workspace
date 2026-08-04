// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: wasm-js-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'fetch.dart';

abstract interface class Global {
  Object valueOf();
  Object get value;
   set value(Object value);
}

abstract interface class GlobalDescriptor {
  ValueType get value;
  set value(ValueType value);
  bool get mutable;
  set mutable(bool value);
}

typedef ImportExportKind = String;

abstract interface class Instance {
  Object get exports;
}

abstract interface class Memory {
  int grow(int delta);
  Object toFixedLengthBuffer();
  Object toResizableBuffer();
  Object get buffer;
}

abstract interface class MemoryDescriptor {
  int get initial;
  set initial(int value);
  int get maximum;
  set maximum(int value);
}

abstract interface class Module {
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

abstract interface class Table {
  int grow(int delta, [Object? value]);
  Object get_(int index);
  void set_(int index, [Object? value]);
  int get length;
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

abstract final class WebAssembly {
  WebAssembly._();
  static bool validate(BufferSource bytes) => throw UnsupportedError(
      'validate is not supported in the neutral surface');
  static Future<Module> compile(BufferSource bytes) => throw UnsupportedError(
      'compile is not supported in the neutral surface');
  static Future<WebAssemblyInstantiatedSource> instantiate(BufferSource bytes, [Object? importObject]) => throw UnsupportedError(
      'instantiate is not supported in the neutral surface');
  static Future<Module> compileStreaming(Future<Response> source) => throw UnsupportedError(
      'compileStreaming is not supported in the neutral surface');
  static Future<WebAssemblyInstantiatedSource> instantiateStreaming(Future<Response> source, [Object? importObject]) => throw UnsupportedError(
      'instantiateStreaming is not supported in the neutral surface');
}

abstract interface class WebAssemblyInstantiatedSource {
  Module get module;
  set module(Module value);
  Instance get instance;
  set instance(Instance value);
}

