// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: shape-detection-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'geometry.dart';
import 'image_capture.dart';

abstract interface class BarcodeDetector {
  Future<List<DetectedBarcode>> detect(ImageBitmapSource image);
}

abstract interface class BarcodeDetectorOptions {
  List<BarcodeFormat> get formats;
  set formats(List<BarcodeFormat> value);
}

typedef BarcodeFormat = String;

abstract interface class DetectedBarcode {
  DOMRectReadOnly get boundingBox;
  set boundingBox(DOMRectReadOnly value);
  String get rawValue;
  set rawValue(String value);
  BarcodeFormat get format;
  set format(BarcodeFormat value);
  List<Point2D> get cornerPoints;
  set cornerPoints(List<Point2D> value);
}

abstract interface class DetectedFace {
  DOMRectReadOnly get boundingBox;
  set boundingBox(DOMRectReadOnly value);
  List<Landmark>? get landmarks;
  set landmarks(List<Landmark>? value);
}

abstract interface class FaceDetector {
  Future<List<DetectedFace>> detect(ImageBitmapSource image);
}

abstract interface class FaceDetectorOptions {
  int get maxDetectedFaces;
  set maxDetectedFaces(int value);
  bool get fastMode;
  set fastMode(bool value);
}

abstract interface class Landmark {
  List<Point2D> get locations;
  set locations(List<Point2D> value);
  LandmarkType get type;
  set type(LandmarkType value);
}

typedef LandmarkType = String;

