# React Zustand

Typed Dart bindings for the [Zustand](https://zustand-demo.pmnd.rs) hook bridge.

## Ecosystem Role

This package is both a usable Zustand bridge and the manual-wrapper reference
for an npm-backed React Dart package. Most wrappers should declare a
`react.js.bind` group and let `react ts bind` generate their shim, bindings,
and hooks. Zustand is handwritten because it intentionally exposes a tiny
store facade instead of mirroring the npm package's full TypeScript API.

It demonstrates the four pieces a custom wrapper owns:

1. the `react.js` descriptor in `pubspec.yaml`;
2. npm dependency and React peer ranges;
3. a self-registering JavaScript shim;
4. a documented Dart API whose `@JS` paths match the shim.

## Installation
```yaml
dependencies:
  react_zustand: ^0.0.1
```

## Core Usage

The underlying store is created inside the bundled JS shim (`react_zustand_shim.mjs`). This package provides the `@JS` externals to read it from Dart.

```dart
import 'package:react/react.dart';
import 'package:react_dom/react_dom.dart';
import 'package:react_zustand/react_zustand.dart';

ReactNode counterView() {
  final count = useCount();
  final doubled = useDoubled();

  return div(
    children: [
      Text('Count: $count (Doubled: $doubled)'),
      button(
        onClick: (_) => inc(),
        children: const [Text('Increment')],
      )
    ],
  );
}
```

## How automatic discovery works

The package declares `lib/react_zustand_shim.mjs` as a shared browser/SSR
entry and Zustand as an npm dependency. `react build` discovers that descriptor
from the Dart package graph, provisions the managed JS environment, and
bundles the shim. Applications do not add it to `react.yaml`.

## Runtime support

The public entrypoint imports `dart:js_interop`, so these functions run in the
browser client and Node SSR worker. They do not run on the native Dart VM.
The shim uses Zustand's React selector hook, which provides subscription and
rerender behavior through Zustand's React integration.

## Use this pattern for another npm package

Copy the structure, not the package-specific global name:

- declare `react.js.schema: 1`;
- point `entries.shared`, `entries.browser`, or `entries.ssr` at package-local
  modules under `lib/`;
- declare npm `dependencies`, React `peers`, and `externals`;
- expose one package-specific bridge from the shim;
- make every Dart `@JS` path match that bridge;
- test the shim contract on the VM and the built integration with
  `react_testing`.

For generated TypeScript bindings, component registration, target-specific
entries, and the full checklist, see the workspace guide:
`.site/docs/guides/wrapper-packages.mdx`.
