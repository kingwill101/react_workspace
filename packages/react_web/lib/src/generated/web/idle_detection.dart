// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: idle-detection
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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

