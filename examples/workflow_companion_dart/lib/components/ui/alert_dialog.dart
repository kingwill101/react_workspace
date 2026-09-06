import 'package:react_dom/react_dom.dart';

import 'button.dart';
import 'dialog.dart';

/// A controlled confirmation dialog matching the shadcn alert-dialog shape.
///
/// The native `dialog` element gives the content a useful non-JavaScript
/// document shape while the callbacks remain ordinary Dart functions.
ReactNode uiAlertDialog({
  required bool open,
  required String title,
  required String description,
  required void Function() onConfirm,
  required void Function() onCancel,
  String confirmLabel = 'Continue',
  String cancelLabel = 'Cancel',
  bool destructive = false,
  String? className,
}) => open
    ? uiDialogFrame(
        className: className,
        role: 'alertdialog',
        additionalProps: {'aria-describedby': 'alert-description'},
        children: [
          div(
            className: 'flex flex-col space-y-2 text-center sm:text-left',
            children: [
              h2(className: 'text-lg font-semibold', children: [Text(title)]),
              p(
                id: 'alert-description',
                className: 'text-sm text-muted-foreground',
                children: [Text(description)],
              ),
            ],
          ),
          div(
            className:
                'flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2',
            children: [
              uiButton(
                label: cancelLabel,
                variant: UiButtonVariant.outline,
                className: 'mt-2 sm:mt-0',
                onPressed: (_) => onCancel(),
              ),
              uiButton(
                label: confirmLabel,
                variant: destructive
                    ? UiButtonVariant.destructive
                    : UiButtonVariant.defaultAction,
                onPressed: (_) => onConfirm(),
              ),
            ],
          ),
        ],
      )
    : fragment(const []);

/// A trigger wrapper for pages that own alert-dialog state.
ReactNode uiAlertDialogTrigger({
  required ReactNode child,
  required void Function() onPressed,
}) => span(
  role: 'button',
  additionalProps: {'tabindex': 0},
  onClick: (_) => onPressed(),
  children: [child],
);
