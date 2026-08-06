// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc-stats
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc.dart';
import 'hr_time.dart';

abstract interface class RTCAudioPlayoutStats {
  String get kind;
  set kind(String value);
  double? get synthesizedSamplesDuration;
  set synthesizedSamplesDuration(double? value);
  int? get synthesizedSamplesEvents;
  set synthesizedSamplesEvents(int? value);
  double? get totalSamplesDuration;
  set totalSamplesDuration(double? value);
  double? get totalPlayoutDelay;
  set totalPlayoutDelay(double? value);
  int? get totalSamplesCount;
  set totalSamplesCount(int? value);
}

final class RTCAudioPlayoutStatsValue implements RTCAudioPlayoutStats {
  @override
  String kind;
  @override
  double? synthesizedSamplesDuration;
  @override
  int? synthesizedSamplesEvents;
  @override
  double? totalSamplesDuration;
  @override
  double? totalPlayoutDelay;
  @override
  int? totalSamplesCount;

  RTCAudioPlayoutStatsValue({
    required this.kind,
    this.synthesizedSamplesDuration,
    this.synthesizedSamplesEvents,
    this.totalSamplesDuration,
    this.totalPlayoutDelay,
    this.totalSamplesCount,
  });
}

abstract interface class RTCAudioSourceStats {
  double? get audioLevel;
  set audioLevel(double? value);
  double? get totalAudioEnergy;
  set totalAudioEnergy(double? value);
  double? get totalSamplesDuration;
  set totalSamplesDuration(double? value);
  double? get echoReturnLoss;
  set echoReturnLoss(double? value);
  double? get echoReturnLossEnhancement;
  set echoReturnLossEnhancement(double? value);
}

final class RTCAudioSourceStatsValue implements RTCAudioSourceStats {
  @override
  double? audioLevel;
  @override
  double? totalAudioEnergy;
  @override
  double? totalSamplesDuration;
  @override
  double? echoReturnLoss;
  @override
  double? echoReturnLossEnhancement;

  RTCAudioSourceStatsValue({
    this.audioLevel,
    this.totalAudioEnergy,
    this.totalSamplesDuration,
    this.echoReturnLoss,
    this.echoReturnLossEnhancement,
  });
}

abstract interface class RTCCertificateStats {
  String get fingerprint;
  set fingerprint(String value);
  String get fingerprintAlgorithm;
  set fingerprintAlgorithm(String value);
  String get base64Certificate;
  set base64Certificate(String value);
  String? get issuerCertificateId;
  set issuerCertificateId(String? value);
}

final class RTCCertificateStatsValue implements RTCCertificateStats {
  @override
  String fingerprint;
  @override
  String fingerprintAlgorithm;
  @override
  String base64Certificate;
  @override
  String? issuerCertificateId;

  RTCCertificateStatsValue({
    required this.fingerprint,
    required this.fingerprintAlgorithm,
    required this.base64Certificate,
    this.issuerCertificateId,
  });
}

abstract interface class RTCCodecStats {
  int get payloadType;
  set payloadType(int value);
  String get transportId;
  set transportId(String value);
  String get mimeType;
  set mimeType(String value);
  int? get clockRate;
  set clockRate(int? value);
  int? get channels;
  set channels(int? value);
  String? get sdpFmtpLine;
  set sdpFmtpLine(String? value);
}

final class RTCCodecStatsValue implements RTCCodecStats {
  @override
  int payloadType;
  @override
  String transportId;
  @override
  String mimeType;
  @override
  int? clockRate;
  @override
  int? channels;
  @override
  String? sdpFmtpLine;

  RTCCodecStatsValue({
    required this.payloadType,
    required this.transportId,
    required this.mimeType,
    this.clockRate,
    this.channels,
    this.sdpFmtpLine,
  });
}

