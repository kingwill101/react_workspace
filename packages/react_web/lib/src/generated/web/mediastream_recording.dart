// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediastream-recording
// ignore_for_file: type=lint

import 'fileapi.dart';
import 'hr_time.dart';
import 'html.dart';
import 'mediacapture_streams.dart';
import 'package:react_web/src/web_runtime.dart';

typedef BitrateMode = String;

abstract interface class BlobEvent {
  factory BlobEvent(String type_, BlobEventInit eventInitDict) => WebRuntime
      .current
      .createWebObject<BlobEvent>('BlobEvent', [type_, eventInitDict]);
  Blob get data;
  DOMHighResTimeStamp get timecode;
}

abstract interface class BlobEventInit {
  Blob get data;
  set data(Blob value);
  DOMHighResTimeStamp? get timecode;
  set timecode(DOMHighResTimeStamp? value);
}

final class BlobEventInitValue implements BlobEventInit {
  @override
  Blob data;
  @override
  DOMHighResTimeStamp? timecode;

  BlobEventInitValue({required this.data, this.timecode});
}

abstract interface class MediaRecorder {
  factory MediaRecorder(MediaStream stream, [MediaRecorderOptions? options]) =>
      WebRuntime.current.createWebObject<MediaRecorder>('MediaRecorder', [
        stream,
        options,
      ]);
  MediaStream get stream;
  String get mimeType;
  RecordingState get state;
  EventHandler get onstart;
  set onstart(EventHandler value);
  EventHandler get onstop;
  set onstop(EventHandler value);
  EventHandler get ondataavailable;
  set ondataavailable(EventHandler value);
  EventHandler get onpause;
  set onpause(EventHandler value);
  EventHandler get onresume;
  set onresume(EventHandler value);
  EventHandler get onerror;
  set onerror(EventHandler value);
  int get videoBitsPerSecond;
  int get audioBitsPerSecond;
  void start([int? timeslice]);
  void stop();
  void pause();
  void resume();
  void requestData();
}

abstract interface class MediaRecorderOptions {
  String? get mimeType;
  set mimeType(String? value);
  int? get audioBitsPerSecond;
  set audioBitsPerSecond(int? value);
  int? get videoBitsPerSecond;
  set videoBitsPerSecond(int? value);
  int? get bitsPerSecond;
  set bitsPerSecond(int? value);
  BitrateMode? get audioBitrateMode;
  set audioBitrateMode(BitrateMode? value);
  DOMHighResTimeStamp? get videoKeyFrameIntervalDuration;
  set videoKeyFrameIntervalDuration(DOMHighResTimeStamp? value);
  int? get videoKeyFrameIntervalCount;
  set videoKeyFrameIntervalCount(int? value);
}

final class MediaRecorderOptionsValue implements MediaRecorderOptions {
  @override
  String? mimeType;
  @override
  int? audioBitsPerSecond;
  @override
  int? videoBitsPerSecond;
  @override
  int? bitsPerSecond;
  @override
  BitrateMode? audioBitrateMode;
  @override
  DOMHighResTimeStamp? videoKeyFrameIntervalDuration;
  @override
  int? videoKeyFrameIntervalCount;

  MediaRecorderOptionsValue({
    this.mimeType,
    this.audioBitsPerSecond,
    this.videoBitsPerSecond,
    this.bitsPerSecond,
    this.audioBitrateMode,
    this.videoKeyFrameIntervalDuration,
    this.videoKeyFrameIntervalCount,
  });
}

typedef RecordingState = String;
