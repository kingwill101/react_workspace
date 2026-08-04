// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: compute-pressure
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';

abstract interface class PressureObserver {
  Future<void> observe(PressureSource source, [PressureObserverOptions? options]);
  void unobserve(PressureSource source);
  void disconnect();
  List<PressureRecord> takeRecords();
}

abstract interface class PressureObserverOptions {
  int get sampleInterval;
  set sampleInterval(int value);
}

abstract interface class PressureRecord {
  PressureSource get source;
  PressureState get state;
  DOMHighResTimeStamp get time;
  Object toJSON();
}

typedef PressureSource = String;

typedef PressureState = String;

typedef PressureUpdateCallback = void Function(List<PressureRecord> changes, PressureObserver observer,);

