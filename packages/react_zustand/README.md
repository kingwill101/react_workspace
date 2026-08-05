# React Zustand

Typed Dart bindings for the [Zustand](https://zustand-demo.pmnd.rs) hook bridge.

## Ecosystem Role
Demonstrates how to integrate JS-based state management (Zustand) into the React Dart ecosystem. Useful for wrapping existing JavaScript/TypeScript state stores.

## Installation
```yaml
dependencies:
  react_zustand: path: ../react_zustand
```

## Core Usage

The underlying store is created inside the bundled JS shim (`react_zustand_shim.mjs`). This package provides the `@JS` externals to read it from Dart.

```dart
import 'package:react/react.dart';
import 'package:react_zustand/react_zustand.dart';

ReactNode counterView() {
  // Safe to call from any component under the React tree
  final count = useCount();
  final doubled = useDoubled();

  return div(
    children: [
      text('Count: $count (Doubled: $doubled)'),
      button(
        onClick: (_) => inc(),
        children: [text('Increment')],
      )
    ],
  );
}
```

## Architecture & Design Notes
- **JS Interop**: Everything relies on `dart:js_interop` and runs only in JS environments (browser client and Node SSR worker). It cannot run on the native VM.
- **Integration**: The JS shim wires Zustand up through `useSyncExternalStore` so the React tree stays reactive to store updates.
- **Relationship**: Serves as a great example of how to wrap JS-ecosystem hooks and state libraries using the `react_js` module shims.
