// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: pointerlock
// ignore_for_file: type=lint

import 'dom.dart';
import 'uievents.dart';

abstract interface class MouseEventInit {
  double? get movementX;
  set movementX(double? value);
  double? get movementY;
  set movementY(double? value);
  int? get screenX;
  set screenX(int? value);
  int? get screenY;
  set screenY(int? value);
  int? get clientX;
  set clientX(int? value);
  int? get clientY;
  set clientY(int? value);
  int? get button;
  set button(int? value);
  int? get buttons;
  set buttons(int? value);
  EventTarget? get relatedTarget;
  set relatedTarget(EventTarget? value);
}

final class MouseEventInitValue implements MouseEventInit {
  @override
  double? movementX;
  @override
  double? movementY;
  @override
  int? screenX;
  @override
  int? screenY;
  @override
  int? clientX;
  @override
  int? clientY;
  @override
  int? button;
  @override
  int? buttons;
  @override
  EventTarget? relatedTarget;

  MouseEventInitValue({
    this.movementX,
    this.movementY,
    this.screenX,
    this.screenY,
    this.clientX,
    this.clientY,
    this.button,
    this.buttons,
    this.relatedTarget,
  });
}

abstract interface class PointerLockOptions {
  bool? get unadjustedMovement;
  set unadjustedMovement(bool? value);
}

final class PointerLockOptionsValue implements PointerLockOptions {
  @override
  bool? unadjustedMovement;

  PointerLockOptionsValue({this.unadjustedMovement});
}
