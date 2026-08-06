// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: compute-pressure
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class PressureObserverOptions {
  int? get sampleInterval;
  set sampleInterval(int? value);
}

final class PressureObserverOptionsValue implements PressureObserverOptions {
  @override
  int? sampleInterval;

  PressureObserverOptionsValue({
    this.sampleInterval,
  });
}

typedef PressureSource = String;

typedef PressureState = String;

typedef PressureUpdateCallback = void Function(List<Object> changes, Object observer,);

