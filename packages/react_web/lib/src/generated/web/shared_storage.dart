// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: shared-storage
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'private_aggregation_api.dart';
import 'turtledove.dart';
import 'web_locks.dart';
import 'html.dart';

abstract interface class HTMLSharedStorageWritableElementUtils {
  bool get sharedStorageWritable;
   set sharedStorageWritable(bool value);
}

typedef RunFunctionForSharedStorageSelectURLOperation = Future<int> Function(List<String> urls, Object data,);

abstract interface class SharedStorage {
  Future<Object> set_(String key, String value, [SharedStorageSetMethodOptions? options]);
  Future<Object> append(String key, String value, [SharedStorageModifierMethodOptions? options]);
  Future<Object> delete(String key, [SharedStorageModifierMethodOptions? options]);
  Future<Object> clear([SharedStorageModifierMethodOptions? options]);
  Future<Object> batchUpdate(List<SharedStorageModifierMethod> methods, [SharedStorageModifierMethodOptions? options]);
  Future<SharedStorageResponse> selectURL(String name, List<SharedStorageUrlWithMetadata> urls, [SharedStorageRunOperationMethodOptions? options]);
  Future<Object> run(String name, [SharedStorageRunOperationMethodOptions? options]);
  Future<SharedStorageWorklet> createWorklet(String moduleURL, [SharedStorageWorkletOptions? options]);
  SharedStorageWorklet get worklet;
  Future<String> get_(String key);
  Future<int> length();
  Future<double> remainingBudget();
   Iterable<(String, String)> get entries;
   Iterable<String> get keys;
   Iterable<String> get values;
}

abstract interface class SharedStorageAppendMethod {
}

abstract interface class SharedStorageClearMethod {
}

abstract interface class SharedStorageDeleteMethod {
}

abstract interface class SharedStorageModifierMethod {
}

abstract interface class SharedStorageModifierMethodOptions {
  String get withLock;
  set withLock(String value);
}

abstract interface class SharedStoragePrivateAggregationConfig {
  String get aggregationCoordinatorOrigin;
  set aggregationCoordinatorOrigin(String value);
  String get contextId;
  set contextId(String value);
  int get filteringIdMaxBytes;
  set filteringIdMaxBytes(int value);
  int get maxContributions;
  set maxContributions(int value);
}

typedef SharedStorageResponse = Object;

abstract interface class SharedStorageRunOperationMethodOptions {
  Object get data;
  set data(Object value);
  bool get resolveToConfig;
  set resolveToConfig(bool value);
  bool get keepAlive;
  set keepAlive(bool value);
  SharedStoragePrivateAggregationConfig get privateAggregationConfig;
  set privateAggregationConfig(SharedStoragePrivateAggregationConfig value);
  String get savedQuery;
  set savedQuery(String value);
}

abstract interface class SharedStorageSetMethod {
}

abstract interface class SharedStorageSetMethodOptions {
  bool get ignoreIfPresent;
  set ignoreIfPresent(bool value);
}

abstract interface class SharedStorageUrlWithMetadata {
  String get url;
  set url(String value);
  Object get reportingMetadata;
  set reportingMetadata(Object value);
}

abstract interface class SharedStorageWorklet {
  Future<SharedStorageResponse> selectURL(String name, List<SharedStorageUrlWithMetadata> urls, [SharedStorageRunOperationMethodOptions? options]);
  Future<Object> run(String name, [SharedStorageRunOperationMethodOptions? options]);
}

abstract interface class SharedStorageWorkletGlobalScope {
  void register(String name, Function operationCtor);
  SharedStorage get sharedStorage;
  PrivateAggregation get privateAggregation;
  Future<List<StorageInterestGroup>> interestGroups();
  SharedStorageWorkletNavigator get navigator;
}

abstract interface class SharedStorageWorkletNavigator {
  LockManager get locks;
}

abstract interface class SharedStorageWorkletOptions {
  String get dataOrigin;
  set dataOrigin(String value);
}

