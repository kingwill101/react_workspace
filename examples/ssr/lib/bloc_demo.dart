import 'package:bloc/bloc.dart';
import 'package:react_bloc/react_bloc.dart';
import 'package:react_web/react_web.dart';

/// A pure-Dart bloc counter (see the wrapper package `react_bloc`).
///
/// No shim, no npm, no bundling: `useBlocState` subscribes to the bloc's
/// stream and SSR reads `bloc.state` synchronously, so the server markup and
/// the hydrated client agree on the initial state.
///
/// The app renders this inside `blocProvider(blocCounterBloc, ...)`.
sealed class BlocCounterEvent {}

final class BlocIncrement extends BlocCounterEvent {}

final class BlocCounterBloc extends Bloc<BlocCounterEvent, int> {
  BlocCounterBloc() : super(0) {
    on<BlocIncrement>((event, emit) => emit(state + 1));
  }
}

/// Shared bloc: the same instance is used by SSR and the client, which is
/// what makes hydration start from identical state.
final BlocCounterBloc blocCounterBloc = BlocCounterBloc();

@reactComponent
ReactNode BlocDemo(({bool hidden}) props) {
  final bloc = useBloc<BlocCounterBloc>();
  final count = useBlocState(bloc);

  return div(
    key: 'bloc-demo',
    children: [
      const Text('Count (bloc): '),
      Text('$count'),
      button(
        key: 'bloc-inc',
        onClick: (_) => bloc.add(BlocIncrement()),
        children: const [Text('+1')],
      ),
    ],
  );
}
