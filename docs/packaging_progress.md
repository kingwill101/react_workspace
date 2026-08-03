Your current solution is a **good proof of concept**, but I would not make automatic `package.json` mutation and per-shim bundling the permanent architecture.

> **Status: implemented.** The recommended architecture below has been built (commits `0ea44a0`, `709e8d1`). Wrappers declare `react.js` schema 1 descriptors; `react build` provisions an isolated npm environment at `.dart_tool/react/js`, bundles one aggregate per target (browser/SSR) with the environment's pinned esbuild, pins one React version across browser + SSR, and fails fatally when a bundle cannot be produced. One follow-up remains: TypeScript type resolution. See the completion record at the bottom.

The core correction is:

> Do not discover a package’s `.mjs` file yourself. Import the package by its public module specifier and let a real JS resolver interpret `exports`, conditional exports, `main`, `module`, and `browser`.

There may be no canonical `.mjs` file. A package can expose `.js`, `.mjs`, `.cjs`, different browser and Node files, or public subpaths. Modern packages declare that through `package.json#exports`, which takes precedence over `main` and may select different targets for `browser`, `node`, `import`, and `require`. ([Node.js][1])

## Verdict on the current implementation

Keep these ideas:

* A Dart wrapper package owns its shim.
* The consumer should normally only add the Dart dependency.
* React and ReactDOM must remain singletons.
* JS package requirements should be declarative.
* One tool should build browser and SSR integrations.
* The wrapper—not the application—should know which bridge code is needed.

Change these parts:

* Do not mutate the nearest user `package.json` during every build.
* Do not silently choose the first version range.
* Do not consider “`node_modules/pkg/package.json` exists” sufficient.
* Do not use one browser-resolved bundle for browser and SSR.
* Do not fall back to copying an unbundled shim.
* Do not search for an npm package’s physical `.mjs` entry.
* Do not bundle each wrapper independently.

# Critical problems in the current code

## 1. The SSR worker receives a browser-resolved bundle

Your `_bundleForeignModule()` does not specify `--platform`, so esbuild uses its browser defaults. That activates browser conditions and the `browser,module,main` resolution order. The resulting file is then imported into the Node SSR worker through the same `foreign_components.mjs`.

That happens to work for React Router, but it is unsafe generally:

```json
{
  "exports": {
    ".": {
      "browser": "./dist/browser.js",
      "node": "./dist/node.js",
      "default": "./dist/shared.js"
    }
  }
}
```

Your current build always selects the browser branch. Esbuild intentionally changes export conditions and main-field resolution depending on `platform=browser` versus `platform=node`. ([esbuild][2])

You need two builds:

```text
foreign_browser.mjs
    platform=browser

foreign_ssr.mjs
    platform=node
```

## 2. The fallback copy is not reliable

When esbuild is unavailable or bundling fails, the code copies the shim verbatim.

But the router shim contains:

```js
import { MemoryRouter, useLocation } from 'react-router-dom';
```

The browser import map currently only maps `react` and `react-dom`, not `react-router-dom`.

So the fallback does not degrade gracefully. It produces an artifact likely to fail at runtime.

For declared npm integrations, bundler failure should be fatal:

```text
Could not build react_router browser adapter:
esbuild is unavailable.

Run:
  react js install
```

## 3. Dependency conflicts are silently hidden

The current merge logic effectively does:

```dart
result[packageName] ??= versionRange;
```

for dependency wrappers.

Suppose:

```text
wrapper_a → zustand ^4.5.0
wrapper_b → zustand ^5.0.0
```

Whichever package appears first wins. The build should instead report:

```text
Conflicting JavaScript requirements for "zustand":

  wrapper_a requires ^4.5.0
  wrapper_b requires ^5.0.0

No version satisfies all requirements.
```

The package manager must resolve compatible ranges; your tool should collect provenance and validate the result.

## 4. Installed-package detection is too weak

Currently, a package is considered available when this exists:

```text
node_modules/<name>/package.json
```

That does not verify:

* The installed version satisfies the requested range.
* The installation is complete.
* The requested export exists.
* Peer dependencies are satisfied.
* The package is compatible with browser and SSR.
* Yarn Plug’n’Play is in use.
* pnpm has provided a nontraditional layout.

Esbuild itself supports Yarn Plug’n’Play when run in the appropriate project context, but your pre-check assumes `node_modules`. ([esbuild][3])

