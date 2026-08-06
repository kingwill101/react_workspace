// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: gyroscope
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Gyroscope {
  factory Gyroscope([GyroscopeSensorOptions? sensorOptions]) =>
      WebRuntime.current.createWebObject<Gyroscope>(
        'Gyroscope',
        [sensorOptions],
      );
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

  GyroscopeSensorOptionsValue({
    this.referenceFrame,
  });
}

