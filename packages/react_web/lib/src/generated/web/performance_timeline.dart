// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: performance-timeline
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'event_timing.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class PerformanceEntry {
  String get name;
  String get entryType;
  DOMHighResTimeStamp get startTime;
  DOMHighResTimeStamp get duration;
  Object toJSON();
}

typedef PerformanceEntryList = List<PerformanceEntry>;

abstract interface class PerformanceObserver {
  factory PerformanceObserver(PerformanceObserverCallback callback) =>
      WebRuntime.current.createWebObject<PerformanceObserver>(
        'PerformanceObserver',
        [callback],
      );
  void observe([PerformanceObserverInit? options]);
  void disconnect();
  PerformanceEntryList takeRecords();
}

typedef PerformanceObserverCallback = void Function(PerformanceObserverEntryList entries, PerformanceObserver observer, PerformanceObserverCallbackOptions options,);

abstract interface class PerformanceObserverCallbackOptions {
  int get droppedEntriesCount;
  set droppedEntriesCount(int value);
}

abstract interface class PerformanceObserverEntryList {
  PerformanceEntryList getEntries();
  PerformanceEntryList getEntriesByType(String type);
  PerformanceEntryList getEntriesByName(String name, [String? type]);
}

