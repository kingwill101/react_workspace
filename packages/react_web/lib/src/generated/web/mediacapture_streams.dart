// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediacapture-streams
// ignore_for_file: type=lint

import 'capture_handle_identity.dart';
import 'html.dart';
import 'image_capture.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class CameraDevicePermissionDescriptor {
  bool? get panTiltZoom;
  set panTiltZoom(bool? value);
}

final class CameraDevicePermissionDescriptorValue
    implements CameraDevicePermissionDescriptor {
  @override
  bool? panTiltZoom;

  CameraDevicePermissionDescriptorValue({this.panTiltZoom});
}

typedef ConstrainBoolean = Object;

abstract interface class ConstrainBooleanParameters {
  bool? get exact;
  set exact(bool? value);
  bool? get ideal;
  set ideal(bool? value);
}

final class ConstrainBooleanParametersValue
    implements ConstrainBooleanParameters {
  @override
  bool? exact;
  @override
  bool? ideal;

  ConstrainBooleanParametersValue({this.exact, this.ideal});
}

typedef ConstrainDOMString = Object;

abstract interface class ConstrainDOMStringParameters {
  Object? get exact;
  set exact(Object? value);
  Object? get ideal;
  set ideal(Object? value);
}

final class ConstrainDOMStringParametersValue
    implements ConstrainDOMStringParameters {
  @override
  Object? exact;
  @override
  Object? ideal;

  ConstrainDOMStringParametersValue({this.exact, this.ideal});
}

typedef ConstrainDouble = Object;

abstract interface class ConstrainDoubleRange {
  double? get exact;
  set exact(double? value);
  double? get ideal;
  set ideal(double? value);
}

final class ConstrainDoubleRangeValue implements ConstrainDoubleRange {
  @override
  double? exact;
  @override
  double? ideal;

  ConstrainDoubleRangeValue({this.exact, this.ideal});
}

typedef ConstrainULong = Object;

abstract interface class ConstrainULongRange {
  int? get exact;
  set exact(int? value);
  int? get ideal;
  set ideal(int? value);
}

final class ConstrainULongRangeValue implements ConstrainULongRange {
  @override
  int? exact;
  @override
  int? ideal;

  ConstrainULongRangeValue({this.exact, this.ideal});
}

abstract interface class DeviceChangeEventInit {
  List<MediaDeviceInfo>? get devices;
  set devices(List<MediaDeviceInfo>? value);
}

final class DeviceChangeEventInitValue implements DeviceChangeEventInit {
  @override
  List<MediaDeviceInfo>? devices;

  DeviceChangeEventInitValue({this.devices});
}

abstract interface class DoubleRange {
  double? get max;
  set max(double? value);
  double? get min;
  set min(double? value);
}

final class DoubleRangeValue implements DoubleRange {
  @override
  double? max;
  @override
  double? min;

  DoubleRangeValue({this.max, this.min});
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
      WebRuntime.current.createWebObject<MediaStream>('MediaStream', []);
  factory MediaStream.named1(MediaStream stream) =>
      WebRuntime.current.createWebObject<MediaStream>('MediaStream', [stream]);
  factory MediaStream.named2(List<MediaStreamTrack> tracks) =>
      WebRuntime.current.createWebObject<MediaStream>('MediaStream', [tracks]);
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
  Object? get video;
  set video(Object? value);
  Object? get audio;
  set audio(Object? value);
  bool? get preferCurrentTab;
  set preferCurrentTab(bool? value);
  String? get peerIdentity;
  set peerIdentity(String? value);
}

final class MediaStreamConstraintsValue implements MediaStreamConstraints {
  @override
  Object? video;
  @override
  Object? audio;
  @override
  bool? preferCurrentTab;
  @override
  String? peerIdentity;

  MediaStreamConstraintsValue({
    this.video,
    this.audio,
    this.preferCurrentTab,
    this.peerIdentity,
  });
}

abstract interface class MediaStreamTrackEvent {
  factory MediaStreamTrackEvent(
    String type_,
    MediaStreamTrackEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<MediaStreamTrackEvent>(
    'MediaStreamTrackEvent',
    [type_, eventInitDict],
  );
  MediaStreamTrack get track;
}

abstract interface class MediaStreamTrackEventInit {
  MediaStreamTrack get track;
  set track(MediaStreamTrack value);
}

final class MediaStreamTrackEventInitValue
    implements MediaStreamTrackEventInit {
  @override
  MediaStreamTrack track;

  MediaStreamTrackEventInitValue({required this.track});
}

typedef MediaStreamTrackState = String;

abstract interface class MediaTrackConstraints {
  List<MediaTrackConstraintSet>? get advanced;
  set advanced(List<MediaTrackConstraintSet>? value);
}

final class MediaTrackConstraintsValue implements MediaTrackConstraints {
  @override
  List<MediaTrackConstraintSet>? advanced;

  MediaTrackConstraintsValue({this.advanced});
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
  int? get max;
  set max(int? value);
  int? get min;
  set min(int? value);
}

final class ULongRangeValue implements ULongRange {
  @override
  int? max;
  @override
  int? min;

  ULongRangeValue({this.max, this.min});
}

typedef VideoFacingModeEnum = String;

typedef VideoResizeModeEnum = String;
