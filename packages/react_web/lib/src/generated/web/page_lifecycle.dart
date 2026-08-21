// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: page-lifecycle
// ignore_for_file: type=lint

import 'service_workers.dart';

abstract interface class Client {
  String get url;
  FrameType get frameType;
  String get id;
  ClientType get type_;
  void postMessage(Object message, List<Object> transfer);
}

typedef ClientLifecycleState = String;
