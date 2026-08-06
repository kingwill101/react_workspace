// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webtransport
// ignore_for_file: type=lint

import 'streams.dart';
import 'hr_time.dart';
import 'webidl.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class WebTransport {
  factory WebTransport(String url, [WebTransportOptions? options]) =>
      WebRuntime.current.createWebObject<WebTransport>(
        'WebTransport',
        [url, options],
      );
  Future<void> get ready;
  Future<WebTransportCloseInfo> get closed;
  void close([WebTransportCloseInfo? closeInfo]);
  WebTransportDatagramDuplexStream get datagrams;
  Future<WebTransportBidirectionalStream> createBidirectionalStream([WebTransportSendStreamOptions? options]);
  ReadableStream get incomingBidirectionalStreams;
  Future<Object> createUnidirectionalStream([WebTransportSendStreamOptions? options]);
  ReadableStream get incomingUnidirectionalStreams;
}

abstract interface class WebTransportBidirectionalStream {
  Object get readable;
  Object get writable;
}

abstract interface class WebTransportCloseInfo {
  int? get closeCode;
  set closeCode(int? value);
  String? get reason;
  set reason(String? value);
}

final class WebTransportCloseInfoValue implements WebTransportCloseInfo {
  @override
  int? closeCode;
  @override
  String? reason;

  WebTransportCloseInfoValue({
    this.closeCode,
    this.reason,
  });
}

typedef WebTransportCongestionControl = String;

abstract interface class WebTransportConnectionStats {
  int? get bytesSent;
  set bytesSent(int? value);
  int? get packetsSent;
  set packetsSent(int? value);
  int? get bytesLost;
  set bytesLost(int? value);
  int? get packetsLost;
  set packetsLost(int? value);
  int? get bytesReceived;
  set bytesReceived(int? value);
  int? get packetsReceived;
  set packetsReceived(int? value);
  DOMHighResTimeStamp? get smoothedRtt;
  set smoothedRtt(DOMHighResTimeStamp? value);
  DOMHighResTimeStamp? get rttVariation;
  set rttVariation(DOMHighResTimeStamp? value);
  DOMHighResTimeStamp? get minRtt;
  set minRtt(DOMHighResTimeStamp? value);
  WebTransportDatagramStats? get datagrams;
  set datagrams(WebTransportDatagramStats? value);
  int? get estimatedSendRate;
  set estimatedSendRate(int? value);
}

final class WebTransportConnectionStatsValue implements WebTransportConnectionStats {
  @override
  int? bytesSent;
  @override
  int? packetsSent;
  @override
  int? bytesLost;
  @override
  int? packetsLost;
  @override
  int? bytesReceived;
  @override
  int? packetsReceived;
  @override
  DOMHighResTimeStamp? smoothedRtt;
  @override
  DOMHighResTimeStamp? rttVariation;
  @override
  DOMHighResTimeStamp? minRtt;
  @override
  WebTransportDatagramStats? datagrams;
  @override
  int? estimatedSendRate;

  WebTransportConnectionStatsValue({
    this.bytesSent,
    this.packetsSent,
    this.bytesLost,
    this.packetsLost,
    this.bytesReceived,
    this.packetsReceived,
    this.smoothedRtt,
    this.rttVariation,
    this.minRtt,
    this.datagrams,
    this.estimatedSendRate,
  });
}

abstract interface class WebTransportDatagramDuplexStream {
  ReadableStream get readable;
  WritableStream get writable;
  int get maxDatagramSize;
  double? get incomingMaxAge;
   set incomingMaxAge(double? value);
  double? get outgoingMaxAge;
   set outgoingMaxAge(double? value);
  double get incomingHighWaterMark;
   set incomingHighWaterMark(double value);
  double get outgoingHighWaterMark;
   set outgoingHighWaterMark(double value);
}

abstract interface class WebTransportDatagramStats {
  int? get droppedIncoming;
  set droppedIncoming(int? value);
  int? get expiredIncoming;
  set expiredIncoming(int? value);
  int? get expiredOutgoing;
  set expiredOutgoing(int? value);
  int? get lostOutgoing;
  set lostOutgoing(int? value);
}

final class WebTransportDatagramStatsValue implements WebTransportDatagramStats {
  @override
  int? droppedIncoming;
  @override
  int? expiredIncoming;
  @override
  int? expiredOutgoing;
  @override
  int? lostOutgoing;

  WebTransportDatagramStatsValue({
    this.droppedIncoming,
    this.expiredIncoming,
    this.expiredOutgoing,
    this.lostOutgoing,
  });
}

