// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: geolocation-sensor
// ignore_for_file: type=lint

import 'dom.dart';
import 'hr_time.dart';

abstract interface class GeolocationSensorOptions {}

final class GeolocationSensorOptionsValue implements GeolocationSensorOptions {
  GeolocationSensorOptionsValue();
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

final class GeolocationSensorReadingValue implements GeolocationSensorReading {
  @override
  DOMHighResTimeStamp? timestamp;
  @override
  double? latitude;
  @override
  double? longitude;
  @override
  double? altitude;
  @override
  double? accuracy;
  @override
  double? altitudeAccuracy;
  @override
  double? heading;
  @override
  double? speed;

  GeolocationSensorReadingValue({
    this.timestamp,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
    this.altitudeAccuracy,
    this.heading,
    this.speed,
  });
}

abstract interface class ReadOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class ReadOptionsValue implements ReadOptions {
  @override
  AbortSignal? signal;

  ReadOptionsValue({this.signal});
}
