import 'package:react_core/react.dart';
import 'package:test/test.dart';

void main() {
  group('ReactRuntimeCapabilities', () {
    test('browser supports events, refs, effects, context, suspense', () {
      const caps = ReactRuntimeCapabilities.browser;
      expect(caps.supportsEvents, isTrue);
      expect(caps.supportsRefs, isTrue);
      expect(caps.supportsEffects, isTrue);
      expect(caps.supportsLayoutEffects, isTrue);
      expect(caps.supportsContext, isTrue);
      expect(caps.supportsSuspense, isTrue);
    });

    test('server does not support events, refs, effects', () {
      const caps = ReactRuntimeCapabilities.server;
      expect(caps.supportsEvents, isFalse);
      expect(caps.supportsRefs, isFalse);
      expect(caps.supportsEffects, isFalse);
      expect(caps.supportsLayoutEffects, isFalse);
      expect(caps.supportsContext, isTrue);
      expect(caps.supportsSuspense, isTrue);
    });

    test('custom capabilities', () {
      const caps = ReactRuntimeCapabilities(
        supportsEvents: false,
        supportsRefs: true,
        supportsEffects: false,
      );
      expect(caps.supportsEvents, isFalse);
      expect(caps.supportsRefs, isTrue);
      expect(caps.supportsEffects, isFalse);
    });
  });

  group('ReactRuntime', () {
    test('stores target, capabilities, binding, renderer', () {
      final binding = _FakeBinding();
      final renderer = _FakeRenderer();
      final runtime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: binding,
        renderer: renderer,
      );
      expect(runtime.target, ReactRenderTarget.test);
      expect(runtime.binding, same(binding));
      expect(runtime.renderer, same(renderer));
    });
  });

  group('unsupportedReactFeature', () {
    test('throws UnsupportedError with feature name', () {
      expect(
        () => unsupportedReactFeature('useMagic'),
        throwsA(
          isA<UnsupportedError>().having(
            (e) => e.message,
            'message',
            contains('useMagic'),
          ),
        ),
      );
    });
  });

  group('currentReactRuntime', () {
    test('throws StateError outside any runtime', () {
      expect(() => currentReactRuntime, throwsStateError);
    });

    test('returns runtime inside runWithReactRuntime', () {
      final runtime = ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _FakeBinding(),
        renderer: _FakeRenderer(),
      );
      runWithReactRuntime(runtime, () {
        expect(currentReactRuntime, same(runtime));
      });
    });

    test('nested runtimes restore correctly', () {
      final outer = ReactRuntime(
        target: ReactRenderTarget.browser,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: _FakeBinding(),
        renderer: _FakeRenderer(),
      );
      final inner = ReactRuntime(
        target: ReactRenderTarget.server,
        capabilities: ReactRuntimeCapabilities.server,
        binding: _FakeBinding(),
        renderer: _FakeRenderer(),
      );
      runWithReactRuntime(outer, () {
        expect(currentReactRuntime.target, ReactRenderTarget.browser);
        runWithReactRuntime(inner, () {
          expect(currentReactRuntime.target, ReactRenderTarget.server);
        });
        expect(currentReactRuntime.target, ReactRenderTarget.browser);
      });
    });
  });

  group('ReactBinding defaults', () {
    test('unimplemented methods throw UnsupportedError', () {
      final binding = _FakeBinding();
      expect(
        () => binding.useReducer((int s, int a) => s, 0, null),
        throwsUnsupportedError,
      );
      expect(() => binding.useMemo(() => 42, []), throwsUnsupportedError);
      expect(() => binding.useCallback(() {}, []), throwsUnsupportedError);
      expect(() => binding.useRef(0), throwsUnsupportedError);
      expect(
        () => binding.useContext(const ReactContext(0)),
        throwsUnsupportedError,
      );
      expect(() => binding.useId(), throwsUnsupportedError);
      expect(() => binding.useTransition(), throwsUnsupportedError);
      expect(() => binding.useDeferredValue(0, null), throwsUnsupportedError);
      expect(
        () => binding.useSyncExternalStore<int>(
          (void Function() _) => () {},
          () => 0,
          null,
        ),
        throwsUnsupportedError,
      );
      expect(
        () => binding.useOptimistic(0, (int s, int a) => s),
        throwsUnsupportedError,
      );
      expect(
        () => binding.useActionState<String, String>((s, a) => s, 'init', null),
        throwsUnsupportedError,
      );
    });

    test('useStateLazy and useStateWithUpdater throw by default', () {
      final binding = _FakeBinding();
      expect(() => binding.useStateLazy(() => 42), throwsUnsupportedError);
      expect(() => binding.useStateWithUpdater(42), throwsUnsupportedError);
    });

    test('useLayoutEffect throws by default', () {
      final binding = _FakeBinding();
      expect(() => binding.useLayoutEffect(() {}, []), throwsUnsupportedError);
    });
  });

  group('StateSetter', () {
    test('direct update calls setter', () {
      var value = 0;
      final setter = StateSetter<int>(
        (v) => value = v,
        (fn) => value = fn(value),
      );
      setter.call(42);
      expect(value, 42);
    });

    test('functional update calls updater', () {
      var value = 10;
      final setter = StateSetter<int>(
        (v) => value = v,
        (fn) => value = fn(value),
      );
      setter.update((prev) => prev + 5);
      expect(value, 15);
    });
  });
}

class _FakeBinding extends ReactBinding {
  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    T value = initial;
    return (value, StateSetter<T>((v) => value = v, (fn) => value = fn(value)));
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {}
}

class _FakeRenderer implements ReactRenderer {
  @override
  Object? render(ReactNode node) => node;
}
