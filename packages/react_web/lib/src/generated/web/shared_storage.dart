// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: shared-storage
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class HTMLSharedStorageWritableElementUtils {
  bool get sharedStorageWritable;
   set sharedStorageWritable(bool value);
}

typedef RunFunctionForSharedStorageSelectURLOperation = Future<int> Function(List<String> urls, Object data,);

typedef SharedStorageResponse = Object;

abstract interface class SharedStorageRunOperationMethodOptions {
  Object? get data;
  set data(Object? value);
  bool? get resolveToConfig;
  set resolveToConfig(bool? value);
  bool? get keepAlive;
  set keepAlive(bool? value);
}

final class SharedStorageRunOperationMethodOptionsValue implements SharedStorageRunOperationMethodOptions {
  @override
  Object? data;
  @override
  bool? resolveToConfig;
  @override
  bool? keepAlive;

  SharedStorageRunOperationMethodOptionsValue({
    this.data,
    this.resolveToConfig,
    this.keepAlive,
  });
}

abstract interface class SharedStorageSetMethodOptions {
  bool? get ignoreIfPresent;
  set ignoreIfPresent(bool? value);
}

final class SharedStorageSetMethodOptionsValue implements SharedStorageSetMethodOptions {
  @override
  bool? ignoreIfPresent;

  SharedStorageSetMethodOptionsValue({
    this.ignoreIfPresent,
  });
}

abstract interface class SharedStorageUrlWithMetadata {
  String get url;
  set url(String value);
  Object? get reportingMetadata;
  set reportingMetadata(Object? value);
}

final class SharedStorageUrlWithMetadataValue implements SharedStorageUrlWithMetadata {
  @override
  String url;
  @override
  Object? reportingMetadata;

  SharedStorageUrlWithMetadataValue({
    required this.url,
    this.reportingMetadata,
  });
}

