// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: requestidlecallback
// ignore_for_file: type=lint

import 'hr_time.dart';

abstract interface class IdleDeadline {
  DOMHighResTimeStamp timeRemaining();
  bool get didTimeout;
}

typedef IdleRequestCallback = void Function(IdleDeadline deadline);

abstract interface class IdleRequestOptions {
  int? get timeout;
  set timeout(int? value);
}

final class IdleRequestOptionsValue implements IdleRequestOptions {
  @override
  int? timeout;

  IdleRequestOptionsValue({this.timeout});
}
