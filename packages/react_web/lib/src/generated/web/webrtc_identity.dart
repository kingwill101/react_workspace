// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc-identity
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc.dart';
import 'html.dart';
import 'webidl.dart';
import 'webrtc_encoded_transform.dart';
import 'capture_handle_identity.dart';
import 'mediacapture_streams.dart';
import 'webrtc_priority.dart';

typedef GenerateAssertionCallback = Future<RTCIdentityAssertionResult> Function(String contents, String origin, RTCIdentityProviderOptions options,);

abstract interface class RTCConfiguration {
  String get peerIdentity;
  set peerIdentity(String value);
  List<RTCIceServer> get iceServers;
  set iceServers(List<RTCIceServer> value);
  RTCIceTransportPolicy get iceTransportPolicy;
  set iceTransportPolicy(RTCIceTransportPolicy value);
  RTCBundlePolicy get bundlePolicy;
  set bundlePolicy(RTCBundlePolicy value);
  RTCRtcpMuxPolicy get rtcpMuxPolicy;
  set rtcpMuxPolicy(RTCRtcpMuxPolicy value);
  List<RTCCertificate> get certificates;
  set certificates(List<RTCCertificate> value);
  Object get iceCandidatePoolSize;
  set iceCandidatePoolSize(Object value);
}

abstract interface class RTCError {
  int? get httpRequestStatusCode;
  RTCErrorDetailType get errorDetail;
  int? get sdpLineNumber;
  int? get sctpCauseCode;
  int? get receivedAlert;
  int? get sentAlert;
}

typedef RTCErrorDetailTypeIdp = String;

abstract interface class RTCErrorInit {
  int get httpRequestStatusCode;
  set httpRequestStatusCode(int value);
  RTCErrorDetailType get errorDetail;
  set errorDetail(RTCErrorDetailType value);
  int get sdpLineNumber;
  set sdpLineNumber(int value);
  int get sctpCauseCode;
  set sctpCauseCode(int value);
  int get receivedAlert;
  set receivedAlert(int value);
  int get sentAlert;
  set sentAlert(int value);
}

abstract interface class RTCIdentityAssertion {
  String get idp;
   set idp(String value);
  String get name;
   set name(String value);
}

abstract interface class RTCIdentityAssertionResult {
  RTCIdentityProviderDetails get idp;
  set idp(RTCIdentityProviderDetails value);
  String get assertion;
  set assertion(String value);
}

abstract interface class RTCIdentityProvider {
  GenerateAssertionCallback get generateAssertion;
  set generateAssertion(GenerateAssertionCallback value);
  ValidateAssertionCallback get validateAssertion;
  set validateAssertion(ValidateAssertionCallback value);
}

abstract interface class RTCIdentityProviderDetails {
  String get domain;
  set domain(String value);
  String get protocol;
  set protocol(String value);
}

abstract interface class RTCIdentityProviderGlobalScope {
  RTCIdentityProviderRegistrar get rtcIdentityProvider;
}

abstract interface class RTCIdentityProviderOptions {
  String get protocol;
  set protocol(String value);
  String get usernameHint;
  set usernameHint(String value);
  String get peerIdentity;
  set peerIdentity(String value);
}

abstract interface class RTCIdentityProviderRegistrar {
  void register(RTCIdentityProvider idp);
}

abstract interface class RTCIdentityValidationResult {
  String get identity;
  set identity(String value);
  String get contents;
  set contents(String value);
}

abstract interface class RTCPeerConnection {
  void setIdentityProvider(String provider, [RTCIdentityProviderOptions? options]);
  Future<String> getIdentityAssertion();
  Future<RTCIdentityAssertion> get peerIdentity;
  String? get idpLoginUrl;
  String? get idpErrorInfo;
  Future<void> createOffer(RTCSessionDescriptionCallback successCallback, RTCPeerConnectionErrorCallback failureCallback, [RTCOfferOptions? options]);
  Future<void> createAnswer(RTCSessionDescriptionCallback successCallback, RTCPeerConnectionErrorCallback failureCallback);
  Future<void> setLocalDescription(RTCLocalSessionDescriptionInit description, VoidFunction successCallback, RTCPeerConnectionErrorCallback failureCallback);
  RTCSessionDescription? get localDescription;
  RTCSessionDescription? get currentLocalDescription;
  RTCSessionDescription? get pendingLocalDescription;
  Future<void> setRemoteDescription(RTCSessionDescriptionInit description, VoidFunction successCallback, RTCPeerConnectionErrorCallback failureCallback);
  RTCSessionDescription? get remoteDescription;
  RTCSessionDescription? get currentRemoteDescription;
  RTCSessionDescription? get pendingRemoteDescription;
  Future<void> addIceCandidate(RTCIceCandidateInit candidate, VoidFunction successCallback, RTCPeerConnectionErrorCallback failureCallback);
  RTCSignalingState get signalingState;
  RTCIceGatheringState get iceGatheringState;
  RTCIceConnectionState get iceConnectionState;
  RTCPeerConnectionState get connectionState;
  bool? get canTrickleIceCandidates;
  void restartIce();
  RTCConfiguration getConfiguration();
  void setConfiguration([RTCConfiguration? configuration]);
  void close();
  EventHandler get onnegotiationneeded;
   set onnegotiationneeded(EventHandler value);
  EventHandler get onicecandidate;
   set onicecandidate(EventHandler value);
  EventHandler get onicecandidateerror;
   set onicecandidateerror(EventHandler value);
  EventHandler get onsignalingstatechange;
   set onsignalingstatechange(EventHandler value);
  EventHandler get oniceconnectionstatechange;
   set oniceconnectionstatechange(EventHandler value);
  EventHandler get onicegatheringstatechange;
   set onicegatheringstatechange(EventHandler value);
  EventHandler get onconnectionstatechange;
   set onconnectionstatechange(EventHandler value);
  List<RTCRtpSender> getSenders();
  List<RTCRtpReceiver> getReceivers();
  List<RTCRtpTransceiver> getTransceivers();
  RTCRtpSender addTrack(MediaStreamTrack track, [List<MediaStream>? streams]);
  void removeTrack(RTCRtpSender sender);
  RTCRtpTransceiver addTransceiver(Object trackOrKind, [RTCRtpTransceiverInit? init]);
  EventHandler get ontrack;
   set ontrack(EventHandler value);
  RTCSctpTransport? get sctp;
  RTCDataChannel createDataChannel(String label, [RTCDataChannelInit? dataChannelDict]);
  EventHandler get ondatachannel;
   set ondatachannel(EventHandler value);
  Future<RTCStatsReport> getStats([MediaStreamTrack? selector]);
}

typedef ValidateAssertionCallback = Future<RTCIdentityValidationResult> Function(String assertion, String origin,);

