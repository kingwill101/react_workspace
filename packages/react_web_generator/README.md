# react_web_generator

Generates the **web host layer** for `react_web`: typed Dart element factories, neutral
Web IDL interfaces, and browser adapters that bridge React synthetic events and DOM
elements to `package:web` at runtime.

This package is **not** meant to be imported by application code. Run its generator
(`tool/web_idl/generate_factories.dart`) during development; it rewrites generated files
inside `packages/react_web/lib/src/generated/` and `packages/react_web/lib/src/`.

---

## 1. What it produces

| Output | Location | Description |
|--------|----------|-------------|
| Element factories | `packages/react_web/lib/src/generated/elements.dart` | Pure Dart factory functions (`div(...)`, `button(...)`, …) returning `ReactNode` with typed props, events, and refs. |
| Browser adapter | `packages/react_web/lib/src/generated/browser_adapter.dart` | Concrete wrappers around `package:web` types: `GeneratedElement`, `GeneratedReactSyntheticEvent<T>`, etc. Includes a host-value codec registration function. |
| Neutral HTML interfaces | `packages/react_web/lib/src/types/html_interfaces.dart` | Generated `abstract interface class` declarations for Web IDL element types (e.g., `HTMLDivElement`, `EventTarget`). Used for static typing in factories and adapters. |
| Neutral event interfaces | `packages/react_web/lib/src/event_interfaces.dart` | Generated `abstract interface class` declarations for React synthetic event types (e.g., `ReactMouseEvent<T>`, `ReactKeyboardEvent<T>`). |

All four files are **generated artifacts**. Do not hand-edit them; edits will be
overwritten on the next generation run.

---

## 2. How it works — the 3-layer architecture

### 2.1 Neutral interfaces (pure Dart)

The generator produces abstract interface classes that model Web IDL and React
synthetic event types **without any browser dependency**. These live under
`packages/react_web/lib/src/` and form the **type contract** that the rest of the
workspace uses:

- `types/html_interfaces.dart` — element and DOM types (`HTMLElement`, `EventTarget`,
  `HTMLDivElement`, etc.).
- `event_interfaces.dart` — React event types parameterized by `T extends EventTarget`.

These interfaces are **stable hand-authored sources of truth** for the type shapes,
but the concrete declarations are *generated* from the Web IDL snapshot and React
declarations.

### 2.2 Web Host IR (intermediate representation)

Before emitting Dart code, the generator builds a `List<WebHostElementIR>` — a
lightweight, offline-friendly IR that describes exactly what each element factory
should expose:

- `WebHostElementIR` — tag name, factory name, namespace, element type, void flag,
  props list, events list.
- `WebHostPropIR` — IDL name, Dart name, React name, type, required flag, SSR behavior.
- `WebEventPropIR` — DOM event name, React name, capture name, React event type,
  native event type.

This IR is built by **`WebHostIrBuilder`** from three config sources:

1. **Web IDL snapshot** (`tool/web_idl/snapshots/web_apis.json`) — a pinned JSON dump of
   browser IDL specs (html, dom, cssom, cssom-view).
2. **React DOM overlay** (`config/react_dom_overlay.json`) — React-specific mapping of
   DOM events to React synthetic event types, plus property renames (`class` →
   `className`) and global props.
3. **Element allowlist** (`config/milestone_w1_elements.json`) — which HTML tags to
   generate factories for.

### 2.3 Browser adapter (host-value codec dispatch)

The generated `browser_adapter.dart` provides concrete implementations that run in the
browser (compiled with `dart compile js`). It:

- Implements `EventTarget` for `GeneratedElement` (wrapping `web.HTMLElement`).
- Generates `GeneratedReactMouseEvent<T>`, `GeneratedReactKeyboardEvent<T>`, etc.,
  backed by `dart:js_interop`.
- Provides `wrapJSValue()` / `_wrapOne()` helpers that distinguish elements (by
  `tagName`) from events (by `type`) and dispatch to the correct wrapper.
- Registers every element type and event type with `ReactCodecRegistry` via
  `registerBrowserAdapters()`, enabling the JS bridge to serialize/deserialize host
  values across the Dart–JS boundary.

---

