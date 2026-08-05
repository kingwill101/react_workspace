# React Riverpod

Typed React bindings for [Riverpod](https://riverpod.dev).

## Ecosystem Role
Integrates the powerful `Riverpod` state management library with the React Dart ecosystem. Being a pure-Dart library, the wrapper is entirely portable—running on the native VM, browser, and SSR worker without npm dependencies or JS shims.

## Installation
```yaml
dependencies:
  react_riverpod: path: ../react_riverpod
```

## Core Usage

Wrap your application in a `riverpodScope` and provide a `ProviderContainer`. Read and watch providers using `useRiverpod`.

```dart
import 'package:react/react.dart';
import 'package:react_riverpod/react_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

ReactNode app() {
  final container = ProviderContainer();
  return riverpodScope(
    container,
    [CounterView()],
  );
}

ReactNode counterView() {
  final count = useRiverpod(counterProvider);
  final container = useContext(riverpodScopeContext)!;

  return div(
    children: [
      text('Count: $count'),
      button(
        onClick: (_) => container.read(counterProvider.notifier).state++,
        children: [text('Increment')],
      )
    ],
  );
}
```

## Architecture & Design Notes
- **React Integration**: Uses React's `useSyncExternalStore` bridged to `container.listen`, mirroring the behavior of `hooks_riverpod`'s `watch`. Provider scopes are managed via a React Context.
- **SSR Ready**: The server snapshot uses the container's synchronous value, ensuring identical outputs during server-side rendering and client hydration.
- **Portability**: Pure Dart implementation ensures smooth execution across testing (VM), client (browser), and server (Node).
