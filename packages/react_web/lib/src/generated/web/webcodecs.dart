// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'html.dart';
import 'webcodecs_aac_codec_registration.dart';
import 'webcodecs_avc_codec_registration.dart';
import 'webcodecs_av1_codec_registration.dart';
import 'geometry.dart';

typedef AlphaOption = String;

abstract interface class AudioData {
  AudioSampleFormat? get format;
  double get sampleRate;
  int get numberOfFrames;
  int get numberOfChannels;
  int get duration;
  int get timestamp;
  int allocationSize(AudioDataCopyToOptions options);
  void copyTo(AllowSharedBufferSource destination, AudioDataCopyToOptions options);
  AudioData clone();
  void close();
}

abstract interface class AudioDataCopyToOptions {
  int get planeIndex;
  set planeIndex(int value);
  int get frameOffset;
  set frameOffset(int value);
  int get frameCount;
  set frameCount(int value);
  AudioSampleFormat get format;
  set format(AudioSampleFormat value);
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
  List<Object> get transfer;
  set transfer(List<Object> value);
}

typedef AudioDataOutputCallback = void Function(AudioData output,);

abstract interface class AudioDecoder {
  CodecState get state;
  int get decodeQueueSize;
  EventHandler get ondequeue;
   set ondequeue(EventHandler value);
  void configure(AudioDecoderConfig config);
  void decode(EncodedAudioChunk chunk);
  Future<void> flush();
  void reset();
  void close();
}

abstract interface class AudioDecoderConfig {
  String get codec;
  set codec(String value);
  int get sampleRate;
  set sampleRate(int value);
  int get numberOfChannels;
  set numberOfChannels(int value);
  BufferSource get description;
  set description(BufferSource value);
}

