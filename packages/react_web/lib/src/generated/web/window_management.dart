// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: window-management
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';

abstract interface class ScreenDetailed {
  int get availLeft;
  int get availTop;
  int get left;
  int get top;
  bool get isPrimary;
  bool get isInternal;
  double get devicePixelRatio;
  String get label;
}

abstract interface class ScreenDetails {
  List<ScreenDetailed> get screens;
  ScreenDetailed get currentScreen;
  EventHandler get onscreenschange;
   set onscreenschange(EventHandler value);
  EventHandler get oncurrentscreenchange;
   set oncurrentscreenchange(EventHandler value);
}

