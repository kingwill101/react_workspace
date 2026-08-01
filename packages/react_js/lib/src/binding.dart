import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react/react.dart';

import 'conversion_core.dart';

final class _StateBox {
  final Object? value;

  const _StateBox(this.value);
}

final class _RefBox {
  final ReactRef<Object?> ref;

  _RefBox(Object? initialValue) : ref = ReactRef(initialValue);

  _RefBox.fromRef(this.ref);
}

/// React hook binding backed by the global React JavaScript runtime.
///
/// State, reducer, memoization, refs, transitions, IDs, and effect cleanup
/// are backed by the corresponding React hooks. Other methods intentionally
/// use the explicit stubs inherited from [ReactBinding] until their renderer
/// contracts are finalized for both browser and SSR.
class JsBinding extends ReactBinding {
  final _callbackCache = <JSFunction, Function>{};

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

  @override
  ReactRef<T> useRef<T>(T? initialValue) {
    final jsRef = _useRef(_RefBox(initialValue).toJSBox);
    final current = jsRef.getProperty('current'.toJS);
    if (current != null && current.isA<JSBoxedDartObject>()) {
      final boxed = (current as JSBoxedDartObject).toDart;
      if (boxed is _RefBox) return boxed.ref as ReactRef<T>;
    }

    final ref = ReactRef<T>(initialValue);
    jsRef.setProperty(
      'current'.toJS,
      _RefBox.fromRef(ref as ReactRef<Object?>).toJSBox,
    );
    return ref;
  }

  @override
  (T, void Function(A)) useReducer<T, A>(
    T Function(T state, A action) reducer,
    T initialState,
    T Function(T initialState)? initializer,
  ) {
    final reducerJS = ((JSAny? state, JSAny? action) {
      final dartState = _fromStateJS<T>(state);
      final dartAction = _fromStateJS<A>(action);
      return _toStateJS(reducer(dartState, dartAction));
    }).toJS;
    final initializerJS = initializer == null
        ? null
        : ((JSAny? initial) {
            return _toStateJS(initializer(_fromStateJS<T>(initial)));
          }).toJS;
    final values = _useReducer(
      reducerJS,
      _toStateJS(initialState),
      initializerJS,
    );
    final value = _fromStateJS<T>(values[0]);
    final dispatch = values[1] as JSFunction;
    return (
      value,
      (action) => dispatch.callAsFunction(null, _toStateJS(action)),
    );
  }

  @override
  T useMemo<T>(T Function() factory, List<Object?>? deps) {
    final compute = (() => _toStateJS(factory())).toJS;
    return _fromStateJS<T>(_useMemo(compute, _depsToJS(deps)));
  }

  @override
  T useCallback<T extends Function>(T callback, List<Object?>? deps) {
    final stableJSCallback = _useCallback(
      _callbackToJS(callback),
      _depsToJS(deps),
    );
    final stableCallback = _callbackCache.putIfAbsent(
      stableJSCallback,
      () => callback,
    );
    return stableCallback as T;
  }

  @override
  String useId() => _useId().toDart;

  @override
  (bool, void Function(TransitionWork)) useTransition() {
    final values = _useTransition();
    final pending = (values[0] as JSBoolean).toDart;
    final start = values[1] as JSFunction;
    return (pending, (work) => start.callAsFunction(null, work.toJS));
  }

  @override
  T useDeferredValue<T>(T value, Object? options) => _fromStateJS<T>(
    _useDeferredValue(
      _toStateJS(value),
      options == null ? null : toReactJS(options),
    ),
  );

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

  JSFunction _callbackToJS(Function callback) => callback.toJS as JSFunction;
}

@JS('React.useRef')
external JSObject _useRef(JSAny? initial);

@JS('React.useMemo')
external JSAny? _useMemo(JSFunction factory, JSAny? deps);

@JS('React.useCallback')
external JSFunction _useCallback(JSFunction callback, JSAny? deps);

@JS('React.useId')
external JSString _useId();

@JS('React.useTransition')
external JSArray _useTransition();

@JS('React.useDeferredValue')
external JSAny? _useDeferredValue(JSAny value, JSAny? options);

@JS('React.useState')
external JSArray _useState(JSAny? initial);

@JS('React.useReducer')
external JSArray _useReducer(
  JSFunction reducer,
  JSAny? initialArg,
  JSFunction? init,
);

@JS('React.useEffect')
external void _useEffect(JSFunction effect, JSAny? deps);
