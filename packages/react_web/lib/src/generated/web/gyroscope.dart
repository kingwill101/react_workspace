// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gyroscope
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class Gyroscope {
  factory Gyroscope([GyroscopeSensorOptions? sensorOptions]) => WebRuntime
      .current
      .createWebObject<Gyroscope>('Gyroscope', [sensorOptions]);
  double? get x;
  double? get y;
  double? get z;
}

typedef GyroscopeLocalCoordinateSystem = String;

abstract interface class GyroscopeSensorOptions {
  GyroscopeLocalCoordinateSystem? get referenceFrame;
  set referenceFrame(GyroscopeLocalCoordinateSystem? value);
}

final class GyroscopeSensorOptionsValue implements GyroscopeSensorOptions {
  @override
  GyroscopeLocalCoordinateSystem? referenceFrame;

  GyroscopeSensorOptionsValue({this.referenceFrame});
}
