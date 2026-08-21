// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mst-content-hint
// ignore_for_file: type=lint

import 'webrtc_priority.dart';

typedef RTCDegradationPreference = String;

abstract interface class RTCRtpSendParameters {
  RTCDegradationPreference? get degradationPreference;
  set degradationPreference(RTCDegradationPreference? value);
  String get transactionId;
  set transactionId(String value);
  List<RTCRtpEncodingParameters> get encodings;
  set encodings(List<RTCRtpEncodingParameters> value);
}

final class RTCRtpSendParametersValue implements RTCRtpSendParameters {
  @override
  RTCDegradationPreference? degradationPreference;
  @override
  String transactionId;
  @override
  List<RTCRtpEncodingParameters> encodings;

  RTCRtpSendParametersValue({
    this.degradationPreference,
    required this.transactionId,
    required this.encodings,
  });
}