The best availability check is: **can the bundler resolve and build the requested entry under the selected target conditions?**

## 5. The build mutates user-owned manifests

The build finds the nearest ancestor containing `package.json` or `node_modules`, writes missing dependencies into that manifest, and invokes `npm install`.

This can unexpectedly modify:

* A Dart workspace root.
* A larger JavaScript monorepo.
* A package using pnpm or Yarn.
* A carefully maintained lockfile.
* An application where dependencies are intentionally dev dependencies.
* A CI checkout expected to remain clean.

A normal build should not silently rewrite source-controlled dependency manifests.

## 6. React versions are already split

The root npm manifest requests:

```json
"react": "^18.3.1",
"react-dom": "^18.3.1"
```

The browser import map pins:

```json
"react": "https://esm.sh/react@18.2.0",
"react-dom": "https://esm.sh/react-dom@18.2.0"
```

So browser and SSR are not currently guaranteed to use the same React release. Your runtime builder should own one exact resolved React/ReactDOM version and generate both the browser mapping and SSR installation from it.

# Recommended architecture

Use a **wrapper descriptor**, a **managed JS environment**, and **two aggregate target builds**.

```text
Dart wrapper packages
       ↓
wrapper JS descriptors
       ↓
dependency graph resolver
       ↓
managed JS environment
       ↓
 ┌───────────────┴──────────────┐
 browser aggregate          SSR aggregate
 platform=browser           platform=node
       ↓                         ↓
foreign_browser.mjs       foreign_ssr.mjs
```

# 1. Wrapper descriptor

Keep this in the wrapper’s `pubspec.yaml`, but make it explicit and target-aware:

```yaml
react:
  js:
    schema: 1

    entries:
      shared: lib/src/js/react_router.ts

    dependencies:
      react-router-dom: ^6.26.2

    peers:
      react: ">=18 <20"
      react-dom: ">=18 <20"

    externals:
      - react
      - react-dom
```

A target-specific package can declare:

```yaml
react:
  js:
    schema: 1

    entries:
      browser: lib/src/js/browser.ts
      ssr: lib/src/js/ssr.ts

    dependencies:
      some-package: ^3.0.0
```

A browser-only wrapper:

```yaml
react:
  js:
    entries:
      browser: lib/src/js/browser.ts
      ssr: false
```

The important distinction is:

```text
entries
    wrapper-owned files

dependencies
    npm package specifiers and version ranges
```

The wrapper entry imports the public npm specifier:

```ts
import {
  BrowserRouter,
  MemoryRouter,
  Routes,
  Route,
} from 'react-router-dom';
```

The build tool does not inspect `react-router-dom` looking for a likely `.mjs` file.

# 2. Let esbuild resolve npm entries

Node and modern bundlers use package exports as the public entry-point contract. If `exports` exists, unexported internal subpaths are intentionally unavailable. ([Node.js][1])

Therefore:

```js
import { create } from 'zustand';
import { motion } from 'framer-motion';
import { useForm } from 'react-hook-form';
```

is the correct resolver input.

For public subpaths:

```js
import { StaticRouter } from 'react-router-dom/server';
```

or whatever public subpath the package documents.

Never generate imports such as:

```js
import x from '../node_modules/pkg/dist/index.mjs';
```

That bypasses export encapsulation and can break on the next package update.

# 3. Generate a managed JS environment

Instead of writing into the consumer’s `package.json`, create:

```text
.dart_tool/react/js/
├── package.json
├── package-lock.json
├── node_modules/
├── entries/
│   ├── browser.mjs
│   └── ssr.mjs
└── build/
```

Generated `package.json`:

```json
{
  "name": "@react-dart/generated-js-environment",
  "private": true,
  "type": "module",
  "dependencies": {
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "react-router-dom": "6.26.2"
  },
  "devDependencies": {
    "esbuild": "0.28.1"
  }
}
```

The exact versions should come from a lock-resolution step, not arbitrary first-found ranges.

Benefits:

* No mutation of application manifests.
* No accidental workspace-root changes.
* Reproducible cache.
* Exact tool-owned esbuild version.
* Clean deletion with `.dart_tool`.
* Fresh installs do not dirty Git.
* Wrapper dependencies are isolated from unrelated JavaScript tooling.

Cache key:

```text
hash(
  wrapper descriptor versions
  npm requirements
  React runtime version
  platform
  build mode
  esbuild version
)
```

