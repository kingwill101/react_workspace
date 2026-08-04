// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: fenced-frame
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class Fence {
  void reportEvent([ReportEventType? event]);
  void setReportEventDataForAutomaticBeacons([FenceEvent? event]);
  List<FencedFrameConfig> getNestedConfigs();
  Future<void> disableUntrustedNetwork();
  void notifyEvent(Event event);
}

abstract interface class FenceEvent {
  String get eventType;
  set eventType(String value);
  String get eventData;
  set eventData(String value);
  List<FenceReportingDestination> get destination;
  set destination(List<FenceReportingDestination> value);
  bool get crossOriginExposed;
  set crossOriginExposed(bool value);
  bool get once;
  set once(bool value);
  String get destinationURL;
  set destinationURL(String value);
}

typedef FenceReportingDestination = String;

abstract interface class FencedFrameConfig {
  void setSharedStorageContext(String contextString);
}

abstract interface class HTMLFencedFrameElement {
  FencedFrameConfig? get config;
   set config(FencedFrameConfig? value);
  String get width;
   set width(String value);
  String get height;
   set height(String value);
  DOMTokenList get sandbox;
  String get allow;
   set allow(String value);
}

typedef OpaqueProperty = String;

typedef ReportEventType = Object;

typedef UrnOrConfig = Object;

