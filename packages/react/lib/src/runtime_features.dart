import 'dart:async';

import 'internal.dart';
import 'node.dart';

/// A mutable object ref whose identity is stable for the lifetime of a hook.
///
/// See https://react.dev/reference/react/useRef.
final class ReactRef<T> {
  /// Creates a ref with [current] as its initial value.
  ReactRef([T? current]) : _current = current, _onChanged = null;

  /// Creates a ref whose writes are mirrored to [onChanged].
  ///
  /// Renderers use this constructor to bridge Dart refs to native React refs.
  ReactRef.linked(T? current, void Function(T?) onChanged)
    : _current = current,
      _onChanged = onChanged;

  final void Function(T?)? _onChanged;
  T? _current;

  /// The value currently stored in the ref.
  T? get current => _current;

  /// Updates the ref and notifies an optional renderer bridge.
  set current(T? value) {
    _current = value;
    _onChanged?.call(value);
  }
}

/// A React context definition and its default value.
///
/// See https://react.dev/reference/react/createContext.
final class ReactContext<T> {
  /// Creates a context with [defaultValue].
  const ReactContext(this.defaultValue);

  /// The value used when no provider is above the component.
  final T defaultValue;

  /// Creates a provider node for this context.
  ///
  /// See https://react.dev/reference/react/createContext#provider.
  ReactNode provider(T value, List<ReactNode> children) =>
      ContextProvider(this, value, children);
}

/// A provider node for [context].
///
/// See https://react.dev/reference/react/createContext#provider.
final class ContextProvider<T> extends ReactNode {
  /// Creates a provider node.
  const ContextProvider(this.context, this.value, this.children);

  /// The context whose value is provided.
  final ReactContext<T> context;

  /// The value visible to descendants.
  final T value;

  /// The provider's children.
  final List<ReactNode> children;
}

/// A node that enables React's development-only strict checks.
///
/// See https://react.dev/reference/react/StrictMode.
final class StrictMode extends ReactNode {
  /// Creates a strict-mode boundary.
  const StrictMode(this.children);

  /// The children checked by this boundary.
  final List<ReactNode> children;
}

/// A node that displays [fallback] while its children suspend.
///
/// See https://react.dev/reference/react/Suspense.
final class Suspense extends ReactNode {
  /// Creates a Suspense boundary.
  const Suspense({required this.fallback, required this.children});

  /// The content shown while [children] are suspended.
  final ReactNode fallback;

  /// The content that may suspend.
  final List<ReactNode> children;
}

/// A portal node rendered into a host [container].
///
/// See https://react.dev/reference/react-dom/createPortal.
final class Portal extends ReactNode {
  /// Creates a portal node.
  const Portal(this.children, this.container, {this.key});

  /// The children rendered through the portal.
  final List<ReactNode> children;

  /// The renderer-owned destination for the portal.
  final Object container;

  /// The optional React key for this portal.
  final String? key;
}

/// An error-boundary configuration.
///
/// The JavaScript renderer uses a small class-based boundary internally while
/// keeping the public Dart component model functional. SSR helpers retry with
/// the first Dart fallback when a render-time error escapes React's server
/// renderer.
///
/// See https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary.
final class ErrorBoundary extends ReactNode {
  /// Creates an error-boundary placeholder.
  const ErrorBoundary({
    required this.children,
    required this.fallback,
    this.onError,
  });

  /// The content protected by the boundary.
  final List<ReactNode> children;

  /// The content or builder shown after an error.
  final ReactNode fallback;

  /// Receives the error and a Dart stack at the report site.
  ///
  /// Client renderers receive React errors through the class boundary. SSR
  /// helpers receive errors while retrying with the Dart fallback.
  final void Function(Object error, StackTrace stack)? onError;
}

/// Creates a context definition.
///
/// See https://react.dev/reference/react/createContext.
ReactContext<T> createContext<T>(T defaultValue) => ReactContext(defaultValue);

/// Creates a provider node for [context].
///
/// See https://react.dev/reference/react/createContext#provider.
ReactNode provideContext<T>(
  ReactContext<T> context,
  T value,
  List<ReactNode> children,
) => ContextProvider(context, value, children);

