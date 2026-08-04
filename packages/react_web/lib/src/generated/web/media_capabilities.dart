// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: media-capabilities
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'encrypted_media.dart';

abstract interface class AudioConfiguration {
  String get contentType;
  set contentType(String value);
  String get channels;
  set channels(String value);
  int get bitrate;
  set bitrate(int value);
  int get samplerate;
  set samplerate(int value);
  bool get spatialRendering;
  set spatialRendering(bool value);
}

typedef ColorGamut = String;

typedef HdrMetadataType = String;

abstract interface class KeySystemTrackConfiguration {
  String get robustness;
  set robustness(String value);
  String? get encryptionScheme;
  set encryptionScheme(String? value);
}

abstract interface class MediaCapabilities {
  Future<MediaCapabilitiesDecodingInfo> decodingInfo(MediaDecodingConfiguration configuration);
  Future<MediaCapabilitiesEncodingInfo> encodingInfo(MediaEncodingConfiguration configuration);
}

abstract interface class MediaCapabilitiesDecodingInfo {
  MediaKeySystemAccess? get keySystemAccess;
  set keySystemAccess(MediaKeySystemAccess? value);
  MediaDecodingConfiguration get configuration;
  set configuration(MediaDecodingConfiguration value);
}

abstract interface class MediaCapabilitiesEncodingInfo {
  MediaEncodingConfiguration get configuration;
  set configuration(MediaEncodingConfiguration value);
}

abstract interface class MediaCapabilitiesInfo {
  bool get supported;
  set supported(bool value);
  bool get smooth;
  set smooth(bool value);
  bool get powerEfficient;
  set powerEfficient(bool value);
}

abstract interface class MediaCapabilitiesKeySystemConfiguration {
  String get keySystem;
  set keySystem(String value);
  String get initDataType;
  set initDataType(String value);
  MediaKeysRequirement get distinctiveIdentifier;
  set distinctiveIdentifier(MediaKeysRequirement value);
  MediaKeysRequirement get persistentState;
  set persistentState(MediaKeysRequirement value);
  List<String> get sessionTypes;
  set sessionTypes(List<String> value);
  KeySystemTrackConfiguration get audio;
  set audio(KeySystemTrackConfiguration value);
  KeySystemTrackConfiguration get video;
  set video(KeySystemTrackConfiguration value);
}

abstract interface class MediaConfiguration {
  VideoConfiguration get video;
  set video(VideoConfiguration value);
  AudioConfiguration get audio;
  set audio(AudioConfiguration value);
}

abstract interface class MediaDecodingConfiguration {
  MediaDecodingType get type;
  set type(MediaDecodingType value);
  MediaCapabilitiesKeySystemConfiguration get keySystemConfiguration;
  set keySystemConfiguration(MediaCapabilitiesKeySystemConfiguration value);
}

typedef MediaDecodingType = String;

abstract interface class MediaEncodingConfiguration {
  MediaEncodingType get type;
  set type(MediaEncodingType value);
}

typedef MediaEncodingType = String;

typedef TransferFunction = String;

abstract interface class VideoConfiguration {
  String get contentType;
  set contentType(String value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int get bitrate;
  set bitrate(int value);
  double get framerate;
  set framerate(double value);
  bool get hasAlphaChannel;
  set hasAlphaChannel(bool value);
  HdrMetadataType get hdrMetadataType;
  set hdrMetadataType(HdrMetadataType value);
  ColorGamut get colorGamut;
  set colorGamut(ColorGamut value);
  TransferFunction get transferFunction;
  set transferFunction(TransferFunction value);
  String get scalabilityMode;
  set scalabilityMode(String value);
  bool get spatialScalability;
  set spatialScalability(bool value);
}

