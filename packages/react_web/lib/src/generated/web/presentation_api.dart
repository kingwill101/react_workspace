// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: presentation-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'websockets.dart';
import 'fileapi.dart';
import 'webidl.dart';
import 'dom.dart';

abstract interface class Presentation {
  PresentationRequest? get defaultRequest;
   set defaultRequest(PresentationRequest? value);
  PresentationReceiver? get receiver;
}

abstract interface class PresentationAvailability {
  bool get value;
  EventHandler get onchange;
   set onchange(EventHandler value);
}

abstract interface class PresentationConnection {
  String get id;
  String get url;
  PresentationConnectionState get state;
  void close();
  void terminate();
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  EventHandler get onterminate;
   set onterminate(EventHandler value);
  BinaryType get binaryType;
   set binaryType(BinaryType value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  void send(String message);
}

abstract interface class PresentationConnectionAvailableEvent {
  PresentationConnection get connection;
}

abstract interface class PresentationConnectionAvailableEventInit {
  PresentationConnection get connection;
  set connection(PresentationConnection value);
}

abstract interface class PresentationConnectionCloseEvent {
  PresentationConnectionCloseReason get reason;
  String get message;
}

abstract interface class PresentationConnectionCloseEventInit {
  PresentationConnectionCloseReason get reason;
  set reason(PresentationConnectionCloseReason value);
  String get message;
  set message(String value);
}

typedef PresentationConnectionCloseReason = String;

abstract interface class PresentationConnectionList {
  List<PresentationConnection> get connections;
  EventHandler get onconnectionavailable;
   set onconnectionavailable(EventHandler value);
}

typedef PresentationConnectionState = String;

abstract interface class PresentationReceiver {
  Future<PresentationConnectionList> get connectionList;
}

abstract interface class PresentationRequest {
  Future<PresentationConnection> start();
  Future<PresentationConnection> reconnect(String presentationId);
  Future<PresentationAvailability> getAvailability();
  EventHandler get onconnectionavailable;
   set onconnectionavailable(EventHandler value);
}

