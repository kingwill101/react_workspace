// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: image-capture
// ignore_for_file: type=lint

import 'mediacapture_streams.dart';

typedef ConstrainPoint2D = Object;

abstract interface class ConstrainPoint2DParameters {
  List<Point2D>? get exact;
  set exact(List<Point2D>? value);
  List<Point2D>? get ideal;
  set ideal(List<Point2D>? value);
}

final class ConstrainPoint2DParametersValue implements ConstrainPoint2DParameters {
  @override
  List<Point2D>? exact;
  @override
  List<Point2D>? ideal;

  ConstrainPoint2DParametersValue({
    this.exact,
    this.ideal,
  });
}

typedef FillLightMode = String;

abstract interface class MediaSettingsRange {
  double? get max;
  set max(double? value);
  double? get min;
  set min(double? value);
  double? get step;
  set step(double? value);
}

final class MediaSettingsRangeValue implements MediaSettingsRange {
  @override
  double? max;
  @override
  double? min;
  @override
  double? step;

  MediaSettingsRangeValue({
    this.max,
    this.min,
    this.step,
  });
}

abstract interface class MediaTrackCapabilities {
  List<String>? get whiteBalanceMode;
  set whiteBalanceMode(List<String>? value);
  List<String>? get exposureMode;
  set exposureMode(List<String>? value);
  List<String>? get focusMode;
  set focusMode(List<String>? value);
  MediaSettingsRange? get exposureCompensation;
  set exposureCompensation(MediaSettingsRange? value);
  MediaSettingsRange? get exposureTime;
  set exposureTime(MediaSettingsRange? value);
  MediaSettingsRange? get colorTemperature;
  set colorTemperature(MediaSettingsRange? value);
  MediaSettingsRange? get iso;
  set iso(MediaSettingsRange? value);
  MediaSettingsRange? get brightness;
  set brightness(MediaSettingsRange? value);
  MediaSettingsRange? get contrast;
  set contrast(MediaSettingsRange? value);
  MediaSettingsRange? get saturation;
  set saturation(MediaSettingsRange? value);
  MediaSettingsRange? get sharpness;
  set sharpness(MediaSettingsRange? value);
  MediaSettingsRange? get focusDistance;
  set focusDistance(MediaSettingsRange? value);
  MediaSettingsRange? get pan;
  set pan(MediaSettingsRange? value);
  MediaSettingsRange? get tilt;
  set tilt(MediaSettingsRange? value);
  MediaSettingsRange? get zoom;
  set zoom(MediaSettingsRange? value);
  List<bool>? get torch;
  set torch(List<bool>? value);
  ULongRange? get width;
  set width(ULongRange? value);
  ULongRange? get height;
  set height(ULongRange? value);
  DoubleRange? get aspectRatio;
  set aspectRatio(DoubleRange? value);
  DoubleRange? get frameRate;
  set frameRate(DoubleRange? value);
  List<String>? get facingMode;
  set facingMode(List<String>? value);
  List<String>? get resizeMode;
  set resizeMode(List<String>? value);
  ULongRange? get sampleRate;
  set sampleRate(ULongRange? value);
  ULongRange? get sampleSize;
  set sampleSize(ULongRange? value);
  List<bool>? get echoCancellation;
  set echoCancellation(List<bool>? value);
  List<bool>? get autoGainControl;
  set autoGainControl(List<bool>? value);
  List<bool>? get noiseSuppression;
  set noiseSuppression(List<bool>? value);
  DoubleRange? get latency;
  set latency(DoubleRange? value);
  ULongRange? get channelCount;
  set channelCount(ULongRange? value);
  String? get deviceId;
  set deviceId(String? value);
  String? get groupId;
  set groupId(String? value);
  String? get displaySurface;
  set displaySurface(String? value);
  bool? get logicalSurface;
  set logicalSurface(bool? value);
  List<String>? get cursor;
  set cursor(List<String>? value);
}