abstract interface class RTCDataChannelStats {
  String? get label;
  set label(String? value);
  String? get protocol;
  set protocol(String? value);
  int? get dataChannelIdentifier;
  set dataChannelIdentifier(int? value);
  RTCDataChannelState get state;
  set state(RTCDataChannelState value);
  int? get messagesSent;
  set messagesSent(int? value);
  int? get bytesSent;
  set bytesSent(int? value);
  int? get messagesReceived;
  set messagesReceived(int? value);
  int? get bytesReceived;
  set bytesReceived(int? value);
}

final class RTCDataChannelStatsValue implements RTCDataChannelStats {
  @override
  String? label;
  @override
  String? protocol;
  @override
  int? dataChannelIdentifier;
  @override
  RTCDataChannelState state;
  @override
  int? messagesSent;
  @override
  int? bytesSent;
  @override
  int? messagesReceived;
  @override
  int? bytesReceived;

  RTCDataChannelStatsValue({
    this.label,
    this.protocol,
    this.dataChannelIdentifier,
    required this.state,
    this.messagesSent,
    this.bytesSent,
    this.messagesReceived,
    this.bytesReceived,
  });
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
  bool? get nominated;
  set nominated(bool? value);
  int? get packetsSent;
  set packetsSent(int? value);
  int? get packetsReceived;
  set packetsReceived(int? value);
  int? get bytesSent;
  set bytesSent(int? value);
  int? get bytesReceived;
  set bytesReceived(int? value);
  DOMHighResTimeStamp? get lastPacketSentTimestamp;
  set lastPacketSentTimestamp(DOMHighResTimeStamp? value);
  DOMHighResTimeStamp? get lastPacketReceivedTimestamp;
  set lastPacketReceivedTimestamp(DOMHighResTimeStamp? value);
  double? get totalRoundTripTime;
  set totalRoundTripTime(double? value);
  double? get currentRoundTripTime;
  set currentRoundTripTime(double? value);
  double? get availableOutgoingBitrate;
  set availableOutgoingBitrate(double? value);
  double? get availableIncomingBitrate;
  set availableIncomingBitrate(double? value);
  int? get requestsReceived;
  set requestsReceived(int? value);
  int? get requestsSent;
  set requestsSent(int? value);
  int? get responsesReceived;
  set responsesReceived(int? value);
  int? get responsesSent;
  set responsesSent(int? value);
  int? get consentRequestsSent;
  set consentRequestsSent(int? value);
  int? get packetsDiscardedOnSend;
  set packetsDiscardedOnSend(int? value);
  int? get bytesDiscardedOnSend;
  set bytesDiscardedOnSend(int? value);
}

final class RTCIceCandidatePairStatsValue implements RTCIceCandidatePairStats {
  @override
  String transportId;
  @override
  String localCandidateId;
  @override
  String remoteCandidateId;
  @override
  RTCStatsIceCandidatePairState state;
  @override
  bool? nominated;
  @override
  int? packetsSent;
  @override
  int? packetsReceived;
  @override
  int? bytesSent;
  @override
  int? bytesReceived;
  @override
  DOMHighResTimeStamp? lastPacketSentTimestamp;
  @override
  DOMHighResTimeStamp? lastPacketReceivedTimestamp;
  @override
  double? totalRoundTripTime;
  @override
  double? currentRoundTripTime;
  @override
  double? availableOutgoingBitrate;
  @override
  double? availableIncomingBitrate;
  @override
  int? requestsReceived;
  @override
  int? requestsSent;
  @override
  int? responsesReceived;
  @override
  int? responsesSent;
  @override
  int? consentRequestsSent;
  @override
  int? packetsDiscardedOnSend;
  @override
  int? bytesDiscardedOnSend;