## 3. The generation pipeline

Run from the workspace root:

```bash
dart run tool/web_idl/generate_factories.dart
```

The script executes these steps in order:

### Step 1 — Build the neutral web model

```text
ModelBuilder(webIdlPath) → NeutralWebModel
```

- Loads relevant interfaces from the Web IDL snapshot.
- Adds React event interfaces from `source/react_declarations.dart`.
- Computes reachable types from the configured root element names (e.g. `HTMLDivElement`),
  walking the inheritance chain ( `HTMLDivElement → HTMLElement → Element → …` ).
- Writes `config/neutral_web_model.json` — the **single source of truth** for all
  reachable interface declarations.
- Emits `lib/src/types/html_interfaces.dart` and `lib/src/event_interfaces.dart` from
  the model.

### Step 2 — Build element IR for factory/adapter generation

```text
WebHostIrBuilder.create(...) → List<WebHostElementIR>
```

- Reads the Web IDL snapshot, overlay, and element allowlist.
- Resolves each allowlisted tag to its IDL interface name (e.g. `div` → `HTMLDivElement`).
- Validates that `package:web` exports the required interface (via `PackageWebResolver`).
- Collects inherited IDL attributes as `WebHostPropIR` props.
- Builds event specs from the overlay’s `events` map.

### Step 3 — Emit factories and adapter

```text
FactoryEmitter(elements) → elements.dart
AdapterEmitter(elements, interfaceModel) → browser_adapter.dart
```

- `FactoryEmitter` writes one factory function per element, plus `ReactEventProp` /
  `ReactRefProp` wrapper helpers and `ReactValueSpec` constants.
- `AdapterEmitter` writes `GeneratedElement`, event mixins/classes, JS wrapping helpers,
  and `registerBrowserAdapters()`.

---

## 4. Configuration files — what to edit and why

### `config/milestone_w1_elements.json`

**What it controls:** Which HTML tags get factories.

```json
{ "html": ["div", "span", "button", "input", "form", "label", "textarea", "select", "option", "a", "img"] }
```

**When to edit:** Adding support for a new HTML element (e.g. `<video>`).

**Manual steps required after edit:**
1. Add the tag to the `html` array.
2. Ensure `package:web` exports the corresponding extension type (e.g. `HTMLVideoElement`).
3. If the element needs custom React props not present in IDL, update
   `react_dom_overlay.json`.
4. Re-run the generator.

### `config/react_dom_overlay.json`

**What it controls:** React-specific mappings that do not exist in raw Web IDL.

```json
{
  "propertyRenames": { "class": "className", "for": "htmlFor", ... },
  "globalProps": ["id", "className", "title", "hidden", "tabIndex", "role"],
  "events": {
    "click": { "reactName": "onClick", "eventType": "ReactMouseEvent", "nativeType": "MouseEvent" },
    ...
  },
  "reactOnlyProps": ["children", "key", "ref", "dangerouslySetInnerHTML"]
}
```

- **`propertyRenames`** — maps IDL attribute names to their React/Dart prop names.
- **`globalProps`** — attributes that should be added to every element even if the IDL
  interface does not explicitly declare them.
- **`events`** — maps DOM event names (`click`, `input`, `change`, …) to their React
  synthetic event wrapper type and the underlying native `package:web` event type.
- **`reactOnlyProps`** — reserved names handled specially by the runtime (not emitted as
  HTML attributes).

**When to edit:**
- Adding a new event mapping (e.g. `scroll` → `ReactUIEvent`).
- Renaming a prop to match React conventions.
- Adding a global attribute that should appear on every element.

### `source/react_declarations.dart`

**What it controls:** The shape of React synthetic event interfaces.

This file defines `InterfaceDecl` objects for `ReactSyntheticEvent`, `ReactMouseEvent`,
`ReactKeyboardEvent`, etc. It is the **hand-authored contract** for what event members
should exist.

**When to edit:** Adding a new React event type (e.g. `ReactTransitionEvent`), or
changing the members of an existing event type (e.g. adding `nativeEvent`).

### `tool/web_idl/snapshots/web_apis.json`

**What it controls:** The raw Web IDL definitions.

