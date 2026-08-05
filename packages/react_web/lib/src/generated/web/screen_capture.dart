// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: screen-capture
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'mediacapture_streams.dart';

typedef CaptureStartFocusBehavior = String;

typedef CursorCaptureConstraint = String;

typedef DisplayCaptureSurfaceType = String;

abstract interface class DisplayMediaStreamOptions {
  Object get video;
  set video(Object value);
  Object get audio;
  set audio(Object value);
  Object get controller;
  set controller(Object value);
  SelfCapturePreferenceEnum get selfBrowserSurface;
  set selfBrowserSurface(SelfCapturePreferenceEnum value);
  SystemAudioPreferenceEnum get systemAudio;
  set systemAudio(SystemAudioPreferenceEnum value);
  SurfaceSwitchingPreferenceEnum get surfaceSwitching;
  set surfaceSwitching(SurfaceSwitchingPreferenceEnum value);
  MonitorTypeSurfacesEnum get monitorTypeSurfaces;
  set monitorTypeSurfaces(MonitorTypeSurfacesEnum value);
}

typedef MonitorTypeSurfacesEnum = String;

typedef SelfCapturePreferenceEnum = String;

typedef SurfaceSwitchingPreferenceEnum = String;

typedef SystemAudioPreferenceEnum = String;

