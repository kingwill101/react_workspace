# React Bloc

Typed React bindings for [bloc](https://bloclibrary.dev).

## Ecosystem Role
Brings the beloved Dart `bloc` state management library into the React Dart ecosystem. Since `bloc` is a pure-Dart library, this wrapper is fully portable across the native VM, the browser, and the Node SSR worker with zero JavaScript shims or npm dependencies.

## Installation
```yaml
dependencies:
  react_bloc: path: ../react_bloc
```

## Core Usage

Wrap your application or component tree in a `blocProvider` to provide the bloc instance, and then consume the state using `useBlocState`.

```dart
import 'package:react/react.dart';
import 'package:react_bloc/react_bloc.dart';
import 'package:bloc/bloc.dart';

class CounterBloc extends Bloc<int, int> {
  CounterBloc() : super(0) {
    on<int>((event, emit) => emit(state + event));
  }
}

ReactNode app() {
  final bloc = CounterBloc();
  return blocProvider(
    bloc,
    [CounterView()],
  );
}

ReactNode counterView() {
  final bloc = useBloc<CounterBloc>();
  final state = useBlocState<CounterBloc, int>(bloc);

  return div(
    children: [
      text('Count: $state'),
      button(
        onClick: (_) => bloc.add(1),
        children: [text('Increment')],
      )
    ],
  );
}
```

## Architecture & Design Notes
- **React Integration**: The bridge leverages React's `useSyncExternalStore` (subscribed to the bloc's stream) and React Context (for provider lookup).
- **SSR Hydration**: The server snapshot returns the bloc's synchronous `state`. During SSR, it renders the current state seamlessly, and hydration continues from it on the client.
- **Portability**: Fully pure Dart, runs anywhere Dart runs.
