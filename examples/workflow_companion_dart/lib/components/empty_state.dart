import 'package:react_dom/react_dom.dart';

import '../utils.dart';
import '../ui/ui.dart' show appButton;

/// Generic empty-state content with primary and secondary actions.
ReactNode emptyStateComponent({
  required String glyph,
  required String title,
  required String description,
  String? action,
  void Function(ReactMouseEvent)? onAction,
  String? secondaryAction,
  void Function(ReactMouseEvent)? onSecondaryAction,
  String? secondaryHref,
  String? className,
}) => div(
  className: cn([
    'flex flex-col items-center justify-center px-4 py-16 text-center',
    className,
  ]),
  children: [
    div(
      className: 'mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-muted text-3xl',
      children: [Text(glyph)],
    ),
    h3(className: 'mb-2 text-lg font-semibold', children: [Text(title)]),
    p(
      className: 'mb-6 max-w-md text-muted-foreground',
      children: [Text(description)],
    ),
    if (action != null || secondaryAction != null)
      div(
        className: 'flex items-center gap-3',
        children: [
          if (action != null) appButton(label: action, onClick: onAction),
          if (secondaryAction != null)
            appButton(
              label: secondaryAction,
              variant: 'outline',
              href: secondaryHref,
              onClick: secondaryHref == null ? onSecondaryAction : null,
            ),
        ],
      ),
  ],
);

/// The gateway-specific empty state shown by data pages before connection.
ReactNode gatewayConnectionEmptyState({
  required void Function() onConnect,
  void Function()? onLearnMore,
  String? learnMoreHref,
}) => emptyStateComponent(
  glyph: '⌁',
  title: 'Connect Your Gateway',
  description: 'To view workflows, tasks, and jobs, connect your durable workflow gateway. The gateway syncs your infrastructure data in real time.',
  action: 'Connect Gateway',
  onAction: (_) => onConnect(),
  secondaryAction: onLearnMore == null && learnMoreHref == null
      ? null
      : 'Learn More',
  onSecondaryAction: learnMoreHref == null && onLearnMore != null
      ? (_) => onLearnMore()
      : null,
  secondaryHref: learnMoreHref,
  className: 'rounded-xl border border-dashed border-border bg-muted/20 py-20',
);
