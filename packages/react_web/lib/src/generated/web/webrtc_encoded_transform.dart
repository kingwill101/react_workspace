// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc-encoded-transform
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'capture_handle_identity.dart';
import 'webrtc.dart';
import 'hr_time.dart';
import 'html.dart';
import 'streams.dart';
import 'mst_content_hint.dart';
import 'mediacapture_streams.dart';
import 'webcryptoapi.dart';
import 'dom.dart';

typedef CryptoKeyID = Object;

abstract interface class KeyFrameRequestEvent {
  String? get rid;
}

abstract interface class RTCEncodedAudioFrame {
  Object get data;
   set data(Object value);
  RTCEncodedAudioFrameMetadata getMetadata();
}

abstract interface class RTCEncodedAudioFrameMetadata {
  int get synchronizationSource;
  set synchronizationSource(int value);
  Object get payloadType;
  set payloadType(Object value);
  List<int> get contributingSources;
  set contributingSources(List<int> value);
  int get sequenceNumber;
  set sequenceNumber(int value);
  int get rtpTimestamp;
  set rtpTimestamp(int value);
  String get mimeType;
  set mimeType(String value);
}

abstract interface class RTCEncodedAudioFrameOptions {
  RTCEncodedAudioFrameMetadata get metadata;
  set metadata(RTCEncodedAudioFrameMetadata value);
}

abstract interface class RTCEncodedVideoFrame {
  RTCEncodedVideoFrameType get type;
  Object get data;
   set data(Object value);
  RTCEncodedVideoFrameMetadata getMetadata();
}

abstract interface class RTCEncodedVideoFrameMetadata {
  int get frameId;
  set frameId(int value);
  List<int> get dependencies;
  set dependencies(List<int> value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int get spatialIndex;
  set spatialIndex(int value);
  int get temporalIndex;
  set temporalIndex(int value);
  int get synchronizationSource;
  set synchronizationSource(int value);
  Object get payloadType;
  set payloadType(Object value);
  List<int> get contributingSources;
  set contributingSources(List<int> value);
  int get timestamp;
  set timestamp(int value);
  int get rtpTimestamp;
  set rtpTimestamp(int value);
  String get mimeType;
  set mimeType(String value);
}

abstract interface class RTCEncodedVideoFrameOptions {
  RTCEncodedVideoFrameMetadata get metadata;
  set metadata(RTCEncodedVideoFrameMetadata value);
}

typedef RTCEncodedVideoFrameType = String;

abstract interface class RTCRtpReceiver {
  RTCRtpTransform? get transform;
   set transform(RTCRtpTransform? value);
  MediaStreamTrack get track;
  RTCDtlsTransport? get transport;
  RTCRtpReceiveParameters getParameters();
  List<RTCRtpContributingSource> getContributingSources();
  List<RTCRtpSynchronizationSource> getSynchronizationSources();
  Future<RTCStatsReport> getStats();
  DOMHighResTimeStamp? get jitterBufferTarget;
   set jitterBufferTarget(DOMHighResTimeStamp? value);
}

abstract interface class RTCRtpScriptTransform {
}

abstract interface class RTCRtpScriptTransformer {
  ReadableStream get readable;
  Future<int> generateKeyFrame([String? rid]);
  Future<void> sendKeyFrameRequest();
  WritableStream get writable;
  EventHandler get onkeyframerequest;
   set onkeyframerequest(EventHandler value);
  Object get options;
}

abstract interface class RTCRtpSender {
  RTCRtpTransform? get transform;
   set transform(RTCRtpTransform? value);
  Future<void> generateKeyFrame([List<String>? rids]);
  MediaStreamTrack? get track;
  RTCDtlsTransport? get transport;
  Future<void> setParameters(RTCRtpSendParameters parameters, [RTCSetParameterOptions? setParameterOptions]);
  RTCRtpSendParameters getParameters();
  Future<void> replaceTrack(MediaStreamTrack? withTrack);
  void setStreams([List<MediaStream>? streams]);
  Future<RTCStatsReport> getStats();
  RTCDTMFSender? get dtmf;
}

typedef RTCRtpTransform = Object;

abstract interface class RTCTransformEvent {
  RTCRtpScriptTransformer get transformer;
}

abstract interface class SFrameTransform {
  ReadableStream get readable;
  WritableStream get writable;
  Future<void> setEncryptionKey(CryptoKey key, [CryptoKeyID? keyID]);
  EventHandler get onerror;
   set onerror(EventHandler value);
}

abstract interface class SFrameTransformErrorEvent {
  SFrameTransformErrorEventType get errorType;
  CryptoKeyID? get keyID;
  Object get frame;
}

abstract interface class SFrameTransformErrorEventInit {
  SFrameTransformErrorEventType get errorType;
  set errorType(SFrameTransformErrorEventType value);
  Object get frame;
  set frame(Object value);
  CryptoKeyID? get keyID;
  set keyID(CryptoKeyID? value);
}

typedef SFrameTransformErrorEventType = String;

abstract interface class SFrameTransformOptions {
  SFrameTransformRole get role;
  set role(SFrameTransformRole value);
}

typedef SFrameTransformRole = String;

typedef SmallCryptoKeyID = int;

