import 'package:react/react.dart';

/// Pre-built test runtimes for common scenarios.
///
/// Provides ready-to-use [ReactRuntime] instances that can be passed to
/// [runWithReactRuntime] for testing components without a real renderer.
class TestRuntimes {
  /// A runtime that supports all test-capable features (no effects).
  static ReactRuntime get standard => ReactRuntime(
    target: ReactRenderTarget.test,
    capabilities: const ReactRuntimeCapabilities(
      supportsEvents: true,
      supportsRefs: true,
      supportsEffects: false,
      supportsContext: true,
      supportsSuspense: true,
    ),
    binding: _TestBinding(),
    renderer: _TestRenderer(),
  );

  /// A runtime that pretends to be the browser (effects enabled).
  static ReactRuntime get browser => ReactRuntime(
    target: ReactRenderTarget.browser,
    capabilities: ReactRuntimeCapabilities.browser,
    binding: _TestBinding(supportsEffects: true),
    renderer: _TestRenderer(),
  );

  /// A runtime that pretends to be the server (SSR, no events/refs).
  static ReactRuntime get server => ReactRuntime(
    target: ReactRenderTarget.server,
    capabilities: ReactRuntimeCapabilities.server,
    binding: _TestBinding(),
    renderer: _TestRenderer(),
  );
}

class _TestBinding extends ReactBinding {
  final bool supportsEffects;
  _TestBinding({this.supportsEffects = false});

  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    T value = initial;
    void setter(T next) => value = next;
    return (value, StateSetter<T>(setter, (fn) => value = fn(value)));
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {
    if (!supportsEffects) return;
    effect();
  }

  @override
  T useContext<T>(ReactContext<T> context) => context.defaultValue;

  @override
  ReactRef<T> useRef<T>(T? initialValue) => ReactRef<T>(initialValue);

  @override
  String useId() => 'test-id';

  @override
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) => getSnapshot();

  @override
  T useMemo<T>(T Function() factory, List<Object?>? deps) => factory();

  @override
  T useCallback<T extends Function>(T callback, List<Object?>? deps) =>
      callback;
}

class _TestRenderer implements ReactRenderer {
  @override
  Object? render(ReactNode node) => node;
}
