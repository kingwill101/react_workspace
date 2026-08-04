// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: input-device-capabilities
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'anonymous_iframe.dart';
import 'dom.dart';

abstract interface class InputDeviceCapabilities {
  bool get firesTouchEvents;
  bool get pointerMovementScrolls;
}

abstract interface class InputDeviceCapabilitiesInit {
  bool get firesTouchEvents;
  set firesTouchEvents(bool value);
  bool get pointerMovementScrolls;
  set pointerMovementScrolls(bool value);
}

abstract interface class UIEvent {
  InputDeviceCapabilities? get sourceCapabilities;
  Window? get view;
  int get detail;
  void initUIEvent(String typeArg, [bool? bubblesArg, bool? cancelableArg, Window? viewArg, int? detailArg]);
  int get which;
}

abstract interface class UIEventInit {
  InputDeviceCapabilities? get sourceCapabilities;
  set sourceCapabilities(InputDeviceCapabilities? value);
  Window? get view;
  set view(Window? value);
  int get detail;
  set detail(int value);
  int get which;
  set which(int value);
}

