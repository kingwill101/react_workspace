// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-opus-codec-registration
// ignore_for_file: type=lint


typedef OpusApplication = String;

typedef OpusBitstreamFormat = String;

abstract interface class OpusEncoderConfig {
  OpusBitstreamFormat? get format;
  set format(OpusBitstreamFormat? value);
  OpusSignal? get signal;
  set signal(OpusSignal? value);
  OpusApplication? get application;
  set application(OpusApplication? value);
  int? get frameDuration;
  set frameDuration(int? value);
  int? get complexity;
  set complexity(int? value);
  int? get packetlossperc;
  set packetlossperc(int? value);
  bool? get useinbandfec;
  set useinbandfec(bool? value);
  bool? get usedtx;
  set usedtx(bool? value);
}

final class OpusEncoderConfigValue implements OpusEncoderConfig {
  @override
  OpusBitstreamFormat? format;
  @override
  OpusSignal? signal;
  @override
  OpusApplication? application;
  @override
  int? frameDuration;
  @override
  int? complexity;
  @override
  int? packetlossperc;
  @override
  bool? useinbandfec;
  @override
  bool? usedtx;

  OpusEncoderConfigValue({
    this.format,
    this.signal,
    this.application,
    this.frameDuration,
    this.complexity,
    this.packetlossperc,
    this.useinbandfec,
    this.usedtx,
  });
}

typedef OpusSignal = String;

