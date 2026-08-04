// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: geolocation-sensor
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'generic_sensor.dart';
import 'hr_time.dart';
import 'dom.dart';

abstract interface class GeolocationSensor {
  double? get latitude;
  double? get longitude;
  double? get altitude;
  double? get accuracy;
  double? get altitudeAccuracy;
  double? get heading;
  double? get speed;
}

abstract interface class GeolocationSensorOptions {
}

abstract interface class GeolocationSensorReading {
  DOMHighResTimeStamp? get timestamp;
  set timestamp(DOMHighResTimeStamp? value);
  double? get latitude;
  set latitude(double? value);
  double? get longitude;
  set longitude(double? value);
  double? get altitude;
  set altitude(double? value);
  double? get accuracy;
  set accuracy(double? value);
  double? get altitudeAccuracy;
  set altitudeAccuracy(double? value);
  double? get heading;
  set heading(double? value);
  double? get speed;
  set speed(double? value);
}

abstract interface class ReadOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

