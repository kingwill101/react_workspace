// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: requestidlecallback
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';

abstract interface class IdleDeadline {
  DOMHighResTimeStamp timeRemaining();
  bool get didTimeout;
}

typedef IdleRequestCallback = void Function(IdleDeadline deadline,);

abstract interface class IdleRequestOptions {
  int get timeout;
  set timeout(int value);
}

