// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: compression
// ignore_for_file: type=lint

import 'streams.dart';
import 'package:react_web/src/web_runtime.dart';

typedef CompressionFormat = String;

abstract interface class CompressionStream {
  factory CompressionStream(CompressionFormat format) =>
      WebRuntime.current.createWebObject<CompressionStream>(
        'CompressionStream',
        [format],
      );
  ReadableStream get readable;
  WritableStream get writable;
}

abstract interface class DecompressionStream {
  factory DecompressionStream(CompressionFormat format) =>
      WebRuntime.current.createWebObject<DecompressionStream>(
        'DecompressionStream',
        [format],
      );
  ReadableStream get readable;
  WritableStream get writable;
}

