// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: magnetometer
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';

typedef MagnetometerLocalCoordinateSystem = String;

abstract interface class MagnetometerSensorOptions {
  MagnetometerLocalCoordinateSystem? get referenceFrame;
  set referenceFrame(MagnetometerLocalCoordinateSystem? value);
}

final class MagnetometerSensorOptionsValue implements MagnetometerSensorOptions {
  @override
  MagnetometerLocalCoordinateSystem? referenceFrame;

  MagnetometerSensorOptionsValue({
    this.referenceFrame,
  });
}