/// Describes a memoized component comparison.
typedef PropsAreEqual<P> = bool Function(P previous, P next);

/// A memoized component node.
///
/// Renderers use this marker to apply `React.memo` to component elements while
/// keeping the Dart component builder portable.
///
/// See https://react.dev/reference/react/memo.
final class MemoizedNode extends ReactNode {
  /// Creates a memoized component node.
  const MemoizedNode(this.child, {this.arePropsEqual});

  /// The component element to memoize.
  final ReactNode child;

  /// An optional Dart-side props comparison supplied to `React.memo`.
  final bool Function(Object? previous, Object? next)? arePropsEqual;
}

/// A Dart component function that receives props and returns a node.
typedef ReactComponentBuilder<P> = ReactNode Function(P props);

/// A component render function that receives a forwarded ref.
typedef ForwardRefRender<P, T> = ReactNode Function(P props, ReactRef<T> ref);

/// A forwarded-ref component definition.
///
/// The component is callable with an optional Dart ref. Renderers also expose
/// it through React's `forwardRef` primitive when producing JavaScript.
///
/// See https://react.dev/reference/react/forwardRef.
final class ForwardRefComponent<P, T> {
  /// Creates a forwarded-ref component.
  const ForwardRefComponent(this.render);

  /// The render function receiving props and the forwarded ref.
  final ForwardRefRender<P, T> render;

  /// Builds a node with an optional Dart ref.
  ReactNode call(P props, {ReactRef<T>? ref}) =>
      ForwardRefNode(render, props, ref: ref);
}

/// The renderer-facing erased form of a forwarded-ref node.
abstract interface class ForwardRefNodeBase extends ReactNode {
  /// The render callback identity used to cache the React component type.
  Function get renderIdentity;

  /// The current value of the Dart ref supplied by the caller, if any.
  Object? get forwardedCurrent;

  /// Updates the caller's Dart ref through an erased bridge.
  void updateForwardedRef(Object? value);

  /// Invokes the typed render callback through an erased bridge.
  ReactNode buildWithRefErased(ReactRef<Object?> target);
}

/// A portable node produced by [ForwardRefComponent].
final class ForwardRefNode<P, T> extends ReactNode
    implements ForwardRefNodeBase {
  /// Creates a forwarded-ref node.
  const ForwardRefNode(this.render, this.props, {this.ref});

  /// The render function for this node.
  final ForwardRefRender<P, T> render;

  /// The props passed to [render].
  final P props;

  /// The Dart ref receiving the rendered host value.
  final ReactRef<T>? ref;

  @override
  Function get renderIdentity => render;

  @override
  Object? get forwardedCurrent => ref?.current;

  @override
  void updateForwardedRef(Object? value) {
    ref?.current = value as T?;
  }

  /// Invokes [render] through the renderer's erased ref boundary.
  @override
  ReactNode buildWithRefErased(ReactRef<Object?> target) {
    final typedTarget = ReactRef<T>.linked(
      target.current as T?,
      (value) => target.current = value,
    );
    return render(props, typedTarget);
  }
}

/// A component loader used by [lazy].
typedef LazyComponentLoader<P> = Future<ReactComponentBuilder<P>> Function();

/// A lazily loaded component definition.
///
/// See https://react.dev/reference/react/lazy.
final class LazyComponent<P> {
  /// Creates a lazy component.
  const LazyComponent(this.load);

  /// Loads the component implementation.
  final LazyComponentLoader<P> load;

  /// Creates a node that suspends until [load] resolves.
  ReactNode call(P props, {String? key}) => LazyNode(load, props, key: key);
}

/// The renderer-facing erased form of a lazy node.
abstract interface class LazyNodeBase extends ReactNode {
  /// The loader identity used to cache the React lazy component type.
  Function get loaderIdentity;

  /// Loads the typed builder through an erased bridge.
  Future<Object> loadErased();

  /// Builds the typed component through an erased bridge.
  ReactNode buildWithErased(Object builder);

  /// The optional React key.
  String? get nodeKey;
}

/// A portable node produced by [LazyComponent].
final class LazyNode<P> extends ReactNode implements LazyNodeBase {
  /// Creates a lazy node.
  const LazyNode(this.load, this.props, {this.key});

