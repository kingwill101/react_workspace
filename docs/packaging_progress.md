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
import * as RRD from 'react-router-dom';
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
├── ssr_worker.mjs                 # tool-generated node worker (shims + imports)
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
├── index.html                     # import map + <script src="foreign/browser/bundle.mjs">
└── manifest.json
```

Naming note: esbuild renames `.mjs` entries to `.js` under `outdir`, so the tool passes an explicit `outfile: …/bundle.mjs`. All references (the page's script tag, the worker's import) point at `bundle.mjs`; the `entry.mjs` files are bundle inputs that may remain as dead weight.

Browser:

```html
<script type="module" src="foreign/browser/bundle.mjs"></script>
<script type="module" src="client.js"></script>
```

SSR worker:

```js
globalThis.require ??= createRequire('<envNpmRoot>/x.js');  // UMD dynamic require
await import('./foreign/ssr/bundle.mjs');
await import('./ssr.js');
```

# Implementation details that diverged from the design

These decisions were forced by the ecosystem while implementing:

* **`npm view <name> versions --json` + local range filtering** — modern npm rejects range specifiers containing spaces/`>` in `npm view pkg@range` (`EINVALIDTAGNAME`). The tool fetches the full version list once and filters locally against every wrapper's range.
* **Driver protocol** — esbuild is invoked programmatically by a tool-owned `driver.mjs` in the environment; build options arrive as JSON argv. The npm root travels via `REACT_NPM_ROOT` because esbuild rejects unknown option keys.
* **SSR externals via node-externals plugin** — the SSR bundle keeps `react`/`react-dom` external, so the driver's `onResolve` rewrites those bare specifiers to absolute paths inside the managed environment (`require.resolve` against the npm root), guaranteeing the worker and the foreign bundle share one React instance.
* **Import-map pinning** — the browser import map (`https://esm.sh/react@X.Y.Z`) is rewritten to the environment's exact resolved `reactVersion` on every build (idempotent), so browser and SSR always agree on one React release.
* **Node compat shims in `ssr_worker.mjs`** — the worker runs dart2js output in Node and needs two aliases injected by the generator:
  * `globalThis.require ??= createRequire('<envNpmRoot>/x.js')` — react-router-dom's UMD build calls dynamic `require('react')` at init; this binds it to the same managed React instance.
  * `globalThis.self ??= globalThis` — dart2js compiles `Random.secure()` to `self.crypto.getRandomValues(...)`; uuid (a riverpod 3 dependency) calls it at module init. Node ≥18 exposes `globalThis.crypto` (webcrypto).
* **`.installed` marker + manifest-content comparison** — a rebuild skips `npm install` when the generated manifest content is unchanged since the last successful install; the marker file is the install record.
* **`entries: false` for a target** — `ssr: false` / `browser: false` suppress that target for the wrapper (no entry emitted for it).

# Migration from the current implementation

Status (implemented):

1. ✅ `react.shims` / `react.npm` replaced by the versioned `react.js` descriptor (schema 1); the old fields are still accepted for compatibility (`JsWrapperDescriptor.parse`).
2. ✅ Separate browser and SSR aggregate entry files (`foreign/browser/entry.mjs`, `foreign/ssr/entry.mjs`).
3. ✅ One esbuild run per target (`driver.mjs` + JSON options, pinned esbuild from the managed environment).
4. ✅ The copy fallback is removed — bundling failures are fatal.
5. ✅ Dependency provenance and version-conflict diagnostics (`NpmRequirement` + `JsDependencyConflict`, listing every declaring wrapper).
6. ✅ Automatic installations moved into `.dart_tool/react/js` (never the host `package.json`); reinstall detection via manifest-content comparison + `.installed` marker.
7. ✅ esbuild pinned as a devDependency of the managed environment (host fallback only in host mode).
8. ✅ One resolved React version: the import map is rewritten to the exact version the environment resolved, and the SSR worker imports react/react-dom through absolute paths in that same environment.
9. ✅ `managed` (default) and `host` JS-environment modes (`react.yaml foreign.host: true`); `react js install` / `react js sync` subcommands.
10. ✅ Prebuilt wrapper support — wrappers ship already-bundled per-target artifacts (`prebuilt.browser` / `prebuilt.ssr`); the build imports them into the aggregate and esbuild keeps react/react-dom external. A prebuilt-only wrapper contributes no npm `dependencies` (they are inlined by the wrapper author), so no installation is forced beyond the framework singletons. Verified end-to-end: the real pinned esbuild bundles a prebuilt file and the node-externals plugin rewrites its bare `react` import to the managed env path, loading against the same 18.3.1 instance.
11. ⬜ TypeScript module resolution for `.d.ts` discovery and binding generation — future work.

The existing mechanism demonstrates that wrappers can self-register and be discovered through Dart package metadata. That part is valuable. The permanent design should make the **module specifier** the contract, make esbuild the resolver, separate browser and Node outputs, and keep all automatically managed npm state out of the consumer’s source-controlled manifest.

[1]: https://r2.nodejs.org/docs/latest/api/packages.html?utm_source=chatgpt.com "Modules: Packages | Node.js v26.5.0 Documentation"
[2]: https://esbuild.github.io/api/ "esbuild - API"
[3]: https://esbuild.github.io/getting-started/?utm_source=chatgpt.com "esbuild - Getting Started"
[4]: https://www.typescriptlang.org/docs/handbook/modules/reference?utm_source=chatgpt.com "TypeScript: Documentation - Modules - Reference"
[5]: https://docs.npmjs.com/cli/configuring-npm/package-json/?utm_source=chatgpt.com "package.json | npm Docs"
