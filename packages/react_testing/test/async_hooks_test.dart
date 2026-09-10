import 'dart:async';

import 'package:react_core/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('memoized Future and refs remain stable across renders', () async {
    final harness = HookTestHarness();
    addTearDown(harness.dispose);
    var calls = 0;
    final completion = Completer<int>();
    (ReactAsyncSnapshot<int>, ReactRef<int>) component() {
      final future = useMemo(() {
        calls++;
        return completion.future;
      }, const []);
      return (useFuture(future), useRef<int>(0));
    }

    final first = harness.render(component);
    completion.complete(42);
    await pumpEventQueue();
    final second = harness.render(component);
    expect(second.$1.data, 42);
    expect(second.$2, same(first.$2));
    expect(calls, 1);
  });

  test('adding or removing hooks between renders is rejected', () {
    final harness = HookTestHarness();
    addTearDown(harness.dispose);
    harness.render(() => useState(0));
    expect(() => harness.render(() {}), throwsStateError);
    expect(
      () => harness.render(() {
        useState(0);
        useState(1);
      }),
      throwsStateError,
    );
  });

  test(
    'Future replacement ignores stale completion and reports current data',
    () async {
      final harness = HookTestHarness();
      addTearDown(harness.dispose);
      final first = Completer<int>();
      final second = Completer<int>();
      expect(harness.render(() => useFuture(first.future)).isWaiting, isTrue);
      harness.render(() => useFuture(second.future));
      first.complete(1);
      await pumpEventQueue();
      expect(harness.render(() => useFuture(second.future)).isWaiting, isTrue);
      second.complete(2);
      await pumpEventQueue();
      final snapshot = harness.render(() => useFuture(second.future));
      expect(snapshot.data, 2);
      expect(snapshot.phase, ReactAsyncPhase.done);
    },
  );

  test(
    'Future errors carry their stack and disposal consumes late errors',
    () async {
      final harness = HookTestHarness();
      final future = Completer<int>();
      harness.render(() => useFuture(future.future));
      final error = StateError('failed');
      final trace = StackTrace.current;
      future.completeError(error, trace);
      await pumpEventQueue();
      final value = harness.render(() => useFuture(future.future));
      expect(value.error, same(error));
      expect(value.stackTrace, same(trace));
      final late = Completer<int>();
      harness.render(() => useFuture(late.future));
      harness.dispose();
      late.completeError(StateError('after unmount'));
      await pumpEventQueue();
    },
  );

  test(
    'Stream updates recover from errors and retain last value on completion',
    () async {
      final harness = HookTestHarness();
      addTearDown(harness.dispose);
      final stream = StreamController<int>();
      addTearDown(stream.close);
      expect(
        harness.render(() => useStream(stream.stream, initialData: 0)).data,
        0,
      );
      stream.addError(StateError('temporary'));
      await pumpEventQueue();
      expect(harness.render(() => useStream(stream.stream)).hasError, isTrue);
      stream.add(3);
      await pumpEventQueue();
      expect(harness.render(() => useStream(stream.stream)).data, 3);
      expect(harness.render(() => useStream(stream.stream)).hasError, isFalse);
      await stream.close();
      await pumpEventQueue();
      final value = harness.render(() => useStream(stream.stream));
      expect(value.phase, ReactAsyncPhase.done);
      expect(value.data, 3);
    },
  );

  test('Stream replacement and disposal cancel subscriptions once', () async {
    var cancellations = 0;
    final first = StreamController<int>(onCancel: () => cancellations++);
    final second = StreamController<int>(onCancel: () => cancellations++);
    addTearDown(first.close);
    addTearDown(second.close);
    final harness = HookTestHarness();
    harness.render(() => useStream(first.stream));
    harness.render(() => useStream(first.stream));
    expect(cancellations, 0);
    harness.render(() => useStream(second.stream));
    await pumpEventQueue();
    expect(cancellations, 1);
    harness.dispose();
    harness.dispose();
    await pumpEventQueue();
    expect(cancellations, 2);
  });

  test(
    'SSR does not listen to streams and exposes deterministic initial data',
    () {
      final stream = StreamController<int>();
      final harness = HookTestHarness(server: true);
      final value = harness.render(
        () => useStream(stream.stream, initialData: 7),
      );
      expect(value.data, 7);
      expect(value.phase, ReactAsyncPhase.waiting);
      expect(stream.hasListener, isFalse);
      final futureHarness = HookTestHarness(server: true);
      addTearDown(futureHarness.dispose);
      final future = futureHarness.render(
        () => useFuture<int>(null, initialData: 8),
      );
      expect(future.phase, ReactAsyncPhase.none);
      expect(future.data, 8);
      harness.dispose();
      // An unlistened single-subscription stream's close Future need not complete.
      unawaited(stream.close());
    },
  );
}
