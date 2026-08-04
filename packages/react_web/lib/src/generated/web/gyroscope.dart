// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gyroscope
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';

abstract interface class Gyroscope {
  double? get x;
  double? get y;
  double? get z;
}

typedef GyroscopeLocalCoordinateSystem = String;

abstract interface class GyroscopeSensorOptions {
  GyroscopeLocalCoordinateSystem get referenceFrame;
  set referenceFrame(GyroscopeLocalCoordinateSystem value);
}

