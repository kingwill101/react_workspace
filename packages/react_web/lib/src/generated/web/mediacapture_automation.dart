// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediacapture-automation
// ignore_for_file: type=lint


abstract interface class MockCameraConfiguration {
  double? get defaultFrameRate;
  set defaultFrameRate(double? value);
  String? get facingMode;
  set facingMode(String? value);
}

final class MockCameraConfigurationValue implements MockCameraConfiguration {
  @override
  double? defaultFrameRate;
  @override
  String? facingMode;

  MockCameraConfigurationValue({
    this.defaultFrameRate,
    this.facingMode,
  });
}

abstract interface class MockCaptureDeviceConfiguration {
  String? get label;
  set label(String? value);
  String? get deviceId;
  set deviceId(String? value);
  String? get groupId;
  set groupId(String? value);
}

final class MockCaptureDeviceConfigurationValue implements MockCaptureDeviceConfiguration {
  @override
  String? label;
  @override
  String? deviceId;
  @override
  String? groupId;

  MockCaptureDeviceConfigurationValue({
    this.label,
    this.deviceId,
    this.groupId,
  });
}

typedef MockCapturePromptResult = String;

abstract interface class MockCapturePromptResultConfiguration {
  MockCapturePromptResult? get getUserMedia;
  set getUserMedia(MockCapturePromptResult? value);
  MockCapturePromptResult? get getDisplayMedia;
  set getDisplayMedia(MockCapturePromptResult? value);
}

final class MockCapturePromptResultConfigurationValue implements MockCapturePromptResultConfiguration {
  @override
  MockCapturePromptResult? getUserMedia;
  @override
  MockCapturePromptResult? getDisplayMedia;

  MockCapturePromptResultConfigurationValue({
    this.getUserMedia,
    this.getDisplayMedia,
  });
}

abstract interface class MockMicrophoneConfiguration {
  int? get defaultSampleRate;
  set defaultSampleRate(int? value);
}

final class MockMicrophoneConfigurationValue implements MockMicrophoneConfiguration {
  @override
  int? defaultSampleRate;

  MockMicrophoneConfigurationValue({
    this.defaultSampleRate,
  });
}

