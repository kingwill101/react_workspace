// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webxr-hand-input
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class XRHand {
}

typedef XRHandJoint = String;

abstract interface class XRJointPose {
  double get radius;
}

abstract interface class XRJointSpace {
  XRHandJoint get jointName;
}

