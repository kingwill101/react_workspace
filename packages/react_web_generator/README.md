# react_web_generator

Generates the **web host layer** for `react_web`: typed Dart element factories, the
complete neutral Web IDL type surface, a browser adapter that bridges React synthetic
events and DOM elements to `package:web` at runtime, and SSR metadata for server-side
rendering.

This package is **not** meant to be imported by application code. Run its generator
(`tool/web_idl/generate_factories.dart`) during development; it rewrites generated files
inside `packages/react_web/lib/src/generated/`.

---

## 1. What it produces

| Output | Location | Description |
|--------|----------|-------------|
| Neutral type surface | `packages/react_web/lib/src/generated/web/` | The complete Web IDL surface as `abstract interface class` declarations: `web.dart` barrel plus one focused library per spec (`dom.dart`, `html.dart`, `svg.dart`, `webaudio.dart`, …). 2167 definitions across 262 specs. |
| React event types | `packages/react_web/lib/src/generated/react_events.dart` | Authored React synthetic event interfaces (`ReactMouseEvent<T>`, `ReactKeyboardEvent<T>`, …). |
| Element factories | `packages/react_web/lib/src/generated/elements.dart` | Pure Dart factory functions (`div(...)`, `button(...)`, …) returning `ReactNode` with typed props, events, and refs. |
| DOM factories | `packages/react_web/lib/src/generated/dom.dart` | Non-element DOM factories (`document`, `window`, …). |
| Browser adapter | `packages/react_web/lib/src/generated/browser_adapter.dart` | Concrete wrappers that delegate every member to `package:web` via JS interop, plus `BrowserWebRuntime`, `registerBrowserAdapters()`, and `installBrowserWebRuntime()`. |
| SSR surface | `packages/react_web/lib/src/generated/web/ssr.dart` | The same 2167 interfaces as throwing implementations (`UnsupportedWebApiError`), `SsrWebRuntime`, and `installSsrWebRuntime()`. |
| SSR metadata | `packages/react_web/lib/src/generated/ssr_metadata.dart` | Per-element prop/event lowering metadata (`WebElementSsrDefinition`), driven by `ssr_metadata.dart` consumers. |

All generated files are **generated artifacts**. Do not hand-edit them; edits will be
overwritten on the next generation run.

---

## 2. How it works — the layered architecture

### 2.1 Complete neutral surface (single source of truth)

The generator loads the pinned Web IDL snapshot (`tool/web_idl/snapshots/web_apis.json`),
filters specs against browser compatibility data (`BcdFilter`), and merges them into a
`CompleteWebModel` covering **every** interface, mixin, callback interface, enum,
typedef, and namespace — no reachability cut-down, no hand-maintained auxiliary types.

Each definition becomes an `abstract interface class` in the neutral surface. Mixins are
flattened into the interfaces that use them (`implements` lists), so the surface is
usable purely as static types without any `dart:js_interop` dependency.

### 2.2 Verifier gate

`tool/web_idl/verify.dart` is the integrity gate between the snapshot and the generated
surface:

- every definition and member in the model is emitted (dropped 0, opaque 0)
- no duplicate interface names
- `--strict`: every `interface`-kind definition has a `package:web` counterpart
  (`PackageWebMappings.missingTypes`). Mixins and callback interfaces are excluded: the
  browser adapter only wraps interfaces.

### 2.3 Web Host IR (factories and SSR metadata)

`WebHostIrBuilder` builds a `List<WebHostElementIR>` from the complete model plus two
config files:

1. **Web IDL snapshot** — the pinned spec data.
2. **React DOM overlay** (`config/react_dom_overlay.json`) — React-specific mapping of
   DOM events to React synthetic event types, property renames (`class` →
   `className`), and global props.
3. **Element roots** (`config/roots.json`) — which tags get factories, plus the void
   element list.

`WebHostElementIR` describes exactly what each element factory should expose:

- `WebHostElementIR` — tag name, factory name, namespace, element type, void flag,
  props list, events list.
