import 'component_id.dart';
sealed class ReactNode { const ReactNode(); }

final class HostType<P extends Object?> {
  final String namespace; final String name;
  const HostType(this.namespace, this.name);
  @override String toString() => '$namespace:$name';
}

final class HostNode<P extends Object?> extends ReactNode {
  final HostType<P> type; final P props; final List<ReactNode> children; final String? key;
  const HostNode(this.type, this.props, {this.children = const [], this.key});
}

final class Component<P> extends ReactNode {
  final ComponentId id; final P props; final String? key; final List<ReactNode> children;
  const Component(this.id, this.props, {this.key, this.children=const []});
}
final class Text extends ReactNode { final String value; const Text(this.value); }
final class Fragment extends ReactNode { final List<ReactNode> children; final String? key; const Fragment(this.children,{this.key}); }
final class Empty extends ReactNode { const Empty(); }
