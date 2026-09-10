# react_bloc

Portable React hooks and context helpers for
[Bloc](https://bloclibrary.dev). The package has no npm or JavaScript shim.

## Installation

```yaml
dependencies:
  react_bloc: ^0.0.1
```

## Usage

```dart
import 'package:bloc/bloc.dart';
import 'package:react_bloc/react_bloc.dart';
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode CounterView(({}) props) {
  final bloc = useBloc<CounterBloc>();
  final count = useBlocState(bloc);
  final isEven = useBlocSelector(bloc, (state) => state.isEven);

  return button(
    type: 'button',
    onClick: (_) => bloc.add(const Increment()),
    children: ['$count — ${isEven ? 'even' : 'odd'}'],
  );
}
```

Render the generated `CounterView` factory below a provider:

```dart
blocProvider(counterBloc, [CounterView()])
```

- `useBloc<T>()` resolves the nearest provider and checks its type. Both Bloc
  and Cubit are supported through `BlocBase`; nested providers shadow outer
  providers rather than searching ancestors by type.
- `useBlocState(bloc)` subscribes to and returns the whole state.
- `useBlocSelector(bloc, selector)` exposes a selected snapshot; return values
  should have stable equality semantics.

Subscriptions use `useSyncExternalStore`. The synchronous Bloc state is also
the SSR snapshot, so the client must hydrate with an equivalent initial Bloc
state.

For Cubit, use the same hooks: `useBloc<CounterCubit>()` and
`useBlocState(cubit)`. The caller owns the Bloc/Cubit instance and must close
it when its scope ends. Hook cleanup cancels subscriptions but does not close
the instance.
