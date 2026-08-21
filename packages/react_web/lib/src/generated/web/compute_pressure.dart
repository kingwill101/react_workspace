// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: compute-pressure
// ignore_for_file: type=lint

abstract interface class PressureObserverOptions {
  int? get sampleInterval;
  set sampleInterval(int? value);
}

final class PressureObserverOptionsValue implements PressureObserverOptions {
  @override
  int? sampleInterval;

  PressureObserverOptionsValue({this.sampleInterval});
}

typedef PressureSource = String;

typedef PressureState = String;

typedef PressureUpdateCallback =
    void Function(List<Object> changes, Object observer);
