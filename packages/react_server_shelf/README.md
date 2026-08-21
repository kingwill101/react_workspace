# react_server_shelf

Optional Shelf integration for `react_server`. It handles server-function
requests, SSR documents, and static fallback without adding Shelf to the
portable server package.

## Installation

```yaml
dependencies:
  react_server: ^0.1.0
  react_server_shelf: ^0.1.0
  shelf: ^1.4.0
```

## Application handler

```dart
final app = ReactServerApp(
  actionRegistry: actionRegistry,
  staticHandler: staticHandler,
  indexTemplate: indexTemplate,
  ssr: ReactSsrClient(endpoint: Uri.parse(ssrUrl)),
  rootComponent: 'package:my_app/lib/app.dart#App',
  pageProps: (request) => {'path': request.requestedUri.path},
);

final server = await shelf_io.serve(app.handler, '0.0.0.0', 8080);
```

`ReactServerApp` routes `/__react/actions` to generated server functions,
renders application documents through the SSR client, and delegates asset
requests to the supplied Shelf handler.

Use `createServerActionHandler` when integrating only the action endpoint into
an existing Shelf pipeline.

## Testing

Compose the real handler with `ShelfRequestHandler` from
`server_testing_shelf` and use `ReactTestHarness` for built assets and the
Node worker. This keeps tests on the same application path used in production.
