/// Small class-name and display helpers shared by translated components.
library;

/// Joins strings, nested iterables, and truthy map keys like `clsx`.
///
/// This keeps the Dart port's public styling API close to the reference
/// `cn(...)` helper while remaining independent of Tailwind at runtime.
String cn(Iterable<Object?> values) {
  final result = <String>[];

  void add(Object? value) {
    switch (value) {
      case null || false || true:
        return;
      case String():
        if (value.trim().isNotEmpty) {
          result.add(value.trim());
        }
      case Iterable<Object?>():
        for (final item in value) {
          add(item);
        }
      case Map<Object?, Object?>():
        for (final entry in value.entries) {
          if (entry.value == true) {
            add(entry.key);
          }
        }
      default:
        add(value.toString());
    }
  }

  for (final value in values) {
    add(value);
  }
  return result.join(' ');
}

/// Formats an ISO timestamp for compact dashboard labels.
String formatDate(String? value) {
  if (value == null || value.isEmpty) return '—';
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  final local = date.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final meridiem = local.hour >= 12 ? 'PM' : 'AM';
  return '${local.month}/${local.day} $hour:$minute $meridiem';
}
