// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: video-rvfc
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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
  double get processingDuration;
  set processingDuration(double value);
  DOMHighResTimeStamp get captureTime;
  set captureTime(DOMHighResTimeStamp value);
  DOMHighResTimeStamp get receiveTime;
  set receiveTime(DOMHighResTimeStamp value);
  int get rtpTimestamp;
  set rtpTimestamp(int value);
}

typedef VideoFrameRequestCallback = void Function(DOMHighResTimeStamp now, VideoFrameCallbackMetadata metadata,);

