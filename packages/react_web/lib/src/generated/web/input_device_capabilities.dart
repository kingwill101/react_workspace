// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: input-device-capabilities
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'anonymous_iframe.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class InputDeviceCapabilitiesInit {
  bool? get firesTouchEvents;
  set firesTouchEvents(bool? value);
  bool? get pointerMovementScrolls;
  set pointerMovementScrolls(bool? value);
}

final class InputDeviceCapabilitiesInitValue implements InputDeviceCapabilitiesInit {
  @override
  bool? firesTouchEvents;
  @override
  bool? pointerMovementScrolls;

  InputDeviceCapabilitiesInitValue({
    this.firesTouchEvents,
    this.pointerMovementScrolls,
  });
}

abstract interface class UIEvent {
  factory UIEvent(String type, [UIEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<UIEvent>(
        'UIEvent',
        [type, eventInitDict],
      );
  Window? get view;
  int get detail;
  void initUIEvent(String typeArg, [bool? bubblesArg, bool? cancelableArg, Window? viewArg, int? detailArg]);
  int get which;
}

abstract interface class UIEventInit {
  Object? get sourceCapabilities;
  set sourceCapabilities(Object? value);
  Window? get view;
  set view(Window? value);
  int? get detail;
  set detail(int? value);
  int? get which;
  set which(int? value);
}

final class UIEventInitValue implements UIEventInit {
  @override
  Object? sourceCapabilities;
  @override
  Window? view;
  @override
  int? detail;
  @override
  int? which;

  UIEventInitValue({
    this.sourceCapabilities,
    this.view,
    this.detail,
    this.which,
  });
}

