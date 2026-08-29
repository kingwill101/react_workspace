# Hooks translation, auto-generated `.mjs`, and bundling — current state & plan

> Status: **analysis only.** Three work tracks are laid out below. Nothing in this
> document changes code; it records the current state of the `react_tool` TS-binding
> pipeline and the bundling pipeline, the concrete breakages that block a green test
> run, and a prioritized implementation plan for each track.

---

## 0. Why we're here

Two maintenance goals drive this work, both reducing handcrafting:

1. **Hooks properly translated by `react ts bind`, and the `.mjs` glue auto-generated** —
   so wrapper packages like `react_router_dom` stop being hand-maintained and are instead
   (re)generated from the npm package's `.d.ts` declarations.
2. **Proper bundling / minimization** — the tool's builder should collapse the many
   `.mjs` shim modules into a small number of minified release bundles (and, ideally,
   a single one per target), instead of shipping a hundred loose `.mjs` files. We are
   open to leaning on more oxc-native tooling (rolldown / oxc-transformer / oxc-minifier).

---

## 1. Current pipeline (what already exists)

### 1.1 The `react ts bind` generator

Files:
- `packages/react_tool/native/src/lib.rs` — Rust/oxc extractor that parses `.d.ts`,
  resolves subpath specifiers through the package `exports` map via `oxc_resolver`,
  and returns a JSON IR of `component | interface | alias | hook` declarations.
- `packages/react_tool/lib/src/ts_bindings.dart` — Dart generator over that IR.
- `packages/react_tool/lib/src/ts_bindings.g.dart` — `@Native` externals for the
  Rust `tsb_extract` entry.
- CLI: `react ts bind` in `packages/react_tool/lib/src/cli.dart` with
  `-o/--output`, `--prefix`, `--type-prefix`, `--shim`, `--hooks`, `--npm-root`.

Outputs (per invocation):
- **`<spec>_bindings.g.dart`** — typed component helpers (bare Dart names like
  `link(...)`, `route(...)`, `memoryRouter(...)`), plus value classes and enums
  (`RelativeRoutingType`, `NavigationType`, `FutureConfig`, `Location`, `UIMatch`, …).
- **`<spec>_hooks.g.dart`** (via `--hooks`) — typed `use*` Dart hooks that call the
  shim's `globalThis.__reactDartHooks.<hook>` bridge and decode results
  (`_pairsMap`, `_decodePairs`, `_decodeList`, `fromParts`, enum `fromValue`,
  captured closures for function returns).
- **`<spec>_shim.mjs`** (via `--shim`) — a self-registering ESM module that:
  - registers each bound component as `globalThis.__reactDartRegisterComponent(name, c)`,
  - registers `globalThis.__reactDartHooks = { useX: (…)=>{…}, … }` with `toPairs`
    decode logic in JS.

`react_router_dom` is now ~fully generated:
- `packages/react_router_dom/lib/react_router_dom_bindings.g.dart`
- `packages/react_router_dom/lib/react_router_dom_server_bindings.g.dart` (subpath
  `react-router-dom/server`, `--type-prefix Server` to avoid `FutureConfig` collisions)
- `packages/react_router_dom/lib/react_router_dom_hooks.g.dart`
- `packages/react_router_dom/lib/react_router_dom_bindings_shim.mjs`
- `packages/react_router_dom/lib/react_router_dom_server_shim.mjs`

### 1.2 What is still handcrafted

1. **`packages/react_router_dom/lib/react_router_dom.dart`** — public library wrapper. Today it
   is only `export` lines + the generation command in the doc comment. Trivial to
   generate, but still a hand-maintained file.
2. **`packages/react_router_dom/lib/react_router_dom_shim.mjs`** — a 10-line glue module that
   just imports the two generated shims:
   ```js
   import './react_router_dom_bindings_shim.mjs';
   import './react_router_dom_server_shim.mjs';
   ```
   It exists because `react.js` `entries.shared` points at one entry, while `--shim`
   emits one `.mjs` per extraction. Auto-generatable, or collapsible into one entry.
