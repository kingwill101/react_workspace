// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-depth-sensing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr_dom_overlays.dart';

typedef XRDepthDataFormat = String;

abstract interface class XRDepthStateInit {
  List<XRDepthUsage> get usagePreference;
  set usagePreference(List<XRDepthUsage> value);
  List<XRDepthDataFormat> get dataFormatPreference;
  set dataFormatPreference(List<XRDepthDataFormat> value);
}

typedef XRDepthUsage = String;

abstract interface class XRSessionInit {
  XRDepthStateInit get depthSensing;
  set depthSensing(XRDepthStateInit value);
  XRDOMOverlayInit? get domOverlay;
  set domOverlay(XRDOMOverlayInit? value);
  List<String> get requiredFeatures;
  set requiredFeatures(List<String> value);
  List<String> get optionalFeatures;
  set optionalFeatures(List<String> value);
}

