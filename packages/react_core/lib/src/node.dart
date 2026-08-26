import 'component_id.dart';

/// Values accepted by ergonomic React child APIs.
///
/// Renderers continue to receive a normalized [List] of [ReactNode] values.
/// This input type intentionally accepts nested iterables so ordinary Dart
/// collection-if, collection-for, and spread expressions remain convenient.
typedef ReactChildren = Iterable<Object?>;

abstract class ReactNode {
  const ReactNode();
}

final class HostType<P extends Object?> {
  final String namespace;
  final String name;
  const HostType(this.namespace, this.name);
  @override
  String toString() => '$namespace:$name';
}

final class HostNode<P extends Object?> extends ReactNode {
  final HostType<P> type;
  final P props;
  final List<ReactNode> children;
  final String? key;
  const HostNode(this.type, this.props, {this.children = const [], this.key});
}

/// A component implemented by a JavaScript/TypeScript React module.
///
/// The name is resolved from `globalThis.__reactDartForeignComponents`, which
/// lets Dart components use TSX without importing browser-only JS interop into
/// the portable React tree model.
final class ForeignComponent extends ReactNode {
  final String name;
  final Map<String, Object?> props;
  final String? key;
  final List<ReactNode> children;

  const ForeignComponent(
    this.name, {
    this.props = const {},
    this.key,
    this.children = const [],
  });
}

final class Component<P> extends ReactNode {
  final ComponentId id;
  final P props;
  final String? key;
  final List<ReactNode> children;
  const Component(this.id, this.props, {this.key, this.children = const []});
}

final class Text extends ReactNode {
  final String value;
  const Text(this.value);
}

/// A React value received from a renderer-specific component boundary.
///
/// Generated bridges use this node to preserve children that React supplies
/// as native elements. Applications normally create portable nodes instead.
final class OpaqueReactNode extends ReactNode {
  final Object value;

  const OpaqueReactNode(this.value);
}

/// Groups children without adding a host element.
///
/// See https://react.dev/reference/react/Fragment.
final class Fragment extends ReactNode {
  final List<ReactNode> children;
  final String? key;
  const Fragment(this.children, {this.key});
}

final class Empty extends ReactNode {
  const Empty();
}

/// Normalizes Dart-friendly child values into the portable React node model.
///
/// Supported values are [ReactNode], [String], [num], nested [Iterable]
/// values, `null`, and booleans. Like React, `null` and booleans render
/// nothing. Unsupported values fail early with a descriptive error.
List<ReactNode> normalizeChildren(ReactChildren children) {
  final normalized = <ReactNode>[];

  void append(Object? child) {
    switch (child) {
      case null || bool():
        return;
      case ReactNode():
        normalized.add(child);
      case String():
        normalized.add(Text(child));
      case num():
        normalized.add(Text('$child'));
      case Iterable<Object?>():
        for (final nested in child) {
          append(nested);
        }
      default:
        throw ArgumentError.value(
          child,
          'children',
          'Expected a ReactNode, String, number, boolean, null, or Iterable.',
        );
    }
  }

  for (final child in children) {
    append(child);
  }
  return normalized;
}

/// Creates a node for a component registered by a JavaScript/TypeScript
/// module.
ForeignComponent foreignComponent(
  String name, {
  Map<String, Object?> props = const {},
  String? key,
  ReactChildren children = const [],
}) => ForeignComponent(
  name,
  props: props,
  key: key,
  children: normalizeChildren(children),
);
