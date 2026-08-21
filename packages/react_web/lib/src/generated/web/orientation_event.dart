// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: orientation-event
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class DeviceMotionEvent {
  factory DeviceMotionEvent(
    String type_, [
    DeviceMotionEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<DeviceMotionEvent>(
    'DeviceMotionEvent',
    [type_, eventInitDict],
  );
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

final class DeviceMotionEventAccelerationInitValue
    implements DeviceMotionEventAccelerationInit {
  @override
  double? x;
  @override
  double? y;
  @override
  double? z;

  DeviceMotionEventAccelerationInitValue({this.x, this.y, this.z});
}

abstract interface class DeviceMotionEventInit {
  DeviceMotionEventAccelerationInit? get acceleration;
  set acceleration(DeviceMotionEventAccelerationInit? value);
  DeviceMotionEventAccelerationInit? get accelerationIncludingGravity;
  set accelerationIncludingGravity(DeviceMotionEventAccelerationInit? value);
  DeviceMotionEventRotationRateInit? get rotationRate;
  set rotationRate(DeviceMotionEventRotationRateInit? value);
  double? get interval;
  set interval(double? value);
}

final class DeviceMotionEventInitValue implements DeviceMotionEventInit {
  @override
  DeviceMotionEventAccelerationInit? acceleration;
  @override
  DeviceMotionEventAccelerationInit? accelerationIncludingGravity;
  @override
  DeviceMotionEventRotationRateInit? rotationRate;
  @override
  double? interval;

  DeviceMotionEventInitValue({
    this.acceleration,
    this.accelerationIncludingGravity,
    this.rotationRate,
    this.interval,
  });
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

final class DeviceMotionEventRotationRateInitValue
    implements DeviceMotionEventRotationRateInit {
  @override
  double? alpha;
  @override
  double? beta;
  @override
  double? gamma;

  DeviceMotionEventRotationRateInitValue({this.alpha, this.beta, this.gamma});
}

abstract interface class DeviceOrientationEvent {
  factory DeviceOrientationEvent(
    String type_, [
    DeviceOrientationEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<DeviceOrientationEvent>(
    'DeviceOrientationEvent',
    [type_, eventInitDict],
  );
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
  bool? get absolute;
  set absolute(bool? value);
}

final class DeviceOrientationEventInitValue
    implements DeviceOrientationEventInit {
  @override
  double? alpha;
  @override
  double? beta;
  @override
  double? gamma;
  @override
  bool? absolute;

  DeviceOrientationEventInitValue({
    this.alpha,
    this.beta,
    this.gamma,
    this.absolute,
  });
}