final class MediaTrackCapabilitiesValue implements MediaTrackCapabilities {
  @override
  List<String>? whiteBalanceMode;
  @override
  List<String>? exposureMode;
  @override
  List<String>? focusMode;
  @override
  MediaSettingsRange? exposureCompensation;
  @override
  MediaSettingsRange? exposureTime;
  @override
  MediaSettingsRange? colorTemperature;
  @override
  MediaSettingsRange? iso;
  @override
  MediaSettingsRange? brightness;
  @override
  MediaSettingsRange? contrast;
  @override
  MediaSettingsRange? saturation;
  @override
  MediaSettingsRange? sharpness;
  @override
  MediaSettingsRange? focusDistance;
  @override
  MediaSettingsRange? pan;
  @override
  MediaSettingsRange? tilt;
  @override
  MediaSettingsRange? zoom;
  @override
  List<bool>? torch;
  @override
  ULongRange? width;
  @override
  ULongRange? height;
  @override
  DoubleRange? aspectRatio;
  @override
  DoubleRange? frameRate;
  @override
  List<String>? facingMode;
  @override
  List<String>? resizeMode;
  @override
  ULongRange? sampleRate;
  @override
  ULongRange? sampleSize;
  @override
  List<bool>? echoCancellation;
  @override
  List<bool>? autoGainControl;
  @override
  List<bool>? noiseSuppression;
  @override
  DoubleRange? latency;
  @override
  ULongRange? channelCount;
  @override
  String? deviceId;
  @override
  String? groupId;
  @override
  String? displaySurface;
  @override
  bool? logicalSurface;
  @override
  List<String>? cursor;

  MediaTrackCapabilitiesValue({
    this.whiteBalanceMode,
    this.exposureMode,
    this.focusMode,
    this.exposureCompensation,
    this.exposureTime,
    this.colorTemperature,
    this.iso,
    this.brightness,
    this.contrast,
    this.saturation,
    this.sharpness,
    this.focusDistance,
    this.pan,
    this.tilt,
    this.zoom,
    this.torch,
    this.width,
    this.height,
    this.aspectRatio,
    this.frameRate,
    this.facingMode,
    this.resizeMode,
    this.sampleRate,
    this.sampleSize,
    this.echoCancellation,
    this.autoGainControl,
    this.noiseSuppression,
    this.latency,
    this.channelCount,
    this.deviceId,
    this.groupId,
    this.displaySurface,
    this.logicalSurface,
    this.cursor,
  });
}