# 4. Provide managed and host modes

Some applications already have a real JS workspace. Support both.

## Managed mode — default

```yaml
react:
  js:
    environment: managed
```

The framework owns `.dart_tool/react/js`.

This gives Dart-first consumers the “add one Dart dependency” experience.

## Host mode — opt-in

```yaml
react:
  js:
    environment: host
    root: .
```

The framework:

* Reads the existing `package.json`.
* Detects the selected package manager.
* Validates required ranges.
* Uses the existing lockfile and installation.
* Never modifies the manifest automatically.

When missing:

```text
react_router requires react-router-dom ^6.26.2.

Install it with:
  pnpm add react-router-dom@^6.26.2
```

An explicit command may modify it:

```bash
react js sync
```

But `react build` should ordinarily remain read-only regarding project manifests.

# 5. Bundle all wrappers together

Do not run esbuild once per wrapper.

Current layout:

```text
router shim → router bundle
zustand shim → zustand bundle
motion shim → motion bundle
```

This can duplicate shared npm dependencies across outputs.

Generate one aggregate browser entry:

```js
import '/absolute/path/react_router/browser.ts';
import '/absolute/path/zustand/browser.ts';
import '/absolute/path/motion/browser.ts';
```

And one SSR entry:

```js
import '/absolute/path/react_router/ssr.ts';
import '/absolute/path/zustand/ssr.ts';
```

Then run esbuild twice.

## Browser build

Conceptually:

```js
await esbuild.build({
  entryPoints: ['entries/browser.mjs'],
  bundle: true,
  platform: 'browser',
  format: 'esm',
  splitting: true,
  outdir: 'build/browser',
  external: ['react', 'react-dom'],
  conditions: [
    release ? 'production' : 'development',
  ],
  metafile: true,
  sourcemap: release ? false : 'linked',
  minify: release,
});
```

## SSR build

```js
await esbuild.build({
  entryPoints: ['entries/ssr.mjs'],
  bundle: true,
  platform: 'node',
  format: 'esm',
  target: ['node20'],
  splitting: true,
  outdir: 'build/ssr',
  external: ['react', 'react-dom'],
  conditions: [
    release ? 'production' : 'development',
  ],
  metafile: true,
});
```

Esbuild uses the platform to activate the correct browser or Node conditional exports. ([esbuild][2])

Also, an external package pattern such as `react` implicitly covers package subpaths such as `react/jsx-runtime`, so the external policy can preserve React’s singleton across those imports too. ([esbuild][2])

# 6. Make esbuild mandatory and tool-owned

The current lookup is:

```text
react.yaml path
ESBUILD environment variable
which esbuild
fallback copy
```

Instead, install an exact esbuild version in the managed environment and invoke its JS API. Esbuild itself recommends a local npm installation, and its JS API is the appropriate interface for more sophisticated builds and plugins. ([esbuild][3])

The JS API gives you:

* `platform`
* `conditions`
* `nodePaths`
* `metafile`
* asset loaders
* plugins
* multiple entry points
* incremental contexts
* proper watch mode
* structured diagnostics

Do not silently continue if the bundler cannot run.

# 7. Separate runtime resolution from TypeScript type resolution

Runtime JavaScript and TypeScript declarations are not necessarily the same file.

For:

```ts
import { SomeComponent } from 'some-package';
```

you need two independent operations:

```text
runtime resolver
    package exports → JS implementation

type resolver
    types condition / types field → .d.ts declarations
```

TypeScript’s modern `bundler`, `node16`, and `nodenext` resolution modes understand package `exports`, `imports`, and `types` conditions. TypeScript explicitly resolves to declaration files for type information while preserving a module specifier that the runtime or bundler can resolve to JavaScript. ([TypeScript][4])

So a future automatic Dart binding generator should use the TypeScript compiler resolver:

```text
specifier: react-router-dom
        ↓
TypeScript module resolution
        ↓
index.d.ts / export declaration graph
        ↓
curated Dart binding IR
```

It should not infer typings from the `.mjs` path selected by esbuild.

Also, do not automatically expose an entire TypeScript package. React libraries often require semantic adaptation:

* React components
* hooks
* render props
* context providers
* callback lifetimes
* refs
* unions
* overloaded props

Continue using curated wrapper entry files even if type declarations help generate the repetitive Dart model.

