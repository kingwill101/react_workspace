// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: portals
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';

abstract interface class HTMLPortalElement {
  String get src;
   set src(String value);
  String get referrerPolicy;
   set referrerPolicy(String value);
  Future<void> activate([PortalActivateOptions? options]);
  void postMessage(Object message, [StructuredSerializeOptions? options]);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

abstract interface class PortalActivateEvent {
  Object get data;
  HTMLPortalElement adoptPredecessor();
}

abstract interface class PortalActivateEventInit {
  Object get data;
  set data(Object value);
}

abstract interface class PortalActivateOptions {
  Object get data;
  set data(Object value);
}

abstract interface class PortalHost {
  void postMessage(Object message, [StructuredSerializeOptions? options]);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

