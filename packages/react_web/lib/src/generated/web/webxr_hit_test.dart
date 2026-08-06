// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webxr-hit-test
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';

abstract interface class XRHitTestOptionsInit {
  XRSpace get space;
  set space(XRSpace value);
  List<XRHitTestTrackableType>? get entityTypes;
  set entityTypes(List<XRHitTestTrackableType>? value);
  Object? get offsetRay;
  set offsetRay(Object? value);
}

final class XRHitTestOptionsInitValue implements XRHitTestOptionsInit {
  @override
  XRSpace space;
  @override
  List<XRHitTestTrackableType>? entityTypes;
  @override
  Object? offsetRay;

  XRHitTestOptionsInitValue({
    required this.space,
    this.entityTypes,
    this.offsetRay,
  });
}

typedef XRHitTestTrackableType = String;

abstract interface class XRRayDirectionInit {
  double? get x;
  set x(double? value);
  double? get y;
  set y(double? value);
  double? get z;
  set z(double? value);
  double? get w;
  set w(double? value);
}

final class XRRayDirectionInitValue implements XRRayDirectionInit {
  @override
  double? x;
  @override
  double? y;
  @override
  double? z;
  @override
  double? w;

  XRRayDirectionInitValue({
    this.x,
    this.y,
    this.z,
    this.w,
  });
}

abstract interface class XRTransientInputHitTestOptionsInit {
  String get profile;
  set profile(String value);
  List<XRHitTestTrackableType>? get entityTypes;
  set entityTypes(List<XRHitTestTrackableType>? value);
  Object? get offsetRay;
  set offsetRay(Object? value);
}

final class XRTransientInputHitTestOptionsInitValue implements XRTransientInputHitTestOptionsInit {
  @override
  String profile;
  @override
  List<XRHitTestTrackableType>? entityTypes;
  @override
  Object? offsetRay;

  XRTransientInputHitTestOptionsInitValue({
    required this.profile,
    this.entityTypes,
    this.offsetRay,
  });
}

