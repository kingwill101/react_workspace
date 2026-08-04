// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-highlight-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class Highlight {
   Iterable<AbstractRange> get values;
   bool has(Object value);
  int get priority;
   set priority(int value);
  HighlightType get type;
   set type(HighlightType value);
}

abstract interface class HighlightRegistry {
   Iterable<String> get keys;
   Iterable<Highlight> get values;
   Iterable<MapEntry<String, Highlight>> get entries;
   Highlight? operator [](Object key);
   bool has(Object key);
  List<Highlight> highlightsFromPoint(double x, double y, [HighlightsFromPointOptions? options]);
}

typedef HighlightType = String;

abstract interface class HighlightsFromPointOptions {
  List<ShadowRoot> get shadowRoots;
  set shadowRoots(List<ShadowRoot> value);
}

