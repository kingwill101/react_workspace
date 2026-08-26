// `react_js` is the browser implementation of the portable React contract.
// ignore_for_file: js_interop_in_server

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_core/react.dart';

import 'conversion_core.dart';

final class _StateBox {
  final Object? value;

  const _StateBox(this.value);
}

final class _RefBox {
  final ReactRef<Object?> ref;

  _RefBox(Object? initialValue) : ref = ReactRef(initialValue);
}

/// React hook binding backed by the global React JavaScript runtime.
///
/// State, reducer, memoization, callback memoization, refs, context,
/// transitions, IDs, optimistic state, and effect cleanup are backed by the
/// corresponding React hooks.
/// Other methods intentionally
/// use the explicit stubs inherited from [ReactBinding] until their renderer
/// contracts are finalized for both browser and SSR.
class JsBinding extends ReactBinding {
  final _contexts = <ReactContext<Object?>, JSObject>{};
  final _snapshotCache = <Object, JSAny>{};
  final _callbackCache = <JSFunction, Function>{};
  final _refCache = Expando<Object>('ReactRefJSObject');
  final _jsRefs = <Object, JSObject>{};

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

  /// Returns the JavaScript context object for [context].
  JSObject contextObject<T>(ReactContext<T> context) {
    final key = context as ReactContext<Object?>;
    return _contexts.putIfAbsent(
      key,
      () => _createContext(_toStateJS(context.defaultValue)),
    );
  }

  /// Returns the React provider type for [context].
  ///
  /// React 18 requires `context.Provider` when creating an element; React 19
  /// additionally permits rendering the context object directly.
  JSObject contextProviderObject<T>(ReactContext<T> context) =>
      contextObject(context).getProperty('Provider'.toJS) as JSObject;

  /// Encodes a hook-owned Dart value without losing its Dart identity.
  JSAny encodeHookValue(Object? value) => _toStateJS(value);

  @override
  ReactRef<T> useRef<T>(T? initialValue) {
    final jsRef = _useRef(_RefBox(initialValue).toJSBox);
    final cached = _refCache[jsRef];
    if (cached != null) return cached as ReactRef<T>;

    final current = jsRef.getProperty('current'.toJS);
    final currentDart = current != null && current.isA<JSBoxedDartObject>()
        ? (current as JSBoxedDartObject).toDart
        : null;
    final initial = currentDart is _RefBox
        ? currentDart.ref.current
        : initialValue;
    final ref = ReactRef<T>(initial as T?);
    _refCache[jsRef] = ref;
    _jsRefs[ref] = jsRef;
    return ref;
  }

  @override
  void useImperativeHandle<T>(
    ReactRef<T>? ref,
    T Function() create, [
    List<Object?>? deps,
  ]) {
    if (ref == null) return;
    if (currentReactRuntime.target == ReactRenderTarget.server) return;
    final jsRef = _jsRefs[ref];
    if (jsRef == null) {
      unsupportedReactFeature('useImperativeHandle requires useRef');
    }
    final createJS = (() {
      final value = create();
      ref.current = value;
      return _toStateJS(value);
    }).toJS;
    _useImperativeHandle(jsRef, createJS, _depsToJS(deps));
  }

