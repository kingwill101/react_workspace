# react_riverpod

Portable React context and subscription bindings for
[Riverpod](https://riverpod.dev). The package has no npm or JavaScript shim.

## Installation

```yaml
dependencies:
  react_riverpod: ^0.0.1
```

## Usage

```dart
import 'package:react_dom/react_dom.dart';
import 'package:react_riverpod/react_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final countProvider = NotifierProvider<CountNotifier, int>(CountNotifier.new);

@reactComponent
ReactNode CounterView(({}) props) {
  final count = useRiverpod(countProvider);
  final container = useContext(riverpodScopeContext)!;

  return button(
    type: 'button',
    onClick: (_) => container.read(countProvider.notifier).state++,
    children: ['Count: $count'],
  );
}
```

Render the generated `CounterView` factory below a scope:

```dart
riverpodScope(container, [CounterView()])
```

`useRiverpod` accepts a `ProviderListenable<T>`, so Riverpod's own
`.select(...)` APIs can narrow rebuild snapshots. The hook uses
`useSyncExternalStore` and reads the same synchronous container value for
SSR. Hydration therefore requires an equivalent initial container state.
