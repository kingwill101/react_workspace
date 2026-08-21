// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr
// ignore_for_file: type=lint

import 'geometry.dart';
import 'hr_time.dart';
import 'html.dart';
import 'webxr_gamepads_module.dart';
import 'package:react_web/src/web_runtime.dart';

typedef XREye = String;

typedef XRFrameRequestCallback =
    void Function(DOMHighResTimeStamp time, Object frame);

typedef XRHandedness = String;

abstract interface class XRInputSourceEvent {
  factory XRInputSourceEvent(
    String type_,
    XRInputSourceEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<XRInputSourceEvent>(
    'XRInputSourceEvent',
    [type_, eventInitDict],
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

final class XRInputSourceEventInitValue implements XRInputSourceEventInit {
  @override
  Object frame;
  @override
  XRInputSource inputSource;

  XRInputSourceEventInitValue({required this.frame, required this.inputSource});
}

abstract interface class XRInputSourcesChangeEvent {
  factory XRInputSourcesChangeEvent(
    String type_,
    XRInputSourcesChangeEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<XRInputSourcesChangeEvent>(
    'XRInputSourcesChangeEvent',
    [type_, eventInitDict],
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

final class XRInputSourcesChangeEventInitValue
    implements XRInputSourcesChangeEventInit {
  @override
  Object session;
  @override
  List<XRInputSource> added;
  @override
  List<XRInputSource> removed;

  XRInputSourcesChangeEventInitValue({
    required this.session,
    required this.added,
    required this.removed,
  });
}

abstract interface class XRPermissionDescriptor {
  XRSessionMode? get mode;
  set mode(XRSessionMode? value);
  List<String>? get requiredFeatures;
  set requiredFeatures(List<String>? value);
  List<String>? get optionalFeatures;
  set optionalFeatures(List<String>? value);
}

final class XRPermissionDescriptorValue implements XRPermissionDescriptor {
  @override
  XRSessionMode? mode;
  @override
  List<String>? requiredFeatures;
  @override
  List<String>? optionalFeatures;

  XRPermissionDescriptorValue({
    this.mode,
    this.requiredFeatures,
    this.optionalFeatures,
  });
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
  factory XRReferenceSpaceEvent(
    String type_,
    XRReferenceSpaceEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<XRReferenceSpaceEvent>(
    'XRReferenceSpaceEvent',
    [type_, eventInitDict],
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

final class XRReferenceSpaceEventInitValue
    implements XRReferenceSpaceEventInit {
  @override
  XRReferenceSpace referenceSpace;
  @override
  XRRigidTransform? transform;

  XRReferenceSpaceEventInitValue({
    required this.referenceSpace,
    this.transform,
  });
}

typedef XRReferenceSpaceType = String;

abstract interface class XRRenderStateInit {
  double? get depthNear;
  set depthNear(double? value);
  double? get depthFar;
  set depthFar(double? value);
  double? get inlineVerticalFieldOfView;
  set inlineVerticalFieldOfView(double? value);
  Object? get baseLayer;
  set baseLayer(Object? value);
  List<Object>? get layers;
  set layers(List<Object>? value);
}

final class XRRenderStateInitValue implements XRRenderStateInit {
  @override
  double? depthNear;
  @override
  double? depthFar;
  @override
  double? inlineVerticalFieldOfView;
  @override
  Object? baseLayer;
  @override
  List<Object>? layers;

  XRRenderStateInitValue({
    this.depthNear,
    this.depthFar,
    this.inlineVerticalFieldOfView,
    this.baseLayer,
    this.layers,
  });
}

abstract interface class XRRigidTransform {
  factory XRRigidTransform([
    DOMPointInit? position,
    DOMPointInit? orientation,
  ]) => WebRuntime.current.createWebObject<XRRigidTransform>(
    'XRRigidTransform',
    [position, orientation],
  );
  DOMPointReadOnly get position;
  DOMPointReadOnly get orientation;
  Object get matrix;
  XRRigidTransform get inverse;
}

abstract interface class XRSessionEvent {
  factory XRSessionEvent(String type_, XRSessionEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<XRSessionEvent>('XRSessionEvent', [
        type_,
        eventInitDict,
      ]);
  Object get session;
}

abstract interface class XRSessionEventInit {
  Object get session;
  set session(Object value);
}

final class XRSessionEventInitValue implements XRSessionEventInit {
  @override
  Object session;

  XRSessionEventInitValue({required this.session});
}

typedef XRSessionMode = String;

abstract interface class XRSessionSupportedPermissionDescriptor {
  XRSessionMode? get mode;
  set mode(XRSessionMode? value);
}

final class XRSessionSupportedPermissionDescriptorValue
    implements XRSessionSupportedPermissionDescriptor {
  @override
  XRSessionMode? mode;

  XRSessionSupportedPermissionDescriptorValue({this.mode});
}

abstract interface class XRSpace {}

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
  bool? get antialias;
  set antialias(bool? value);
  bool? get depth;
  set depth(bool? value);
  bool? get stencil;
  set stencil(bool? value);
  bool? get alpha;
  set alpha(bool? value);
  bool? get ignoreDepthValues;
  set ignoreDepthValues(bool? value);
  double? get framebufferScaleFactor;
  set framebufferScaleFactor(double? value);
}

final class XRWebGLLayerInitValue implements XRWebGLLayerInit {
  @override
  bool? antialias;
  @override
  bool? depth;
  @override
  bool? stencil;
  @override
  bool? alpha;
  @override
  bool? ignoreDepthValues;
  @override
  double? framebufferScaleFactor;

  XRWebGLLayerInitValue({
    this.antialias,
    this.depth,
    this.stencil,
    this.alpha,
    this.ignoreDepthValues,
    this.framebufferScaleFactor,
  });
}

typedef XRWebGLRenderingContext = Object;
