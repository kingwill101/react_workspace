// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: keyboard-map
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class KeyboardLayoutMap {
   Iterable<String> get keys;
   Iterable<String> get values;
   Iterable<MapEntry<String, String>> get entries;
   String? operator [](Object key);
   bool has(Object key);
}

