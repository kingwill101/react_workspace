import 'package:react_dom/react_dom.dart';

import '../hooks/use_data_table.dart';
import '../utils.dart';
import '../components/ui/button.dart';
import '../components/ui/table.dart';

/// A sortable table heading matching the reference `DataTableHeader`.
ReactNode dataTableHeader({
  required String label,
  String? sortKey,
  SortConfig? sortConfig,
  void Function(String key)? onSort,
  String? className,
}) {
  if (sortKey == null || onSort == null) {
    return uiTableHead(label, className: className);
  }
  final active = sortConfig?.key == sortKey;
  final glyph = !active
      ? '↕'
      : sortConfig!.direction == SortDirection.asc
      ? '↑'
      : '↓';
  return th(
    className: cn([
      'h-12 px-4 text-left align-middle font-medium text-muted-foreground hover:bg-secondary/50',
      className,
    ]),
    children: [
      button(
        type: 'button',
        className: 'flex items-center gap-1.5 font-medium',
        onClick: (_) => onSort(sortKey),
        children: [
          Text(label),
          span(
            className: active ? 'text-primary' : 'text-muted-foreground/50',
            children: [Text(glyph)],
          ),
        ],
      ),
    ],
  );
}

/// Pagination controls for a filtered table.
ReactNode dataTablePagination({
  required int currentPage,
  required int totalPages,
  required int totalItems,
  int pageSize = 10,
  required void Function(int page) onPageChange,
  String? key,
}) {
  if (totalPages <= 1) return fragment(const []);
  final start = (currentPage - 1) * pageSize + 1;
  final end = mathMin(currentPage * pageSize, totalItems);
  return div(
    key: key,
    className:
        'flex items-center justify-between border-t border-border px-4 py-3',
    children: [
      p(
        className: 'text-sm text-muted-foreground',
        children: [Text('Showing $start to $end of $totalItems results')],
      ),
      div(
        className: 'flex items-center gap-1',
        children: [
          uiButton(
            label: '«',
            variant: UiButtonVariant.outline,
            size: UiButtonSize.icon,
            disabled: currentPage == 1,
            onPressed: (_) => onPageChange(1),
          ),
          uiButton(
            label: '‹',
            variant: UiButtonVariant.outline,
            size: UiButtonSize.icon,
            disabled: currentPage == 1,
            onPressed: (_) => onPageChange(currentPage - 1),
          ),
          span(
            className: 'px-3 text-sm text-muted-foreground',
            children: [Text('Page $currentPage of $totalPages')],
          ),
          uiButton(
            label: '›',
            variant: UiButtonVariant.outline,
            size: UiButtonSize.icon,
            disabled: currentPage == totalPages,
            onPressed: (_) => onPageChange(currentPage + 1),
          ),
          uiButton(
            label: '»',
            variant: UiButtonVariant.outline,
            size: UiButtonSize.icon,
            disabled: currentPage == totalPages,
            onPressed: (_) => onPageChange(totalPages),
          ),
        ],
      ),
    ],
  );
}

int mathMin(int left, int right) => left < right ? left : right;
