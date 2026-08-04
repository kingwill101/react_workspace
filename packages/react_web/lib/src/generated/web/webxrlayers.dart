// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxrlayers
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'geometry.dart';
import 'html.dart';
import 'dom.dart';
import 'webgl1.dart';
import 'anchors.dart';

abstract interface class XRCompositionLayer {
  XRLayerLayout get layout;
  bool get blendTextureSourceAlpha;
   set blendTextureSourceAlpha(bool value);
  bool get forceMonoPresentation;
   set forceMonoPresentation(bool value);
  double get opacity;
   set opacity(double value);
  int get mipLevels;
  XRLayerQuality get quality;
   set quality(XRLayerQuality value);
  bool get needsRedraw;
  void destroy();
}

abstract interface class XRCubeLayer {
  XRSpace get space;
   set space(XRSpace value);
  DOMPointReadOnly get orientation;
   set orientation(DOMPointReadOnly value);
  EventHandler get onredraw;
   set onredraw(EventHandler value);
}

abstract interface class XRCubeLayerInit {
  DOMPointReadOnly? get orientation;
  set orientation(DOMPointReadOnly? value);
}

abstract interface class XRCylinderLayer {
  XRSpace get space;
   set space(XRSpace value);
  XRRigidTransform get transform;
   set transform(XRRigidTransform value);
  double get radius;
   set radius(double value);
  double get centralAngle;
   set centralAngle(double value);
  double get aspectRatio;
   set aspectRatio(double value);
  EventHandler get onredraw;
   set onredraw(EventHandler value);
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

abstract interface class XREquirectLayer {
  XRSpace get space;
   set space(XRSpace value);
  XRRigidTransform get transform;
   set transform(XRRigidTransform value);
  double get radius;
   set radius(double value);
  double get centralHorizontalAngle;
   set centralHorizontalAngle(double value);
  double get upperVerticalAngle;
   set upperVerticalAngle(double value);
  double get lowerVerticalAngle;
   set lowerVerticalAngle(double value);
  EventHandler get onredraw;
   set onredraw(EventHandler value);
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

abstract interface class XRLayerEvent {
  XRLayer get layer;
}

abstract interface class XRLayerEventInit {
  XRLayer get layer;
  set layer(XRLayer value);
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

abstract interface class XRMediaBinding {
  XRQuadLayer createQuadLayer(HTMLVideoElement video, [XRMediaQuadLayerInit? init]);
  XRCylinderLayer createCylinderLayer(HTMLVideoElement video, [XRMediaCylinderLayerInit? init]);
  XREquirectLayer createEquirectLayer(HTMLVideoElement video, [XRMediaEquirectLayerInit? init]);
}

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

abstract interface class XRProjectionLayer {
  int get textureWidth;
  int get textureHeight;
  int get textureArrayLength;
  bool get ignoreDepthValues;
  double? get fixedFoveation;
   set fixedFoveation(double? value);
  XRRigidTransform? get deltaPose;
   set deltaPose(XRRigidTransform? value);
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

abstract interface class XRQuadLayer {
  XRSpace get space;
   set space(XRSpace value);
  XRRigidTransform get transform;
   set transform(XRRigidTransform value);
  double get width;
   set width(double value);
  double get height;
   set height(double value);
  EventHandler get onredraw;
   set onredraw(EventHandler value);
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

abstract interface class XRSubImage {
  XRViewport get viewport;
}

typedef XRTextureType = String;

abstract interface class XRWebGLSubImage {
  WebGLTexture get colorTexture;
  WebGLTexture? get depthStencilTexture;
  WebGLTexture? get motionVectorTexture;
  int? get imageIndex;
  int get colorTextureWidth;
  int get colorTextureHeight;
  int? get depthStencilTextureWidth;
  int? get depthStencilTextureHeight;
  int? get motionVectorTextureWidth;
  int? get motionVectorTextureHeight;
}

