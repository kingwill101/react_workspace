// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: long-animation-frames
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'anonymous_iframe.dart';

abstract interface class PerformanceLongAnimationFrameTiming {
  DOMHighResTimeStamp get paintTime;
  DOMHighResTimeStamp? get presentationTime;
  DOMHighResTimeStamp get renderStart;
  DOMHighResTimeStamp get styleAndLayoutStart;
  DOMHighResTimeStamp get blockingDuration;
  DOMHighResTimeStamp get firstUIEventTimestamp;
  List<PerformanceScriptTiming> get scripts;
}

abstract interface class PerformanceScriptTiming {
  ScriptInvokerType get invokerType;
  String get invoker;
  DOMHighResTimeStamp get executionStart;
  String get sourceURL;
  String get sourceFunctionName;
  int get sourceCharPosition;
  DOMHighResTimeStamp get pauseDuration;
  DOMHighResTimeStamp get forcedStyleAndLayoutDuration;
  Window? get window;
  ScriptWindowAttribution get windowAttribution;
}

typedef ScriptInvokerType = String;

typedef ScriptWindowAttribution = String;

