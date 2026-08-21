// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gamepad-extensions
// ignore_for_file: type=lint

import 'gamepad.dart';
import 'hr_time.dart';

abstract interface class Gamepad {
  String get id;
  int get index;
  bool get connected;
  DOMHighResTimeStamp get timestamp;
  GamepadMappingType get mapping;
  List<double> get axes;
  List<GamepadButton> get buttons;
}

typedef GamepadHand = String;

abstract interface class GamepadHapticActuator {
  Future<bool> pulse(double value, double duration);
  Future<GamepadHapticsResult> playEffect(
    GamepadHapticEffectType type_, [
    GamepadEffectParameters? params,
  ]);
  Future<GamepadHapticsResult> reset();
}
