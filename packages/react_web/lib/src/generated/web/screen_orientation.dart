// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: screen-orientation
// ignore_for_file: type=lint

import 'html.dart';

typedef OrientationLockType = String;

typedef OrientationType = String;

abstract interface class ScreenOrientation {
  Future<void> lock(OrientationLockType orientation);
  void unlock();
  OrientationType get type_;
  int get angle;
  EventHandler get onchange;
   set onchange(EventHandler value);
}

