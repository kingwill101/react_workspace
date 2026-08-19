# React Dart Workspace

A modern, full-stack React framework and ecosystem for Dart (>=3.12.0). 

React Dart brings the full power of React—including **Server-Side Rendering (SSR)**, **Hooks**, **Typed Server Functions**, and **Client-Side Hydration**—to Dart, maintaining strict type safety without sacrificing cross-platform portability.

---

## Ecosystem Architecture

The workspace is structured into decoupled, single-responsibility packages designed around a strict platform contract:

```
                      ┌──────────────────────────────┐
                      │        package:react         │
                      │  Pure Dart AST (ReactNode)   │
                      │  Hooks & Sealed HostNode<P>  │
                      └──────────────┬───────────────┘
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
┌──────────────────────┐                           ┌──────────────────────┐
│  package:react_web   │                           │  package:react_js    │
│  Portable Web & DOM  │                           │  JS Bridge & Codecs  │
│  Wraps package:web   │                           │  React JS Renderer   │
└──────────┬───────────┘                           └───────────┬──────────┘
           │                                                   │
           └─────────────────────────┬─────────────────────────┘
                                     ▼
                      ┌──────────────────────────────┐
                      │    package:react_codegen     │
                      │  build_runner Code Generator │
                      └──────────────┬───────────────┘
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
┌──────────────────────┐                           ┌──────────────────────┐
│ package:react_server │                           │  package:react_dom   │
│  Dart VM / SSR Server│                           │  Browser Attach/Hydr │
└──────────────────────┘                           └──────────────────────┘
```

### Core Architecture Principles

1. **Pure Dart Core (`package:react`)**
   - The UI tree is described entirely in pure Dart using the sealed `ReactNode` hierarchy (`Component`, `HostNode`, `Text`, `Fragment`, `ForeignComponent`).
   - No `dart:js_interop` or browser imports exist in `package:react`. Components can be compiled and executed on any Dart target (native Dart VM, server runtime, CLI, unit tests).

2. **Portable Web Abstraction (`package:react_web`)**
   - `react_web` wraps `package:web` so all web/DOM APIs supported by `package:web` (e.g. `EventTarget`, `HTMLInputElement`, `ReactChangeEvent`, `Window`, `Document`) are exposed as **portable Dart representations**.
   - On the client browser, these abstractions delegate directly to underlying JS interop types.
   - On the server (SSR / Dart VM), these abstractions fall back to safe, portable implementations or server stubs.
   - **Why this matters**: Application components import `react_web` rather than `package:web` or `dart:html` directly. This enables 100% code sharing between client-side hydration and server-side Dart VM rendering without breaking compiler rules or runtime constraints.

3. **Explicit Host Representations (`HostNode` & `HostTypeRef`)**
   - Host elements (HTML tags like `<div>`, `<input>`, `<button>`) are represented as `HostNode` in pure Dart.
   - `react_codegen` uses `HostTypeRef` to recognize web host types (`ReactChangeEvent`, `HTMLInputElement`) and automatically generate codec calls (`ReactCodecRegistry.encodeHostValue` / `decodeHostValue`).
   - Developers write clean, strongly-typed event handlers without needing manual `.toJS` or `dynamic` casting.

4. **Isomorphic Server Functions (`react_actions` & `react_server`)**
   - Annotate functions with `@serverFunction` to make server-side logic callable directly from the browser with complete contract validation, serialization, and type safety.

---

## Workspace Packages