  RTCIceCandidatePairStatsValue({
    required this.transportId,
    required this.localCandidateId,
    required this.remoteCandidateId,
    required this.state,
    this.nominated,
    this.packetsSent,
    this.packetsReceived,
    this.bytesSent,
    this.bytesReceived,
    this.lastPacketSentTimestamp,
    this.lastPacketReceivedTimestamp,
    this.totalRoundTripTime,
    this.currentRoundTripTime,
    this.availableOutgoingBitrate,
    this.availableIncomingBitrate,
    this.requestsReceived,
    this.requestsSent,
    this.responsesReceived,
    this.responsesSent,
    this.consentRequestsSent,
    this.packetsDiscardedOnSend,
    this.bytesDiscardedOnSend,
  });
}

abstract interface class RTCIceCandidateStats {
  String get transportId;
  set transportId(String value);
  String? get address;
  set address(String? value);
  int? get port;
  set port(int? value);
  String? get protocol;
  set protocol(String? value);
  RTCIceCandidateType get candidateType;
  set candidateType(RTCIceCandidateType value);
  int? get priority;
  set priority(int? value);
  String? get url;
  set url(String? value);
  RTCIceServerTransportProtocol? get relayProtocol;
  set relayProtocol(RTCIceServerTransportProtocol? value);
  String? get foundation;
  set foundation(String? value);
  String? get relatedAddress;
  set relatedAddress(String? value);
  int? get relatedPort;
  set relatedPort(int? value);
  String? get usernameFragment;
  set usernameFragment(String? value);
  RTCIceTcpCandidateType? get tcpType;
  set tcpType(RTCIceTcpCandidateType? value);
}

final class RTCIceCandidateStatsValue implements RTCIceCandidateStats {
  @override
  String transportId;
  @override
  String? address;
  @override
  int? port;
  @override
  String? protocol;
  @override
  RTCIceCandidateType candidateType;
  @override
  int? priority;
  @override
  String? url;
  @override
  RTCIceServerTransportProtocol? relayProtocol;
  @override
  String? foundation;
  @override
  String? relatedAddress;
  @override
  int? relatedPort;
  @override
  String? usernameFragment;
  @override
  RTCIceTcpCandidateType? tcpType;

  RTCIceCandidateStatsValue({
    required this.transportId,
    this.address,
    this.port,
    this.protocol,
    required this.candidateType,
    this.priority,
    this.url,
    this.relayProtocol,
    this.foundation,
    this.relatedAddress,
    this.relatedPort,
    this.usernameFragment,
    this.tcpType,
  });
}

