// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: url
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class URLSearchParams {
  int get size;
  void append(String name, String value);
  void delete(String name, [String? value]);
  String? get_(String name);
  List<String> getAll(String name);
  bool has(String name, [String? value]);
  void set_(String name, String value);
  void sort();
   Iterable<(String, String)> get entries;
   Iterable<String> get keys;
   Iterable<String> get values;
}

