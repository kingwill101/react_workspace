import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// A fixed aspect-ratio wrapper corresponding to shadcn's aspect-ratio root.
ReactNode uiAspectRatio({
  required double ratio,
  required ReactChildren children,
  String? className,
}) => div(
  className: cn(['relative w-full', className]),
  style: {'aspect-ratio': '$ratio'},
  children: children,
);

/// A clipped scrolling region that retains a visible scrollbar affordance.
ReactNode uiScrollArea({
  required ReactChildren children,
  String? orientation,
  String? className,
}) => div(
  className: cn([
    'relative overflow-auto',
    orientation == 'horizontal' ? 'overflow-x-auto overflow-y-hidden' : null,
    className,
  ]),
  children: [div(className: 'min-w-0', children: children)],
);

/// A resizable-layout model. The visual divider is deliberately passive in
/// the portable layer; applications can update [sizes] from their own input.
ReactNode uiResizablePanelGroup({
  required List<double> sizes,
  required List<ReactChildren> panels,
  String direction = 'horizontal',
  String? className,
}) => div(
  className: cn([
    'flex h-full w-full',
    direction == 'vertical' ? 'flex-col' : null,
    className,
  ]),
  additionalProps: {'data-panel-group-direction': direction},
  children: [
    for (final (index, panel) in panels.indexed) ...[
      div(
        className: 'min-h-0 min-w-0',
        style: {
          direction == 'vertical' ? 'height' : 'width':
              '${(sizes.elementAtOrNull(index) ?? 1) * 100}%',
        },
        children: panel,
      ),
      if (index < panels.length - 1)
        div(
          className: direction == 'vertical'
              ? 'h-px w-full shrink-0 bg-border'
              : 'w-px shrink-0 bg-border',
          role: 'separator',
          children: const [],
        ),
    ],
  ],
);

/// A drawer-like side surface for mobile settings and detail views.
ReactNode uiDrawer({
  required bool open,
  required String title,
  required ReactChildren children,
  required void Function(bool) onOpenChange,
  String side = 'right',
}) => open
    ? aside(
        className: cn([
          'fixed inset-y-0 z-50 w-full max-w-md overflow-auto border-border bg-background p-6 shadow-xl',
          side == 'left' ? 'left-0 border-r' : 'right-0 border-l',
        ]),
        role: 'dialog',
        children: [
          div(
            className: 'mb-6 flex items-center justify-between',
            children: [
              h2(className: 'text-lg font-semibold', children: [Text(title)]),
              button(
                type: 'button',
                className: 'rounded-md p-2 hover:bg-accent',
                additionalProps: {'aria-label': 'Close $title'},
                onClick: (_) => onOpenChange(false),
                children: const [Text('×')],
              ),
            ],
          ),
          ...children,
        ],
      )
    : fragment(const []);
