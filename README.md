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
Node SSR worker and callback bridge in `build/react/`. `react serve` starts both
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

The CLI emits `foreign_components.mjs` for both browser and SSR execution.
The module is expected to be a browser-loadable ESM asset (a Vite/esbuild
bundle may be used for `.tsx` sources). Dart code references it without
`dart:js_interop`:

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

## Boundary preserving
Source:
  Avatar({required src}) in avatar.dart
Generated pure:
  Avatar({required src, key, children}) => Component(_idAvatar, (src: src), key: key, children: children)

Usage in client.dart after generation:
  import 'lib/avatar.react.dart';
  Avatar(src: url, key: 'a', children: [Text('badge')])

JS wrapper calls impl inside React render, hooks isolated.
