import 'dart:math' as math;

import 'package:react_dom/react_dom.dart';

/// Small SVG-free sparkline representation for portable SSR output.
///
/// The reference uses an SVG path. A row of bars has the same information
/// density while keeping the component available to the neutral host layer.
ReactNode miniSparklineComponent(
  Iterable<num> values, {
  String color = 'bg-primary',
  String? className,
}) {
  final data = values.map((value) => value.toDouble()).toList();
  if (data.isEmpty) return span(className: className);
  final maximum = data.reduce(math.max);
  final minimum = data.reduce(math.min);
  final range = maximum - minimum == 0 ? 1 : maximum - minimum;
  return div(
    className: 'flex h-6 items-end gap-px ${className ?? ''}',
    additionalProps: {'aria-label': 'Recent trend'},
    children: [
      for (final value in data)
        span(
          className: 'w-1 rounded-t $color',
          style: {
            'height': '${4 + ((value - minimum) / range * 20).round()}px',
          },
        ),
    ],
  );
}

/// Deterministic trend data used in the queue cards.
List<double> generateSparklineData({int points = 12, double base = 50}) => [
  for (var index = 0; index < points; index++)
    math.max(0, base + ((index * 17) % 13) - 6),
];