abstract interface class RTCInboundRtpStreamStats {
  String get trackIdentifier;
  set trackIdentifier(String value);
  String? get mid;
  set mid(String? value);
  String? get remoteId;
  set remoteId(String? value);
  int? get framesDecoded;
  set framesDecoded(int? value);
  int? get keyFramesDecoded;
  set keyFramesDecoded(int? value);
  int? get framesRendered;
  set framesRendered(int? value);
  int? get framesDropped;
  set framesDropped(int? value);
  int? get frameWidth;
  set frameWidth(int? value);
  int? get frameHeight;
  set frameHeight(int? value);
  double? get framesPerSecond;
  set framesPerSecond(double? value);
  int? get qpSum;
  set qpSum(int? value);
  double? get totalDecodeTime;
  set totalDecodeTime(double? value);
  double? get totalInterFrameDelay;
  set totalInterFrameDelay(double? value);
  double? get totalSquaredInterFrameDelay;
  set totalSquaredInterFrameDelay(double? value);
  int? get pauseCount;
  set pauseCount(int? value);
  double? get totalPausesDuration;
  set totalPausesDuration(double? value);
  int? get freezeCount;
  set freezeCount(int? value);
  double? get totalFreezesDuration;
  set totalFreezesDuration(double? value);
  DOMHighResTimeStamp? get lastPacketReceivedTimestamp;
  set lastPacketReceivedTimestamp(DOMHighResTimeStamp? value);
  int? get headerBytesReceived;
  set headerBytesReceived(int? value);
  int? get packetsDiscarded;
  set packetsDiscarded(int? value);
  int? get fecBytesReceived;
  set fecBytesReceived(int? value);
  int? get fecPacketsReceived;
  set fecPacketsReceived(int? value);
  int? get fecPacketsDiscarded;
  set fecPacketsDiscarded(int? value);
  int? get bytesReceived;
  set bytesReceived(int? value);
  int? get nackCount;
  set nackCount(int? value);
  int? get firCount;
  set firCount(int? value);
  int? get pliCount;
  set pliCount(int? value);
  double? get totalProcessingDelay;
  set totalProcessingDelay(double? value);
  DOMHighResTimeStamp? get estimatedPlayoutTimestamp;
  set estimatedPlayoutTimestamp(DOMHighResTimeStamp? value);
  double? get jitterBufferDelay;
  set jitterBufferDelay(double? value);
  double? get jitterBufferTargetDelay;
  set jitterBufferTargetDelay(double? value);
  int? get jitterBufferEmittedCount;
  set jitterBufferEmittedCount(int? value);
  double? get jitterBufferMinimumDelay;
  set jitterBufferMinimumDelay(double? value);
  int? get totalSamplesReceived;
  set totalSamplesReceived(int? value);
  int? get concealedSamples;
  set concealedSamples(int? value);
  int? get silentConcealedSamples;
  set silentConcealedSamples(int? value);
  int? get concealmentEvents;
  set concealmentEvents(int? value);
  int? get insertedSamplesForDeceleration;
  set insertedSamplesForDeceleration(int? value);
  int? get removedSamplesForAcceleration;
  set removedSamplesForAcceleration(int? value);
  double? get audioLevel;
  set audioLevel(double? value);
  double? get totalAudioEnergy;
  set totalAudioEnergy(double? value);
  double? get totalSamplesDuration;
  set totalSamplesDuration(double? value);
  int? get framesReceived;
  set framesReceived(int? value);
  String? get decoderImplementation;
  set decoderImplementation(String? value);
  String? get playoutId;
  set playoutId(String? value);
  bool? get powerEfficientDecoder;
  set powerEfficientDecoder(bool? value);
  int? get framesAssembledFromMultiplePackets;
  set framesAssembledFromMultiplePackets(int? value);
  double? get totalAssemblyTime;
  set totalAssemblyTime(double? value);
  int? get retransmittedPacketsReceived;
  set retransmittedPacketsReceived(int? value);
  int? get retransmittedBytesReceived;
  set retransmittedBytesReceived(int? value);
  int? get rtxSsrc;
  set rtxSsrc(int? value);
  int? get fecSsrc;
  set fecSsrc(int? value);
}

final class RTCInboundRtpStreamStatsValue implements RTCInboundRtpStreamStats {
  @override
  String trackIdentifier;
  @override
  String? mid;
  @override
  String? remoteId;
  @override
  int? framesDecoded;
  @override
  int? keyFramesDecoded;
  @override
  int? framesRendered;
  @override
  int? framesDropped;
  @override
  int? frameWidth;
  @override
  int? frameHeight;
  @override
  double? framesPerSecond;
  @override
  int? qpSum;
  @override
  double? totalDecodeTime;
  @override
  double? totalInterFrameDelay;
  @override
  double? totalSquaredInterFrameDelay;
  @override
  int? pauseCount;
  @override
  double? totalPausesDuration;
  @override
  int? freezeCount;
  @override
  double? totalFreezesDuration;
  @override
  DOMHighResTimeStamp? lastPacketReceivedTimestamp;
  @override
  int? headerBytesReceived;
  @override
  int? packetsDiscarded;
  @override
  int? fecBytesReceived;
  @override
  int? fecPacketsReceived;
  @override
  int? fecPacketsDiscarded;
  @override
  int? bytesReceived;
  @override
  int? nackCount;
  @override
  int? firCount;
  @override
  int? pliCount;
  @override
  double? totalProcessingDelay;
  @override
  DOMHighResTimeStamp? estimatedPlayoutTimestamp;
  @override
  double? jitterBufferDelay;
  @override
  double? jitterBufferTargetDelay;
  @override
  int? jitterBufferEmittedCount;
  @override
  double? jitterBufferMinimumDelay;
  @override
  int? totalSamplesReceived;
  @override
  int? concealedSamples;
  @override
  int? silentConcealedSamples;
  @override
  int? concealmentEvents;
  @override
  int? insertedSamplesForDeceleration;
  @override
  int? removedSamplesForAcceleration;
  @override
  double? audioLevel;
  @override
  double? totalAudioEnergy;
  @override
  double? totalSamplesDuration;
  @override
  int? framesReceived;
  @override
  String? decoderImplementation;
  @override
  String? playoutId;
  @override
  bool? powerEfficientDecoder;
  @override
  int? framesAssembledFromMultiplePackets;
  @override
  double? totalAssemblyTime;
  @override
  int? retransmittedPacketsReceived;
  @override
  int? retransmittedBytesReceived;
  @override
  int? rtxSsrc;
  @override
  int? fecSsrc;