abstract interface class WebTransportError {
  factory WebTransportError([String? message, WebTransportErrorOptions? options]) =>
      WebRuntime.current.createWebObject<WebTransportError>(
        'WebTransportError',
        [message, options],
      );
  WebTransportErrorSource get source;
  int? get streamErrorCode;
}

abstract interface class WebTransportErrorOptions {
  WebTransportErrorSource? get source;
  set source(WebTransportErrorSource? value);
  int? get streamErrorCode;
  set streamErrorCode(int? value);
}

final class WebTransportErrorOptionsValue implements WebTransportErrorOptions {
  @override
  WebTransportErrorSource? source;
  @override
  int? streamErrorCode;

  WebTransportErrorOptionsValue({
    this.source,
    this.streamErrorCode,
  });
}

typedef WebTransportErrorSource = String;

abstract interface class WebTransportHash {
  String? get algorithm;
  set algorithm(String? value);
  BufferSource? get value;
  set value(BufferSource? value);
}

final class WebTransportHashValue implements WebTransportHash {
  @override
  String? algorithm;
  @override
  BufferSource? value;

  WebTransportHashValue({
    this.algorithm,
    this.value,
  });
}

abstract interface class WebTransportOptions {
  bool? get allowPooling;
  set allowPooling(bool? value);
  bool? get requireUnreliable;
  set requireUnreliable(bool? value);
  List<WebTransportHash>? get serverCertificateHashes;
  set serverCertificateHashes(List<WebTransportHash>? value);
  WebTransportCongestionControl? get congestionControl;
  set congestionControl(WebTransportCongestionControl? value);
  int? get anticipatedConcurrentIncomingUnidirectionalStreams;
  set anticipatedConcurrentIncomingUnidirectionalStreams(int? value);
  int? get anticipatedConcurrentIncomingBidirectionalStreams;
  set anticipatedConcurrentIncomingBidirectionalStreams(int? value);
}

final class WebTransportOptionsValue implements WebTransportOptions {
  @override
  bool? allowPooling;
  @override
  bool? requireUnreliable;
  @override
  List<WebTransportHash>? serverCertificateHashes;
  @override
  WebTransportCongestionControl? congestionControl;
  @override
  int? anticipatedConcurrentIncomingUnidirectionalStreams;
  @override
  int? anticipatedConcurrentIncomingBidirectionalStreams;

  WebTransportOptionsValue({
    this.allowPooling,
    this.requireUnreliable,
    this.serverCertificateHashes,
    this.congestionControl,
    this.anticipatedConcurrentIncomingUnidirectionalStreams,
    this.anticipatedConcurrentIncomingBidirectionalStreams,
  });
}

abstract interface class WebTransportReceiveStreamStats {
  int? get bytesReceived;
  set bytesReceived(int? value);
  int? get bytesRead;
  set bytesRead(int? value);
}

final class WebTransportReceiveStreamStatsValue implements WebTransportReceiveStreamStats {
  @override
  int? bytesReceived;
  @override
  int? bytesRead;

  WebTransportReceiveStreamStatsValue({
    this.bytesReceived,
    this.bytesRead,
  });
}

typedef WebTransportReliabilityMode = String;

abstract interface class WebTransportSendStreamOptions {
  Object? get sendGroup;
  set sendGroup(Object? value);
  int? get sendOrder;
  set sendOrder(int? value);
  bool? get waitUntilAvailable;
  set waitUntilAvailable(bool? value);
}

final class WebTransportSendStreamOptionsValue implements WebTransportSendStreamOptions {
  @override
  Object? sendGroup;
  @override
  int? sendOrder;
  @override
  bool? waitUntilAvailable;

  WebTransportSendStreamOptionsValue({
    this.sendGroup,
    this.sendOrder,
    this.waitUntilAvailable,
  });
}

abstract interface class WebTransportSendStreamStats {
  int? get bytesWritten;
  set bytesWritten(int? value);
  int? get bytesSent;
  set bytesSent(int? value);
  int? get bytesAcknowledged;
  set bytesAcknowledged(int? value);
}

final class WebTransportSendStreamStatsValue implements WebTransportSendStreamStats {
  @override
  int? bytesWritten;
  @override
  int? bytesSent;
  @override
  int? bytesAcknowledged;

  WebTransportSendStreamStatsValue({
    this.bytesWritten,
    this.bytesSent,
    this.bytesAcknowledged,
  });
}

