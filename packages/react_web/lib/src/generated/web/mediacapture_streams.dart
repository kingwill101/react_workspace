// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediacapture-streams
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'permissions.dart';
import 'dom.dart';
import 'image_capture.dart';
import 'capture_handle_identity.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class CameraDevicePermissionDescriptor {
  bool get panTiltZoom;
  set panTiltZoom(bool value);
}

typedef ConstrainBoolean = Object;

abstract interface class ConstrainBooleanParameters {
  bool get exact;
  set exact(bool value);
  bool get ideal;
  set ideal(bool value);
}

typedef ConstrainDOMString = Object;

abstract interface class ConstrainDOMStringParameters {
  Object get exact;
  set exact(Object value);
  Object get ideal;
  set ideal(Object value);
}

typedef ConstrainDouble = Object;

abstract interface class ConstrainDoubleRange {
  double get exact;
  set exact(double value);
  double get ideal;
  set ideal(double value);
}

typedef ConstrainULong = Object;

abstract interface class ConstrainULongRange {
  int get exact;
  set exact(int value);
  int get ideal;
  set ideal(int value);
}

abstract interface class DeviceChangeEventInit {
  List<MediaDeviceInfo> get devices;
  set devices(List<MediaDeviceInfo> value);
}

abstract interface class DoubleRange {
  double get max;
  set max(double value);
  double get min;
  set min(double value);
}

abstract interface class InputDeviceInfo {
  MediaTrackCapabilities getCapabilities();
}

abstract interface class MediaDeviceInfo {
  String get deviceId;
  MediaDeviceKind get kind;
  String get label;
  String get groupId;
  Object toJSON();
}

typedef MediaDeviceKind = String;

abstract interface class MediaStream {
  factory MediaStream() =>
      WebRuntime.current.createWebObject<MediaStream>(
        'MediaStream',
        [],
      );
  factory MediaStream.named1(MediaStream stream) =>
      WebRuntime.current.createWebObject<MediaStream>(
        'MediaStream',
        [stream],
      );
  factory MediaStream.named2(List<MediaStreamTrack> tracks) =>
      WebRuntime.current.createWebObject<MediaStream>(
        'MediaStream',
        [tracks],
      );
  String get id;
  List<MediaStreamTrack> getAudioTracks();
  List<MediaStreamTrack> getVideoTracks();
  List<MediaStreamTrack> getTracks();
  MediaStreamTrack? getTrackById(String trackId);
  void addTrack(MediaStreamTrack track);
  void removeTrack(MediaStreamTrack track);
  MediaStream clone();
  bool get active;
  EventHandler get onaddtrack;
   set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
   set onremovetrack(EventHandler value);
}

abstract interface class MediaStreamConstraints {
  Object get video;
  set video(Object value);
  Object get audio;
  set audio(Object value);
  bool get preferCurrentTab;
  set preferCurrentTab(bool value);
  String get peerIdentity;
  set peerIdentity(String value);
}

abstract interface class MediaStreamTrackEvent {
  factory MediaStreamTrackEvent(String type, MediaStreamTrackEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<MediaStreamTrackEvent>(
        'MediaStreamTrackEvent',
        [type, eventInitDict],
      );
  MediaStreamTrack get track;
}

abstract interface class MediaStreamTrackEventInit {
  MediaStreamTrack get track;
  set track(MediaStreamTrack value);
}

typedef MediaStreamTrackState = String;

abstract interface class MediaTrackConstraints {
  List<MediaTrackConstraintSet> get advanced;
  set advanced(List<MediaTrackConstraintSet> value);
}

abstract interface class OverconstrainedError {
  factory OverconstrainedError(String constraint, [String? message]) =>
      WebRuntime.current.createWebObject<OverconstrainedError>(
        'OverconstrainedError',
        [constraint, message],
      );
  String get constraint;
}

abstract interface class ULongRange {
  int get max;
  set max(int value);
  int get min;
  set min(int value);
}

typedef VideoFacingModeEnum = String;

typedef VideoResizeModeEnum = String;

