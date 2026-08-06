// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: pointerevents
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'pointerlock.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class PointerEvent {
  factory PointerEvent(String type, [PointerEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PointerEvent>(
        'PointerEvent',
        [type, eventInitDict],
      );
  int get pointerId;
  double get width;
  double get height;
  double get pressure;
  double get tangentialPressure;
  int get tiltX;
  int get tiltY;
  int get twist;
  String get pointerType;
  bool get isPrimary;
  List<PointerEvent> getCoalescedEvents();
  List<PointerEvent> getPredictedEvents();
}

abstract interface class PointerEventInit {
  int? get pointerId;
  set pointerId(int? value);
  double? get width;
  set width(double? value);
  double? get height;
  set height(double? value);
  double? get pressure;
  set pressure(double? value);
  double? get tangentialPressure;
  set tangentialPressure(double? value);
  int? get tiltX;
  set tiltX(int? value);
  int? get tiltY;
  set tiltY(int? value);
  int? get twist;
  set twist(int? value);
  double? get altitudeAngle;
  set altitudeAngle(double? value);
  double? get azimuthAngle;
  set azimuthAngle(double? value);
  String? get pointerType;
  set pointerType(String? value);
  bool? get isPrimary;
  set isPrimary(bool? value);
  List<PointerEvent>? get coalescedEvents;
  set coalescedEvents(List<PointerEvent>? value);
  List<PointerEvent>? get predictedEvents;
  set predictedEvents(List<PointerEvent>? value);
}

final class PointerEventInitValue implements PointerEventInit {
  @override
  int? pointerId;
  @override
  double? width;
  @override
  double? height;
  @override
  double? pressure;
  @override
  double? tangentialPressure;
  @override
  int? tiltX;
  @override
  int? tiltY;
  @override
  int? twist;
  @override
  double? altitudeAngle;
  @override
  double? azimuthAngle;
  @override
  String? pointerType;
  @override
  bool? isPrimary;
  @override
  List<PointerEvent>? coalescedEvents;
  @override
  List<PointerEvent>? predictedEvents;

  PointerEventInitValue({
    this.pointerId,
    this.width,
    this.height,
    this.pressure,
    this.tangentialPressure,
    this.tiltX,
    this.tiltY,
    this.twist,
    this.altitudeAngle,
    this.azimuthAngle,
    this.pointerType,
    this.isPrimary,
    this.coalescedEvents,
    this.predictedEvents,
  });
}