This is a pinned JSON snapshot of browser specification data. It is **not** hand-edited
during normal development. To refresh it, use the snapshot acquisition tool in
`tool/web_idl/`.

**When to edit:** Only when upgrading the IDL baseline. Changing this file changes the
entire reachable type graph.

---

## 5. What gets updated manually vs. automatically

### Generated (do not edit directly)

| File | Generated by | Why |
|------|--------------|-----|
| `packages/react_web/lib/src/generated/elements.dart` | `FactoryEmitter` | Deterministic output from `WebHostElementIR`. |
| `packages/react_web/lib/src/generated/browser_adapter.dart` | `AdapterEmitter` | Deterministic output from `WebHostElementIR` + `neutral_web_model.json`. |
| `packages/react_web/lib/src/types/html_interfaces.dart` | `NeutralInterfaceEmitter` | Derived from `neutral_web_model.json`. |
| `packages/react_web/lib/src/event_interfaces.dart` | `NeutralInterfaceEmitter` | Derived from `neutral_web_model.json`. |
| `packages/react_web_generator/config/neutral_web_model.json` | `ModelJsonEmitter` | Derived from Web IDL snapshot + React declarations. |

### Hand-authored (edit these)

| File | Purpose |
|------|---------|
| `packages/react_web_generator/config/milestone_w1_elements.json` | Element allowlist. |
| `packages/react_web_generator/config/react_dom_overlay.json` | Event/property renames/overrides. |
| `packages/react_web_generator/lib/src/source/react_declarations.dart` | React event interface shapes. |
| `packages/react_web_generator/lib/src/adapter_emitter.dart` | Adapter code-generation logic. |
| `packages/react_web_generator/lib/src/factory_emitter.dart` | Factory code-generation logic. |
| `packages/react_web_generator/lib/src/ir_builder.dart` | IR construction, IDL-to-Dart type mapping, void-element logic. |
| `packages/react_web_generator/lib/src/resolver.dart` | `package:web` symbol indexing. |
| `packages/react_web_generator/lib/src/normalize/model_builder.dart` | Reachability, type graph construction. |
| `packages/react_web/lib/react_web.dart` | Barrel export; currently hides `Text` and element interface names to avoid collisions with `package:react`. |

---

## 6. How to extend the generator

### 6.1 Add a new HTML element

1. Add the tag name to `config/milestone_w1_elements.json` under `"html"`.
2. Confirm `package:web` exports the corresponding extension type (e.g. `HTMLVideoElement`).
   The generator will throw a `StateError` at build time if it does not.
3. Run `dart run tool/web_idl/generate_factories.dart`.
4. The new factory function (e.g. `video(...)`) and `GeneratedElement` adapter entries
   are produced automatically.

### 6.2 Add a new event type

1. Add the DOM event entry to `config/react_dom_overlay.json` under `"events"`, e.g.:

   ```json
   "scroll": { "reactName": "onScroll", "eventType": "ReactUIEvent", "nativeType": "UIEvent" }
   ```

2. If `ReactUIEvent` does not yet exist in the neutral model, add an `InterfaceDecl`
   for it in `lib/src/source/react_declarations.dart` with the desired members.
3. Run the generator.
4. The factory will now emit `onScroll` and `onScrollCapture` callbacks typed as
   `void Function(ReactUIEvent)?`. The browser adapter will emit
   `GeneratedReactUIEvent<T>` with the correct JS interop reads.

### 6.3 Add a new global property

Add the attribute name to `"globalProps"` in `config/react_dom_overlay.json`. It will
be appended to every element factory with type `String?`.

### 6.4 Rename an IDL property to a React prop

Add a mapping to `"propertyRenames"` in `config/react_dom_overlay.json`. The current
mapping is:

```json
{ "class": "className", "for": "htmlFor", "tabindex": "tabIndex", ... }
```

### 6.5 Add a new event interface member

Edit the relevant `InterfaceDecl` in `lib/src/source/react_declarations.dart` and add
an `AttributeDecl` or `OperationDecl`. The generator will include it in both the
neutral interface file and the browser adapter mixin.

### 6.6 Change adapter emission logic

