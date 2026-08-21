// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: local-font-access
// ignore_for_file: type=lint

abstract interface class QueryOptions {
  List<String>? get postscriptNames;
  set postscriptNames(List<String>? value);
}

final class QueryOptionsValue implements QueryOptions {
  @override
  List<String>? postscriptNames;

  QueryOptionsValue({this.postscriptNames});
}
