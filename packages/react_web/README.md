# react_web

> Portable `package:web` wrappers, HTML element factories, and DOM event abstractions for React Dart.

`react_web` provides the typed HTML element factories (like `div`, `span`, `input`, `button`) and DOM event definitions used to build web user interfaces in React Dart.

---

## Role in the Ecosystem

While `package:react` provides pure platform-agnostic UI node structures (`HostNode`), `react_web` specializes those structures for web applications.

Crucially, `react_web` acts as a **portable wrapper around `package:web`**. It exposes the complete DOM API surface supported by `package:web` (`EventTarget`, `HTMLInputElement`, `HTMLSelectElement`, `ReactChangeEvent`, `MessageEvent`, `Window`, `Document`, etc.) wrapped in platform-neutral representations.

```
                      ┌──────────────────────────────┐
                      │     package:react_web        │
                      │  Portable Web Abstractions   │
                      └──────────────┬───────────────┘
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
┌───────────────────────────┐                       ┌───────────────────────────┐
│ Browser Client (Web JS)   │                       │ Server Runtime (Dart VM)  │
│ Delegates to package:web  │                       │ Portable Stubs & Selective│
│ & JS Interop Extension    │                       │ Server-Side DOM Support   │
└───────────────────────────┘                       └───────────────────────────┘
```

---

## Why Portable `package:web` Wrappers Are Essential for SSR

### The Problem with Direct `package:web` Imports
`package:web` uses `dart:js_interop` extension types that bind directly to browser JavaScript globals (`window`, `document`, `HTMLInputElement`). If component files import `package:web` or `dart:html` directly:
- The Dart VM compiler fails when building or running server-side code (SSR), because `dart:js_interop` extension types cannot execute on native Dart VM targets.
- Universal component sharing between client and server becomes impossible.

### The `react_web` Solution
`react_web` wraps all `package:web` types into **portable representations**:

1. **Client-Side (Web JS)**: Wrappers delegate directly to underlying `package:web` JS interop objects with zero overhead.
2. **Server-Side (Dart VM / SSR)**: Wrappers map to safe, portable Dart stubs. Selective server-side support allows components to query headers, inspect document metadata, or evaluate layout constraints during SSR without crashing on missing browser globals.
3. **Proper SSR Support**: Components (`.dart`) can be shared 100% between browser client-side hydration and server-side Dart VM rendering.

---

## Installation

Declare a path dependency in your workspace package `pubspec.yaml`:

```yaml
dependencies:
  react_web:
    path: ../../packages/react_web
```

---

## Core Features & Usage

### 1. HTML Element Factories

`react_web` exports functions matching standard HTML tags (`div`, `span`, `input`, `button`, `select`, `textarea`, `form`, `h1`–`h6`, `a`, `img`, `canvas`, etc.).

```dart
import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

@ReactComponent
ReactNode SearchBar(({
  required String query,
  required void Function(String) onQueryChange,
}) props) {
  return div(
    className: 'search-wrapper',
    children: [
      span(className: 'icon', children: [Text('🔍')]),
      input(
        type: 'text',
        value: props.query,
        placeholder: 'Search...',
        className: 'search-input',
        onChange: (event) {
          // Strongly-typed access via Portable HTMLInputElement
          final input = event.target as HTMLInputElement;
          props.onQueryChange(input.value);
        },
      ),
    ],
  );
}
```

### 2. Strongly-Typed React Synthetic Events

When passing event listeners (`onChange`, `onClick`, `onKeyDown`, `onFocus`), handlers receive strongly-typed synthetic event wrappers:

| Event Wrapper | Target / Context | Key Properties |
|---|---|---|
| `ReactChangeEvent<T>` | Inputs, selects, textareas | `target`, `currentTarget`, `preventDefault()` |
| `ReactMouseEvent<T>` | Buttons, clickable divs | `clientX`, `clientY`, `button`, `altKey`, `ctrlKey` |
| `ReactKeyboardEvent<T>` | Inputs, document listeners | `key`, `keyCode`, `altKey`, `ctrlKey`, `shiftKey` |
| `ReactFocusEvent<T>` | Form elements | `relatedTarget`, `target` |
| `ReactTouchEvent<T>` | Touch surfaces | `touches`, `targetTouches`, `changedTouches` |

```dart
button(
  className: 'action-btn',
  onClick: (ReactMouseEvent<HTMLButtonElement> event) {
    event.preventDefault();
    print('Click at position: ${event.clientX}, ${event.clientY}');
  },
  children: [Text('Submit')],
);
```

---

## Automatic Host Type Wiring & Zero `.toJS` Boilerplate

`react_web` integrates directly with `react_codegen`'s `HostTypeRef` system. 

When `react_codegen` inspects component props typed as `react_web` interfaces (e.g., `ReactChangeEvent<HTMLInputElement>`, `HTMLSelectElement`, `EventTarget`):

1. **Automatic Codec Selection**: `react_codegen` recognizes these types as `HostTypeRef` host values.
2. **`ReactCodecRegistry` Integration**: Generated JS bridge files (`.react.g.dart`) encode and decode parameters automatically using `ReactCodecRegistry.encodeHostValue` and `decodeHostValue`.
3. **No Manual Conversion**: Application code requires **no manual `.toJS` calls** or `dynamic` casting.

```dart
// Handlers stay 100% strongly typed and portable:
onChange: (e) => setSearch((e.target as HTMLInputElement).value)
```

---

## Browser Adapters & Runtime Setup

`react_web` includes adapters that hook browser-specific runtimes into the React Dart environment:

- `registerBrowserAdapters()`: Configures global networking, logging, and environment bindings.
- `installBrowserWebRuntime()`: Registers host-value decoders for DOM elements and synthetic events into `ReactCodecRegistry`.

These adapters are invoked automatically during client bootstrap by `react_dom` (`mount` / `hydrate`) and during SSR initialization by `react_server`.

---

## Relationship to Other Packages

- **`react`**: `react_web` specializes `package:react`'s abstract `HostNode` into typed HTML element factories.
- **`react_js`**: Provides the underlying `ReactCodecRegistry` where `react_web` registers host encoders/decoders.
- **`react_codegen`**: Analyzes `react_web` types (`HostTypeRef`) to generate bridge code automatically.
- **`react_server`**: Renders `react_web` element trees to HTML strings during server-side rendering.
