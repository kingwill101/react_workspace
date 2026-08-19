import 'dart:async';

import 'node.dart';
import 'runtime_features.dart';

/// The renderer-facing hook and capability contract.
///
/// Methods that are not implemented by a renderer fail explicitly instead of
/// silently producing client/SSR divergence. This keeps the portable API
/// available while browser, server, and test bindings are implemented in
/// separate phases.
abstract class ReactBinding {
  /// Reads state and returns a direct/functional state setter.
  (T, StateSetter<T>) useState<T>(T initial);

  /// Reads state initialized by [initializer] only on the first render.
  (T, StateSetter<T>) useStateLazy<T>(T Function() initializer) =>
      unsupportedReactFeature('useState (lazy initialization)');

  /// Reads state with a setter that also accepts functional updates.
  (T, StateSetter<T>) useStateWithUpdater<T>(T initial) =>
      unsupportedReactFeature('useState (functional updates)');

  /// Registers a passive effect and its optional cleanup.
  void useEffect(EffectCallback effect, List<Object?>? deps);

  /// Registers a layout effect.
  void useLayoutEffect(EffectCallback effect, List<Object?>? deps) =>
      unsupportedReactFeature('useLayoutEffect');

  /// Returns reducer state and a dispatch function.
  (T, void Function(A)) useReducer<T, A>(
    T Function(T state, A action) reducer,
    T initialState,
    T Function(T initialState)? initializer,
  ) => unsupportedReactFeature('useReducer');

  /// Returns a memoized value.
  T useMemo<T>(T Function() factory, List<Object?>? deps) =>
      unsupportedReactFeature('useMemo');

  /// Returns a memoized callback.
  T useCallback<T extends Function>(T callback, List<Object?>? deps) =>
      unsupportedReactFeature('useCallback');

  /// Returns a stable mutable ref.
  ReactRef<T> useRef<T>(T? initialValue) => unsupportedReactFeature('useRef');

  /// Sets the value exposed through a ref.
  void useImperativeHandle<T>(
    ReactRef<T>? ref,
    T Function() create,
    List<Object?>? deps,
  ) => unsupportedReactFeature('useImperativeHandle');

  /// Reads a context value.
  T useContext<T>(ReactContext<T> context) =>
      unsupportedReactFeature('useContext');

  /// Publishes a value to React developer tooling.
  void useDebugValue(Object? value, String Function(Object? value)? format) =>
      unsupportedReactFeature('useDebugValue');

  /// Returns a server/client-stable identifier.
  String useId() => unsupportedReactFeature('useId');

  /// Returns transition state and a transition starter.
  (bool, void Function(TransitionWork)) useTransition() =>
      unsupportedReactFeature('useTransition');

  /// Returns a deferred value.
  T useDeferredValue<T>(T value, Object? options) =>
      unsupportedReactFeature('useDeferredValue');

  /// Subscribes to an external store.
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) => unsupportedReactFeature('useSyncExternalStore');

  /// Returns optimistic state and its dispatcher.
  (T, void Function(A)) useOptimistic<T, A>(
    T state,
    T Function(T state, A action) update,
  ) => unsupportedReactFeature('useOptimistic');

  /// Returns action state and its dispatcher.
  (T, void Function(A)) useActionState<T, A>(
    Action<T, A> action,
    T initialState,
    String? permalink,
  ) => unsupportedReactFeature('useActionState');
}

/// Throws a consistent error for a runtime feature that is only stubbed.
Never unsupportedReactFeature(String feature) =>
    throw UnsupportedError('$feature is not implemented by this renderer yet.');

/// A callback returned by an effect to clean up its subscription.
typedef EffectCleanup = void Function();

/// A passive or layout effect callback.
///
/// The dynamic return type intentionally accepts both `void` callbacks and
/// callbacks that return an [EffectCleanup], matching React's optional cleanup
/// contract without warning on ordinary Dart callbacks.
typedef EffectCallback = dynamic Function();

/// A renderer that turns a portable node into a host value.
abstract class ReactRenderer {
  /// Renders [node] for this runtime.
  Object? render(ReactNode node);
}

enum ReactRenderTarget { browser, server, test }

final class ReactRuntimeCapabilities {
  final bool supportsEvents;
  final bool supportsRefs;
  final bool supportsEffects;
  final bool supportsLayoutEffects;
  final bool supportsContext;
  final bool supportsSuspense;

  const ReactRuntimeCapabilities({
    required this.supportsEvents,
    required this.supportsRefs,
    required this.supportsEffects,
    this.supportsLayoutEffects = false,
    this.supportsContext = false,
    this.supportsSuspense = false,
  });

  static const browser = ReactRuntimeCapabilities(
    supportsEvents: true,
    supportsRefs: true,
    supportsEffects: true,
    supportsLayoutEffects: true,
    supportsContext: true,
    supportsSuspense: true,
  );

  static const server = ReactRuntimeCapabilities(
    supportsEvents: false,
    supportsRefs: false,
    supportsEffects: false,
    supportsLayoutEffects: false,
    supportsContext: true,
    supportsSuspense: true,
  );
}

final class ReactRuntime {
  final ReactRenderTarget target;
  final ReactRuntimeCapabilities capabilities;
  final ReactBinding binding;
  final ReactRenderer renderer;

  const ReactRuntime({
    required this.target,
    required this.capabilities,
    required this.binding,
    required this.renderer,
  });
}

final Object _reactRuntimeKey = Object();
ReactRuntime? _globalRuntime;

ReactRuntime get currentReactRuntime {
  final runtime = Zone.current[_reactRuntimeKey];
  if (runtime is ReactRuntime) return runtime;
  if (_globalRuntime != null) return _globalRuntime!;
  throw StateError('No ReactRuntime is active.');
}

T runWithReactRuntime<T>(ReactRuntime runtime, T Function() callback) {
  _globalRuntime = runtime;
  return runZoned(callback, zoneValues: {_reactRuntimeKey: runtime});
}