abstract interface class MediaTrackConstraintSet {
  ConstrainDOMString? get whiteBalanceMode;
  set whiteBalanceMode(ConstrainDOMString? value);
  ConstrainDOMString? get exposureMode;
  set exposureMode(ConstrainDOMString? value);
  ConstrainDOMString? get focusMode;
  set focusMode(ConstrainDOMString? value);
  ConstrainPoint2D? get pointsOfInterest;
  set pointsOfInterest(ConstrainPoint2D? value);
  ConstrainDouble? get exposureCompensation;
  set exposureCompensation(ConstrainDouble? value);
  ConstrainDouble? get exposureTime;
  set exposureTime(ConstrainDouble? value);
  ConstrainDouble? get colorTemperature;
  set colorTemperature(ConstrainDouble? value);
  ConstrainDouble? get iso;
  set iso(ConstrainDouble? value);
  ConstrainDouble? get brightness;
  set brightness(ConstrainDouble? value);
  ConstrainDouble? get contrast;
  set contrast(ConstrainDouble? value);
  ConstrainDouble? get saturation;
  set saturation(ConstrainDouble? value);
  ConstrainDouble? get sharpness;
  set sharpness(ConstrainDouble? value);
  ConstrainDouble? get focusDistance;
  set focusDistance(ConstrainDouble? value);
  Object? get pan;
  set pan(Object? value);
  Object? get tilt;
  set tilt(Object? value);
  Object? get zoom;
  set zoom(Object? value);
  ConstrainBoolean? get torch;
  set torch(ConstrainBoolean? value);
  ConstrainULong? get width;
  set width(ConstrainULong? value);
  ConstrainULong? get height;
  set height(ConstrainULong? value);
  ConstrainDouble? get aspectRatio;
  set aspectRatio(ConstrainDouble? value);
  ConstrainDouble? get frameRate;
  set frameRate(ConstrainDouble? value);
  ConstrainDOMString? get facingMode;
  set facingMode(ConstrainDOMString? value);
  ConstrainDOMString? get resizeMode;
  set resizeMode(ConstrainDOMString? value);
  ConstrainULong? get sampleRate;
  set sampleRate(ConstrainULong? value);
  ConstrainULong? get sampleSize;
  set sampleSize(ConstrainULong? value);
  ConstrainBoolean? get echoCancellation;
  set echoCancellation(ConstrainBoolean? value);
  ConstrainBoolean? get autoGainControl;
  set autoGainControl(ConstrainBoolean? value);
  ConstrainBoolean? get noiseSuppression;
  set noiseSuppression(ConstrainBoolean? value);
  ConstrainDouble? get latency;
  set latency(ConstrainDouble? value);
  ConstrainULong? get channelCount;
  set channelCount(ConstrainULong? value);
  ConstrainDOMString? get deviceId;
  set deviceId(ConstrainDOMString? value);
  ConstrainDOMString? get groupId;
  set groupId(ConstrainDOMString? value);
  ConstrainDOMString? get displaySurface;
  set displaySurface(ConstrainDOMString? value);
  ConstrainBoolean? get logicalSurface;
  set logicalSurface(ConstrainBoolean? value);
  ConstrainDOMString? get cursor;
  set cursor(ConstrainDOMString? value);
  ConstrainBoolean? get restrictOwnAudio;
  set restrictOwnAudio(ConstrainBoolean? value);
  ConstrainBoolean? get suppressLocalAudioPlayback;
  set suppressLocalAudioPlayback(ConstrainBoolean? value);
}

final class MediaTrackConstraintSetValue implements MediaTrackConstraintSet {
  @override
  ConstrainDOMString? whiteBalanceMode;
  @override
  ConstrainDOMString? exposureMode;
  @override
  ConstrainDOMString? focusMode;
  @override
  ConstrainPoint2D? pointsOfInterest;
  @override
  ConstrainDouble? exposureCompensation;
  @override
  ConstrainDouble? exposureTime;
  @override
  ConstrainDouble? colorTemperature;
  @override
  ConstrainDouble? iso;
  @override
  ConstrainDouble? brightness;
  @override
  ConstrainDouble? contrast;
  @override
  ConstrainDouble? saturation;
  @override
  ConstrainDouble? sharpness;
  @override
  ConstrainDouble? focusDistance;
  @override
  Object? pan;
  @override
  Object? tilt;
  @override
  Object? zoom;
  @override
  ConstrainBoolean? torch;
  @override
  ConstrainULong? width;
  @override
  ConstrainULong? height;
  @override
  ConstrainDouble? aspectRatio;
  @override
  ConstrainDouble? frameRate;
  @override
  ConstrainDOMString? facingMode;
  @override
  ConstrainDOMString? resizeMode;
  @override
  ConstrainULong? sampleRate;
  @override
  ConstrainULong? sampleSize;
  @override
  ConstrainBoolean? echoCancellation;
  @override
  ConstrainBoolean? autoGainControl;
  @override
  ConstrainBoolean? noiseSuppression;
  @override
  ConstrainDouble? latency;
  @override
  ConstrainULong? channelCount;
  @override
  ConstrainDOMString? deviceId;
  @override
  ConstrainDOMString? groupId;
  @override
  ConstrainDOMString? displaySurface;
  @override
  ConstrainBoolean? logicalSurface;
  @override
  ConstrainDOMString? cursor;
  @override
  ConstrainBoolean? restrictOwnAudio;
  @override
  ConstrainBoolean? suppressLocalAudioPlayback;

