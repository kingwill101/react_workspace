// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: push-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';
import 'permissions.dart';
import 'fileapi.dart';
import 'hr_time.dart';
import 'webidl.dart';

typedef PushEncryptionKeyName = String;

abstract interface class PushEvent {
  PushMessageData? get data;
}

abstract interface class PushEventInit {
  PushMessageDataInit get data;
  set data(PushMessageDataInit value);
}

abstract interface class PushManager {
  Future<PushSubscription> subscribe([PushSubscriptionOptionsInit? options]);
  Future<PushSubscription?> getSubscription();
  Future<PermissionState> permissionState([PushSubscriptionOptionsInit? options]);
}

abstract interface class PushMessageData {
  Object arrayBuffer();
  Blob blob();
  Object bytes();
  Object json();
  String text();
}

typedef PushMessageDataInit = Object;

abstract interface class PushPermissionDescriptor {
  bool get userVisibleOnly;
  set userVisibleOnly(bool value);
}

abstract interface class PushSubscription {
  String get endpoint;
  EpochTimeStamp? get expirationTime;
  PushSubscriptionOptions get options;
  Object getKey(PushEncryptionKeyName name);
  Future<bool> unsubscribe();
  PushSubscriptionJSON toJSON();
}

abstract interface class PushSubscriptionChangeEvent {
  PushSubscription? get newSubscription;
  PushSubscription? get oldSubscription;
}

abstract interface class PushSubscriptionChangeEventInit {
  PushSubscription get newSubscription;
  set newSubscription(PushSubscription value);
  PushSubscription get oldSubscription;
  set oldSubscription(PushSubscription value);
}

abstract interface class PushSubscriptionJSON {
  String get endpoint;
  set endpoint(String value);
  EpochTimeStamp? get expirationTime;
  set expirationTime(EpochTimeStamp? value);
  Map<String, String> get keys;
  set keys(Map<String, String> value);
}

abstract interface class PushSubscriptionOptions {
  bool get userVisibleOnly;
  Object get applicationServerKey;
}

abstract interface class PushSubscriptionOptionsInit {
  bool get userVisibleOnly;
  set userVisibleOnly(bool value);
  Object get applicationServerKey;
  set applicationServerKey(Object value);
}

