// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: magnetometer
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';

abstract interface class Magnetometer {
  double? get x;
  double? get y;
  double? get z;
}

typedef MagnetometerLocalCoordinateSystem = String;

abstract interface class MagnetometerSensorOptions {
  MagnetometerLocalCoordinateSystem get referenceFrame;
  set referenceFrame(MagnetometerLocalCoordinateSystem value);
}

abstract interface class UncalibratedMagnetometer {
  double? get x;
  double? get y;
  double? get z;
  double? get xBias;
  double? get yBias;
  double? get zBias;
}

