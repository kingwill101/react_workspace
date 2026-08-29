# Routed React example

A complete React Dart application hosted by Routed. It demonstrates:

- React client and Node SSR bundles produced by `react_tool`;
- React server functions at `/__react/actions`; and
- Routed's host-neutral `Engine` mounted into the `routed_io` HTTP transport.

The example deliberately has no Shelf dependency. `react_server_routed` composes React
with `routed_core`; the application chooses `routed_io` as its host.

For day-to-day editing, the files you typically change are:

- `lib/app.dart` for UI.
- `lib/greeting.dart` for server actions.

Everything else is generated or build output (`lib/.generated/`, `build/react`) and is
safe to ignore during normal iteration.

For less editor noise, `.vscode/settings.json` hides generated and build
artifacts by default.

## Setup

```sh
dart pub get
```

The React packages use local paths, while Routed is resolved from the GitHub
`master` ref through the dependency override in `pubspec.yaml`.
The deployment CLI is the published `routed_cli: ^0.4.0` package.

## Build

```sh
dart run react_tool:react build
```

## Run

```sh
dart run react_tool:react serve
```

This builds the client and SSR bundles, starts the Node SSR worker on port
`3001`, and starts the Routed server on `http://localhost:8080`. Server
functions live in `lib/greeting.dart` and are registered by the generated
`lib/.generated/server_actions.g.dart`.

To run only the Dart server after a build, set `REACT_SSR_URL` yourself:

```sh
PORT=8080 REACT_SSR_URL=http://127.0.0.1:3001/ dart run bin/server.dart
```

## Test

```sh
# Fast tests (no JavaScript build)
dart test test/app_test.dart test/greeting_test.dart

# With coverage
dart run react_tool:react test --coverage
# or
dart test --coverage

# Full-stack SSR + server-function integration (builds + boots Node worker)
dart test test/full_stack_test.dart
```

Tests use `react_testing` on top of the transport-neutral `server_testing`
base. They compose the actual `RoutedReactApplication` and exercise it through
`RoutedRequestHandler` from `routed_testing`; no Shelf adapter is involved.
`test/full_stack_test.dart` also builds the browser and SSR bundles and boots
the generated Node worker.

## Analyze

```sh
dart run react_tool:react analyze
# verbose
dart run react_tool:react analyze --verbose
```

Uses `react_analysis` for component, hook and SSR diagnostics (same engine as the IDE plugin). Run `dart run react_tool:react doctor` to check setup.

## Cloudflare deployment

Build the Fetch-compatible SSR entry and deploy it with the published Routed
CLI:

```sh
dart run react_tool:react build --release
dart run routed_cli:routed deploy --target cloudflare \
  --entry package:react_server_routed_example/cloudflare_app.dart \
  --ssr-entry build/react/ssr.entry.mjs \
  --name react-routed-demo
```

The CLI embeds the complete `build/react` directory, mounts the SSR entry at
`/__ssr`, and serves the browser bundle, CSS, and assets through the Worker.

## Docker

The multi-stage `Dockerfile` builds the server binary and JS bundles in
stage 1 and runs them in a slim Node runtime. Build it from the workspace
root so the context includes the `packages/` directory:

```sh
docker build -f example/Dockerfile .
```
