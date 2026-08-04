// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: accelerometer
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';

abstract interface class Accelerometer {
  double? get x;
  double? get y;
  double? get z;
}

typedef AccelerometerLocalCoordinateSystem = String;

abstract interface class AccelerometerSensorOptions {
  AccelerometerLocalCoordinateSystem get referenceFrame;
  set referenceFrame(AccelerometerLocalCoordinateSystem value);
}

abstract interface class GravitySensor {
}

abstract interface class LinearAccelerationSensor {
}

