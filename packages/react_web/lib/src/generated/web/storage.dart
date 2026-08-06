// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: storage
// ignore_for_file: type=lint

import 'fs.dart';

abstract interface class NavigatorStorage {
  StorageManager get storage;
}

abstract interface class StorageEstimate {
  int? get usage;
  set usage(int? value);
  int? get quota;
  set quota(int? value);
}

final class StorageEstimateValue implements StorageEstimate {
  @override
  int? usage;
  @override
  int? quota;

  StorageEstimateValue({
    this.usage,
    this.quota,
  });
}

