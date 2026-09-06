import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// Toast tone variants used by the portable notification surface.
enum UiToastVariant { defaultVariant, destructive }

/// A single notification record.
final class UiToastRecord {
  /// Creates a toast record.
  const UiToastRecord({
    required this.id,
    required this.title,
    this.description,
    this.variant = UiToastVariant.defaultVariant,
    this.action,
  });

  final String id;
  final String title;
  final String? description;
  final UiToastVariant variant;
  final ReactNode? action;
}

/// Renders one toast record.
ReactNode uiToastPrimitive({
  required UiToastRecord toast,
  required void Function() onClose,
  String? className,
}) => div(
  className: cn([
    'pointer-events-auto relative flex w-full items-start justify-between gap-4 rounded-md border p-4 shadow-lg',
    toast.variant == UiToastVariant.destructive
        ? 'border-destructive bg-destructive text-destructive-foreground'
        : 'border-border bg-background text-foreground',
    className,
  ]),
  role: 'status',
  children: [
    div(
      className: 'grid gap-1',
      children: [
        p(className: 'text-sm font-semibold', children: [Text(toast.title)]),
        if (toast.description != null)
          p(
            className: 'text-sm opacity-90',
            children: [Text(toast.description!)],
          ),
        if (toast.action != null) toast.action!,
      ],
    ),
    button(
      type: 'button',
      className: 'rounded-md p-1 opacity-70 hover:opacity-100',
      additionalProps: {'aria-label': 'Close notification'},
      onClick: (_) => onClose(),
      children: const [Text('×')],
    ),
  ],
);

/// A toast viewport. The queue is supplied by a page or a context provider.
ReactNode uiToastViewport({
  required List<UiToastRecord> toasts,
  required void Function(String id) onDismiss,
  String? className,
}) => div(
  className: cn([
    'fixed right-0 top-0 z-[100] flex max-h-screen w-full flex-col gap-2 p-4 sm:max-w-[420px]',
    className,
  ]),
  role: 'region',
  additionalProps: {'aria-label': 'Notifications'},
  children: [
    for (final toast in toasts)
      uiToastPrimitive(toast: toast, onClose: () => onDismiss(toast.id)),
  ],
);

/// Creates a simple action button for use as [UiToastRecord.action].
ReactNode uiToastAction({
  required String label,
  required void Function() onPressed,
}) => uiButton(
  label: label,
  size: UiButtonSize.sm,
  variant: UiButtonVariant.outline,
  onPressed: (_) => onPressed(),
);
