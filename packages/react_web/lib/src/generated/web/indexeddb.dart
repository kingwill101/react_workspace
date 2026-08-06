// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: IndexedDB
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'webidl.dart';
import 'dom.dart';
import 'webcryptoapi.dart';
import 'fetch.dart';
import 'attribution_reporting_api.dart';
import 'event_timing.dart';
import 'scheduling_apis.dart';
import 'service_workers.dart';
import 'trusted_types.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class IDBCursor {
  Object get source;
  IDBCursorDirection get direction;
  Object get key;
  Object get primaryKey;
  IDBRequest get request;
  void advance(int count);
  void continue_([Object? key]);
  void continuePrimaryKey(Object key, Object primaryKey);
  IDBRequest update(Object value);
  IDBRequest delete();
}

typedef IDBCursorDirection = String;

abstract interface class IDBCursorWithValue {
  Object get value;
}

abstract interface class IDBDatabase {
  String get name;
  int get version;
  DOMStringList get objectStoreNames;
  IDBTransaction transaction(Object storeNames, [IDBTransactionMode? mode, IDBTransactionOptions? options]);
  void close();
  IDBObjectStore createObjectStore(String name, [IDBObjectStoreParameters? options]);
  void deleteObjectStore(String name);
  EventHandler get onabort;
   set onabort(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onversionchange;
   set onversionchange(EventHandler value);
}

abstract interface class IDBDatabaseInfo {
  String? get name;
  set name(String? value);
  int? get version;
  set version(int? value);
}

final class IDBDatabaseInfoValue implements IDBDatabaseInfo {
  @override
  String? name;
  @override
  int? version;

  IDBDatabaseInfoValue({
    this.name,
    this.version,
  });
}

abstract interface class IDBFactory {
  IDBOpenDBRequest open(String name, [int? version]);
  IDBOpenDBRequest deleteDatabase(String name);
  Future<List<IDBDatabaseInfo>> databases();
  int cmp(Object first, Object second);
}

abstract interface class IDBIndex {
  String get name;
   set name(String value);
  IDBObjectStore get objectStore;
  Object get keyPath;
  bool get multiEntry;
  bool get unique;
  IDBRequest get_(Object query);
  IDBRequest getKey(Object query);
  IDBRequest getAll([Object? query, int? count]);
  IDBRequest getAllKeys([Object? query, int? count]);
  IDBRequest count([Object? query]);
  IDBRequest openCursor([Object? query, IDBCursorDirection? direction]);
  IDBRequest openKeyCursor([Object? query, IDBCursorDirection? direction]);
}

abstract interface class IDBIndexParameters {
  bool? get unique;
  set unique(bool? value);
  bool? get multiEntry;
  set multiEntry(bool? value);
}

final class IDBIndexParametersValue implements IDBIndexParameters {
  @override
  bool? unique;
  @override
  bool? multiEntry;

  IDBIndexParametersValue({
    this.unique,
    this.multiEntry,
  });
}

abstract interface class IDBKeyRange {
  Object get lower;
  Object get upper;
  bool get lowerOpen;
  bool get upperOpen;
  bool includes(Object key);
}

abstract interface class IDBObjectStore {
  String get name;
   set name(String value);
  Object get keyPath;
  DOMStringList get indexNames;
  IDBTransaction get transaction;
  bool get autoIncrement;
  IDBRequest put(Object value, [Object? key]);
  IDBRequest add(Object value, [Object? key]);
  IDBRequest delete(Object query);
  IDBRequest clear();
  IDBRequest get_(Object query);
  IDBRequest getKey(Object query);
  IDBRequest getAll([Object? query, int? count]);
  IDBRequest getAllKeys([Object? query, int? count]);
  IDBRequest count([Object? query]);
  IDBRequest openCursor([Object? query, IDBCursorDirection? direction]);
  IDBRequest openKeyCursor([Object? query, IDBCursorDirection? direction]);
  IDBIndex index(String name);
  IDBIndex createIndex(String name, Object keyPath, [IDBIndexParameters? options]);
  void deleteIndex(String name);
}

abstract interface class IDBObjectStoreParameters {
  Object? get keyPath;
  set keyPath(Object? value);
  bool? get autoIncrement;
  set autoIncrement(bool? value);
}

final class IDBObjectStoreParametersValue implements IDBObjectStoreParameters {
  @override
  Object? keyPath;
  @override
  bool? autoIncrement;

  IDBObjectStoreParametersValue({
    this.keyPath,
    this.autoIncrement,
  });
}

abstract interface class IDBOpenDBRequest {
  EventHandler get onblocked;
   set onblocked(EventHandler value);
  EventHandler get onupgradeneeded;
   set onupgradeneeded(EventHandler value);
}

abstract interface class IDBRequest {
  Object get result;
  DOMException? get error;
  Object get source;
  IDBTransaction? get transaction;
  IDBRequestReadyState get readyState;
  EventHandler get onsuccess;
   set onsuccess(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
}

typedef IDBRequestReadyState = String;

abstract interface class IDBTransaction {
  DOMStringList get objectStoreNames;
  IDBTransactionMode get mode;
  IDBTransactionDurability get durability;
  IDBDatabase get db;
  DOMException? get error;
  IDBObjectStore objectStore(String name);
  void commit();
  void abort();
  EventHandler get onabort;
   set onabort(EventHandler value);
  EventHandler get oncomplete;
   set oncomplete(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
}

typedef IDBTransactionDurability = String;

typedef IDBTransactionMode = String;

abstract interface class IDBTransactionOptions {
  IDBTransactionDurability? get durability;
  set durability(IDBTransactionDurability? value);
}

final class IDBTransactionOptionsValue implements IDBTransactionOptions {
  @override
  IDBTransactionDurability? durability;

  IDBTransactionOptionsValue({
    this.durability,
  });
}

abstract interface class IDBVersionChangeEvent {
  factory IDBVersionChangeEvent(String type, [IDBVersionChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<IDBVersionChangeEvent>(
        'IDBVersionChangeEvent',
        [type, eventInitDict],
      );
  int get oldVersion;
  int? get newVersion;
}

abstract interface class IDBVersionChangeEventInit {
  int? get oldVersion;
  set oldVersion(int? value);
  int? get newVersion;
  set newVersion(int? value);
}

final class IDBVersionChangeEventInitValue implements IDBVersionChangeEventInit {
  @override
  int? oldVersion;
  @override
  int? newVersion;

  IDBVersionChangeEventInitValue({
    this.oldVersion,
    this.newVersion,
  });
}

abstract interface class WindowOrWorkerGlobalScope {
  IDBFactory get indexedDB;
  Crypto get crypto;
  Future<Response> fetch(RequestInfo input, [RequestInit? init]);
  Performance get performance;
  String get origin;
  bool get isSecureContext;
  bool get crossOriginIsolated;
  void reportError(Object e);
  String btoa(String data);
  String atob(String data);
  int setTimeout(TimerHandler handler, [int? timeout, List<Object>? arguments]);
  void clearTimeout([int? id]);
  int setInterval(TimerHandler handler, [int? timeout, List<Object>? arguments]);
  void clearInterval([int? id]);
  void queueMicrotask(VoidFunction callback);
  Future<ImageBitmap> createImageBitmap(ImageBitmapSource image, int sx, int sy, int sw, int sh, [ImageBitmapOptions? options]);
  Object structuredClone(Object value, [StructuredSerializeOptions? options]);
  Scheduler get scheduler;
  CacheStorage get caches;
  TrustedTypePolicyFactory get trustedTypes;
}

