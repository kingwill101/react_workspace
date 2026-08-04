// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: keyboard-lock
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'keyboard_map.dart';
import 'html.dart';

abstract interface class Keyboard {
  Future<void> lock([List<String>? keyCodes]);
  void unlock();
  Future<KeyboardLayoutMap> getLayoutMap();
  EventHandler get onlayoutchange;
   set onlayoutchange(EventHandler value);
}

