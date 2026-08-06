// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: css-view-transitions-2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_view_transitions.dart';

abstract interface class StartViewTransitionOptions {
  UpdateCallback? get update;
  set update(UpdateCallback? value);
  List<String>? get types;
  set types(List<String>? value);
}

final class StartViewTransitionOptionsValue implements StartViewTransitionOptions {
  @override
  UpdateCallback? update;
  @override
  List<String>? types;

  StartViewTransitionOptionsValue({
    this.update,
    this.types,
  });
}

abstract interface class ViewTransition {
  Future<void> get updateCallbackDone;
  Future<void> get ready;
  Future<void> get finished;
  void skipTransition();
}

typedef ViewTransitionNavigation = String;

