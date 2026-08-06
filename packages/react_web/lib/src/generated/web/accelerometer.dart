// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: accelerometer
// ignore_for_file: type=lint

import 'generic_sensor.dart';
import 'package:react_web/src/web_runtime.dart';

typedef AccelerometerLocalCoordinateSystem = String;

abstract interface class AccelerometerSensorOptions {
  AccelerometerLocalCoordinateSystem? get referenceFrame;
  set referenceFrame(AccelerometerLocalCoordinateSystem? value);
}

final class AccelerometerSensorOptionsValue implements AccelerometerSensorOptions {
  @override
  AccelerometerLocalCoordinateSystem? referenceFrame;

  AccelerometerSensorOptionsValue({
    this.referenceFrame,
  });
}

abstract interface class GravitySensor {
  factory GravitySensor([AccelerometerSensorOptions? options]) =>
      WebRuntime.current.createWebObject<GravitySensor>(
        'GravitySensor',
        [options],
      );
}

abstract interface class LinearAccelerationSensor {
  factory LinearAccelerationSensor([AccelerometerSensorOptions? options]) =>
      WebRuntime.current.createWebObject<LinearAccelerationSensor>(
        'LinearAccelerationSensor',
        [options],
      );
}

