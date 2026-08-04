// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-hit-test
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'geometry.dart';
import 'webxr_gamepads_module.dart';
import 'anchors.dart';

abstract interface class XRHitTestOptionsInit {
  XRSpace get space;
  set space(XRSpace value);
  List<XRHitTestTrackableType> get entityTypes;
  set entityTypes(List<XRHitTestTrackableType> value);
  XRRay get offsetRay;
  set offsetRay(XRRay value);
}

abstract interface class XRHitTestSource {
  void cancel();
}

typedef XRHitTestTrackableType = String;

abstract interface class XRRay {
  DOMPointReadOnly get origin;
  DOMPointReadOnly get direction;
  Object get matrix;
}

abstract interface class XRRayDirectionInit {
  double get x;
  set x(double value);
  double get y;
  set y(double value);
  double get z;
  set z(double value);
  double get w;
  set w(double value);
}

abstract interface class XRTransientInputHitTestOptionsInit {
  String get profile;
  set profile(String value);
  List<XRHitTestTrackableType> get entityTypes;
  set entityTypes(List<XRHitTestTrackableType> value);
  XRRay get offsetRay;
  set offsetRay(XRRay value);
}

abstract interface class XRTransientInputHitTestResult {
  XRInputSource get inputSource;
  List<XRHitTestResult> get results;
}

abstract interface class XRTransientInputHitTestSource {
  void cancel();
}

