// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webcodecs
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'webcodecs_aac_codec_registration.dart';
import 'streams.dart';
import 'html.dart';
import 'webcodecs_avc_codec_registration.dart';
import 'webcodecs_av1_codec_registration.dart';
import 'geometry.dart';
import 'package:react_web/src/web_runtime.dart';

typedef AlphaOption = String;

abstract interface class AudioDataCopyToOptions {
  int get planeIndex;
  set planeIndex(int value);
  int? get frameOffset;
  set frameOffset(int? value);
  int? get frameCount;
  set frameCount(int? value);
  AudioSampleFormat? get format;
  set format(AudioSampleFormat? value);
}

final class AudioDataCopyToOptionsValue implements AudioDataCopyToOptions {
  @override
  int planeIndex;
  @override
  int? frameOffset;
  @override
  int? frameCount;
  @override
  AudioSampleFormat? format;

  AudioDataCopyToOptionsValue({
    required this.planeIndex,
    this.frameOffset,
    this.frameCount,
    this.format,
  });
}

abstract interface class AudioDataInit {
  AudioSampleFormat get format;
  set format(AudioSampleFormat value);
  double get sampleRate;
  set sampleRate(double value);
  int get numberOfFrames;
  set numberOfFrames(int value);
  int get numberOfChannels;
  set numberOfChannels(int value);
  int get timestamp;
  set timestamp(int value);
  BufferSource get data;
  set data(BufferSource value);
  List<Object>? get transfer;
  set transfer(List<Object>? value);
}

final class AudioDataInitValue implements AudioDataInit {
  @override
  AudioSampleFormat format;
  @override
  double sampleRate;
  @override
  int numberOfFrames;
  @override
  int numberOfChannels;
  @override
  int timestamp;
  @override
  BufferSource data;
  @override
  List<Object>? transfer;

  AudioDataInitValue({
    required this.format,
    required this.sampleRate,
    required this.numberOfFrames,
    required this.numberOfChannels,
    required this.timestamp,
    required this.data,
    this.transfer,
  });
}

typedef AudioDataOutputCallback = void Function(Object output,);

abstract interface class AudioDecoderConfig {
  String get codec;
  set codec(String value);
  int get sampleRate;
  set sampleRate(int value);
  int get numberOfChannels;
  set numberOfChannels(int value);
  BufferSource? get description;
  set description(BufferSource? value);
}

final class AudioDecoderConfigValue implements AudioDecoderConfig {
  @override
  String codec;
  @override
  int sampleRate;
  @override
  int numberOfChannels;
  @override
  BufferSource? description;

  AudioDecoderConfigValue({
    required this.codec,
    required this.sampleRate,
    required this.numberOfChannels,
    this.description,
  });
}

