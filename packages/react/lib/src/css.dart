/// Joins conditional class names into one stable string.
///
/// Strings, iterables, maps, and null/boolean values are accepted. Map keys
/// are included when their values are true. This makes the helper suitable for
/// Tailwind utilities and small variant systems without tying the runtime to a
/// CSS framework.
String joinClassNames(
  Object? first, [
  Object? second,
  Object? third,
  Object? fourth,
]) {
  final values = <Object?>[first, second, third, fourth];
  final classes = <String>[];

  void add(Object? value) {
    switch (value) {
      case null || false:
        return;
      case true:
        return;
      case String():
        if (value.trim().isNotEmpty) {
          classes.add(value.trim());
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
  return classes.join(' ');
}
