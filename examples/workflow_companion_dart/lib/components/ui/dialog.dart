import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

const _dialogContentClass =
    'fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg '
    'translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background '
    'p-6 text-foreground shadow-lg duration-200 sm:rounded-lg';

/// Renders the shared modal surface used by the translated Radix dialog.
///
/// Radix renders the overlay and content through a portal. This portable
/// version keeps those same two layers while using a native `dialog` as the
/// semantic root, so SSR and browser output share the same shape.
ReactNode uiDialogFrame({
  required ReactChildren children,
  String role = 'dialog',
  String? className,
  Map<String, Object?> additionalProps = const {},
}) => dialog(
  open: true,
  className:
      'fixed inset-0 z-50 m-0 h-screen w-screen max-h-none max-w-none '
      'border-0 bg-black/80 p-0 text-foreground',
  role: role,
  additionalProps: {'aria-modal': true, ...additionalProps},
  children: [
    div(className: cn([_dialogContentClass, className]), children: children),
  ],
);

/// A small portable dialog primitive. It uses a real HTML dialog node so the
/// same tree can be emitted by SSR and upgraded by the browser.
ReactNode uiDialog({
  required bool open,
  required String title,
  String? description,
  required ReactChildren children,
  required void Function(bool open) onOpenChange,
  ReactChildren? footer,
  String? className,
}) {
  if (!open) return fragment(const []);
  return uiDialogFrame(
    className: className,
    children: [
      div(
        className: 'flex flex-col space-y-1.5 text-center sm:text-left',
        children: [
          h2(
            className: 'text-lg font-semibold leading-none tracking-tight',
            children: [Text(title)],
          ),
          if (description != null)
            p(
              className: 'text-sm text-muted-foreground',
              children: [Text(description)],
            ),
        ],
      ),
      ...children,
      div(
        className:
            'absolute right-4 top-4 rounded-sm opacity-70 transition-opacity '
            'hover:opacity-100 focus:outline-none focus:ring-2 '
            'focus:ring-ring focus:ring-offset-2',
        children: [
          button(
            type: 'button',
            additionalProps: {'aria-label': 'Close'},
            onClick: (_) => onOpenChange(false),
            className: 'rounded-sm p-1 text-muted-foreground',
            children: const [Text('×')],
          ),
        ],
      ),
      if (footer != null)
        div(
          className:
              'flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2',
          children: footer,
        ),
    ],
  );
}
