import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';
import 'controls.dart';

/// A controlled checkbox using the browser's native accessible input.
ReactNode uiCheckbox({
  required bool checked,
  required void Function(bool) onChanged,
  String? labelText,
  String? className,
}) => labelText == null
    ? input(
        type: 'checkbox',
        checked: checked,
        className: className,
        onChange: (_) => onChanged(!checked),
      )
    : label(
        className: cn(['flex cursor-pointer items-center gap-2', className]),
        children: [
          input(
            type: 'checkbox',
            checked: checked,
            onChange: (_) => onChanged(!checked),
          ),
          span(children: [Text(labelText)]),
        ],
      );

/// A text-like toggle with selected semantics.
ReactNode uiToggle({
  required String label,
  required bool pressed,
  required void Function(bool) onChanged,
  String? className,
}) => uiButton(
  label: label,
  variant: pressed ? UiButtonVariant.secondary : UiButtonVariant.ghost,
  onPressed: (_) => onChanged(!pressed),
  className: cn(['aria-[pressed=true]:bg-accent', className]),
);

/// A radio group with a typed string value.
ReactNode uiRadioGroup({
  required String value,
  required List<UiRadioOption> options,
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

/// One entry in [uiRadioGroup].
final class UiRadioOption {
  /// Creates a radio option.
  const UiRadioOption(this.value, this.label);

  /// Form value.
  final String value;

  /// Display label.
  final String label;
}

/// A native details/summary disclosure for menus and compact panels.
ReactNode uiAccordion({
  required String title,
  required ReactChildren children,
  bool open = false,
  String? className,
}) => details(
  open: open,
  className: cn(['rounded-lg border border-border', className]),
  children: [
    summary(
      className: 'cursor-pointer list-none px-4 py-3 text-sm font-medium hover:bg-muted/50',
      children: [Text(title)],
    ),
    div(className: 'border-t border-border p-4', children: children),
  ],
);

/// A dropdown menu whose item actions are ordinary Dart callbacks.
///
/// `details` provides keyboard and no-JavaScript fallback behavior; the
/// styling layer can enhance it in the browser without changing the API.
ReactNode uiDropdownMenu({
  required ReactNode trigger,
  required ReactChildren children,
  String? className,
}) => details(
  className: cn(['relative inline-block text-left', className]),
  children: [
    summary(
      className: 'list-none [&::-webkit-details-marker]:hidden',
      children: [trigger],
    ),
    div(
      className: 'absolute right-0 z-20 mt-2 min-w-40 rounded-md border border-border bg-popover p-1 text-popover-foreground shadow-md',
      children: children,
    ),
  ],
);

/// An item in [uiDropdownMenu].
ReactNode uiDropdownItem({
  required String label,
  required void Function() onSelected,
  bool destructive = false,
  String? className,
}) => button(
  type: 'button',
  className: cn([
    'flex w-full items-center rounded-sm px-2 py-1.5 text-left text-sm outline-none hover:bg-accent',
    destructive ? 'text-destructive' : null,
    className,
  ]),
  onClick: (_) => onSelected(),
  children: [Text(label)],
);

/// A tooltip-compatible wrapper using the platform title affordance.
ReactNode uiTooltip({required String label, required ReactNode child}) =>
    span(additionalProps: {'title': label}, children: [child]);

/// A small inline form description.
ReactNode uiFieldDescription(String text, {String? className}) => p(
  className: cn(['text-sm text-muted-foreground', className]),
  children: [Text(text)],
);

/// An empty-state panel for lists with no matching records.
ReactNode uiEmptyState({
  required String title,
  required String description,
  ReactNode? action,
  String? className,
}) => div(
  className: cn([
    'flex min-h-40 flex-col items-center justify-center rounded-lg border border-dashed border-border p-8 text-center',
    className,
  ]),
  children: [
    h3(className: 'font-medium', children: [Text(title)]),
    p(
      className: 'mt-1 max-w-sm text-sm text-muted-foreground',
      children: [Text(description)],
    ),
    if (action != null) div(className: 'mt-4', children: [action]),
  ],
);

/// A dismissible-looking notification panel used by mocked actions.
ReactNode uiToast({
  required String message,
  UiAlertTone tone = UiAlertTone.info,
  String? className,
}) => div(
  className: cn([
    'rounded-md border p-3 text-sm shadow-sm',
    switch (tone) {
      UiAlertTone.info => 'border-primary/30 bg-primary/10 text-primary',
      UiAlertTone.success => 'border-success/30 bg-success/10 text-success',
      UiAlertTone.warning => 'border-warning/30 bg-warning/10 text-warning',
      UiAlertTone.error =>
        'border-destructive/30 bg-destructive/10 text-destructive',
    },
    className,
  ]),
  role: 'status',
  children: [Text(message)],
);

/// A responsive side panel used for mobile detail surfaces.
ReactNode uiSheet({
  required bool open,
  required String title,
  required ReactChildren children,
  required void Function(bool) onOpenChange,
}) => open
    ? aside(
        className: 'fixed inset-y-0 right-0 z-50 w-full max-w-md overflow-auto border-l border-border bg-background p-6 shadow-xl',
        children: [
          div(
            className: 'mb-6 flex items-center justify-between',
            children: [
              h2(className: 'text-lg font-semibold', children: [Text(title)]),
              uiButton(
                label: '×',
                variant: UiButtonVariant.ghost,
                size: UiButtonSize.icon,
                onPressed: (_) => onOpenChange(false),
              ),
            ],
          ),
          ...children,
        ],
      )
    : fragment(const []);
