# React Dart Server & SSR (`react_server`)

Server-side rendering (SSR) and server orchestration for React Dart.

## Ecosystem Role

`react_server` provides the portable server runtime for React Dart applications: SSR worker communication, server-function context, registries, and protocol types. It does not depend on a particular HTTP framework.

Shelf applications should add [`react_server_shelf`](../react_server_shelf) separately. Routed applications can depend on `react_server` without bringing Shelf into their package graph.

## Installation

Add `react_server` to your `dependencies`:

```yaml
dependencies:
  react_server:
    path: packages/react_server
```

## How to Use

### Rendering Components

Register your root rendering factory, which accepts the application properties and returns the root `ReactNode`:

```dart
import 'package:react_server/react_server.dart';
import 'package:app/app.react.dart';

void main() {
  registerServerHandler((request) {
    // Read route or session properties passed from the HTTP layer
    final url = request['url'] as String;
    return App(url: url);
  });
}
```

### SSR Invocation

The `renderToString` method expands the `ReactNode` tree recursively and forwards it to `ReactDOMServer.renderToString`. Components are intelligently expanded via `React.createElement` so that standard React hooks (like `useContext` and `useMemo`) execute with full accuracy on the backend.

```dart
import 'package:react_server/react_server.dart';
import 'package:app/app.react.dart';

String render(String url) {
  return renderToString(App(url: url));
}
```

## Architecture Notes

- **Tree Expansion:** To render on the server, `react_server` traverses the `ReactNode` tree and expands component nodes dynamically. It registers generated components and foreign JS wrappers, passing mapped properties to JavaScript. 
- **Error Boundaries:** React natively struggles to recover from render-time errors on the server without crashing the response. `react_server` tracks `ErrorBoundary` boundaries and provides a fallback mode. If a render fails, it catches the exception and gracefully retries rendering, substituting the failed component's boundary with its defined fallback tree.
- **Server Function Context:** This package also defines `ServerFunctionContext`, which is injected into your `@serverFunction`s to access HTTP request headers, sessions, and response cookies.
