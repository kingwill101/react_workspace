// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: pointerevents
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'pointerlock.dart';

abstract interface class PointerEvent {
  int get pointerId;
  double get width;
  double get height;
  double get pressure;
  double get tangentialPressure;
  int get tiltX;
  int get tiltY;
  int get twist;
  double get altitudeAngle;
  double get azimuthAngle;
  String get pointerType;
  bool get isPrimary;
  int get persistentDeviceId;
  List<PointerEvent> getCoalescedEvents();
  List<PointerEvent> getPredictedEvents();
}

abstract interface class PointerEventInit {
  int get pointerId;
  set pointerId(int value);
  double get width;
  set width(double value);
  double get height;
  set height(double value);
  double get pressure;
  set pressure(double value);
  double get tangentialPressure;
  set tangentialPressure(double value);
  int get tiltX;
  set tiltX(int value);
  int get tiltY;
  set tiltY(int value);
  int get twist;
  set twist(int value);
  double get altitudeAngle;
  set altitudeAngle(double value);
  double get azimuthAngle;
  set azimuthAngle(double value);
  String get pointerType;
  set pointerType(String value);
  bool get isPrimary;
  set isPrimary(bool value);
  int get persistentDeviceId;
  set persistentDeviceId(int value);
  List<PointerEvent> get coalescedEvents;
  set coalescedEvents(List<PointerEvent> value);
  List<PointerEvent> get predictedEvents;
  set predictedEvents(List<PointerEvent> value);
}

