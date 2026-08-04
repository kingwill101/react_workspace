// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc-stats
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc.dart';
import 'hr_time.dart';

abstract interface class RTCAudioPlayoutStats {
  String get kind;
  set kind(String value);
  double get synthesizedSamplesDuration;
  set synthesizedSamplesDuration(double value);
  int get synthesizedSamplesEvents;
  set synthesizedSamplesEvents(int value);
  double get totalSamplesDuration;
  set totalSamplesDuration(double value);
  double get totalPlayoutDelay;
  set totalPlayoutDelay(double value);
  int get totalSamplesCount;
  set totalSamplesCount(int value);
}

abstract interface class RTCAudioSourceStats {
  double get audioLevel;
  set audioLevel(double value);
  double get totalAudioEnergy;
  set totalAudioEnergy(double value);
  double get totalSamplesDuration;
  set totalSamplesDuration(double value);
  double get echoReturnLoss;
  set echoReturnLoss(double value);
  double get echoReturnLossEnhancement;
  set echoReturnLossEnhancement(double value);
}

abstract interface class RTCCertificateStats {
  String get fingerprint;
  set fingerprint(String value);
  String get fingerprintAlgorithm;
  set fingerprintAlgorithm(String value);
  String get base64Certificate;
  set base64Certificate(String value);
  String get issuerCertificateId;
  set issuerCertificateId(String value);
}

abstract interface class RTCCodecStats {
  int get payloadType;
  set payloadType(int value);
  String get transportId;
  set transportId(String value);
  String get mimeType;
  set mimeType(String value);
  int get clockRate;
  set clockRate(int value);
  int get channels;
  set channels(int value);
  String get sdpFmtpLine;
  set sdpFmtpLine(String value);
}

abstract interface class RTCDataChannelStats {
  String get label;
  set label(String value);
  String get protocol;
  set protocol(String value);
  int get dataChannelIdentifier;
  set dataChannelIdentifier(int value);
  RTCDataChannelState get state;
  set state(RTCDataChannelState value);
  int get messagesSent;
  set messagesSent(int value);
  int get bytesSent;
  set bytesSent(int value);
  int get messagesReceived;
  set messagesReceived(int value);
  int get bytesReceived;
  set bytesReceived(int value);
}

typedef RTCDtlsRole = String;

abstract interface class RTCIceCandidatePairStats {
  String get transportId;
  set transportId(String value);
  String get localCandidateId;
  set localCandidateId(String value);
  String get remoteCandidateId;
  set remoteCandidateId(String value);
  RTCStatsIceCandidatePairState get state;
  set state(RTCStatsIceCandidatePairState value);
  bool get nominated;
  set nominated(bool value);
  int get packetsSent;
  set packetsSent(int value);
  int get packetsReceived;
  set packetsReceived(int value);
  int get bytesSent;
  set bytesSent(int value);
  int get bytesReceived;
  set bytesReceived(int value);
  DOMHighResTimeStamp get lastPacketSentTimestamp;
  set lastPacketSentTimestamp(DOMHighResTimeStamp value);
  DOMHighResTimeStamp get lastPacketReceivedTimestamp;
  set lastPacketReceivedTimestamp(DOMHighResTimeStamp value);
  double get totalRoundTripTime;
  set totalRoundTripTime(double value);
  double get currentRoundTripTime;
  set currentRoundTripTime(double value);
  double get availableOutgoingBitrate;
  set availableOutgoingBitrate(double value);
  double get availableIncomingBitrate;
  set availableIncomingBitrate(double value);
  int get requestsReceived;
  set requestsReceived(int value);
  int get requestsSent;
  set requestsSent(int value);
  int get responsesReceived;
  set responsesReceived(int value);
  int get responsesSent;
  set responsesSent(int value);
  int get consentRequestsSent;
  set consentRequestsSent(int value);
  int get packetsDiscardedOnSend;
  set packetsDiscardedOnSend(int value);
  int get bytesDiscardedOnSend;
  set bytesDiscardedOnSend(int value);
}

abstract interface class RTCIceCandidateStats {
  String get transportId;
  set transportId(String value);
  String? get address;
  set address(String? value);
  int get port;
  set port(int value);
  String get protocol;
  set protocol(String value);
  RTCIceCandidateType get candidateType;
  set candidateType(RTCIceCandidateType value);
  int get priority;
  set priority(int value);
  String get url;
  set url(String value);
  RTCIceServerTransportProtocol get relayProtocol;
  set relayProtocol(RTCIceServerTransportProtocol value);
  String get foundation;
  set foundation(String value);
  String get relatedAddress;
  set relatedAddress(String value);
  int get relatedPort;
  set relatedPort(int value);
  String get usernameFragment;
  set usernameFragment(String value);
  RTCIceTcpCandidateType get tcpType;
  set tcpType(RTCIceTcpCandidateType value);
}

