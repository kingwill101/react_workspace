// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: generic-sensor
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'html.dart';
import 'webidl.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Sensor {
  bool get activated;
  bool get hasReading;
  DOMHighResTimeStamp? get timestamp;
  void start();
  void stop();
  EventHandler get onreading;
   set onreading(EventHandler value);
  EventHandler get onactivate;
   set onactivate(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
}

abstract interface class SensorErrorEvent {
  factory SensorErrorEvent(String type_, SensorErrorEventInit errorEventInitDict) =>
      WebRuntime.current.createWebObject<SensorErrorEvent>(
        'SensorErrorEvent',
        [type_, errorEventInitDict],
      );
  DOMException get error;
}

abstract interface class SensorErrorEventInit {
  DOMException get error;
  set error(DOMException value);
}

final class SensorErrorEventInitValue implements SensorErrorEventInit {
  @override
  DOMException error;

  SensorErrorEventInitValue({
    required this.error,
  });
}

abstract interface class SensorOptions {
  double? get frequency;
  set frequency(double? value);
}

final class SensorOptionsValue implements SensorOptions {
  @override
  double? frequency;

  SensorOptionsValue({
    this.frequency,
  });
}

