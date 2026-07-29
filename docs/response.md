The agent has identified the correct problem. The solution is **not to expand `neutral_interfaces.json` manually**. Instead, generate a complete neutral type graph from Web IDL plus React type information, then let every emitter consume that graph.

## Recommended decision

```text
Web IDL snapshot
        +
React declarations / overlay
        +
root element allowlist
        ↓
Neutral model builder
        ↓
neutral_web_model.json   ← generated, never edited
        ↓
 ┌────────────┬────────────────┬────────────────┬───────────────┐
 │            │                │                │
interfaces   factories     browser adapter    SSR metadata
html.dart    elements.dart browser_adapter    ssr_schema.dart
events.dart
```

The “single source of truth” should be the generated `neutral_web_model.json`, **not a manually maintained interface list**.

At `c72c23d`, the duplication is visible:

* `neutral_interfaces.json` contains a small manually selected interface graph.
* `html.dart` then adds more handwritten auxiliary stubs such as `NamedNodeMap`, `ShadowRoot`, `Document`, `FileList`, and `HTMLDataListElement`.
* `currentTarget`, `target`, and `relatedTarget` are absent from the source model but hardcoded into generated/handwritten output.

That is precisely the manual loop you need to remove.

# 1. Replace string types with a structured type model

Do not represent types as:

```json
{
  "returnType": "String?"
}
```

or:

```json
{
  "typeArg": "T extends WebEventTarget"
}
```

Those are strings that every emitter must parse and reinterpret.

Use a `TypeRef` AST:

```json
{
  "kind": "named",
  "typeId": "web.String",
  "nullable": true,
  "arguments": []
}
```

Generic parameter reference:

```json
{
  "kind": "typeParameter",
  "name": "T",
  "nullable": false
}
```

Generic interface instantiation:

```json
{
  "kind": "named",
  "typeId": "react.ReactSyntheticEvent",
  "nullable": false,
  "arguments": [
    {
      "kind": "typeParameter",
      "name": "T",
      "nullable": false
    }
  ]
}
```

Union:

```json
{
  "kind": "union",
  "nullable": true,
  "options": [
    {
      "kind": "named",
      "typeId": "web.Element",
      "nullable": false,
      "arguments": []
    },
    {
      "kind": "named",
      "typeId": "web.Document",
      "nullable": false,
      "arguments": []
    }
  ]
}
```

Other useful variants:

```text
primitive
named
typeParameter
union
list
record
function
future
opaque
```

Use IDs such as:

```text
web.EventTarget
web.HTMLDivElement
web.FileList
react.SyntheticEvent
react.MouseEvent
core.String
core.int
```

The Dart spelling is an emitter decision, not the identity of the type.

# 2. One central type registry, generated automatically

Every type referenced by the public surface must be present in the model, including auxiliary types.

But that does **not** mean manually listing every auxiliary type.

Use a reachability pass:

```text
Roots
  HTML elements selected for generation
  React event interfaces
  React ref types
      ↓
Traverse
  parent interfaces
  member return types
  member parameters
  generic bounds
  generic arguments
  dictionary fields
  aliases
  unions
      ↓
Closed type graph
```

For example:

```text
HTMLInputElement
   ├── HTMLElement
   ├── FileList
   ├── HTMLDataListElement
   ├── ValidityState
   └── SelectionDirection
```

The model builder discovers those automatically from Web IDL and adds them to the generated registry.

The generator should fail if the closure contains an unresolved type:

```text
Unresolved neutral type:
  HTMLInputElement.files → FileList

Source:
  Web IDL HTMLInputElement.files

Add a mapping policy or update the source snapshot.
```

It should never silently require someone to add:

```dart
abstract interface class FileList {}
```

by hand.

# 3. Explicit exposure policies

Not every reachable Web API needs its complete surface generated immediately.

Each reachable declaration should receive one of these policies:

```text
full
opaque
excluded
mapped
```

Example overlay:

```yaml
typePolicies:
  FileList:
    exposure: full

  ShadowRoot:
    exposure: opaque

  NamedNodeMap:
    exposure: opaque

  Document:
    exposure: opaque

  TrustedHTML:
    exposure: mapped
    dartType: TrustedHtml
```

Meaning:

### `full`

Generate its members recursively:

```dart
abstract interface class FileList {
  int get length;

  WebFile? item(int index);
}
```

### `opaque`

