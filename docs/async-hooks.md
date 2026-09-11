# Portable asynchronous hooks

`useFuture<T>` and `useStream<T>` from `package:react_core/react.dart` expose a
`ReactAsyncSnapshot<T>` with phase, data, error, and stack trace. Phases are
`none` (disconnected), `waiting`, `active` (stream data/error), and `done`.

Keep the Future stable between renders, for example by creating it through
`useMemo`. Creating a new Future on every render restarts observation.

```dart
final request = useMemo(() => repository.loadItems(), [repository]);
final items = useFuture(request);
if (items.hasError) return Text('Unable to load items');
if (items.isWaiting) return Text('Loading');
return Text('${items.data}');
```

Replacing a source starts a new snapshot using `initialData`; it does not keep
the previous source's value. Passing null disconnects the source. Changes to
`initialData` alone do not restart observation. Future cleanup ignores late
completions; it cannot cancel underlying work. Stream cleanup cancels the
subscription. Stream errors remain observable without preventing later data
from recovering; completion retains the last data/error.

SSR never subscribes or starts effects. Provide the same initial data to server
and client for consistent initial output. Future rejection handling outside
the client lifecycle remains the caller's responsibility during SSR.

Use `HookTestHarness` from `react_testing` to render a single hook-owning
component repeatedly. It preserves state and commits effect cleanup on source
replacement and disposal. After async work settles, call `render` again to
observe the new snapshot. `HookTestHarness(server: true)` suppresses effects.
The harness does not emulate browser scheduling or concurrent React rendering.
