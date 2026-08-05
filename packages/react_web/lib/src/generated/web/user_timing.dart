// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: user-timing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class PerformanceMark {
  factory PerformanceMark(String markName, [PerformanceMarkOptions? markOptions]) =>
      WebRuntime.current.createWebObject<PerformanceMark>(
        'PerformanceMark',
        [markName, markOptions],
      );
  Object get detail;
}

abstract interface class PerformanceMarkOptions {
  Object get detail;
  set detail(Object value);
  DOMHighResTimeStamp get startTime;
  set startTime(DOMHighResTimeStamp value);
}

abstract interface class PerformanceMeasure {
  Object get detail;
}

abstract interface class PerformanceMeasureOptions {
  Object get detail;
  set detail(Object value);
  Object get start;
  set start(Object value);
  DOMHighResTimeStamp get duration;
  set duration(DOMHighResTimeStamp value);
  Object get end;
  set end(Object value);
}

