import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// A labelled form field with optional help and validation text.
ReactNode uiFormField({
  required String labelText,
  required ReactNode control,
  String? description,
  String? error,
  String? htmlFor,
  String? className,
}) => div(
  className: cn(['space-y-2', className]),
  children: [
    label(
      htmlFor: htmlFor,
      className: 'text-sm font-medium',
      children: [Text(labelText)],
    ),
    control,
    if (description != null && error == null)
      p(
        className: 'text-sm text-muted-foreground',
        children: [Text(description)],
      ),
    if (error != null)
      p(
        className: 'text-sm font-medium text-destructive',
        role: 'alert',
        children: [Text(error)],
      ),
  ],
);

/// A form section title and description.
ReactNode uiFormSection({
  required String title,
  String? description,
  required ReactChildren children,
  String? className,
}) => fieldset(
  className: cn(['space-y-4', className]),
  children: [
    legend(className: 'text-base font-semibold', children: [Text(title)]),
    if (description != null)
      p(
        className: 'text-sm text-muted-foreground',
        children: [Text(description)],
      ),
    ...children,
  ],
);

/// An inline form message used by async actions.
ReactNode uiFormMessage(
  String message, {
  bool error = false,
  String? className,
}) => p(
  className: cn([
    'text-sm',
    error ? 'text-destructive' : 'text-muted-foreground',
    className,
  ]),
  role: error ? 'alert' : 'status',
  children: [Text(message)],
);
