import 'package:react_core/react.dart';

/// The direction used by [SortConfig].
enum SortDirection { asc, desc }

/// Describes the field and direction used to order a data table.
final class SortConfig {
  /// Creates a sort configuration for [key].
  const SortConfig(this.key, this.direction);

  /// The logical field name to sort.
  final String key;

  /// Whether values are ordered from low to high or high to low.
  final SortDirection direction;
}

/// Reads a named field from one row.
typedef DataTableValue<T> = Object? Function(T row, String key);

/// A stateful, typed translation of the reference `useDataTable` hook.
///
/// The reference hook accepts JavaScript records and indexes them by string.
/// Dart callers provide [valueOf] when their rows are model objects. Maps are
/// supported automatically, which keeps the API convenient for API payloads.
final class DataTableController<T> {
  const DataTableController({
    required this.paginatedData,
    required this.filteredData,
    required this.totalItems,
    required this.search,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.sortConfig,
    required this.filters,
    required this.setSearch,
    required this.setCurrentPage,
    required this.nextPage,
    required this.prevPage,
    required this.toggleSort,
    required this.setFilter,
    required this.clearFilters,
  });

  /// Rows visible on the current page.
  final List<T> paginatedData;

  /// Rows after search, filters, and sorting, before pagination.
  final List<T> filteredData;

  /// Number of rows after search and filtering.
  final int totalItems;

  /// Current search query.
  final String search;

  /// One-based current page index.
  final int currentPage;

  /// Number of pages for the filtered result.
  final int totalPages;

  /// Whether [nextPage] can advance.
  final bool hasNextPage;

  /// Whether [prevPage] can go backwards.
  final bool hasPrevPage;

  /// Active sort configuration, if any.
  final SortConfig? sortConfig;

  /// Active field filters.
  final Map<String, List<String>> filters;

  /// Updates the search query and returns to the first page.
  final void Function(String value) setSearch;

  /// Moves to a one-based page number.
  final void Function(int page) setCurrentPage;

  /// Moves forward while staying within the available pages.
  final void Function() nextPage;

  /// Moves backward while staying on or above page one.
  final void Function() prevPage;

  /// Cycles a field through ascending, descending, and unsorted states.
  final void Function(String key) toggleSort;

  /// Replaces one field's selected filter values and returns to page one.
  final void Function(String key, List<String> values) setFilter;

  /// Clears search, filters, and pagination.
  final void Function() clearFilters;
}

/// Mirrors the reference hook's options for [useDataTable].
final class DataTableOptions<T> {
  /// Creates table options.
  const DataTableOptions({
    required this.data,
    this.pageSize = 10,
    this.searchKeys = const [],
    this.initialSort,
    this.valueOf,
  });

  /// Source rows.
  final List<T> data;

  /// Maximum number of rows per page.
  final int pageSize;

  /// Fields searched by [setSearch].
  final List<String> searchKeys;

  /// Initial sort state.
  final SortConfig? initialSort;

  /// Model-field reader. Maps are read by key when omitted.
  final DataTableValue<T>? valueOf;
}

/// Provides search, filters, sorting, and pagination for a table component.
///
/// This is intentionally a hook rather than a mutable data helper: each
/// setter schedules a React render through the active renderer, matching the
/// semantics of the original TypeScript implementation.
DataTableController<T> useDataTable<T>(DataTableOptions<T> options) {
  final (search, setSearchState) = useState('');
  final (currentPage, setCurrentPageState) = useState(1);
  final (sortConfig, setSortConfig) = useState<SortConfig?>(
    options.initialSort,
  );
  final (filters, setFilters) = useState<Map<String, List<String>>>({});

  Object? valueOf(T row, String key) {
    if (options.valueOf != null) return options.valueOf!(row, key);
    if (row is Map) return row[key];
    return null;
  }

  final filteredData = useMemo(
    () {
      var result = List<T>.of(options.data);

      if (search.isNotEmpty && options.searchKeys.isNotEmpty) {
        final query = search.toLowerCase();
        result = result.where((row) {
          return options.searchKeys.any((key) {
            final value = valueOf(row, key);
            return value != null &&
                value.toString().toLowerCase().contains(query);
          });
        }).toList();
      }

      for (final entry in filters.entries) {
        if (entry.value.isEmpty) continue;
        result = result.where((row) {
          return entry.value.contains(valueOf(row, entry.key).toString());
        }).toList();
      }

      final activeSort = sortConfig;
      if (activeSort != null) {
        result.sort((a, b) {
          final left = valueOf(a, activeSort.key);
          final right = valueOf(b, activeSort.key);
          final comparison = _compareValues(left, right);
          return activeSort.direction == SortDirection.asc
              ? comparison
              : -comparison;
        });
      }

      return result;
    },
    [
      options.data,
      options.searchKeys,
      options.valueOf,
      search,
      filters,
      sortConfig,
    ],
  );

  final pageSize = options.pageSize < 1 ? 1 : options.pageSize;
  final totalPages = (filteredData.length / pageSize).ceil();
  final safeTotalPages = totalPages == 0 ? 1 : totalPages;
  final safePage = currentPage.clamp(1, safeTotalPages);
  final paginatedData = useMemo(() {
    final start = (safePage - 1) * pageSize;
    return filteredData.skip(start).take(pageSize).toList();
  }, [filteredData, safePage, pageSize]);

  void setSearch(String value) {
    setSearchState(value);
    setCurrentPageState(1);
  }

  void setCurrentPage(int page) {
    setCurrentPageState(page.clamp(1, safeTotalPages));
  }

  void nextPage() {
    setCurrentPageState.update((page) => (page + 1).clamp(1, safeTotalPages));
  }

  void prevPage() {
    setCurrentPageState.update((page) => (page - 1).clamp(1, safeTotalPages));
  }

  void toggleSort(String key) {
    setSortConfig.update((previous) {
      if (previous?.key != key) return SortConfig(key, SortDirection.asc);
      if (previous!.direction == SortDirection.asc) {
        return SortConfig(key, SortDirection.desc);
      }
      return null;
    });
  }

  void setFilter(String key, List<String> values) {
    setFilters.update((previous) {
      final next = Map<String, List<String>>.of(previous);
      next[key] = List<String>.of(values);
      return next;
    });
    setCurrentPageState(1);
  }

  void clearFilters() {
    setFilters(<String, List<String>>{});
    setSearchState('');
    setCurrentPageState(1);
  }

  return DataTableController<T>(
    paginatedData: paginatedData,
    filteredData: filteredData,
    totalItems: filteredData.length,
    search: search,
    currentPage: safePage,
    totalPages: totalPages,
    hasNextPage: safePage < totalPages,
    hasPrevPage: safePage > 1,
    sortConfig: sortConfig,
    filters: filters,
    setSearch: setSearch,
    setCurrentPage: setCurrentPage,
    nextPage: nextPage,
    prevPage: prevPage,
    toggleSort: toggleSort,
    setFilter: setFilter,
    clearFilters: clearFilters,
  );
}

int _compareValues(Object? left, Object? right) {
  if (left == right) return 0;
  if (left == null) return -1;
  if (right == null) return 1;
  if (left is Comparable && right.runtimeType == left.runtimeType) {
    return left.compareTo(right);
  }
  return left.toString().compareTo(right.toString());
}
