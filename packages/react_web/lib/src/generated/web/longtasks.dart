// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: longtasks
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class PerformanceLongTaskTiming {
  List<TaskAttributionTiming> get attribution;
}

abstract interface class TaskAttributionTiming {
  String get containerType;
  String get containerSrc;
  String get containerId;
  String get containerName;
}

