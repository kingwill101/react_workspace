// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webcodecs-hevc-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


typedef HevcBitstreamFormat = String;

abstract interface class HevcEncoderConfig {
  HevcBitstreamFormat? get format;
  set format(HevcBitstreamFormat? value);
}

final class HevcEncoderConfigValue implements HevcEncoderConfig {
  @override
  HevcBitstreamFormat? format;

  HevcEncoderConfigValue({
    this.format,
  });
}

abstract interface class VideoEncoderEncodeOptionsForHevc {
  int? get quantizer;
  set quantizer(int? value);
}

final class VideoEncoderEncodeOptionsForHevcValue implements VideoEncoderEncodeOptionsForHevc {
  @override
  int? quantizer;

  VideoEncoderEncodeOptionsForHevcValue({
    this.quantizer,
  });
}

