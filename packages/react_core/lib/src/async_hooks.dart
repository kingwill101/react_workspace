import 'hooks.dart';

/// The lifecycle of a Future or Stream observed by a React hook.
enum ReactAsyncPhase { none, waiting, active, done }

/// A portable asynchronous value, including its error and stack trace.
final class ReactAsyncSnapshot<T> {
  const ReactAsyncSnapshot(
    this.phase, {
    this.data,
    this.error,
    this.stackTrace,
  });
  final ReactAsyncPhase phase;
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  bool get hasError => error != null;
  bool get isWaiting => phase == ReactAsyncPhase.waiting;
}

/// Observes [future] without allowing replaced or disposed work to update state.
///
/// Keep the Future stable between renders (for example with useMemo). Passing
/// null disconnects it. SSR returns the initial snapshot without subscribing.
/// A Future cannot be cancelled; cleanup ignores its subsequent completion.
ReactAsyncSnapshot<T> useFuture<T>(Future<T>? future, {T? initialData}) {
  final initial = ReactAsyncSnapshot<T>(
    future == null ? ReactAsyncPhase.none : ReactAsyncPhase.waiting,
    data: initialData,
  );
  final (state, setState) = useState((source: future, snapshot: initial));
  useEffect(() {
    var active = true;
    setState((source: future, snapshot: initial));
    future?.then<void>(
      (value) {
        if (active) {
          setState((
            source: future,
            snapshot: ReactAsyncSnapshot<T>(ReactAsyncPhase.done, data: value),
          ));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (active) {
          setState((
            source: future,
            snapshot: ReactAsyncSnapshot<T>(
              ReactAsyncPhase.done,
              error: error,
              stackTrace: stackTrace,
            ),
          ));
        }
      },
    );
    return () {
      active = false;
    };
  }, [future]);
  return identical(state.source, future) ? state.snapshot : initial;
}

/// Observes [stream] and cancels its subscription on replacement or unmount.
///
/// SSR returns [initialData] without listening. Errors are represented in the
/// snapshot and do not terminate a stream subscription; later data can recover.
ReactAsyncSnapshot<T> useStream<T>(Stream<T>? stream, {T? initialData}) {
  final initial = ReactAsyncSnapshot<T>(
    stream == null ? ReactAsyncPhase.none : ReactAsyncPhase.waiting,
    data: initialData,
  );
  final (state, setState) = useState((source: stream, snapshot: initial));
  // StreamController.stream may return equal wrappers on repeated reads.
  // Retain the subscribed wrapper so React's identity-based dependency check
  // does not try to listen to the same single-subscription stream twice.
  final source = state.source == stream ? state.source : stream;
  useEffect(() {
    var active = true;
    var latest = initial;
    void publish(ReactAsyncSnapshot<T> value) {
      if (!active) return;
      latest = value;
      setState((source: stream, snapshot: value));
    }

    publish(initial);
    final subscription = stream?.listen(
      (value) =>
          publish(ReactAsyncSnapshot<T>(ReactAsyncPhase.active, data: value)),
      onError: (Object error, StackTrace stackTrace) => publish(
        ReactAsyncSnapshot<T>(
          ReactAsyncPhase.active,
          data: latest.data,
          error: error,
          stackTrace: stackTrace,
        ),
      ),
      onDone: () => publish(
        ReactAsyncSnapshot<T>(
          ReactAsyncPhase.done,
          data: latest.data,
          error: latest.error,
          stackTrace: latest.stackTrace,
        ),
      ),
    );
    return () {
      active = false;
      subscription?.cancel();
    };
  }, [source]);
  return state.source == stream ? state.snapshot : initial;
}
