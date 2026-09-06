import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// A portable accordion root. The selected item remains owned by the page so
/// the primitive works in both SSR and browser builds without a Radix runtime.
ReactNode uiAccordionRoot({
  required ReactChildren children,
  String? className,
}) => div(
  className: cn(['w-full', className]),
  role: 'region',
  children: children,
);

/// A single accordion item with an optional open state.
ReactNode uiAccordionItem({
  required String value,
  required bool open,
  required ReactChildren children,
  String? className,
}) => div(
  className: cn(['border-b border-border', className]),
  additionalProps: {
    'data-accordion-value': value,
    'data-state': open ? 'open' : 'closed',
  },
  children: children,
);

/// The keyboard-accessible button that toggles an accordion item.
ReactNode uiAccordionTrigger({
  required String label,
  required bool open,
  required void Function() onPressed,
  String? className,
}) => button(
  type: 'button',
  className: cn([
    'flex w-full items-center justify-between py-4 text-left font-medium transition-all hover:underline',
    className,
  ]),
  additionalProps: {
    'aria-expanded': open,
    'aria-controls': 'accordion-content-$label',
  },
  onClick: (_) => onPressed(),
  children: [
    Text(label),
    span(
      className: cn([
        'text-muted-foreground transition-transform',
        open ? 'rotate-180' : null,
      ]),
      children: const [Text('⌄')],
    ),
  ],
);

/// The conditionally rendered accordion panel.
ReactNode uiAccordionContent({
  required String label,
  required bool open,
  required ReactChildren children,
  String? className,
}) => open
    ? div(
        id: 'accordion-content-$label',
        className: cn(['overflow-hidden pb-4 text-sm', className]),
        role: 'region',
        children: children,
      )
    : fragment(const []);
