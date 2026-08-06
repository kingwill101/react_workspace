// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: page-lifecycle
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';
import 'html.dart';

abstract interface class Client {
  String get url;
  FrameType get frameType;
  String get id;
  ClientType get type;
  void postMessage(Object message, List<Object> transfer);
}

typedef ClientLifecycleState = String;

