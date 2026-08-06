// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: svg-animations
// ignore_for_file: type=lint

import 'svg.dart';
import 'html.dart';
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
  EventHandler get onend;
   set onend(EventHandler value);
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

