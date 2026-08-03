# React Dart Workspace - MVP

Dart >=3.12.0 <4.0.0 + pub workspace, no melos.

## Structure
- packages/react - pure sealed ReactNode, ComponentId, Component with key+children
- packages/react_js - JsBinding, JsRenderer exhaustive switch
- packages/react_dom - mount Attach/Hydrate
- packages/react_codegen - generates .react.dart (pure factory returning Component with key+children) + .react.g.dart (JS wrapper extension type PropsJS + fromJS/toJS + $Component + register)
- example - Avatar, App, client.dart, ssr.dart

## First run
```
dart pub get
dart run packages/react_tool/bin/react.dart doctor
dart run packages/react_tool/bin/react.dart serve
```

## React CLI

The `react_tool` package provides the first standardized build commands. It
uses `react.yaml` when present, or conventional entrypoints and an optional
`react:` section in `pubspec.yaml` when it is absent:

```console
dart run packages/react_tool/bin/react.dart doctor
dart run packages/react_tool/bin/react.dart build
```

`react build` runs code generation, compiles the client and SSR Dart bundles,
copies static assets, compiles configured Sass stylesheets, and generates the
target bootstraps, SSR worker runtime, and callback bridge in `build/react/`:

```text
build/react/
├── browser.entry.mjs   # sets React globals, then loads trampoline/foreign/client.js
├── ssr.entry.mjs       # sets React globals, loads trampoline/foreign/ssr.js + runtime
├── ssr_runtime.mjs     # HTTP worker (server + error-boundary fallback)
├── foreign/browser/bundle.mjs
├── foreign/ssr/bundle.mjs
├── client.js, ssr.js   # dart compile js outputs
├── bundle_manifest.json
└── index.html          # import map + single browser.entry.mjs script tag
```

`bundle_manifest.json` records every runtime artifact per target (entry, Dart
output, foreign bundle, SSR runtime, byte sizes) plus the bundler and mode.
`react serve` and `react_testing` resolve the SSR entry from it at runtime, so
servers and tooling never hardcode module names. `react serve` starts both
the native Dart server and the SSR worker. Add `--watch` to `build` to rebuild
on source changes, or to `serve` to rebuild and restart both processes:

```console
dart run packages/react_tool/bin/react.dart serve --watch
dart run packages/react_tool/bin/react.dart build --watch
```

The CLI uses
`package:artisanal/args.dart` for its command runner.

### Styling

CSS files in the static directory are copied unchanged. Sass is compiled by
`react build` using the Dart `sass` package, so Node is not required for the
CSS pipeline:

```yaml
# react.yaml
styles:
  entrypoints:
    - web/styles.scss
  output: styles.css
```

A list is also supported:

```yaml
styles:
  - web/styles.scss
  - web/admin.scss
```

Compiled styles are emitted into `build/react/`. In development they use
expanded output; `react build --release` emits compressed CSS. `styles` may be
placed under the `react:` section in `pubspec.yaml` as well.

Files named `*.module.scss`, `*.module.sass`, or `*.module.css` use the
CSS-Modules subset automatically. Local class selectors receive stable scoped
names and a generated Dart binding is written next to the source:

```dart
import 'card.module.dart';

// Generated: CardModuleStyles.card
button(className: CardModuleStyles.card);
```

The generated binding is a build artifact; do not edit it manually.

Inline `style` maps are supported for dynamic values and CSS custom properties:

```dart
div(
  className: Styles.card,
  style: {
    'backgroundColor': selected ? '#7257ff' : '#e6eaf0',
    '--progress': '${progress * 100}%',
  },
  children: [...],
)
```

Use camelCase for normal CSS properties. Prefer classes or CSS Modules for
static styling, and reserve inline styles for state-dependent values.

### Foreign React/TSX components

Dart trees can reference components owned by a JavaScript or TypeScript build:

```yaml
# react.yaml
foreign:
  - name: DatePicker
    module: web/components/date_picker.js
    export: default
```