  RTCInboundRtpStreamStatsValue({
    required this.trackIdentifier,
    this.mid,
    this.remoteId,
    this.framesDecoded,
    this.keyFramesDecoded,
    this.framesRendered,
    this.framesDropped,
    this.frameWidth,
    this.frameHeight,
    this.framesPerSecond,
    this.qpSum,
    this.totalDecodeTime,
    this.totalInterFrameDelay,
    this.totalSquaredInterFrameDelay,
    this.pauseCount,
    this.totalPausesDuration,
    this.freezeCount,
    this.totalFreezesDuration,
    this.lastPacketReceivedTimestamp,
    this.headerBytesReceived,
    this.packetsDiscarded,
    this.fecBytesReceived,
    this.fecPacketsReceived,
    this.fecPacketsDiscarded,
    this.bytesReceived,
    this.nackCount,
    this.firCount,
    this.pliCount,
    this.totalProcessingDelay,
    this.estimatedPlayoutTimestamp,
    this.jitterBufferDelay,
    this.jitterBufferTargetDelay,
    this.jitterBufferEmittedCount,
    this.jitterBufferMinimumDelay,
    this.totalSamplesReceived,
    this.concealedSamples,
    this.silentConcealedSamples,
    this.concealmentEvents,
    this.insertedSamplesForDeceleration,
    this.removedSamplesForAcceleration,
    this.audioLevel,
    this.totalAudioEnergy,
    this.totalSamplesDuration,
    this.framesReceived,
    this.decoderImplementation,
    this.playoutId,
    this.powerEfficientDecoder,
    this.framesAssembledFromMultiplePackets,
    this.totalAssemblyTime,
    this.retransmittedPacketsReceived,
    this.retransmittedBytesReceived,
    this.rtxSsrc,
    this.fecSsrc,
  });
}

abstract interface class RTCMediaSourceStats {
  String get trackIdentifier;
  set trackIdentifier(String value);
  String get kind;
  set kind(String value);
}

final class RTCMediaSourceStatsValue implements RTCMediaSourceStats {
  @override
  String trackIdentifier;
  @override
  String kind;

  RTCMediaSourceStatsValue({
    required this.trackIdentifier,
    required this.kind,
  });
}

