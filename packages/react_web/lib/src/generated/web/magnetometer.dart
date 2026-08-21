// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: magnetometer
// ignore_for_file: type=lint

typedef MagnetometerLocalCoordinateSystem = String;

abstract interface class MagnetometerSensorOptions {
  MagnetometerLocalCoordinateSystem? get referenceFrame;
  set referenceFrame(MagnetometerLocalCoordinateSystem? value);
}

final class MagnetometerSensorOptionsValue
    implements MagnetometerSensorOptions {
  @override
  MagnetometerLocalCoordinateSystem? referenceFrame;

  MagnetometerSensorOptionsValue({this.referenceFrame});
}
