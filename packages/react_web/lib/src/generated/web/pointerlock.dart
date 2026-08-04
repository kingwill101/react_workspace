// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: pointerlock
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'uievents.dart';

abstract interface class MouseEventInit {
  double get movementX;
  set movementX(double value);
  double get movementY;
  set movementY(double value);
  int get screenX;
  set screenX(int value);
  int get screenY;
  set screenY(int value);
  int get clientX;
  set clientX(int value);
  int get clientY;
  set clientY(int value);
  int get button;
  set button(int value);
  int get buttons;
  set buttons(int value);
  EventTarget? get relatedTarget;
  set relatedTarget(EventTarget? value);
}

abstract interface class PointerLockOptions {
  bool get unadjustedMovement;
  set unadjustedMovement(bool value);
}

