// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: shape-detection-api
// ignore_for_file: type=lint

import 'geometry.dart';
import 'image_capture.dart';

abstract interface class BarcodeDetectorOptions {
  List<BarcodeFormat>? get formats;
  set formats(List<BarcodeFormat>? value);
}

final class BarcodeDetectorOptionsValue implements BarcodeDetectorOptions {
  @override
  List<BarcodeFormat>? formats;

  BarcodeDetectorOptionsValue({
    this.formats,
  });
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

final class DetectedBarcodeValue implements DetectedBarcode {
  @override
  DOMRectReadOnly boundingBox;
  @override
  String rawValue;
  @override
  BarcodeFormat format;
  @override
  List<Point2D> cornerPoints;

  DetectedBarcodeValue({
    required this.boundingBox,
    required this.rawValue,
    required this.format,
    required this.cornerPoints,
  });
}

abstract interface class DetectedFace {
  DOMRectReadOnly get boundingBox;
  set boundingBox(DOMRectReadOnly value);
  List<Landmark>? get landmarks;
  set landmarks(List<Landmark>? value);
}

final class DetectedFaceValue implements DetectedFace {
  @override
  DOMRectReadOnly boundingBox;
  @override
  List<Landmark>? landmarks;

  DetectedFaceValue({
    required this.boundingBox,
    required this.landmarks,
  });
}

abstract interface class FaceDetectorOptions {
  int? get maxDetectedFaces;
  set maxDetectedFaces(int? value);
  bool? get fastMode;
  set fastMode(bool? value);
}

final class FaceDetectorOptionsValue implements FaceDetectorOptions {
  @override
  int? maxDetectedFaces;
  @override
  bool? fastMode;

  FaceDetectorOptionsValue({
    this.maxDetectedFaces,
    this.fastMode,
  });
}

abstract interface class Landmark {
  List<Point2D> get locations;
  set locations(List<Point2D> value);
  LandmarkType? get type;
  set type(LandmarkType? value);
}

final class LandmarkValue implements Landmark {
  @override
  List<Point2D> locations;
  @override
  LandmarkType? type;

  LandmarkValue({
    required this.locations,
    this.type,
  });
}

typedef LandmarkType = String;

