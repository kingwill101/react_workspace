// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: background-sync
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class SyncEvent {
  factory SyncEvent(String type, SyncEventInit init) =>
      WebRuntime.current.createWebObject<SyncEvent>(
        'SyncEvent',
        [type, init],
      );
  String get tag;
  bool get lastChance;
}

abstract interface class SyncEventInit {
  String get tag;
  set tag(String value);
  bool? get lastChance;
  set lastChance(bool? value);
}

final class SyncEventInitValue implements SyncEventInit {
  @override
  String tag;
  @override
  bool? lastChance;

  SyncEventInitValue({
    required this.tag,
    this.lastChance,
  });
}

abstract interface class SyncManager {
  Future<void> register(String tag);
  Future<List<String>> getTags();
}

