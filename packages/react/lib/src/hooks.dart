import 'internal.dart';
import 'runtime_features.dart';

/// Returns state and a setter for the current component.
///
/// See https://react.dev/reference/react/useState.
(T, StateSetter<T>) useState<T>(T initial) =>
    currentReactRuntime.binding.useState(initial);

/// Registers a passive effect and optional cleanup.
///
/// Effects are not executed during server rendering. See
/// https://react.dev/reference/react/useEffect.
void useEffect(EffectCallback effect, [List<Object?>? deps]) =>
    currentReactRuntime.binding.useEffect(effect, deps);

/// Registers an effect that runs before the browser paints.
///
/// This is a client-only primitive; server renderers must not run it. See
/// https://react.dev/reference/react/useLayoutEffect.
void useLayoutEffect(EffectCallback effect, [List<Object?>? deps]) =>
    currentReactRuntime.binding.useLayoutEffect(effect, deps);
