// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webtransport
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';
import 'hr_time.dart';
import 'webidl.dart';

abstract interface class WebTransport {
  Future<WebTransportConnectionStats> getStats();
  Future<void> get ready;
  WebTransportReliabilityMode get reliability;
  WebTransportCongestionControl get congestionControl;
  int? get anticipatedConcurrentIncomingUnidirectionalStreams;
   set anticipatedConcurrentIncomingUnidirectionalStreams(int? value);
  int? get anticipatedConcurrentIncomingBidirectionalStreams;
   set anticipatedConcurrentIncomingBidirectionalStreams(int? value);
  String get protocol;
  Future<WebTransportCloseInfo> get closed;
  Future<void> get draining;
  void close([WebTransportCloseInfo? closeInfo]);
  WebTransportDatagramDuplexStream get datagrams;
  Future<WebTransportBidirectionalStream> createBidirectionalStream([WebTransportSendStreamOptions? options]);
  ReadableStream get incomingBidirectionalStreams;
  Future<WebTransportSendStream> createUnidirectionalStream([WebTransportSendStreamOptions? options]);
  ReadableStream get incomingUnidirectionalStreams;
  WebTransportSendGroup createSendGroup();
}

abstract interface class WebTransportBidirectionalStream {
  WebTransportReceiveStream get readable;
  WebTransportSendStream get writable;
}

abstract interface class WebTransportCloseInfo {
  int get closeCode;
  set closeCode(int value);
  String get reason;
  set reason(String value);
}

typedef WebTransportCongestionControl = String;

abstract interface class WebTransportConnectionStats {
  int get bytesSent;
  set bytesSent(int value);
  int get packetsSent;
  set packetsSent(int value);
  int get bytesLost;
  set bytesLost(int value);
  int get packetsLost;
  set packetsLost(int value);
  int get bytesReceived;
  set bytesReceived(int value);
  int get packetsReceived;
  set packetsReceived(int value);
  DOMHighResTimeStamp get smoothedRtt;
  set smoothedRtt(DOMHighResTimeStamp value);
  DOMHighResTimeStamp get rttVariation;
  set rttVariation(DOMHighResTimeStamp value);
  DOMHighResTimeStamp get minRtt;
  set minRtt(DOMHighResTimeStamp value);
  WebTransportDatagramStats get datagrams;
  set datagrams(WebTransportDatagramStats value);
  int? get estimatedSendRate;
  set estimatedSendRate(int? value);
  bool get atSendCapacity;
  set atSendCapacity(bool value);
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
  int get droppedIncoming;
  set droppedIncoming(int value);
  int get expiredIncoming;
  set expiredIncoming(int value);
  int get expiredOutgoing;
  set expiredOutgoing(int value);
  int get lostOutgoing;
  set lostOutgoing(int value);
}

abstract interface class WebTransportError {
  WebTransportErrorSource get source;
  int? get streamErrorCode;
}

abstract interface class WebTransportErrorOptions {
  WebTransportErrorSource get source;
  set source(WebTransportErrorSource value);
  int? get streamErrorCode;
  set streamErrorCode(int? value);
}

typedef WebTransportErrorSource = String;

abstract interface class WebTransportHash {
  String get algorithm;
  set algorithm(String value);
  BufferSource get value;
  set value(BufferSource value);
}

abstract interface class WebTransportOptions {
  bool get allowPooling;
  set allowPooling(bool value);
  bool get requireUnreliable;
  set requireUnreliable(bool value);
  List<WebTransportHash> get serverCertificateHashes;
  set serverCertificateHashes(List<WebTransportHash> value);
  WebTransportCongestionControl get congestionControl;
  set congestionControl(WebTransportCongestionControl value);
  int? get anticipatedConcurrentIncomingUnidirectionalStreams;
  set anticipatedConcurrentIncomingUnidirectionalStreams(int? value);
  int? get anticipatedConcurrentIncomingBidirectionalStreams;
  set anticipatedConcurrentIncomingBidirectionalStreams(int? value);
  List<String> get protocols;
  set protocols(List<String> value);
}

abstract interface class WebTransportReceiveStream {
  Future<WebTransportReceiveStreamStats> getStats();
}

abstract interface class WebTransportReceiveStreamStats {
  int get bytesReceived;
  set bytesReceived(int value);
  int get bytesRead;
  set bytesRead(int value);
}

typedef WebTransportReliabilityMode = String;

abstract interface class WebTransportSendGroup {
  Future<WebTransportSendStreamStats> getStats();
}

abstract interface class WebTransportSendStream {
  WebTransportSendGroup? get sendGroup;
   set sendGroup(WebTransportSendGroup? value);
  int get sendOrder;
   set sendOrder(int value);
  Future<WebTransportSendStreamStats> getStats();
  WebTransportWriter getWriter();
}

abstract interface class WebTransportSendStreamOptions {
  WebTransportSendGroup? get sendGroup;
  set sendGroup(WebTransportSendGroup? value);
  int get sendOrder;
  set sendOrder(int value);
  bool get waitUntilAvailable;
  set waitUntilAvailable(bool value);
}

abstract interface class WebTransportSendStreamStats {
  int get bytesWritten;
  set bytesWritten(int value);
  int get bytesSent;
  set bytesSent(int value);
  int get bytesAcknowledged;
  set bytesAcknowledged(int value);
}

abstract interface class WebTransportWriter {
  Future<void> atomicWrite([Object? chunk]);
}

