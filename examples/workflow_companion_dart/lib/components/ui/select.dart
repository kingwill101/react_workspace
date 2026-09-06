import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// One option in [uiSelect].
final class UiSelectOption {
  /// Creates a select option.
  const UiSelectOption(this.value, this.label);

  final String value;
  final String label;
}

/// A native select with the same controlled-value contract as the reference
/// Radix select wrapper.
ReactNode uiSelect({
  required String value,
  required List<UiSelectOption> options,
  String? id,
  String? className,
  void Function(ReactChangeEvent)? onChanged,
}) => select(
  id: id,
  value: value,
  onChange: onChanged,
  className: cn([
    'flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm',
    'focus:outline-none focus:ring-2 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50',
    className,
  ]),
  children: [
    for (final option in options)
      optionElement(
        value: option.value,
        label: option.label,
        key: option.value,
      ),
  ],
);

ReactNode optionElement({
  required String value,
  required String label,
  String? key,
}) => option(value: value, key: key, children: [Text(label)]);