The CLI emits per-target foreign bundles — `foreign/browser/bundle.mjs` for
browser execution and `foreign/ssr/bundle.mjs` for SSR. The module is
expected to be a browser-loadable ESM asset (a Vite/esbuild bundle may be
used for `.tsx` sources). Dart code references it without `dart:js_interop`:

```dart
foreignComponent(
  'DatePicker',
  props: {'value': selectedDate},
  children: const [],
)
```

Named exports are supported with `export: DatePicker`. Add a `props` map to
also generate a typed Dart wrapper in `lib/foreign_components.g.dart`:

```yaml
foreign:
  - name: DatePicker
    module: web/components/date_picker.js
    props:
      value: String
      disabled: bool?
```

That produces a `datePicker(value: ..., disabled: ...)` helper. The bridge
preserves Dart portability: only `react_js` resolves the registered
JavaScript value.

The `react_testing` package reuses the same build and server orchestration in
browser and HTTP tests:

```dart
final harness = await ReactTestHarness.start(
  projectRoot: Directory('example'),
  rootComponent: 'package:app/lib/app.dart#App',
  registerActions: registerActions,
);
addTearDown(harness.close);
```

The CLI bundles each project's foreign modules and dependency shims into two
per-target aggregates — `foreign/browser/bundle.mjs` (loaded by the page via
import map) and `foreign/ssr/bundle.mjs` (imported by the SSR bootstrap) —
using esbuild with platform-appropriate conditions. `react`/`react-dom` stay
external so everything shares one React instance in each target. Bundling is
contained behind a `JavaScriptBundler` interface, so an alternative backend
(e.g. Rolldown) can be swapped in without touching `ReactBuilder`.

### Wrapping third-party React packages

To wrap an npm package (router, forms, charts…) without touching the core
packages, publish a wrapper Dart package that ships a self-registering shim:

1. The shim imports the npm package, registers components through the generic
   bridge, and exposes a hook bridge:

   ```js
   // lib/react_router_shim.mjs
   import * as RRD from 'react-router-dom';
   globalThis.__reactDartRegisterComponent?.('reactRouter.MemoryRouter', RRD.MemoryRouter);
   globalThis.__reactDartRouter = { locationParts: () => { const l = RRD.useLocation(); return [l.pathname, l.search, l.hash, l.key]; } };
   ```

2. The wrapper's pubspec declares the shim and its npm dependencies through
   the `react.js` descriptor (schema 1), so depending on the package is all a
   project needs:

   ```yaml
   # pubspec.yaml — wrapper package
   react:
     js:
       schema: 1
       entries:
         shared: lib/react_router_shim.mjs   # or browser:/ssr: per target
       dependencies:
         react-router-dom: ^6.26.2
       peers:
         react: ">=18 <20"
         react-dom: ">=18 <20"
       externals:
         - react
         - react-dom
   ```

   `react build` provisions an isolated npm environment at
   `.dart_tool/react/js` (never the host `package.json`), resolves one exact
   version per package that satisfies every wrapper's ranges, and bundles the
   entries into the two aggregates. The legacy `react.shims` / `react.npm`
   fields are still accepted.

3. Dart code uses `foreignComponent(...)` from `package:react` for components
   and its own `@JS` externals for hooks. See `packages/react_router` for a
   complete example.

`react js install` provisions the environment on its own; `react js sync`
validates an existing host JS project when `react.yaml` sets
`foreign.host: true`. Bundling failures are fatal — there is no unbundled
fallback — and conflicting version requirements across wrappers fail the
build with a diagnostic naming every declaring package.

## Boundary preserving
Source:
  Avatar({required src}) in avatar.dart
Generated pure:
  Avatar({required src, key, children}) => Component(_idAvatar, (src: src), key: key, children: children)

Usage in client.dart after generation:
  import 'lib/avatar.react.dart';
  Avatar(src: url, key: 'a', children: [Text('badge')])

JS wrapper calls impl inside React render, hooks isolated.
