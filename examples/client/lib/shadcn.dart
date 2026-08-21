import 'package:react/react.dart';

/// Dart-facing wrapper around the local shadcn Button implementation.
ReactNode shadcnButton({
  String? variant,
  String? size,
  String? className,
  bool? disabled,
  ReactCallback? onClick,
  ReactChildren children = const [],
}) => foreignComponent(
  'shadcn.Button',
  props: {
    'variant': ?variant,
    'size': ?size,
    'className': ?className,
    'disabled': ?disabled,
    'onClick': ?onClick,
  },
  children: children,
);

/// Dart-facing wrapper around the local shadcn Card implementation.
ReactNode shadcnCard({
  String? className,
  ReactChildren children = const [],
}) => foreignComponent(
  'shadcn.Card',
  props: {'className': ?className},
  children: children,
);
