# React Router

Typed React Router bindings for `react-router-dom` v6 in the React Dart ecosystem.

## Ecosystem Role
Provides typed navigation, route matching, and SSR URL handling for React Dart apps. It utilizes the general purpose `foreignComponent` bridge for components and exposes typed `use*` hooks generated from TypeScript declarations.

## Installation
Add the package to your workspace:
```yaml
dependencies:
  react_router: path: ../react_router
```

Ensure your `react.yaml` or pubspec's `react` section wraps the npm package appropriately, relying on the shipped shims.

## Core Usage

### Routing Components
Components are rendered through the generic foreign-component bridge (`foreignComponent`), exposed as typed helpers in `react_router.dart`:

```dart
import 'package:react_router/react_router.dart';
import 'package:react/react.dart';

ReactNode myApp() {
  return browserRouter(
    children: [
      routes(
        children: [
          route(path: '/', element: Home()),
          route(path: '/about', element: About()),
        ],
      )
    ]
  );
}
```

### Typed Hooks
The typed `use*` hooks import `dart:js_interop` and run only in JS targets (browser client and SSR worker). Import them explicitly:

```dart
import 'package:react_router/react_router_hooks.dart';
import 'package:react/react.dart';

ReactNode profile() {
  final params = useParams();
  final navigate = useNavigate();

  return div(
    children: [
      text('User ID: ${params['id']}'),
      button(
        onClick: (e) => navigate('/home'),
        children: [text('Go Home')]
      )
    ]
  );
}
```

## Architecture & Design Notes
- **SSR Handling**: The library exports `react_router_server_bindings.g.dart` providing `staticRouter` (the SSR counterpart to `browserRouter`). 
- **Type Safety**: Hooks run through the shim's `globalThis.__reactDartBindings.reactRouter` bridge during render and decode into typed values.
- **JS Isolation**: Hooks are separated into `react_router_hooks.dart` because they rely on JS interop, ensuring pure VM (non-JS) tests and consumers don't break.
