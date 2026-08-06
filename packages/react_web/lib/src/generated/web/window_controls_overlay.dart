// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: window-controls-overlay
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'dom.dart';

abstract interface class WindowControlsOverlayGeometryChangeEventInit {
  DOMRect get titlebarAreaRect;
  set titlebarAreaRect(DOMRect value);
  bool? get visible;
  set visible(bool? value);
}

final class WindowControlsOverlayGeometryChangeEventInitValue implements WindowControlsOverlayGeometryChangeEventInit {
  @override
  DOMRect titlebarAreaRect;
  @override
  bool? visible;

  WindowControlsOverlayGeometryChangeEventInitValue({
    required this.titlebarAreaRect,
    this.visible,
  });
}

