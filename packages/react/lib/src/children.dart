import 'node.dart';

/// Converts a scalar value to a React text node.
Text text(Object value) => Text('$value');

/// Groups [children] without adding a host element.
ReactNode fragment(ReactChildren children, {String? key}) =>
    Fragment(normalizeChildren(children), key: key);
