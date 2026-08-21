// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-aac-codec-registration
// ignore_for_file: type=lint

import 'mediastream_recording.dart';
import 'webcodecs_flac_codec_registration.dart';
import 'webcodecs_opus_codec_registration.dart';

typedef AacBitstreamFormat = String;

abstract interface class AacEncoderConfig {
  AacBitstreamFormat? get format;
  set format(AacBitstreamFormat? value);
}

final class AacEncoderConfigValue implements AacEncoderConfig {
  @override
  AacBitstreamFormat? format;

  AacEncoderConfigValue({this.format});
}

abstract interface class AudioEncoderConfig {
  AacEncoderConfig? get aac;
  set aac(AacEncoderConfig? value);
  FlacEncoderConfig? get flac;
  set flac(FlacEncoderConfig? value);
  OpusEncoderConfig? get opus;
  set opus(OpusEncoderConfig? value);
  String get codec;
  set codec(String value);
  int get sampleRate;
  set sampleRate(int value);
  int get numberOfChannels;
  set numberOfChannels(int value);
  int? get bitrate;
  set bitrate(int? value);
  BitrateMode? get bitrateMode;
  set bitrateMode(BitrateMode? value);
}

final class AudioEncoderConfigValue implements AudioEncoderConfig {
  @override
  AacEncoderConfig? aac;
  @override
  FlacEncoderConfig? flac;
  @override
  OpusEncoderConfig? opus;
  @override
  String codec;
  @override
  int sampleRate;
  @override
  int numberOfChannels;
  @override
  int? bitrate;
  @override
  BitrateMode? bitrateMode;

  AudioEncoderConfigValue({
    this.aac,
    this.flac,
    this.opus,
    required this.codec,
    required this.sampleRate,
    required this.numberOfChannels,
    this.bitrate,
    this.bitrateMode,
  });
}
