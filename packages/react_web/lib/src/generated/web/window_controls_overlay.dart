// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: window-controls-overlay
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'html.dart';
import 'dom.dart';

abstract interface class WindowControlsOverlay {
  bool get visible;
  DOMRect getTitlebarAreaRect();
  EventHandler get ongeometrychange;
   set ongeometrychange(EventHandler value);
}

abstract interface class WindowControlsOverlayGeometryChangeEvent {
  DOMRect get titlebarAreaRect;
  bool get visible;
}

abstract interface class WindowControlsOverlayGeometryChangeEventInit {
  DOMRect get titlebarAreaRect;
  set titlebarAreaRect(DOMRect value);
  bool get visible;
  set visible(bool value);
}

