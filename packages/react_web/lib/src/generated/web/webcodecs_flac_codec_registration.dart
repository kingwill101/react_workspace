// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-flac-codec-registration
// ignore_for_file: type=lint

abstract interface class FlacEncoderConfig {
  int? get blockSize;
  set blockSize(int? value);
  int? get compressLevel;
  set compressLevel(int? value);
}

final class FlacEncoderConfigValue implements FlacEncoderConfig {
  @override
  int? blockSize;
  @override
  int? compressLevel;

  FlacEncoderConfigValue({this.blockSize, this.compressLevel});
}
