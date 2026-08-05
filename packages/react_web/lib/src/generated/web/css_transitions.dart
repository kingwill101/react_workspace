// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-transitions
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class TransitionEvent {
  factory TransitionEvent(Object type, [TransitionEventInit? transitionEventInitDict]) =>
      WebRuntime.current.createWebObject<TransitionEvent>(
        'TransitionEvent',
        [type, transitionEventInitDict],
      );
  Object get propertyName;
  double get elapsedTime;
  Object get pseudoElement;
}

abstract interface class TransitionEventInit {
  Object get propertyName;
  set propertyName(Object value);
  double get elapsedTime;
  set elapsedTime(double value);
  Object get pseudoElement;
  set pseudoElement(Object value);
}

