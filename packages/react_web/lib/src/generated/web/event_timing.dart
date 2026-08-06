// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: event-timing
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'navigation_timing.dart';
import 'performance_timeline.dart';
import 'html.dart';
import 'user_timing.dart';
import 'dom.dart';

abstract interface class EventCounts {
}

abstract interface class Performance {
  EventCounts get eventCounts;
  DOMHighResTimeStamp now();
  DOMHighResTimeStamp get timeOrigin;
  Object toJSON();
  PerformanceTiming get timing;
  PerformanceNavigation get navigation;
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
}

abstract interface class PerformanceObserverInit {
  DOMHighResTimeStamp? get durationThreshold;
  set durationThreshold(DOMHighResTimeStamp? value);
  List<String>? get entryTypes;
  set entryTypes(List<String>? value);
  String? get type;
  set type(String? value);
  bool? get buffered;
  set buffered(bool? value);
}

final class PerformanceObserverInitValue implements PerformanceObserverInit {
  @override
  DOMHighResTimeStamp? durationThreshold;
  @override
  List<String>? entryTypes;
  @override
  String? type;
  @override
  bool? buffered;

  PerformanceObserverInitValue({
    this.durationThreshold,
    this.entryTypes,
    this.type,
    this.buffered,
  });
}

