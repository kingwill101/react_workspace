# react_router_dom

Generated typed bindings for `react-router-dom` 6.26.x components, functions,
and hooks.

## Installation

```yaml
dependencies:
  react_router_dom: ^0.0.1
```

The package's `react.js` descriptor declares its npm dependency and browser/SSR
shims. `react build` provisions and bundles them automatically; applications
do not copy shims into `react.yaml`.

## Components

```dart
import 'package:react_router_dom/react_router_dom.dart';
import 'package:react_dom/react_dom.dart';

ReactNode appRoutes() => browserRouter(
  children: [
    routes(children: [
      route(key: 'home', path: '/', element: Home()),
      route(key: 'about', path: '/about', element: About()),
    ]),
  ],
);
```

The generated API includes router providers, links, routes, outlets, navigation
components, and typed value classes. `staticRouter` is the SSR counterpart for
an explicitly static location.

## Hooks

Hook bindings import `dart:js_interop` and run only in JavaScript targets
(browser or Node SSR worker), so they use a separate entrypoint:

```dart
import 'package:react_router_dom/react_router_dom_hooks.dart';
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode LocationView(({}) props) {
  final location = useLocation();
  final navigate = useNavigate();

  return button(
    type: 'button',
    onClick: (_) => navigate('/home'),
    children: [location.fullPath],
  );
}
```

`react_router_dom.dart` remains VM-importable for portable component trees and
tests. `ReactRouterLocation.fullPath` combines pathname, query, and fragment.

## Regeneration

The package declares two `react.js.bind` groups. From the package directory:

```console
dart run react_tool:react js install
dart run react_tool:react ts bind
dart format .
dart analyze --fatal-infos
dart test
```

Review generated Dart and JavaScript shim changes together. The server group
uses a type prefix to avoid declarations that collide with the browser group.
