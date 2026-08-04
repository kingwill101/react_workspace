// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-view-transitions-2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_view_transitions.dart';

abstract interface class CSSViewTransitionRule {
  Object get navigation;
  List<Object> get types;
}

abstract interface class StartViewTransitionOptions {
  ViewTransitionUpdateCallback? get update;
  set update(ViewTransitionUpdateCallback? value);
  List<String>? get types;
  set types(List<String>? value);
}

abstract interface class ViewTransition {
  ViewTransitionTypeSet get types;
   set types(ViewTransitionTypeSet value);
  Future<void> get updateCallbackDone;
  Future<void> get ready;
  Future<void> get finished;
  void skipTransition();
}

abstract interface class ViewTransitionTypeSet {
   Iterable<String> get values;
   bool has(Object value);
}

