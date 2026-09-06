import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// A small, dependency-free calendar model used by schedule forms.
final class UiCalendarMonth {
  /// Creates a month from its first day.
  const UiCalendarMonth(this.year, this.month);

  final int year;
  final int month;

  /// Number of days in this month.
  int get dayCount => DateTime(year, month + 1, 0).day;

  /// Weekday offset before the first day, with Sunday as zero.
  int get leadingDays => DateTime(year, month, 1).weekday % 7;

  /// All visible cells, including leading and trailing empty cells.
  List<int?> get cells => [
    for (var index = 0; index < leadingDays; index++) null,
    for (var day = 1; day <= dayCount; day++) day,
  ];

  String get label => '${_monthNames[month - 1]} $year';
}

const _monthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Renders a semantic month grid without importing a browser-only date picker.
ReactNode uiCalendar({
  required UiCalendarMonth month,
  DateTime? selected,
  required void Function(DateTime date) onSelected,
  void Function()? onPrevious,
  void Function()? onNext,
  bool Function(DateTime date)? isDisabled,
  String? className,
}) => div(
  className: cn([
    'w-fit rounded-md border border-border bg-card p-3',
    className,
  ]),
  role: 'application',
  children: [
    div(
      className: 'mb-3 flex items-center justify-between',
      children: [
        uiButton(
          label: '‹',
          variant: UiButtonVariant.ghost,
          size: UiButtonSize.icon,
          onPressed: onPrevious == null ? null : (_) => onPrevious(),
        ),
        p(className: 'text-sm font-medium', children: [Text(month.label)]),
        uiButton(
          label: '›',
          variant: UiButtonVariant.ghost,
          size: UiButtonSize.icon,
          onPressed: onNext == null ? null : (_) => onNext(),
        ),
      ],
    ),
    div(
      className: 'grid grid-cols-7 gap-1 text-center',
      children: [
        for (final day in const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'])
          span(
            className: 'p-2 text-xs font-medium text-muted-foreground',
            children: [Text(day)],
          ),
        for (final day in month.cells)
          if (day == null)
            span(children: const [])
          else
            () {
              final date = DateTime(month.year, month.month, day);
              final disabled = isDisabled?.call(date) ?? false;
              final active =
                  selected?.year == date.year &&
                  selected?.month == date.month &&
                  selected?.day == date.day;
              return uiButton(
                label: '$day',
                variant: active
                    ? UiButtonVariant.defaultAction
                    : UiButtonVariant.ghost,
                size: UiButtonSize.icon,
                disabled: disabled,
                className: 'h-9 w-9 p-0',
                onPressed: disabled ? null : (_) => onSelected(date),
              );
            }(),
      ],
    ),
  ],
);
