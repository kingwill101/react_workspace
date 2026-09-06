import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// A controlled checkbox with a native input for browser and assistive tech.
ReactNode uiCheckboxPrimitive({
  required bool checked,
  required void Function(bool) onChanged,
  String? labelText,
  String? className,
}) {
  final control = input(
    type: 'checkbox',
    checked: checked,
    className: cn(['h-4 w-4 rounded border-primary', className]),
    onChange: (_) => onChanged(!checked),
  );
  if (labelText == null) return control;
  return label(
    className: 'flex cursor-pointer items-center gap-2 text-sm',
    children: [
      control,
      span(children: [Text(labelText)]),
    ],
  );
}

/// A controlled radio group.
ReactNode uiRadioGroupPrimitive({
  required String value,
  required List<UiSelectionOption> options,
  required void Function(String value) onChanged,
  String? className,
}) => div(
  className: cn(['space-y-2', className]),
  role: 'radiogroup',
  children: [
    for (final option in options)
      label(
        key: option.value,
        className: 'flex cursor-pointer items-center gap-2 text-sm',
        children: [
          input(
            type: 'radio',
            value: option.value,
            checked: option.value == value,
            onChange: (_) => onChanged(option.value),
          ),
          Text(option.label),
        ],
      ),
  ],
);

/// A string option shared by radio and toggle groups.
final class UiSelectionOption {
  /// Creates a selection option.
  const UiSelectionOption(this.value, this.label);

  final String value;
  final String label;
}

/// A controlled range slider with an output value.
ReactNode uiSlider({
  required double value,
  required void Function(double) onChanged,
  double min = 0,
  double max = 100,
  double step = 1,
  String? className,
}) => div(
  className: cn(['flex w-full items-center gap-3', className]),
  children: [
    input(
      type: 'range',
      min: '$min',
      max: '$max',
      step: '$step',
      value: '$value',
      className: 'h-2 w-full cursor-pointer accent-primary',
      onChange: (_) => onChanged(value),
    ),
    output(
      className: 'w-12 text-right text-sm tabular-nums',
      children: [Text('$value')],
    ),
  ],
);

/// A button toggle with pressed semantics.
ReactNode uiTogglePrimitive({
  required String label,
  required bool pressed,
  required void Function(bool) onChanged,
  UiButtonVariant variant = UiButtonVariant.ghost,
  String? className,
}) => uiButton(
  label: label,
  variant: pressed ? UiButtonVariant.secondary : variant,
  className: cn([
    className,
    pressed ? 'bg-accent text-accent-foreground' : null,
  ]),
  onPressed: (_) => onChanged(!pressed),
);

/// A group of mutually exclusive or multi-select toggles.
ReactNode uiToggleGroup({
  required Set<String> selected,
  required List<UiSelectionOption> options,
  required void Function(String value) onChanged,
  bool multiple = false,
  String? className,
}) => div(
  className: cn(['flex flex-wrap items-center gap-1', className]),
  role: 'group',
  children: [
    for (final option in options)
      uiTogglePrimitive(
        label: option.label,
        pressed: selected.contains(option.value),
        onChanged: (pressed) {
          if (!multiple && pressed) {
            onChanged(option.value);
          } else if (multiple) {
            onChanged(option.value);
          }
        },
      ),
  ],
);

/// A collapsible region with explicit controlled state.
ReactNode uiCollapsible({
  required bool open,
  required ReactNode trigger,
  required ReactChildren children,
  required void Function(bool) onOpenChange,
  String? className,
}) => div(
  className: cn(['space-y-2', className]),
  children: [
    span(
      role: 'button',
      additionalProps: {'tabindex': 0, 'aria-expanded': open},
      onClick: (_) => onOpenChange(!open),
      children: [trigger],
    ),
    if (open) div(children: children),
  ],
);

/// A popover surface that is rendered when [open].
ReactNode uiPopover({
  required bool open,
  required ReactNode trigger,
  required ReactChildren children,
  required void Function(bool) onOpenChange,
  String? className,
}) => div(
  className: 'relative inline-block',
  children: [
    span(
      role: 'button',
      additionalProps: {'tabindex': 0},
      onClick: (_) => onOpenChange(!open),
      children: [trigger],
    ),
    if (open)
      div(
        className: cn([
          'absolute left-0 top-full z-50 mt-2 w-72 rounded-md border border-border bg-popover p-4 text-popover-foreground shadow-md',
          className,
        ]),
        children: children,
      ),
  ],
);
