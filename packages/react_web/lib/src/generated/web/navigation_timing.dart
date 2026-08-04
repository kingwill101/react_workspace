// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: navigation-timing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'html.dart';

typedef NavigationTimingType = String;

abstract interface class PerformanceNavigation {
   static const int TYPE_NAVIGATE =
      0;
   static const int TYPE_RELOAD =
      1;
   static const int TYPE_BACK_FORWARD =
      2;
   static const int TYPE_RESERVED =
      255;
  int get type;
  int get redirectCount;
  Object toJSON();
}

abstract interface class PerformanceNavigationTiming {
  DOMHighResTimeStamp get unloadEventStart;
  DOMHighResTimeStamp get unloadEventEnd;
  DOMHighResTimeStamp get domInteractive;
  DOMHighResTimeStamp get domContentLoadedEventStart;
  DOMHighResTimeStamp get domContentLoadedEventEnd;
  DOMHighResTimeStamp get domComplete;
  DOMHighResTimeStamp get loadEventStart;
  DOMHighResTimeStamp get loadEventEnd;
  NavigationTimingType get type;
  int get redirectCount;
  DOMHighResTimeStamp get criticalCHRestart;
  NotRestoredReasons? get notRestoredReasons;
  DOMHighResTimeStamp get activationStart;
}

abstract interface class PerformanceTiming {
  int get navigationStart;
  int get unloadEventStart;
  int get unloadEventEnd;
  int get redirectStart;
  int get redirectEnd;
  int get fetchStart;
  int get domainLookupStart;
  int get domainLookupEnd;
  int get connectStart;
  int get connectEnd;
  int get secureConnectionStart;
  int get requestStart;
  int get responseStart;
  int get responseEnd;
  int get domLoading;
  int get domInteractive;
  int get domContentLoadedEventStart;
  int get domContentLoadedEventEnd;
  int get domComplete;
  int get loadEventStart;
  int get loadEventEnd;
  Object toJSON();
}

