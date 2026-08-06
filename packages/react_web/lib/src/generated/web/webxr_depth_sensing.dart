// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-depth-sensing
// ignore_for_file: type=lint

import 'webxr_dom_overlays.dart';

typedef XRDepthDataFormat = String;

abstract interface class XRDepthStateInit {
  List<XRDepthUsage> get usagePreference;
  set usagePreference(List<XRDepthUsage> value);
  List<XRDepthDataFormat> get dataFormatPreference;
  set dataFormatPreference(List<XRDepthDataFormat> value);
}

final class XRDepthStateInitValue implements XRDepthStateInit {
  @override
  List<XRDepthUsage> usagePreference;
  @override
  List<XRDepthDataFormat> dataFormatPreference;

  XRDepthStateInitValue({
    required this.usagePreference,
    required this.dataFormatPreference,
  });
}

typedef XRDepthUsage = String;

abstract interface class XRSessionInit {
  XRDepthStateInit? get depthSensing;
  set depthSensing(XRDepthStateInit? value);
  XRDOMOverlayInit? get domOverlay;
  set domOverlay(XRDOMOverlayInit? value);
  List<String>? get requiredFeatures;
  set requiredFeatures(List<String>? value);
  List<String>? get optionalFeatures;
  set optionalFeatures(List<String>? value);
}

final class XRSessionInitValue implements XRSessionInit {
  @override
  XRDepthStateInit? depthSensing;
  @override
  XRDOMOverlayInit? domOverlay;
  @override
  List<String>? requiredFeatures;
  @override
  List<String>? optionalFeatures;

  XRSessionInitValue({
    this.depthSensing,
    this.domOverlay,
    this.requiredFeatures,
    this.optionalFeatures,
  });
}