# 8. Support source and prebuilt wrapper distribution

There are two useful distribution models.

## Source wrapper

The Dart package ships:

```text
lib/
├── react_router.dart
└── src/js/react_router.ts
```

The application build installs npm dependencies and bundles all wrapper sources together.

Advantages:

* Cross-wrapper deduplication.
* Tree shaking.
* Correct target conditions.
* Development source maps.
* Easy target-specific adapters.

Recommended for workspace development and advanced applications.

## Prebuilt wrapper

The Dart package ships:

```text
lib/
├── react_router.dart
└── src/js/
    ├── react_router.browser.mjs
    └── react_router.ssr.mjs
```

Its npm dependency is already bundled, with React external.

Descriptor:

```yaml
react:
  js:
    prebuilt:
      browser: lib/src/js/react_router.browser.mjs
      ssr: lib/src/js/react_router.ssr.mjs

    peers:
      react: ">=18 <20"
      react-dom: ">=18 <20"
```

Advantages:

* Consumer does not require npm package installation.
* Faster builds.
* Excellent pub.dev installation experience.
* Wrapper author controls tested dependency versions.

Trade-offs:

* Less cross-wrapper deduplication.
* Larger package.
* Must publish per-target artifacts and assets.
* Dynamic imports, CSS, workers and WASM need an output manifest.

Support both; make prebuilt artifacts the easiest path for official published wrappers.

# 9. Resolve and validate versions properly

Collect requirements with provenance:

```text
react-router-dom
  react_router ^6.26.2

zustand
  react_zustand >=4.5.0 <6.0.0
  app_override 5.0.3
```

Then:

1. Validate that ranges intersect.
2. Let the package manager resolve an exact version.
3. Read the installed exact version.
4. Store it in the generated lock/manifest.
5. Fail if peers are incompatible.
6. Include the resolution in build diagnostics.

Npm distinguishes regular dependencies from peer dependencies precisely for libraries that must work with a host-provided singleton or plugin interface. Peer ranges should generally be broad enough to cover compatible host versions. ([npm Docs][5])

React and ReactDOM belong in the framework runtime/peer category—not duplicated inside every wrapper.

# Proposed final schema

Implemented fields (schema 1): `schema`, `entries` (shared/browser/ssr, `false` to disable a target), `dependencies`, `peers`, `externals` (defaults to react/react-dom), `prebuilt` (accepted; no wrapper ships one yet). `capabilities` and `assets` are not yet parsed — reserved for the prebuilt/asset work.

```yaml
name: react_router

react:
  js:
    schema: 1

    entries:
      browser: lib/src/js/browser.ts
      ssr: lib/src/js/ssr.ts

    dependencies:
      react-router-dom: ^6.26.2

    peers:
      react: ">=18 <20"
      react-dom: ">=18 <20"

    externals:
      - react
      - react-dom

    capabilities:
      browser: true
      ssr: true

    assets:
      include:
        - lib/src/js/**/*.css
```

For a universal entry:

```yaml
react:
  js:
    entries:
      shared: lib/src/js/register.ts
```

# Build output (implemented)

```text
build/react/
├── client.js                      # dart2js browser app
├── ssr.js                         # dart2js SSR entry (node worker)
├── browser.entry.mjs              # target bootstrap: sets React globals, then loads trampoline/foreign/client
├── ssr.entry.mjs                  # target bootstrap: sets React globals, loads trampoline/foreign/ssr.js + runtime
├── ssr_runtime.mjs                # HTTP worker (server + error-boundary fallback)
├── callback_trampoline.mjs        # js bridge protocol asset
├── foreign/
│   ├── browser/
│   │   ├── entry.mjs              # generated aggregate input (wrapper entries)
│   │   ├── bundle.mjs             # esbuild output (sourcemap: bundle.mjs.map)
│   │   └── styles.css             # when a wrapper ships CSS
│   └── ssr/
│       ├── entry.mjs
│       └── bundle.mjs
├── foreign_components.g.dart      # typed Dart bindings for foreign components
├── bundle_manifest.json           # deterministic artifact manifest (entries, bytes, bundler, mode)
├── bundle_report.json             # size + retained-surface metrics, with per-target usedComponents/usedHooks
├── index.html                     # import map + single <script src="browser.entry.mjs">
└── manifest.json
```

