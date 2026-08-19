// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: media-source
// ignore_for_file: type=lint

import 'html.dart';
import 'dom.dart';
import 'webidl.dart';
import 'package:react_web/src/web_runtime.dart';

typedef AppendMode = String;

abstract interface class BufferedChangeEventInit {
  TimeRanges? get addedRanges;
  set addedRanges(TimeRanges? value);
  TimeRanges? get removedRanges;
  set removedRanges(TimeRanges? value);
}

final class BufferedChangeEventInitValue implements BufferedChangeEventInit {
  @override
  TimeRanges? addedRanges;
  @override
  TimeRanges? removedRanges;

  BufferedChangeEventInitValue({
    this.addedRanges,
    this.removedRanges,
  });
}

typedef EndOfStreamError = String;

abstract interface class MediaSource {
  factory MediaSource() =>
      WebRuntime.current.createWebObject<MediaSource>(
        'MediaSource',
        [],
      );
  MediaSourceHandle get handle;
  SourceBufferList get sourceBuffers;
  SourceBufferList get activeSourceBuffers;
  ReadyState get readyState;
  double get duration;
   set duration(double value);
  EventHandler get onsourceopen;
   set onsourceopen(EventHandler value);
  EventHandler get onsourceended;
   set onsourceended(EventHandler value);
  EventHandler get onsourceclose;
   set onsourceclose(EventHandler value);
  SourceBuffer addSourceBuffer(String type_);
  void removeSourceBuffer(SourceBuffer sourceBuffer);
  void endOfStream([EndOfStreamError? error]);
  void setLiveSeekableRange(double start, double end);
  void clearLiveSeekableRange();
}

abstract interface class MediaSourceHandle {
}

typedef ReadyState = String;

abstract interface class SourceBuffer {
  AppendMode get mode;
   set mode(AppendMode value);
  bool get updating;
  TimeRanges get buffered;
  double get timestampOffset;
   set timestampOffset(double value);
  AudioTrackList get audioTracks;
  VideoTrackList get videoTracks;
  double get appendWindowStart;
   set appendWindowStart(double value);
  double get appendWindowEnd;
   set appendWindowEnd(double value);
  EventHandler get onupdatestart;
   set onupdatestart(EventHandler value);
  EventHandler get onupdate;
   set onupdate(EventHandler value);
  EventHandler get onupdateend;
   set onupdateend(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onabort;
   set onabort(EventHandler value);
  void appendBuffer(BufferSource data);
  void abort();
  void changeType(String type_);
  void remove(double start, double end);
}

abstract interface class SourceBufferList {
  int get length;
  EventHandler get onaddsourcebuffer;
   set onaddsourcebuffer(EventHandler value);
  EventHandler get onremovesourcebuffer;
   set onremovesourcebuffer(EventHandler value);
}

