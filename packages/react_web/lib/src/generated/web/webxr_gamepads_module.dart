// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-gamepads-module
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'gamepad_extensions.dart';
import 'webxr_hand_input.dart';
import 'webxr.dart';

abstract interface class XRInputSource {
  Gamepad? get gamepad;
  XRHand? get hand;
  XRHandedness get handedness;
  XRTargetRayMode get targetRayMode;
  XRSpace get targetRaySpace;
  XRSpace? get gripSpace;
  List<String> get profiles;
}

