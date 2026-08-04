// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: resource-timing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'server_timing.dart';

abstract interface class PerformanceResourceTiming {
  String get initiatorType;
  String get deliveryType;
  String get nextHopProtocol;
  DOMHighResTimeStamp get workerStart;
  DOMHighResTimeStamp get redirectStart;
  DOMHighResTimeStamp get redirectEnd;
  DOMHighResTimeStamp get fetchStart;
  DOMHighResTimeStamp get domainLookupStart;
  DOMHighResTimeStamp get domainLookupEnd;
  DOMHighResTimeStamp get connectStart;
  DOMHighResTimeStamp get connectEnd;
  DOMHighResTimeStamp get secureConnectionStart;
  DOMHighResTimeStamp get requestStart;
  DOMHighResTimeStamp get finalResponseHeadersStart;
  DOMHighResTimeStamp get firstInterimResponseStart;
  DOMHighResTimeStamp get responseStart;
  DOMHighResTimeStamp get responseEnd;
  int get transferSize;
  int get encodedBodySize;
  int get decodedBodySize;
  int get responseStatus;
  RenderBlockingStatusType get renderBlockingStatus;
  String get contentType;
  List<PerformanceServerTiming> get serverTiming;
}

typedef RenderBlockingStatusType = String;

