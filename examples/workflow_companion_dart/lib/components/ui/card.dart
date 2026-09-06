import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// The base card container.
ReactNode uiCard({ReactChildren children = const [], String? className}) => div(
  className: cn([
    'rounded-xl border bg-card text-card-foreground shadow',
    className,
  ]),
  children: children,
);

/// Card header layout.
ReactNode uiCardHeader({
  ReactChildren children = const [],
  String? className,
}) => div(
  className: cn(['flex flex-col space-y-1.5 p-6', className]),
  children: children,
);

/// Card title.
ReactNode uiCardTitle(String title, {String? className}) => h3(
  className: cn([
    'text-2xl font-semibold leading-none tracking-tight',
    className,
  ]),
  children: [Text(title)],
);

/// Card description.
ReactNode uiCardDescription(String description, {String? className}) => p(
  className: cn(['text-sm text-muted-foreground', className]),
  children: [Text(description)],
);

/// Card body layout.
ReactNode uiCardContent({
  ReactChildren children = const [],
  String? className,
}) => div(className: cn(['p-6 pt-0', className]), children: children);

/// Card footer layout.
ReactNode uiCardFooter({
  ReactChildren children = const [],
  String? className,
}) => div(
  className: cn(['flex items-center p-6 pt-0', className]),
  children: children,
);
