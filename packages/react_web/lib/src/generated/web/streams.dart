// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: streams
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class ByteLengthQueuingStrategy {
  factory ByteLengthQueuingStrategy(QueuingStrategyInit init) =>
      WebRuntime.current.createWebObject<ByteLengthQueuingStrategy>(
        'ByteLengthQueuingStrategy',
        [init],
      );
  double get highWaterMark;
  Function get size;
}

abstract interface class CountQueuingStrategy {
  factory CountQueuingStrategy(QueuingStrategyInit init) =>
      WebRuntime.current.createWebObject<CountQueuingStrategy>(
        'CountQueuingStrategy',
        [init],
      );
  double get highWaterMark;
  Function get size;
}

abstract interface class GenericTransformStream {
  ReadableStream get readable;
  WritableStream get writable;
}

abstract interface class QueuingStrategy {
  double get highWaterMark;
  set highWaterMark(double value);
  QueuingStrategySize get size;
  set size(QueuingStrategySize value);
}

abstract interface class QueuingStrategyInit {
  double get highWaterMark;
  set highWaterMark(double value);
}

typedef QueuingStrategySize = double Function(Object chunk,);

abstract interface class ReadableByteStreamController {
  ReadableStreamBYOBRequest? get byobRequest;
  double? get desiredSize;
  void close();
  void enqueue(ArrayBufferView chunk);
  void error([Object? e]);
}

abstract interface class ReadableStream {
  factory ReadableStream([Object? underlyingSource, QueuingStrategy? strategy]) =>
      WebRuntime.current.createWebObject<ReadableStream>(
        'ReadableStream',
        [underlyingSource, strategy],
      );
  bool get locked;
  Future<void> cancel([Object? reason]);
  ReadableStreamReader getReader([ReadableStreamGetReaderOptions? options]);
  ReadableStream pipeThrough(ReadableWritablePair transform, [StreamPipeOptions? options]);
  Future<void> pipeTo(WritableStream destination, [StreamPipeOptions? options]);
  List<ReadableStream> tee();
}

abstract interface class ReadableStreamBYOBReader {
  factory ReadableStreamBYOBReader(ReadableStream stream) =>
      WebRuntime.current.createWebObject<ReadableStreamBYOBReader>(
        'ReadableStreamBYOBReader',
        [stream],
      );
  Future<void> get closed;
  Future<void> cancel([Object? reason]);
  Future<ReadableStreamReadResult> read(ArrayBufferView view, [ReadableStreamBYOBReaderReadOptions? options]);
  void releaseLock();
}

abstract interface class ReadableStreamBYOBReaderReadOptions {
  int get min;
  set min(int value);
}

abstract interface class ReadableStreamBYOBRequest {
  ArrayBufferView? get view;
  void respond(int bytesWritten);
  void respondWithNewView(ArrayBufferView view);
}

typedef ReadableStreamController = Object;

abstract interface class ReadableStreamDefaultController {
  double? get desiredSize;
  void close();
  void enqueue([Object? chunk]);
  void error([Object? e]);
}

abstract interface class ReadableStreamDefaultReader {
  factory ReadableStreamDefaultReader(ReadableStream stream) =>
      WebRuntime.current.createWebObject<ReadableStreamDefaultReader>(
        'ReadableStreamDefaultReader',
        [stream],
      );
  Future<void> get closed;
  Future<void> cancel([Object? reason]);
  Future<ReadableStreamReadResult> read();
  void releaseLock();
}

abstract interface class ReadableStreamGenericReader {
  Future<void> get closed;
  Future<void> cancel([Object? reason]);
}

abstract interface class ReadableStreamGetReaderOptions {
  ReadableStreamReaderMode get mode;
  set mode(ReadableStreamReaderMode value);
}

abstract interface class ReadableStreamIteratorOptions {
  bool get preventCancel;
  set preventCancel(bool value);
}

abstract interface class ReadableStreamReadResult {
  Object get value;
  set value(Object value);
  bool get done;
  set done(bool value);
}

typedef ReadableStreamReader = Object;

typedef ReadableStreamReaderMode = String;

typedef ReadableStreamType = String;

abstract interface class ReadableWritablePair {
  ReadableStream get readable;
  set readable(ReadableStream value);
  WritableStream get writable;
  set writable(WritableStream value);
}