| Package | Role & Description |
|---|---|
| [`react`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react/README.md) | Pure Dart React AST (`ReactNode`, `HostNode`, `Component`), hook primitives, `@ReactComponent` annotations. |
| [`react_web`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_web/README.md) | Portable `package:web` wrappers (`HTMLInputElement`, `ReactChangeEvent`), DOM element factories (`div`, `span`), browser runtime adapters. |
| [`react_js`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_js/README.md) | JavaScript interop binding layer, renderer dispatch, `ReactCallback` trampoline, and `ReactCodecRegistry`. |
| [`react_dom`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_dom/README.md) | Client-side DOM mounting, attachment, and hydration entrypoints (`mount`, `hydrate`). |
| [`react_codegen`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_codegen/README.md) | `build_runner` generator producing `.react.dart` factories, JS bridge implementations (`.react.g.dart`), and action codecs. |
| [`react_tool`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_tool/README.md) | Unified CLI (`react build`, `react serve`, `react doctor`) for code generation, bundling, Sass processing, and dev server orchestration. |
| [`react_actions`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_actions/README.md) | Client/server RPC protocol, `@serverFunction` / `@serverData` annotations, wire protocol format. |
| [`react_server`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_server/README.md) | Server-Side Rendering (SSR) engine, Shelf HTTP handler, SSR component registry, and error boundaries. |
| [`react_testing`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_testing/README.md) | In-memory and browser test harness (`ReactTestHarness`) for SSR, client, and action testing. |
| [`react_router`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_router/README.md) | Typed React Router bindings (`MemoryRouter`, `useLocation`, `useNavigate`) supporting both client and SSR URL resolution. |
| [`react_bloc`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_bloc/README.md) | State management bindings for `package:bloc` / `package:flutter_bloc` via `useSyncExternalStore`. |
| [`react_riverpod`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_riverpod/README.md) | State management bindings for Riverpod providers in React Dart components. |
| [`react_zustand`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_zustand/README.md) | Typed bindings for Zustand micro-state stores. |
| [`react_web_generator`](file:///home/kingwill101/code/dart_packages/react_workspace/packages/react_web_generator/README.md) | Internal Web IDL generator that synthesizes `react_web` DOM interfaces from upstream W3C specs. |

---

## Quick Start

### 1. Requirements & Workspace Setup

- Dart SDK `>=3.12.0 <4.0.0`
- Node.js (for esbuild bundling of third-party JS/TSX components)

Install dependencies across the workspace:

```bash
dart pub get
```

### 2. Scaffold a New Project

Use the `react_tool` CLI to scaffold an SSR, Routed-hosted SSR, or client-only project:

```bash
# SSR Project (Default)
dart run react_tool:react init my_app

# Routed Host Project (Shelf-free, SSR via `routed_io`)
dart run react_tool:react init my_app --template routed

# Client-Only Static Project
dart run react_tool:react init my_app --template client
```

### 3. Build & Run

```bash
cd my_app
dart pub get

# Check project health
dart run react_tool:react doctor

# Build assets, run codegen, compile JS & SSR bundles
dart run react_tool:react build

# Start dev server with watch mode
dart run react_tool:react serve --watch
```

---

## React CLI (`react_tool`)

The `react_tool` CLI orchestrates the complete build and development lifecycle. It reads configuration from `react.yaml` or the `react:` key in `pubspec.yaml`.

```console
dart run react_tool:react doctor    # Diagnostics & environment verification
dart run react_tool:react build     # Codegen + Sass compile + JS/SSR bundling
dart run react_tool:react serve     # Serves native server & SSR worker
```

### Build Artifacts (`build/react/`)

```text
build/react/
├── browser.entry.mjs   # Sets React globals, loads client bundle
├── ssr.entry.mjs       # Sets React globals, loads SSR worker bundle
├── ssr_runtime.mjs     # HTTP SSR worker
├── foreign/browser/    # ESM bundled foreign JS/TSX components
├── foreign/ssr/        # SSR bundled foreign components
├── client.js, ssr.js   # dart compile js output binaries
└── index.html          # HTML template with import map
```

---

## How Portability & Host Objects Enable SSR

In traditional web-focused Dart frameworks, UI code imports `package:web` or `dart:html` directly. However, `package:web` relies on `dart:js_interop` extension types that cannot execute on native Dart VM runtimes (such as server-side renderers, CLI tools, or VM unit tests).

React Dart resolves this architectural challenge through a 3-layer portable model:

```
┌─────────────────────────────────────────────────────────────┐
│ Application Code (lib/components/my_widget.dart)            │
│ Imports package:react_web (HTMLInputElement, ReactChangeEvent)│
└──────────────────────────────┬──────────────────────────────┘
                               │
               ┌───────────────┴───────────────┐
               ▼                               ▼
  Client Browser Runtime (JS)       Server SSR Runtime (VM)
  ┌───────────────────────────┐   ┌───────────────────────────┐
  │ Wraps package:web extension│   │ Portable Mock/Stub Class  │
  │ types via JS Interop      │   │ Selective Server Support  │
  └───────────────────────────┘   └───────────────────────────┘
```

1. **`HostNode<P>` in `package:react`**: Defines element nodes (`div`, `span`, `input`) as pure Dart data objects.
2. **`react_web` API Wrappers**: Exposes standard DOM interfaces (`HTMLInputElement`, `EventTarget`, `ReactChangeEvent`) as platform-neutral abstractions. Application code stays strongly typed without touching platform JS interop directly.
3. **Automatic Codegen Wiring (`HostTypeRef`)**: `react_codegen` inspects component props and automatically generates codec calls (`ReactCodecRegistry.encodeHostValue` / `decodeHostValue`). Component event handlers accept strongly typed parameters like `ReactChangeEvent<HTMLInputElement>` without requiring manual `.toJS` conversions or `dynamic` casting.

---

## Foreign React / TSX Components

React Dart applications can seamlessly render components written in JavaScript or TypeScript (React, MUI, Radix, Tailwind UI):

1. **Configure in `react.yaml`**:
   ```yaml
   foreign:
     - name: DatePicker
       module: web/components/date_picker.tsx
       export: default
       props:
         value: String
         disabled: bool?
   ```

2. **Use in Dart**:
   ```dart
   import 'lib/foreign_components.g.dart';

   datePicker(
     value: selectedDate,
     disabled: false,
   )
   ```

`react build` uses `esbuild` to compile TSX/JS sources into two aggregate bundles (`foreign/browser/bundle.mjs` and `foreign/ssr/bundle.mjs`), ensuring single-instance React sharing across both targets.

---

## Documentation & Learning

- **Interactive Site Documentation**: See [.site/docs/](file:///.site/docs/intro.mdx) for comprehensive guides on SSR, Server Functions, State Management, Styling, and Testing.
- **Example Projects**:
  - `examples/superdesk`: Full-featured admin dashboard demo featuring offline storage, resources editor, live canvas/arcade, and theme settings.
  - `examples/ssr`: Reference server-side rendering application.

---

## License

MIT License. See individual package directories for license details.
