// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: screen-wake-lock
// ignore_for_file: type=lint

import 'html.dart';

abstract interface class WakeLock {
  Future<WakeLockSentinel> request([WakeLockType? type]);
}

abstract interface class WakeLockSentinel {
  bool get released;
  WakeLockType get type;
  Future<void> release();
  EventHandler get onrelease;
   set onrelease(EventHandler value);
}

typedef WakeLockType = String;

