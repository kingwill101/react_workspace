// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc
// ignore_for_file: type=lint

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

final class RTCAnswerOptionsValue implements RTCAnswerOptions {

  RTCAnswerOptionsValue();
}

typedef RTCBundlePolicy = String;

abstract interface class RTCCertificate {
  EpochTimeStamp get expires;
  List<RTCDtlsFingerprint> getFingerprints();
}

abstract interface class RTCCertificateExpiration {
  int? get expires;
  set expires(int? value);
}

final class RTCCertificateExpirationValue implements RTCCertificateExpiration {
  @override
  int? expires;

  RTCCertificateExpirationValue({
    this.expires,
  });
}

abstract interface class RTCDTMFSender {
  void insertDTMF(String tones, [int? duration, int? interToneGap]);
  EventHandler get ontonechange;
   set ontonechange(EventHandler value);
  bool get canInsertDTMF;
  String get toneBuffer;
}

abstract interface class RTCDTMFToneChangeEvent {
  factory RTCDTMFToneChangeEvent(String type_, [RTCDTMFToneChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<RTCDTMFToneChangeEvent>(
        'RTCDTMFToneChangeEvent',
        [type_, eventInitDict],
      );
  String get tone;
}

abstract interface class RTCDTMFToneChangeEventInit {
  String? get tone;
  set tone(String? value);
}

final class RTCDTMFToneChangeEventInitValue implements RTCDTMFToneChangeEventInit {
  @override
  String? tone;

  RTCDTMFToneChangeEventInitValue({
    this.tone,
  });
}

abstract interface class RTCDataChannelEvent {
  factory RTCDataChannelEvent(String type_, RTCDataChannelEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCDataChannelEvent>(
        'RTCDataChannelEvent',
        [type_, eventInitDict],
      );
  RTCDataChannel get channel;
}

abstract interface class RTCDataChannelEventInit {
  RTCDataChannel get channel;
  set channel(RTCDataChannel value);
}

final class RTCDataChannelEventInitValue implements RTCDataChannelEventInit {
  @override
  RTCDataChannel channel;

  RTCDataChannelEventInitValue({
    required this.channel,
  });
}

typedef RTCDataChannelState = String;

abstract interface class RTCDtlsFingerprint {
  String? get algorithm;
  set algorithm(String? value);
  String? get value;
  set value(String? value);
}

final class RTCDtlsFingerprintValue implements RTCDtlsFingerprint {
  @override
  String? algorithm;
  @override
  String? value;

  RTCDtlsFingerprintValue({
    this.algorithm,
    this.value,
  });
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
  factory RTCErrorEvent(String type_, RTCErrorEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCErrorEvent>(
        'RTCErrorEvent',
        [type_, eventInitDict],
      );
  RTCError get error;
}

abstract interface class RTCErrorEventInit {
  RTCError get error;
  set error(RTCError value);
}

final class RTCErrorEventInitValue implements RTCErrorEventInit {
  @override
  RTCError error;

  RTCErrorEventInitValue({
    required this.error,
  });
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
  RTCIceCandidateType? get type_;
  RTCIceTcpCandidateType? get tcpType;
  String? get relatedAddress;
  int? get relatedPort;
  String? get usernameFragment;
  RTCIceCandidateInit toJSON();
}

abstract interface class RTCIceCandidateInit {
  String? get candidate;
  set candidate(String? value);
  String? get sdpMid;
  set sdpMid(String? value);
  int? get sdpMLineIndex;
  set sdpMLineIndex(int? value);
  String? get usernameFragment;
  set usernameFragment(String? value);
}

final class RTCIceCandidateInitValue implements RTCIceCandidateInit {
  @override
  String? candidate;
  @override
  String? sdpMid;
  @override
  int? sdpMLineIndex;
  @override
  String? usernameFragment;

  RTCIceCandidateInitValue({
    this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
    this.usernameFragment,
  });
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
  String? get username;
  set username(String? value);
  String? get credential;
  set credential(String? value);
}

final class RTCIceServerValue implements RTCIceServer {
  @override
  Object urls;
  @override
  String? username;
  @override
  String? credential;

  RTCIceServerValue({
    required this.urls,
    this.username,
    this.credential,
  });
}

typedef RTCIceServerTransportProtocol = String;

typedef RTCIceTcpCandidateType = String;

typedef RTCIceTransportPolicy = String;

typedef RTCIceTransportState = String;

abstract interface class RTCLocalSessionDescriptionInit {
  RTCSdpType? get type_;
  set type_(RTCSdpType? value);
  String? get sdp;
  set sdp(String? value);
}

final class RTCLocalSessionDescriptionInitValue implements RTCLocalSessionDescriptionInit {
  @override
  RTCSdpType? type_;
  @override
  String? sdp;

  RTCLocalSessionDescriptionInitValue({
    this.type_,
    this.sdp,
  });
}

abstract interface class RTCOfferAnswerOptions {
}

final class RTCOfferAnswerOptionsValue implements RTCOfferAnswerOptions {

  RTCOfferAnswerOptionsValue();
}

abstract interface class RTCOfferOptions {
  bool? get iceRestart;
  set iceRestart(bool? value);
  bool? get offerToReceiveAudio;
  set offerToReceiveAudio(bool? value);
  bool? get offerToReceiveVideo;
  set offerToReceiveVideo(bool? value);
}

final class RTCOfferOptionsValue implements RTCOfferOptions {
  @override
  bool? iceRestart;
  @override
  bool? offerToReceiveAudio;
  @override
  bool? offerToReceiveVideo;

  RTCOfferOptionsValue({
    this.iceRestart,
    this.offerToReceiveAudio,
    this.offerToReceiveVideo,
  });
}

typedef RTCPeerConnectionErrorCallback = void Function(DOMException error,);

abstract interface class RTCPeerConnectionIceErrorEvent {
  factory RTCPeerConnectionIceErrorEvent(String type_, RTCPeerConnectionIceErrorEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCPeerConnectionIceErrorEvent>(
        'RTCPeerConnectionIceErrorEvent',
        [type_, eventInitDict],
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
  String? get url;
  set url(String? value);
  int get errorCode;
  set errorCode(int value);
  String? get errorText;
  set errorText(String? value);
}

final class RTCPeerConnectionIceErrorEventInitValue implements RTCPeerConnectionIceErrorEventInit {
  @override
  String? address;
  @override
  int? port;
  @override
  String? url;
  @override
  int errorCode;
  @override
  String? errorText;

  RTCPeerConnectionIceErrorEventInitValue({
    this.address,
    this.port,
    this.url,
    required this.errorCode,
    this.errorText,
  });
}

abstract interface class RTCPeerConnectionIceEvent {
  factory RTCPeerConnectionIceEvent(String type_, [RTCPeerConnectionIceEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<RTCPeerConnectionIceEvent>(
        'RTCPeerConnectionIceEvent',
        [type_, eventInitDict],
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

final class RTCPeerConnectionIceEventInitValue implements RTCPeerConnectionIceEventInit {
  @override
  RTCIceCandidate? candidate;
  @override
  String? url;

  RTCPeerConnectionIceEventInitValue({
    this.candidate,
    this.url,
  });
}

typedef RTCPeerConnectionState = String;

typedef RTCRtcpMuxPolicy = String;

abstract interface class RTCRtcpParameters {
  String? get cname;
  set cname(String? value);
  bool? get reducedSize;
  set reducedSize(bool? value);
}

final class RTCRtcpParametersValue implements RTCRtcpParameters {
  @override
  String? cname;
  @override
  bool? reducedSize;

  RTCRtcpParametersValue({
    this.cname,
    this.reducedSize,
  });
}

abstract interface class RTCRtpCapabilities {
  List<RTCRtpCodec> get codecs;
  set codecs(List<RTCRtpCodec> value);
  List<RTCRtpHeaderExtensionCapability> get headerExtensions;
  set headerExtensions(List<RTCRtpHeaderExtensionCapability> value);
}

final class RTCRtpCapabilitiesValue implements RTCRtpCapabilities {
  @override
  List<RTCRtpCodec> codecs;
  @override
  List<RTCRtpHeaderExtensionCapability> headerExtensions;

  RTCRtpCapabilitiesValue({
    required this.codecs,
    required this.headerExtensions,
  });
}

abstract interface class RTCRtpCodec {
  String get mimeType;
  set mimeType(String value);
  int get clockRate;
  set clockRate(int value);
  int? get channels;
  set channels(int? value);
  String? get sdpFmtpLine;
  set sdpFmtpLine(String? value);
}

final class RTCRtpCodecValue implements RTCRtpCodec {
  @override
  String mimeType;
  @override
  int clockRate;
  @override
  int? channels;
  @override
  String? sdpFmtpLine;

  RTCRtpCodecValue({
    required this.mimeType,
    required this.clockRate,
    this.channels,
    this.sdpFmtpLine,
  });
}

abstract interface class RTCRtpCodecParameters {
  Object get payloadType;
  set payloadType(Object value);
}

final class RTCRtpCodecParametersValue implements RTCRtpCodecParameters {
  @override
  Object payloadType;

  RTCRtpCodecParametersValue({
    required this.payloadType,
  });
}

abstract interface class RTCRtpCodingParameters {
  String? get rid;
  set rid(String? value);
}

final class RTCRtpCodingParametersValue implements RTCRtpCodingParameters {
  @override
  String? rid;

  RTCRtpCodingParametersValue({
    this.rid,
  });
}

abstract interface class RTCRtpContributingSource {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  int get source;
  set source(int value);
  double? get audioLevel;
  set audioLevel(double? value);
  int get rtpTimestamp;
  set rtpTimestamp(int value);
}

final class RTCRtpContributingSourceValue implements RTCRtpContributingSource {
  @override
  DOMHighResTimeStamp timestamp;
  @override
  int source;
  @override
  double? audioLevel;
  @override
  int rtpTimestamp;

  RTCRtpContributingSourceValue({
    required this.timestamp,
    required this.source,
    this.audioLevel,
    required this.rtpTimestamp,
  });
}

abstract interface class RTCRtpHeaderExtensionCapability {
  String get uri;
  set uri(String value);
}

final class RTCRtpHeaderExtensionCapabilityValue implements RTCRtpHeaderExtensionCapability {
  @override
  String uri;

  RTCRtpHeaderExtensionCapabilityValue({
    required this.uri,
  });
}

abstract interface class RTCRtpHeaderExtensionParameters {
  String get uri;
  set uri(String value);
  int get id;
  set id(int value);
  bool? get encrypted;
  set encrypted(bool? value);
}

final class RTCRtpHeaderExtensionParametersValue implements RTCRtpHeaderExtensionParameters {
  @override
  String uri;
  @override
  int id;
  @override
  bool? encrypted;

  RTCRtpHeaderExtensionParametersValue({
    required this.uri,
    required this.id,
    this.encrypted,
  });
}

abstract interface class RTCRtpParameters {
  List<RTCRtpHeaderExtensionParameters> get headerExtensions;
  set headerExtensions(List<RTCRtpHeaderExtensionParameters> value);
  RTCRtcpParameters get rtcp;
  set rtcp(RTCRtcpParameters value);
  List<RTCRtpCodecParameters> get codecs;
  set codecs(List<RTCRtpCodecParameters> value);
}

final class RTCRtpParametersValue implements RTCRtpParameters {
  @override
  List<RTCRtpHeaderExtensionParameters> headerExtensions;
  @override
  RTCRtcpParameters rtcp;
  @override
  List<RTCRtpCodecParameters> codecs;

  RTCRtpParametersValue({
    required this.headerExtensions,
    required this.rtcp,
    required this.codecs,
  });
}

abstract interface class RTCRtpReceiveParameters {
}

final class RTCRtpReceiveParametersValue implements RTCRtpReceiveParameters {

  RTCRtpReceiveParametersValue();
}

abstract interface class RTCRtpSynchronizationSource {
}

final class RTCRtpSynchronizationSourceValue implements RTCRtpSynchronizationSource {

  RTCRtpSynchronizationSourceValue();
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
  RTCRtpTransceiverDirection? get direction;
  set direction(RTCRtpTransceiverDirection? value);
  List<MediaStream>? get streams;
  set streams(List<MediaStream>? value);
  List<RTCRtpEncodingParameters>? get sendEncodings;
  set sendEncodings(List<RTCRtpEncodingParameters>? value);
}

final class RTCRtpTransceiverInitValue implements RTCRtpTransceiverInit {
  @override
  RTCRtpTransceiverDirection? direction;
  @override
  List<MediaStream>? streams;
  @override
  List<RTCRtpEncodingParameters>? sendEncodings;

  RTCRtpTransceiverInitValue({
    this.direction,
    this.streams,
    this.sendEncodings,
  });
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
  RTCSdpType get type_;
  String get sdp;
  RTCSessionDescriptionInit toJSON();
}

typedef RTCSessionDescriptionCallback = void Function(RTCSessionDescriptionInit description,);

abstract interface class RTCSessionDescriptionInit {
  RTCSdpType get type_;
  set type_(RTCSdpType value);
  String? get sdp;
  set sdp(String? value);
}

final class RTCSessionDescriptionInitValue implements RTCSessionDescriptionInit {
  @override
  RTCSdpType type_;
  @override
  String? sdp;

  RTCSessionDescriptionInitValue({
    required this.type_,
    this.sdp,
  });
}

abstract interface class RTCSetParameterOptions {
}

final class RTCSetParameterOptionsValue implements RTCSetParameterOptions {

  RTCSetParameterOptionsValue();
}

typedef RTCSignalingState = String;

abstract interface class RTCStats {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  RTCStatsType get type_;
  set type_(RTCStatsType value);
  String get id;
  set id(String value);
}

final class RTCStatsValue implements RTCStats {
  @override
  DOMHighResTimeStamp timestamp;
  @override
  RTCStatsType type_;
  @override
  String id;

  RTCStatsValue({
    required this.timestamp,
    required this.type_,
    required this.id,
  });
}

abstract interface class RTCStatsReport {
}

abstract interface class RTCTrackEvent {
  factory RTCTrackEvent(String type_, RTCTrackEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<RTCTrackEvent>(
        'RTCTrackEvent',
        [type_, eventInitDict],
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
  List<MediaStream>? get streams;
  set streams(List<MediaStream>? value);
  RTCRtpTransceiver get transceiver;
  set transceiver(RTCRtpTransceiver value);
}

final class RTCTrackEventInitValue implements RTCTrackEventInit {
  @override
  RTCRtpReceiver receiver;
  @override
  MediaStreamTrack track;
  @override
  List<MediaStream>? streams;
  @override
  RTCRtpTransceiver transceiver;

  RTCTrackEventInitValue({
    required this.receiver,
    required this.track,
    this.streams,
    required this.transceiver,
  });
}