abstract interface class RTCInboundRtpStreamStats {
  String get trackIdentifier;
  set trackIdentifier(String value);
  String get mid;
  set mid(String value);
  String get remoteId;
  set remoteId(String value);
  int get framesDecoded;
  set framesDecoded(int value);
  int get keyFramesDecoded;
  set keyFramesDecoded(int value);
  int get framesRendered;
  set framesRendered(int value);
  int get framesDropped;
  set framesDropped(int value);
  int get frameWidth;
  set frameWidth(int value);
  int get frameHeight;
  set frameHeight(int value);
  double get framesPerSecond;
  set framesPerSecond(double value);
  int get qpSum;
  set qpSum(int value);
  double get totalDecodeTime;
  set totalDecodeTime(double value);
  double get totalInterFrameDelay;
  set totalInterFrameDelay(double value);
  double get totalSquaredInterFrameDelay;
  set totalSquaredInterFrameDelay(double value);
  int get pauseCount;
  set pauseCount(int value);
  double get totalPausesDuration;
  set totalPausesDuration(double value);
  int get freezeCount;
  set freezeCount(int value);
  double get totalFreezesDuration;
  set totalFreezesDuration(double value);
  DOMHighResTimeStamp get lastPacketReceivedTimestamp;
  set lastPacketReceivedTimestamp(DOMHighResTimeStamp value);
  int get headerBytesReceived;
  set headerBytesReceived(int value);
  int get packetsDiscarded;
  set packetsDiscarded(int value);
  int get fecBytesReceived;
  set fecBytesReceived(int value);
  int get fecPacketsReceived;
  set fecPacketsReceived(int value);
  int get fecPacketsDiscarded;
  set fecPacketsDiscarded(int value);
  int get bytesReceived;
  set bytesReceived(int value);
  int get nackCount;
  set nackCount(int value);
  int get firCount;
  set firCount(int value);
  int get pliCount;
  set pliCount(int value);
  double get totalProcessingDelay;
  set totalProcessingDelay(double value);
  DOMHighResTimeStamp get estimatedPlayoutTimestamp;
  set estimatedPlayoutTimestamp(DOMHighResTimeStamp value);
  double get jitterBufferDelay;
  set jitterBufferDelay(double value);
  double get jitterBufferTargetDelay;
  set jitterBufferTargetDelay(double value);
  int get jitterBufferEmittedCount;
  set jitterBufferEmittedCount(int value);
  double get jitterBufferMinimumDelay;
  set jitterBufferMinimumDelay(double value);
  int get totalSamplesReceived;
  set totalSamplesReceived(int value);
  int get concealedSamples;
  set concealedSamples(int value);
  int get silentConcealedSamples;
  set silentConcealedSamples(int value);
  int get concealmentEvents;
  set concealmentEvents(int value);
  int get insertedSamplesForDeceleration;
  set insertedSamplesForDeceleration(int value);
  int get removedSamplesForAcceleration;
  set removedSamplesForAcceleration(int value);
  double get audioLevel;
  set audioLevel(double value);
  double get totalAudioEnergy;
  set totalAudioEnergy(double value);
  double get totalSamplesDuration;
  set totalSamplesDuration(double value);
  int get framesReceived;
  set framesReceived(int value);
  String get decoderImplementation;
  set decoderImplementation(String value);
  String get playoutId;
  set playoutId(String value);
  bool get powerEfficientDecoder;
  set powerEfficientDecoder(bool value);
  int get framesAssembledFromMultiplePackets;
  set framesAssembledFromMultiplePackets(int value);
  double get totalAssemblyTime;
  set totalAssemblyTime(double value);
  int get retransmittedPacketsReceived;
  set retransmittedPacketsReceived(int value);
  int get retransmittedBytesReceived;
  set retransmittedBytesReceived(int value);
  int get rtxSsrc;
  set rtxSsrc(int value);
  int get fecSsrc;
  set fecSsrc(int value);
  double get totalCorruptionProbability;
  set totalCorruptionProbability(double value);
  double get totalSquaredCorruptionProbability;
  set totalSquaredCorruptionProbability(double value);
  int get corruptionMeasurements;
  set corruptionMeasurements(int value);
}

abstract interface class RTCMediaSourceStats {
  String get trackIdentifier;
  set trackIdentifier(String value);
  String get kind;
  set kind(String value);
}

