// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: geolocation
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';

abstract interface class Geolocation {
  void getCurrentPosition(PositionCallback successCallback, [PositionErrorCallback? errorCallback, PositionOptions? options]);
  int watchPosition(PositionCallback successCallback, [PositionErrorCallback? errorCallback, PositionOptions? options]);
  void clearWatch(int watchId);
}

abstract interface class GeolocationCoordinates {
  double get accuracy;
  double get latitude;
  double get longitude;
  double? get altitude;
  double? get altitudeAccuracy;
  double? get heading;
  double? get speed;
  Object toJSON();
}

abstract interface class GeolocationPosition {
  GeolocationCoordinates get coords;
  EpochTimeStamp get timestamp;
  Object toJSON();
}

abstract interface class GeolocationPositionError {
   static const int PERMISSION_DENIED =
      1;
   static const int POSITION_UNAVAILABLE =
      2;
   static const int TIMEOUT =
      3;
  int get code;
  String get message;
}

typedef PositionCallback = void Function(GeolocationPosition position,);

typedef PositionErrorCallback = void Function(GeolocationPositionError positionError,);

abstract interface class PositionOptions {
  bool get enableHighAccuracy;
  set enableHighAccuracy(bool value);
  int get timeout;
  set timeout(int value);
  int get maximumAge;
  set maximumAge(int value);
}

