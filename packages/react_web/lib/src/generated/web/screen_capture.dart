// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: screen-capture
// ignore_for_file: type=lint

import 'mediacapture_streams.dart';

typedef CaptureStartFocusBehavior = String;

typedef CursorCaptureConstraint = String;

typedef DisplayCaptureSurfaceType = String;

abstract interface class DisplayMediaStreamOptions {
  Object? get video;
  set video(Object? value);
  Object? get audio;
  set audio(Object? value);
  Object? get controller;
  set controller(Object? value);
  SelfCapturePreferenceEnum? get selfBrowserSurface;
  set selfBrowserSurface(SelfCapturePreferenceEnum? value);
  SystemAudioPreferenceEnum? get systemAudio;
  set systemAudio(SystemAudioPreferenceEnum? value);
  SurfaceSwitchingPreferenceEnum? get surfaceSwitching;
  set surfaceSwitching(SurfaceSwitchingPreferenceEnum? value);
  MonitorTypeSurfacesEnum? get monitorTypeSurfaces;
  set monitorTypeSurfaces(MonitorTypeSurfacesEnum? value);
}

final class DisplayMediaStreamOptionsValue implements DisplayMediaStreamOptions {
  @override
  Object? video;
  @override
  Object? audio;
  @override
  Object? controller;
  @override
  SelfCapturePreferenceEnum? selfBrowserSurface;
  @override
  SystemAudioPreferenceEnum? systemAudio;
  @override
  SurfaceSwitchingPreferenceEnum? surfaceSwitching;
  @override
  MonitorTypeSurfacesEnum? monitorTypeSurfaces;

  DisplayMediaStreamOptionsValue({
    this.video,
    this.audio,
    this.controller,
    this.selfBrowserSurface,
    this.systemAudio,
    this.surfaceSwitching,
    this.monitorTypeSurfaces,
  });
}

typedef MonitorTypeSurfacesEnum = String;

typedef SelfCapturePreferenceEnum = String;

typedef SurfaceSwitchingPreferenceEnum = String;

typedef SystemAudioPreferenceEnum = String;

