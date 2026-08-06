// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: local-font-access
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class QueryOptions {
  List<String>? get postscriptNames;
  set postscriptNames(List<String>? value);
}

final class QueryOptionsValue implements QueryOptions {
  @override
  List<String>? postscriptNames;

  QueryOptionsValue({
    this.postscriptNames,
  });
}