  MediaTrackConstraintSetValue({
    this.whiteBalanceMode,
    this.exposureMode,
    this.focusMode,
    this.pointsOfInterest,
    this.exposureCompensation,
    this.exposureTime,
    this.colorTemperature,
    this.iso,
    this.brightness,
    this.contrast,
    this.saturation,
    this.sharpness,
    this.focusDistance,
    this.pan,
    this.tilt,
    this.zoom,
    this.torch,
    this.width,
    this.height,
    this.aspectRatio,
    this.frameRate,
    this.facingMode,
    this.resizeMode,
    this.sampleRate,
    this.sampleSize,
    this.echoCancellation,
    this.autoGainControl,
    this.noiseSuppression,
    this.latency,
    this.channelCount,
    this.deviceId,
    this.groupId,
    this.displaySurface,
    this.logicalSurface,
    this.cursor,
    this.restrictOwnAudio,
    this.suppressLocalAudioPlayback,
  });
}

abstract interface class MediaTrackSettings {
  String? get whiteBalanceMode;
  set whiteBalanceMode(String? value);
  String? get exposureMode;
  set exposureMode(String? value);
  String? get focusMode;
  set focusMode(String? value);
  List<Point2D>? get pointsOfInterest;
  set pointsOfInterest(List<Point2D>? value);
  double? get exposureCompensation;
  set exposureCompensation(double? value);
  double? get exposureTime;
  set exposureTime(double? value);
  double? get colorTemperature;
  set colorTemperature(double? value);
  double? get iso;
  set iso(double? value);
  double? get brightness;
  set brightness(double? value);
  double? get contrast;
  set contrast(double? value);
  double? get saturation;
  set saturation(double? value);
  double? get sharpness;
  set sharpness(double? value);
  double? get focusDistance;
  set focusDistance(double? value);
  double? get pan;
  set pan(double? value);
  double? get tilt;
  set tilt(double? value);
  double? get zoom;
  set zoom(double? value);
  bool? get torch;
  set torch(bool? value);
  int? get width;
  set width(int? value);
  int? get height;
  set height(int? value);
  double? get aspectRatio;
  set aspectRatio(double? value);
  double? get frameRate;
  set frameRate(double? value);
  String? get facingMode;
  set facingMode(String? value);
  String? get resizeMode;
  set resizeMode(String? value);
  int? get sampleRate;
  set sampleRate(int? value);
  int? get sampleSize;
  set sampleSize(int? value);
  bool? get echoCancellation;
  set echoCancellation(bool? value);
  bool? get autoGainControl;
  set autoGainControl(bool? value);
  bool? get noiseSuppression;
  set noiseSuppression(bool? value);
  double? get latency;
  set latency(double? value);
  int? get channelCount;
  set channelCount(int? value);
  String? get deviceId;
  set deviceId(String? value);
  String? get groupId;
  set groupId(String? value);
  String? get displaySurface;
  set displaySurface(String? value);
  bool? get logicalSurface;
  set logicalSurface(bool? value);
  String? get cursor;
  set cursor(String? value);
  bool? get restrictOwnAudio;
  set restrictOwnAudio(bool? value);
  bool? get suppressLocalAudioPlayback;
  set suppressLocalAudioPlayback(bool? value);
}

final class MediaTrackSettingsValue implements MediaTrackSettings {
  @override
  String? whiteBalanceMode;
  @override
  String? exposureMode;
  @override
  String? focusMode;
  @override
  List<Point2D>? pointsOfInterest;
  @override
  double? exposureCompensation;
  @override
  double? exposureTime;
  @override
  double? colorTemperature;
  @override
  double? iso;
  @override
  double? brightness;
  @override
  double? contrast;
  @override
  double? saturation;
  @override
  double? sharpness;
  @override
  double? focusDistance;
  @override
  double? pan;
  @override
  double? tilt;
  @override
  double? zoom;
  @override
  bool? torch;
  @override
  int? width;
  @override
  int? height;
  @override
  double? aspectRatio;
  @override
  double? frameRate;
  @override
  String? facingMode;
  @override
  String? resizeMode;
  @override
  int? sampleRate;
  @override
  int? sampleSize;
  @override
  bool? echoCancellation;
  @override
  bool? autoGainControl;
  @override
  bool? noiseSuppression;
  @override
  double? latency;
  @override
  int? channelCount;
  @override
  String? deviceId;
  @override
  String? groupId;
  @override
  String? displaySurface;
  @override
  bool? logicalSurface;
  @override
  String? cursor;
  @override
  bool? restrictOwnAudio;
  @override
  bool? suppressLocalAudioPlayback;

