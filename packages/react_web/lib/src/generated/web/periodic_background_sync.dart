// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: periodic-background-sync
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';

abstract interface class BackgroundSyncOptions {
  int? get minInterval;
  set minInterval(int? value);
}

final class BackgroundSyncOptionsValue implements BackgroundSyncOptions {
  @override
  int? minInterval;

  BackgroundSyncOptionsValue({
    this.minInterval,
  });
}

abstract interface class PeriodicSyncEventInit {
  String get tag;
  set tag(String value);
}

final class PeriodicSyncEventInitValue implements PeriodicSyncEventInit {
  @override
  String tag;

  PeriodicSyncEventInitValue({
    required this.tag,
  });
}

