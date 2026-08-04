// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-aac-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webcodecs_flac_codec_registration.dart';
import 'webcodecs_opus_codec_registration.dart';
import 'mediastream_recording.dart';

typedef AacBitstreamFormat = String;

abstract interface class AacEncoderConfig {
  AacBitstreamFormat get format;
  set format(AacBitstreamFormat value);
}

abstract interface class AudioEncoderConfig {
  AacEncoderConfig get aac;
  set aac(AacEncoderConfig value);
  FlacEncoderConfig get flac;
  set flac(FlacEncoderConfig value);
  OpusEncoderConfig get opus;
  set opus(OpusEncoderConfig value);
  String get codec;
  set codec(String value);
  int get sampleRate;
  set sampleRate(int value);
  int get numberOfChannels;
  set numberOfChannels(int value);
  int get bitrate;
  set bitrate(int value);
  BitrateMode get bitrateMode;
  set bitrateMode(BitrateMode value);
}

