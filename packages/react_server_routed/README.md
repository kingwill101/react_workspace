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
  routed_core: ">=0.4.0 <1.0.0"

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

## Node, Bun, and Cloudflare

`react_server_routed` mounts into the same `routed_core.Engine` regardless of
the host. For Node or Bun, compile the Dart entrypoint to JavaScript and use
`serveNode` or `serveBun` from `routed_node`. The application can keep using
the generated Node SSR worker through `ReactSsrClient`.

For Cloudflare Workers, compile the Routed application to JavaScript and
export the engine through `defineCloudflareFetch` (or a lazy factory variant).
The JavaScript implementation of `ReactSsrClient` uses `fetch`, so the Worker
can call a separately deployed Node SSR endpoint. Configure that endpoint
through a Worker binding or secret rather than assuming a local subprocess.

The default generated `lib/ssr.dart` output is Node-specific: it imports Node
modules and starts an HTTP worker. Use the Fetch SSR target below when the
rendering endpoint must run as a Worker module.

The experimental Fetch target can be selected in `react.yaml`:

```yaml
ssr:
  entrypoint: lib/ssr.dart
  runtime: fetch
```

It emits a module-style Fetch SSR endpoint using React's
`renderToReadableStream`. Deploy that endpoint as the SSR service and point
the JavaScript `ReactSsrClient` at its URL. The host application and the SSR
service may be separate Workers or use different deployment targets.

The published `routed_cli: ^0.4.0` package understands the Routed engine
factory convention and can embed the generated Fetch SSR artifact with
`--ssr-entry`. The application must expose a `createEngine` or
`createCloudflareEngine(CloudflareEnvironment)` factory and use `/__ssr` as
its SSR endpoint.

The example includes an edge-safe factory in
`lib/cloudflare_app.dart`. From a Routed CLI checkout, its deployment shape is:

```bash
dart run react_tool:react build --release
dart run routed_cli:routed deploy --target cloudflare \
  --entry package:react_server_routed_example/cloudflare_app.dart \
  --ssr-entry build/react/ssr.entry.mjs \
  --dry-run
```

## Full example

See the [full Routed example](https://github.com/kingwill101/react_workspace/tree/master/packages/react_server_routed/example)
for a project generated with `react_tool:react init`. It includes React
codegen, browser and Node SSR builds, a generated server action, and a
Shelf-free `routed_io` server.

```sh
cd packages/react_server_routed/example
dart pub get
dart run react_tool:react build
dart run react_tool:react serve
```
