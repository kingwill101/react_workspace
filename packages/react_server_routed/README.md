# react_server_routed

Routed application handlers for React Dart SSR and server actions.

`react_server_routed` is the integration layer between the two portable kernels:

- `react_server` owns React SSR and the server-function protocol.
- `routed_core` owns HTTP routing, middleware, providers, and portable host
  contracts.
- `react_server_routed` composes those contracts without changing either core package.

The package provides `RoutedReactApplication`, which handles the React action
endpoint, document SSR, and a caller-supplied static fallback.

## Dependency

Routed Core is constrained normally and pinned through a dependency override to
the Routed GitHub repository:

```yaml
dependencies:
  routed_core: ^0.4.0

dependency_overrides:
  routed_core:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: master
      path: packages/routed_core
```

## Usage

```dart
final app = RoutedReactApplication(
  actionRegistry: registry,
  staticHandler: (context) => context.string('asset'),
  indexTemplate: '<div id="root">{{SSR}}</div><script>{{PROPS}}</script>',
  ssr: ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:3001')),
  rootComponent: 'app.App',
  pageProps: (context) => {'path': context.path},
);

final engine = Engine();
app.mount(engine);
```

Mount the application after specific API routes. Use `routed_io` or
`routed_node` to choose the actual deployment host.

## Full example

See [`example/`](example/) for a project generated with `react_tool:react
init`. It includes React codegen, browser and Node SSR builds, a generated
server action, and a Shelf-free `routed_io` server.

```sh
cd packages/react_server_routed/example
dart pub get
dart run react_tool:react build
dart run react_tool:react serve
```