  /// The loader used by the renderer.
  final LazyComponentLoader<P> load;

  /// The props passed to the loaded component.
  final P props;

  /// The optional React key.
  final String? key;

  @override
  Function get loaderIdentity => load;

  @override
  String? get nodeKey => key;

  @override
  Future<Object> loadErased() async => load();

  /// Builds the loaded Dart component through an erased boundary.
  @override
  ReactNode buildWithErased(Object builder) =>
      (builder as ReactComponentBuilder<P>)(props);
}

/// Marks [component] for memoization.
///
/// The JavaScript and SSR renderers apply `React.memo` when [component]
/// produces a registered component node.
///
/// See https://react.dev/reference/react/memo.
ReactComponentBuilder<P> memo<P>(
  ReactComponentBuilder<P> component, {
  PropsAreEqual<P>? arePropsEqual,
}) =>
    (props) => MemoizedNode(
      component(props),
      arePropsEqual: arePropsEqual == null
          ? null
          : (previous, next) => arePropsEqual(previous as P, next as P),
    );

/// Marks a component as receiving a forwarded ref.
///
/// JavaScript and SSR renderers invoke the Dart render function through
/// `React.forwardRef`.
///
/// See https://react.dev/reference/react/forwardRef.
ForwardRefComponent<P, T> forwardRef<P, T>(ForwardRefRender<P, T> render) =>
    ForwardRefComponent(render);

/// Defers loading a component until it is rendered.
///
/// JavaScript and SSR renderers resolve the loader through `React.lazy`; wrap
/// the result in [suspense] when a visible loading state is required.
///
/// See https://react.dev/reference/react/lazy.
LazyComponent<P> lazy<P>(LazyComponentLoader<P> load) => LazyComponent(load);

/// Creates a portal node.
///
/// Client renderers will pass [container] to `react-dom`; server renderers
/// reject portals because they have no host destination.
///
/// See https://react.dev/reference/react-dom/createPortal.
ReactNode createPortal(
  List<ReactNode> children,
  Object container, {
  String? key,
}) => Portal(children, container, key: key);

/// Creates a Suspense boundary node.
///
/// See https://react.dev/reference/react/Suspense.
ReactNode suspense({
  required ReactNode fallback,
  required List<ReactNode> children,
}) => Suspense(fallback: fallback, children: children);

/// Creates a strict-mode boundary node.
///
/// See https://react.dev/reference/react/StrictMode.
ReactNode strictMode(List<ReactNode> children) => StrictMode(children);

/// Creates an error-boundary node.
///
/// See https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary.
ReactNode errorBoundary({
  required List<ReactNode> children,
  required ReactNode fallback,
  void Function(Object error, StackTrace stack)? onError,
}) => ErrorBoundary(children: children, fallback: fallback, onError: onError);

/// A future-compatible action result for [useActionState].
typedef Action<T, A> = FutureOr<T> Function(T previousState, A action);

/// A callback that subscribes to an external store and returns its cleanup.
typedef StoreSubscribe = void Function() Function(void Function());

/// A snapshot reader for [useSyncExternalStore].
typedef Snapshot<T> = T Function();

/// The work started by [useTransition].
typedef TransitionWork = void Function();

/// A ref-like state setter that supports direct and functional updates.
///
/// Calling the setter with a value replaces the state. Calling [update] lets a
/// renderer apply an updater against the current state.
///
/// See https://react.dev/reference/react/useState#updating-state-based-on-the-previous-state.
final class StateSetter<T> {
  /// Creates a state setter from renderer operations.
  const StateSetter(this._setValue, this._setUpdater);

  final void Function(T) _setValue;
  final void Function(T Function(T previous)) _setUpdater;

  /// Replaces state with [value].
  ///
  /// A function can also be passed directly, matching React's functional
  /// updater form: `setCount((previous) => previous + 1)`.
  void call(Object? value) {
    if (value is Function) {
      final dynamic updater = value;
      _setUpdater((previous) => updater(previous) as T);
      return;
    }
    if (value is T || value == null) {
      _setValue(value as T);
      return;
    }
    throw ArgumentError.value(value, 'value', 'Expected T or T Function(T).');
  }

