# react

> Pure Dart representations of React trees and hook primitives.

The `react` package is the foundation of the React Dart workspace. It provides the **platform-agnostic** primitives needed to describe a UI tree and manage component state. It does *not* contain any JavaScript interoperability or browser-specific DOM code. 

## Role in the Ecosystem

This package defines:
- **`ReactNode`**: The sealed class hierarchy that represents all valid nodes in a React tree (components, host nodes, text, fragments, etc.).
- **Hooks**: Core React hooks like `useState`, `useEffect`, and `useLayoutEffect`.
- **Annotations**: The `@React()` annotation used by `react_codegen` to generate boilerplate-free functional components.

Because this package is pure Dart, it can be imported anywhere—including server-side code for SSR without triggering `dart:js_interop` constraints.

## Installation

This package is part of the React Dart workspace. Depending on it usually happens via path dependency within the workspace:

```yaml
dependencies:
  react:
    path: ../../packages/react
```

## Core Concepts & API

### The Node Tree

Every component in React Dart eventually returns a `ReactNode`. The `react` package exposes sealed types that describe this tree:

- `Component<P>`: A Dart component node with typed props and a `ComponentId`.
- `HostNode<P>`: A native element (e.g., a `div` or `span`), identified by a `HostType`.
- `ForeignComponent`: A component backed by a JS/TypeScript implementation (e.g., loaded via TSX/Vite).
- `Text`: A raw text node.
- `Fragment`: A grouping of multiple nodes without an enclosing DOM element.
- `Empty`: A node representing `null` or an empty render.

### Defining Components

You typically don't instantiate `Component` nodes directly. Instead, you use the `@React()` annotation, and `react_codegen` generates the factory functions for you:

```dart
import 'package:react/react.dart';

import 'my_button.react.dart'; // Generated file

@React()
ReactNode MyButton({
  required String label,
  required VoidCallback onClick,
}) {
  return foreignComponent(
    'SomeDesignSystemButton',
    props: {'onClick': onClick, 'label': label},
  );
}
```

### Hooks

The `react` package exports the standard React hooks, which delegate to the underlying active `ReactRuntime` (like `JsBinding` provided by `react_js`):

```dart
import 'package:react/react.dart';

@React()
ReactNode Counter() {
  final (count, setCount) = useState<int>(0);

  useEffect(() {
    print('Counter mounted or updated: $count');
    return () => print('Cleanup');
  }, [count]);

  // UI rendering goes here...
  return Text('Count: $count');
}
```

### Working with Third-Party JS Components

To render a component from the JavaScript ecosystem that isn't wrapped by Dart yet, use `foreignComponent`:

```dart
foreignComponent(
  'DatePicker',
  props: {'value': selectedDate, 'onChange': handleDateChange},
  children: [],
)
```

## Relationship to other packages

- **`react_js`**: Implements the actual React execution by taking the `ReactNode` tree from this package and building an equivalent `dart:js_interop` object tree.
- **`react_web`**: Builds on `react` by providing specialized `HostNode` factories for standard HTML elements (`div`, `span`, etc.).
- **`react_codegen`**: Looks for `@React()` annotations from this package to generate component wrappers.
