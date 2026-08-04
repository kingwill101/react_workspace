// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediacapture-automation
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class MockCameraConfiguration {
  double get defaultFrameRate;
  set defaultFrameRate(double value);
  String get facingMode;
  set facingMode(String value);
}

abstract interface class MockCaptureDeviceConfiguration {
  String get label;
  set label(String value);
  String get deviceId;
  set deviceId(String value);
  String get groupId;
  set groupId(String value);
}

typedef MockCapturePromptResult = String;

abstract interface class MockCapturePromptResultConfiguration {
  MockCapturePromptResult get getUserMedia;
  set getUserMedia(MockCapturePromptResult value);
  MockCapturePromptResult get getDisplayMedia;
  set getDisplayMedia(MockCapturePromptResult value);
}

abstract interface class MockMicrophoneConfiguration {
  int get defaultSampleRate;
  set defaultSampleRate(int value);
}

