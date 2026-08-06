// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: saa-non-cookie-storage
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'indexeddb.dart';
import 'web_locks.dart';
import 'service_workers.dart';
import 'fs.dart';
import 'storage.dart';
import 'fileapi.dart';
import 'media_source.dart';

typedef SameSiteCookiesType = String;

abstract interface class SharedWorkerOptions {
  SameSiteCookiesType? get sameSiteCookies;
  set sameSiteCookies(SameSiteCookiesType? value);
}

final class SharedWorkerOptionsValue implements SharedWorkerOptions {
  @override
  SameSiteCookiesType? sameSiteCookies;

  SharedWorkerOptionsValue({
    this.sameSiteCookies,
  });
}

abstract interface class StorageAccessHandle {
  Storage get sessionStorage;
  Storage get localStorage;
  IDBFactory get indexedDB;
  LockManager get locks;
  CacheStorage get caches;
  Future<FileSystemDirectoryHandle> getDirectory();
  Future<StorageEstimate> estimate();
  String createObjectURL(Object obj);
  void revokeObjectURL(String url);
}

abstract interface class StorageAccessTypes {
  bool? get all;
  set all(bool? value);
  bool? get cookies;
  set cookies(bool? value);
  bool? get sessionStorage;
  set sessionStorage(bool? value);
  bool? get localStorage;
  set localStorage(bool? value);
  bool? get indexedDB;
  set indexedDB(bool? value);
  bool? get locks;
  set locks(bool? value);
  bool? get caches;
  set caches(bool? value);
  bool? get getDirectory;
  set getDirectory(bool? value);
  bool? get estimate;
  set estimate(bool? value);
  bool? get createObjectURL;
  set createObjectURL(bool? value);
  bool? get revokeObjectURL;
  set revokeObjectURL(bool? value);
  bool? get BroadcastChannel;
  set BroadcastChannel(bool? value);
  bool? get SharedWorker;
  set SharedWorker(bool? value);
}

final class StorageAccessTypesValue implements StorageAccessTypes {
  @override
  bool? all;
  @override
  bool? cookies;
  @override
  bool? sessionStorage;
  @override
  bool? localStorage;
  @override
  bool? indexedDB;
  @override
  bool? locks;
  @override
  bool? caches;
  @override
  bool? getDirectory;
  @override
  bool? estimate;
  @override
  bool? createObjectURL;
  @override
  bool? revokeObjectURL;
  @override
  bool? BroadcastChannel;
  @override
  bool? SharedWorker;

  StorageAccessTypesValue({
    this.all,
    this.cookies,
    this.sessionStorage,
    this.localStorage,
    this.indexedDB,
    this.locks,
    this.caches,
    this.getDirectory,
    this.estimate,
    this.createObjectURL,
    this.revokeObjectURL,
    this.BroadcastChannel,
    this.SharedWorker,
  });
}