Naming note: esbuild renames `.mjs` entries to `.js` under `outdir`, so the tool passes an explicit `outfile: …/bundle.mjs`. All references (the entry bootstrap, the worker's import) point at `bundle.mjs`; the `entry.mjs` files are bundle inputs that may remain as dead weight.

The `browser.entry.mjs` bootstrap absorbs the inline `globalThis.React` bootstrap that used to live in `index.html`: it sets the React/ReactDOM globals, then dynamically imports the trampoline, the foreign bundle, and `client.js`. Dynamic imports are required because ES module semantics hoist static imports ahead of the body — the foreign graph and Dart app must not run before the globals are set (a static-import variant produced a broken hydration pass). The importmap stays in `index.html` because the browser resolves the bare `react`/`react-dom` specifiers, not the bundler.

`ssr.entry.mjs` does the same for the node target and hands off to `ssr_runtime.mjs` for the HTTP server and error-boundary fallback.

Browser:

```html
<script type="importmap">{…react/react-dom pinned…}</script>
<script type="module" src="browser.entry.mjs"></script>
```

SSR bootstrap (`ssr.entry.mjs`):

```js
globalThis.require ??= createRequire('<envNpmRoot>/x.js');  // UMD dynamic require
globalThis.self ??= globalThis;                             // dart2js crypto access
await import('./callback_trampoline.mjs');
await import('./foreign/ssr/bundle.mjs');
await import('./ssr.js');
await import('./ssr_runtime.mjs');
```

`react serve` and the `react_testing` harness resolve the SSR entry (and, by extension, all target artifacts) from `bundle_manifest.json` via `BundleManifest.load`, falling back to the legacy `ssr.entry.mjs` name when no manifest was emitted.

# Implementation details that diverged from the design

These decisions were forced by the ecosystem while implementing:

* **Rust/oxc instead of the managed-JS `typescript` package for item 11** — the design phase planned a Node-side extraction driver (tool-owned `typescript` devDependency + `createProgram` + `checker.getExportsOfModule`). The user directed a native approach instead: `oxc_parser` 0.142 + `oxc_resolver` 11.24 (`resolve_dts`, which matches `ts.resolveModuleName` with bundler resolution and always adds the `types` condition) compiled as a code asset via `native_toolchain_rust` (the pattern from `keyring_native`). Trade-offs: a cargo/rustup requirement on machines that build `react_tool` (native assets build once per config, cached in `.dart_tool`), but no Node toolchain in the build path and a much smaller extracted surface (the driver only walks exports + type imports, so heavy runtime graphs like `@remix-run/router` are bounded by a 400-file cap and a depth limit). The FFI externals are hand-written (`src/ts_bindings.g.dart`), mirroring the `@ffi.Native` + assetName convention; the externals' file path must match the `RustBuilder` assetName for the VM to link them.

* **`npm view <name> versions --json` + local range filtering** — modern npm rejects range specifiers containing spaces/`>` in `npm view pkg@range` (`EINVALIDTAGNAME`). The tool fetches the full version list once and filters locally against every wrapper's range.
* **Driver protocol** — esbuild is invoked programmatically by a tool-owned `esbuild_driver.mjs` in the environment; build options arrive as JSON argv. The npm root travels via `REACT_NPM_ROOT` because esbuild rejects unknown option keys.
* **SSR externals via node-externals plugin** — the SSR bundle keeps `react`/`react-dom` external, so the driver's `onResolve` rewrites those bare specifiers to absolute paths inside the managed environment (`require.resolve` against the npm root), guaranteeing the worker and the foreign bundle share one React instance.
* **Import-map pinning** — the browser import map (`https://esm.sh/react@X.Y.Z`) is rewritten to the environment's exact resolved `reactVersion` on every build (idempotent), so browser and SSR always agree on one React release.
* **Node compat shims in `ssr.entry.mjs`** — the bootstrap runs dart2js output in Node and needs two aliases injected by the generator:
  * `globalThis.require ??= createRequire('<envNpmRoot>/x.js')` — react-router-dom's UMD build calls dynamic `require('react')` at init; this binds it to the same managed React instance.
  * `globalThis.self ??= globalThis` — dart2js compiles `Random.secure()` to `self.crypto.getRandomValues(...)`; uuid (a riverpod 3 dependency) calls it at module init. Node ≥18 exposes `globalThis.crypto` (webcrypto).
* **`.installed` marker + manifest-content comparison** — a rebuild skips `npm install` when the generated manifest content is unchanged since the last successful install; the marker file is the install record.
* **`entries: false` for a target** — `ssr: false` / `browser: false` suppress that target for the wrapper (no entry emitted for it).

# Migration from the current implementation

Status (implemented):

1. ✅ `react.shims` / `react.npm` replaced by the versioned `react.js` descriptor (schema 1); the old fields are still accepted for compatibility (`JsWrapperDescriptor.parse`).
2. ✅ Separate browser and SSR aggregate entry files (`foreign/browser/entry.mjs`, `foreign/ssr/entry.mjs`).
3. ✅ One esbuild run per target (`esbuild_driver.mjs` + JSON options, pinned esbuild from the managed environment).
4. ✅ The copy fallback is removed — bundling failures are fatal.
5. ✅ Dependency provenance and version-conflict diagnostics (`NpmRequirement` + `JsDependencyConflict`, listing every declaring wrapper).
6. ✅ Automatic installations moved into `.dart_tool/react/js` (never the host `package.json`); reinstall detection via manifest-content comparison + `.installed` marker.
7. ✅ esbuild pinned as a devDependency of the managed environment (host fallback only in host mode).
8. ✅ One resolved React version: the import map is rewritten to the exact version the environment resolved, and the SSR bootstrap imports react/react-dom through absolute paths in that same environment.
9. ✅ `managed` (default) and `host` JS-environment modes (`react.yaml foreign.host: true`); `react js install` / `react js sync` subcommands.
10. ✅ Prebuilt wrapper support — wrappers ship already-bundled per-target artifacts (`prebuilt.browser` / `prebuilt.ssr`); the build imports them into the aggregate and esbuild keeps react/react-dom external. A prebuilt-only wrapper contributes no npm `dependencies` (they are inlined by the wrapper author), so no installation is forced beyond the framework singletons. Verified end-to-end: the real pinned esbuild bundles a prebuilt file and the node-externals plugin rewrites its bare `react` import to the managed env path, loading against the same 18.3.1 instance.
11. ✅ TypeScript module resolution for `.d.ts` discovery and binding generation — a native **oxc**-based extractor ships inside `react_tool` as a code asset (`native/`, built via `native_toolchain_rust` + `hook/build.dart`; crate `react-ts-bindings`, C ABI: `tsb_extract(requestJson, npmRoot)`). It resolves a package's types entry (`types`/`typings`/`exports["."]`), loads the `.d.ts` graph with `oxc_resolver::resolve_dts` (types-condition + relative/bare imports), and serializes requested exported declarations to a JSON IR (props, optionality, string/number/boolean/any/array/object/union/function/reactNode/literal kinds; `Partial<T>`, interface `extends`, unions-of-interfaces, and cross-file references resolved against the declaration store; depth/cycle guarded; named interface references carry their TS name). `react ts bind <specifier> <names...>` (CLI) pipes that IR through `generateBindings` (Dart) into **strongly-typed** helpers: components become `foreignComponent('prefix.Name', ...)` functions with a Dart class per object prop (nested members, `toJson()` for the JS bridge), literal unions become enums, callbacks become typedefs + `ReactCallback` factories, and prim aliases become typedefs. Verified end-to-end against `react-router-dom`: `MemoryRouter`/`Route`/`NavigateProps` extracted (10 type files); `example/lib/reactRouterDom_bindings.g.dart` emits `FutureConfig`, `NavigateProps`, `NavigatePropsRelative`, analyzes clean, and a runtime smoke test exercises the helpers. The managed-JS `typescript`-package plan from the research phase was **rejected in favor of this Rust design** (user-directed): oxc gives a single dependency-free binary, no Node toolchain needed for the build tool, and it stays strictly inside `react_tool` — never in exposed packages, no FFI in browser contexts.

    Subsequent hardening (all in `react_tool` + the `react_router` package, committed together):

    * **Subpath specifiers** — `react ts bind react-router-dom/server StaticRouter` resolves through the package `exports` map via `oxc_resolver` instead of reading the top-level types entry; the CLI validates the top-level package directory for `a/b` specifiers.
    * **`ForwardRefExoticComponent` / qualified type names** — `type_name_base` now returns the *rightmost* segment (`React.ForwardRefExoticComponent` → `ForwardRefExoticComponent`), so `export declare const Link: React.ForwardRefExoticComponent<LinkProps & …>` extracts as a component; the `__ref` intersection marker is flattened in `props_for_expr`.
    * **Curated DOM attribute table** — `extends: Omit<AnchorHTMLAttributes<…>, "href">` clauses resolve against a curated member table (children, className, style, href, onClick, …) since `@types/react` is not installed in the managed environment; `Omit`/`Pick` key filtering is honored. This restores inherited props like `children` on `Link`.
    * **`--shim`** — `generateShim()` emits a self-registering `.mjs` module that imports only the referenced declarations as individual named imports (aliased `__reactDart<Name>`, so bundlers can tree-shake the rest of the package instead of pulling the whole namespace in) and calls `globalThis.__reactDartRegisterComponent?.(…)`; the CLI writes it alongside the bindings.
    * **`--type-prefix`** — namespaces generated type names so a second extraction (e.g. the `react-router-dom/server` subpath, whose `FutureConfig` differs from react-router's) cannot collide with the first file.
    * **Children param** — a `children` prop of any non-function kind becomes the typed `List<ReactNode> children = const []` parameter instead of a props-map entry; enum values are decoded (`"path"` → `path`) so `.value` matches what the JS side expects.

    **`react_router` is now generated**: `lib/react_router_bindings.g.dart` (BrowserRouter, MemoryRouter, Routes, Route, Link, NavLink, Outlet, Navigate) + `lib/react_router_server_bindings.g.dart` (StaticRouter, `--type-prefix Server`), with shims registered through the handwritten `react_router_shim.mjs` (which imports both generated shims and still owns the `__reactDartRouter` hook bridge for `react_router_hooks.dart`). `react_router.dart` re-exports the generated helpers; example callsites (`router_demo.dart`, `route_content.dart`, `route_item.dart`) and the package tests were migrated to the generated names. Verified: `react_router` 7/7 tests, SSR worker renders the router demo through the new bundles (`location: /`, route matching, `router-link` markup).

    **Dart helpers carry the bare component name** (`outlet()`, `navigate()`, `memoryRouter(children:, initialEntries:)`, `route(path:, element:)`, `link(to:, children:)`, …) — the `--prefix` value is used *only* for the JS registration keys (`reactRouter.*`) the shim registers and the Dart `foreignComponent('reactRouter.Name', …)` lookups reference; it never leaks into Dart function names, so generated APIs read like handwritten ones. (A `hide link` is still needed where `react_web`'s `<link>` element helper is imported alongside the router's `Link`.)

12. ✅ Bundler abstraction + target-aware packaging layer — `JavaScriptBundler` interface with the existing esbuild path contained behind it (`EsbuildBundler`, `packages/react_tool/lib/src/bundler/`), explicit per-target bootstrap entries (`browser.entry.mjs`, `ssr.entry.mjs` + `ssr_runtime.mjs` split), a deterministic `bundle_manifest.json` (schema 1, bundler, mode, per-target entry/dart/runtime/foreign + byte sizes), and a `BundleManifest` model consumed by `react serve` and the `react_testing` harness (falling back to legacy names). esbuild metafiles enabled with output size + duration logging. Foreign bundles verified byte-for-byte identical to the pre-refactor output (browser `1e4b38e3…`, ssr `c8a81a5e…`); browser E2E (hydration + server function) green. Design record: `docs/bundler_recommendation.md`.

Post-12 roadmap (bundler recommendations, in order):

13. ✅ Bundle reporting — `bundle_report.json` (schema 1) next to `bundle_manifest.json`: per-target artifacts, uncompressed/gzip bytes, optional source-map size, externals, `retainedExports` (component keys surviving the final bundle, e.g. `reactRouter.Route`), and `retainedHookNamespaces`. Retained keys come from string literals (`__reactDartRegisterComponent('…')`, `'ns.Name': …` shim object keys) which survive minification.

14. ✅ Rolldown backend — `react.yaml bundling.backend: rolldown` selects `RolldownBundler` (esbuild stays the default); the managed environment pins `rolldown` as a devDependency and a tool-owned `rolldown_driver.mjs` drives it with the same request/response contract as the esbuild driver (JSON argv options, structured inputs/outputs summary). Browser keeps externals bare for the import map; the node target rewrites them to absolute paths through the environment's npm root. `backend: webpack` and friends are rejected at config load.

15. ✅ Named shim imports — `generateShim()` imports only the referenced declarations as individual named imports aliased `__reactDart<Name>` (tree-shakeable) instead of `import * as …`; hook bridge bodies call the aliased imports. The `react_router` browser/server shims were regenerated through the CLI.

16. ✅ Per-target usage data — each `bundle_report.json` target now carries `usedComponents` (retained keys whose quoted literal appears in the compiled `client.js`/`ssr.js` Dart output) and `usedHooks` (`<namespace>.<hook>` paths from the `__reactDartBindings` JS-interop bridge). `dart compile js` preserves these string literals while tree-shaking unused helpers, so the scan reports what the app actually renders per target (verified on the example: browser uses `MemoryRouter/Routes/Route/Link/NavLink`, SSR additionally calls `useLocation`/`useParams`).

17. ✅ Application-level DCE — the aggregate entry for each target now imports only the foreign surface the compiled Dart output references. The build runs the Dart compilation first, scans `client.js`/`ssr.js` for used component keys and hook paths, and:
    * rewrites generated wrapper shims (`parseForeignShim` + `pruneShim` in `react_tool/lib/src/bundler/shim_pruning.dart`) to import and register only the used subset — filtered import line, filtered `components`/`hooks` object literals, whole hook bridge dropped when unused — so the bundler tree-shakes the rest of the npm package;
    * follows aggregator wrapper entries (files that only import local modules, like `react_router_shim.mjs`) recursively, materializing pruned copies under `foreign/<target>/<package>/`;
    * drops project-level `foreign.components` whose key never appears in the target's compiled output, and emits an empty bundle when everything is pruned so bootstraps and `bundle_report.json` still resolve `foreign/<target>/bundle.mjs`.
    Pruning is skipped for a target whose Dart entrypoint was not compiled (no scan → keep everything).
    Measured on the example release build: browser bundle 32.8 → 22.7 KiB (11.6 → 8.4 KiB gzip) and retained exports 8 → 5 (`MemoryRouter`/`Routes`/`Route`/`Link`/`NavLink`); SSR 156.3 → 149.6 KiB, dropping `StaticRouter` and all unused hooks. SSR gains are smaller because the router runtime dominates and is largely shared; browser gains come from tree-shaking the unused `use*` hooks out of `react-router-dom`. `server_boot_test` passes against the pruned bundles.

18. ✅ Combined-bundle decision — **keep `client.js`/`ssr.js` separate from the foreign bundle.** Measured release artifacts: dart2js output is `client.js` 390 KiB / `ssr.js` 312 KiB versus a tree-shaken foreign bundle of 22.7 KiB (browser) / 149.6 KiB (SSR). The Dart output already dwarfs the foreign surface and is minified beyond what esbuild can further shrink, so physically inlining saves only one HTTP request per target while forcing a classic-script IIFE into an ESM wrapper (re-risking global-init order, deferred imports, re-minification). It also cannot be *shared* across targets without making browser clients download the SSR-only `react-dom/server` code. Recorded as an optional future packaging mode (`react.bundling.combineDartOutput: false` default); the doc's risk list (Dart output format, source maps, deferred imports, global init order) is preserved there.

19. ✅ Deferred docs — the post-PR non-goals are now recorded with their status in `bundler_recommendation.md`: Rolldown and usage manifests done, combined bundling decided against, and **hook bridge redesign, code splitting, and automatic chunk loading** explicitly deferred with reasons (bridge works and is DCE-pruned; dart2js has no stable per-import split; chunk loading depends on code splitting).

The existing mechanism demonstrates that wrappers can self-register and be discovered through Dart package metadata. That part is valuable. The permanent design should make the **module specifier** the contract, make esbuild the resolver, separate browser and Node outputs, and keep all automatically managed npm state out of the consumer’s source-controlled manifest.

[1]: https://r2.nodejs.org/docs/latest/api/packages.html?utm_source=chatgpt.com "Modules: Packages | Node.js v26.5.0 Documentation"
[2]: https://esbuild.github.io/api/ "esbuild - API"
[3]: https://esbuild.github.io/getting-started/?utm_source=chatgpt.com "esbuild - Getting Started"
[4]: https://www.typescriptlang.org/docs/handbook/modules/reference?utm_source=chatgpt.com "TypeScript: Documentation - Modules - Reference"
[5]: https://docs.npmjs.com/cli/configuring-npm/package-json/?utm_source=chatgpt.com "package.json | npm Docs"
