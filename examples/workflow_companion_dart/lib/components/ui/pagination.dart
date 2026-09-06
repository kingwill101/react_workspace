import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// Pagination metadata shared by the translated pagination primitives.
final class UiPaginationState {
  /// Creates pagination state.
  const UiPaginationState({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  bool get canGoPrevious => currentPage > 1;
  bool get canGoNext => currentPage < totalPages;
}

/// A semantic pagination navigation region.
ReactNode uiPagination({
  required UiPaginationState state,
  required void Function(int page) onPageChanged,
  String? className,
}) => nav(
  className: cn(['mx-auto flex w-full justify-center', className]),
  role: 'navigation',
  additionalProps: {'aria-label': 'Pagination'},
  children: [
    ul(
      className: 'flex flex-row items-center gap-1',
      children: [
        li(
          children: [
            uiPaginationLink(
              label: 'Previous',
              page: state.currentPage - 1,
              enabled: state.canGoPrevious,
              onPressed: onPageChanged,
            ),
          ],
        ),
        for (final page in _pageWindow(state))
          if (page == null)
            li(children: [uiPaginationEllipsis()])
          else
            li(
              children: [
                uiPaginationLink(
                  label: '$page',
                  page: page,
                  active: page == state.currentPage,
                  onPressed: onPageChanged,
                ),
              ],
            ),
        li(
          children: [
            uiPaginationLink(
              label: 'Next',
              page: state.currentPage + 1,
              enabled: state.canGoNext,
              onPressed: onPageChanged,
            ),
          ],
        ),
      ],
    ),
  ],
);

/// A pagination item with disabled and current-page affordances.
ReactNode uiPaginationLink({
  required String label,
  required int page,
  required void Function(int page) onPressed,
  bool active = false,
  bool enabled = true,
}) => uiButton(
  label: label,
  variant: active ? UiButtonVariant.outline : UiButtonVariant.ghost,
  size: label.length > 2 ? UiButtonSize.defaultSize : UiButtonSize.icon,
  disabled: !enabled,
  className: label.length > 2 ? 'gap-1 px-2.5' : null,
  onPressed: enabled ? (_) => onPressed(page) : null,
);

/// An ellipsis item for truncated page ranges.
ReactNode uiPaginationEllipsis() => span(
  className: 'flex h-9 w-9 items-center justify-center',
  additionalProps: {'aria-hidden': true},
  children: const [Text('…')],
);

List<int?> _pageWindow(UiPaginationState state) {
  if (state.totalPages <= 5) {
    return [for (var page = 1; page <= state.totalPages; page++) page];
  }
  if (state.currentPage <= 3) return [1, 2, 3, null, state.totalPages];
  if (state.currentPage >= state.totalPages - 2) {
    return [
      1,
      null,
      state.totalPages - 2,
      state.totalPages - 1,
      state.totalPages,
    ];
  }
  return [
    1,
    null,
    state.currentPage - 1,
    state.currentPage,
    state.currentPage + 1,
    null,
    state.totalPages,
  ];
}
