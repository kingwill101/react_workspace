// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gamepad
// ignore_for_file: type=lint

import 'gamepad_extensions.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class GamepadButton {
  bool get pressed;
  bool get touched;
  double get value;
}

abstract interface class GamepadEffectParameters {
  int? get duration;
  set duration(int? value);
  int? get startDelay;
  set startDelay(int? value);
  double? get strongMagnitude;
  set strongMagnitude(double? value);
  double? get weakMagnitude;
  set weakMagnitude(double? value);
  double? get leftTrigger;
  set leftTrigger(double? value);
  double? get rightTrigger;
  set rightTrigger(double? value);
}

final class GamepadEffectParametersValue implements GamepadEffectParameters {
  @override
  int? duration;
  @override
  int? startDelay;
  @override
  double? strongMagnitude;
  @override
  double? weakMagnitude;
  @override
  double? leftTrigger;
  @override
  double? rightTrigger;

  GamepadEffectParametersValue({
    this.duration,
    this.startDelay,
    this.strongMagnitude,
    this.weakMagnitude,
    this.leftTrigger,
    this.rightTrigger,
  });
}

abstract interface class GamepadEvent {
  factory GamepadEvent(String type_, GamepadEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<GamepadEvent>('GamepadEvent', [
        type_,
        eventInitDict,
      ]);
  Gamepad get gamepad;
}

abstract interface class GamepadEventInit {
  Gamepad get gamepad;
  set gamepad(Gamepad value);
}

final class GamepadEventInitValue implements GamepadEventInit {
  @override
  Gamepad gamepad;

  GamepadEventInitValue({required this.gamepad});
}

typedef GamepadHapticEffectType = String;

typedef GamepadHapticsResult = String;

typedef GamepadMappingType = String;

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
