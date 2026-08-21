import 'package:react/react.dart';
import 'package:react_actions/react_actions.dart';

/// The state and invoker returned by [useServerAction].
final class ServerActionState<TArgs, TResult> {
  const ServerActionState({
    required this.pending,
    required this.data,
    required this.error,
    required this.invoke,
  });

  /// Whether an invocation is currently in flight.
  final bool pending;

  /// The most recent successful result.
  final TResult? data;

  /// The most recent invocation error, if any.
  final Object? error;

  /// Invokes the typed server function and updates this hook's state.
  final Future<TResult> Function(TArgs arguments) invoke;
}

/// Binds a generated server function to React pending/result/error state.
///
/// This is the ergonomic building block for buttons and form submit handlers:
///
/// ```dart
/// final action = useServerAction(greetRef);
/// button(
///   disabled: action.pending,
///   onClick: (_) => action.invoke((name: 'Ada')),
///   children: [Text(action.data ?? 'Greet')],
/// );
/// ```
ServerActionState<TArgs, TResult> useServerAction<TArgs, TResult>(
  ServerFunctionRef<TArgs, TResult> ref,
) {
  final (pending, setPending) = useState(false);
  final (data, setData) = useState<TResult?>(null);
  final (error, setError) = useState<Object?>(null);

  Future<TResult> invoke(TArgs arguments) async {
    setPending(true);
    setError(null);
    try {
      final result = await currentServerFunctionClient.invoke(ref, arguments);
      setData(result);
      return result;
    } catch (caught) {
      setError(caught);
      rethrow;
    } finally {
      setPending(false);
    }
  }

  return ServerActionState(
    pending: pending,
    data: data,
    error: error,
    invoke: invoke,
  );
}
