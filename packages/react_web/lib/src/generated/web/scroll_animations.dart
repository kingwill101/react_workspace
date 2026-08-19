// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: scroll-animations
// ignore_for_file: type=lint

import 'css_nav.dart';
import 'css_typed_om.dart';

typedef ScrollAxis = String;

abstract interface class ScrollTimelineOptions {
  Element? get source;
  set source(Element? value);
  ScrollAxis? get axis;
  set axis(ScrollAxis? value);
}

final class ScrollTimelineOptionsValue implements ScrollTimelineOptions {
  @override
  Element? source;
  @override
  ScrollAxis? axis;

  ScrollTimelineOptionsValue({this.source, this.axis});
}

abstract interface class ViewTimelineOptions {
  Element? get subject;
  set subject(Element? value);
  ScrollAxis? get axis;
  set axis(ScrollAxis? value);
  Object? get inset;
  set inset(Object? value);
}

final class ViewTimelineOptionsValue implements ViewTimelineOptions {
  @override
  Element? subject;
  @override
  ScrollAxis? axis;
  @override
  Object? inset;

  ViewTimelineOptionsValue({this.subject, this.axis, this.inset});
}
