// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: user-timing
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class PerformanceMark {
  factory PerformanceMark(
    String markName, [
    PerformanceMarkOptions? markOptions,
  ]) => WebRuntime.current.createWebObject<PerformanceMark>('PerformanceMark', [
    markName,
    markOptions,
  ]);
  Object get detail;
}

abstract interface class PerformanceMarkOptions {
  Object? get detail;
  set detail(Object? value);
  DOMHighResTimeStamp? get startTime;
  set startTime(DOMHighResTimeStamp? value);
}

final class PerformanceMarkOptionsValue implements PerformanceMarkOptions {
  @override
  Object? detail;
  @override
  DOMHighResTimeStamp? startTime;

  PerformanceMarkOptionsValue({this.detail, this.startTime});
}

abstract interface class PerformanceMeasure {
  Object get detail;
}

abstract interface class PerformanceMeasureOptions {
  Object? get detail;
  set detail(Object? value);
  Object? get start;
  set start(Object? value);
  DOMHighResTimeStamp? get duration;
  set duration(DOMHighResTimeStamp? value);
  Object? get end;
  set end(Object? value);
}

final class PerformanceMeasureOptionsValue
    implements PerformanceMeasureOptions {
  @override
  Object? detail;
  @override
  Object? start;
  @override
  DOMHighResTimeStamp? duration;
  @override
  Object? end;

  PerformanceMeasureOptionsValue({
    this.detail,
    this.start,
    this.duration,
    this.end,
  });
}
