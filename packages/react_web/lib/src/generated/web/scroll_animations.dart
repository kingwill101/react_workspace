// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: scroll-animations
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_nav.dart';
import 'css_typed_om.dart';

typedef ScrollAxis = String;

abstract interface class ScrollTimeline {
  Element? get source;
  ScrollAxis get axis;
}

abstract interface class ScrollTimelineOptions {
  Element? get source;
  set source(Element? value);
  ScrollAxis get axis;
  set axis(ScrollAxis value);
}

abstract interface class ViewTimeline {
  Element get subject;
  CSSNumericValue get startOffset;
  CSSNumericValue get endOffset;
}

abstract interface class ViewTimelineOptions {
  Element get subject;
  set subject(Element value);
  ScrollAxis get axis;
  set axis(ScrollAxis value);
  Object get inset;
  set inset(Object value);
}

