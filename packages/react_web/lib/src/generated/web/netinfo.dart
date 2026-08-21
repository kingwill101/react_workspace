// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: netinfo
// ignore_for_file: type=lint

import 'html.dart';

typedef ConnectionType = String;

typedef EffectiveConnectionType = String;

typedef Megabit = double;

typedef Millisecond = int;

abstract interface class NavigatorNetworkInformation {
  NetworkInformation get connection;
}

abstract interface class NetworkInformation {
  bool get saveData;
  EffectiveConnectionType get effectiveType;
  Megabit get downlink;
  Millisecond get rtt;
  EventHandler get onchange;
  set onchange(EventHandler value);
}
