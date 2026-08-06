// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-hand-input
// ignore_for_file: type=lint


abstract interface class XRHand {
}

typedef XRHandJoint = String;

abstract interface class XRJointPose {
  double get radius;
}

abstract interface class XRJointSpace {
  XRHandJoint get jointName;
}

