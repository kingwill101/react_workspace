// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: anchors
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'real_world_meshing.dart';
import 'webxr_depth_sensing.dart';
import 'raw_camera_access.dart';
import 'webxr_hand_input.dart';
import 'webxr_hit_test.dart';
import 'webxr_lighting_estimation.dart';
import 'webxr_plane_detection.dart';
import 'hr_time.dart';
import 'webxr_ar_module.dart';
import 'webxr_dom_overlays.dart';
import 'html.dart';

abstract interface class XRAnchor {
  XRSpace get anchorSpace;
  Future<String> requestPersistentHandle();
  void delete();
}

abstract interface class XRAnchorSet {
   Iterable<XRAnchor> get values;
   bool has(Object value);
}

abstract interface class XRFrame {
  Future<XRAnchor> createAnchor(XRRigidTransform pose, XRSpace space);
  XRAnchorSet get trackedAnchors;
  XRMeshSet get detectedMeshes;
  XRCPUDepthInformation? getDepthInformation(XRView view);
  XRJointPose? getJointPose(XRJointSpace joint, XRSpace baseSpace);
  bool fillJointRadii(List<XRJointSpace> jointSpaces, Object radii);
  bool fillPoses(List<XRSpace> spaces, XRSpace baseSpace, Object transforms);
  List<XRHitTestResult> getHitTestResults(XRHitTestSource hitTestSource);
  List<XRTransientInputHitTestResult> getHitTestResultsForTransientInput(XRTransientInputHitTestSource hitTestSource);
  XRLightEstimate? getLightEstimate(XRLightProbe lightProbe);
  XRPlaneSet get detectedPlanes;
  XRSession get session;
  DOMHighResTimeStamp get predictedDisplayTime;
  XRViewerPose? getViewerPose(XRReferenceSpace referenceSpace);
  XRPose? getPose(XRSpace space, XRSpace baseSpace);
}

abstract interface class XRHitTestResult {
  Future<XRAnchor> createAnchor();
  XRPose? getPose(XRSpace baseSpace);
}

abstract interface class XRSession {
  List<String> get persistentAnchors;
  Future<XRAnchor> restorePersistentAnchor(String uuid);
  Future<void> deletePersistentAnchor(String uuid);
  XREnvironmentBlendMode get environmentBlendMode;
  XRInteractionMode get interactionMode;
  XRDepthUsage get depthUsage;
  XRDepthDataFormat get depthDataFormat;
  XRDOMOverlayState? get domOverlayState;
  Future<XRHitTestSource> requestHitTestSource(XRHitTestOptionsInit options);
  Future<XRTransientInputHitTestSource> requestHitTestSourceForTransientInput(XRTransientInputHitTestOptionsInit options);
  Future<XRLightProbe> requestLightProbe([XRLightProbeInit? options]);
  XRReflectionFormat get preferredReflectionFormat;
  Future<void> initiateRoomCapture();
  XRVisibilityState get visibilityState;
  double? get frameRate;
  Object get supportedFrameRates;
  XRRenderState get renderState;
  XRInputSourceArray get inputSources;
  XRInputSourceArray get trackedSources;
  List<String> get enabledFeatures;
  bool get isSystemKeyboardSupported;
  void updateRenderState([XRRenderStateInit? state]);
  Future<void> updateTargetFrameRate(double rate);
  Future<XRReferenceSpace> requestReferenceSpace(XRReferenceSpaceType type);
  int requestAnimationFrame(XRFrameRequestCallback callback);
  void cancelAnimationFrame(int handle);
  Future<void> end();
  EventHandler get onend;
   set onend(EventHandler value);
  EventHandler get oninputsourceschange;
   set oninputsourceschange(EventHandler value);
  EventHandler get onselect;
   set onselect(EventHandler value);
  EventHandler get onselectstart;
   set onselectstart(EventHandler value);
  EventHandler get onselectend;
   set onselectend(EventHandler value);
  EventHandler get onsqueeze;
   set onsqueeze(EventHandler value);
  EventHandler get onsqueezestart;
   set onsqueezestart(EventHandler value);
  EventHandler get onsqueezeend;
   set onsqueezeend(EventHandler value);
  EventHandler get onvisibilitychange;
   set onvisibilitychange(EventHandler value);
  EventHandler get onframeratechange;
   set onframeratechange(EventHandler value);
}

