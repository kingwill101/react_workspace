// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-lighting-estimation
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'webxr.dart';
import 'html.dart';

abstract interface class XRLightEstimate {
  Object get sphericalHarmonicsCoefficients;
  DOMPointReadOnly get primaryLightDirection;
  DOMPointReadOnly get primaryLightIntensity;
}

abstract interface class XRLightProbe {
  XRSpace get probeSpace;
  EventHandler get onreflectionchange;
   set onreflectionchange(EventHandler value);
}

abstract interface class XRLightProbeInit {
  XRReflectionFormat get reflectionFormat;
  set reflectionFormat(XRReflectionFormat value);
}

typedef XRReflectionFormat = String;

