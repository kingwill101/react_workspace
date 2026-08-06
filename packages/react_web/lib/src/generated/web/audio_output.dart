// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: audio-output
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'encrypted_media.dart';
import 'html.dart';
import 'mediacapture_streams.dart';
import 'remote_playback.dart';
import 'image_capture.dart';
import 'screen_capture.dart';

abstract interface class AudioOutputOptions {
  String? get deviceId;
  set deviceId(String? value);
}

final class AudioOutputOptionsValue implements AudioOutputOptions {
  @override
  String? deviceId;

  AudioOutputOptionsValue({
    this.deviceId,
  });
}

abstract interface class HTMLMediaElement {
  String get sinkId;
  Future<void> setSinkId(String sinkId);
  MediaKeys? get mediaKeys;
  EventHandler get onencrypted;
   set onencrypted(EventHandler value);
  EventHandler get onwaitingforkey;
   set onwaitingforkey(EventHandler value);
  Future<void> setMediaKeys(MediaKeys? mediaKeys);
  MediaError? get error;
  String get src;
   set src(String value);
  MediaProvider? get srcObject;
   set srcObject(MediaProvider? value);
  String get currentSrc;
  String? get crossOrigin;
   set crossOrigin(String? value);
  int get networkState;
  String get preload;
   set preload(String value);
  TimeRanges get buffered;
  void load();
  CanPlayTypeResult canPlayType(String type);
  int get readyState;
  bool get seeking;
  double get currentTime;
   set currentTime(double value);
  void fastSeek(double time);
  double get duration;
  Object getStartDate();
  bool get paused;
  double get defaultPlaybackRate;
   set defaultPlaybackRate(double value);
  double get playbackRate;
   set playbackRate(double value);
  bool get preservesPitch;
   set preservesPitch(bool value);
  TimeRanges get played;
  TimeRanges get seekable;
  bool get ended;
  bool get autoplay;
   set autoplay(bool value);
  bool get loop;
   set loop(bool value);
  Future<void> play();
  void pause();
  bool get controls;
   set controls(bool value);
  double get volume;
   set volume(double value);
  bool get muted;
   set muted(bool value);
  bool get defaultMuted;
   set defaultMuted(bool value);
  AudioTrackList get audioTracks;
  VideoTrackList get videoTracks;
  TextTrackList get textTracks;
  TextTrack addTextTrack(TextTrackKind kind, [String? label, String? language]);
  MediaStream captureStream();
  RemotePlayback get remote;
  bool get disableRemotePlayback;
   set disableRemotePlayback(bool value);
}

abstract interface class MediaDevices {
  EventHandler get ondevicechange;
   set ondevicechange(EventHandler value);
  Future<List<MediaDeviceInfo>> enumerateDevices();
  MediaTrackSupportedConstraints getSupportedConstraints();
  Future<MediaStream> getUserMedia([MediaStreamConstraints? constraints]);
  Future<MediaStream> getDisplayMedia([DisplayMediaStreamOptions? options]);
}

