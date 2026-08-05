# react_web

> HTML element factories, DOM bindings, and browser events for React Dart.

The `react_web` package provides the typed factories needed to construct HTML elements (like `div`, `span`, and `button`) within a React Dart tree. It encapsulates all web-specific DOM typings and event handlers.

## Role in the Ecosystem

Since `package:react` provides a generic, cross-platform tree structure (`ReactNode` and `HostNode`), `react_web` specializes that tree for the browser. 

It provides:
- **Element Factories**: Functions like `div(...)`, `button(...)`, `input(...)` that output `HostNode`s matching standard HTML tags.
- **Typed Events**: React Synthetic Event definitions (e.g., `SyntheticMouseEvent`, `SyntheticChangeEvent`) generated for Dart.
- **DOM Typings**: Re-exports safe browser typings to interact with standard DOM elements.
- **Browser Adapters**: Utilities to hook into the runtime to provide browser-specific implementations for HTTP fetching and SSR metadata.

## Installation

This package is part of the React Dart workspace. Depending on it usually happens via path dependency within the workspace:

```yaml
dependencies:
  react_web:
    path: ../../packages/react_web
```

## API Reference & Usage

### Constructing UI using Element Factories

`react_web` exposes functions mirroring standard HTML tags. These functions take typed properties (like `className`, `id`, `onClick`, `disabled`) and return a `ReactNode`.

```dart
import 'package:react_web/react_web.dart';

ReactNode myWidget() {
  return div(
    className: 'container',
    id: 'main-wrapper',
    children: [
      h1(children: [Text('Hello World')]),
      button(
        className: 'primary-btn',
        onClick: (event) {
          print('Button clicked at X: ${event.clientX}');
        },
        children: [Text('Click Me')],
      ),
    ],
  );
}
```

### Typed Events

When passing event handlers to web factories, you receive typed React synthetic events rather than raw DOM events. This ensures cross-browser consistency, matching React JS behavior.

```dart
input(
  type: 'text',
  value: currentText,
  onChange: (SyntheticChangeEvent<HTMLInputElement> event) {
    // Safely access the typed target
    print('New value: ${event.target.value}');
  },
)
```

### Browser Runtime Adapters

`react_web` provides initialization functions to plug web-specific features into the React Dart runtime, which are typically called by `react_dom` during client hydration, or by the SSR entrypoints.

- `registerBrowserAdapters()`: Hooks up logging, networking, and environment bindings.
- `installBrowserWebRuntime()`: Configures global features required by the generated DOM output.

## Relationship to other packages

- **`react`**: `react_web` builds on `react` by generating `HostNode`s configured for HTML tags.
- **`react_dom`**: Uses `react_web` internally to configure the browser runtime environment.
- **`react_codegen`**: Often works in tandem; your generated components will compose the elements exported by `react_web`.

## Platform Notes

While the element factories (like `div`, `span`) output pure `ReactNode` trees and are safe to use in SSR environments (Node.js/Workers), the actual execution of DOM interactions or typed event accesses requires a browser context or a JS DOM abstraction.