- `WebHostPropIR` — IDL name, Dart name, React name, type, required flag, SSR behavior.
- `WebEventPropIR` — DOM event name, React name, capture name, React event type,
  native event type.

### 2.4 Browser adapter (real delegation to package:web)

The generated `browser_adapter.dart` is a full runtime backend. Every wrapper is a
`final class BrowserX extends BrowserObjectAdapter implements X` where
`BrowserObjectAdapter` holds a `JSObject` and dispatches getters, setters, and method
calls through `dart:js_interop_unsafe` (`getProperty`/`setProperty`/`callMethodVarArgs`).
Type conversion (`_toJs`/`_convert`) handles primitives, lists, JS objects, and
`null`/`undefined`; unknown values become `_UnknownObject`.

Wrapper classes are closed over `implements` from the neutral surface; when
`package:web` exports the same name, the wrapper also exposes a `web.X get inner`
accessor for raw interop escapes. Event wrappers (`BrowserReactMouseEvent<T>`, …) are
generated per React event type from the shared `reactEventDefs` and expose `inner` as a
`JSObject`.

`BrowserWebRuntime` implements `WebRuntime` against `web.window`/`web.document`.
`registerBrowserAdapters()` registers every element-like interface and React event type
with `ReactCodecRegistry` so the JS bridge can serialize/deserialize host values across
the Dart–JS boundary. `installBrowserWebRuntime()` installs the runtime singleton.

---

## 3. The generation pipeline

Run from the workspace root:

```bash
dart run tool/web_idl/generate_factories.dart
```

Steps in order:

1. **Load the raw model** — parse the pinned Web IDL snapshot.
2. **Apply the BCD filter** — drop deprecated/never-implemented specs.
3. **Merge** into `CompleteWebModel` (flatten mixins, resolve typedefs).
4. **Verify** — completeness and duplicate-name gate.
5. **Emit the SSR surface** — `web/ssr.dart` (throwing implementations).
6. **Emit focused libraries** — the neutral surface, one library per spec, into
   `packages/react_web/lib/src/generated/web/` plus `lib/apis/` convenience barrels.
7. **Emit React event types** — `react_events.dart` from `reactEventDefs`.
8. **Build `WebHostElementIR`** — from the model, overlay, and roots.
9. **Emit element factories** — `elements.dart`.
10. **Emit the browser adapter** — `browser_adapter.dart` from the model plus
    `PackageWebMappings` (which neutral names map to `package:web`).
11. **Emit DOM factories** — `dom.dart`.
12. **Emit SSR metadata** — `ssr_metadata.dart` from the IR.

---

## 4. Configuration files — what to edit and why

### `config/react_dom_overlay.json`

**What it controls:** React-specific mappings that do not exist in raw Web IDL:
property renames, global props, event → synthetic event mappings, and type policies.

- **`propertyRenames`** — maps IDL attribute names to their React/Dart prop names.
- **`globalProps`** — attributes added to every element even if IDL does not declare them.
- **`events`** — maps DOM event names to React synthetic event wrapper types.
- **`typePolicies`** — exposure policy overrides per type (`full`/`opaque`/`excluded`).

### `config/roots.json`

**What it controls:** Which HTML tags get factories, and the void-element list.

```json
{
  "voidElements": ["area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"],
  "elements": [{"tag": "div", "voidElement": false}, {"tag": "button", "voidElement": false}, ...]
}
```

**When to edit:** Adding support for a new HTML element (e.g. `<video>`). Add the tag
to `elements` (with `voidElement` matching the spec), re-run the generator. The
corresponding interface (e.g. `HTMLVideoElement`) must exist in the snapshot — the
builder throws if it does not.

### `tool/web_idl/snapshots/web_apis.json`

The pinned JSON snapshot of browser specification IDL. Not hand-edited during normal
development; refresh it with the snapshot acquisition tool in `tool/web_idl/` and pin
`package:web` to a matching revision.

---

## 5. What gets updated manually vs. automatically

### Generated (do not edit directly)