Edit `lib/src/adapter_emitter.dart`. Common changes:
- Add a new `_jsReadExpr` case for a new primitive type.
- Change how `GeneratedElement` implements element types (currently only `EventTarget`).
- Modify `_wrapEventByType` dispatch logic.

### 6.7 Change factory emission logic

Edit `lib/src/factory_emitter.dart`.

---

## 7. Key concepts and types

### NeutralWebModel

The central data structure produced by `ModelBuilder`. Contains:

- `types: Map<String, InterfaceDecl>` — all reachable Web IDL and React event
  interfaces keyed by typeId (`web.HTMLDivElement`, `react.ReactMouseEvent`, etc.).
- `elements: Map<String, ElementDecl>` — element declarations keyed by tag name
  (`div`, `button`, …).
- `sources` — provenance metadata (e.g. path to the Web IDL snapshot).

### InterfaceDecl

Represents a Web IDL or React interface:

- `typeId` — fully qualified ID (`web.HTMLDivElement`).
- `name` — short Dart name (`HTMLDivElement`).
- `typeParameters` — generic parameters (used by event interfaces, e.g. `<T extends EventTarget>`).
- `extends_` — inheritance chain (`HTMLElement`, `Element`).
- `members` — `AttributeDecl` and `OperationDecl`.
- `browserBinding` — mapping to `package:web` (`library: 'package:web/web.dart'`, `symbol: 'HTMLDivElement'`).

### WebHostElementIR

The offline-friendly IR consumed by emitters:

- `tagName` — `"div"`.
- `factoryName` — `"div"` (camel-cased tag).
- `elementType` — `WebDartType(symbol: 'HTMLDivElement', import: 'package:web/web.dart')`.
- `voidElement` — `true` for `img`, `input`.
- `props` — list of `WebHostPropIR`.
- `events` — list of `WebEventPropIR`.

### WebDartType

A resolved Dart type reference used in generated code:

- `symbol` — e.g. `'HTMLDivElement?'`, `'ReactMouseEvent<T>'`.
- `import` — the Dart library URI where the symbol is declared.
- `nullable` / `typeArguments` — generic information.

### ReactCodecRegistry

The runtime registry (in `react_js`) that maps `(namespace, typeId)` pairs to
encoder/decoder functions. The generated `registerBrowserAdapters()` function calls
`ReactCodecRegistry.registerHostValue(...)` for every element type and event type so
that the JS renderer can serialize/deserialize DOM nodes and events across the
Dart–JS interop boundary.

---

## 8. Generated interface files — usage and caveats

### `html_interfaces.dart`

Contains abstract interfaces for every reachable Web IDL type. These are used as:

- **Factory return types** — not directly; factories return `ReactNode`.
- **Ref callback types** — e.g. `void Function(HTMLDivElement?)? ref`.
- **Event `currentTarget` types** — e.g. `ReactSyntheticEvent<T extends EventTarget>`.
- **Adapter implementation targets** — `GeneratedElement` currently implements only
  `EventTarget` (not the full `HTMLDivElement` interface) to avoid inheriting 300+
  abstract methods from `package:web`.

**Important:** The barrel export in `packages/react_web/lib/react_web.dart` currently
hides `Text` and all element interface names (`HTMLDivElement`, `HTMLSpanElement`, etc.)
from `html_interfaces.dart` because `package:react` already exports a `Text` widget.
If you add new element interface classes, verify they do not collide with `package:react`
exports.

### `event_interfaces.dart`

Contains parameterized event interfaces:

```dart
abstract interface class ReactSyntheticEvent<T extends EventTarget> {
  T get currentTarget;
  EventTarget get target;
  ...
}

abstract interface class ReactMouseEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> { ... }
```

These are referenced by:
- `elements.dart` factory signatures.
- `browser_adapter.dart` adapter classes.
- Application code that types event handlers.

---

## 9. Running the generator in practice

```bash
# From the workspace root
cd /run/media/kingwill101/disk2/code/code/dart_packages/react_workspace
dart run tool/web_idl/generate_factories.dart
```

Expected output:

```text
Generated neutral web model → packages/react_web_generator/config/neutral_web_model.json
  Types: 60
  Elements: 11
Generated interface files → packages/react_web/src/
  - types/html_interfaces.dart
  - event_interfaces.dart
Generated 11 element factories → packages/react_web/lib/src/generated/elements.dart
Generated browser adapter → packages/react_web/lib/src/generated/browser_adapter.dart
```

