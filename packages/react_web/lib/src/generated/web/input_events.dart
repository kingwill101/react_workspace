// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: input-events
// ignore_for_file: type=lint

import 'dom.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class InputEvent {
  factory InputEvent(String type_, [InputEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<InputEvent>('InputEvent', [
        type_,
        eventInitDict,
      ]);
  DataTransfer? get dataTransfer;
  List<StaticRange> getTargetRanges();
  String? get data;
  bool get isComposing;
  String get inputType;
}

abstract interface class InputEventInit {
  DataTransfer? get dataTransfer;
  set dataTransfer(DataTransfer? value);
  List<StaticRange>? get targetRanges;
  set targetRanges(List<StaticRange>? value);
  String? get data;
  set data(String? value);
  bool? get isComposing;
  set isComposing(bool? value);
  String? get inputType;
  set inputType(String? value);
}

final class InputEventInitValue implements InputEventInit {
  @override
  DataTransfer? dataTransfer;
  @override
  List<StaticRange>? targetRanges;
  @override
  String? data;
  @override
  bool? isComposing;
  @override
  String? inputType;

  InputEventInitValue({
    this.dataTransfer,
    this.targetRanges,
    this.data,
    this.isComposing,
    this.inputType,
  });
}
