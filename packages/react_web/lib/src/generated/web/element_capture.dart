// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: element-capture
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'mediacapture_region.dart';

abstract interface class BrowserCaptureMediaStreamTrack {
  Future<void> restrictTo(RestrictionTarget? RestrictionTarget);
  Future<void> cropTo(CropTarget? cropTarget);
  BrowserCaptureMediaStreamTrack clone();
}

abstract interface class RestrictionTarget {
}

