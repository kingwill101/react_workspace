// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: websockets
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'html.dart';
import 'webidl.dart';
import 'fileapi.dart';

typedef BinaryType = String;

abstract interface class CloseEvent {
  bool get wasClean;
  int get code;
  String get reason;
}

abstract interface class CloseEventInit {
  bool get wasClean;
  set wasClean(bool value);
  int get code;
  set code(int value);
  String get reason;
  set reason(String value);
}

abstract interface class WebSocket {
  String get url;
   static const int CONNECTING =
      0;
   static const int OPEN =
      1;
   static const int CLOSING =
      2;
   static const int CLOSED =
      3;
  int get readyState;
  int get bufferedAmount;
  EventHandler get onopen;
   set onopen(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  String get extensions;
  String get protocol;
  void close([int? code, String? reason]);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  BinaryType get binaryType;
   set binaryType(BinaryType value);
  void send(Object data);
}