abstract interface class AudioDecoderInit {
  AudioDataOutputCallback get output;
  set output(AudioDataOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

final class AudioDecoderInitValue implements AudioDecoderInit {
  @override
  AudioDataOutputCallback output;
  @override
  WebCodecsErrorCallback error;

  AudioDecoderInitValue({
    required this.output,
    required this.error,
  });
}

abstract interface class AudioDecoderSupport {
  bool? get supported;
  set supported(bool? value);
  AudioDecoderConfig? get config;
  set config(AudioDecoderConfig? value);
}

final class AudioDecoderSupportValue implements AudioDecoderSupport {
  @override
  bool? supported;
  @override
  AudioDecoderConfig? config;

  AudioDecoderSupportValue({
    this.supported,
    this.config,
  });
}

abstract interface class AudioEncoderInit {
  EncodedAudioChunkOutputCallback get output;
  set output(EncodedAudioChunkOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

final class AudioEncoderInitValue implements AudioEncoderInit {
  @override
  EncodedAudioChunkOutputCallback output;
  @override
  WebCodecsErrorCallback error;

  AudioEncoderInitValue({
    required this.output,
    required this.error,
  });
}

abstract interface class AudioEncoderSupport {
  bool? get supported;
  set supported(bool? value);
  AudioEncoderConfig? get config;
  set config(AudioEncoderConfig? value);
}

final class AudioEncoderSupportValue implements AudioEncoderSupport {
  @override
  bool? supported;
  @override
  AudioEncoderConfig? config;

  AudioEncoderSupportValue({
    this.supported,
    this.config,
  });
}

typedef AudioSampleFormat = String;

typedef CodecState = String;

abstract interface class EncodedAudioChunkInit {
  EncodedAudioChunkType get type;
  set type(EncodedAudioChunkType value);
  int get timestamp;
  set timestamp(int value);
  int? get duration;
  set duration(int? value);
  AllowSharedBufferSource get data;
  set data(AllowSharedBufferSource value);
  List<Object>? get transfer;
  set transfer(List<Object>? value);
}

final class EncodedAudioChunkInitValue implements EncodedAudioChunkInit {
  @override
  EncodedAudioChunkType type;
  @override
  int timestamp;
  @override
  int? duration;
  @override
  AllowSharedBufferSource data;
  @override
  List<Object>? transfer;

  EncodedAudioChunkInitValue({
    required this.type,
    required this.timestamp,
    this.duration,
    required this.data,
    this.transfer,
  });
}

abstract interface class EncodedAudioChunkMetadata {
  AudioDecoderConfig? get decoderConfig;
  set decoderConfig(AudioDecoderConfig? value);
}

final class EncodedAudioChunkMetadataValue implements EncodedAudioChunkMetadata {
  @override
  AudioDecoderConfig? decoderConfig;

  EncodedAudioChunkMetadataValue({
    this.decoderConfig,
  });
}

typedef EncodedAudioChunkOutputCallback = void Function(Object output, EncodedAudioChunkMetadata metadata,);

typedef EncodedAudioChunkType = String;

abstract interface class EncodedVideoChunk {
  factory EncodedVideoChunk(EncodedVideoChunkInit init) =>
      WebRuntime.current.createWebObject<EncodedVideoChunk>(
        'EncodedVideoChunk',
        [init],
      );
  EncodedVideoChunkType get type;
  int get timestamp;
  int? get duration;
  int get byteLength;
  void copyTo(AllowSharedBufferSource destination);
}

abstract interface class EncodedVideoChunkInit {
  EncodedVideoChunkType get type;
  set type(EncodedVideoChunkType value);
  int get timestamp;
  set timestamp(int value);
  int? get duration;
  set duration(int? value);
  AllowSharedBufferSource get data;
  set data(AllowSharedBufferSource value);
  List<Object>? get transfer;
  set transfer(List<Object>? value);
}

final class EncodedVideoChunkInitValue implements EncodedVideoChunkInit {
  @override
  EncodedVideoChunkType type;
  @override
  int timestamp;
  @override
  int? duration;
  @override
  AllowSharedBufferSource data;
  @override
  List<Object>? transfer;

  EncodedVideoChunkInitValue({
    required this.type,
    required this.timestamp,
    this.duration,
    required this.data,
    this.transfer,
  });
}

abstract interface class EncodedVideoChunkMetadata {
  VideoDecoderConfig? get decoderConfig;
  set decoderConfig(VideoDecoderConfig? value);
  SvcOutputMetadata? get svc;
  set svc(SvcOutputMetadata? value);
  BufferSource? get alphaSideData;
  set alphaSideData(BufferSource? value);
}

final class EncodedVideoChunkMetadataValue implements EncodedVideoChunkMetadata {
  @override
  VideoDecoderConfig? decoderConfig;
  @override
  SvcOutputMetadata? svc;
  @override
  BufferSource? alphaSideData;

  EncodedVideoChunkMetadataValue({
    this.decoderConfig,
    this.svc,
    this.alphaSideData,
  });
}

typedef EncodedVideoChunkOutputCallback = void Function(EncodedVideoChunk chunk, EncodedVideoChunkMetadata metadata,);

typedef EncodedVideoChunkType = String;

typedef HardwareAcceleration = String;

typedef ImageBufferSource = Object;

abstract interface class ImageDecodeOptions {
  int? get frameIndex;
  set frameIndex(int? value);
  bool? get completeFramesOnly;
  set completeFramesOnly(bool? value);
}

final class ImageDecodeOptionsValue implements ImageDecodeOptions {
  @override
  int? frameIndex;
  @override
  bool? completeFramesOnly;

  ImageDecodeOptionsValue({
    this.frameIndex,
    this.completeFramesOnly,
  });
}

abstract interface class ImageDecodeResult {
  VideoFrame get image;
  set image(VideoFrame value);
  bool get complete;
  set complete(bool value);
}

final class ImageDecodeResultValue implements ImageDecodeResult {
  @override
  VideoFrame image;
  @override
  bool complete;

  ImageDecodeResultValue({
    required this.image,
    required this.complete,
  });
}

abstract interface class ImageDecoderInit {
  String get type;
  set type(String value);
  ImageBufferSource get data;
  set data(ImageBufferSource value);
  ColorSpaceConversion? get colorSpaceConversion;
  set colorSpaceConversion(ColorSpaceConversion? value);
  int? get desiredWidth;
  set desiredWidth(int? value);
  int? get desiredHeight;
  set desiredHeight(int? value);
  bool? get preferAnimation;
  set preferAnimation(bool? value);
  List<Object>? get transfer;
  set transfer(List<Object>? value);
}

final class ImageDecoderInitValue implements ImageDecoderInit {
  @override
  String type;
  @override
  ImageBufferSource data;
  @override
  ColorSpaceConversion? colorSpaceConversion;
  @override
  int? desiredWidth;
  @override
  int? desiredHeight;
  @override
  bool? preferAnimation;
  @override
  List<Object>? transfer;

  ImageDecoderInitValue({
    required this.type,
    required this.data,
    this.colorSpaceConversion,
    this.desiredWidth,
    this.desiredHeight,
    this.preferAnimation,
    this.transfer,
  });
}

typedef LatencyMode = String;

abstract interface class PlaneLayout {
  int get offset;
  set offset(int value);
  int get stride;
  set stride(int value);
}

final class PlaneLayoutValue implements PlaneLayout {
  @override
  int offset;
  @override
  int stride;

  PlaneLayoutValue({
    required this.offset,
    required this.stride,
  });
}

abstract interface class SvcOutputMetadata {
  int? get temporalLayerId;
  set temporalLayerId(int? value);
}

final class SvcOutputMetadataValue implements SvcOutputMetadata {
  @override
  int? temporalLayerId;

  SvcOutputMetadataValue({
    this.temporalLayerId,
  });
}

typedef VideoColorPrimaries = String;

abstract interface class VideoColorSpace {
  factory VideoColorSpace([VideoColorSpaceInit? init]) =>
      WebRuntime.current.createWebObject<VideoColorSpace>(
        'VideoColorSpace',
        [init],
      );
  VideoColorPrimaries? get primaries;
  VideoTransferCharacteristics? get transfer;
  VideoMatrixCoefficients? get matrix;
  bool? get fullRange;
  VideoColorSpaceInit toJSON();
}

abstract interface class VideoColorSpaceInit {
  VideoColorPrimaries? get primaries;
  set primaries(VideoColorPrimaries? value);
  VideoTransferCharacteristics? get transfer;
  set transfer(VideoTransferCharacteristics? value);
  VideoMatrixCoefficients? get matrix;
  set matrix(VideoMatrixCoefficients? value);
  bool? get fullRange;
  set fullRange(bool? value);
}

final class VideoColorSpaceInitValue implements VideoColorSpaceInit {
  @override
  VideoColorPrimaries? primaries;
  @override
  VideoTransferCharacteristics? transfer;
  @override
  VideoMatrixCoefficients? matrix;
  @override
  bool? fullRange;

  VideoColorSpaceInitValue({
    this.primaries,
    this.transfer,
    this.matrix,
    this.fullRange,
  });
}

abstract interface class VideoDecoder {
  factory VideoDecoder(VideoDecoderInit init) =>
      WebRuntime.current.createWebObject<VideoDecoder>(
        'VideoDecoder',
        [init],
      );
  CodecState get state;
  int get decodeQueueSize;
  EventHandler get ondequeue;
   set ondequeue(EventHandler value);
  void configure(VideoDecoderConfig config);
  void decode(EncodedVideoChunk chunk);
  Future<void> flush();
  void reset();
  void close();
}

abstract interface class VideoDecoderConfig {
  String get codec;
  set codec(String value);
  AllowSharedBufferSource? get description;
  set description(AllowSharedBufferSource? value);
  int? get codedWidth;
  set codedWidth(int? value);
  int? get codedHeight;
  set codedHeight(int? value);
  int? get displayAspectWidth;
  set displayAspectWidth(int? value);
  int? get displayAspectHeight;
  set displayAspectHeight(int? value);
  VideoColorSpaceInit? get colorSpace;
  set colorSpace(VideoColorSpaceInit? value);
  HardwareAcceleration? get hardwareAcceleration;
  set hardwareAcceleration(HardwareAcceleration? value);
  bool? get optimizeForLatency;
  set optimizeForLatency(bool? value);
}

final class VideoDecoderConfigValue implements VideoDecoderConfig {
  @override
  String codec;
  @override
  AllowSharedBufferSource? description;
  @override
  int? codedWidth;
  @override
  int? codedHeight;
  @override
  int? displayAspectWidth;
  @override
  int? displayAspectHeight;
  @override
  VideoColorSpaceInit? colorSpace;
  @override
  HardwareAcceleration? hardwareAcceleration;
  @override
  bool? optimizeForLatency;

  VideoDecoderConfigValue({
    required this.codec,
    this.description,
    this.codedWidth,
    this.codedHeight,
    this.displayAspectWidth,
    this.displayAspectHeight,
    this.colorSpace,
    this.hardwareAcceleration,
    this.optimizeForLatency,
  });
}

abstract interface class VideoDecoderInit {
  VideoFrameOutputCallback get output;
  set output(VideoFrameOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

final class VideoDecoderInitValue implements VideoDecoderInit {
  @override
  VideoFrameOutputCallback output;
  @override
  WebCodecsErrorCallback error;

  VideoDecoderInitValue({
    required this.output,
    required this.error,
  });
}

abstract interface class VideoDecoderSupport {
  bool? get supported;
  set supported(bool? value);
  VideoDecoderConfig? get config;
  set config(VideoDecoderConfig? value);
}

final class VideoDecoderSupportValue implements VideoDecoderSupport {
  @override
  bool? supported;
  @override
  VideoDecoderConfig? config;

  VideoDecoderSupportValue({
    this.supported,
    this.config,
  });
}

abstract interface class VideoEncoder {
  factory VideoEncoder(VideoEncoderInit init) =>
      WebRuntime.current.createWebObject<VideoEncoder>(
        'VideoEncoder',
        [init],
      );
  CodecState get state;
  int get encodeQueueSize;
  EventHandler get ondequeue;
   set ondequeue(EventHandler value);
  void configure(VideoEncoderConfig config);
  void encode(VideoFrame frame, [VideoEncoderEncodeOptions? options]);
  Future<void> flush();
  void reset();
  void close();
}

typedef VideoEncoderBitrateMode = String;

abstract interface class VideoEncoderInit {
  EncodedVideoChunkOutputCallback get output;
  set output(EncodedVideoChunkOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

final class VideoEncoderInitValue implements VideoEncoderInit {
  @override
  EncodedVideoChunkOutputCallback output;
  @override
  WebCodecsErrorCallback error;

  VideoEncoderInitValue({
    required this.output,
    required this.error,
  });
}

abstract interface class VideoEncoderSupport {
  bool? get supported;
  set supported(bool? value);
  VideoEncoderConfig? get config;
  set config(VideoEncoderConfig? value);
}

final class VideoEncoderSupportValue implements VideoEncoderSupport {
  @override
  bool? supported;
  @override
  VideoEncoderConfig? config;

  VideoEncoderSupportValue({
    this.supported,
    this.config,
  });
}

abstract interface class VideoFrame {
  factory VideoFrame(CanvasImageSource image, [VideoFrameInit? init]) =>
      WebRuntime.current.createWebObject<VideoFrame>(
        'VideoFrame',
        [image, init],
      );
  factory VideoFrame.named1(AllowSharedBufferSource data, VideoFrameBufferInit init) =>
      WebRuntime.current.createWebObject<VideoFrame>(
        'VideoFrame',
        [data, init],
      );
  VideoPixelFormat? get format;
  int get codedWidth;
  int get codedHeight;
  DOMRectReadOnly? get codedRect;
  DOMRectReadOnly? get visibleRect;
  int get displayWidth;
  int get displayHeight;
  int? get duration;
  int get timestamp;
  VideoColorSpace get colorSpace;
  int allocationSize([VideoFrameCopyToOptions? options]);
  Future<List<PlaneLayout>> copyTo(AllowSharedBufferSource destination, [VideoFrameCopyToOptions? options]);
  VideoFrame clone();
  void close();
}

abstract interface class VideoFrameBufferInit {
  VideoPixelFormat get format;
  set format(VideoPixelFormat value);
  int get codedWidth;
  set codedWidth(int value);
  int get codedHeight;
  set codedHeight(int value);
  int get timestamp;
  set timestamp(int value);
  int? get duration;
  set duration(int? value);
  List<PlaneLayout>? get layout;
  set layout(List<PlaneLayout>? value);
  DOMRectInit? get visibleRect;
  set visibleRect(DOMRectInit? value);
  int? get displayWidth;
  set displayWidth(int? value);
  int? get displayHeight;
  set displayHeight(int? value);
  VideoColorSpaceInit? get colorSpace;
  set colorSpace(VideoColorSpaceInit? value);
  List<Object>? get transfer;
  set transfer(List<Object>? value);
  VideoFrameMetadata? get metadata;
  set metadata(VideoFrameMetadata? value);
}

final class VideoFrameBufferInitValue implements VideoFrameBufferInit {
  @override
  VideoPixelFormat format;
  @override
  int codedWidth;
  @override
  int codedHeight;
  @override
  int timestamp;
  @override
  int? duration;
  @override
  List<PlaneLayout>? layout;
  @override
  DOMRectInit? visibleRect;
  @override
  int? displayWidth;
  @override
  int? displayHeight;
  @override
  VideoColorSpaceInit? colorSpace;
  @override
  List<Object>? transfer;
  @override
  VideoFrameMetadata? metadata;

  VideoFrameBufferInitValue({
    required this.format,
    required this.codedWidth,
    required this.codedHeight,
    required this.timestamp,
    this.duration,
    this.layout,
    this.visibleRect,
    this.displayWidth,
    this.displayHeight,
    this.colorSpace,
    this.transfer,
    this.metadata,
  });
}

abstract interface class VideoFrameCopyToOptions {
  DOMRectInit? get rect;
  set rect(DOMRectInit? value);
  List<PlaneLayout>? get layout;
  set layout(List<PlaneLayout>? value);
  VideoPixelFormat? get format;
  set format(VideoPixelFormat? value);
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
}

final class VideoFrameCopyToOptionsValue implements VideoFrameCopyToOptions {
  @override
  DOMRectInit? rect;
  @override
  List<PlaneLayout>? layout;
  @override
  VideoPixelFormat? format;
  @override
  PredefinedColorSpace? colorSpace;

  VideoFrameCopyToOptionsValue({
    this.rect,
    this.layout,
    this.format,
    this.colorSpace,
  });
}

abstract interface class VideoFrameInit {
  int? get duration;
  set duration(int? value);
  int? get timestamp;
  set timestamp(int? value);
  AlphaOption? get alpha;
  set alpha(AlphaOption? value);
  DOMRectInit? get visibleRect;
  set visibleRect(DOMRectInit? value);
  int? get displayWidth;
  set displayWidth(int? value);
  int? get displayHeight;
  set displayHeight(int? value);
  VideoFrameMetadata? get metadata;
  set metadata(VideoFrameMetadata? value);
}

final class VideoFrameInitValue implements VideoFrameInit {
  @override
  int? duration;
  @override
  int? timestamp;
  @override
  AlphaOption? alpha;
  @override
  DOMRectInit? visibleRect;
  @override
  int? displayWidth;
  @override
  int? displayHeight;
  @override
  VideoFrameMetadata? metadata;

  VideoFrameInitValue({
    this.duration,
    this.timestamp,
    this.alpha,
    this.visibleRect,
    this.displayWidth,
    this.displayHeight,
    this.metadata,
  });
}

abstract interface class VideoFrameMetadata {
}

final class VideoFrameMetadataValue implements VideoFrameMetadata {

  VideoFrameMetadataValue();
}

typedef VideoFrameOutputCallback = void Function(VideoFrame output,);

typedef VideoMatrixCoefficients = String;

typedef VideoPixelFormat = String;

typedef VideoTransferCharacteristics = String;

typedef WebCodecsErrorCallback = void Function(DOMException error,);