Generate only a marker interface:

```dart
abstract interface class ShadowRoot {}
```

The browser adapter can still hold the underlying `web.ShadowRoot`, but shared code cannot inspect unsupported members.

### `excluded`

Drop any member that exposes this type, with a generator diagnostic.

### `mapped`

Map it to a known neutral/core type.

This policy file remains small and intentional. It does not duplicate Web IDL.

# 4. Suggested canonical model

```json
{
  "schemaVersion": 1,
  "sources": {
    "webIdlRevision": "...",
    "reactTypesVersion": "...",
    "packageWebVersion": "..."
  },
  "types": {
    "web.WebEventTarget": {
      "kind": "interface",
      "name": "WebEventTarget",
      "sourceName": "EventTarget",
      "typeParameters": [],
      "extends": [],
      "members": [],
      "exposure": "full",
      "browserBinding": {
        "library": "package:web/web.dart",
        "symbol": "EventTarget"
      }
    },
    "web.HTMLDivElement": {
      "kind": "interface",
      "name": "HTMLDivElement",
      "sourceName": "HTMLDivElement",
      "typeParameters": [],
      "extends": [
        {
          "kind": "named",
          "typeId": "web.HTMLElement",
          "nullable": false,
          "arguments": []
        }
      ],
      "members": [],
      "exposure": "full",
      "browserBinding": {
        "library": "package:web/web.dart",
        "symbol": "HTMLDivElement"
      }
    },
    "react.ReactSyntheticEvent": {
      "kind": "interface",
      "name": "ReactSyntheticEvent",
      "typeParameters": [
        {
          "name": "T",
          "bound": {
            "kind": "named",
            "typeId": "web.WebEventTarget",
            "nullable": false,
            "arguments": []
          }
        }
      ],
      "extends": [],
      "members": [
        {
          "name": "currentTarget",
          "kind": "attribute",
          "readable": true,
          "writable": false,
          "type": {
            "kind": "typeParameter",
            "name": "T",
            "nullable": false
          }
        },
        {
          "name": "target",
          "kind": "attribute",
          "readable": true,
          "writable": false,
          "type": {
            "kind": "named",
            "typeId": "web.WebEventTarget",
            "nullable": false,
            "arguments": []
          }
        }
      ]
    }
  },
  "elements": {
    "div": {
      "namespace": "html",
      "elementType": {
        "kind": "named",
        "typeId": "web.HTMLDivElement",
        "nullable": false,
        "arguments": []
      },
      "voidElement": false,
      "props": [],
      "events": []
    }
  }
}
```

All emitters consume this model and nothing else.

# 5. React-specific data should come from React declarations

Web IDL knows about browser interfaces, but it does not define:

```text
SyntheticEvent
currentTarget
React event handler names
onClickCapture
dangerouslySetInnerHTML
JSX intrinsic element mappings
React ref shapes
```

The best fully data-driven source for that information is the React TypeScript declarations, optionally supplemented by a small override file.

The current React declarations define `nativeEvent`, `currentTarget`, `target`, propagation methods, timestamps and related event fields in `BaseSyntheticEvent` and `SyntheticEvent`.  They also define `DOMAttributes<T>` with event handlers and capture variants.  The `JSX.IntrinsicElements` interface maps each tag to its React attribute interface and DOM element type. 

That gives you:

```text
Web IDL
    authoritative browser interfaces

React .d.ts
    authoritative React props/events/intrinsic mappings

small overlay
    Dart naming and unsupported-feature policies
```

You should pin the React declarations just as you pin the Web IDL snapshot.

Do not directly emit Dart from the TypeScript file. Parse it into your neutral model first.

The Dart `web` repository’s generator already follows this general compiler pattern: parse declarations, transform them into an intermediate representation, then generate target code.  Its `js_interop_gen` tooling supports both TypeScript declarations and Web IDL. ([GitHub][1])

# 6. Generic type parameters

Yes, encode `T` directly in the model, but as a structured type parameter—not a string.

Declaration:

```json
{
  "typeParameters": [
    {
      "name": "T",
      "bound": {
        "kind": "named",
        "typeId": "web.WebEventTarget",
        "nullable": false,
        "arguments": []
      }
    }
  ]
}
```

Member:

```json
{
  "name": "currentTarget",
  "kind": "attribute",
  "readable": true,
  "writable": false,
  "type": {
    "kind": "typeParameter",
    "name": "T",
    "nullable": false
  }
}
```