abstract interface class RTCOutboundRtpStreamStats {
  String? get mid;
  set mid(String? value);
  String? get mediaSourceId;
  set mediaSourceId(String? value);
  String? get remoteId;
  set remoteId(String? value);
  String? get rid;
  set rid(String? value);
  int? get headerBytesSent;
  set headerBytesSent(int? value);
  int? get retransmittedPacketsSent;
  set retransmittedPacketsSent(int? value);
  int? get retransmittedBytesSent;
  set retransmittedBytesSent(int? value);
  int? get rtxSsrc;
  set rtxSsrc(int? value);
  double? get targetBitrate;
  set targetBitrate(double? value);
  int? get totalEncodedBytesTarget;
  set totalEncodedBytesTarget(int? value);
  int? get frameWidth;
  set frameWidth(int? value);
  int? get frameHeight;
  set frameHeight(int? value);
  double? get framesPerSecond;
  set framesPerSecond(double? value);
  int? get framesSent;
  set framesSent(int? value);
  int? get hugeFramesSent;
  set hugeFramesSent(int? value);
  int? get framesEncoded;
  set framesEncoded(int? value);
  int? get keyFramesEncoded;
  set keyFramesEncoded(int? value);
  int? get qpSum;
  set qpSum(int? value);
  double? get totalEncodeTime;
  set totalEncodeTime(double? value);
  double? get totalPacketSendDelay;
  set totalPacketSendDelay(double? value);
  RTCQualityLimitationReason? get qualityLimitationReason;
  set qualityLimitationReason(RTCQualityLimitationReason? value);
  Map<String, double>? get qualityLimitationDurations;
  set qualityLimitationDurations(Map<String, double>? value);
  int? get qualityLimitationResolutionChanges;
  set qualityLimitationResolutionChanges(int? value);
  int? get nackCount;
  set nackCount(int? value);
  int? get firCount;
  set firCount(int? value);
  int? get pliCount;
  set pliCount(int? value);
  String? get encoderImplementation;
  set encoderImplementation(String? value);
  bool? get powerEfficientEncoder;
  set powerEfficientEncoder(bool? value);
  bool? get active;
  set active(bool? value);
  String? get scalabilityMode;
  set scalabilityMode(String? value);
}

final class RTCOutboundRtpStreamStatsValue implements RTCOutboundRtpStreamStats {
  @override
  String? mid;
  @override
  String? mediaSourceId;
  @override
  String? remoteId;
  @override
  String? rid;
  @override
  int? headerBytesSent;
  @override
  int? retransmittedPacketsSent;
  @override
  int? retransmittedBytesSent;
  @override
  int? rtxSsrc;
  @override
  double? targetBitrate;
  @override
  int? totalEncodedBytesTarget;
  @override
  int? frameWidth;
  @override
  int? frameHeight;
  @override
  double? framesPerSecond;
  @override
  int? framesSent;
  @override
  int? hugeFramesSent;
  @override
  int? framesEncoded;
  @override
  int? keyFramesEncoded;
  @override
  int? qpSum;
  @override
  double? totalEncodeTime;
  @override
  double? totalPacketSendDelay;
  @override
  RTCQualityLimitationReason? qualityLimitationReason;
  @override
  Map<String, double>? qualityLimitationDurations;
  @override
  int? qualityLimitationResolutionChanges;
  @override
  int? nackCount;
  @override
  int? firCount;
  @override
  int? pliCount;
  @override
  String? encoderImplementation;
  @override
  bool? powerEfficientEncoder;
  @override
  bool? active;
  @override
  String? scalabilityMode;

  RTCOutboundRtpStreamStatsValue({
    this.mid,
    this.mediaSourceId,
    this.remoteId,
    this.rid,
    this.headerBytesSent,
    this.retransmittedPacketsSent,
    this.retransmittedBytesSent,
    this.rtxSsrc,
    this.targetBitrate,
    this.totalEncodedBytesTarget,
    this.frameWidth,
    this.frameHeight,
    this.framesPerSecond,
    this.framesSent,
    this.hugeFramesSent,
    this.framesEncoded,
    this.keyFramesEncoded,
    this.qpSum,
    this.totalEncodeTime,
    this.totalPacketSendDelay,
    this.qualityLimitationReason,
    this.qualityLimitationDurations,
    this.qualityLimitationResolutionChanges,
    this.nackCount,
    this.firCount,
    this.pliCount,
    this.encoderImplementation,
    this.powerEfficientEncoder,
    this.active,
    this.scalabilityMode,
  });
}

