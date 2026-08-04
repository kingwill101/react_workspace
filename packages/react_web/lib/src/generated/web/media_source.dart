// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: media-source
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'webidl.dart';

typedef AppendMode = String;

abstract interface class BufferedChangeEvent {
  TimeRanges get addedRanges;
  TimeRanges get removedRanges;
}

abstract interface class BufferedChangeEventInit {
  TimeRanges get addedRanges;
  set addedRanges(TimeRanges value);
  TimeRanges get removedRanges;
  set removedRanges(TimeRanges value);
}

typedef EndOfStreamError = String;

abstract interface class ManagedMediaSource {
  bool get streaming;
  EventHandler get onstartstreaming;
   set onstartstreaming(EventHandler value);
  EventHandler get onendstreaming;
   set onendstreaming(EventHandler value);
}

abstract interface class ManagedSourceBuffer {
  EventHandler get onbufferedchange;
   set onbufferedchange(EventHandler value);
}

abstract interface class MediaSource {
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
  SourceBuffer addSourceBuffer(String type);
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
  TextTrackList get textTracks;
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
  void changeType(String type);
  void remove(double start, double end);
}

abstract interface class SourceBufferList {
  int get length;
  EventHandler get onaddsourcebuffer;
   set onaddsourcebuffer(EventHandler value);
  EventHandler get onremovesourcebuffer;
   set onremovesourcebuffer(EventHandler value);
}

