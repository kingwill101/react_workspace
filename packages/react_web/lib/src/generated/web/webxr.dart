// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'webxr_gamepads_module.dart';
import 'dom.dart';
import 'permissions.dart';
import 'geometry.dart';
import 'html.dart';
import 'webgl1.dart';
import 'webgl2.dart';
import 'package:react_web/src/web_runtime.dart';

typedef XREye = String;

typedef XRFrameRequestCallback = void Function(DOMHighResTimeStamp time, Object frame,);

typedef XRHandedness = String;

abstract interface class XRInputSourceEvent {
  factory XRInputSourceEvent(String type, XRInputSourceEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<XRInputSourceEvent>(
        'XRInputSourceEvent',
        [type, eventInitDict],
      );
  Object get frame;
  XRInputSource get inputSource;
}

abstract interface class XRInputSourceEventInit {
  Object get frame;
  set frame(Object value);
  XRInputSource get inputSource;
  set inputSource(XRInputSource value);
}

abstract interface class XRInputSourcesChangeEvent {
  factory XRInputSourcesChangeEvent(String type, XRInputSourcesChangeEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<XRInputSourcesChangeEvent>(
        'XRInputSourcesChangeEvent',
        [type, eventInitDict],
      );
  Object get session;
  List<XRInputSource> get added;
  List<XRInputSource> get removed;
}

abstract interface class XRInputSourcesChangeEventInit {
  Object get session;
  set session(Object value);
  List<XRInputSource> get added;
  set added(List<XRInputSource> value);
  List<XRInputSource> get removed;
  set removed(List<XRInputSource> value);
}

abstract interface class XRPermissionDescriptor {
  XRSessionMode get mode;
  set mode(XRSessionMode value);
  List<String> get requiredFeatures;
  set requiredFeatures(List<String> value);
  List<String> get optionalFeatures;
  set optionalFeatures(List<String> value);
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
  factory XRReferenceSpaceEvent(String type, XRReferenceSpaceEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<XRReferenceSpaceEvent>(
        'XRReferenceSpaceEvent',
        [type, eventInitDict],
      );
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

abstract interface class XRRenderStateInit {
  double get depthNear;
  set depthNear(double value);
  double get depthFar;
  set depthFar(double value);
  double get inlineVerticalFieldOfView;
  set inlineVerticalFieldOfView(double value);
  Object get baseLayer;
  set baseLayer(Object value);
  List<Object> get layers;
  set layers(List<Object> value);
}

abstract interface class XRRigidTransform {
  factory XRRigidTransform([DOMPointInit? position, DOMPointInit? orientation]) =>
      WebRuntime.current.createWebObject<XRRigidTransform>(
        'XRRigidTransform',
        [position, orientation],
      );
  DOMPointReadOnly get position;
  DOMPointReadOnly get orientation;
  Object get matrix;
  XRRigidTransform get inverse;
}

abstract interface class XRSessionEvent {
  factory XRSessionEvent(String type, XRSessionEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<XRSessionEvent>(
        'XRSessionEvent',
        [type, eventInitDict],
      );
  Object get session;
}

abstract interface class XRSessionEventInit {
  Object get session;
  set session(Object value);
}

typedef XRSessionMode = String;

abstract interface class XRSessionSupportedPermissionDescriptor {
  XRSessionMode get mode;
  set mode(XRSessionMode value);
}

abstract interface class XRSpace {
}

typedef XRTargetRayMode = String;

abstract interface class XRViewerPose {
  List<Object> get views;
}

abstract interface class XRViewport {
  int get x;
  int get y;
  int get width;
  int get height;
}

typedef XRVisibilityState = String;

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

