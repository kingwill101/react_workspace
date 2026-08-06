// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-lighting-estimation
// ignore_for_file: type=lint


abstract interface class XRLightProbeInit {
  XRReflectionFormat? get reflectionFormat;
  set reflectionFormat(XRReflectionFormat? value);
}

final class XRLightProbeInitValue implements XRLightProbeInit {
  @override
  XRReflectionFormat? reflectionFormat;

  XRLightProbeInitValue({
    this.reflectionFormat,
  });
}

typedef XRReflectionFormat = String;