3. **Docs / command lines** embedded in `react_router_dom.dart` — easy to drift from the
   actual `react ts bind` invocation.

## 2. Track 1 — Fix the current breakages → green tests

`dart test packages/react_router_dom/test/react_router_dom_test.dart` currently **fails to
compile**. Confirmed errors and root causes:

### 2.1 A — `route()` wrongly requires `index` (generator bug)

Error: `Required named parameter 'index' must be provided` at the
`route(path:…, element:…)` callsite.

TS ground truth (`react-router/dist/lib/components.d.ts`):
```ts
export interface PathRouteProps { …; index?: false; … }
export interface LayoutRouteProps extends PathRouteProps {}
export interface IndexRouteProps { …; index: true; … }
export type RouteProps = PathRouteProps | LayoutRouteProps | IndexRouteProps;
```
So `RouteProps.index` is **optional** (`index?: boolean`). The generated helper emits:
```dart
required bool index,
```
which is wrong. The intent is even documented in `native/src/lib.rs:1294-1297`
(`merge_prop_union` keeps a prop optional unless *every* variant requires it), so the
**component-var** path for `ForwardRefExoticComponent<RouteProps & …>` is not reaching
that union merge — the intersection with `RefAttributes` is flattened to an object
with `__ref` markers *before* `RouteProps`'s union is expanded, so `index`'s
optionality is dropped. The emitted `index: false | false | true` type string is also
a union-merge artifact (dedupe missing).

**Plan:**
- Reproduce with a focused unit test asserting `index` is optional in the emitted IR
  for `ForwardRefExoticComponent<RouteProps & …>`.
- In `native/src/lib.rs`, make the component annotation path resolve the inner props
  type and push it through `props_for_expr`'s `TyExpr::Union` branch
  (`merge_prop_union`) before the intersection `__ref` flattening strips it — i.e.
  preserve union structure across the `Foo<Props & RefAttributes<…>>` wrapper.
- Dedupe literals in the boolean-union before emitting (`false | false | true` →
  `false | true` → `bool`).
- Regenerate `react_router_dom_bindings.g.dart`; `route(path:, element:)` should compile
  with `index` optional.

### 2.2 B — stale test reference `LinkRelative` → `RelativeRoutingType`

Error: `Undefined name 'LinkRelative'` at `react_router_dom_test.dart:83`. The enum is
now generated as `RelativeRoutingType` (and imported transitively). Update the test:
```dart
relative: RelativeRoutingType.path,
```

### 2.3 C — `dart:js_interop` leaks to non-JS targets

Error: `Dart library 'dart:js_interop' is not available on this platform` when the
VM `dart test` loads `react_router_dom.dart`, because it `export`s
`react_router_dom_hooks.g.dart`, which `import 'dart:js_interop'`.

Hooks only run in JS targets (browser client, Node SSR worker). Exporting them from
the package root forces every consumer — including VM tests and any non-JS tooling —
to (fail to) compile them.

**Options (pick one for the plan):**
1. _(recommended)_ Keep hooks behind an explicit library: `react_router_dom.dart` exports
   only the component bindings; hooks move to a separate entry (e.g.
   `react_router_dom_hooks.dart` that re-exports the `.g.dart`). Consumers that render
   with hooks import the hooks entry explicitly, and only from JS-targeted Dart.
   The example (`route_content.dart`, `route_item.dart`) and `ssr.dart` would import
   it explicitly. The package test stops importing hooks and only exercises the pure
   Dart bindings.
2. Convert the package test to a web test (`test` with a browser/`dart compile js`
   target) so `dart:js_interop` resolves. Heavier and doesn't fix downstream consumers.
3. Conditionally export via a separate part only reachable from JS. Most complex.

