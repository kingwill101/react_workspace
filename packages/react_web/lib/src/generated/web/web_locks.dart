// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-locks
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class Lock {
  String get name;
  LockMode get mode;
}

typedef LockGrantedCallback = Future<Object> Function(Lock? lock,);

abstract interface class LockInfo {
  String get name;
  set name(String value);
  LockMode get mode;
  set mode(LockMode value);
  String get clientId;
  set clientId(String value);
}

abstract interface class LockManager {
  Future<Object> request(String name, LockOptions options, LockGrantedCallback callback);
  Future<LockManagerSnapshot> query();
}

abstract interface class LockManagerSnapshot {
  List<LockInfo> get held;
  set held(List<LockInfo> value);
  List<LockInfo> get pending;
  set pending(List<LockInfo> value);
}

typedef LockMode = String;

abstract interface class LockOptions {
  LockMode get mode;
  set mode(LockMode value);
  bool get ifAvailable;
  set ifAvailable(bool value);
  bool get steal;
  set steal(bool value);
  AbortSignal get signal;
  set signal(AbortSignal value);
}

abstract interface class NavigatorLocks {
  LockManager get locks;
}

