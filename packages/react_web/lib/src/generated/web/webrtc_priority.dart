// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webrtc-priority
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc.dart';
import 'html.dart';
import 'websockets.dart';
import 'fileapi.dart';
import 'webidl.dart';

abstract interface class RTCDataChannel {
  String get label;
  bool get ordered;
  int? get maxPacketLifeTime;
  int? get maxRetransmits;
  String get protocol;
  bool get negotiated;
  int? get id;
  RTCDataChannelState get readyState;
  int get bufferedAmount;
  int get bufferedAmountLowThreshold;
   set bufferedAmountLowThreshold(int value);
  EventHandler get onopen;
   set onopen(EventHandler value);
  EventHandler get onbufferedamountlow;
   set onbufferedamountlow(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onclosing;
   set onclosing(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  void close();
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  BinaryType get binaryType;
   set binaryType(BinaryType value);
  void send(String data);
}

abstract interface class RTCDataChannelInit {
  RTCPriorityType? get priority;
  set priority(RTCPriorityType? value);
  bool? get ordered;
  set ordered(bool? value);
  int? get maxPacketLifeTime;
  set maxPacketLifeTime(int? value);
  int? get maxRetransmits;
  set maxRetransmits(int? value);
  String? get protocol;
  set protocol(String? value);
  bool? get negotiated;
  set negotiated(bool? value);
  int? get id;
  set id(int? value);
}

final class RTCDataChannelInitValue implements RTCDataChannelInit {
  @override
  RTCPriorityType? priority;
  @override
  bool? ordered;
  @override
  int? maxPacketLifeTime;
  @override
  int? maxRetransmits;
  @override
  String? protocol;
  @override
  bool? negotiated;
  @override
  int? id;

  RTCDataChannelInitValue({
    this.priority,
    this.ordered,
    this.maxPacketLifeTime,
    this.maxRetransmits,
    this.protocol,
    this.negotiated,
    this.id,
  });
}

typedef RTCPriorityType = String;

abstract interface class RTCRtpEncodingParameters {
  RTCPriorityType? get priority;
  set priority(RTCPriorityType? value);
  RTCPriorityType? get networkPriority;
  set networkPriority(RTCPriorityType? value);
  String? get scalabilityMode;
  set scalabilityMode(String? value);
  bool? get active;
  set active(bool? value);
  int? get maxBitrate;
  set maxBitrate(int? value);
  double? get maxFramerate;
  set maxFramerate(double? value);
  double? get scaleResolutionDownBy;
  set scaleResolutionDownBy(double? value);
}

final class RTCRtpEncodingParametersValue implements RTCRtpEncodingParameters {
  @override
  RTCPriorityType? priority;
  @override
  RTCPriorityType? networkPriority;
  @override
  String? scalabilityMode;
  @override
  bool? active;
  @override
  int? maxBitrate;
  @override
  double? maxFramerate;
  @override
  double? scaleResolutionDownBy;

  RTCRtpEncodingParametersValue({
    this.priority,
    this.networkPriority,
    this.scalabilityMode,
    this.active,
    this.maxBitrate,
    this.maxFramerate,
    this.scaleResolutionDownBy,
  });
}