| File | Generated by | Why |
|------|--------------|-----|
| `packages/react_web/lib/src/generated/web/**` | `NeutralSurfaceEmitter` (+ per-spec focused libraries) | Complete neutral surface from the model. |
| `packages/react_web/lib/src/generated/web/ssr.dart` | `SsrSurfaceEmitter` | Throwing SSR surface + `SsrWebRuntime` + installer. |
| `packages/react_web/lib/src/generated/react_events.dart` | `ReactEventEmitter` | React synthetic event interfaces. |
| `packages/react_web/lib/src/generated/elements.dart` | `FactoryEmitter` | Deterministic output from `WebHostElementIR`. |
| `packages/react_web/lib/src/generated/dom.dart` | `DomFactoryEmitter` | Non-element DOM factories. |
| `packages/react_web/lib/src/generated/browser_adapter.dart` | `BrowserAdapterEmitter` | Real delegation wrappers + `BrowserWebRuntime`. |
| `packages/react_web/lib/src/generated/ssr_metadata.dart` | `SsrMetadataEmitter` | SSR prop/event lowering metadata. |
| `packages/react_web/lib/src/generated/completeness_report.json` | generator | Defs/members/duplicates audit. |
| `packages/react_web/lib/apis/**` | generator | Convenience barrels for focused libraries. |

### Hand-authored (edit these)

| File | Purpose |
|------|---------|
| `config/react_dom_overlay.json` | Event/property renames/overrides and type policies. |
| `config/roots.json` | Element factory roots + void elements. |
| `lib/src/emit/react_event_defs.dart` | React synthetic event shapes (single source for surface + adapter). |
| `lib/src/emit/browser_adapter_emitter.dart` | Browser adapter generation logic. |
| `lib/src/emit/factory_emitter.dart` | Factory generation logic. |
| `lib/src/ir_builder.dart` | IR construction, IDL-to-Dart type mapping (incl. `WindowProxy` → `Window`), void-element logic. |
| `lib/src/complete/**` | Model parsing/merging and neutral-surface emission. |
| `packages/react_web/lib/react_web.dart` | Barrel export; hides `Text`, `EffectCallback`, and factory helper types to avoid collisions with `package:react` / `web_animations_2`. |

---

## 6. How to extend the generator

### 6.1 Add a new HTML element

1. Add the tag to `config/roots.json` under `elements` (with the correct
   `voidElement` flag).
2. Confirm the interface exists in `tool/web_idl/snapshots/web_apis.json` (the builder
   throws `StateError` if not).
3. Run `dart run tool/web_idl/generate_factories.dart`.
4. The new factory function and `Browser*` adapter wrapper are produced automatically.

### 6.2 Add a new event type

1. Add the DOM event entry to `config/react_dom_overlay.json` under `"events"`.
2. Add the `ReactEventDef` to `lib/src/emit/react_event_defs.dart`.
3. Run the generator. The factory emits `onScroll`/`onScrollCapture` callbacks, the
   surface emits the `ReactScrollEvent<T>` interface, and the adapter emits
   `BrowserReactScrollEvent<T>`.

### 6.3 Add a new global property

Add the attribute name to `"globalProps"` in `config/react_dom_overlay.json`. It is
appended to every element factory.

### 6.4 Rename an IDL property to a React prop

Add a mapping to `"propertyRenames"` in `config/react_dom_overlay.json` (e.g.
`"class": "className"`).

### 6.5 Change adapter emission logic

Edit `lib/src/emit/browser_adapter_emitter.dart`. Common changes:

- Add a `_kinds` entry for a new primitive kind.
- Change how unknown JS values are wrapped (`_UnknownObject`).
- Extend `registerBrowserAdapters()` dispatch.

### 6.6 Change factory emission logic

Edit `lib/src/emit/factory_emitter.dart`.

---

## 7. Key concepts and types

### CompleteWebModel

The central data structure produced by the snapshot load/merge steps. Contains every
definition (`interface`, `mixin`, `callbackInterface`, `enum`, `typedef`, `namespace`)
with parsed members. Mixins are flattened into using interfaces; typedefs are resolved.

### PackageWebMappings

