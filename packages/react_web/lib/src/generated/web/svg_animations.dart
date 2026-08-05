// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: svg-animations
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'svg.dart';
import 'anonymous_iframe.dart';

abstract interface class SVGAnimateElement {
}

abstract interface class SVGAnimateMotionElement {
}

abstract interface class SVGAnimateTransformElement {
}

abstract interface class SVGAnimationElement {
  SVGStringList get requiredExtensions;
  SVGStringList get systemLanguage;
  SVGElement? get targetElement;
  double getStartTime();
  double getCurrentTime();
  double getSimpleDuration();
  void beginElement();
  void beginElementAt(double offset);
  void endElement();
  void endElementAt(double offset);
}

abstract interface class SVGMPathElement {
  SVGAnimatedString get href;
}

abstract interface class SVGSetElement {
}

abstract interface class TimeEvent {
  Object get view;
  int get detail;
  void initTimeEvent(String typeArg, Window? viewArg, int detailArg);
}

