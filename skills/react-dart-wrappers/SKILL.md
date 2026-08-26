---
name: react-dart-wrappers
description: Integrate npm React and TypeScript packages into Dart with generated bindings, generated shims, react.js descriptors, and typed hooks. Use when wrapping shadcn, Zustand, React Router, or any foreign React package.
---

# React Dart wrappers

Use generated bindings by default. Use a handwritten shim only when the public
Dart API is intentionally a custom facade, the npm package has no usable
TypeScript declarations, or a small bridge is clearer than a complete mirror.

## Generated workflow

1. Install the package's declared npm dependencies:

   ```console
   dart run react_tool:react js install
   ```

2. Generate typed Dart declarations, hook bindings, and the JavaScript shim:

   ```console
   dart run react_tool:react ts bind some-react-package \
     --output lib/src/some_bindings.g.dart \
     --shim lib/src/some_bindings_shim.mjs \
     --hooks lib/src/some_hooks.g.dart \
     --namespace somePackage \
     --prefix somePackage
   ```

3. For a reusable package, put the same options in a `react.js.bind` group and
   rerun `dart run react_tool:react ts bind` without positional arguments.
4. Export stable authored helpers while keeping generated files internal.
5. Test the Dart API and build both browser and SSR targets.

The generator creates the registration shim. Do not hand-write one for a
normal declaration-backed package.

## Declare the npm contract

Keep wrapper packages reproducible and React-singleton-safe:

```yaml
react:
  js:
    schema: 1
    entries:
      shared: lib/src/some_bindings_shim.mjs
    dependencies:
      some-react-package: ^1.0.0
    peers:
      react: ">=18 <20"
      react-dom: ">=18 <20"
    externals: [react, react-dom]
```

React and React DOM remain peers/externals. Do not bundle a second React
instance. Keep npm dependencies in the descriptor rather than asking each
consumer to edit its own `package.json`.

## Handle unpublished Dart packages

The React Dart wrapper packages are currently consumed from GitHub refs rather
than pub.dev releases:

```yaml
dependencies:
  react_router:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react_router
```

Use the same React workspace ref for all related Dart packages. Pin a commit
instead of `master` when reproducibility matters.

## Manual facade exception

`react_zustand` is the reference manual facade. It exposes a deliberately
small Dart API over a package-private global bridge rather than mirroring all
of Zustand:

```js
globalThis.__reactDartZustand = {
  useCount: () => useCounterStore((state) => state.count),
  useDoubled: () => useCounterStore((state) => state.count * 2),
  inc: () => useCounterStore.getState().inc(),
};
```

Give every manual bridge a unique namespace, document its browser/Node SSR
target limitation, and keep values crossing the JS boundary to primitives or
documented object shapes. Add a shim contract test.

## Validate a wrapper

```console
dart analyze
dart test
dart run react_tool:react js install
dart run react_tool:react build
```

Confirm the wrapper is retained in both browser and SSR bundle reports when it
is used. Unused project-local foreign declarations are intentionally pruned.

## Native-backed wrapper packages

If a wrapper package also ships a Rust or C code asset, keep native delivery
separate from its JavaScript descriptor. Use `native_prebuilt` in
`hook/build.dart` with a generated manifest, and provide a source fallback for
workspace and offline development. The normal loop is:

```console
dart test
dart run native_prebuilt manifest update \
  --config native_prebuilt.yaml \
  --output lib/src/hook/<package>_prebuilts.g.dart \
  --built-library-dir <staged-build-directory> \
  --release-assets-dir <release-assets-directory>
dart run native_prebuilt manifest verify \
  --config native_prebuilt.yaml \
  --output lib/src/hook/<package>_prebuilts.g.dart
```

The generated manifest is checked in, while native binaries and release
archives are not. Keep GitHub release tags and artifact hashes versioned and
reproducible; do not silently replace a published artifact behind an existing
tag.
