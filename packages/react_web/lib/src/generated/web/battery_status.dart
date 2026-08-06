// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: battery-status
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';

abstract interface class BatteryManager {
  bool get charging;
  double get chargingTime;
  double get dischargingTime;
  double get level;
  EventHandler get onchargingchange;
   set onchargingchange(EventHandler value);
  EventHandler get onchargingtimechange;
   set onchargingtimechange(EventHandler value);
  EventHandler get ondischargingtimechange;
   set ondischargingtimechange(EventHandler value);
  EventHandler get onlevelchange;
   set onlevelchange(EventHandler value);
}

