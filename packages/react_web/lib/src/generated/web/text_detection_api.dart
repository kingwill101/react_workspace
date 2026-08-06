// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: text-detection-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'image_capture.dart';

abstract interface class DetectedText {
  DOMRectReadOnly get boundingBox;
  set boundingBox(DOMRectReadOnly value);
  String get rawValue;
  set rawValue(String value);
  List<Point2D> get cornerPoints;
  set cornerPoints(List<Point2D> value);
}

final class DetectedTextValue implements DetectedText {
  @override
  DOMRectReadOnly boundingBox;
  @override
  String rawValue;
  @override
  List<Point2D> cornerPoints;

  DetectedTextValue({
    required this.boundingBox,
    required this.rawValue,
    required this.cornerPoints,
  });
}

