// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-hevc-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


typedef HevcBitstreamFormat = String;

abstract interface class HevcEncoderConfig {
  HevcBitstreamFormat get format;
  set format(HevcBitstreamFormat value);
}

abstract interface class VideoEncoderEncodeOptionsForHevc {
  int? get quantizer;
  set quantizer(int? value);
}

