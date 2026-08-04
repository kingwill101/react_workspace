// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: input-events
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'input_device_capabilities.dart';

abstract interface class InputEvent {
  DataTransfer? get dataTransfer;
  List<StaticRange> getTargetRanges();
  String? get data;
  bool get isComposing;
  String get inputType;
}

abstract interface class InputEventInit {
  DataTransfer? get dataTransfer;
  set dataTransfer(DataTransfer? value);
  List<StaticRange> get targetRanges;
  set targetRanges(List<StaticRange> value);
  String? get data;
  set data(String? value);
  bool get isComposing;
  set isComposing(bool value);
  String get inputType;
  set inputType(String value);
}

