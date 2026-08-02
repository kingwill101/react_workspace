// Typed React bindings for bloc.
//
// bloc is a pure-Dart state library, so this wrapper is fully portable: it
// runs on the native VM (unit tests), in the browser, and in the SSR worker
// with no JavaScript shim and no npm dependency. The React bridge is
// `useSyncExternalStore` (subscribed to the bloc's stream) plus a React
// context (provider lookup).
//
// Docs: https://bloclibrary.dev (core package: package:bloc)
library;

import 'package:bloc/bloc.dart';
import 'package:react/react.dart';

/// React context carrying the nearest bloc instance.
///
/// The default is `null`; components that call [useBloc] must render under a
/// [blocProvider].
const ReactContext<Bloc?> blocScopeContext = ReactContext<Bloc?>(null);

/// Wraps [children] so they can resolve [bloc] through [useBloc].
///
/// Mirrors `BlocProvider` from flutter_bloc:
/// https://bloclibrary.dev/blocs/#accessing-data.
ReactNode blocProvider<T extends Bloc>(T bloc, List<ReactNode> children) =>
    blocScopeContext.provider(bloc, children);

/// Returns the nearest bloc from [blocProvider].
///
/// See https://bloclibrary.dev/blocs/#accessing-data.
T useBloc<T extends Bloc<dynamic, dynamic>>() {
  final bloc = useContext(blocScopeContext);
  if (bloc == null) {
    throw StateError(
      'useBloc called outside of blocProvider(...). '
      'Wrap the component tree in blocProvider(bloc, children).',
    );
  }
  return bloc as T;
}

/// Rebuilds this component whenever [bloc]'s state changes.
///
/// Subscribes to the bloc's stream and surfaces the current state through
/// `useSyncExternalStore`. The server snapshot returns the bloc's synchronous
/// `state`, so SSR renders the current state and hydration continues from it.
///
/// Mirrors `BlocBuilder` from flutter_bloc:
/// https://bloclibrary.dev/blocs/#blocbuilder.
S useBlocState<B extends Bloc<dynamic, S>, S>(B bloc) {
  return useSyncExternalStore<S>(
    (onChange) {
      final subscription = bloc.stream.listen((_) => onChange());
      return subscription.cancel;
    },
    () => bloc.state,
    () => bloc.state,
  );
}
