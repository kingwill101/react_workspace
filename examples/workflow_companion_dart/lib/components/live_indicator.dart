import 'package:react_dom/react_dom.dart';

import '../utils.dart';

/// Shows the live connection marker used by polling pages.
ReactNode liveIndicator({
  String? lastUpdated,
  bool refreshing = false,
  String? className,
}) => div(
  className: cn([
    'flex items-center gap-2 text-xs text-muted-foreground',
    className,
  ]),
  children: [
    span(
      className: 'relative flex h-2 w-2',
      children: [
        span(
          className: 'absolute inline-flex h-full w-full animate-ping rounded-full bg-success opacity-75',
        ),
        span(className: 'relative inline-flex h-2 w-2 rounded-full bg-success'),
      ],
    ),
    span(
      className: refreshing ? 'opacity-50' : null,
      children: [
        Text(
          refreshing
              ? 'Updating...'
              : lastUpdated == null
              ? 'Live'
              : 'Updated $lastUpdated',
        ),
      ],
    ),
  ],
);
