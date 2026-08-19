// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: streams
// ignore_for_file: type=lint

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
  double? get highWaterMark;
  set highWaterMark(double? value);
  QueuingStrategySize? get size;
  set size(QueuingStrategySize? value);
}

final class QueuingStrategyValue implements QueuingStrategy {
  @override
  double? highWaterMark;
  @override
  QueuingStrategySize? size;

  QueuingStrategyValue({
    this.highWaterMark,
    this.size,
  });
}

abstract interface class QueuingStrategyInit {
  double get highWaterMark;
  set highWaterMark(double value);
}

final class QueuingStrategyInitValue implements QueuingStrategyInit {
  @override
  double highWaterMark;

  QueuingStrategyInitValue({
    required this.highWaterMark,
  });
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
  int? get min;
  set min(int? value);
}

final class ReadableStreamBYOBReaderReadOptionsValue implements ReadableStreamBYOBReaderReadOptions {
  @override
  int? min;

  ReadableStreamBYOBReaderReadOptionsValue({
    this.min,
  });
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
  ReadableStreamReaderMode? get mode;
  set mode(ReadableStreamReaderMode? value);
}

final class ReadableStreamGetReaderOptionsValue implements ReadableStreamGetReaderOptions {
  @override
  ReadableStreamReaderMode? mode;

  ReadableStreamGetReaderOptionsValue({
    this.mode,
  });
}

abstract interface class ReadableStreamIteratorOptions {
  bool? get preventCancel;
  set preventCancel(bool? value);
}

final class ReadableStreamIteratorOptionsValue implements ReadableStreamIteratorOptions {
  @override
  bool? preventCancel;

  ReadableStreamIteratorOptionsValue({
    this.preventCancel,
  });
}

abstract interface class ReadableStreamReadResult {
  Object? get value;
  set value(Object? value);
  bool? get done;
  set done(bool? value);
}

final class ReadableStreamReadResultValue implements ReadableStreamReadResult {
  @override
  Object? value;
  @override
  bool? done;

  ReadableStreamReadResultValue({
    this.value,
    this.done,
  });
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

final class ReadableWritablePairValue implements ReadableWritablePair {
  @override
  ReadableStream readable;
  @override
  WritableStream writable;

  ReadableWritablePairValue({
    required this.readable,
    required this.writable,
  });
}

abstract interface class StreamPipeOptions {
  bool? get preventClose;
  set preventClose(bool? value);
  bool? get preventAbort;
  set preventAbort(bool? value);
  bool? get preventCancel;
  set preventCancel(bool? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class StreamPipeOptionsValue implements StreamPipeOptions {
  @override
  bool? preventClose;
  @override
  bool? preventAbort;
  @override
  bool? preventCancel;
  @override
  AbortSignal? signal;

  StreamPipeOptionsValue({
    this.preventClose,
    this.preventAbort,
    this.preventCancel,
    this.signal,
  });
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
  TransformerStartCallback? get start;
  set start(TransformerStartCallback? value);
  TransformerTransformCallback? get transform;
  set transform(TransformerTransformCallback? value);
  TransformerFlushCallback? get flush;
  set flush(TransformerFlushCallback? value);
  TransformerCancelCallback? get cancel;
  set cancel(TransformerCancelCallback? value);
  Object? get readableType;
  set readableType(Object? value);
  Object? get writableType;
  set writableType(Object? value);
}

final class TransformerValue implements Transformer {
  @override
  TransformerStartCallback? start;
  @override
  TransformerTransformCallback? transform;
  @override
  TransformerFlushCallback? flush;
  @override
  TransformerCancelCallback? cancel;
  @override
  Object? readableType;
  @override
  Object? writableType;

  TransformerValue({
    this.start,
    this.transform,
    this.flush,
    this.cancel,
    this.readableType,
    this.writableType,
  });
}

typedef TransformerCancelCallback = Future<void> Function(Object reason,);

typedef TransformerFlushCallback = Future<void> Function(TransformStreamDefaultController controller,);

typedef TransformerStartCallback = Object Function(TransformStreamDefaultController controller,);

typedef TransformerTransformCallback = Future<void> Function(Object chunk, TransformStreamDefaultController controller,);

abstract interface class UnderlyingSink {
  UnderlyingSinkStartCallback? get start;
  set start(UnderlyingSinkStartCallback? value);
  UnderlyingSinkWriteCallback? get write;
  set write(UnderlyingSinkWriteCallback? value);
  UnderlyingSinkCloseCallback? get close;
  set close(UnderlyingSinkCloseCallback? value);
  UnderlyingSinkAbortCallback? get abort;
  set abort(UnderlyingSinkAbortCallback? value);
  Object? get type_;
  set type_(Object? value);
}

final class UnderlyingSinkValue implements UnderlyingSink {
  @override
  UnderlyingSinkStartCallback? start;
  @override
  UnderlyingSinkWriteCallback? write;
  @override
  UnderlyingSinkCloseCallback? close;
  @override
  UnderlyingSinkAbortCallback? abort;
  @override
  Object? type_;

  UnderlyingSinkValue({
    this.start,
    this.write,
    this.close,
    this.abort,
    this.type_,
  });
}

typedef UnderlyingSinkAbortCallback = Future<void> Function(Object reason,);

typedef UnderlyingSinkCloseCallback = Future<void> Function();

typedef UnderlyingSinkStartCallback = Object Function(WritableStreamDefaultController controller,);

typedef UnderlyingSinkWriteCallback = Future<void> Function(Object chunk, WritableStreamDefaultController controller,);

abstract interface class UnderlyingSource {
  UnderlyingSourceStartCallback? get start;
  set start(UnderlyingSourceStartCallback? value);
  UnderlyingSourcePullCallback? get pull;
  set pull(UnderlyingSourcePullCallback? value);
  UnderlyingSourceCancelCallback? get cancel;
  set cancel(UnderlyingSourceCancelCallback? value);
  ReadableStreamType? get type_;
  set type_(ReadableStreamType? value);
  int? get autoAllocateChunkSize;
  set autoAllocateChunkSize(int? value);
}

final class UnderlyingSourceValue implements UnderlyingSource {
  @override
  UnderlyingSourceStartCallback? start;
  @override
  UnderlyingSourcePullCallback? pull;
  @override
  UnderlyingSourceCancelCallback? cancel;
  @override
  ReadableStreamType? type_;
  @override
  int? autoAllocateChunkSize;

  UnderlyingSourceValue({
    this.start,
    this.pull,
    this.cancel,
    this.type_,
    this.autoAllocateChunkSize,
  });
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

