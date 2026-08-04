// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: element-timing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'geometry.dart';
import 'css_nav.dart';

abstract interface class PerformanceElementTiming {
  DOMHighResTimeStamp get paintTime;
  DOMHighResTimeStamp? get presentationTime;
  DOMHighResTimeStamp get renderTime;
  DOMHighResTimeStamp get loadTime;
  DOMRectReadOnly get intersectionRect;
  String get identifier;
  int get naturalWidth;
  int get naturalHeight;
  String get id;
  Element? get element;
  String get url;
}

