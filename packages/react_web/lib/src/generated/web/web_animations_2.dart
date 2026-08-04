// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-animations-2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_typed_om.dart';
import 'web_animations.dart';
import 'html.dart';
import 'dom.dart';
import 'css_nav.dart';
import 'css_pseudo.dart';

abstract interface class Animation {
  CSSNumberish? get startTime;
   set startTime(CSSNumberish? value);
  CSSNumberish? get currentTime;
   set currentTime(CSSNumberish? value);
  AnimationTrigger? get trigger;
   set trigger(AnimationTrigger? value);
  double? get overallProgress;
  String get id;
   set id(String value);
  AnimationEffect? get effect;
   set effect(AnimationEffect? value);
  AnimationTimeline? get timeline;
   set timeline(AnimationTimeline? value);
  double get playbackRate;
   set playbackRate(double value);
  AnimationPlayState get playState;
  AnimationReplaceState get replaceState;
  bool get pending;
  Future<Animation> get ready;
  Future<Animation> get finished;
  EventHandler get onfinish;
   set onfinish(EventHandler value);
  EventHandler get oncancel;
   set oncancel(EventHandler value);
  EventHandler get onremove;
   set onremove(EventHandler value);
  void cancel();
  void finish();
  void play();
  void pause();
  void updatePlaybackRate(double playbackRate);
  void reverse();
  void persist();
  void commitStyles();
}

abstract interface class AnimationEffect {
  GroupEffect? get parent;
  AnimationEffect? get previousSibling;
  AnimationEffect? get nextSibling;
  void before([List<AnimationEffect>? effects]);
  void after([List<AnimationEffect>? effects]);
  void replace([List<AnimationEffect>? effects]);
  void remove();
  EffectTiming getTiming();
  ComputedEffectTiming getComputedTiming();
  void updateTiming([OptionalEffectTiming? timing]);
}

abstract interface class AnimationNodeList {
  int get length;
  AnimationEffect? item(int index);
}

abstract interface class AnimationPlaybackEvent {
  CSSNumberish? get currentTime;
  CSSNumberish? get timelineTime;
}

abstract interface class AnimationPlaybackEventInit {
  CSSNumberish? get currentTime;
  set currentTime(CSSNumberish? value);
  CSSNumberish? get timelineTime;
  set timelineTime(CSSNumberish? value);
}

abstract interface class AnimationTimeline {
  CSSNumberish? get currentTime;
  CSSNumberish? get duration;
  Animation play([AnimationEffect? effect]);
}

abstract interface class AnimationTrigger {
  AnimationTimeline get timeline;
   set timeline(AnimationTimeline value);
  AnimationTriggerType get type;
   set type(AnimationTriggerType value);
  Object get rangeStart;
   set rangeStart(Object value);
  Object get rangeEnd;
   set rangeEnd(Object value);
  Object get exitRangeStart;
   set exitRangeStart(Object value);
  Object get exitRangeEnd;
   set exitRangeEnd(Object value);
}

abstract interface class AnimationTriggerOptions {
  AnimationTimeline? get timeline;
  set timeline(AnimationTimeline? value);
  AnimationTriggerType? get type;
  set type(AnimationTriggerType? value);
  Object get rangeStart;
  set rangeStart(Object value);
  Object get rangeEnd;
  set rangeEnd(Object value);
  Object get exitRangeStart;
  set exitRangeStart(Object value);
  Object get exitRangeEnd;
  set exitRangeEnd(Object value);
}

typedef AnimationTriggerType = String;

abstract interface class ComputedEffectTiming {
  CSSNumberish get startTime;
  set startTime(CSSNumberish value);
  CSSNumberish get endTime;
  set endTime(CSSNumberish value);
  CSSNumberish get activeDuration;
  set activeDuration(CSSNumberish value);
  CSSNumberish? get localTime;
  set localTime(CSSNumberish? value);
  double? get progress;
  set progress(double? value);
  double? get currentIteration;
  set currentIteration(double? value);
}

typedef EffectCallback = void Function(double? progress, Object currentTarget, Animation animation,);

abstract interface class EffectTiming {
  double get delay;
  set delay(double value);
  double get endDelay;
  set endDelay(double value);
  double get playbackRate;
  set playbackRate(double value);
  Object get duration;
  set duration(Object value);
  FillMode get fill;
  set fill(FillMode value);
  double get iterationStart;
  set iterationStart(double value);
  double get iterations;
  set iterations(double value);
  PlaybackDirection get direction;
  set direction(PlaybackDirection value);
  String get easing;
  set easing(String value);
}

abstract interface class GroupEffect {
  AnimationNodeList get children;
  AnimationEffect? get firstChild;
  AnimationEffect? get lastChild;
  GroupEffect clone();
  void prepend([List<AnimationEffect>? effects]);
  void append([List<AnimationEffect>? effects]);
}

typedef IterationCompositeOperation = String;

abstract interface class KeyframeAnimationOptions {
  Object get rangeStart;
  set rangeStart(Object value);
  Object get rangeEnd;
  set rangeEnd(Object value);
  AnimationTrigger? get trigger;
  set trigger(AnimationTrigger? value);
  String get id;
  set id(String value);
  AnimationTimeline? get timeline;
  set timeline(AnimationTimeline? value);
}

abstract interface class KeyframeEffect {
  IterationCompositeOperation get iterationComposite;
   set iterationComposite(IterationCompositeOperation value);
  Element? get target;
   set target(Element? value);
  Object get pseudoElement;
   set pseudoElement(Object value);
  CompositeOperation get composite;
   set composite(CompositeOperation value);
  List<Object> getKeyframes();
  void setKeyframes(Object? keyframes);
}

abstract interface class KeyframeEffectOptions {
  IterationCompositeOperation get iterationComposite;
  set iterationComposite(IterationCompositeOperation value);
  CompositeOperation get composite;
  set composite(CompositeOperation value);
  Object get pseudoElement;
  set pseudoElement(Object value);
}

abstract interface class OptionalEffectTiming {
  double get playbackRate;
  set playbackRate(double value);
  double get delay;
  set delay(double value);
  double get endDelay;
  set endDelay(double value);
  FillMode get fill;
  set fill(FillMode value);
  double get iterationStart;
  set iterationStart(double value);
  double get iterations;
  set iterations(double value);
  Object get duration;
  set duration(Object value);
  PlaybackDirection get direction;
  set direction(PlaybackDirection value);
  String get easing;
  set easing(String value);
}

abstract interface class SequenceEffect {
  SequenceEffect clone();
}

abstract interface class TimelineRangeOffset {
  Object get rangeName;
  set rangeName(Object value);
  CSSNumericValue get offset;
  set offset(CSSNumericValue value);
}

