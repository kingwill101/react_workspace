// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: orientation-sensor
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';

abstract interface class AbsoluteOrientationSensor {
}

abstract interface class OrientationSensor {
  List<double>? get quaternion;
  void populateMatrix(RotationMatrixType targetMatrix);
}

typedef OrientationSensorLocalCoordinateSystem = String;

abstract interface class OrientationSensorOptions {
  OrientationSensorLocalCoordinateSystem get referenceFrame;
  set referenceFrame(OrientationSensorLocalCoordinateSystem value);
}

abstract interface class RelativeOrientationSensor {
}

typedef RotationMatrixType = Object;

