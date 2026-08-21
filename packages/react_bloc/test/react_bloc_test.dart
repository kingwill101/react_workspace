import 'package:bloc/bloc.dart';
import 'package:react/react.dart';
import 'package:react_bloc/react_bloc.dart';
import 'package:test/test.dart';

/// The wrapper's contract is portable: [useBloc] must resolve the bloc from
/// React context, and [useBlocState] must subscribe through the bloc's stream
/// and surface `bloc.state` as the snapshot. This test drives that contract
/// on the native VM with a fake binding — no JavaScript involved.
void main() {
  test('blocProvider publishes the bloc through React context', () {
    final bloc = CounterBloc();
    addTearDown(bloc.close);
    final scope = blocProvider(bloc, const []);
    expect(scope, isA<ContextProvider<Bloc?>>());
  });

  test('useBloc outside blocProvider fails explicitly', () {
    final binding = _VmBinding(bloc: null);
    runWithReactRuntime(_runtime(binding), () {
      expect(() => useBloc<CounterBloc>(), throwsStateError);
    });
  });

  test('useBloc resolves the nearest bloc', () {
    final bloc = CounterBloc();
    addTearDown(bloc.close);
    final binding = _VmBinding(bloc: bloc);
    runWithReactRuntime(_runtime(binding), () {
      final resolved = useBloc<CounterBloc>();
      expect(resolved, same(bloc));
    });
  });

  test('useBlocState subscribes to the bloc stream', () async {
    final bloc = CounterBloc();
    addTearDown(bloc.close);
    final binding = _VmBinding(bloc: bloc);
    runWithReactRuntime(_runtime(binding), () {
      final initial = useBlocState(bloc);
      expect(initial, 0);
      expect(binding.listenerCalls, 0, reason: 'no change yet');
      expect(binding.snapshot(), 0);

      // Emit a new state: bloc processes events on a microtask, so yield
      // before asserting the stream listener fired.
      bloc.add(_Increment());
    });
    await pumpEventQueue();
    expect(binding.listenerCalls, 1);
    expect(binding.snapshot(), 1);

    bloc.add(_Increment());
    await pumpEventQueue();
    expect(binding.listenerCalls, 2);
    expect(binding.snapshot(), 2);
  });

  test(
    'useBlocSelector exposes the selected external-store snapshot',
    () async {
      final bloc = CounterBloc();
      addTearDown(bloc.close);
      final binding = _VmBinding(bloc: bloc);
      runWithReactRuntime(_runtime(binding), () {
        final initial = useBlocSelector(bloc, (state) => 'count:$state');
        expect(initial, 'count:0');
        expect(binding.snapshot(), 'count:0');
        bloc.add(_Increment());
      });

      await pumpEventQueue();
      expect(binding.listenerCalls, 1);
      expect(binding.snapshot(), 'count:1');
    },
  );
}

final class _Increment {}

final class CounterBloc extends Bloc<_Increment, int> {
  CounterBloc() : super(0) {
    on<_Increment>((event, emit) => emit(state + 1));
  }
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
  _VmBinding({required this.bloc});

  final Bloc? bloc;

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
  T useContext<T>(ReactContext<T> context) => bloc as T;

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
