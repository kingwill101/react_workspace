// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: capture-handle-identity
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'mediacapture_streams.dart';
import 'image_capture.dart';

abstract interface class CaptureHandle {
  String? get origin;
  set origin(String? value);
  String? get handle;
  set handle(String? value);
}

final class CaptureHandleValue implements CaptureHandle {
  @override
  String? origin;
  @override
  String? handle;

  CaptureHandleValue({
    this.origin,
    this.handle,
  });
}

abstract interface class CaptureHandleConfig {
  bool? get exposeOrigin;
  set exposeOrigin(bool? value);
  String? get handle;
  set handle(String? value);
  List<String>? get permittedOrigins;
  set permittedOrigins(List<String>? value);
}

final class CaptureHandleConfigValue implements CaptureHandleConfig {
  @override
  bool? exposeOrigin;
  @override
  String? handle;
  @override
  List<String>? permittedOrigins;

  CaptureHandleConfigValue({
    this.exposeOrigin,
    this.handle,
    this.permittedOrigins,
  });
}

abstract interface class MediaStreamTrack {
  String get kind;
  String get id;
  String get label;
  bool get enabled;
   set enabled(bool value);
  bool get muted;
  EventHandler get onmute;
   set onmute(EventHandler value);
  EventHandler get onunmute;
   set onunmute(EventHandler value);
  MediaStreamTrackState get readyState;
  EventHandler get onended;
   set onended(EventHandler value);
  MediaStreamTrack clone();
  void stop();
  MediaTrackCapabilities getCapabilities();
  MediaTrackConstraints getConstraints();
  MediaTrackSettings getSettings();
  Future<void> applyConstraints([MediaTrackConstraints? constraints]);
  String get contentHint;
   set contentHint(String value);
}

