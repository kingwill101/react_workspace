// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: screen-wake-lock
// ignore_for_file: type=lint

import 'html.dart';

abstract interface class WakeLock {
  Future<WakeLockSentinel> request([WakeLockType? type_]);
}

abstract interface class WakeLockSentinel {
  bool get released;
  WakeLockType get type_;
  Future<void> release();
  EventHandler get onrelease;
  set onrelease(EventHandler value);
}

typedef WakeLockType = String;
