import 'component_id.dart';

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

/// Creates a node for a component registered by a JavaScript/TypeScript
/// module.
ForeignComponent foreignComponent(
  String name, {
  Map<String, Object?> props = const {},
  String? key,
  List<ReactNode> children = const [],
}) => ForeignComponent(name, props: props, key: key, children: children);
