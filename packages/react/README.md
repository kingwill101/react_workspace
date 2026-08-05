# react

> Pure Dart AST representations of React trees, host elements, and hook primitives.

The `react` package is the core foundation of the React Dart workspace. It provides platform-agnostic primitives to describe a UI component tree and manage component state. It contains **zero** `dart:js_interop` code or browser-specific dependencies, ensuring complete platform portability across Dart VM (SSR, testing, CLI) and JavaScript runtimes (browsers, Node.js).

---

## Role in the Ecosystem

This package defines:
- **`ReactNode`**: The sealed class hierarchy representing all nodes in a React tree (`Component`, `HostNode`, `ForeignComponent`, `Text`, `Fragment`, `Empty`).
- **`HostNode` & `HostType`**: Abstract platform-neutral representations of native host elements (such as HTML tags like `div`, `span`, `input`).
- **Hook Primitives**: Standard React hooks (`useState`, `useEffect`, `useLayoutEffect`, `useMemo`, `useCallback`, `useRef`, `useContext`, `useReducer`, `useSyncExternalStore`).
- **Annotations**: `@ReactComponent` (or `@React()`) used by `react_codegen` to analyze and generate component factories and JS interop bridges.

Because `package:react` is pure Dart, component files can be compiled and executed on native Dart VM servers for Server-Side Rendering (SSR) as well as inside browser JavaScript engines without triggering platform compilation errors.

---

## Installation

Declare a path dependency in your workspace package `pubspec.yaml`:

```yaml
dependencies:
  react:
    path: ../../packages/react
```

---

## What is `HostNode` and Why Is It Important?

In React, the UI tree consists of user-defined functional components and **host elements** (native platform elements, such as `<div>`, `<span>`, `<button>`, `<input>`).

In traditional web frameworks, host elements are tightly coupled to browser DOM types (`dart:html` or `package:web`). However, importing browser DOM types into component files breaks Dart VM compilation when running on non-browser targets (such as SSR servers, CLI tools, or native VM unit tests).

`package:react` solves this by introducing **`HostNode<P>`**:

```dart
final class HostNode<P extends Record> extends ReactNode {
  final HostType hostType;
  final P props;
  final Object? key;
  final List<ReactNode> children;
}
```

### Why `HostNode` Matters for SSR and Cross-Platform React

1. **Decoupling Abstract AST from Platform Renderers**
   `HostNode` stores element tags (e.g. `'div'`, `'input'`) and props as pure Dart records without referencing JS objects or DOM elements. Renderer packages (`react_js`, `react_dom`, `react_server`) decide how to materialize a `HostNode`:
   - On the web client (`react_js` / `react_dom`), `HostNode` is converted into a `React.createElement` JS object.
   - On the SSR server (`react_server`), `HostNode` is rendered to pure HTML string markup.

2. **Isomorphic Component Definitions**
   Component code written with `HostNode` runs identically during server rendering and client hydration. The compiler never encounters `dart:js_interop` extension types in component source files.

3. **Strict Contract Preservation**
   `HostNode` enforces exact prop contracts and child node structures across server and client boundaries, preventing hydration mismatch errors.

---

## Core API & Node Types

Every React Dart component function returns a `ReactNode`:

| Node Type | Purpose | Example |
|---|---|---|
| `Component<P>` | Dart component node with typed props record and `ComponentId`. | Output by `@ReactComponent` generated factories. |
| `HostNode<P>` | Native platform element (HTML tag or native host component). | `div(...)`, `input(...)`, `button(...)` |
| `ForeignComponent` | Component implemented in external JS/TS (e.g. TSX / Vite bundle). | `foreignComponent('DatePicker', props: {...})` |
| `Text` | Primitive text string node. | `Text('Hello World')` |
| `Fragment` | Logical grouping of nodes without an enclosing DOM element. | `Fragment([nodeA, nodeB])` |
| `Empty` | Represents `null` or absent render output. | `Empty()` |

---

## Defining Components with `@ReactComponent`

Functional components are defined using the `@ReactComponent` annotation. A component receives a named Dart record containing its props:

```dart
import 'package:react/react.dart';

import 'user_card.react.dart'; // Generated factory file

@ReactComponent
ReactNode UserCard(({
  required String name,
  required String role,
  String? avatarUrl,
}) props) {
  final (isHovered, setHovered) = useState<bool>(false);

  return HostNode(
    const HostType('div'),
    (
      className: isHovered ? 'card hover' : 'card',
      onMouseEnter: (_) => setHovered(true),
      onMouseLeave: (_) => setHovered(false),
    ),
    children: [
      Text('${props.name} - ${props.role}'),
    ],
  );
}
```

*Note: In practice, web applications use `package:react_web` which provides convenient HTML factories like `div(...)` and `span(...)` built on top of `HostNode`.*

---

## React Hooks API

`package:react` exports standard React hooks. At runtime, hooks delegate to the active `ReactRuntime` registered by `react_js` or `react_server`:

```dart
import 'package:react/react.dart';

@ReactComponent
ReactNode Counter(({int initialCount}) props) {
  final (count, setCount) = useState<int>(props.initialCount ?? 0);

  useEffect(() {
    print('Count updated to: $count');
    return () => print('Cleaning up effect');
  }, [count]);

  final handleIncrement = useCallback(() {
    setCount(count + 1);
  }, [count]);

  return HostNode(
    const HostType('button'),
    (onClick: (_) => handleIncrement()),
    children: [Text('Count: $count')],
  );
}
```

Available hooks:
- `useState<T>(initial)` -> `(T value, void Function(T) setValue)`
- `useEffect(effect, [deps])`
- `useLayoutEffect(effect, [deps])`
- `useMemo<T>(factory, [deps])`
- `useCallback<T>(callback, [deps])`
- `useRef<T>(initial)` -> `Ref<T>`
- `useContext<T>(context)`
- `useReducer<S, A>(reducer, initialState)`
- `useSyncExternalStore<T>(subscribe, getSnapshot, [getServerSnapshot])`

---

## Rendering Foreign JS/TSX Components

To render a third-party React component from JavaScript/TypeScript without manual interop boilerplate, use `foreignComponent`:

```dart
foreignComponent(
  'RadixDialog',
  props: {
    'open': isOpen,
    'onOpenChange': (val) => setOpen(val),
  },
  children: [/* children nodes */],
);
```

---

## Relationship to Other Workspace Packages

- **`react_web`**: Builds on `package:react` by specializing `HostNode` into strongly-typed HTML element factories (`div`, `button`, `input`) and wrapping web/DOM APIs into portable representations.
- **`react_js`**: Materializes `ReactNode` trees into JavaScript objects (`React.createElement`) on browser targets.
- **`react_codegen`**: Analyzes `@ReactComponent` annotations and generates `.react.dart` factories and JS bridge bindings.
- **`react_server`**: Renders `ReactNode` trees to HTML strings on Dart VM server targets for SSR.
