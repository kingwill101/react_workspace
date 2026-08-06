// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-hevc-codec-registration
// ignore_for_file: type=lint


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

