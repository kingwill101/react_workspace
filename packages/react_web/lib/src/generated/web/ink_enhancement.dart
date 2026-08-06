// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ink-enhancement
// ignore_for_file: type=lint

import 'css_nav.dart';

abstract interface class InkPresenterParam {
  Element? get presentationArea;
  set presentationArea(Element? value);
}

final class InkPresenterParamValue implements InkPresenterParam {
  @override
  Element? presentationArea;

  InkPresenterParamValue({
    this.presentationArea,
  });
}

abstract interface class InkTrailStyle {
  String get color;
  set color(String value);
  double get diameter;
  set diameter(double value);
}

final class InkTrailStyleValue implements InkTrailStyle {
  @override
  String color;
  @override
  double diameter;

  InkTrailStyleValue({
    required this.color,
    required this.diameter,
  });
}

