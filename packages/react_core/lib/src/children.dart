import 'node.dart';

/// Converts a scalar value to a React text node.
Text text(Object value) => Text('$value');

/// Groups [children] without adding a host element.
ReactNode fragment(ReactChildren children, {String? key}) =>
    Fragment(normalizeChildren(children), key: key);

/// Returns [child] when [condition] is true, otherwise an empty node.
///
/// This is useful in collection literals where a nullable child would be
/// less readable:
///
/// ```dart
/// div(children: [
///   text('Account'),
///   when(isAdmin, Badge('Admin')),
/// ]);
/// ```
ReactNode? when(bool condition, ReactNode child) => condition ? child : null;

/// Returns [child] when [condition] is false, otherwise an empty node.
ReactNode? unless(bool condition, ReactNode child) => when(!condition, child);

/// Builds one child for each item in [values].
///
/// The result is an iterable so it can be spread directly into a `children`
/// collection. Null results are handled by [normalizeChildren].
Iterable<ReactNode> each<T>(
  Iterable<T> values,
  ReactNode Function(T value, int index) builder,
) sync* {
  var index = 0;
  for (final value in values) {
    yield builder(value, index++);
  }
}
