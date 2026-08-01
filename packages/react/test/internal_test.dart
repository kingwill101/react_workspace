import 'dart:async';
import 'package:react/react.dart';
import 'package:test/test.dart';

void main() {
  group('StateSetter', () {
    test('accepts direct and functional updates', () {
      final values = <int>[];
      final setter = StateSetter<int>(
        values.add,
        (updater) => values.add(updater(values.last)),
      );

      setter(2);
      setter((previous) => previous + 1);

      expect(values, [2, 3]);
    });
  });

  group('ReactRuntimeCapabilities', () {
    test('server capabilities report no events or refs', () {
      expect(ReactRuntimeCapabilities.server.supportsEvents, isFalse);
      expect(ReactRuntimeCapabilities.server.supportsRefs, isFalse);
      expect(ReactRuntimeCapabilities.server.supportsEffects, isFalse);
      expect(ReactRuntimeCapabilities.server.supportsContext, isTrue);
    });

    test('browser capabilities report events and refs', () {
      expect(ReactRuntimeCapabilities.browser.supportsEvents, isTrue);
      expect(ReactRuntimeCapabilities.browser.supportsRefs, isTrue);
      expect(ReactRuntimeCapabilities.browser.supportsEffects, isTrue);
      expect(ReactRuntimeCapabilities.browser.supportsContext, isTrue);
    });
  });

  group('Context', () {
    test('creates provider nodes without renderer state', () {
      final context = createContext('default');
      final provider = context.provider('provided', [const Text('child')]);

      expect(provider, isA<ContextProvider<String>>());
      expect((provider as ContextProvider<String>).value, 'provided');
    });
  });

  group('Component feature nodes', () {
    test('memo creates a memoized node', () {
      final component = memo<String>((value) => Text(value));

      expect(component('hello'), isA<MemoizedNode>());
    });

    test('forwardRef creates a forwarded-ref node', () {
      final component = forwardRef<String, Object?>(
        (value, ref) => Text(value),
      );

      expect(component('hello'), isA<ForwardRefNode<String, Object?>>());
    });

    test('lazy creates a lazy node', () {
      final component = lazy<String>(
        () => Future.value((value) => Text(value)),
      );

      expect(component('hello'), isA<LazyNode<String>>());
    });
  });

  group('currentReactRuntime', () {
    test('throws StateError outside any runtime', () {
      expect(() => currentReactRuntime, throwsStateError);
    });

    test('hooks fail outside runtime', () {
      expect(() => useState(0), throwsStateError);
      expect(() => useEffect(() {}), throwsStateError);
    });

    test('returns runtime inside runWithReactRuntime', () {
      final runtime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      ReactRuntime? captured;
      runWithReactRuntime(runtime, () {
        captured = currentReactRuntime;
      });

      expect(captured, same(runtime));
    });

    test('nested runtime restores parent', () {
      final parentRuntime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      final childRuntime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.server,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      ReactRuntime? insideChild;
      ReactRuntime? afterChild;

      runWithReactRuntime(parentRuntime, () {
        runWithReactRuntime(childRuntime, () {
          insideChild = currentReactRuntime;
        });
        afterChild = currentReactRuntime;
      });

      expect(insideChild, same(childRuntime));
      expect(afterChild, same(parentRuntime));
    });
  });

  group('runWithReactRuntime', () {
    test('two concurrent renders do not leak state', () async {
      final runtime1 = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      final runtime2 = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      Future<int> render(ReactRuntime r) =>
          runWithReactRuntime(r, () => Future.value(r.binding.useState(0).$1));

      final results = await Future.wait([
        render(runtime1),
        render(runtime2),
        render(runtime1),
        render(runtime2),
      ]);

      expect(results, [0, 0, 0, 0]);
    });

    test('global fallback persists after Zone exits', () {
      final runtime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      runWithReactRuntime(runtime, () {});

      expect(currentReactRuntime, same(runtime));
    });

    test('latest runtime replaces previous global', () {
      final r1 = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      final r2 = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.server,
        binding: _TestBinding(),
        renderer: _TestRenderer(),
      );

      runWithReactRuntime(r1, () {});
      runWithReactRuntime(r2, () {});

      expect(currentReactRuntime, same(r2));
    });
  });
}

final class _TestBinding extends ReactBinding {
  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    return (initial, StateSetter<T>((_) {}, (_) {}));
  }

  @override
  void useEffect(void Function() effect, List<Object?>? deps) {}
}

final class _TestRenderer implements ReactRenderer {
  @override
  Object? render(ReactNode node) => null;
}
