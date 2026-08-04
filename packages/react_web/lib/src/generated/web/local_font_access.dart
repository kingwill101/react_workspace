// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: local-font-access
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fileapi.dart';

abstract interface class FontData {
  Future<Blob> blob();
  String get postscriptName;
  String get fullName;
  String get family;
  String get style;
}

abstract interface class QueryOptions {
  List<String> get postscriptNames;
  set postscriptNames(List<String> value);
}

