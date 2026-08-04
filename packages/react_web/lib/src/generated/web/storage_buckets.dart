// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: storage-buckets
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'storage.dart';
import 'hr_time.dart';
import 'indexeddb.dart';
import 'service_workers.dart';
import 'fs.dart';

abstract interface class NavigatorStorageBuckets {
  StorageBucketManager get storageBuckets;
}

abstract interface class StorageBucket {
  String get name;
  Future<bool> persist();
  Future<bool> persisted();
  Future<StorageEstimate> estimate();
  Future<void> setExpires(DOMHighResTimeStamp expires);
  Future<DOMHighResTimeStamp?> expires();
  IDBFactory get indexedDB;
  CacheStorage get caches;
  Future<FileSystemDirectoryHandle> getDirectory();
}

abstract interface class StorageBucketManager {
  Future<StorageBucket> open(String name, [StorageBucketOptions? options]);
  Future<List<String>> keys();
  Future<void> delete(String name);
}

abstract interface class StorageBucketOptions {
  bool get persisted;
  set persisted(bool value);
  int get quota;
  set quota(int value);
  DOMHighResTimeStamp get expires;
  set expires(DOMHighResTimeStamp value);
}

