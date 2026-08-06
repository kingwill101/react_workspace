// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: media-capabilities
// ignore_for_file: type=lint

import 'encrypted_media.dart';

abstract interface class AudioConfiguration {
  String get contentType;
  set contentType(String value);
  String? get channels;
  set channels(String? value);
  int? get bitrate;
  set bitrate(int? value);
  int? get samplerate;
  set samplerate(int? value);
  bool? get spatialRendering;
  set spatialRendering(bool? value);
}

final class AudioConfigurationValue implements AudioConfiguration {
  @override
  String contentType;
  @override
  String? channels;
  @override
  int? bitrate;
  @override
  int? samplerate;
  @override
  bool? spatialRendering;

  AudioConfigurationValue({
    required this.contentType,
    this.channels,
    this.bitrate,
    this.samplerate,
    this.spatialRendering,
  });
}

typedef ColorGamut = String;

typedef HdrMetadataType = String;

abstract interface class KeySystemTrackConfiguration {
  String? get robustness;
  set robustness(String? value);
  String? get encryptionScheme;
  set encryptionScheme(String? value);
}

final class KeySystemTrackConfigurationValue implements KeySystemTrackConfiguration {
  @override
  String? robustness;
  @override
  String? encryptionScheme;

  KeySystemTrackConfigurationValue({
    this.robustness,
    this.encryptionScheme,
  });
}

abstract interface class MediaCapabilities {
  Future<MediaCapabilitiesDecodingInfo> decodingInfo(MediaDecodingConfiguration configuration);
  Future<MediaCapabilitiesEncodingInfo> encodingInfo(MediaEncodingConfiguration configuration);
}

abstract interface class MediaCapabilitiesDecodingInfo {
  MediaKeySystemAccess get keySystemAccess;
  set keySystemAccess(MediaKeySystemAccess value);
  MediaDecodingConfiguration? get configuration;
  set configuration(MediaDecodingConfiguration? value);
}

final class MediaCapabilitiesDecodingInfoValue implements MediaCapabilitiesDecodingInfo {
  @override
  MediaKeySystemAccess keySystemAccess;
  @override
  MediaDecodingConfiguration? configuration;

  MediaCapabilitiesDecodingInfoValue({
    required this.keySystemAccess,
    this.configuration,
  });
}

abstract interface class MediaCapabilitiesEncodingInfo {
  MediaEncodingConfiguration? get configuration;
  set configuration(MediaEncodingConfiguration? value);
}

final class MediaCapabilitiesEncodingInfoValue implements MediaCapabilitiesEncodingInfo {
  @override
  MediaEncodingConfiguration? configuration;

  MediaCapabilitiesEncodingInfoValue({
    this.configuration,
  });
}

abstract interface class MediaCapabilitiesInfo {
  bool get supported;
  set supported(bool value);
  bool get smooth;
  set smooth(bool value);
  bool get powerEfficient;
  set powerEfficient(bool value);
}

final class MediaCapabilitiesInfoValue implements MediaCapabilitiesInfo {
  @override
  bool supported;
  @override
  bool smooth;
  @override
  bool powerEfficient;

  MediaCapabilitiesInfoValue({
    required this.supported,
    required this.smooth,
    required this.powerEfficient,
  });
}

abstract interface class MediaCapabilitiesKeySystemConfiguration {
  String get keySystem;
  set keySystem(String value);
  String? get initDataType;
  set initDataType(String? value);
  MediaKeysRequirement? get distinctiveIdentifier;
  set distinctiveIdentifier(MediaKeysRequirement? value);
  MediaKeysRequirement? get persistentState;
  set persistentState(MediaKeysRequirement? value);
  List<String>? get sessionTypes;
  set sessionTypes(List<String>? value);
  KeySystemTrackConfiguration? get audio;
  set audio(KeySystemTrackConfiguration? value);
  KeySystemTrackConfiguration? get video;
  set video(KeySystemTrackConfiguration? value);
}

final class MediaCapabilitiesKeySystemConfigurationValue implements MediaCapabilitiesKeySystemConfiguration {
  @override
  String keySystem;
  @override
  String? initDataType;
  @override
  MediaKeysRequirement? distinctiveIdentifier;
  @override
  MediaKeysRequirement? persistentState;
  @override
  List<String>? sessionTypes;
  @override
  KeySystemTrackConfiguration? audio;
  @override
  KeySystemTrackConfiguration? video;

  MediaCapabilitiesKeySystemConfigurationValue({
    required this.keySystem,
    this.initDataType,
    this.distinctiveIdentifier,
    this.persistentState,
    this.sessionTypes,
    this.audio,
    this.video,
  });
}

abstract interface class MediaConfiguration {
  VideoConfiguration? get video;
  set video(VideoConfiguration? value);
  AudioConfiguration? get audio;
  set audio(AudioConfiguration? value);
}

final class MediaConfigurationValue implements MediaConfiguration {
  @override
  VideoConfiguration? video;
  @override
  AudioConfiguration? audio;

  MediaConfigurationValue({
    this.video,
    this.audio,
  });
}

abstract interface class MediaDecodingConfiguration {
  MediaDecodingType get type;
  set type(MediaDecodingType value);
  MediaCapabilitiesKeySystemConfiguration? get keySystemConfiguration;
  set keySystemConfiguration(MediaCapabilitiesKeySystemConfiguration? value);
}

final class MediaDecodingConfigurationValue implements MediaDecodingConfiguration {
  @override
  MediaDecodingType type;
  @override
  MediaCapabilitiesKeySystemConfiguration? keySystemConfiguration;

  MediaDecodingConfigurationValue({
    required this.type,
    this.keySystemConfiguration,
  });
}

typedef MediaDecodingType = String;

abstract interface class MediaEncodingConfiguration {
  MediaEncodingType get type;
  set type(MediaEncodingType value);
}

final class MediaEncodingConfigurationValue implements MediaEncodingConfiguration {
  @override
  MediaEncodingType type;

  MediaEncodingConfigurationValue({
    required this.type,
  });
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
  bool? get hasAlphaChannel;
  set hasAlphaChannel(bool? value);
  HdrMetadataType? get hdrMetadataType;
  set hdrMetadataType(HdrMetadataType? value);
  ColorGamut? get colorGamut;
  set colorGamut(ColorGamut? value);
  TransferFunction? get transferFunction;
  set transferFunction(TransferFunction? value);
  String? get scalabilityMode;
  set scalabilityMode(String? value);
  bool? get spatialScalability;
  set spatialScalability(bool? value);
}

final class VideoConfigurationValue implements VideoConfiguration {
  @override
  String contentType;
  @override
  int width;
  @override
  int height;
  @override
  int bitrate;
  @override
  double framerate;
  @override
  bool? hasAlphaChannel;
  @override
  HdrMetadataType? hdrMetadataType;
  @override
  ColorGamut? colorGamut;
  @override
  TransferFunction? transferFunction;
  @override
  String? scalabilityMode;
  @override
  bool? spatialScalability;

  VideoConfigurationValue({
    required this.contentType,
    required this.width,
    required this.height,
    required this.bitrate,
    required this.framerate,
    this.hasAlphaChannel,
    this.hdrMetadataType,
    this.colorGamut,
    this.transferFunction,
    this.scalabilityMode,
    this.spatialScalability,
  });
}

