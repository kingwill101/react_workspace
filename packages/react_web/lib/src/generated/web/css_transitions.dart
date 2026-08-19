// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-transitions
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class TransitionEvent {
  factory TransitionEvent(Object type_, [TransitionEventInit? transitionEventInitDict]) =>
      WebRuntime.current.createWebObject<TransitionEvent>(
        'TransitionEvent',
        [type_, transitionEventInitDict],
      );
  Object get propertyName;
  double get elapsedTime;
  Object get pseudoElement;
}

abstract interface class TransitionEventInit {
  Object? get propertyName;
  set propertyName(Object? value);
  double? get elapsedTime;
  set elapsedTime(double? value);
  Object? get pseudoElement;
  set pseudoElement(Object? value);
}

final class TransitionEventInitValue implements TransitionEventInit {
  @override
  Object? propertyName;
  @override
  double? elapsedTime;
  @override
  Object? pseudoElement;

  TransitionEventInitValue({
    this.propertyName,
    this.elapsedTime,
    this.pseudoElement,
  });
}

