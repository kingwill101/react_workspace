// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webcodecs-av1-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webcodecs_avc_codec_registration.dart';
import 'webcodecs_hevc_codec_registration.dart';
import 'webcodecs_vp9_codec_registration.dart';

abstract interface class VideoEncoderEncodeOptions {
  VideoEncoderEncodeOptionsForAv1? get av1;
  set av1(VideoEncoderEncodeOptionsForAv1? value);
  VideoEncoderEncodeOptionsForAvc? get avc;
  set avc(VideoEncoderEncodeOptionsForAvc? value);
  VideoEncoderEncodeOptionsForHevc? get hevc;
  set hevc(VideoEncoderEncodeOptionsForHevc? value);
  VideoEncoderEncodeOptionsForVp9? get vp9;
  set vp9(VideoEncoderEncodeOptionsForVp9? value);
  bool? get keyFrame;
  set keyFrame(bool? value);
}

final class VideoEncoderEncodeOptionsValue implements VideoEncoderEncodeOptions {
  @override
  VideoEncoderEncodeOptionsForAv1? av1;
  @override
  VideoEncoderEncodeOptionsForAvc? avc;
  @override
  VideoEncoderEncodeOptionsForHevc? hevc;
  @override
  VideoEncoderEncodeOptionsForVp9? vp9;
  @override
  bool? keyFrame;

  VideoEncoderEncodeOptionsValue({
    this.av1,
    this.avc,
    this.hevc,
    this.vp9,
    this.keyFrame,
  });
}

abstract interface class VideoEncoderEncodeOptionsForAv1 {
  int? get quantizer;
  set quantizer(int? value);
}

final class VideoEncoderEncodeOptionsForAv1Value implements VideoEncoderEncodeOptionsForAv1 {
  @override
  int? quantizer;

  VideoEncoderEncodeOptionsForAv1Value({
    this.quantizer,
  });
}

