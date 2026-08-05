// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxrlayers
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'webxr.dart';
import 'dom.dart';
import 'webgl1.dart';

abstract interface class XRCubeLayerInit {
  DOMPointReadOnly? get orientation;
  set orientation(DOMPointReadOnly? value);
}

abstract interface class XRCylinderLayerInit {
  XRTextureType get textureType;
  set textureType(XRTextureType value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double get radius;
  set radius(double value);
  double get centralAngle;
  set centralAngle(double value);
  double get aspectRatio;
  set aspectRatio(double value);
}

abstract interface class XREquirectLayerInit {
  XRTextureType get textureType;
  set textureType(XRTextureType value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double get radius;
  set radius(double value);
  double get centralHorizontalAngle;
  set centralHorizontalAngle(double value);
  double get upperVerticalAngle;
  set upperVerticalAngle(double value);
  double get lowerVerticalAngle;
  set lowerVerticalAngle(double value);
}

abstract interface class XRLayerEventInit {
  Object get layer;
  set layer(Object value);
}

abstract interface class XRLayerInit {
  XRSpace get space;
  set space(XRSpace value);
  GLenum get colorFormat;
  set colorFormat(GLenum value);
  GLenum? get depthFormat;
  set depthFormat(GLenum? value);
  int get mipLevels;
  set mipLevels(int value);
  int get viewPixelWidth;
  set viewPixelWidth(int value);
  int get viewPixelHeight;
  set viewPixelHeight(int value);
  XRLayerLayout get layout;
  set layout(XRLayerLayout value);
  bool get isStatic;
  set isStatic(bool value);
  bool get clearOnAccess;
  set clearOnAccess(bool value);
}

typedef XRLayerLayout = String;

typedef XRLayerQuality = String;

abstract interface class XRMediaCylinderLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double get radius;
  set radius(double value);
  double get centralAngle;
  set centralAngle(double value);
  double? get aspectRatio;
  set aspectRatio(double? value);
}

abstract interface class XRMediaEquirectLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double get radius;
  set radius(double value);
  double get centralHorizontalAngle;
  set centralHorizontalAngle(double value);
  double get upperVerticalAngle;
  set upperVerticalAngle(double value);
  double get lowerVerticalAngle;
  set lowerVerticalAngle(double value);
}

abstract interface class XRMediaLayerInit {
  XRSpace get space;
  set space(XRSpace value);
  XRLayerLayout get layout;
  set layout(XRLayerLayout value);
  bool get invertStereo;
  set invertStereo(bool value);
}

abstract interface class XRMediaQuadLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get width;
  set width(double? value);
  double? get height;
  set height(double? value);
}

abstract interface class XRProjectionLayerInit {
  XRTextureType get textureType;
  set textureType(XRTextureType value);
  GLenum get colorFormat;
  set colorFormat(GLenum value);
  GLenum get depthFormat;
  set depthFormat(GLenum value);
  double get scaleFactor;
  set scaleFactor(double value);
  bool get clearOnAccess;
  set clearOnAccess(bool value);
}

abstract interface class XRQuadLayerInit {
  XRTextureType get textureType;
  set textureType(XRTextureType value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double get width;
  set width(double value);
  double get height;
  set height(double value);
}

typedef XRTextureType = String;

