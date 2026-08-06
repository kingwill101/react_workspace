// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: fenced-frame
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class FenceEvent {
  String? get eventType;
  set eventType(String? value);
  String? get eventData;
  set eventData(String? value);
  List<FenceReportingDestination>? get destination;
  set destination(List<FenceReportingDestination>? value);
  bool? get crossOriginExposed;
  set crossOriginExposed(bool? value);
  bool? get once;
  set once(bool? value);
  String? get destinationURL;
  set destinationURL(String? value);
}

final class FenceEventValue implements FenceEvent {
  @override
  String? eventType;
  @override
  String? eventData;
  @override
  List<FenceReportingDestination>? destination;
  @override
  bool? crossOriginExposed;
  @override
  bool? once;
  @override
  String? destinationURL;

  FenceEventValue({
    this.eventType,
    this.eventData,
    this.destination,
    this.crossOriginExposed,
    this.once,
    this.destinationURL,
  });
}

typedef FenceReportingDestination = String;

typedef FencedFrameConfigSize = Object;

typedef FencedFrameConfigURL = String;

typedef OpaqueProperty = String;

typedef ReportEventType = Object;

typedef UrnOrConfig = Object;

