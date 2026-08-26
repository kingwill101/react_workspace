// Typed React bindings for Riverpod.
//
// Riverpod is a pure-Dart state library, so this wrapper is fully portable:
// it runs on the native VM (unit tests), in the browser, and in the SSR
// worker with no JavaScript shim and no npm dependency. The React bridge is
// `useSyncExternalStore` (subscription) plus a React context (scope).
//
// Docs: https://riverpod.dev (core package: package:riverpod)
library;

import 'package:react_core/react.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

/// React context carrying the nearest [ProviderContainer].
///
/// The default is `null`; components that call [useRiverpod] must render
/// under a [riverpodScope].
const ReactContext<ProviderContainer?> riverpodScopeContext =
    ReactContext<ProviderContainer?>(null);

/// Wraps [children] with a Riverpod [container] so they can read providers
/// through [useRiverpod].
///
/// Mirrors `ProviderScope` from hooks_riverpod:
/// https://riverpod.dev/docs/concepts/providers#provider-scopes.
ReactNode riverpodScope(
  ProviderContainer container,
  List<ReactNode> children,
) => riverpodScopeContext.provider(container, children);

/// Reads [provider] and rebuilds this component whenever its value changes.
///
/// Subscribes through `container.listen`, the same mechanism hooks_riverpod's
/// `watch` uses — here wired into React via `useSyncExternalStore`. The
/// server snapshot returns the container's synchronous value, so SSR renders
/// the current provider state and hydration continues from it.
///
/// See https://riverpod.dev/docs/concepts/reading_providers#listening.
T useRiverpod<T>(ProviderListenable<T> provider) {
  final container = useContext(riverpodScopeContext);
  if (container == null) {
    throw StateError(
      'useRiverpod called outside of riverpodScope(...). '
      'Wrap the component tree in riverpodScope(container, children).',
    );
  }
  return useSyncExternalStore<T>(
    (onChange) {
      final subscription = container.listen<T>(provider, (_, _) => onChange());
      return subscription.close;
    },
    () => container.read(provider),
    () => container.read(provider),
  );
}
