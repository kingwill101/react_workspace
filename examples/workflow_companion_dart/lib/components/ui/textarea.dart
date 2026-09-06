import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// A controlled multiline text input.
ReactNode uiTextarea({
  String? value,
  String? placeholder,
  int? rows,
  String? id,
  bool disabled = false,
  String? className,
  void Function(ReactChangeEvent)? onChanged,
  void Function(ReactInputEvent)? onInput,
}) => textarea(
  value: value,
  placeholder: placeholder,
  rows: rows,
  id: id,
  disabled: disabled,
  onChange: onChanged,
  onInput: onInput,
  className: cn([
    'flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm',
    'placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
    'disabled:cursor-not-allowed disabled:opacity-50',
    className,
  ]),
);
