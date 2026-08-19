import 'package:react/react.dart';

/// A test React runtime that captures renders and supports hook testing
/// without requiring `dart:js_interop` or a browser.
///
/// Uses a lightweight in-memory [ReactBinding] and [ReactRenderer] so
/// component functions can be invoked and their output inspected.
///
/// Example:
/// ```dart
/// final harness = ReactComponentHarness();
/// final node = harness.render((props) => div(children: [Text(props)]), 'hello');
/// expect(node, isA<HostNode>());
/// ```
final class ReactComponentHarness {
  final TestReactBinding binding;
  final TestReactRenderer renderer;
  late final ReactRuntime runtime;

  ReactComponentHarness({
    TestReactBinding? binding,
    TestReactRenderer? renderer,
  }) : binding = binding ?? TestReactBinding(),
       renderer = renderer ?? TestReactRenderer() {
    runtime = ReactRuntime(
      target: ReactRenderTarget.test,
      capabilities: const ReactRuntimeCapabilities(
        supportsEvents: true,
        supportsRefs: true,
        supportsEffects: false,
        supportsContext: true,
        supportsSuspense: true,
      ),
      binding: this.binding,
      renderer: this.renderer,
    );
  }

  /// Runs [callback] inside this harness's runtime.
  T run<T>(T Function() callback) => runWithReactRuntime(runtime, callback);

  /// Renders a [ReactNode] through the test renderer.
  Object? renderNode(ReactNode node) => run(() => renderer.render(node));

  /// Helper to build and render a simple functional component.
  HostNode<Map<String, Object?>> renderDiv({
    Map<String, Object?> props = const {},
    ReactChildren children = const [],
  }) {
    final node = HostNode<Map<String, Object?>>(
      const HostType('web', 'div'),
      props,
      children: normalizeChildren(children),
    );
    renderNode(node);
    // Return the node itself for assertion convenience
    return node;
  }

  /// Asserts that [node] is a host node with the expected type.
  void assertHostNode(
    ReactNode node, {
    required String namespace,
    required String name,
  }) {
    if (node is! HostNode) {
      throw TestFailure('Expected HostNode but got ${node.runtimeType}');
    }
    if (node.type.namespace != namespace || node.type.name != name) {
      throw TestFailure('Expected $namespace:$name but got ${node.type}');
    }
  }

  /// Asserts that [node] is a text node with [value].
  void assertText(ReactNode node, String value) {
    if (node is! Text) {
      throw TestFailure('Expected Text but got ${node.runtimeType}');
    }
    if (node.value != value) {
      throw TestFailure('Expected Text("$value") but got "${node.value}"');
    }
  }
}

/// A test binding that stores state in-memory and supports basic hooks.
class TestReactBinding extends ReactBinding {
  final _states = <int, Object?>{};
  int _nextId = 0;

  final _contexts = <ReactContext<Object?>, Object?>{};
  final _effectCleanups = <EffectCleanup>[];

  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    final id = _nextId++;
    _states[id] = initial;

    void setter(T value) {
      _states[id] = value;
    }

    void updater(T Function(T) fn) {
      _states[id] = fn(_states[id] as T);
    }

    return (_states[id] as T, StateSetter<T>(setter, updater));
  }

  // ignore: non_constant_identifier_names
  @override
  (T, StateSetter<T>) useStateLazy<T>(T Function() initializer) {
    return useState(initializer());
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {
    // No-op in test: effects are not executed by default
  }

  @override
  T useContext<T>(ReactContext<T> context) {
    if (_contexts.containsKey(context as ReactContext<Object?>)) {
      return _contexts[context] as T;
    }
    return context.defaultValue;
  }

  /// Sets the value for a context (test helper).
  void setContext<T>(ReactContext<T> context, T value) {
    _contexts[context as ReactContext<Object?>] = value;
  }

  @override
  T useMemo<T>(T Function() factory, List<Object?>? deps) => factory();

  @override
  T useCallback<T extends Function>(T callback, List<Object?>? deps) =>
      callback;

  @override
  ReactRef<T> useRef<T>(T? initialValue) => ReactRef<T>(initialValue);

  @override
  String useId() => 'test-id-${_nextId++}';

  @override
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) => getSnapshot();

  /// Returns all recorded effect cleanups.
  List<EffectCleanup> get cleanups => List.unmodifiable(_effectCleanups);
}

/// A test renderer that captures the last rendered node.
class TestReactRenderer implements ReactRenderer {
  ReactNode? lastNode;
  final List<ReactNode> history = [];

  @override
  Object? render(ReactNode node) {
    lastNode = node;
    history.add(node);
    return _describe(node);
  }

  String _describe(ReactNode node) => switch (node) {
    HostNode(:var type, :var children) =>
      '<${type.name}>${children.length} children</${type.name}>',
    Text(:var value) => 'Text($value)',
    Fragment(:var children) => 'Fragment(${children.length})',
    Empty() => 'Empty',
    Component(:var id) => 'Component(${id.value})',
    _ => node.runtimeType.toString(),
  };

  void clear() {
    lastNode = null;
    history.clear();
  }
}

class TestFailure implements Exception {
  final String message;
  TestFailure(this.message);
  @override
  String toString() => 'TestFailure: $message';
}
