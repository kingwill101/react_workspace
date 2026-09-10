import 'package:bloc/bloc.dart';
import 'package:react_bloc/react_bloc.dart';
import 'package:react_core/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('Cubit provider resolves through the native component harness', () {
    final cubit = _Counter();
    addTearDown(cubit.close);
    final provider = blocProvider(cubit, const []) as ContextProvider<BlocBase?>;
    final harness = ReactComponentHarness();
    harness.binding.setContext(blocScopeContext, provider.value);
    expect(harness.run(() => useBloc<_Counter>()), same(cubit));
    expect(harness.run(() => useBlocState(cubit)), 0);
  });

  test(
    'Cubit subscriptions cancel without closing the owned instance',
    () async {
      final cubit = _Counter();
      addTearDown(cubit.close);
      final binding = _StoreBinding();
      final harness = ReactComponentHarness(binding: binding);
      expect(harness.run(() => useBlocState(cubit)), 0);
      expect(binding.serverSnapshot(), 0);
      cubit.increment();
      await pumpEventQueue();
      expect(binding.notifications, 1);
      expect(binding.snapshot(), 1);
      binding.unsubscribe();
      await pumpEventQueue();
      cubit.increment();
      await pumpEventQueue();
      expect(binding.notifications, 1);
      expect(cubit.isClosed, isFalse);
    },
  );

  test(
    'Cubit selectors provide matching client and server snapshots',
    () async {
      final cubit = _Counter();
      addTearDown(cubit.close);
      final binding = _StoreBinding();
      final harness = ReactComponentHarness(binding: binding);
      expect(
      harness.run(() => useBlocSelector(cubit, (int n) => n.isEven)),
        isTrue,
      );
      addTearDown(() => binding.unsubscribe());
      cubit.increment();
      await pumpEventQueue();
      expect(binding.snapshot(), isFalse);
      expect(binding.serverSnapshot(), isFalse);
    },
  );
}

final class _Counter extends Cubit<int> {
  _Counter() : super(0);
  void increment() => emit(state + 1);
}

final class _StoreBinding extends TestReactBinding {
  int notifications = 0;
  late void Function() unsubscribe;
  late Object? Function() snapshot;
  late Object? Function() serverSnapshot;

  @override
  T useSyncExternalStore<T>(
    StoreSubscribe subscribe,
    Snapshot<T> getSnapshot,
    Snapshot<T>? getServerSnapshot,
  ) {
    unsubscribe = subscribe(() => notifications++);
    snapshot = getSnapshot;
    serverSnapshot = getServerSnapshot!;
    return getSnapshot();
  }
}
