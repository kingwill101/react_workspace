import 'component_id.dart';
sealed class ReactNode { const ReactNode(); }
final class Intrinsic extends ReactNode {
  final String tag; final Map<String,Object?> props; final List<ReactNode> children; final String? key;
  const Intrinsic(this.tag, {this.props=const {}, this.children=const [], this.key});
}
final class Component<P> extends ReactNode {
  final ComponentId id; final P props; final String? key; final List<ReactNode> children;
  const Component(this.id, this.props, {this.key, this.children=const []});
}
final class Text extends ReactNode { final String value; const Text(this.value); }
final class Fragment extends ReactNode { final List<ReactNode> children; final String? key; const Fragment(this.children,{this.key}); }
final class Empty extends ReactNode { const Empty(); }
