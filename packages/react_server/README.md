# react_server

Transport-neutral SSR and server-function runtime for React Dart.

The package contains the server-function context and registry, the VM-side SSR
worker client, and the Node-side React renderer. It has no Shelf or Routed
dependency.

## Installation

```yaml
dependencies:
  react_server: ^0.1.0
```

Choose a separate HTTP adapter:

```yaml
dependencies:
  react_server_routed: ^0.1.0
  # or
  react_server_shelf: ^0.1.0
```

## Server functions

Create one registry and let generated code populate it:

```dart
import 'package:my_app/.generated/server_actions.g.dart';
import 'package:react_server/react_server.dart';

final actions = ServerFunctionRegistry();

void registerActions() {
  registerServerActions(registry: actions);
}
```

Each handler receives a `ServerFunctionContext` containing request metadata,
authentication state, request headers, deadlines, and cancellation. Concrete
server adapters translate their request type into this context.

## SSR worker client

The Dart VM server communicates with the generated Node worker through
`ReactSsrClient`:

```dart
final ssr = ReactSsrClient(
  endpoint: Uri.parse('http://127.0.0.1:3001/'),
);

final document = await ssr.render(
  component: 'package:my_app/lib/app.dart#App',
  props: {'title': 'Dashboard'},
);
```

`ReactSsrDocument` contains rendered HTML and serialized props. The HTTP
adapter injects both into the configured index template.

## Caching and lifecycle primitives

`ReactDocumentCache` is an in-process document cache. When documents must be
shared between processes or survive restarts, provide a `ReactDocumentStore` to
the selected HTTP adapter. The store receives the document TTL, stale-while-
revalidate window, and cache tags, so a Redis, database, disk, or edge-KV
implementation can preserve the same application contract.

`ReactDataCache` provides typed data caching with concurrent-load
deduplication, stale-while-revalidate, and tag invalidation:

```dart
final data = ReactDataCache();
final user = await data.getOrLoad<User>(
  'user:$id',
  () => loadUser(id),
  ttl: const Duration(minutes: 5),
  tags: ['user:$id'],
);
```

Server functions can schedule non-critical work with
`ServerFunctionContext.scheduleAfterResponse`. The Routed and Shelf adapters
drain these callbacks after the action handler completes. Deployment-specific
durable background-work guarantees remain the responsibility of the host.

## Node renderer entrypoint

The application's `lib/ssr.dart` is compiled to JavaScript. It imports hidden
generated factories and registries, registers component builders, and calls
`registerGlobalRenderer`. The generated Node runtime then invokes
`renderToString` inside a real React render stack, preserving hooks, contexts,
foreign components, suspense, refs, memoization, and error boundaries.

## Package boundary

- HTTP request/response handling belongs in `react_server_routed` or
  `react_server_shelf`.
- Protocol annotations and browser clients belong in `react_actions`.
- Build and worker process orchestration belongs in `react_tool`.
- Test fixtures belong in `react_testing` and compose with the selected
  `server_testing` adapter.
