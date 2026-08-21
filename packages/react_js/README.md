# react_js

> JavaScript bindings and renderer for React Dart.

The `react_js` package acts as the bridge between the pure Dart UI tree (defined in `package:react`) and the actual React JavaScript library. It uses modern `dart:js_interop` to translate Dart's `ReactNode`s into JavaScript React elements.

## Role in the Ecosystem

While `package:react` provides the cross-platform data structures, `react_js` provides the engine that executes them in a browser or Node/Edge JS environment. 

It exposes:
- **`JsRenderer`**: An exhaustive switch that traverses the `ReactNode` tree and emits JS React elements (`React.createElement`).
- **`JsBinding`**: The implementation of React hooks (`useState`, `useEffect`, etc.) that forwards calls to the global JS React instance.
- **Conversion Core**: Utilities for safely mapping Dart maps, lists, and callbacks into their JS equivalents to be passed as props.

## Installation

This package is part of the React Dart workspace. Depending on it usually happens via path dependency within the workspace:

```yaml
dependencies:
  react_js: ^0.1.0
```

## Architecture & Core Concepts

### The JavaScript Renderer

The `JsRenderer` is responsible for translating a Dart `ReactNode` tree. When rendering, it visits nodes like `Component`, `HostNode`, and `ForeignComponent` and maps them using JS interop. 

For example, when `JsRenderer` encounters a `ForeignComponent` (like `foreignComponent('DatePicker', ...)`), it resolves the JS component from the `globalThis.__reactDartForeignComponents` registry and creates a JS element.

### Interop and Props Conversion

Because Dart maps and lists are opaque to JS, `react_js` provides conversion utilities. Props passed to `HostNode`s or `ForeignComponent`s are translated safely. Event callbacks (e.g., `onClick`) are wrapped in bridges so that Dart closures can be invoked by React JS.

```dart
// Handled internally by react_js when converting a HostNode or ForeignComponent
final jsProps = convertPropsToJS(dartProps);
```

### Runtime Registry

For Dart components to be callable by React, they must be registered. `react_js` manages the `CodecRegistry` and interop layers that `react_codegen` targets when generating the `.react.g.dart` files.

## Relationship to other packages

- **`react`**: Defines the `ReactNode` tree that `react_js` translates.
- **`react_dom`**: Uses `react_js`'s `JsRenderer` and `JsBinding` to actually mount the application to the browser DOM.
- **`react_web`**: Exposes the HTML element builders whose output is eventually consumed and translated by `react_js`.

## Platform Notes

This package contains `dart:js_interop` imports and is structurally dependent on JS. It can be compiled to JavaScript via `dart compile js` for the browser, or bundled into a JS worker for Server-Side Rendering (SSR). It cannot run in the pure Dart VM unless executed via an embedded JS engine context.
