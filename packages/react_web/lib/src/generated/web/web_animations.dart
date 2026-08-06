// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-animations
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'web_animations_2.dart';
import 'hr_time.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Animatable {
  Animation animate(Object? keyframes, [Object? options]);
  List<Animation> getAnimations([GetAnimationsOptions? options]);
}

typedef AnimationPlayState = String;

typedef AnimationReplaceState = String;

abstract interface class BaseComputedKeyframe {
  double? get offset;
  set offset(double? value);
  double? get computedOffset;
  set computedOffset(double? value);
  String? get easing;
  set easing(String? value);
  CompositeOperationOrAuto? get composite;
  set composite(CompositeOperationOrAuto? value);
}

final class BaseComputedKeyframeValue implements BaseComputedKeyframe {
  @override
  double? offset;
  @override
  double? computedOffset;
  @override
  String? easing;
  @override
  CompositeOperationOrAuto? composite;

  BaseComputedKeyframeValue({
    this.offset,
    this.computedOffset,
    this.easing,
    this.composite,
  });
}

abstract interface class BaseKeyframe {
  double? get offset;
  set offset(double? value);
  String? get easing;
  set easing(String? value);
  CompositeOperationOrAuto? get composite;
  set composite(CompositeOperationOrAuto? value);
}

final class BaseKeyframeValue implements BaseKeyframe {
  @override
  double? offset;
  @override
  String? easing;
  @override
  CompositeOperationOrAuto? composite;

  BaseKeyframeValue({
    this.offset,
    this.easing,
    this.composite,
  });
}

abstract interface class BasePropertyIndexedKeyframe {
  Object? get offset;
  set offset(Object? value);
  Object? get easing;
  set easing(Object? value);
  Object? get composite;
  set composite(Object? value);
}

final class BasePropertyIndexedKeyframeValue implements BasePropertyIndexedKeyframe {
  @override
  Object? offset;
  @override
  Object? easing;
  @override
  Object? composite;

  BasePropertyIndexedKeyframeValue({
    this.offset,
    this.easing,
    this.composite,
  });
}

typedef CompositeOperation = String;

typedef CompositeOperationOrAuto = String;

abstract interface class DocumentTimeline {
  factory DocumentTimeline([DocumentTimelineOptions? options]) =>
      WebRuntime.current.createWebObject<DocumentTimeline>(
        'DocumentTimeline',
        [options],
      );
}

abstract interface class DocumentTimelineOptions {
  DOMHighResTimeStamp? get originTime;
  set originTime(DOMHighResTimeStamp? value);
}

final class DocumentTimelineOptionsValue implements DocumentTimelineOptions {
  @override
  DOMHighResTimeStamp? originTime;

  DocumentTimelineOptionsValue({
    this.originTime,
  });
}

typedef FillMode = String;

abstract interface class GetAnimationsOptions {
  bool? get subtree;
  set subtree(bool? value);
}

final class GetAnimationsOptionsValue implements GetAnimationsOptions {
  @override
  bool? subtree;

  GetAnimationsOptionsValue({
    this.subtree,
  });
}

typedef PlaybackDirection = String;

