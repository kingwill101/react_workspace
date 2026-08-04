// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: background-sync
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';

abstract interface class SyncEvent {
  String get tag;
  bool get lastChance;
}

abstract interface class SyncEventInit {
  String get tag;
  set tag(String value);
  bool get lastChance;
  set lastChance(bool value);
}

abstract interface class SyncManager {
  Future<void> register(String tag);
  Future<List<String>> getTags();
}