Go with **Option 1**. This also reduces handcrafting: the generated hooks file can
declare a per-package library entry, and the generated/public files can be wired to
`export` it only where requested (`--hooks` already exists; add a generated hooks
library re-export).

**Definition of done for Track 1:** `dart test packages/react_router_dom` (bindings only
path) passes; the example still renders the router demo through the generated bundles
(client + SSR worker); `route(path:…, element:…)` compiles without `index`.


## 3. Track 2 — Harden hook codegen to eliminate handcrafting

Beyond fixing bugs, make the generator produce everything the wrapper needs so the
public package files are artifacts, not hand edits.

### 3.1 Auto-generate the shared shim / collapse to one entry

Today: `react_router_dom_shim.mjs` (hand) imports two generated shims (auto). The
`react.js` descriptor entry is `entries.shared: lib/react_router_dom_shim.mjs`.

Plan:
- Add an `--aggregate-shim` mode (or make `--shim` idempotently merge all generated
  shims registered by this package into one file), OR teach the builder to discover
  generated `*_shim.mjs` files next to `react.js`'s declared source folder and build
  an aggregate entry automatically.
- Result: no handwritten shim; `entries.shared` points at a generated aggregate.

### 3.2 Auto-generate the public library file

Plan:
- Add `--library <path>` (and/or have `react ts bind` emit a `react_router_dom.dart`
  alongside) generating:
  - the doc header with the exact regeneration command,
  - `export '…_bindings.g.dart';`,
  - `export '…_server_bindings.g.dart';` when a subpath extraction was requested,
  - `export '…_hooks.dart';` (or hooks library) **only** when `--hooks`.
- This kills the last handwritten wrapper for `react_router_dom`.

### 3.3 Keep generated value classes close to the JS shape

The hooks file already generates `fromParts` value classes, enums with `fromValue`,
records for tuples, and captured closures for function returns. Remaining hardening
worth scheduling:
- **Function-typed props/returns** (`useNavigate`, `useSubmit`, `useBlocker.reset`)
  are emitted as closures in Dart and `callAsFunction` in JS; verify they survive
  dart2js compilation on the JS target (currently the package test can't even compile
  them because of Track 1 §2.3).
