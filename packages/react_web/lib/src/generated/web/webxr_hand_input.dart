// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-hand-input
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class XRHand {
   Iterable<(XRHandJoint, XRJointSpace)> get entries;
   Iterable<XRHandJoint> get keys;
   Iterable<XRJointSpace> get values;
  int get size;
  XRJointSpace get_(XRHandJoint key);
}

typedef XRHandJoint = String;

abstract interface class XRJointPose {
  double get radius;
}

abstract interface class XRJointSpace {
  XRHandJoint get jointName;
}

