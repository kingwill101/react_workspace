// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: eyedropper-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class ColorSelectionOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class ColorSelectionOptionsValue implements ColorSelectionOptions {
  @override
  AbortSignal? signal;

  ColorSelectionOptionsValue({
    this.signal,
  });
}

abstract interface class ColorSelectionResult {
  String? get sRGBHex;
  set sRGBHex(String? value);
}

final class ColorSelectionResultValue implements ColorSelectionResult {
  @override
  String? sRGBHex;

  ColorSelectionResultValue({
    this.sRGBHex,
  });
}

