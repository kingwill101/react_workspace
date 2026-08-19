// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-contain
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class ContentVisibilityAutoStateChangeEvent {
  factory ContentVisibilityAutoStateChangeEvent(String type_, [ContentVisibilityAutoStateChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ContentVisibilityAutoStateChangeEvent>(
        'ContentVisibilityAutoStateChangeEvent',
        [type_, eventInitDict],
      );
  bool get skipped;
}

abstract interface class ContentVisibilityAutoStateChangeEventInit {
  bool? get skipped;
  set skipped(bool? value);
}

final class ContentVisibilityAutoStateChangeEventInitValue implements ContentVisibilityAutoStateChangeEventInit {
  @override
  bool? skipped;

  ContentVisibilityAutoStateChangeEventInitValue({
    this.skipped,
  });
}

