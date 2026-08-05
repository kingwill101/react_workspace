// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediastream-recording
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fileapi.dart';
import 'hr_time.dart';
import 'mediacapture_streams.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

typedef BitrateMode = String;

abstract interface class BlobEvent {
  factory BlobEvent(String type, BlobEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<BlobEvent>(
        'BlobEvent',
        [type, eventInitDict],
      );
  Blob get data;
  DOMHighResTimeStamp get timecode;
}

abstract interface class BlobEventInit {
  Blob get data;
  set data(Blob value);
  DOMHighResTimeStamp get timecode;
  set timecode(DOMHighResTimeStamp value);
}

abstract interface class MediaRecorder {
  factory MediaRecorder(MediaStream stream, [MediaRecorderOptions? options]) =>
      WebRuntime.current.createWebObject<MediaRecorder>(
        'MediaRecorder',
        [stream, options],
      );
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
  String get mimeType;
  set mimeType(String value);
  int get audioBitsPerSecond;
  set audioBitsPerSecond(int value);
  int get videoBitsPerSecond;
  set videoBitsPerSecond(int value);
  int get bitsPerSecond;
  set bitsPerSecond(int value);
  BitrateMode get audioBitrateMode;
  set audioBitrateMode(BitrateMode value);
  DOMHighResTimeStamp get videoKeyFrameIntervalDuration;
  set videoKeyFrameIntervalDuration(DOMHighResTimeStamp value);
  int get videoKeyFrameIntervalCount;
  set videoKeyFrameIntervalCount(int value);
}

typedef RecordingState = String;

