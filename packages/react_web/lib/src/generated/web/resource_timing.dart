// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: resource-timing
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'server_timing.dart';

abstract interface class PerformanceResourceTiming {
  String get initiatorType;
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
  DOMHighResTimeStamp get responseStart;
  DOMHighResTimeStamp get responseEnd;
  int get transferSize;
  int get encodedBodySize;
  int get decodedBodySize;
  RenderBlockingStatusType get renderBlockingStatus;
  List<PerformanceServerTiming> get serverTiming;
}

typedef RenderBlockingStatusType = String;