abstract interface class AudioDecoderInit {
  AudioDataOutputCallback get output;
  set output(AudioDataOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

abstract interface class AudioDecoderSupport {
  bool get supported;
  set supported(bool value);
  AudioDecoderConfig get config;
  set config(AudioDecoderConfig value);
}

abstract interface class AudioEncoder {
  CodecState get state;
  int get encodeQueueSize;
  EventHandler get ondequeue;
   set ondequeue(EventHandler value);
  void configure(AudioEncoderConfig config);
  void encode(AudioData data);
  Future<void> flush();
  void reset();
  void close();
}

abstract interface class AudioEncoderInit {
  EncodedAudioChunkOutputCallback get output;
  set output(EncodedAudioChunkOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

abstract interface class AudioEncoderSupport {
  bool get supported;
  set supported(bool value);
  AudioEncoderConfig get config;
  set config(AudioEncoderConfig value);
}

typedef AudioSampleFormat = String;

typedef CodecState = String;

abstract interface class EncodedAudioChunk {
  EncodedAudioChunkType get type;
  int get timestamp;
  int? get duration;
  int get byteLength;
  void copyTo(AllowSharedBufferSource destination);
}

abstract interface class EncodedAudioChunkInit {
  EncodedAudioChunkType get type;
  set type(EncodedAudioChunkType value);
  int get timestamp;
  set timestamp(int value);
  int get duration;
  set duration(int value);
  AllowSharedBufferSource get data;
  set data(AllowSharedBufferSource value);
  List<Object> get transfer;
  set transfer(List<Object> value);
}

abstract interface class EncodedAudioChunkMetadata {
  AudioDecoderConfig get decoderConfig;
  set decoderConfig(AudioDecoderConfig value);
}

typedef EncodedAudioChunkOutputCallback = void Function(EncodedAudioChunk output, EncodedAudioChunkMetadata metadata,);

typedef EncodedAudioChunkType = String;

abstract interface class EncodedVideoChunk {
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
  int get duration;
  set duration(int value);
  AllowSharedBufferSource get data;
  set data(AllowSharedBufferSource value);
  List<Object> get transfer;
  set transfer(List<Object> value);
}

abstract interface class EncodedVideoChunkMetadata {
  VideoDecoderConfig get decoderConfig;
  set decoderConfig(VideoDecoderConfig value);
  SvcOutputMetadata get svc;
  set svc(SvcOutputMetadata value);
  BufferSource get alphaSideData;
  set alphaSideData(BufferSource value);
}

typedef EncodedVideoChunkOutputCallback = void Function(EncodedVideoChunk chunk, EncodedVideoChunkMetadata metadata,);

typedef EncodedVideoChunkType = String;

typedef HardwareAcceleration = String;

typedef ImageBufferSource = Object;

abstract interface class ImageDecodeOptions {
  int get frameIndex;
  set frameIndex(int value);
  bool get completeFramesOnly;
  set completeFramesOnly(bool value);
}

abstract interface class ImageDecodeResult {
  VideoFrame get image;
  set image(VideoFrame value);
  bool get complete;
  set complete(bool value);
}

abstract interface class ImageDecoder {
  String get type;
  bool get complete;
  Future<void> get completed;
  ImageTrackList get tracks;
  Future<ImageDecodeResult> decode([ImageDecodeOptions? options]);
  void reset();
  void close();
}

abstract interface class ImageDecoderInit {
  String get type;
  set type(String value);
  ImageBufferSource get data;
  set data(ImageBufferSource value);
  ColorSpaceConversion get colorSpaceConversion;
  set colorSpaceConversion(ColorSpaceConversion value);
  int get desiredWidth;
  set desiredWidth(int value);
  int get desiredHeight;
  set desiredHeight(int value);
  bool get preferAnimation;
  set preferAnimation(bool value);
  List<Object> get transfer;
  set transfer(List<Object> value);
}

abstract interface class ImageTrack {
  bool get animated;
  int get frameCount;
  double get repetitionCount;
  bool get selected;
   set selected(bool value);
}

abstract interface class ImageTrackList {
  Future<void> get ready;
  int get length;
  int get selectedIndex;
  ImageTrack? get selectedTrack;
}

typedef LatencyMode = String;

abstract interface class PlaneLayout {
  int get offset;
  set offset(int value);
  int get stride;
  set stride(int value);
}

abstract interface class SvcOutputMetadata {
  int get temporalLayerId;
  set temporalLayerId(int value);
}

typedef VideoColorPrimaries = String;

abstract interface class VideoColorSpace {
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

abstract interface class VideoDecoder {
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
  AllowSharedBufferSource get description;
  set description(AllowSharedBufferSource value);
  int get codedWidth;
  set codedWidth(int value);
  int get codedHeight;
  set codedHeight(int value);
  int get displayAspectWidth;
  set displayAspectWidth(int value);
  int get displayAspectHeight;
  set displayAspectHeight(int value);
  VideoColorSpaceInit get colorSpace;
  set colorSpace(VideoColorSpaceInit value);
  HardwareAcceleration get hardwareAcceleration;
  set hardwareAcceleration(HardwareAcceleration value);
  bool get optimizeForLatency;
  set optimizeForLatency(bool value);
  double get rotation;
  set rotation(double value);
  bool get flip;
  set flip(bool value);
}

abstract interface class VideoDecoderInit {
  VideoFrameOutputCallback get output;
  set output(VideoFrameOutputCallback value);
  WebCodecsErrorCallback get error;
  set error(WebCodecsErrorCallback value);
}

abstract interface class VideoDecoderSupport {
  bool get supported;
  set supported(bool value);
  VideoDecoderConfig get config;
  set config(VideoDecoderConfig value);
}

abstract interface class VideoEncoder {
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

abstract interface class VideoEncoderSupport {
  bool get supported;
  set supported(bool value);
  VideoEncoderConfig get config;
  set config(VideoEncoderConfig value);
}

abstract interface class VideoFrame {
  VideoPixelFormat? get format;
  int get codedWidth;
  int get codedHeight;
  DOMRectReadOnly? get codedRect;
  DOMRectReadOnly? get visibleRect;
  double get rotation;
  bool get flip;
  int get displayWidth;
  int get displayHeight;
  int? get duration;
  int get timestamp;
  VideoColorSpace get colorSpace;
  VideoFrameMetadata metadata();
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
  int get duration;
  set duration(int value);
  List<PlaneLayout> get layout;
  set layout(List<PlaneLayout> value);
  DOMRectInit get visibleRect;
  set visibleRect(DOMRectInit value);
  double get rotation;
  set rotation(double value);
  bool get flip;
  set flip(bool value);
  int get displayWidth;
  set displayWidth(int value);
  int get displayHeight;
  set displayHeight(int value);
  VideoColorSpaceInit get colorSpace;
  set colorSpace(VideoColorSpaceInit value);
  List<Object> get transfer;
  set transfer(List<Object> value);
  VideoFrameMetadata get metadata;
  set metadata(VideoFrameMetadata value);
}

abstract interface class VideoFrameCopyToOptions {
  DOMRectInit get rect;
  set rect(DOMRectInit value);
  List<PlaneLayout> get layout;
  set layout(List<PlaneLayout> value);
  VideoPixelFormat get format;
  set format(VideoPixelFormat value);
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
}

abstract interface class VideoFrameInit {
  int get duration;
  set duration(int value);
  int get timestamp;
  set timestamp(int value);
  AlphaOption get alpha;
  set alpha(AlphaOption value);
  DOMRectInit get visibleRect;
  set visibleRect(DOMRectInit value);
  double get rotation;
  set rotation(double value);
  bool get flip;
  set flip(bool value);
  int get displayWidth;
  set displayWidth(int value);
  int get displayHeight;
  set displayHeight(int value);
  VideoFrameMetadata get metadata;
  set metadata(VideoFrameMetadata value);
}

abstract interface class VideoFrameMetadata {
}

typedef VideoFrameOutputCallback = void Function(VideoFrame output,);

typedef VideoMatrixCoefficients = String;

typedef VideoPixelFormat = String;

typedef VideoTransferCharacteristics = String;

typedef WebCodecsErrorCallback = void Function(DOMException error,);

