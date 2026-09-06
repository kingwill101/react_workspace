import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// A horizontal separator matching the shadcn separator primitive.
ReactNode uiSeparator({String? className, bool vertical = false}) => div(
  className: cn([
    'shrink-0 bg-border',
    vertical ? 'h-full w-px' : 'h-px w-full',
    className,
  ]),
  role: 'separator',
  additionalProps: {'aria-orientation': vertical ? 'vertical' : 'horizontal'},
  children: const [],
);

/// An accessible controlled switch built from a portable button.
ReactNode uiSwitch({
  required bool checked,
  required void Function(bool) onChanged,
  String? label,
  String? className,
}) => button(
  type: 'button',
  role: 'switch',
  className: cn([
    'relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors',
    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
    checked ? 'bg-primary' : 'bg-input',
    className,
  ]),
  additionalProps: {'aria-checked': checked, 'aria-label': label},
  onClick: (_) => onChanged(!checked),
  children: [
    span(
      className: cn([
        'pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform',
        checked ? 'translate-x-5' : 'translate-x-0',
      ]),
      children: const [],
    ),
  ],
);

/// A progress meter with an optional visible percentage label.
ReactNode uiProgress({
  required double value,
  String? className,
  bool showLabel = false,
}) {
  final normalized = value.clamp(0, 100).toDouble();
  return div(
    className: cn(['space-y-1', className]),
    children: [
      if (showLabel)
        div(
          className: 'flex justify-between text-xs text-muted-foreground',
          children: [const Text('Progress'), Text('${normalized.round()}%')],
        ),
      div(
        className: 'h-2 w-full overflow-hidden rounded-full bg-secondary',
        role: 'progressbar',
        additionalProps: {
          'aria-valuemin': 0,
          'aria-valuemax': 100,
          'aria-valuenow': normalized,
        },
        children: [
          div(
            className: 'h-full rounded-full bg-primary transition-all',
            style: {'width': '$normalized%'},
            children: const [],
          ),
        ],
      ),
    ],
  );
}

/// A compact avatar with a deterministic initials fallback.
ReactNode uiAvatar({
  required String name,
  String? imageUrl,
  String? className,
}) => div(
  className: cn([
    'flex h-9 w-9 shrink-0 items-center justify-center overflow-hidden rounded-full bg-primary/15 text-sm font-medium text-primary',
    className,
  ]),
  children: [
    if (imageUrl != null)
      img(src: imageUrl, alt: name, className: 'h-full w-full object-cover')
    else
      Text(_initials(name)),
  ],
);

/// A non-interactive loading placeholder.
ReactNode uiSkeleton({String? className}) => div(
  className: cn(['animate-pulse rounded-md bg-muted', className]),
  additionalProps: {'aria-hidden': true},
  children: const [],
);

/// An alert panel for inline success, warning, or error feedback.
ReactNode uiAlert({
  required String title,
  String? description,
  UiAlertTone tone = UiAlertTone.info,
  String? className,
}) => div(
  className: cn([
    'relative w-full rounded-lg border p-4',
    switch (tone) {
      UiAlertTone.info => 'border-primary/30 bg-primary/10 text-primary',
      UiAlertTone.success => 'border-success/30 bg-success/10 text-success',
      UiAlertTone.warning => 'border-warning/30 bg-warning/10 text-warning',
      UiAlertTone.error =>
        'border-destructive/30 bg-destructive/10 text-destructive',
    },
    className,
  ]),
  role: 'alert',
  children: [
    p(className: 'font-medium', children: [Text(title)]),
    if (description != null)
      p(className: 'mt-1 text-sm opacity-90', children: [Text(description)]),
  ],
);

/// Tones supported by [uiAlert].
enum UiAlertTone { info, success, warning, error }

/// A small tab-list container. Selection remains owned by the page.
ReactNode uiTabsList({required ReactChildren children, String? className}) =>
    div(
      className: cn([
        'inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground',
        className,
      ]),
      role: 'tablist',
      children: children,
    );

/// A controlled tab trigger.
ReactNode uiTabTrigger({
  required String label,
  required bool selected,
  required void Function() onSelected,
  String? className,
}) => button(
  type: 'button',
  role: 'tab',
  className: cn([
    'inline-flex h-8 items-center justify-center rounded-sm px-3 text-sm font-medium transition-all',
    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
    selected
        ? 'bg-background text-foreground shadow-sm'
        : 'hover:bg-background/50',
    className,
  ]),
  additionalProps: {'aria-selected': selected},
  onClick: (_) => onSelected(),
  children: [Text(label)],
);

/// A breadcrumb list composed of ordinary accessible links.
ReactNode uiBreadcrumb({
  required List<({String label, String? href})> items,
  String? className,
}) => nav(
  className: className,
  additionalProps: {'aria-label': 'Breadcrumb'},
  children: [
    ol(
      className:
          'flex flex-wrap items-center gap-2 text-sm text-muted-foreground',
      children: [
        for (final (index, item) in items.indexed) ...[
          if (index > 0) const [Text('/')],
          li(
            children: [
              if (item.href != null)
                a(
                  additionalProps: {'href': item.href},
                  className: 'hover:text-foreground hover:underline',
                  children: [Text(item.label)],
                )
              else
                span(
                  className: 'text-foreground',
                  children: [Text(item.label)],
                ),
            ],
          ),
        ],
      ],
    ),
  ],
);

/// Pagination controls for a page-indexed list.
ReactNode uiPagination({
  required int currentPage,
  required int totalPages,
  required void Function(int) onPageChange,
}) => div(
  className: 'flex items-center justify-end gap-2',
  children: [
    uiButton(
      label: 'Previous',
      variant: UiButtonVariant.outline,
      size: UiButtonSize.sm,
      disabled: currentPage <= 1,
      onPressed: (_) => onPageChange(currentPage - 1),
    ),
    span(
      className: 'text-sm text-muted-foreground',
      children: [Text('$currentPage / $totalPages')],
    ),
    uiButton(
      label: 'Next',
      variant: UiButtonVariant.outline,
      size: UiButtonSize.sm,
      disabled: currentPage >= totalPages,
      onPressed: (_) => onPageChange(currentPage + 1),
    ),
  ],
);

String _initials(String name) => name
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .map((part) => part[0])
    .take(2)
    .join()
    .toUpperCase();
