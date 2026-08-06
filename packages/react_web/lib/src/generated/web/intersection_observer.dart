// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: intersection-observer
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_nav.dart';
import 'svg.dart';
import 'hr_time.dart';
import 'geometry.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class IntersectionObserver {
  factory IntersectionObserver(IntersectionObserverCallback callback, [IntersectionObserverInit? options]) =>
      WebRuntime.current.createWebObject<IntersectionObserver>(
        'IntersectionObserver',
        [callback, options],
      );
  Object get root;
  String get rootMargin;
  List<double> get thresholds;
  void observe(Element target);
  void unobserve(Element target);
  void disconnect();
  List<IntersectionObserverEntry> takeRecords();
}

typedef IntersectionObserverCallback = void Function(List<IntersectionObserverEntry> entries, IntersectionObserver observer,);

abstract interface class IntersectionObserverEntry {
  factory IntersectionObserverEntry(IntersectionObserverEntryInit intersectionObserverEntryInit) =>
      WebRuntime.current.createWebObject<IntersectionObserverEntry>(
        'IntersectionObserverEntry',
        [intersectionObserverEntryInit],
      );
  DOMHighResTimeStamp get time;
  DOMRectReadOnly? get rootBounds;
  DOMRectReadOnly get boundingClientRect;
  DOMRectReadOnly get intersectionRect;
  bool get isIntersecting;
  double get intersectionRatio;
  Element get target;
}

abstract interface class IntersectionObserverEntryInit {
  DOMHighResTimeStamp get time;
  set time(DOMHighResTimeStamp value);
  DOMRectInit? get rootBounds;
  set rootBounds(DOMRectInit? value);
  DOMRectInit get boundingClientRect;
  set boundingClientRect(DOMRectInit value);
  DOMRectInit get intersectionRect;
  set intersectionRect(DOMRectInit value);
  bool get isIntersecting;
  set isIntersecting(bool value);
  double get intersectionRatio;
  set intersectionRatio(double value);
  Element get target;
  set target(Element value);
}

final class IntersectionObserverEntryInitValue implements IntersectionObserverEntryInit {
  @override
  DOMHighResTimeStamp time;
  @override
  DOMRectInit? rootBounds;
  @override
  DOMRectInit boundingClientRect;
  @override
  DOMRectInit intersectionRect;
  @override
  bool isIntersecting;
  @override
  double intersectionRatio;
  @override
  Element target;

  IntersectionObserverEntryInitValue({
    required this.time,
    required this.rootBounds,
    required this.boundingClientRect,
    required this.intersectionRect,
    required this.isIntersecting,
    required this.intersectionRatio,
    required this.target,
  });
}

abstract interface class IntersectionObserverInit {
  Object? get root;
  set root(Object? value);
  String? get rootMargin;
  set rootMargin(String? value);
  String? get scrollMargin;
  set scrollMargin(String? value);
  Object? get threshold;
  set threshold(Object? value);
}

final class IntersectionObserverInitValue implements IntersectionObserverInit {
  @override
  Object? root;
  @override
  String? rootMargin;
  @override
  String? scrollMargin;
  @override
  Object? threshold;

  IntersectionObserverInitValue({
    this.root,
    this.rootMargin,
    this.scrollMargin,
    this.threshold,
  });
}

