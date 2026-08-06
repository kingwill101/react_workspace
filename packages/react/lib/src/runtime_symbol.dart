import 'internal.dart';

/// The kind of runtime symbol a Dart declaration bridges to.
enum ReactRuntimeSymbolKind {
  component,
  hook,
  function,
  value,
}

/// Machine-readable bridge metadata added to generated declarations.
///
/// The analyzer resolves this annotation to determine which hooks/components
/// are actually used without scanning compiled JS. See
/// `packages/react_analysis/lib/src/runtime_usage.dart`.
final class ReactRuntimeSymbol {
  final ReactRuntimeSymbolKind kind;
  final String runtimeKey;
  final Set<ReactRenderTarget> targets;

  const ReactRuntimeSymbol({
    required this.kind,
    required this.runtimeKey,
    required this.targets,
  });
}

/// Marker for generated React hooks.
final class ReactHook {
  const ReactHook();
}

/// A component explicitly marked as browser-only.
///
/// The SSR analyzer will not flag browser-only API usage inside it.
final class ClientOnly {
  final Type? fallback;
  const ClientOnly({this.fallback});
}

const clientOnly = ClientOnly();
