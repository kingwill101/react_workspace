// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-app-launch
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'file_system_access.dart';

typedef LaunchConsumer = Object Function(LaunchParams params,);

abstract interface class LaunchParams {
  String? get targetURL;
  List<FileSystemHandle> get files;
}

abstract interface class LaunchQueue {
  void setConsumer(LaunchConsumer consumer);
}

