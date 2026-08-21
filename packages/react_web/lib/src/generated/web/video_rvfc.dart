// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: video-rvfc
// ignore_for_file: type=lint

import 'hr_time.dart';

abstract interface class VideoFrameCallbackMetadata {
  DOMHighResTimeStamp get presentationTime;
  set presentationTime(DOMHighResTimeStamp value);
  DOMHighResTimeStamp get expectedDisplayTime;
  set expectedDisplayTime(DOMHighResTimeStamp value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  double get mediaTime;
  set mediaTime(double value);
  int get presentedFrames;
  set presentedFrames(int value);
  double? get processingDuration;
  set processingDuration(double? value);
  DOMHighResTimeStamp? get captureTime;
  set captureTime(DOMHighResTimeStamp? value);
  DOMHighResTimeStamp? get receiveTime;
  set receiveTime(DOMHighResTimeStamp? value);
  int? get rtpTimestamp;
  set rtpTimestamp(int? value);
}

final class VideoFrameCallbackMetadataValue
    implements VideoFrameCallbackMetadata {
  @override
  DOMHighResTimeStamp presentationTime;
  @override
  DOMHighResTimeStamp expectedDisplayTime;
  @override
  int width;
  @override
  int height;
  @override
  double mediaTime;
  @override
  int presentedFrames;
  @override
  double? processingDuration;
  @override
  DOMHighResTimeStamp? captureTime;
  @override
  DOMHighResTimeStamp? receiveTime;
  @override
  int? rtpTimestamp;

  VideoFrameCallbackMetadataValue({
    required this.presentationTime,
    required this.expectedDisplayTime,
    required this.width,
    required this.height,
    required this.mediaTime,
    required this.presentedFrames,
    this.processingDuration,
    this.captureTime,
    this.receiveTime,
    this.rtpTimestamp,
  });
}

typedef VideoFrameRequestCallback =
    void Function(DOMHighResTimeStamp now, VideoFrameCallbackMetadata metadata);
