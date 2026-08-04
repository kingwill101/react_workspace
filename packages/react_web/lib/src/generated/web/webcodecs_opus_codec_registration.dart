// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webcodecs-opus-codec-registration
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


typedef OpusApplication = String;

typedef OpusBitstreamFormat = String;

abstract interface class OpusEncoderConfig {
  OpusBitstreamFormat get format;
  set format(OpusBitstreamFormat value);
  OpusSignal get signal;
  set signal(OpusSignal value);
  OpusApplication get application;
  set application(OpusApplication value);
  int get frameDuration;
  set frameDuration(int value);
  int get complexity;
  set complexity(int value);
  int get packetlossperc;
  set packetlossperc(int value);
  bool get useinbandfec;
  set useinbandfec(bool value);
  bool get usedtx;
  set usedtx(bool value);
}

typedef OpusSignal = String;

