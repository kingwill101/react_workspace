import 'package:react_core/react.dart';
import 'package:react_riverpod/react_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// The wrapper's contract is portable: [useRiverpod] must read the container
/// from React context, subscribe through `container.listen`, and surface
/// `container.read` as the snapshot. This test drives that contract on the
/// native VM with a fake binding — no JavaScript involved.
void main() {
  final countProvider = Provider<int>((ref) => 0);

  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('riverpodScope publishes the container through React context', () {
    final scope = riverpodScope(container, const []);
    expect(scope, isA<ContextProvider<ProviderContainer?>>());
  });

  test('useRiverpod outside riverpodScope fails explicitly', () {
    final binding = _VmBinding(container: null);
    runWithReactRuntime(_runtime(binding), () {
      expect(() => useRiverpod(countProvider), throwsStateError);
    });
  });

  test('useRiverpod subscribes to provider changes', () {
    final notifier = NotifierProvider<CountNotifier, int>(CountNotifier.new);
    final binding = _VmBinding(container: container);
    runWithReactRuntime(_runtime(binding), () {
      final initial = useRiverpod(notifier);
      expect(initial, 0);
      expect(binding.listenerCalls, 0, reason: 'no change yet');
      expect(binding.snapshot(), 0);

      // Mutate the provider: the container listener must fire and the
      // snapshot must re-read the new value (exactly what React does).
      container.read(notifier.notifier).state = 5;
      expect(binding.listenerCalls, 1);
      expect(binding.snapshot(), 5);
    });
  });
}

final class CountNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

ReactRuntime _runtime(_VmBinding binding) => ReactRuntime(
  target: ReactRenderTarget.test,
  capabilities: ReactRuntimeCapabilities.browser,
  binding: binding,
  renderer: _VmRenderer(),
);

final class _VmRenderer implements ReactRenderer {
  @override
  Object? render(ReactNode node) => null;
}

/// Minimal VM binding: implements the two hooks the wrapper relies on and
/// records how they were driven.
final class _VmBinding extends ReactBinding {
  _VmBinding({required this.container});

  final ProviderContainer? container;

  /// How many times the subscribe callback fired (a React re-read request).
  int listenerCalls = 0;

  late void Function() unsubscribe;
  late Object? Function() snapshot;

  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    return (initial, StateSetter<T>((_) {}, (_) {}));
  }

  @override
  void useEffect(void Function() effect, List<Object?>? deps) {}

  @override
  T useContext<T>(ReactContext<T> context) => container as T;

  @override
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) {
    unsubscribe = subscribe(() => listenerCalls++);
    snapshot = () => getSnapshot();
    return getSnapshot();
  }
}
