// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'hr_time.dart';
import 'anchors.dart';
import 'webxr_gamepads_module.dart';
import 'dom.dart';
import 'permissions.dart';
import 'html.dart';
import 'webxr_depth_sensing.dart';
import 'raw_camera_access.dart';
import 'webgl1.dart';

abstract interface class XRBoundedReferenceSpace {
  List<DOMPointReadOnly> get boundsGeometry;
}

typedef XREye = String;

typedef XRFrameRequestCallback = void Function(DOMHighResTimeStamp time, XRFrame frame,);

typedef XRHandedness = String;

abstract interface class XRInputSourceArray {
   Iterable<XRInputSource> get values;
  int get length;
}

abstract interface class XRInputSourceEvent {
  XRFrame get frame;
  XRInputSource get inputSource;
}

abstract interface class XRInputSourceEventInit {
  XRFrame get frame;
  set frame(XRFrame value);
  XRInputSource get inputSource;
  set inputSource(XRInputSource value);
}

abstract interface class XRInputSourcesChangeEvent {
  XRSession get session;
  List<XRInputSource> get added;
  List<XRInputSource> get removed;
}

abstract interface class XRInputSourcesChangeEventInit {
  XRSession get session;
  set session(XRSession value);
  List<XRInputSource> get added;
  set added(List<XRInputSource> value);
  List<XRInputSource> get removed;
  set removed(List<XRInputSource> value);
}

abstract interface class XRLayer {
}

abstract interface class XRPermissionDescriptor {
  XRSessionMode get mode;
  set mode(XRSessionMode value);
  List<String> get requiredFeatures;
  set requiredFeatures(List<String> value);
  List<String> get optionalFeatures;
  set optionalFeatures(List<String> value);
}

abstract interface class XRPermissionStatus {
  List<String> get granted;
   set granted(List<String> value);
}

abstract interface class XRPose {
  XRRigidTransform get transform;
  DOMPointReadOnly? get linearVelocity;
  DOMPointReadOnly? get angularVelocity;
  bool get emulatedPosition;
}

abstract interface class XRReferenceSpace {
  XRReferenceSpace getOffsetReferenceSpace(XRRigidTransform originOffset);
  EventHandler get onreset;
   set onreset(EventHandler value);
}

abstract interface class XRReferenceSpaceEvent {
  XRReferenceSpace get referenceSpace;
  XRRigidTransform? get transform;
}

abstract interface class XRReferenceSpaceEventInit {
  XRReferenceSpace get referenceSpace;
  set referenceSpace(XRReferenceSpace value);
  XRRigidTransform? get transform;
  set transform(XRRigidTransform? value);
}

typedef XRReferenceSpaceType = String;

abstract interface class XRRenderState {
  double get depthNear;
  double get depthFar;
  double? get inlineVerticalFieldOfView;
  XRWebGLLayer? get baseLayer;
  List<XRLayer> get layers;
}

abstract interface class XRRenderStateInit {
  double get depthNear;
  set depthNear(double value);
  double get depthFar;
  set depthFar(double value);
  double get inlineVerticalFieldOfView;
  set inlineVerticalFieldOfView(double value);
  XRWebGLLayer? get baseLayer;
  set baseLayer(XRWebGLLayer? value);
  List<XRLayer>? get layers;
  set layers(List<XRLayer>? value);
}

abstract interface class XRRigidTransform {
  DOMPointReadOnly get position;
  DOMPointReadOnly get orientation;
  Object get matrix;
  XRRigidTransform get inverse;
}

abstract interface class XRSessionEvent {
  XRSession get session;
}

abstract interface class XRSessionEventInit {
  XRSession get session;
  set session(XRSession value);
}

typedef XRSessionMode = String;

abstract interface class XRSessionSupportedPermissionDescriptor {
  XRSessionMode get mode;
  set mode(XRSessionMode value);
}

abstract interface class XRSpace {
}

abstract interface class XRSystem {
  Future<bool> isSessionSupported(XRSessionMode mode);
  Future<XRSession> requestSession(XRSessionMode mode, [XRSessionInit? options]);
  EventHandler get ondevicechange;
   set ondevicechange(EventHandler value);
}

typedef XRTargetRayMode = String;

abstract interface class XRViewerPose {
  List<XRView> get views;
}

abstract interface class XRViewport {
  int get x;
  int get y;
  int get width;
  int get height;
}

typedef XRVisibilityState = String;

abstract interface class XRWebGLLayer {
  bool get antialias;
  bool get ignoreDepthValues;
  double? get fixedFoveation;
   set fixedFoveation(double? value);
  WebGLFramebuffer? get framebuffer;
  int get framebufferWidth;
  int get framebufferHeight;
  XRViewport? getViewport(XRView view);
}

abstract interface class XRWebGLLayerInit {
  bool get antialias;
  set antialias(bool value);
  bool get depth;
  set depth(bool value);
  bool get stencil;
  set stencil(bool value);
  bool get alpha;
  set alpha(bool value);
  bool get ignoreDepthValues;
  set ignoreDepthValues(bool value);
  double get framebufferScaleFactor;
  set framebufferScaleFactor(double value);
}

typedef XRWebGLRenderingContext = Object;

