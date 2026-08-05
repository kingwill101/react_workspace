// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'html.dart';
import 'dom.dart';
import 'webrtc_priority.dart';
import 'webrtc_ice.dart';
import 'webrtc_identity.dart';
import 'webidl.dart';
import 'webrtc_encoded_transform.dart';
import 'mediacapture_streams.dart';
import 'webrtc_stats.dart';
import 'capture_handle_identity.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class RTCAnswerOptions {
}

typedef RTCBundlePolicy = String;

abstract interface class RTCCertificate {
  EpochTimeStamp get expires;
  List<RTCDtlsFingerprint> getFingerprints();
}

abstract interface class RTCCertificateExpiration {
  int get expires;
  set expires(int value);
}

abstract interface class RTCDTMFSender {
  void insertDTMF(String tones, [int? duration, int? interToneGap]);
  EventHandler get ontonechange;
   set ontonechange(EventHandler value);
  bool get canInsertDTMF;
  String get toneBuffer;
}

abstract interface class RTCDTMFToneChangeEvent {
  factory RTCDTMFToneChangeEvent(String type, [RTCDTMFToneChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<RTCDTMFToneChangeEvent>(
        'RTCDTMFToneChangeEvent',
        [type, eventInitDict],
      );
  String get tone;
}

abstract interface class RTCDTMFToneChangeEventInit {
  String get tone;
  set tone(String value);
}

abstract interface class RTCDataChannelEvent {
  factory RTCDataChannelEvent(String type, RTCDataChannelEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCDataChannelEvent>(
        'RTCDataChannelEvent',
        [type, eventInitDict],
      );
  RTCDataChannel get channel;
}

abstract interface class RTCDataChannelEventInit {
  RTCDataChannel get channel;
  set channel(RTCDataChannel value);
}

typedef RTCDataChannelState = String;

abstract interface class RTCDtlsFingerprint {
  String get algorithm;
  set algorithm(String value);
  String get value;
  set value(String value);
}

abstract interface class RTCDtlsTransport {
  RTCIceTransport get iceTransport;
  RTCDtlsTransportState get state;
  List<Object> getRemoteCertificates();
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
}

typedef RTCDtlsTransportState = String;

typedef RTCErrorDetailType = String;

abstract interface class RTCErrorEvent {
  factory RTCErrorEvent(String type, RTCErrorEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCErrorEvent>(
        'RTCErrorEvent',
        [type, eventInitDict],
      );
  RTCError get error;
}

abstract interface class RTCErrorEventInit {
  RTCError get error;
  set error(RTCError value);
}

abstract interface class RTCIceCandidate {
  factory RTCIceCandidate([RTCIceCandidateInit? candidateInitDict]) =>
      WebRuntime.current.createWebObject<RTCIceCandidate>(
        'RTCIceCandidate',
        [candidateInitDict],
      );
  String get candidate;
  String? get sdpMid;
  int? get sdpMLineIndex;
  String? get foundation;
  RTCIceComponent? get component;
  int? get priority;
  String? get address;
  RTCIceProtocol? get protocol;
  int? get port;
  RTCIceCandidateType? get type;
  RTCIceTcpCandidateType? get tcpType;
  String? get relatedAddress;
  int? get relatedPort;
  String? get usernameFragment;
  RTCIceCandidateInit toJSON();
}

abstract interface class RTCIceCandidateInit {
  String get candidate;
  set candidate(String value);
  String? get sdpMid;
  set sdpMid(String? value);
  int? get sdpMLineIndex;
  set sdpMLineIndex(int? value);
  String? get usernameFragment;
  set usernameFragment(String? value);
}

typedef RTCIceCandidateType = String;

typedef RTCIceComponent = String;

typedef RTCIceConnectionState = String;

typedef RTCIceGathererState = String;

typedef RTCIceGatheringState = String;

typedef RTCIceProtocol = String;

typedef RTCIceRole = String;

abstract interface class RTCIceServer {
  Object get urls;
  set urls(Object value);
  String get username;
  set username(String value);
  String get credential;
  set credential(String value);
}

typedef RTCIceServerTransportProtocol = String;

typedef RTCIceTcpCandidateType = String;

typedef RTCIceTransportPolicy = String;

typedef RTCIceTransportState = String;

abstract interface class RTCLocalSessionDescriptionInit {
  RTCSdpType get type;
  set type(RTCSdpType value);
  String get sdp;
  set sdp(String value);
}

abstract interface class RTCOfferAnswerOptions {
}

abstract interface class RTCOfferOptions {
  bool get iceRestart;
  set iceRestart(bool value);
  bool get offerToReceiveAudio;
  set offerToReceiveAudio(bool value);
  bool get offerToReceiveVideo;
  set offerToReceiveVideo(bool value);
}

typedef RTCPeerConnectionErrorCallback = void Function(DOMException error,);

abstract interface class RTCPeerConnectionIceErrorEvent {
  factory RTCPeerConnectionIceErrorEvent(String type, RTCPeerConnectionIceErrorEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCPeerConnectionIceErrorEvent>(
        'RTCPeerConnectionIceErrorEvent',
        [type, eventInitDict],
      );
  String? get address;
  int? get port;
  String get url;
  int get errorCode;
  String get errorText;
}

abstract interface class RTCPeerConnectionIceErrorEventInit {
  String? get address;
  set address(String? value);
  int? get port;
  set port(int? value);
  String get url;
  set url(String value);
  int get errorCode;
  set errorCode(int value);
  String get errorText;
  set errorText(String value);
}

abstract interface class RTCPeerConnectionIceEvent {
  factory RTCPeerConnectionIceEvent(String type, [RTCPeerConnectionIceEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<RTCPeerConnectionIceEvent>(
        'RTCPeerConnectionIceEvent',
        [type, eventInitDict],
      );
  RTCIceCandidate? get candidate;
  String? get url;
}

abstract interface class RTCPeerConnectionIceEventInit {
  RTCIceCandidate? get candidate;
  set candidate(RTCIceCandidate? value);
  String? get url;
  set url(String? value);
}

typedef RTCPeerConnectionState = String;

typedef RTCRtcpMuxPolicy = String;

abstract interface class RTCRtcpParameters {
  String get cname;
  set cname(String value);
  bool get reducedSize;
  set reducedSize(bool value);
}

abstract interface class RTCRtpCapabilities {
  List<RTCRtpCodec> get codecs;
  set codecs(List<RTCRtpCodec> value);
  List<RTCRtpHeaderExtensionCapability> get headerExtensions;
  set headerExtensions(List<RTCRtpHeaderExtensionCapability> value);
}

abstract interface class RTCRtpCodec {
  String get mimeType;
  set mimeType(String value);
  int get clockRate;
  set clockRate(int value);
  int get channels;
  set channels(int value);
  String get sdpFmtpLine;
  set sdpFmtpLine(String value);
}

abstract interface class RTCRtpCodecParameters {
  Object get payloadType;
  set payloadType(Object value);
}

abstract interface class RTCRtpCodingParameters {
  String get rid;
  set rid(String value);
}

abstract interface class RTCRtpContributingSource {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  int get source;
  set source(int value);
  double get audioLevel;
  set audioLevel(double value);
  int get rtpTimestamp;
  set rtpTimestamp(int value);
}

abstract interface class RTCRtpHeaderExtensionCapability {
  String get uri;
  set uri(String value);
}

abstract interface class RTCRtpHeaderExtensionParameters {
  String get uri;
  set uri(String value);
  int get id;
  set id(int value);
  bool get encrypted;
  set encrypted(bool value);
}

abstract interface class RTCRtpParameters {
  List<RTCRtpHeaderExtensionParameters> get headerExtensions;
  set headerExtensions(List<RTCRtpHeaderExtensionParameters> value);
  RTCRtcpParameters get rtcp;
  set rtcp(RTCRtcpParameters value);
  List<RTCRtpCodecParameters> get codecs;
  set codecs(List<RTCRtpCodecParameters> value);
}

abstract interface class RTCRtpReceiveParameters {
}

abstract interface class RTCRtpSynchronizationSource {
}

abstract interface class RTCRtpTransceiver {
  String? get mid;
  RTCRtpSender get sender;
  RTCRtpReceiver get receiver;
  RTCRtpTransceiverDirection get direction;
   set direction(RTCRtpTransceiverDirection value);
  RTCRtpTransceiverDirection? get currentDirection;
  void stop();
  void setCodecPreferences(List<RTCRtpCodec> codecs);
}

typedef RTCRtpTransceiverDirection = String;

abstract interface class RTCRtpTransceiverInit {
  RTCRtpTransceiverDirection get direction;
  set direction(RTCRtpTransceiverDirection value);
  List<MediaStream> get streams;
  set streams(List<MediaStream> value);
  List<RTCRtpEncodingParameters> get sendEncodings;
  set sendEncodings(List<RTCRtpEncodingParameters> value);
}

abstract interface class RTCSctpTransport {
  RTCDtlsTransport get transport;
  RTCSctpTransportState get state;
  double get maxMessageSize;
  int? get maxChannels;
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
}

typedef RTCSctpTransportState = String;

typedef RTCSdpType = String;

abstract interface class RTCSessionDescription {
  factory RTCSessionDescription(RTCSessionDescriptionInit descriptionInitDict) =>
      WebRuntime.current.createWebObject<RTCSessionDescription>(
        'RTCSessionDescription',
        [descriptionInitDict],
      );
  RTCSdpType get type;
  String get sdp;
  RTCSessionDescriptionInit toJSON();
}

typedef RTCSessionDescriptionCallback = void Function(RTCSessionDescriptionInit description,);

abstract interface class RTCSessionDescriptionInit {
  RTCSdpType get type;
  set type(RTCSdpType value);
  String get sdp;
  set sdp(String value);
}

abstract interface class RTCSetParameterOptions {
}

typedef RTCSignalingState = String;

abstract interface class RTCStats {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  RTCStatsType get type;
  set type(RTCStatsType value);
  String get id;
  set id(String value);
}

abstract interface class RTCStatsReport {
}

abstract interface class RTCTrackEvent {
  factory RTCTrackEvent(String type, RTCTrackEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCTrackEvent>(
        'RTCTrackEvent',
        [type, eventInitDict],
      );
  RTCRtpReceiver get receiver;
  MediaStreamTrack get track;
  List<MediaStream> get streams;
  RTCRtpTransceiver get transceiver;
}

abstract interface class RTCTrackEventInit {
  RTCRtpReceiver get receiver;
  set receiver(RTCRtpReceiver value);
  MediaStreamTrack get track;
  set track(MediaStreamTrack value);
  List<MediaStream> get streams;
  set streams(List<MediaStream> value);
  RTCRtpTransceiver get transceiver;
  set transceiver(RTCRtpTransceiver value);
}