  MediaTrackSettingsValue({
    this.whiteBalanceMode,
    this.exposureMode,
    this.focusMode,
    this.pointsOfInterest,
    this.exposureCompensation,
    this.exposureTime,
    this.colorTemperature,
    this.iso,
    this.brightness,
    this.contrast,
    this.saturation,
    this.sharpness,
    this.focusDistance,
    this.pan,
    this.tilt,
    this.zoom,
    this.torch,
    this.width,
    this.height,
    this.aspectRatio,
    this.frameRate,
    this.facingMode,
    this.resizeMode,
    this.sampleRate,
    this.sampleSize,
    this.echoCancellation,
    this.autoGainControl,
    this.noiseSuppression,
    this.latency,
    this.channelCount,
    this.deviceId,
    this.groupId,
    this.displaySurface,
    this.logicalSurface,
    this.cursor,
    this.restrictOwnAudio,
    this.suppressLocalAudioPlayback,
  });
}

abstract interface class MediaTrackSupportedConstraints {
  bool? get whiteBalanceMode;
  set whiteBalanceMode(bool? value);
  bool? get exposureMode;
  set exposureMode(bool? value);
  bool? get focusMode;
  set focusMode(bool? value);
  bool? get pointsOfInterest;
  set pointsOfInterest(bool? value);
  bool? get exposureCompensation;
  set exposureCompensation(bool? value);
  bool? get exposureTime;
  set exposureTime(bool? value);
  bool? get colorTemperature;
  set colorTemperature(bool? value);
  bool? get iso;
  set iso(bool? value);
  bool? get brightness;
  set brightness(bool? value);
  bool? get contrast;
  set contrast(bool? value);
  bool? get pan;
  set pan(bool? value);
  bool? get saturation;
  set saturation(bool? value);
  bool? get sharpness;
  set sharpness(bool? value);
  bool? get focusDistance;
  set focusDistance(bool? value);
  bool? get tilt;
  set tilt(bool? value);
  bool? get zoom;
  set zoom(bool? value);
  bool? get torch;
  set torch(bool? value);
  bool? get width;
  set width(bool? value);
  bool? get height;
  set height(bool? value);
  bool? get aspectRatio;
  set aspectRatio(bool? value);
  bool? get frameRate;
  set frameRate(bool? value);
  bool? get facingMode;
  set facingMode(bool? value);
  bool? get resizeMode;
  set resizeMode(bool? value);
  bool? get sampleRate;
  set sampleRate(bool? value);
  bool? get sampleSize;
  set sampleSize(bool? value);
  bool? get echoCancellation;
  set echoCancellation(bool? value);
  bool? get autoGainControl;
  set autoGainControl(bool? value);
  bool? get noiseSuppression;
  set noiseSuppression(bool? value);
  bool? get latency;
  set latency(bool? value);
  bool? get channelCount;
  set channelCount(bool? value);
  bool? get deviceId;
  set deviceId(bool? value);
  bool? get groupId;
  set groupId(bool? value);
  bool? get displaySurface;
  set displaySurface(bool? value);
  bool? get logicalSurface;
  set logicalSurface(bool? value);
  bool? get cursor;
  set cursor(bool? value);
  bool? get restrictOwnAudio;
  set restrictOwnAudio(bool? value);
  bool? get suppressLocalAudioPlayback;
  set suppressLocalAudioPlayback(bool? value);
}

