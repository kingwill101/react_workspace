// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: magnetometer
// ignore_for_file: type=lint

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

