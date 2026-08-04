// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: raw-camera-access
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'webgl1.dart';
import 'webxr_depth_sensing.dart';
import 'webxr_lighting_estimation.dart';
import 'anchors.dart';
import 'webxrlayers.dart';

abstract interface class XRCamera {
  int get width;
  int get height;
}

abstract interface class XRView {
  XRCamera? get camera;
  bool get isFirstPersonObserver;
  XREye get eye;
  Object get projectionMatrix;
  XRRigidTransform get transform;
  double? get recommendedViewportScale;
  void requestViewportScale(double? scale);
}

abstract interface class XRWebGLBinding {
  WebGLTexture? getCameraImage(XRCamera camera);
  XRWebGLDepthInformation? getDepthInformation(XRView view);
  WebGLTexture? getReflectionCubeMap(XRLightProbe lightProbe);
  double get nativeProjectionScaleFactor;
  bool get usesDepthValues;
  XRProjectionLayer createProjectionLayer([XRProjectionLayerInit? init]);
  XRQuadLayer createQuadLayer([XRQuadLayerInit? init]);
  XRCylinderLayer createCylinderLayer([XRCylinderLayerInit? init]);
  XREquirectLayer createEquirectLayer([XREquirectLayerInit? init]);
  XRCubeLayer createCubeLayer([XRCubeLayerInit? init]);
  XRWebGLSubImage getSubImage(XRCompositionLayer layer, XRFrame frame, [XREye? eye]);
  XRWebGLSubImage getViewSubImage(XRProjectionLayer layer, XRView view);
}

