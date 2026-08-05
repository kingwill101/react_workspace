// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: encoding
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'streams.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class TextDecodeOptions {
  bool get stream;
  set stream(bool value);
}

abstract interface class TextDecoder {
  factory TextDecoder([String? label, TextDecoderOptions? options]) =>
      WebRuntime.current.createWebObject<TextDecoder>(
        'TextDecoder',
        [label, options],
      );
  String get encoding;
  bool get fatal;
  bool get ignoreBOM;
  String decode([AllowSharedBufferSource? input, TextDecodeOptions? options]);
}

abstract interface class TextDecoderCommon {
  String get encoding;
  bool get fatal;
  bool get ignoreBOM;
}

abstract interface class TextDecoderOptions {
  bool get fatal;
  set fatal(bool value);
  bool get ignoreBOM;
  set ignoreBOM(bool value);
}

abstract interface class TextDecoderStream {
  factory TextDecoderStream([String? label, TextDecoderOptions? options]) =>
      WebRuntime.current.createWebObject<TextDecoderStream>(
        'TextDecoderStream',
        [label, options],
      );
  String get encoding;
  bool get fatal;
  bool get ignoreBOM;
  ReadableStream get readable;
  WritableStream get writable;
}

abstract interface class TextEncoder {
  factory TextEncoder() =>
      WebRuntime.current.createWebObject<TextEncoder>(
        'TextEncoder',
        [],
      );
  String get encoding;
  Object encode([String? input]);
  TextEncoderEncodeIntoResult encodeInto(String source, Object destination);
}

abstract interface class TextEncoderCommon {
  String get encoding;
}

abstract interface class TextEncoderEncodeIntoResult {
  int get read;
  set read(int value);
  int get written;
  set written(int value);
}

abstract interface class TextEncoderStream {
  factory TextEncoderStream() =>
      WebRuntime.current.createWebObject<TextEncoderStream>(
        'TextEncoderStream',
        [],
      );
  String get encoding;
  ReadableStream get readable;
  WritableStream get writable;
}

