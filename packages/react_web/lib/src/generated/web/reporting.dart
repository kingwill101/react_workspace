// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: reporting
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class GenerateTestReportParameters {
  String get message;
  set message(String value);
  String? get group;
  set group(String? value);
}

final class GenerateTestReportParametersValue implements GenerateTestReportParameters {
  @override
  String message;
  @override
  String? group;

  GenerateTestReportParametersValue({
    required this.message,
    this.group,
  });
}

abstract interface class Report {
  Object toJSON();
  String get type;
  String get url;
  ReportBody? get body;
}

abstract interface class ReportBody {
  Object toJSON();
}

typedef ReportList = List<Report>;

abstract interface class ReportingObserver {
  factory ReportingObserver(ReportingObserverCallback callback, [ReportingObserverOptions? options]) =>
      WebRuntime.current.createWebObject<ReportingObserver>(
        'ReportingObserver',
        [callback, options],
      );
  void observe();
  void disconnect();
  ReportList takeRecords();
}

typedef ReportingObserverCallback = void Function(List<Report> reports, ReportingObserver observer,);

abstract interface class ReportingObserverOptions {
  List<String>? get types;
  set types(List<String>? value);
  bool? get buffered;
  set buffered(bool? value);
}

final class ReportingObserverOptionsValue implements ReportingObserverOptions {
  @override
  List<String>? types;
  @override
  bool? buffered;

  ReportingObserverOptionsValue({
    this.types,
    this.buffered,
  });
}