After generation, run analysis to verify:

```bash
dart analyze packages/
```

Tests for the generator itself:

```bash
cd packages/react_web_generator && dart test
cd packages/react_web && dart test   # if any tests exist
```

---

## 10. Troubleshooting

### `IDL interface "XYZ" not found for element "foo"`

The allowlist references a tag whose IDL interface is not present in the Web IDL
snapshot. Either the snapshot is stale, or the interface was renamed.

### `package:web does not export "XYZ" required by element "foo"`

The resolver could not find the extension type in the installed `package:web`. Upgrade
`web` in the workspace `pubspec.yaml` or remove the element from the allowlist.

### `ambiguous_export: Text`

`package:react` exports a `Text` widget, and `html_interfaces.dart` also exports a
`Text` interface. The barrel export in `react_web.dart` hides the conflicting names.
If you add new generated types, check for name collisions and update the `hide` list
in the barrel export.

### `non_abstract_class_inherits_abstract_member` in `GeneratedElement`

This happens when `GeneratedElement` implements an interface with many abstract
members (e.g. full `HTMLDivElement`) but the adapter emitter only implements a subset.
The current design avoids this by having `GeneratedElement` implement only `EventTarget`.

### Events not appearing in factories

Check that the DOM event name is listed in `config/react_dom_overlay.json` under
`"events"` and that the corresponding React event type is declared in
`lib/src/source/react_declarations.dart`.

---

## 11. Design decisions

### 11.1 Single source of truth: `neutral_web_model.json`

All generated outputs derive from one file: `config/neutral_web_model.json`. It is
**never hand-edited**. It is rewritten by `ModelJsonEmitter` every time the generator
runs. Adding an element or exposing a new IDL member may expand the type graph, but it
must never require manually adding another Dart interface or auxiliary stub.

### 11.2 Structured `TypeRef` AST, not strings

Types in the model are represented as structured JSON (e.g. `{"kind":"named","typeId":"web.String","nullable":true,"arguments":[]}`)
rather than unparsed Dart strings like `"String?"` or `"T extends EventTarget"`.
This lets every emitter resolve types independently without fragile string parsing.

### 11.3 Reachability, not manual allowlisting of auxiliary types

Every type referenced by the public surface (parent interfaces, return types, parameters,
generic bounds, union options) is discovered automatically by a reachability pass from
the configured root element names and React event interfaces.

The generator fails if the closure contains an unresolved type:

```text
Unresolved neutral type: HTMLInputElement.files → FileList
Source: Web IDL HTMLInputElement.files
Add a mapping policy or update the source snapshot.
```

It should never silently require someone to add `abstract interface class FileList {}` by hand.

### 11.4 Exposure policies

Not every reachable Web API needs its complete surface generated immediately. Each
reachable declaration receives a policy:

| Policy   | Behavior |
|----------|----------|
| `full`   | Generate all members recursively. |
| `opaque` | Generate only a marker interface (`abstract interface class ShadowRoot {}`). The browser adapter can still hold the underlying `web.ShadowRoot`, but shared code cannot inspect unsupported members. |
| `excluded` | Drop any member that exposes this type, with a generator diagnostic. |
| `mapped` | Map it to a known neutral/core type (e.g. `TrustedHTML` → `TrustedHtml`). |

The policy file (`react_dom_overlay.json` or a dedicated `typePolicies` map) remains
small and intentional. It does not duplicate Web IDL inheritance and members.

### 11.5 Browser adapters per interface, not one monolith

`GeneratedElement` currently implements only `EventTarget` (3 methods), not the full
`HTMLDivElement` interface with 300+ inherited abstract members. This avoids
`non_abstract_class_inherits_abstract_member` errors and keeps the adapter minimal.

Event wrappers are generated per event type (`GeneratedReactMouseEvent<T>`,
`GeneratedReactKeyboardEvent<T>`, …). The host-value registry registers exact neutral
type IDs (e.g. `web.HTMLDivElement`, `react.ReactMouseEvent<EventTarget>`).

