import 'component_id.dart';
import 'node.dart';

/// Metadata describing a component for tooling and documentation.
///
/// Metadata is intentionally renderer-neutral. It can be attached to a
/// generated component descriptor without affecting the node representation.
final class ReactComponentMetadata {
  /// Creates metadata for a component.
  const ReactComponentMetadata({
    required this.name,
    this.description,
    this.propsType,
    this.supportsRef = false,
    this.isForeign = false,
  });

  /// Public component name.
  final String name;

  /// Optional human-readable description.
  final String? description;

  /// Dart type name used by generated documentation.
  final String? propsType;

  /// Whether the component accepts a forwarded ref.
  final bool supportsRef;

  /// Whether the component is implemented by a foreign JS module.
  final bool isForeign;
}

/// A typed factory for a component already registered with the React runtime.
///
/// Generated component APIs can expose this shape while retaining their
/// existing named-parameter convenience functions. The factory is also useful
/// for handwritten component catalogs and wrapper packages.
final class ReactComponentFactory<P> {
  /// Creates a factory for the registered component identified by [id].
  const ReactComponentFactory({required this.id, this.metadata});

  /// Stable registry identifier used by browser and SSR renderers.
  final ComponentId id;

  /// Optional tooling metadata.
  final ReactComponentMetadata? metadata;

  /// Creates a component node with typed [props] and [children].
  ReactNode call(P props, {ReactChildren children = const [], String? key}) =>
      Component(id, props, children: normalizeChildren(children), key: key);
}

/// Creates a typed factory for a generated or registered component.
ReactComponentFactory<P> component<P>(
  ComponentId id, {
  ReactComponentMetadata? metadata,
}) => ReactComponentFactory(id: id, metadata: metadata);
