// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mst-content-hint
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc_priority.dart';
import 'webrtc.dart';

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

