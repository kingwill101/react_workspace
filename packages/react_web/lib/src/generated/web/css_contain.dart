// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-contain
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class ContentVisibilityAutoStateChangeEvent {
  factory ContentVisibilityAutoStateChangeEvent(String type, [ContentVisibilityAutoStateChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ContentVisibilityAutoStateChangeEvent>(
        'ContentVisibilityAutoStateChangeEvent',
        [type, eventInitDict],
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

