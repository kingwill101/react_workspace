// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: handwriting-recognition
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';

abstract interface class HandwritingDrawing {
  void addStroke(HandwritingStroke stroke);
  void removeStroke(HandwritingStroke stroke);
  void clear();
  List<HandwritingStroke> getStrokes();
  Future<List<HandwritingPrediction>> getPrediction();
}

abstract interface class HandwritingDrawingSegment {
  int get strokeIndex;
  set strokeIndex(int value);
  int get beginPointIndex;
  set beginPointIndex(int value);
  int get endPointIndex;
  set endPointIndex(int value);
}

abstract interface class HandwritingHints {
  String get recognitionType;
  set recognitionType(String value);
  String get inputType;
  set inputType(String value);
  String get textContext;
  set textContext(String value);
  int get alternatives;
  set alternatives(int value);
}

abstract interface class HandwritingHintsQueryResult {
  List<HandwritingRecognitionType> get recognitionType;
  set recognitionType(List<HandwritingRecognitionType> value);
  List<HandwritingInputType> get inputType;
  set inputType(List<HandwritingInputType> value);
  bool get textContext;
  set textContext(bool value);
  bool get alternatives;
  set alternatives(bool value);
}

typedef HandwritingInputType = String;

abstract interface class HandwritingModelConstraint {
  List<String> get languages;
  set languages(List<String> value);
}

abstract interface class HandwritingPoint {
  double get x;
  set x(double value);
  double get y;
  set y(double value);
  DOMHighResTimeStamp get t;
  set t(DOMHighResTimeStamp value);
}

abstract interface class HandwritingPrediction {
  String get text;
  set text(String value);
  List<HandwritingSegment> get segmentationResult;
  set segmentationResult(List<HandwritingSegment> value);
}

typedef HandwritingRecognitionType = String;

abstract interface class HandwritingRecognizer {
  HandwritingDrawing startDrawing([HandwritingHints? hints]);
  void finish();
}

abstract interface class HandwritingRecognizerQueryResult {
  bool get textAlternatives;
  set textAlternatives(bool value);
  bool get textSegmentation;
  set textSegmentation(bool value);
  HandwritingHintsQueryResult get hints;
  set hints(HandwritingHintsQueryResult value);
}

abstract interface class HandwritingSegment {
  String get grapheme;
  set grapheme(String value);
  int get beginIndex;
  set beginIndex(int value);
  int get endIndex;
  set endIndex(int value);
  List<HandwritingDrawingSegment> get drawingSegments;
  set drawingSegments(List<HandwritingDrawingSegment> value);
}

abstract interface class HandwritingStroke {
  void addPoint(HandwritingPoint point);
  List<HandwritingPoint> getPoints();
  void clear();
}

