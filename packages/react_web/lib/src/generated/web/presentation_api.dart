// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: presentation-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class PresentationConnectionAvailableEventInit {
  Object get connection;
  set connection(Object value);
}

final class PresentationConnectionAvailableEventInitValue implements PresentationConnectionAvailableEventInit {
  @override
  Object connection;

  PresentationConnectionAvailableEventInitValue({
    required this.connection,
  });
}

abstract interface class PresentationConnectionCloseEventInit {
  PresentationConnectionCloseReason get reason;
  set reason(PresentationConnectionCloseReason value);
  String? get message;
  set message(String? value);
}

final class PresentationConnectionCloseEventInitValue implements PresentationConnectionCloseEventInit {
  @override
  PresentationConnectionCloseReason reason;
  @override
  String? message;

  PresentationConnectionCloseEventInitValue({
    required this.reason,
    this.message,
  });
}

typedef PresentationConnectionCloseReason = String;

typedef PresentationConnectionState = String;