Maps neutral interface names to the `package:web` revision pinned in the workspace.
Used by the strict verify gate and by `BrowserAdapterEmitter` to decide which wrappers
also expose a `web.X get inner` accessor.

### WebHostElementIR

The offline-friendly IR consumed by the factory/SSR emitters:

- `tagName` — `"div"`.
- `factoryName` — `"div"`.
- `elementType` — `WebDartType(symbol: 'HTMLDivElement', import: 'package:react_web/src/generated/web/web.dart')`.
- `voidElement` — `true` for `img`, `input`, …
- `props` — list of `WebHostPropIR`.
- `events` — list of `WebEventPropIR`.

### ReactCodecRegistry

The runtime registry (in `react_js`) that maps `(namespace, typeId)` pairs to
encoder/decoder functions. The generated `registerBrowserAdapters()` registers every
element-like interface and React event type so the JS renderer can serialize/deserialize
DOM nodes and events across the Dart–JS interop boundary.

### WebRuntime

The runtime seam between renderer-independent code and the host environment. The browser
path installs `BrowserWebRuntime` (via `initReact()` in `react_dom`); server entry points
install `SsrWebRuntime` via `installSsrWebRuntime()` (exported from
`package:react_web/web.dart`).

---

## 8. Generated interface files — usage and caveats

### Neutral surface (`generated/web/`)

Used as:

- **Ref callback types** — e.g. `void Function(HTMLDivElement?)? ref`.
- **Event `currentTarget` types** — e.g. `ReactSyntheticEvent<T extends EventTarget>`.
- **Adapter implementation targets** — `BrowserX` wrappers `implements` the neutral
  interface and satisfy every member via `BrowserObjectAdapter.noSuchMethod`.
- **Application typing** — components can type props/state with DOM types without a
  browser dependency.

**Barrel hiding:** `packages/react_web/lib/react_web.dart` hides `Text` (collides with
`package:react`'s `Text` node class), `EffectCallback` (collides with
`web_animations_2`), and the generated element factory helper types (`div`, `span`, …)
so the factories remain available through `elements.dart`'s own import. If the surface
gains new top-level names that collide, extend the `hide` lists.

### React event types (`react_events.dart`)

Parameterized interfaces authored in `react_event_defs.dart`:

```dart
abstract interface class ReactSyntheticEvent<T extends EventTarget> {
  T get currentTarget;
  EventTarget get target;
  ...
}
```

Referenced by `elements.dart` factory signatures, `browser_adapter.dart` wrappers, and
application event handlers.

---

## 9. Running the generator in practice

```bash
# From the workspace root
cd /run/media/kingwill101/disk2/code/code/dart_packages/react_workspace
dart run tool/web_idl/generate_factories.dart
```

Expected output ends with:

```text
Generated 11 element factories → packages/react_web/lib/src/generated/elements.dart
Generated browser adapter → packages/react_web/lib/src/generated/browser_adapter.dart
Generated DOM factories → packages/react_web/lib/src/generated/dom.dart
Generated SSR metadata → packages/react_web/lib/src/generated/ssr_metadata.dart
```

Gate:

```bash
dart run tool/web_idl/verify.dart            # completeness + duplicates
dart run tool/web_idl/verify.dart --strict   # + package:web mapping coverage
```

Tests:

```bash
cd packages/react_web_generator && dart test
cd packages/react_web && dart test           # VM suites
cd packages/react_web && dart test -p chrome test/host_value_adapter_test.dart  # browser backend
```

---

## 10. Troubleshooting

### `IDL interface "XYZ" not found for element "foo"`

The roots config references a tag whose interface is absent from the snapshot. Refresh
the snapshot or remove the root element.

### `package:web missing mappings` in strict verify

The snapshot surface is ahead of the pinned `package:web` revision. Pin `package:web`
to the snapshot revision, or update `tool/web_idl/snapshots/provenance.json`.

### `ambiguous_export: Text` (or `EffectCallback`)

`package:react` exports a `Text` widget and `web_animations_2` exports
`EffectCallback`; the neutral surface also declares them. The barrel export in
`react_web.dart` hides the conflicting names. If new generated types collide, update the
`hide` lists.

