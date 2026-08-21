import 'dart:async';

import 'package:react/react.dart';
import 'package:react_actions/react_actions.dart';

import 'generated/react_events.dart';
import 'generated/web/html.dart';
import 'generated/web/xhr.dart';

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

/// The state returned by [useOptimisticServerAction].
final class OptimisticServerActionState<TArgs, TState, TResult> {
  const OptimisticServerActionState({
    required this.state,
    required this.pending,
    required this.data,
    required this.error,
    required this.invoke,
  });

  /// The current optimistic state.
  final TState state;

  /// Whether the optimistic transition or server action is pending.
  final bool pending;

  /// The most recent successful server result.
  final TResult? data;

  /// The most recent invocation error, if any.
  final Object? error;

  /// Applies the optimistic update and invokes the server action.
  final Future<TResult> Function(TArgs arguments) invoke;
}

/// Typed convenience accessors for a browser [FormData] payload.
final class ServerActionFormData {
  /// Wraps a browser form-data object.
  const ServerActionFormData(this.data);

  /// The underlying generated Web API value.
  final FormData data;

  /// Returns a text field, or `null` when the field is absent or a file.
  String? text(String name) {
    final value = data.get_(name);
    return value is String ? value : null;
  }

  /// Returns all text values for a repeated field.
  List<String> texts(String name) => [
    for (final value in data.getAll(name))
      if (value is String) value,
  ];

  /// Returns a parsed integer field.
  int? integer(String name) => int.tryParse(text(name) ?? '');

  /// Returns a parsed decimal field.
  double? number(String name) => double.tryParse(text(name) ?? '');

  /// Returns whether a checkbox-style field was submitted.
  bool checked(String name) => data.has(name);
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

/// Binds a server action to React 19's optimistic state and transitions.
///
/// [optimisticUpdate] runs immediately when `invoke` is called. React keeps
/// that state visible while the transition is pending and restores the
/// previous state when the action settles. The server result and error remain
/// available through `data` and `error`, just as with [useServerAction].
///
/// This hook requires a React runtime that supports `useOptimistic` and
/// `useTransition`.
OptimisticServerActionState<TArgs, TState, TResult>
useOptimisticServerAction<TArgs, TState, TResult>(
  ServerFunctionRef<TArgs, TResult> ref,
  TState initialState,
  TState Function(TState state, TArgs arguments) optimisticUpdate,
) {
  final action = useServerAction(ref);
  final (optimisticState, setOptimisticState) = useOptimistic<TState, TArgs>(
    initialState,
    optimisticUpdate,
  );
  final (transitionPending, startTransition) = useTransition();

  Future<TResult> invoke(TArgs arguments) {
    final result = Completer<TResult>();
    try {
      startTransition(() {
        setOptimisticState(arguments);
        action
            .invoke(arguments)
            .then(
              result.complete,
              onError: (Object error, StackTrace stack) {
                result.completeError(error, stack);
              },
            );
      });
    } catch (error, stack) {
      result.completeError(error, stack);
    }
    return result.future;
  }

  return OptimisticServerActionState(
    state: optimisticState,
    pending: transitionPending || action.pending,
    data: action.data,
    error: action.error,
    invoke: invoke,
  );
}

/// Creates a form submit handler for a [ServerActionState].
///
/// [decode] converts the browser [FormData] into the generated action's typed
/// argument record. The handler prevents native navigation and ignores a
/// second submit while the action is pending.
void Function(ReactFormEvent) serverActionSubmit<TArgs, TResult>(
  ServerActionState<TArgs, TResult> action,
  TArgs Function(FormData data) decode,
) {
  return (event) {
    event.preventDefault();
    if (action.pending) return;
    final form = event.currentTarget as HTMLFormElement;
    unawaited(action.invoke(decode(FormData(form))));
  };
}

/// Creates a form submit handler using [ServerActionFormData] accessors.
void Function(ReactFormEvent) serverActionFormSubmit<TArgs, TResult>(
  ServerActionState<TArgs, TResult> action,
  TArgs Function(ServerActionFormData data) decode,
) => serverActionSubmit(action, (data) => decode(ServerActionFormData(data)));

/// Extracts field messages from a structured server-action failure.
///
/// Server functions can return field errors by throwing
/// `ServerFunctionFailure(details: {'fieldErrors': {'email': 'Invalid'}})`.
/// Unknown detail values are ignored, so this helper is safe to use for every
/// action error.
Map<String, String> serverActionFieldErrors(Object? error) {
  if (error is! RemoteServerFunctionException) return const {};
  final raw = error.details?['fieldErrors'];
  if (raw is! Map) return const {};
  return Map<String, String>.fromEntries(
    raw.entries
        .where((entry) => entry.key is String && entry.value is String)
        .map(
          (entry) => MapEntry<String, String>(
            entry.key as String,
            entry.value as String,
          ),
        ),
  );
}