- **`index`-style optionality** (#2.1) applies to hooks too — keep an eye on it.
- Dedupe boolean-literal unions, and normalize `false | true` → `bool`.

**Definition of done for Track 2:** `react_router_dom` has *zero* handwritten `.dart`/`.mjs`
files for the router itself; regenerating the package from scratch reproduces the same
committed tree (modulo whitespace), so maintenance is "re-run the command in the header".


## 4. Track 3 — Bundling & minimization

### 4.1 Current state (`packages/react_tool/lib/src/build.dart`)

`_writeForeignComponents` already does a lot right:
- One **aggregate entry per target** (`browser`, `ssr`): `foreign/browser/bundle.mjs`
  and `foreign/ssr/bundle.mjs`.
- esbuild (`_bundleTarget`): `bundle: true`, `format: esm`, `platform: node|browser`,
  node target for SSR, `conditions: production|development`, `nodePaths` to the
  managed npm root.
- `react`/`react-dom` and wrapper-declared externals stay **external** (singletons) via
  `_mergedExternals`.
- `minify: release` and `sourcemap: linked` in dev; no unbundled fallback (fatal on
  failure).

So the *final release bundle is already one minified `.mjs` per target* that inlines
all wrapper shims. The remaining gaps:

### 4.2 Gaps

1. **Only `--release` minifies**; dev bundles are pretty-printed. (Arguably fine — dev
   readability.) If we want parity with the "hundred files" complaint, confirm release
   really is 1 file/target + `react`/`react-dom` external.
2. **Hook bridge is runtime, not compile-time.** Every hook routes through
   `globalThis.__reactDartHooks.<hook>` and dynamic `toPairs` decode. This indirection
   is not tree-shakable and is the main obstacle to aggressive DCE of unused hooks.
3. **Shims ship in source trees** even though they get inlined — cosmetic, but a
   source of "hundreds of mjs" confusion. The *release bundle* is fine; the *source
   tree* is not.
4. **Bundler is esbuild** (JS, spawned via the node driver `_esbuildDriver`). You noted
   interest in oxc-native tooling.

### 4.3 Options for minimizing + DCE

- **A. Keep esbuild, tighten config.** Add `treeShaking: true` (default), `minify`
   always in release, and assert/instrument one-bundle-per-target. Cheapest, lowest
   risk. Does not change the hook-bridge model.
- **B. Move to rolldown (Rust/oxc) as the production bundler.** rolldown is oxc-powered,
   exposes native + JS APIs, supports ESM, externals, tree-shaking, and has an
   oxc-based minifier. Use it for `--release` (or always) with the same externals and
   per-target platform split. Keeps the same contract (module specifier → one bundle
   per target), so swap is localized in `_bundleTarget` + the node driver.
- **C. Compile-time inline of the hook bridge** so DCE can remove unused hooks:
   generate the hooks shim to **import the concrete hook directly** from the package
   (`import { useNavigate } from 'react-router-dom'`) and expose a small typed bridge
   per hook, rather than a single dynamic `__reactDartHooks` table. Then rolldown/esbuild
   tree-shake unused hook bindings.
   - Trade-off: more generated surface, and the bridge still has to decode across the
     Dart/JS boundary; the win is unused hooks disappear from the release bundle.
- **D. oxc-transformer / oxc-minifier** as a post-processor for TS-stripping + minify if
   we ever bundle `.tsx` foreign components directly (the README mentions Vite/esbuild
   for `.tsx` foreign sources today).

**Recommended sequencing for Track 3:**
1. Instrument the release build: assert the final foreign output is exactly one
   `.mjs` per target (+ `.map`), log sizes before/after minify. (Audit first — the
   "hundred mjs" concern may already be solved at release; capture the evidence.)
2. Add unused-export DCE on the aggregate (option A) and confirm `--release` sizes.
3. Evaluate rolldown as a drop-in for `_bundleTarget` (option B) behind a config flag
   (`esbuild:` vs `rolldown:` bundler in `react.yaml`).
4. If hook DCE matters, move to per-hook direct imports (option C) so unused hooks
   shake out, and re-measure the release bundle.

**Definition of done for Track 3:** `react build --release` emits a small, stable set of
bundles (one per target, ideally), with `react`/`react-dom` external; unreferenced
hooks/components/`__reactDartHooks` members are removed by the bundler; and the output
is reproducible across rebuilds.

---

## 5. Cross-cutting notes

- The native build (`packages/react_tool/native`, cargo) is already present
  (`target/release/libreact_ts_bindings.so` is built), and `dart analyze` on the hooks
  file reports no issues — the compile failure only appears when a *non-JS* target
  pulls in the hooks file. That asymmetry is the crux of Track 1 §2.3.
- Distinguish *source-tree* file count (shims still live in `lib/`) from *release
  bundle* count (already one per target). Both should be surfaced by the tool so the
  "hundreds of mjs" concern is measurable.
- Regeneration is the contract: prefer fixing `native/src/lib.rs` +
  `ts_bindings.dart` and re-running `react ts bind`, never hand-editing `*.g.dart`
  or `*.mjs` shims.

## 6. Suggested iteration order

1. **Track 1** first — it unblocks red tests and directly improves "hooks properly
   translated". Fast win: fix `index` optionality (A), update the stale test (B),
   adopt the hooks-behind-explicit-library split (C).
2. **Track 2** — remove the last handwritten `react_router_dom.dart` + `react_router_dom_shim.mjs`
   by extending `--shim`/adding `--library`.
3. **Track 3** — audit-then-improve bundling (options A → B → C), with rolldown as the
   oxc-native direction the team prefers.