abstract interface class RTCPeerConnectionStats {
  int? get dataChannelsOpened;
  set dataChannelsOpened(int? value);
  int? get dataChannelsClosed;
  set dataChannelsClosed(int? value);
}

final class RTCPeerConnectionStatsValue implements RTCPeerConnectionStats {
  @override
  int? dataChannelsOpened;
  @override
  int? dataChannelsClosed;

  RTCPeerConnectionStatsValue({
    this.dataChannelsOpened,
    this.dataChannelsClosed,
  });
}

typedef RTCQualityLimitationReason = String;

abstract interface class RTCReceivedRtpStreamStats {
  int? get packetsReceived;
  set packetsReceived(int? value);
  int? get packetsLost;
  set packetsLost(int? value);
  double? get jitter;
  set jitter(double? value);
}

final class RTCReceivedRtpStreamStatsValue implements RTCReceivedRtpStreamStats {
  @override
  int? packetsReceived;
  @override
  int? packetsLost;
  @override
  double? jitter;

  RTCReceivedRtpStreamStatsValue({
    this.packetsReceived,
    this.packetsLost,
    this.jitter,
  });
}

abstract interface class RTCRemoteInboundRtpStreamStats {
  String? get localId;
  set localId(String? value);
  double? get roundTripTime;
  set roundTripTime(double? value);
  double? get totalRoundTripTime;
  set totalRoundTripTime(double? value);
  double? get fractionLost;
  set fractionLost(double? value);
  int? get roundTripTimeMeasurements;
  set roundTripTimeMeasurements(int? value);
}

final class RTCRemoteInboundRtpStreamStatsValue implements RTCRemoteInboundRtpStreamStats {
  @override
  String? localId;
  @override
  double? roundTripTime;
  @override
  double? totalRoundTripTime;
  @override
  double? fractionLost;
  @override
  int? roundTripTimeMeasurements;

  RTCRemoteInboundRtpStreamStatsValue({
    this.localId,
    this.roundTripTime,
    this.totalRoundTripTime,
    this.fractionLost,
    this.roundTripTimeMeasurements,
  });
}

abstract interface class RTCRemoteOutboundRtpStreamStats {
  String? get localId;
  set localId(String? value);
  DOMHighResTimeStamp? get remoteTimestamp;
  set remoteTimestamp(DOMHighResTimeStamp? value);
  int? get reportsSent;
  set reportsSent(int? value);
  double? get roundTripTime;
  set roundTripTime(double? value);
  double? get totalRoundTripTime;
  set totalRoundTripTime(double? value);
  int? get roundTripTimeMeasurements;
  set roundTripTimeMeasurements(int? value);
}

final class RTCRemoteOutboundRtpStreamStatsValue implements RTCRemoteOutboundRtpStreamStats {
  @override
  String? localId;
  @override
  DOMHighResTimeStamp? remoteTimestamp;
  @override
  int? reportsSent;
  @override
  double? roundTripTime;
  @override
  double? totalRoundTripTime;
  @override
  int? roundTripTimeMeasurements;

  RTCRemoteOutboundRtpStreamStatsValue({
    this.localId,
    this.remoteTimestamp,
    this.reportsSent,
    this.roundTripTime,
    this.totalRoundTripTime,
    this.roundTripTimeMeasurements,
  });
}

abstract interface class RTCRtpStreamStats {
  int get ssrc;
  set ssrc(int value);
  String get kind;
  set kind(String value);
  String? get transportId;
  set transportId(String? value);
  String? get codecId;
  set codecId(String? value);
}

final class RTCRtpStreamStatsValue implements RTCRtpStreamStats {
  @override
  int ssrc;
  @override
  String kind;
  @override
  String? transportId;
  @override
  String? codecId;

