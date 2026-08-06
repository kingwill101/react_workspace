// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: storage-buckets
// ignore_for_file: type=lint

import 'hr_time.dart';

abstract interface class NavigatorStorageBuckets {
  Object get storageBuckets;
}

abstract interface class StorageBucketOptions {
  bool? get persisted;
  set persisted(bool? value);
  int? get quota;
  set quota(int? value);
  DOMHighResTimeStamp? get expires;
  set expires(DOMHighResTimeStamp? value);
}

final class StorageBucketOptionsValue implements StorageBucketOptions {
  @override
  bool? persisted;
  @override
  int? quota;
  @override
  DOMHighResTimeStamp? expires;

  StorageBucketOptionsValue({
    this.persisted,
    this.quota,
    this.expires,
  });
}

