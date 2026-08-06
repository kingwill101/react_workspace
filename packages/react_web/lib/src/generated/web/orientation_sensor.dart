// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: orientation-sensor
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';
import 'geometry.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class AbsoluteOrientationSensor {
  factory AbsoluteOrientationSensor([OrientationSensorOptions? sensorOptions]) =>
      WebRuntime.current.createWebObject<AbsoluteOrientationSensor>(
        'AbsoluteOrientationSensor',
        [sensorOptions],
      );
}

abstract interface class OrientationSensor {
  List<double>? get quaternion;
  void populateMatrix(RotationMatrixType targetMatrix);
}

typedef OrientationSensorLocalCoordinateSystem = String;

abstract interface class OrientationSensorOptions {
  OrientationSensorLocalCoordinateSystem? get referenceFrame;
  set referenceFrame(OrientationSensorLocalCoordinateSystem? value);
}

final class OrientationSensorOptionsValue implements OrientationSensorOptions {
  @override
  OrientationSensorLocalCoordinateSystem? referenceFrame;

  OrientationSensorOptionsValue({
    this.referenceFrame,
  });
}

abstract interface class RelativeOrientationSensor {
  factory RelativeOrientationSensor([OrientationSensorOptions? sensorOptions]) =>
      WebRuntime.current.createWebObject<RelativeOrientationSensor>(
        'RelativeOrientationSensor',
        [sensorOptions],
      );
}

typedef RotationMatrixType = Object;