  RTCRtpStreamStatsValue({
    required this.ssrc,
    required this.kind,
    this.transportId,
    this.codecId,
  });
}

abstract interface class RTCSentRtpStreamStats {
  int? get packetsSent;
  set packetsSent(int? value);
  int? get bytesSent;
  set bytesSent(int? value);
}

final class RTCSentRtpStreamStatsValue implements RTCSentRtpStreamStats {
  @override
  int? packetsSent;
  @override
  int? bytesSent;

  RTCSentRtpStreamStatsValue({
    this.packetsSent,
    this.bytesSent,
  });
}

typedef RTCStatsIceCandidatePairState = String;

typedef RTCStatsType = String;

abstract interface class RTCTransportStats {
  int? get packetsSent;
  set packetsSent(int? value);
  int? get packetsReceived;
  set packetsReceived(int? value);
  int? get bytesSent;
  set bytesSent(int? value);
  int? get bytesReceived;
  set bytesReceived(int? value);
  RTCIceRole? get iceRole;
  set iceRole(RTCIceRole? value);
  String? get iceLocalUsernameFragment;
  set iceLocalUsernameFragment(String? value);
  RTCDtlsTransportState get dtlsState;
  set dtlsState(RTCDtlsTransportState value);
  RTCIceTransportState? get iceState;
  set iceState(RTCIceTransportState? value);
  String? get selectedCandidatePairId;
  set selectedCandidatePairId(String? value);
  String? get localCertificateId;
  set localCertificateId(String? value);
  String? get remoteCertificateId;
  set remoteCertificateId(String? value);
  String? get tlsVersion;
  set tlsVersion(String? value);
  String? get dtlsCipher;
  set dtlsCipher(String? value);
  RTCDtlsRole? get dtlsRole;
  set dtlsRole(RTCDtlsRole? value);
  String? get srtpCipher;
  set srtpCipher(String? value);
  int? get selectedCandidatePairChanges;
  set selectedCandidatePairChanges(int? value);
}

final class RTCTransportStatsValue implements RTCTransportStats {
  @override
  int? packetsSent;
  @override
  int? packetsReceived;
  @override
  int? bytesSent;
  @override
  int? bytesReceived;
  @override
  RTCIceRole? iceRole;
  @override
  String? iceLocalUsernameFragment;
  @override
  RTCDtlsTransportState dtlsState;
  @override
  RTCIceTransportState? iceState;
  @override
  String? selectedCandidatePairId;
  @override
  String? localCertificateId;
  @override
  String? remoteCertificateId;
  @override
  String? tlsVersion;
  @override
  String? dtlsCipher;
  @override
  RTCDtlsRole? dtlsRole;
  @override
  String? srtpCipher;
  @override
  int? selectedCandidatePairChanges;

  RTCTransportStatsValue({
    this.packetsSent,
    this.packetsReceived,
    this.bytesSent,
    this.bytesReceived,
    this.iceRole,
    this.iceLocalUsernameFragment,
    required this.dtlsState,
    this.iceState,
    this.selectedCandidatePairId,
    this.localCertificateId,
    this.remoteCertificateId,
    this.tlsVersion,
    this.dtlsCipher,
    this.dtlsRole,
    this.srtpCipher,
    this.selectedCandidatePairChanges,
  });
}

abstract interface class RTCVideoSourceStats {
  int? get width;
  set width(int? value);
  int? get height;
  set height(int? value);
  int? get frames;
  set frames(int? value);
  double? get framesPerSecond;
  set framesPerSecond(double? value);
}

final class RTCVideoSourceStatsValue implements RTCVideoSourceStats {
  @override
  int? width;
  @override
  int? height;
  @override
  int? frames;
  @override
  double? framesPerSecond;

  RTCVideoSourceStatsValue({
    this.width,
    this.height,
    this.frames,
    this.framesPerSecond,
  });
}

