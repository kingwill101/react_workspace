// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-highlight-api
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Highlight {
  factory Highlight([List<AbstractRange>? initialRanges]) =>
      WebRuntime.current.createWebObject<Highlight>(
        'Highlight',
        [initialRanges],
      );
  int get priority;
   set priority(int value);
  HighlightType get type;
   set type(HighlightType value);
}

abstract interface class HighlightRegistry {
}

typedef HighlightType = String;

