// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: captured-mouse-events
// ignore_for_file: type=lint

abstract interface class CapturedMouseEventInit {
  int? get surfaceX;
  set surfaceX(int? value);
  int? get surfaceY;
  set surfaceY(int? value);
}

final class CapturedMouseEventInitValue implements CapturedMouseEventInit {
  @override
  int? surfaceX;
  @override
  int? surfaceY;

  CapturedMouseEventInitValue({this.surfaceX, this.surfaceY});
}
