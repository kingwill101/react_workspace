// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: font-metrics-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class Baseline {
  String get name;
  double get value;
}

abstract interface class Font {
  String get name;
  int get glyphsRendered;
}

abstract interface class FontMetrics {
  double get width;
  List<double> get advances;
  double get boundingBoxLeft;
  double get boundingBoxRight;
  double get height;
  double get emHeightAscent;
  double get emHeightDescent;
  double get boundingBoxAscent;
  double get boundingBoxDescent;
  double get fontBoundingBoxAscent;
  double get fontBoundingBoxDescent;
  Baseline get dominantBaseline;
  List<Baseline> get baselines;
  List<Font> get fonts;
}