### 11.6 SSR generation policy

SSR does **not** construct concrete DOM or event objects (`HTMLDivElement`, `MouseEvent`,
`FileList`). The shared interfaces exist so component source compiles:

```dart
div(
  onClick: (event) {
    event.currentTarget.focus();
  },
);
```

During SSR, `onClick` and `ref` are omitted. The server never invokes the callback and
never needs an `HTMLDivElement` instance.

SSR should generate **renderer metadata and prop lowering** from the same model:

- host element metadata
- prop filtering
- attribute/property names
- boolean behavior
- void-element behavior
- `dangerouslySetInnerHTML` handling

If a future native renderer needs real server-side DOM handles, add another target
emitter from the same model. Do not force that requirement into the current SSR
architecture.

### 11.7 React-specific data comes from React declarations

Web IDL knows about browser interfaces, but it does not define:

- `SyntheticEvent` / `currentTarget`
- React event handler names (`onClickCapture`)
- `dangerouslySetInnerHTML`
- JSX intrinsic element mappings
- React ref shapes

That information comes from hand-authored React declarations (`source/react_declarations.dart`)
and the overlay file (`react_dom_overlay.json`). These should be pinned just like the
Web IDL snapshot.

### 11.8 Generics are modeled explicitly

Type parameters are encoded as structured declarations with bounds, not as unparsed
strings:

```json
{
  "typeParameters": [
    {
      "name": "T",
      "bound": { "kind": "named", "typeId": "web.EventTarget", "nullable": false, "arguments": [] }
    }
  ]
}
```

Type parameter references in members use `{"kind":"typeParameter","name":"T","nullable":false}`.
Generic instantiations in `extends` use `{"kind":"named","typeId":"react.ReactSyntheticEvent","arguments":[{"kind":"typeParameter","name":"T",...}]}`.

---

## 12. File inventory

```
packages/react_web_generator/
├── config/
│   ├── milestone_w1_elements.json      # Element allowlist
│   ├── react_dom_overlay.json          # Event/property renames/overrides
│   ├── neutral_interfaces.json         # Deprecated legacy interface model
│   └── neutral_web_model.json          # Generated single source of truth (reachable types)
├── lib/
│   ├── react_web_generator.dart        # Barrel export
│   └── src/
│       ├── adapter_emitter.dart        # Emits browser_adapter.dart
│       ├── factory_emitter.dart        # Emits elements.dart
│       ├── ir_builder.dart             # Builds WebHostElementIR from IDL + overlay
│       ├── resolver.dart               # Indexes package:web extension types
│       ├── web_dart_type.dart          # WebDartType IR node
│       ├── web_host_ir.dart            # WebHostElementIR / WebHostPropIR / WebEventPropIR
│       ├── emit/
│       │   ├── model_json_emitter.dart # Writes neutral_web_model.json
│       │   ├── neutral_interface_emitter.dart # Emits html_interfaces.dart + event_interfaces.dart
│       │   └── type_ref_resolver.dart  # Resolves TypeRef to Dart type strings
│       ├── model/
│       │   ├── model.dart              # NeutralWebModel, ElementDecl
│       │   ├── element_decl.dart       # ElementDecl, PropDecl, EventDecl
│       │   ├── member_decl.dart        # AttributeDecl, OperationDecl, ParameterDecl
│       │   ├── neutral_web_model.dart  # NeutralWebModel + JSON (de)serialization
│       │   ├── type_decl.dart          # InterfaceDecl, TypeParameterDecl, BrowserBinding
│       │   └── type_ref.dart           # NamedTypeRef, TypeParameterRef, UnionTypeRef
│       ├── normalize/
│       │   ├── model_builder.dart      # Builds NeutralWebModel from IDL + React declarations
│       │   └── reachability.dart       # Graph traversal for reachable types
│       └── source/
│           ├── react_declarations.dart # Hand-authored React synthetic event interfaces
│           └── web_idl_loader.dart     # Loads Web IDL snapshot into InterfaceDecl registry
└── test/
    └── factory_emitter_test.dart       # FactoryEmitter unit tests

tool/web_idl/
└── generate_factories.dart             # Top-level generation entry point
```