final class MediaTrackSupportedConstraintsValue implements MediaTrackSupportedConstraints {
  @override
  bool? whiteBalanceMode;
  @override
  bool? exposureMode;
  @override
  bool? focusMode;
  @override
  bool? pointsOfInterest;
  @override
  bool? exposureCompensation;
  @override
  bool? exposureTime;
  @override
  bool? colorTemperature;
  @override
  bool? iso;
  @override
  bool? brightness;
  @override
  bool? contrast;
  @override
  bool? pan;
  @override
  bool? saturation;
  @override
  bool? sharpness;
  @override
  bool? focusDistance;
  @override
  bool? tilt;
  @override
  bool? zoom;
  @override
  bool? torch;
  @override
  bool? width;
  @override
  bool? height;
  @override
  bool? aspectRatio;
  @override
  bool? frameRate;
  @override
  bool? facingMode;
  @override
  bool? resizeMode;
  @override
  bool? sampleRate;
  @override
  bool? sampleSize;
  @override
  bool? echoCancellation;
  @override
  bool? autoGainControl;
  @override
  bool? noiseSuppression;
  @override
  bool? latency;
  @override
  bool? channelCount;
  @override
  bool? deviceId;
  @override
  bool? groupId;
  @override
  bool? displaySurface;
  @override
  bool? logicalSurface;
  @override
  bool? cursor;
  @override
  bool? restrictOwnAudio;
  @override
  bool? suppressLocalAudioPlayback;

  MediaTrackSupportedConstraintsValue({
    this.whiteBalanceMode,
    this.exposureMode,
    this.focusMode,
    this.pointsOfInterest,
    this.exposureCompensation,
    this.exposureTime,
    this.colorTemperature,
    this.iso,
    this.brightness,
    this.contrast,
    this.pan,
    this.saturation,
    this.sharpness,
    this.focusDistance,
    this.tilt,
    this.zoom,
    this.torch,
    this.width,
    this.height,
    this.aspectRatio,
    this.frameRate,
    this.facingMode,
    this.resizeMode,
    this.sampleRate,
    this.sampleSize,
    this.echoCancellation,
    this.autoGainControl,
    this.noiseSuppression,
    this.latency,
    this.channelCount,
    this.deviceId,
    this.groupId,
    this.displaySurface,
    this.logicalSurface,
    this.cursor,
    this.restrictOwnAudio,
    this.suppressLocalAudioPlayback,
  });
}

typedef MeteringMode = String;

abstract interface class PhotoCapabilities {
  RedEyeReduction? get redEyeReduction;
  set redEyeReduction(RedEyeReduction? value);
  MediaSettingsRange? get imageHeight;
  set imageHeight(MediaSettingsRange? value);
  MediaSettingsRange? get imageWidth;
  set imageWidth(MediaSettingsRange? value);
  List<FillLightMode>? get fillLightMode;
  set fillLightMode(List<FillLightMode>? value);
}

final class PhotoCapabilitiesValue implements PhotoCapabilities {
  @override
  RedEyeReduction? redEyeReduction;
  @override
  MediaSettingsRange? imageHeight;
  @override
  MediaSettingsRange? imageWidth;
  @override
  List<FillLightMode>? fillLightMode;

  PhotoCapabilitiesValue({
    this.redEyeReduction,
    this.imageHeight,
    this.imageWidth,
    this.fillLightMode,
  });
}

abstract interface class PhotoSettings {
  FillLightMode? get fillLightMode;
  set fillLightMode(FillLightMode? value);
  double? get imageHeight;
  set imageHeight(double? value);
  double? get imageWidth;
  set imageWidth(double? value);
  bool? get redEyeReduction;
  set redEyeReduction(bool? value);
}

final class PhotoSettingsValue implements PhotoSettings {
  @override
  FillLightMode? fillLightMode;
  @override
  double? imageHeight;
  @override
  double? imageWidth;
  @override
  bool? redEyeReduction;

  PhotoSettingsValue({
    this.fillLightMode,
    this.imageHeight,
    this.imageWidth,
    this.redEyeReduction,
  });
}

abstract interface class Point2D {
  double? get x;
  set x(double? value);
  double? get y;
  set y(double? value);
}

final class Point2DValue implements Point2D {
  @override
  double? x;
  @override
  double? y;

  Point2DValue({
    this.x,
    this.y,
  });
}

typedef RedEyeReduction = String;

