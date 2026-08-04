// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: uievents
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'input_device_capabilities.dart';
import 'dom.dart';
import 'anonymous_iframe.dart';
import 'pointerlock.dart';

abstract interface class CompositionEvent {
  String get data;
  void initCompositionEvent(String typeArg, [bool? bubblesArg, bool? cancelableArg, Object? viewArg, String? dataArg]);
}

abstract interface class CompositionEventInit {
  String get data;
  set data(String value);
}

abstract interface class EventModifierInit {
  bool get ctrlKey;
  set ctrlKey(bool value);
  bool get shiftKey;
  set shiftKey(bool value);
  bool get altKey;
  set altKey(bool value);
  bool get metaKey;
  set metaKey(bool value);
  bool get modifierAltGraph;
  set modifierAltGraph(bool value);
  bool get modifierCapsLock;
  set modifierCapsLock(bool value);
  bool get modifierFn;
  set modifierFn(bool value);
  bool get modifierFnLock;
  set modifierFnLock(bool value);
  bool get modifierHyper;
  set modifierHyper(bool value);
  bool get modifierNumLock;
  set modifierNumLock(bool value);
  bool get modifierScrollLock;
  set modifierScrollLock(bool value);
  bool get modifierSuper;
  set modifierSuper(bool value);
  bool get modifierSymbol;
  set modifierSymbol(bool value);
  bool get modifierSymbolLock;
  set modifierSymbolLock(bool value);
}

abstract interface class FocusEvent {
  EventTarget? get relatedTarget;
}

abstract interface class FocusEventInit {
  EventTarget? get relatedTarget;
  set relatedTarget(EventTarget? value);
}

abstract interface class KeyboardEvent {
   static const int DOM_KEY_LOCATION_STANDARD =
      0x00;
   static const int DOM_KEY_LOCATION_LEFT =
      0x01;
   static const int DOM_KEY_LOCATION_RIGHT =
      0x02;
   static const int DOM_KEY_LOCATION_NUMPAD =
      0x03;
  String get key;
  String get code;
  int get location;
  bool get ctrlKey;
  bool get shiftKey;
  bool get altKey;
  bool get metaKey;
  bool get repeat;
  bool get isComposing;
  bool getModifierState(String keyArg);
  void initKeyboardEvent(String typeArg, [bool? bubblesArg, bool? cancelableArg, Window? viewArg, String? keyArg, int? locationArg, bool? ctrlKey, bool? altKey, bool? shiftKey, bool? metaKey]);
  int get charCode;
  int get keyCode;
}

abstract interface class KeyboardEventInit {
  String get key;
  set key(String value);
  String get code;
  set code(String value);
  int get location;
  set location(int value);
  bool get repeat;
  set repeat(bool value);
  bool get isComposing;
  set isComposing(bool value);
  int get charCode;
  set charCode(int value);
  int get keyCode;
  set keyCode(int value);
}

abstract interface class TextEvent {
  String get data;
  void initTextEvent(String type, [bool? bubbles, bool? cancelable, Window? view, String? data]);
}

abstract interface class WheelEvent {
   static const int DOM_DELTA_PIXEL =
      0x00;
   static const int DOM_DELTA_LINE =
      0x01;
   static const int DOM_DELTA_PAGE =
      0x02;
  double get deltaX;
  double get deltaY;
  double get deltaZ;
  int get deltaMode;
}

abstract interface class WheelEventInit {
  double get deltaX;
  set deltaX(double value);
  double get deltaY;
  set deltaY(double value);
  double get deltaZ;
  set deltaZ(double value);
  int get deltaMode;
  set deltaMode(int value);
}

