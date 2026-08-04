// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gamepad
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'gamepad_extensions.dart';
import 'dom.dart';
import 'geometry.dart';
import 'html.dart';

abstract interface class GamepadButton {
  bool get pressed;
  bool get touched;
  double get value;
}

abstract interface class GamepadEffectParameters {
  int get duration;
  set duration(int value);
  int get startDelay;
  set startDelay(int value);
  double get strongMagnitude;
  set strongMagnitude(double value);
  double get weakMagnitude;
  set weakMagnitude(double value);
  double get leftTrigger;
  set leftTrigger(double value);
  double get rightTrigger;
  set rightTrigger(double value);
}

abstract interface class GamepadEvent {
  Gamepad get gamepad;
}

abstract interface class GamepadEventInit {
  Gamepad get gamepad;
  set gamepad(Gamepad value);
}

typedef GamepadHapticEffectType = String;

typedef GamepadHapticsResult = String;

typedef GamepadMappingType = String;

abstract interface class GamepadTouch {
  int get touchId;
  set touchId(int value);
  Object get surfaceId;
  set surfaceId(Object value);
  DOMPointReadOnly get position;
  set position(DOMPointReadOnly value);
  DOMRectReadOnly? get surfaceDimensions;
  set surfaceDimensions(DOMRectReadOnly? value);
}

abstract interface class WindowEventHandlers {
  EventHandler get ongamepadconnected;
   set ongamepadconnected(EventHandler value);
  EventHandler get ongamepaddisconnected;
   set ongamepaddisconnected(EventHandler value);
  EventHandler get onafterprint;
   set onafterprint(EventHandler value);
  EventHandler get onbeforeprint;
   set onbeforeprint(EventHandler value);
  OnBeforeUnloadEventHandler get onbeforeunload;
   set onbeforeunload(OnBeforeUnloadEventHandler value);
  EventHandler get onhashchange;
   set onhashchange(EventHandler value);
  EventHandler get onlanguagechange;
   set onlanguagechange(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
  EventHandler get onoffline;
   set onoffline(EventHandler value);
  EventHandler get ononline;
   set ononline(EventHandler value);
  EventHandler get onpagehide;
   set onpagehide(EventHandler value);
  EventHandler get onpagereveal;
   set onpagereveal(EventHandler value);
  EventHandler get onpageshow;
   set onpageshow(EventHandler value);
  EventHandler get onpageswap;
   set onpageswap(EventHandler value);
  EventHandler get onpopstate;
   set onpopstate(EventHandler value);
  EventHandler get onrejectionhandled;
   set onrejectionhandled(EventHandler value);
  EventHandler get onstorage;
   set onstorage(EventHandler value);
  EventHandler get onunhandledrejection;
   set onunhandledrejection(EventHandler value);
  EventHandler get onunload;
   set onunload(EventHandler value);
  EventHandler get onportalactivate;
   set onportalactivate(EventHandler value);
}

