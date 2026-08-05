// GENERATED CODE — DO NOT EDIT
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

abstract interface class IntersectionObserverInit {
  Object get root;
  set root(Object value);
  String get rootMargin;
  set rootMargin(String value);
  String get scrollMargin;
  set scrollMargin(String value);
  Object get threshold;
  set threshold(Object value);
}