Inheritance:

```json
{
  "extends": [
    {
      "kind": "named",
      "typeId": "react.ReactSyntheticEvent",
      "nullable": false,
      "arguments": [
        {
          "kind": "typeParameter",
          "name": "T",
          "nullable": false
        }
      ]
    }
  ]
}
```

Generated Dart:

```dart
abstract interface class ReactSyntheticEvent<
  T extends WebEventTarget
> {
  T get currentTarget;

  WebEventTarget get target;
}
```

You will also encounter TypeScript intersections such as:

```ts
EventTarget & T
```

Dart does not have a direct intersection type syntax. Normalize it during lowering:

```text
EventTarget & T
where T extends EventTarget
    ↓
T
```

Other intersections can use an explicit policy:

```text
preserve as composite interface
select dominant type
map to Object
reject
```

# 7. Member modeling

Avoid the current:

```json
{
  "kind": "getter",
  "returnType": "String?"
}
```

Use:

```json
{
  "name": "value",
  "kind": "attribute",
  "readable": true,
  "writable": true,
  "type": {
    "kind": "named",
    "typeId": "core.String",
    "nullable": false,
    "arguments": []
  }
}
```

Method:

```json
{
  "name": "item",
  "kind": "operation",
  "parameters": [
    {
      "name": "index",
      "required": true,
      "type": {
        "kind": "named",
        "typeId": "core.int",
        "nullable": false,
        "arguments": []
      }
    }
  ],
  "returnType": {
    "kind": "named",
    "typeId": "web.WebFile",
    "nullable": true,
    "arguments": []
  }
}
```

This handles setters, method arguments and overloads without special-case strings.

# 8. Browser adapter generation

Generate one adapter per neutral interface hierarchy, not one object implementing every HTML interface.

The current emitter generates:

```dart
final class GeneratedElement implements
    HTMLDivElement,
    HTMLSpanElement,
    HTMLButtonElement,
    HTMLInputElement,
    // ...
```

because it combines every encountered element interface into one class.

That means a wrapped `<div>` also statically claims to be an `HTMLInputElement` and `HTMLFormElement`.

Prefer:

```dart
class BrowserWebEventTarget
    implements WebEventTarget {
  final JSObject handle;

  BrowserWebEventTarget(this.handle);
}

class BrowserWebNode
    extends BrowserWebEventTarget
    implements WebNode {
  BrowserWebNode(super.handle);
}

class BrowserWebElement
    extends BrowserWebNode
    implements WebElement {
  BrowserWebElement(super.handle);

  @override
  String? get id {
    // Generated package:web bridge.
  }
}

class BrowserHTMLElement
    extends BrowserWebElement
    implements HTMLElement {
  BrowserHTMLElement(super.handle);
}

final class BrowserHTMLDivElement
    extends BrowserHTMLElement
    implements HTMLDivElement {
  BrowserHTMLDivElement(super.handle);
}
```

The generated host-value registry maps the exact neutral type ID:

```dart
registerHostValue(
  namespace: 'web',
  typeId: 'web.HTMLDivElement',
  decoder: (value) =>
      BrowserHTMLDivElement(
    value as JSObject,
  ),
);
```

The callback metadata already tells the decoder which type is expected. It should not inspect a tag and guess a broad wrapper.

Likewise, event decoding should be driven by the callback specification:

```text
react.ReactMouseEvent<web.HTMLDivElement>
```

not by comparing the JavaScript event’s `type` string with names such as `ReactMouseEvent`.

The current emitter switches on the JS event’s `.type` but generates cases from neutral event class names, which will not match real values such as `"click"` or `"keydown"`.

# 9. SSR generation

Do **not** generate fake concrete SSR implementations of:

```text
HTMLDivElement
MouseEvent
FileList
Document
```

SSR does not construct those values.

The shared interfaces exist so component source can compile:

```dart
div(
  onClick: (event) {
    event.currentTarget.focus();
  },
);
```

During SSR:

```text
onClick → omitted
ref     → omitted
```

The server never invokes the callback and never needs an `HTMLDivElement` instance.

Generate SSR behavior from the same model:

