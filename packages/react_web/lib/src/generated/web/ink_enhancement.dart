// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ink-enhancement
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_nav.dart';
import 'pointerevents.dart';

abstract interface class DelegatedInkTrailPresenter {
  Element? get presentationArea;
  void updateInkTrailStartPoint(PointerEvent event, InkTrailStyle style);
}

abstract interface class Ink {
  Future<DelegatedInkTrailPresenter> requestPresenter([InkPresenterParam? param]);
}

abstract interface class InkPresenterParam {
  Element? get presentationArea;
  set presentationArea(Element? value);
}

abstract interface class InkTrailStyle {
  String get color;
  set color(String value);
  double get diameter;
  set diameter(double value);
}