abstract interface class StreamPipeOptions {
  bool get preventClose;
  set preventClose(bool value);
  bool get preventAbort;
  set preventAbort(bool value);
  bool get preventCancel;
  set preventCancel(bool value);
  AbortSignal get signal;
  set signal(AbortSignal value);
}

abstract interface class TransformStream {
  factory TransformStream([Object? transformer, QueuingStrategy? writableStrategy, QueuingStrategy? readableStrategy]) =>
      WebRuntime.current.createWebObject<TransformStream>(
        'TransformStream',
        [transformer, writableStrategy, readableStrategy],
      );
  ReadableStream get readable;
  WritableStream get writable;
}

abstract interface class TransformStreamDefaultController {
  double? get desiredSize;
  void enqueue([Object? chunk]);
  void error([Object? reason]);
  void terminate();
}

abstract interface class Transformer {
  TransformerStartCallback get start;
  set start(TransformerStartCallback value);
  TransformerTransformCallback get transform;
  set transform(TransformerTransformCallback value);
  TransformerFlushCallback get flush;
  set flush(TransformerFlushCallback value);
  TransformerCancelCallback get cancel;
  set cancel(TransformerCancelCallback value);
  Object get readableType;
  set readableType(Object value);
  Object get writableType;
  set writableType(Object value);
}

typedef TransformerCancelCallback = Future<void> Function(Object reason,);

typedef TransformerFlushCallback = Future<void> Function(TransformStreamDefaultController controller,);

typedef TransformerStartCallback = Object Function(TransformStreamDefaultController controller,);

typedef TransformerTransformCallback = Future<void> Function(Object chunk, TransformStreamDefaultController controller,);

abstract interface class UnderlyingSink {
  UnderlyingSinkStartCallback get start;
  set start(UnderlyingSinkStartCallback value);
  UnderlyingSinkWriteCallback get write;
  set write(UnderlyingSinkWriteCallback value);
  UnderlyingSinkCloseCallback get close;
  set close(UnderlyingSinkCloseCallback value);
  UnderlyingSinkAbortCallback get abort;
  set abort(UnderlyingSinkAbortCallback value);
  Object get type;
  set type(Object value);
}

typedef UnderlyingSinkAbortCallback = Future<void> Function(Object reason,);

typedef UnderlyingSinkCloseCallback = Future<void> Function();

typedef UnderlyingSinkStartCallback = Object Function(WritableStreamDefaultController controller,);

typedef UnderlyingSinkWriteCallback = Future<void> Function(Object chunk, WritableStreamDefaultController controller,);

abstract interface class UnderlyingSource {
  UnderlyingSourceStartCallback get start;
  set start(UnderlyingSourceStartCallback value);
  UnderlyingSourcePullCallback get pull;
  set pull(UnderlyingSourcePullCallback value);
  UnderlyingSourceCancelCallback get cancel;
  set cancel(UnderlyingSourceCancelCallback value);
  ReadableStreamType get type;
  set type(ReadableStreamType value);
  int get autoAllocateChunkSize;
  set autoAllocateChunkSize(int value);
}

typedef UnderlyingSourceCancelCallback = Future<void> Function(Object reason,);

typedef UnderlyingSourcePullCallback = Future<void> Function(ReadableStreamController controller,);

typedef UnderlyingSourceStartCallback = Object Function(ReadableStreamController controller,);

abstract interface class WritableStream {
  factory WritableStream([Object? underlyingSink, QueuingStrategy? strategy]) =>
      WebRuntime.current.createWebObject<WritableStream>(
        'WritableStream',
        [underlyingSink, strategy],
      );
  bool get locked;
  Future<void> abort([Object? reason]);
  Future<void> close();
  WritableStreamDefaultWriter getWriter();
}

abstract interface class WritableStreamDefaultController {
  AbortSignal get signal;
  void error([Object? e]);
}

abstract interface class WritableStreamDefaultWriter {
  factory WritableStreamDefaultWriter(WritableStream stream) =>
      WebRuntime.current.createWebObject<WritableStreamDefaultWriter>(
        'WritableStreamDefaultWriter',
        [stream],
      );
  Future<void> get closed;
  double? get desiredSize;
  Future<void> get ready;
  Future<void> abort([Object? reason]);
  Future<void> close();
  void releaseLock();
  Future<void> write([Object? chunk]);
}