```dart
const divSsrDefinition = WebElementSsrDefinition(
  tagName: 'div',
  voidElement: false,
  props: {
    'id': WebPropSsrBehavior.attribute,
    'hidden':
        WebPropSsrBehavior.booleanAttribute,
    'className':
        WebPropSsrBehavior.reactProperty,
    'onClick':
        WebPropSsrBehavior.omitEvent,
    'ref':
        WebPropSsrBehavior.omitRef,
  },
);
```

Your existing IR already includes `WebSsrBehavior`, `clientOnly`, and per-property SSR behavior.  The builder also already assigns primitive SSR behaviors.

Therefore the SSR emitter should generate:

```text
host element metadata
prop filtering
attribute/property names
boolean behavior
void-element behavior
style handling
dangerouslySetInnerHTML handling
```

It should not implement neutral DOM interfaces.

If a future native renderer needs real server-side DOM handles, add another target emitter from the same model then. Do not force that requirement into the current SSR architecture.

# Direct answers

## 1. All referenced types or separate registry?

Use **one type registry inside the generated canonical model**.

Every referenced type must exist in that graph, but types are discovered automatically through reachability.

Do not maintain a separate manual auxiliary registry.

A small policy file may say:

```yaml
ShadowRoot: opaque
Document: opaque
FileList: full
```

but it should not redeclare their inheritance and members.

## 2. How should generics be modeled?

Use explicit type-parameter declarations and `typeParameter` references.

Do not encode:

```json
"typeArg": "T extends WebEventTarget"
```

or:

```json
"returnType": "T"
```

as unparsed strings.

## 3. Should SSR implementations be generated?

Generate the SSR **renderer metadata and prop lowering** from the same model.

Do not manually implement neutral interfaces in the SSR package, and do not generate concrete DOM/event objects that SSR never creates.

## 4. Is there a known pattern?

Yes:

```text
source frontends
    ↓
semantic type graph
    ↓
normalization and validation
    ↓
reachability closure
    ↓
target-independent IR
    ↓
multiple backend emitters
```

This is the standard compiler/IDL-generator architecture used by systems such as Web IDL generators, protocol compilers and API binding generators. The interface declarations and each target implementation are separate emitters over one normalized semantic model.

# Proposed files

```text
packages/react_web_generator/
├── config/
│   ├── roots.yaml
│   ├── overrides.yaml
│   └── source_versions.json
│
├── lib/src/
│   ├── source/
│   │   ├── web_idl_loader.dart
│   │   ├── react_types_loader.dart
│   │   └── package_web_loader.dart
│   │
│   ├── model/
│   │   ├── neutral_web_model.dart
│   │   ├── type_decl.dart
│   │   ├── type_ref.dart
│   │   ├── member_decl.dart
│   │   └── element_decl.dart
│   │
│   ├── normalize/
│   │   ├── type_normalizer.dart
│   │   ├── intersection_lowerer.dart
│   │   ├── reachability.dart
│   │   └── validator.dart
│   │
│   └── emit/
│       ├── neutral_interface_emitter.dart
│       ├── factory_emitter.dart
│       ├── browser_adapter_emitter.dart
│       ├── ssr_metadata_emitter.dart
│       └── model_json_emitter.dart
```

Generated outputs:

```text
packages/react_web/lib/src/generated/
├── html_interfaces.dart
├── event_interfaces.dart
├── elements.dart
├── browser_adapter.dart
├── browser_registry.dart
└── ssr_metadata.dart
```

# Next implementation sequence

1. Add the structured `TypeRef` and `TypeDecl` model.
2. Convert Web IDL declarations into that model.
3. Add React event and intrinsic inputs—preferably parsed from pinned React declarations.
4. Compute the transitive reachable-type closure.
5. Add explicit `full`, `opaque`, `mapped`, and `excluded` policies.
6. Generate `html_interfaces.dart` and `event_interfaces.dart`.
7. Delete handwritten `html.dart` and `events.dart`.
8. Generate per-interface browser adapters.
9. Generate SSR metadata from the same model.
10. Make one command produce all outputs:

```bash
dart run react_web_generator:generate
```

11. Add CI:

```bash
dart run react_web_generator:generate
dart format packages/react_web/lib/src/generated
git diff --exit-code
```

The success condition is simple:

> Adding an element or exposing a new IDL member may expand the generated type graph, but it must never require manually adding another Dart interface or auxiliary stub.

[1]: https://github.com/dart-lang/web?utm_source=chatgpt.com "GitHub - dart-lang/web: Lightweight browser API bindings built around JS static interop. · GitHub"