  @override
  T useContext<T>(ReactContext<T> context) =>
      _fromStateJS<T>(_useContext(contextObject(context)));

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
    final values = initializerJS == null
        ? _useReducer(reducerJS, _toStateJS(initialState))
        : _useReducerWithInitializer(
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
  void useDebugValue(Object? value, String Function(Object? value)? format) {
    if (currentReactRuntime.target == ReactRenderTarget.server) return;
    final formatJS = format == null
        ? null
        : ((JSAny? raw) => format(_fromStateJS<Object?>(raw)).toJS).toJS;
    _useDebugValue(_toStateJS(value), formatJS);
  }

  @override
  (T, void Function(A)) useOptimistic<T, A>(
    T state,
    T Function(T state, A action) update,
  ) {
    final hook = _requireReactHook(_useOptimistic, 'useOptimistic');
    final updateJS = ((JSAny? previous, JSAny? action) {
      return _toStateJS(
        update(_fromStateJS<T>(previous), _fromStateJS<A>(action)),
      );
    }).toJS;
    final values =
        hook.callAsFunction(null, _toStateJS(state), updateJS) as JSArray;
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
    // React owns the JavaScript identity; the Dart callback is returned so it
    // can still flow through typed ReactCallback descriptors.
    final candidate = (() {}).toJS;
    final stable = _useCallback(candidate, _depsToJS(deps));
    return _callbackCache.putIfAbsent(stable, () => callback) as T;
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
  T useDeferredValue<T>(T value, Object? initialValue) {
    final encodedValue = _toStateJS(value);
    final deferred = initialValue == null
        ? _useDeferredValue(encodedValue)
        : _useDeferredValueWithInitialValue(
            encodedValue,
            _toStateJS(initialValue),
          );
    return _fromStateJS<T>(deferred);
  }

  @override
  (T, void Function(A)) useActionState<T, A>(
    Action<T, A> action,
    T initialState,
    String? permalink,
  ) {
    final hook = _requireReactHook(_useActionState, 'useActionState');
    final actionJS = ((JSAny? previous, JSAny? rawAction) {
      final result = action(
        _fromStateJS<T>(previous),
        _fromStateJS<A>(rawAction),
      );
      return result is Future<T>
          ? result.then(_toStateJS).toJS
          : _toStateJS(result);
    }).toJS;
    final values =
        hook.callAsFunction(
              null,
              actionJS,
              _toStateJS(initialState),
              permalink?.toJS,
            )
            as JSArray;
    final value = _fromStateJS<T>(values[0]);
    final dispatch = values[1] as JSFunction;
    return (
      value,
      (rawAction) => dispatch.callAsFunction(null, _toStateJS(rawAction)),
    );
  }

  @override
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) {
    final subscribeJS = ((JSFunction listener) {
      final unsubscribe = subscribe(() => listener.callAsFunction(null));
      return unsubscribe.toJS;
    }).toJS;
    final snapshotJS = (() => _toSnapshotJS(getSnapshot())).toJS;
    final serverSnapshotJS = getServerSnapshot == null
        ? null
        : (() => _toSnapshotJS(getServerSnapshot())).toJS;
    return _fromStateJS<T>(
      _useSyncExternalStore(subscribeJS, snapshotJS, serverSnapshotJS),
    );
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

  JSAny? _toSnapshotJS(Object? value) {
    if (value == null || value is String || value is bool || value is num) {
      return toReactJS(value);
    }
    return _snapshotCache.putIfAbsent(value, () => _toStateJS(value));
  }

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

    final jsFn = (() {
      final cleanup = effect();
      return cleanup is EffectCleanup ? cleanup.toJS : _jsUndefined;
    }).toJS;
    _useLayoutEffect(jsFn, _depsToJS(deps));
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {
    // React does not execute effects during SSR. Avoid even registering the
    // callback so SSR remains warning-free and side-effect-free.
    if (currentReactRuntime.target == ReactRenderTarget.server) return;

    final jsFn = (() {
      final cleanup = effect();
      return cleanup is EffectCleanup ? cleanup.toJS : _jsUndefined;
    }).toJS;
    _useEffect(jsFn, _depsToJS(deps));
  }

  JSAny? _depsToJS(List<Object?>? deps) =>
      deps?.map((d) => toReactJS(d)).toList().toJS;
}

JSFunction _requireReactHook(JSAny? candidate, String name) {
  if (candidate == null ||
      candidate.isUndefined ||
      !candidate.isA<JSFunction>()) {
    throw UnsupportedError(
      '$name requires React 19 or newer, but the active runtime does not '
      'export it.',
    );
  }
  return candidate as JSFunction;
}

@JS('undefined')
external JSAny? get _jsUndefined;

@JS('React.createContext')
external JSObject _createContext(JSAny? defaultValue);

@JS('React.useContext')
external JSAny? _useContext(JSObject context);

@JS('React.useImperativeHandle')
external void _useImperativeHandle(
  JSObject ref,
  JSFunction create,
  JSAny? deps,
);

@JS('React.useDebugValue')
external void _useDebugValue(JSAny? value, JSFunction? format);

@JS('React.useOptimistic')
external JSAny? get _useOptimistic;

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
external JSAny? _useDeferredValue(JSAny value);

@JS('React.useDeferredValue')
external JSAny? _useDeferredValueWithInitialValue(
  JSAny value,
  JSAny initialValue,
);

@JS('React.useActionState')
external JSAny? get _useActionState;

@JS('React.useSyncExternalStore')
external JSAny? _useSyncExternalStore(
  JSFunction subscribe,
  JSFunction getSnapshot,
  JSFunction? getServerSnapshot,
);

@JS('React.useState')
external JSArray _useState(JSAny? initial);

@JS('React.useLayoutEffect')
external void _useLayoutEffect(JSFunction effect, JSAny? deps);

@JS('React.useReducer')
external JSArray _useReducer(JSFunction reducer, JSAny? initialArg);

@JS('React.useReducer')
external JSArray _useReducerWithInitializer(
  JSFunction reducer,
  JSAny? initialArg,
  JSFunction initializer,
);

@JS('React.useEffect')
external void _useEffect(JSFunction effect, JSAny? deps);
