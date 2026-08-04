// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: compression
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';

typedef CompressionFormat = String;

abstract interface class CompressionStream {
  ReadableStream get readable;
  WritableStream get writable;
}

abstract interface class DecompressionStream {
  ReadableStream get readable;
  WritableStream get writable;
}

