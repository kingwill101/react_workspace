// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: compute-pressure
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class PressureObserverOptions {
  int get sampleInterval;
  set sampleInterval(int value);
}

typedef PressureSource = String;

typedef PressureState = String;

typedef PressureUpdateCallback = void Function(List<Object> changes, Object observer,);

