// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: presentation-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class PresentationConnectionAvailableEventInit {
  Object get connection;
  set connection(Object value);
}

abstract interface class PresentationConnectionCloseEventInit {
  PresentationConnectionCloseReason get reason;
  set reason(PresentationConnectionCloseReason value);
  String get message;
  set message(String value);
}

typedef PresentationConnectionCloseReason = String;

typedef PresentationConnectionState = String;

