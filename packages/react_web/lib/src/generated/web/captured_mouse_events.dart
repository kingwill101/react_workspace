// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: captured-mouse-events
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'cssom_view.dart';
import 'screen_capture.dart';
import 'dom.dart';

abstract interface class CaptureController {
  EventHandler get oncapturedmousechange;
   set oncapturedmousechange(EventHandler value);
  List<int> getSupportedZoomLevels();
  int? get zoomLevel;
  Future<void> increaseZoomLevel();
  Future<void> decreaseZoomLevel();
  Future<void> resetZoomLevel();
  EventHandler get onzoomlevelchange;
   set onzoomlevelchange(EventHandler value);
  Future<void> forwardWheel(HTMLElement? element);
  void setFocusBehavior(CaptureStartFocusBehavior focusBehavior);
}

abstract interface class CapturedMouseEvent {
  int get surfaceX;
  int get surfaceY;
}

abstract interface class CapturedMouseEventInit {
  int get surfaceX;
  set surfaceX(int value);
  int get surfaceY;
  set surfaceY(int value);
}

