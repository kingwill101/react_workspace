import 'package:react_dom/react_dom.dart';

import '../utils.dart';

/// A dashboard KPI card.
ReactNode metricCardComponent({
  required String title,
  required Object value,
  String? subtitle,
  required String glyph,
  int? trend,
  bool positive = true,
  String? className,
  String? key,
}) => div(
  key: key,
  className: cn([
    'relative rounded-xl border border-border bg-card p-5 gradient-border transition-all duration-300 hover:border-primary/30',
    className,
  ]),
  children: [
    div(
      className: 'flex items-start justify-between',
      children: [
        div(
          className: 'space-y-1',
          children: [
            p(
              className: 'text-sm font-medium text-muted-foreground',
              children: [Text(title)],
            ),
            p(
              className: 'text-3xl font-semibold tracking-tight',
              children: [Text('$value')],
            ),
            if (subtitle != null)
              p(
                className: 'text-xs text-muted-foreground',
                children: [Text(subtitle)],
              ),
          ],
        ),
        div(
          className: 'rounded-lg bg-primary/10 p-2.5 text-primary',
          children: [
            span(className: 'text-xl', role: 'img', children: [Text(glyph)]),
          ],
        ),
      ],
    ),
    if (trend != null)
      div(
        className: 'mt-3 flex items-center gap-1.5',
        children: [
          span(
            className: positive
                ? 'text-xs font-medium text-success'
                : 'text-xs font-medium text-destructive',
            children: [Text('${positive ? '+' : ''}$trend%')],
          ),
          span(
            className: 'text-xs text-muted-foreground',
            children: const [Text('from last hour')],
          ),
        ],
      ),
  ],
);
