// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: touch-events
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Touch {
  factory Touch(TouchInit touchInitDict) =>
      WebRuntime.current.createWebObject<Touch>('Touch', [touchInitDict]);
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
  factory TouchEvent(String type_, [TouchEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<TouchEvent>('TouchEvent', [
        type_,
        eventInitDict,
      ]);
  TouchList get touches;
  TouchList get targetTouches;
  TouchList get changedTouches;
  bool get altKey;
  bool get metaKey;
  bool get ctrlKey;
  bool get shiftKey;
}

abstract interface class TouchEventInit {
  List<Touch>? get touches;
  set touches(List<Touch>? value);
  List<Touch>? get targetTouches;
  set targetTouches(List<Touch>? value);
  List<Touch>? get changedTouches;
  set changedTouches(List<Touch>? value);
}

final class TouchEventInitValue implements TouchEventInit {
  @override
  List<Touch>? touches;
  @override
  List<Touch>? targetTouches;
  @override
  List<Touch>? changedTouches;

  TouchEventInitValue({this.touches, this.targetTouches, this.changedTouches});
}

abstract interface class TouchInit {
  int get identifier;
  set identifier(int value);
  EventTarget get target;
  set target(EventTarget value);
  double? get clientX;
  set clientX(double? value);
  double? get clientY;
  set clientY(double? value);
  double? get screenX;
  set screenX(double? value);
  double? get screenY;
  set screenY(double? value);
  double? get pageX;
  set pageX(double? value);
  double? get pageY;
  set pageY(double? value);
  double? get radiusX;
  set radiusX(double? value);
  double? get radiusY;
  set radiusY(double? value);
  double? get rotationAngle;
  set rotationAngle(double? value);
  double? get force;
  set force(double? value);
  double? get altitudeAngle;
  set altitudeAngle(double? value);
  double? get azimuthAngle;
  set azimuthAngle(double? value);
  TouchType? get touchType;
  set touchType(TouchType? value);
}

final class TouchInitValue implements TouchInit {
  @override
  int identifier;
  @override
  EventTarget target;
  @override
  double? clientX;
  @override
  double? clientY;
  @override
  double? screenX;
  @override
  double? screenY;
  @override
  double? pageX;
  @override
  double? pageY;
  @override
  double? radiusX;
  @override
  double? radiusY;
  @override
  double? rotationAngle;
  @override
  double? force;
  @override
  double? altitudeAngle;
  @override
  double? azimuthAngle;
  @override
  TouchType? touchType;

  TouchInitValue({
    required this.identifier,
    required this.target,
    this.clientX,
    this.clientY,
    this.screenX,
    this.screenY,
    this.pageX,
    this.pageY,
    this.radiusX,
    this.radiusY,
    this.rotationAngle,
    this.force,
    this.altitudeAngle,
    this.azimuthAngle,
    this.touchType,
  });
}

abstract interface class TouchList {
  int get length;
  Touch? item(int index);
}

typedef TouchType = String;