  /// Updates state from its current value.
  void update(T Function(T previous) updater) => _setUpdater(updater);
}

/// Lazily initializes state.
///
/// See https://react.dev/reference/react/useState.
(T, StateSetter<T>) useStateLazy<T>(T Function() initializer) =>
    currentReactRuntime.binding.useStateLazy(initializer);

/// Returns state with a setter that supports functional updates.
///
/// [useState] also returns this setter type; this named form makes the
/// functional-update capability explicit at call sites. See
/// https://react.dev/reference/react/useState.
(T, StateSetter<T>) useStateWithUpdater<T>(T initial) =>
    currentReactRuntime.binding.useStateWithUpdater(initial);

/// Returns state from a reducer and a dispatch function.
///
/// See https://react.dev/reference/react/useReducer.
(T, void Function(A)) useReducer<T, A>(
  T Function(T state, A action) reducer,
  T initialState, [
  T Function(T initialState)? initializer,
]) =>
    currentReactRuntime.binding.useReducer(reducer, initialState, initializer);

/// Returns a cached calculation until [deps] changes.
///
/// See https://react.dev/reference/react/useMemo.
T useMemo<T>(T Function() factory, [List<Object?>? deps]) =>
    currentReactRuntime.binding.useMemo(factory, deps);

/// Returns a memoized callback until [deps] changes.
///
/// See https://react.dev/reference/react/useCallback.
T useCallback<T extends Function>(T callback, [List<Object?>? deps]) =>
    currentReactRuntime.binding.useCallback(callback, deps);

/// Returns a stable mutable ref object.
///
/// See https://react.dev/reference/react/useRef.
ReactRef<T> useRef<T>([T? initialValue]) =>
    currentReactRuntime.binding.useRef(initialValue);

/// Customizes the value exposed through [ref].
///
/// See https://react.dev/reference/react/useImperativeHandle.
void useImperativeHandle<T>(
  ReactRef<T>? ref,
  T Function() create, [
  List<Object?>? deps,
]) => currentReactRuntime.binding.useImperativeHandle(ref, create, deps);

/// Reads the nearest value for [context].
///
/// See https://react.dev/reference/react/useContext.
T useContext<T>(ReactContext<T> context) =>
    currentReactRuntime.binding.useContext(context);

/// Associates debugging information with the current hook.
///
/// See https://react.dev/reference/react/useDebugValue.
void useDebugValue(Object? value, [String Function(Object? value)? format]) =>
    currentReactRuntime.binding.useDebugValue(value, format);

/// Returns a stable identifier suitable for matching server and client trees.
///
/// See https://react.dev/reference/react/useId.
String useId() => currentReactRuntime.binding.useId();

/// Returns pending state and a transition starter.
///
/// See https://react.dev/reference/react/useTransition.
(bool, void Function(TransitionWork)) useTransition() =>
    currentReactRuntime.binding.useTransition();

/// Returns a deferred version of [value].
///
/// See https://react.dev/reference/react/useDeferredValue.
T useDeferredValue<T>(T value, [Object? options]) =>
    currentReactRuntime.binding.useDeferredValue(value, options);

/// Subscribes to an external store with an SSR snapshot when provided.
///
/// See https://react.dev/reference/react/useSyncExternalStore.
T useSyncExternalStore<T>(
  StoreSubscribe subscribe,
  Snapshot<T> getSnapshot, [
  Snapshot<T>? getServerSnapshot,
]) => currentReactRuntime.binding.useSyncExternalStore(
  subscribe,
  getSnapshot,
  getServerSnapshot,
);

/// Returns optimistic state and a dispatcher for optimistic actions.
///
/// See https://react.dev/reference/react/useOptimistic.
(T, void Function(A)) useOptimistic<T, A>(
  T state,
  T Function(T state, A action) update,
) => currentReactRuntime.binding.useOptimistic(state, update);

/// Returns action state and a dispatcher for async actions.
///
/// See https://react.dev/reference/react/useActionState.
(T, void Function(A)) useActionState<T, A>(
  Action<T, A> action,
  T initialState, [
  String? permalink,
]) =>
    currentReactRuntime.binding.useActionState(action, initialState, permalink);
