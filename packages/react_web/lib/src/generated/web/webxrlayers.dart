// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxrlayers
// ignore_for_file: type=lint

import 'geometry.dart';
import 'webgl1.dart';
import 'webxr.dart';

abstract interface class XRCubeLayerInit {
  DOMPointReadOnly? get orientation;
  set orientation(DOMPointReadOnly? value);
}

final class XRCubeLayerInitValue implements XRCubeLayerInit {
  @override
  DOMPointReadOnly? orientation;

  XRCubeLayerInitValue({this.orientation});
}

abstract interface class XRCylinderLayerInit {
  XRTextureType? get textureType;
  set textureType(XRTextureType? value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get radius;
  set radius(double? value);
  double? get centralAngle;
  set centralAngle(double? value);
  double? get aspectRatio;
  set aspectRatio(double? value);
}

final class XRCylinderLayerInitValue implements XRCylinderLayerInit {
  @override
  XRTextureType? textureType;
  @override
  XRRigidTransform? transform;
  @override
  double? radius;
  @override
  double? centralAngle;
  @override
  double? aspectRatio;

  XRCylinderLayerInitValue({
    this.textureType,
    this.transform,
    this.radius,
    this.centralAngle,
    this.aspectRatio,
  });
}

abstract interface class XREquirectLayerInit {
  XRTextureType? get textureType;
  set textureType(XRTextureType? value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get radius;
  set radius(double? value);
  double? get centralHorizontalAngle;
  set centralHorizontalAngle(double? value);
  double? get upperVerticalAngle;
  set upperVerticalAngle(double? value);
  double? get lowerVerticalAngle;
  set lowerVerticalAngle(double? value);
}

final class XREquirectLayerInitValue implements XREquirectLayerInit {
  @override
  XRTextureType? textureType;
  @override
  XRRigidTransform? transform;
  @override
  double? radius;
  @override
  double? centralHorizontalAngle;
  @override
  double? upperVerticalAngle;
  @override
  double? lowerVerticalAngle;

  XREquirectLayerInitValue({
    this.textureType,
    this.transform,
    this.radius,
    this.centralHorizontalAngle,
    this.upperVerticalAngle,
    this.lowerVerticalAngle,
  });
}

abstract interface class XRLayerEventInit {
  Object get layer;
  set layer(Object value);
}

final class XRLayerEventInitValue implements XRLayerEventInit {
  @override
  Object layer;

  XRLayerEventInitValue({required this.layer});
}

abstract interface class XRLayerInit {
  XRSpace get space;
  set space(XRSpace value);
  GLenum? get colorFormat;
  set colorFormat(GLenum? value);
  GLenum? get depthFormat;
  set depthFormat(GLenum? value);
  int? get mipLevels;
  set mipLevels(int? value);
  int get viewPixelWidth;
  set viewPixelWidth(int value);
  int get viewPixelHeight;
  set viewPixelHeight(int value);
  XRLayerLayout? get layout;
  set layout(XRLayerLayout? value);
  bool? get isStatic;
  set isStatic(bool? value);
  bool? get clearOnAccess;
  set clearOnAccess(bool? value);
}

final class XRLayerInitValue implements XRLayerInit {
  @override
  XRSpace space;
  @override
  GLenum? colorFormat;
  @override
  GLenum? depthFormat;
  @override
  int? mipLevels;
  @override
  int viewPixelWidth;
  @override
  int viewPixelHeight;
  @override
  XRLayerLayout? layout;
  @override
  bool? isStatic;
  @override
  bool? clearOnAccess;

  XRLayerInitValue({
    required this.space,
    this.colorFormat,
    this.depthFormat,
    this.mipLevels,
    required this.viewPixelWidth,
    required this.viewPixelHeight,
    this.layout,
    this.isStatic,
    this.clearOnAccess,
  });
}

typedef XRLayerLayout = String;

typedef XRLayerQuality = String;

abstract interface class XRMediaCylinderLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get radius;
  set radius(double? value);
  double? get centralAngle;
  set centralAngle(double? value);
  double? get aspectRatio;
  set aspectRatio(double? value);
}

final class XRMediaCylinderLayerInitValue implements XRMediaCylinderLayerInit {
  @override
  XRRigidTransform? transform;
  @override
  double? radius;
  @override
  double? centralAngle;
  @override
  double? aspectRatio;

  XRMediaCylinderLayerInitValue({
    this.transform,
    this.radius,
    this.centralAngle,
    this.aspectRatio,
  });
}

abstract interface class XRMediaEquirectLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get radius;
  set radius(double? value);
  double? get centralHorizontalAngle;
  set centralHorizontalAngle(double? value);
  double? get upperVerticalAngle;
  set upperVerticalAngle(double? value);
  double? get lowerVerticalAngle;
  set lowerVerticalAngle(double? value);
}

final class XRMediaEquirectLayerInitValue implements XRMediaEquirectLayerInit {
  @override
  XRRigidTransform? transform;
  @override
  double? radius;
  @override
  double? centralHorizontalAngle;
  @override
  double? upperVerticalAngle;
  @override
  double? lowerVerticalAngle;

  XRMediaEquirectLayerInitValue({
    this.transform,
    this.radius,
    this.centralHorizontalAngle,
    this.upperVerticalAngle,
    this.lowerVerticalAngle,
  });
}

abstract interface class XRMediaLayerInit {
  XRSpace get space;
  set space(XRSpace value);
  XRLayerLayout? get layout;
  set layout(XRLayerLayout? value);
  bool? get invertStereo;
  set invertStereo(bool? value);
}

final class XRMediaLayerInitValue implements XRMediaLayerInit {
  @override
  XRSpace space;
  @override
  XRLayerLayout? layout;
  @override
  bool? invertStereo;

  XRMediaLayerInitValue({required this.space, this.layout, this.invertStereo});
}

abstract interface class XRMediaQuadLayerInit {
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get width;
  set width(double? value);
  double? get height;
  set height(double? value);
}

final class XRMediaQuadLayerInitValue implements XRMediaQuadLayerInit {
  @override
  XRRigidTransform? transform;
  @override
  double? width;
  @override
  double? height;

  XRMediaQuadLayerInitValue({this.transform, this.width, this.height});
}

abstract interface class XRProjectionLayerInit {
  XRTextureType? get textureType;
  set textureType(XRTextureType? value);
  GLenum? get colorFormat;
  set colorFormat(GLenum? value);
  GLenum? get depthFormat;
  set depthFormat(GLenum? value);
  double? get scaleFactor;
  set scaleFactor(double? value);
  bool? get clearOnAccess;
  set clearOnAccess(bool? value);
}

final class XRProjectionLayerInitValue implements XRProjectionLayerInit {
  @override
  XRTextureType? textureType;
  @override
  GLenum? colorFormat;
  @override
  GLenum? depthFormat;
  @override
  double? scaleFactor;
  @override
  bool? clearOnAccess;

  XRProjectionLayerInitValue({
    this.textureType,
    this.colorFormat,
    this.depthFormat,
    this.scaleFactor,
    this.clearOnAccess,
  });
}

abstract interface class XRQuadLayerInit {
  XRTextureType? get textureType;
  set textureType(XRTextureType? value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
  double? get width;
  set width(double? value);
  double? get height;
  set height(double? value);
}

final class XRQuadLayerInitValue implements XRQuadLayerInit {
  @override
  XRTextureType? textureType;
  @override
  XRRigidTransform? transform;
  @override
  double? width;
  @override
  double? height;

  XRQuadLayerInitValue({
    this.textureType,
    this.transform,
    this.width,
    this.height,
  });
}

typedef XRTextureType = String;
