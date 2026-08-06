// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webcodecs-avc-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webcodecs_hevc_codec_registration.dart';
import 'webcodecs.dart';

typedef AvcBitstreamFormat = String;

abstract interface class AvcEncoderConfig {
  AvcBitstreamFormat? get format;
  set format(AvcBitstreamFormat? value);
}

final class AvcEncoderConfigValue implements AvcEncoderConfig {
  @override
  AvcBitstreamFormat? format;

  AvcEncoderConfigValue({
    this.format,
  });
}

abstract interface class VideoEncoderConfig {
  AvcEncoderConfig? get avc;
  set avc(AvcEncoderConfig? value);
  HevcEncoderConfig? get hevc;
  set hevc(HevcEncoderConfig? value);
  String get codec;
  set codec(String value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int? get displayWidth;
  set displayWidth(int? value);
  int? get displayHeight;
  set displayHeight(int? value);
  int? get bitrate;
  set bitrate(int? value);
  double? get framerate;
  set framerate(double? value);
  HardwareAcceleration? get hardwareAcceleration;
  set hardwareAcceleration(HardwareAcceleration? value);
  AlphaOption? get alpha;
  set alpha(AlphaOption? value);
  String? get scalabilityMode;
  set scalabilityMode(String? value);
  VideoEncoderBitrateMode? get bitrateMode;
  set bitrateMode(VideoEncoderBitrateMode? value);
  LatencyMode? get latencyMode;
  set latencyMode(LatencyMode? value);
  String? get contentHint;
  set contentHint(String? value);
}

final class VideoEncoderConfigValue implements VideoEncoderConfig {
  @override
  AvcEncoderConfig? avc;
  @override
  HevcEncoderConfig? hevc;
  @override
  String codec;
  @override
  int width;
  @override
  int height;
  @override
  int? displayWidth;
  @override
  int? displayHeight;
  @override
  int? bitrate;
  @override
  double? framerate;
  @override
  HardwareAcceleration? hardwareAcceleration;
  @override
  AlphaOption? alpha;
  @override
  String? scalabilityMode;
  @override
  VideoEncoderBitrateMode? bitrateMode;
  @override
  LatencyMode? latencyMode;
  @override
  String? contentHint;

  VideoEncoderConfigValue({
    this.avc,
    this.hevc,
    required this.codec,
    required this.width,
    required this.height,
    this.displayWidth,
    this.displayHeight,
    this.bitrate,
    this.framerate,
    this.hardwareAcceleration,
    this.alpha,
    this.scalabilityMode,
    this.bitrateMode,
    this.latencyMode,
    this.contentHint,
  });
}

abstract interface class VideoEncoderEncodeOptionsForAvc {
  int? get quantizer;
  set quantizer(int? value);
}

final class VideoEncoderEncodeOptionsForAvcValue implements VideoEncoderEncodeOptionsForAvc {
  @override
  int? quantizer;

  VideoEncoderEncodeOptionsForAvcValue({
    this.quantizer,
  });
}

