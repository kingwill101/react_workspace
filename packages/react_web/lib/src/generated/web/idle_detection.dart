// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: idle-detection
// ignore_for_file: type=lint

import 'dom.dart';

abstract interface class IdleOptions {
  int? get threshold;
  set threshold(int? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class IdleOptionsValue implements IdleOptions {
  @override
  int? threshold;
  @override
  AbortSignal? signal;

  IdleOptionsValue({
    this.threshold,
    this.signal,
  });
}

typedef ScreenIdleState = String;

typedef UserIdleState = String;

