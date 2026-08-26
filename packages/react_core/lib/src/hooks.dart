import 'internal.dart';
import 'runtime_features.dart';

/// A snapshot of state together with a stable setter.
///
/// The value is the state observed during the current render. Calling [set]
/// schedules the next render through the active renderer.
final class StateController<T> {
  const StateController(this.value, this.set);

  /// The current render's state value.
  final T value;

  /// Sets the next state value.
  final StateSetter<T> set;
}

/// Returns state and a setter for the current component.
///
/// See https://react.dev/reference/react/useState.
(T, StateSetter<T>) useState<T>(T initial) =>
    currentReactRuntime.binding.useState(initial);

/// Returns the current state value and its setter as one typed object.
StateController<T> useStateController<T>(T initial) {
  final (value, set) = useState(initial);
  return StateController(value, set);
}

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
