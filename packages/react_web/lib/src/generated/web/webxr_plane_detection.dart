// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-plane-detection
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'geometry.dart';
import 'hr_time.dart';

abstract interface class XRPlane {
  XRSpace get planeSpace;
  List<DOMPointReadOnly> get polygon;
  XRPlaneOrientation? get orientation;
  DOMHighResTimeStamp get lastChangedTime;
  String? get semanticLabel;
}

typedef XRPlaneOrientation = String;

abstract interface class XRPlaneSet {
   Iterable<XRPlane> get values;
   bool has(Object value);
}