### SSR throwing `UnsupportedWebApiError`

Expected: the SSR surface deliberately throws for live Web APIs. Host elements are
handled by the virtual host-node pipeline and SSR metadata, never by constructing DOM
objects.

---

## 11. Design decisions

### 11.1 Single source of truth: the Web IDL snapshot

All generated outputs derive from one pinned snapshot (`web_apis.json`) merged into
`CompleteWebModel`. There is no intermediate hand-maintained model JSON: adding an
element or exposing a member never requires editing auxiliary stubs — the full surface
is generated.

### 11.2 Full surface, not reachability

Every definition in the snapshot is emitted (filtered only by BCD). This keeps the
surface stable, total, and free of "unresolved type" closures: no member is dropped, and
application code can use any browser type.

### 11.3 Mixins flatten into interfaces

Mixins are not emitted as standalone abstract mixin classes; their members are merged
into the interfaces that `includes` them. This keeps `implements` closures closed and
lets `BrowserObjectAdapter.noSuchMethod` cover every member uniformly.

### 11.4 The browser adapter is generated, not handwritten

`browser_adapter.dart` is ~6.7k lines of mechanical, deterministic delegation
(`getProperty`/`setProperty`/`callMethodVarArgs` per member). Handwriting it would be
unmaintainable; generation guarantees it matches the neutral surface exactly. The
`BrowserObjectAdapter.noSuchMethod` dispatcher means a new IDL member requires only
regeneration, never a hand edit.

### 11.5 SSR generation policy

SSR does **not** construct concrete DOM or event objects (`HTMLDivElement`, `MouseEvent`,
`FileList`). The shared interfaces exist so component source compiles; the SSR surface
throws `UnsupportedWebApiError` on live access. SSR renders from the same model:

- host element metadata
- prop filtering
- attribute/property names
- boolean behavior
- void-element behavior
- `dangerouslySetInnerHTML` handling

If a future native renderer needs real server-side DOM handles, add another target
emitter from the same model.

### 11.6 React-specific data comes from React declarations

Web IDL knows about browser interfaces, but not `SyntheticEvent`, `onClickCapture`,
`dangerouslySetInnerHTML`, or ref shapes. That information lives in
`react_event_defs.dart` and `react_dom_overlay.json`, pinned alongside the snapshot.

---

## 12. File inventory

```
packages/react_web_generator/
├── config/
│   ├── roots.json                  # Element factory roots + void elements
│   └── react_dom_overlay.json      # Event/property renames/overrides, type policies
├── lib/
│   ├── react_web_generator.dart    # Barrel export
│   └── src/
│       ├── bcd_filter.dart         # Spec filtering by browser compatibility data
│       ├── ir_builder.dart         # Builds WebHostElementIR from model + overlay + roots
│       ├── complete/
│       │   ├── complete.dart       # CompleteWebModel, merge, load
│       │   ├── package_web_mappings.dart  # package:web name mapping
│       │   └── emit/
│       │       ├── neutral_surface_emitter.dart  # Emits web/** + lib/apis/**
│       │       └── ssr_surface_emitter.dart      # Emits web/ssr.dart
│       └── emit/
│           ├── react_event_defs.dart        # Authored React event shapes
│           ├── react_event_emitter.dart     # Emits react_events.dart
│           ├── factory_emitter.dart         # Emits elements.dart
│           ├── dom_factory_emitter.dart     # Emits dom.dart
│           ├── browser_adapter_emitter.dart # Emits browser_adapter.dart
│           └── ssr_metadata_emitter.dart    # Emits ssr_metadata.dart
└── test/
    └── factory_emitter_test.dart       # FactoryEmitter unit tests

tool/web_idl/
├── generate_factories.dart             # Top-level generation entry point
├── verify.dart                         # Integrity gate (--strict for package:web)
└── snapshots/
    ├── web_apis.json                   # Pinned Web IDL snapshot
    └── provenance.json                 # Snapshot metadata (source, date, revision)
```
