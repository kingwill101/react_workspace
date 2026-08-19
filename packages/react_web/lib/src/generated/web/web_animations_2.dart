// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-animations-2
// ignore_for_file: type=lint

import 'css_typed_om.dart';
import 'web_animations.dart';
import 'html.dart';
import 'dom.dart';
import 'css_nav.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Animation {
  factory Animation([AnimationEffect? effect, AnimationTimeline? timeline]) =>
      WebRuntime.current.createWebObject<Animation>('Animation', [
        effect,
        timeline,
      ]);
  CSSNumberish? get startTime;
  set startTime(CSSNumberish? value);
  CSSNumberish? get currentTime;
  set currentTime(CSSNumberish? value);
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
  EffectTiming getTiming();
  ComputedEffectTiming getComputedTiming();
  void updateTiming([OptionalEffectTiming? timing]);
}

abstract interface class AnimationPlaybackEvent {
  factory AnimationPlaybackEvent(
    String type_, [
    AnimationPlaybackEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<AnimationPlaybackEvent>(
    'AnimationPlaybackEvent',
    [type_, eventInitDict],
  );
  CSSNumberish? get currentTime;
  CSSNumberish? get timelineTime;
}

abstract interface class AnimationPlaybackEventInit {
  CSSNumberish? get currentTime;
  set currentTime(CSSNumberish? value);
  CSSNumberish? get timelineTime;
  set timelineTime(CSSNumberish? value);
}

final class AnimationPlaybackEventInitValue
    implements AnimationPlaybackEventInit {
  @override
  CSSNumberish? currentTime;
  @override
  CSSNumberish? timelineTime;

  AnimationPlaybackEventInitValue({this.currentTime, this.timelineTime});
}

abstract interface class AnimationTimeline {
  CSSNumberish? get currentTime;
}

abstract interface class ComputedEffectTiming {
  CSSNumberish? get startTime;
  set startTime(CSSNumberish? value);
  CSSNumberish? get endTime;
  set endTime(CSSNumberish? value);
  CSSNumberish? get activeDuration;
  set activeDuration(CSSNumberish? value);
  CSSNumberish? get localTime;
  set localTime(CSSNumberish? value);
  double? get progress;
  set progress(double? value);
  double? get currentIteration;
  set currentIteration(double? value);
}

final class ComputedEffectTimingValue implements ComputedEffectTiming {
  @override
  CSSNumberish? startTime;
  @override
  CSSNumberish? endTime;
  @override
  CSSNumberish? activeDuration;
  @override
  CSSNumberish? localTime;
  @override
  double? progress;
  @override
  double? currentIteration;

  ComputedEffectTimingValue({
    this.startTime,
    this.endTime,
    this.activeDuration,
    this.localTime,
    this.progress,
    this.currentIteration,
  });
}

typedef EffectCallback =
    void Function(double? progress, Object currentTarget, Animation animation);

abstract interface class EffectTiming {
  double? get delay;
  set delay(double? value);
  double? get endDelay;
  set endDelay(double? value);
  double? get playbackRate;
  set playbackRate(double? value);
  Object? get duration;
  set duration(Object? value);
  FillMode? get fill;
  set fill(FillMode? value);
  double? get iterationStart;
  set iterationStart(double? value);
  double? get iterations;
  set iterations(double? value);
  PlaybackDirection? get direction;
  set direction(PlaybackDirection? value);
  String? get easing;
  set easing(String? value);
}

final class EffectTimingValue implements EffectTiming {
  @override
  double? delay;
  @override
  double? endDelay;
  @override
  double? playbackRate;
  @override
  Object? duration;
  @override
  FillMode? fill;
  @override
  double? iterationStart;
  @override
  double? iterations;
  @override
  PlaybackDirection? direction;
  @override
  String? easing;

  EffectTimingValue({
    this.delay,
    this.endDelay,
    this.playbackRate,
    this.duration,
    this.fill,
    this.iterationStart,
    this.iterations,
    this.direction,
    this.easing,
  });
}

typedef IterationCompositeOperation = String;

abstract interface class KeyframeAnimationOptions {
  Object? get rangeStart;
  set rangeStart(Object? value);
  Object? get rangeEnd;
  set rangeEnd(Object? value);
  String? get id;
  set id(String? value);
  AnimationTimeline? get timeline;
  set timeline(AnimationTimeline? value);
}

final class KeyframeAnimationOptionsValue implements KeyframeAnimationOptions {
  @override
  Object? rangeStart;
  @override
  Object? rangeEnd;
  @override
  String? id;
  @override
  AnimationTimeline? timeline;

  KeyframeAnimationOptionsValue({
    this.rangeStart,
    this.rangeEnd,
    this.id,
    this.timeline,
  });
}

abstract interface class KeyframeEffect {
  factory KeyframeEffect(
    Element? target,
    Object? keyframes, [
    Object? options,
  ]) => WebRuntime.current.createWebObject<KeyframeEffect>('KeyframeEffect', [
    target,
    keyframes,
    options,
  ]);
  factory KeyframeEffect.named1(KeyframeEffect source) => WebRuntime.current
      .createWebObject<KeyframeEffect>('KeyframeEffect', [source]);
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
  IterationCompositeOperation? get iterationComposite;
  set iterationComposite(IterationCompositeOperation? value);
  CompositeOperation? get composite;
  set composite(CompositeOperation? value);
  Object? get pseudoElement;
  set pseudoElement(Object? value);
}

final class KeyframeEffectOptionsValue implements KeyframeEffectOptions {
  @override
  IterationCompositeOperation? iterationComposite;
  @override
  CompositeOperation? composite;
  @override
  Object? pseudoElement;

  KeyframeEffectOptionsValue({
    this.iterationComposite,
    this.composite,
    this.pseudoElement,
  });
}

abstract interface class OptionalEffectTiming {
  double? get playbackRate;
  set playbackRate(double? value);
  double? get delay;
  set delay(double? value);
  double? get endDelay;
  set endDelay(double? value);
  FillMode? get fill;
  set fill(FillMode? value);
  double? get iterationStart;
  set iterationStart(double? value);
  double? get iterations;
  set iterations(double? value);
  Object? get duration;
  set duration(Object? value);
  PlaybackDirection? get direction;
  set direction(PlaybackDirection? value);
  String? get easing;
  set easing(String? value);
}

final class OptionalEffectTimingValue implements OptionalEffectTiming {
  @override
  double? playbackRate;
  @override
  double? delay;
  @override
  double? endDelay;
  @override
  FillMode? fill;
  @override
  double? iterationStart;
  @override
  double? iterations;
  @override
  Object? duration;
  @override
  PlaybackDirection? direction;
  @override
  String? easing;

  OptionalEffectTimingValue({
    this.playbackRate,
    this.delay,
    this.endDelay,
    this.fill,
    this.iterationStart,
    this.iterations,
    this.duration,
    this.direction,
    this.easing,
  });
}

abstract interface class TimelineRangeOffset {
  Object? get rangeName;
  set rangeName(Object? value);
  CSSNumericValue? get offset;
  set offset(CSSNumericValue? value);
}

final class TimelineRangeOffsetValue implements TimelineRangeOffset {
  @override
  Object? rangeName;
  @override
  CSSNumericValue? offset;

  TimelineRangeOffsetValue({this.rangeName, this.offset});
}
