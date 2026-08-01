import 'dart:js_interop';

import 'package:react/react.dart';

import 'conversion_core.dart';

final class _StateBox {
  final Object? value;

  const _StateBox(this.value);
}

/// React hook binding backed by the global React JavaScript runtime.
///
/// The first implementation phase covers state, lazy state initialization,
/// functional state updates, and effect cleanup. Other methods intentionally
/// use the explicit stubs inherited from [ReactBinding] until their renderer
/// contracts are finalized for both browser and SSR.
class JsBinding extends ReactBinding {
  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    final state = _readState<T>(_useState(_toStateJS(initial)));
    return (state.value, state.stateSetter);
  }

  @override
  (T, StateSetter<T>) useStateLazy<T>(T Function() initializer) {
    final lazy = (() => _toStateJS(initializer())).toJS;
    final state = _readState<T>(_useState(lazy));
    return (state.value, state.stateSetter);
  }

  @override
  (T, StateSetter<T>) useStateWithUpdater<T>(T initial) {
    final state = _readState<T>(_useState(_toStateJS(initial)));
    return (state.value, state.stateSetter);
  }

  ({T value, void Function(T) setter, StateSetter<T> stateSetter})
  _readState<T>(JSArray values) {
    final value = _fromStateJS<T>(values[0]);
    final setter = values[1] as JSFunction;

    void setValue(T next) {
      setter.callAsFunction(null, _toStateJS(next));
    }

    void setUpdater(T Function(T previous) updater) {
      final jsUpdater = ((JSAny? previous) {
        final dartPrevious = _fromStateJS<T>(previous);
        return _toStateJS(updater(dartPrevious));
      }).toJS;
      setter.callAsFunction(null, jsUpdater);
    }

    final stateSetter = StateSetter<T>(setValue, setUpdater);
    return (value: value, setter: setValue, stateSetter: stateSetter);
  }

  JSAny _toStateJS(Object? value) => _StateBox(value).toJSBox;

  T _fromStateJS<T>(JSAny? value) {
    if (value != null && value.isA<JSBoxedDartObject>()) {
      final boxed = (value as JSBoxedDartObject).toDart;
      if (boxed is _StateBox) return boxed.value as T;
      return boxed as T;
    }
    return fromJS<T>(value);
  }

  @override
  void useLayoutEffect(EffectCallback effect, List<Object?>? deps) {
    // Layout effects are client-only. Keeping SSR as a no-op prevents a
    // browser timing primitive from changing server output.
    if (currentReactRuntime.target == ReactRenderTarget.server) return;
    unsupportedReactFeature('useLayoutEffect');
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {
    // React does not execute effects during SSR. Avoid even registering the
    // callback so SSR remains warning-free and side-effect-free.
    if (currentReactRuntime.target == ReactRenderTarget.server) return;

    final jsFn = (() {
      final cleanup = effect();
      return cleanup is EffectCleanup ? cleanup.toJS : null;
    }).toJS;
    _useEffect(jsFn, _depsToJS(deps));
  }

  JSAny? _depsToJS(List<Object?>? deps) =>
      deps?.map((d) => toReactJS(d)).toList().toJS;
}

@JS('React.useState')
external JSArray _useState(JSAny? initial);

@JS('React.useEffect')
external void _useEffect(JSFunction effect, JSAny? deps);
