import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// Button variants used by the translated shadcn-style controls.
enum UiButtonVariant {
  defaultAction,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

/// Button sizes used by the translated controls.
enum UiButtonSize { defaultSize, sm, lg, icon }

/// Builds a styled, accessible button using the portable `react_dom` host
/// element. The function intentionally accepts Dart callbacks instead of
/// exposing a JavaScript event object to application code.
ReactNode uiButton({
  String? label,
  ReactChildren children = const [],
  UiButtonVariant variant = UiButtonVariant.defaultAction,
  UiButtonSize size = UiButtonSize.defaultSize,
  bool disabled = false,
  void Function(ReactMouseEvent)? onPressed,
  String type = 'button',
  String? className,
  String? key,
}) => button(
  key: key,
  type: type,
  disabled: disabled,
  onClick: onPressed,
  className: cn([
    'inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors',
    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
    'disabled:pointer-events-none disabled:opacity-50',
    switch (variant) {
      UiButtonVariant.defaultAction =>
        'bg-primary text-primary-foreground shadow hover:bg-primary/90',
      UiButtonVariant.destructive => 'bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90',
      UiButtonVariant.outline => 'border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground',
      UiButtonVariant.secondary => 'bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80',
      UiButtonVariant.ghost => 'hover:bg-accent hover:text-accent-foreground',
      UiButtonVariant.link => 'text-primary underline-offset-4 hover:underline',
    },
    switch (size) {
      UiButtonSize.defaultSize => 'h-10 px-4 py-2',
      UiButtonSize.sm => 'h-9 rounded-md px-3',
      UiButtonSize.lg => 'h-11 rounded-md px-8',
      UiButtonSize.icon => 'h-10 w-10',
    },
    className,
  ]),
  additionalProps: {'type': type},
  children: [...children, if (label != null) Text(label)],
);
