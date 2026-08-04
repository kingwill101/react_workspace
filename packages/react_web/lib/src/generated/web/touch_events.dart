// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: touch-events
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'uievents.dart';

abstract interface class Touch {
  int get identifier;
  EventTarget get target;
  double get screenX;
  double get screenY;
  double get clientX;
  double get clientY;
  double get pageX;
  double get pageY;
  double get radiusX;
  double get radiusY;
  double get rotationAngle;
  double get force;
  double get altitudeAngle;
  double get azimuthAngle;
  TouchType get touchType;
}

abstract interface class TouchEvent {
  TouchList get touches;
  TouchList get targetTouches;
  TouchList get changedTouches;
  bool get altKey;
  bool get metaKey;
  bool get ctrlKey;
  bool get shiftKey;
  bool getModifierState(String keyArg);
}

abstract interface class TouchEventInit {
  List<Touch> get touches;
  set touches(List<Touch> value);
  List<Touch> get targetTouches;
  set targetTouches(List<Touch> value);
  List<Touch> get changedTouches;
  set changedTouches(List<Touch> value);
}

abstract interface class TouchInit {
  int get identifier;
  set identifier(int value);
  EventTarget get target;
  set target(EventTarget value);
  double get clientX;
  set clientX(double value);
  double get clientY;
  set clientY(double value);
  double get screenX;
  set screenX(double value);
  double get screenY;
  set screenY(double value);
  double get pageX;
  set pageX(double value);
  double get pageY;
  set pageY(double value);
  double get radiusX;
  set radiusX(double value);
  double get radiusY;
  set radiusY(double value);
  double get rotationAngle;
  set rotationAngle(double value);
  double get force;
  set force(double value);
  double get altitudeAngle;
  set altitudeAngle(double value);
  double get azimuthAngle;
  set azimuthAngle(double value);
  TouchType get touchType;
  set touchType(TouchType value);
}

abstract interface class TouchList {
  int get length;
  Touch? item(int index);
}

typedef TouchType = String;

