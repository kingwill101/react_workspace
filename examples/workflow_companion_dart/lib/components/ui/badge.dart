import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// Badge variants used by filters, plans, and status summaries.
enum UiBadgeVariant { defaultBadge, secondary, destructive, outline }

/// Builds a compact badge.
ReactNode uiBadge({
  required String label,
  UiBadgeVariant variant = UiBadgeVariant.defaultBadge,
  String? className,
}) => span(
  className: cn([
    'inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors',
    switch (variant) {
      UiBadgeVariant.defaultBadge =>
        'border-transparent bg-primary text-primary-foreground',
      UiBadgeVariant.secondary =>
        'border-transparent bg-secondary text-secondary-foreground',
      UiBadgeVariant.destructive =>
        'border-transparent bg-destructive text-destructive-foreground',
      UiBadgeVariant.outline => 'text-foreground',
    },
    className,
  ]),
  children: [Text(label)],
);
