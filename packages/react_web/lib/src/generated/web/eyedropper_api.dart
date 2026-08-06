// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: eyedropper-api
// ignore_for_file: type=lint

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

