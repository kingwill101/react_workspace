// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: orientation-event
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class DeviceMotionEvent {
  DeviceMotionEventAcceleration? get acceleration;
  DeviceMotionEventAcceleration? get accelerationIncludingGravity;
  DeviceMotionEventRotationRate? get rotationRate;
  double get interval;
}

abstract interface class DeviceMotionEventAcceleration {
  double? get x;
  double? get y;
  double? get z;
}

abstract interface class DeviceMotionEventAccelerationInit {
  double? get x;
  set x(double? value);
  double? get y;
  set y(double? value);
  double? get z;
  set z(double? value);
}

abstract interface class DeviceMotionEventInit {
  DeviceMotionEventAccelerationInit get acceleration;
  set acceleration(DeviceMotionEventAccelerationInit value);
  DeviceMotionEventAccelerationInit get accelerationIncludingGravity;
  set accelerationIncludingGravity(DeviceMotionEventAccelerationInit value);
  DeviceMotionEventRotationRateInit get rotationRate;
  set rotationRate(DeviceMotionEventRotationRateInit value);
  double get interval;
  set interval(double value);
}

abstract interface class DeviceMotionEventRotationRate {
  double? get alpha;
  double? get beta;
  double? get gamma;
}

abstract interface class DeviceMotionEventRotationRateInit {
  double? get alpha;
  set alpha(double? value);
  double? get beta;
  set beta(double? value);
  double? get gamma;
  set gamma(double? value);
}

abstract interface class DeviceOrientationEvent {
  double? get alpha;
  double? get beta;
  double? get gamma;
  bool get absolute;
}

abstract interface class DeviceOrientationEventInit {
  double? get alpha;
  set alpha(double? value);
  double? get beta;
  set beta(double? value);
  double? get gamma;
  set gamma(double? value);
  bool get absolute;
  set absolute(bool value);
}

