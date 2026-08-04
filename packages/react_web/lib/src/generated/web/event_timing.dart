// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: event-timing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'navigation_timing.dart';
import 'performance_measure_memory.dart';
import 'performance_timeline.dart';
import 'html.dart';
import 'user_timing.dart';
import 'dom.dart';

abstract interface class EventCounts {
   Iterable<String> get keys;
   Iterable<int> get values;
   Iterable<MapEntry<String, int>> get entries;
   int? operator [](Object key);
   bool has(Object key);
}

abstract interface class Performance {
  EventCounts get eventCounts;
  int get interactionCount;
  DOMHighResTimeStamp now();
  DOMHighResTimeStamp get timeOrigin;
  Object toJSON();
  PerformanceTiming get timing;
  PerformanceNavigation get navigation;
  Future<MemoryMeasurement> measureUserAgentSpecificMemory();
  PerformanceEntryList getEntries();
  PerformanceEntryList getEntriesByType(String type);
  PerformanceEntryList getEntriesByName(String name, [String? type]);
  void clearResourceTimings();
  void setResourceTimingBufferSize(int maxSize);
  EventHandler get onresourcetimingbufferfull;
   set onresourcetimingbufferfull(EventHandler value);
  PerformanceMark mark(String markName, [PerformanceMarkOptions? markOptions]);
  void clearMarks([String? markName]);
  PerformanceMeasure measure(String measureName, [Object? startOrMeasureOptions, String? endMark]);
  void clearMeasures([String? measureName]);
}

abstract interface class PerformanceEventTiming {
  DOMHighResTimeStamp get processingStart;
  DOMHighResTimeStamp get processingEnd;
  bool get cancelable;
  Node? get target;
  int get interactionId;
}

abstract interface class PerformanceObserverInit {
  DOMHighResTimeStamp get durationThreshold;
  set durationThreshold(DOMHighResTimeStamp value);
  List<String> get entryTypes;
  set entryTypes(List<String> value);
  String get type;
  set type(String value);
  bool get buffered;
  set buffered(bool value);
}

