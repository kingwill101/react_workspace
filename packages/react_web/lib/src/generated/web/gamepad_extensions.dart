// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: gamepad-extensions
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';
import 'gamepad.dart';

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
  Future<GamepadHapticsResult> playEffect(GamepadHapticEffectType type, [GamepadEffectParameters? params]);
  Future<GamepadHapticsResult> reset();
}

