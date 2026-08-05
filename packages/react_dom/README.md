# react_dom

> DOM mounting and hydration for React Dart applications.

The `react_dom` package provides the entrypoints for rendering a React Dart application in the browser. It links the pure Dart components (`package:react`) and the JS renderer engine (`package:react_js`) to `ReactDOM`, allowing you to attach your UI to the HTML document.

## Role in the Ecosystem

While `react` defines *what* to render and `react_js` defines *how* to translate it to JS, `react_dom` answers *where* to render it. It exposes the top-level API to mount your application to the page or hydrate server-side rendered HTML.

## Installation

This package is part of the React Dart workspace. Depending on it usually happens via path dependency within the workspace:

```yaml
dependencies:
  react_dom:
    path: ../../packages/react_dom
```

## API Reference & Usage

### Initialization

Before mounting or hydrating, you need to ensure the React Dart runtime is initialized. Usually, this is handled automatically or explicitly in your client entrypoint.

### Mounting (Client-Side Rendering)

To mount a React Dart application to a fresh DOM node (Standard CSR), use the `mount` function.

```dart
import 'dart:js_interop';
import 'package:react_dom/react_dom.dart';
import 'package:react_web/react_web.dart';

import 'app.react.dart'; // Your root component

void main() {
  initReact(); // Sets up the browser runtime, adapters, and bindings
  
  final rootElement = document.getElementById('root');
  if (rootElement != null) {
    mount(rootElement as JSObject, App());
  }
}
```

### Hydrating (Server-Side Rendering)

If your HTML was rendered on the server (using the SSR worker), use `hydrate` to attach event listeners and interactivity without destroying the existing DOM tree.

```dart
import 'dart:js_interop';
import 'package:react_dom/react_dom.dart';

import 'app.react.dart';

void main() {
  initReact();
  
  final rootElement = document.getElementById('root');
  if (rootElement != null) {
    // You can check if the root has SSR content
    if (hasSSRContent(rootElement as JSObject)) {
      hydrate(rootElement, App());
    } else {
      mount(rootElement, App());
    }
  }
}
```

### Fetching SSR Initial Props

When using SSR, the server can pass serialized props down to the client in a special `<script id="__props">` tag. `react_dom` provides a helper to extract these properties on the client.

```dart
void main() {
  initReact();
  
  final initialProps = getInitialProps();
  
  final rootElement = document.getElementById('root');
  hydrate(rootElement as JSObject, App(config: initialProps['config']));
}
```

## Relationship to other packages

- **`react_js`**: `react_dom` initializes the `JsRenderer` and `JsBinding` from `react_js` when `initReact()` is called, setting up the runtime environment.
- **`react_web`**: Required for browser adapters and DOM element bindings. `react_dom` often uses `react_web` internally during initialization.
