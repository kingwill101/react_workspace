// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-regions
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_nav.dart';
import 'dom.dart';
import 'cssom_view.dart';

abstract interface class NamedFlow {
  Object get name;
  bool get overset;
  List<Element> getRegions();
  int get firstEmptyRegionIndex;
  List<Node> getContent();
  List<Element> getRegionsByContent(Node node);
}

abstract interface class NamedFlowMap {
   Iterable<Object> get keys;
   Iterable<NamedFlow> get values;
   Iterable<MapEntry<Object, NamedFlow>> get entries;
   NamedFlow? operator [](Object key);
   bool has(Object key);
}

abstract interface class Region {
  Object get regionOverset;
  List<Range>? getRegionFlowRanges();
}

