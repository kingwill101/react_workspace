import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// A controlled text input matching the reference UI input primitive.
ReactNode uiInput({
  String? value,
  String? placeholder,
  String type = 'text',
  String? id,
  String? name,
  bool disabled = false,
  bool required = false,
  String? className,
  void Function(ReactChangeEvent)? onChanged,
  void Function(ReactInputEvent)? onInput,
}) => input(
  type: type,
  value: value,
  placeholder: placeholder,
  id: id,
  name: name,
  disabled: disabled,
  onChange: onChanged,
  onInput: onInput,
  additionalProps: {if (required) 'required': true},
  className: cn([
    'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm',
    'ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium',
    'placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
    'disabled:cursor-not-allowed disabled:opacity-50',
    className,
  ]),
);
