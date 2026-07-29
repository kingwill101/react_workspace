import 'dart:async';
import 'node.dart';

abstract class ReactBinding {
  (T, void Function(T)) useState<T>(T initial);
  void useEffect(void Function() effect, List<Object?>? deps);
}

abstract class ReactRenderer {
  Object? render(ReactNode node);
}

enum ReactRenderTarget { browser, server, test }

final class ReactRuntimeCapabilities {
  final bool supportsEvents;
  final bool supportsRefs;
  final bool supportsEffects;

  const ReactRuntimeCapabilities({
    required this.supportsEvents,
    required this.supportsRefs,
    required this.supportsEffects,
  });

  static const browser = ReactRuntimeCapabilities(
    supportsEvents: true,
    supportsRefs: true,
    supportsEffects: true,
  );

  static const server = ReactRuntimeCapabilities(
    supportsEvents: false,
    supportsRefs: false,
    supportsEffects: false,
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