abstract interface class RTCOutboundRtpStreamStats {
  String get mid;
  set mid(String value);
  String get mediaSourceId;
  set mediaSourceId(String value);
  String get remoteId;
  set remoteId(String value);
  String get rid;
  set rid(String value);
  int get headerBytesSent;
  set headerBytesSent(int value);
  int get retransmittedPacketsSent;
  set retransmittedPacketsSent(int value);
  int get retransmittedBytesSent;
  set retransmittedBytesSent(int value);
  int get rtxSsrc;
  set rtxSsrc(int value);
  double get targetBitrate;
  set targetBitrate(double value);
  int get totalEncodedBytesTarget;
  set totalEncodedBytesTarget(int value);
  int get frameWidth;
  set frameWidth(int value);
  int get frameHeight;
  set frameHeight(int value);
  double get framesPerSecond;
  set framesPerSecond(double value);
  int get framesSent;
  set framesSent(int value);
  int get hugeFramesSent;
  set hugeFramesSent(int value);
  int get framesEncoded;
  set framesEncoded(int value);
  int get keyFramesEncoded;
  set keyFramesEncoded(int value);
  int get qpSum;
  set qpSum(int value);
  double get totalEncodeTime;
  set totalEncodeTime(double value);
  double get totalPacketSendDelay;
  set totalPacketSendDelay(double value);
  RTCQualityLimitationReason get qualityLimitationReason;
  set qualityLimitationReason(RTCQualityLimitationReason value);
  Map<String, double> get qualityLimitationDurations;
  set qualityLimitationDurations(Map<String, double> value);
  int get qualityLimitationResolutionChanges;
  set qualityLimitationResolutionChanges(int value);
  int get nackCount;
  set nackCount(int value);
  int get firCount;
  set firCount(int value);
  int get pliCount;
  set pliCount(int value);
  String get encoderImplementation;
  set encoderImplementation(String value);
  bool get powerEfficientEncoder;
  set powerEfficientEncoder(bool value);
  bool get active;
  set active(bool value);
  String get scalabilityMode;
  set scalabilityMode(String value);
}

abstract interface class RTCPeerConnectionStats {
  int get dataChannelsOpened;
  set dataChannelsOpened(int value);
  int get dataChannelsClosed;
  set dataChannelsClosed(int value);
}

typedef RTCQualityLimitationReason = String;

abstract interface class RTCReceivedRtpStreamStats {
  int get packetsReceived;
  set packetsReceived(int value);
  int get packetsLost;
  set packetsLost(int value);
  double get jitter;
  set jitter(double value);
}

abstract interface class RTCRemoteInboundRtpStreamStats {
  String get localId;
  set localId(String value);
  double get roundTripTime;
  set roundTripTime(double value);
  double get totalRoundTripTime;
  set totalRoundTripTime(double value);
  double get fractionLost;
  set fractionLost(double value);
  int get roundTripTimeMeasurements;
  set roundTripTimeMeasurements(int value);
}

abstract interface class RTCRemoteOutboundRtpStreamStats {
  String get localId;
  set localId(String value);
  DOMHighResTimeStamp get remoteTimestamp;
  set remoteTimestamp(DOMHighResTimeStamp value);
  int get reportsSent;
  set reportsSent(int value);
  double get roundTripTime;
  set roundTripTime(double value);
  double get totalRoundTripTime;
  set totalRoundTripTime(double value);
  int get roundTripTimeMeasurements;
  set roundTripTimeMeasurements(int value);
}

abstract interface class RTCRtpStreamStats {
  int get ssrc;
  set ssrc(int value);
  String get kind;
  set kind(String value);
  String get transportId;
  set transportId(String value);
  String get codecId;
  set codecId(String value);
}

abstract interface class RTCSentRtpStreamStats {
  int get packetsSent;
  set packetsSent(int value);
  int get bytesSent;
  set bytesSent(int value);
}

typedef RTCStatsIceCandidatePairState = String;

typedef RTCStatsType = String;

abstract interface class RTCTransportStats {
  int get packetsSent;
  set packetsSent(int value);
  int get packetsReceived;
  set packetsReceived(int value);
  int get bytesSent;
  set bytesSent(int value);
  int get bytesReceived;
  set bytesReceived(int value);
  RTCIceRole get iceRole;
  set iceRole(RTCIceRole value);
  String get iceLocalUsernameFragment;
  set iceLocalUsernameFragment(String value);
  RTCDtlsTransportState get dtlsState;
  set dtlsState(RTCDtlsTransportState value);
  RTCIceTransportState get iceState;
  set iceState(RTCIceTransportState value);
  String get selectedCandidatePairId;
  set selectedCandidatePairId(String value);
  String get localCertificateId;
  set localCertificateId(String value);
  String get remoteCertificateId;
  set remoteCertificateId(String value);
  String get tlsVersion;
  set tlsVersion(String value);
  String get dtlsCipher;
  set dtlsCipher(String value);
  RTCDtlsRole get dtlsRole;
  set dtlsRole(RTCDtlsRole value);
  String get srtpCipher;
  set srtpCipher(String value);
  int get selectedCandidatePairChanges;
  set selectedCandidatePairChanges(int value);
}

abstract interface class RTCVideoSourceStats {
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int get frames;
  set frames(int value);
  double get framesPerSecond;
  set framesPerSecond(double value);
}

