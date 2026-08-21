# Milestone W1: Generated Web Host API with SSR Built In

## Goal

Replace the handwritten web element surface—currently `div()` and `button()`—with a generated, typed web host API sourced from Web IDL and aligned with `package:web`.

The milestone is complete only when the same generated definitions support:

```text
Browser rendering
Browser hydration
Node-based SSR
Typed package:web events and refs
```

SSR is part of the generator model and acceptance tests from the beginning. It is not a follow-up feature.

Artisanal is **not part of this milestone**. The only Artisanal-related requirement is that no decision pollutes `package:react` with browser-specific types or assumptions.

---

# 1. Architectural boundaries

## `package:react`

Renderer-neutral core:

```text
ReactNode
Component
ComponentId
Fragment
Text
Empty
hooks API
callback descriptors
runtime contracts
host-node abstraction
```

It must not import:

```text
package:web
dart:js_interop
react_js
react_dom
react_server
```

## `package:react_web`

New shared web host package:

```text
generated HTML element factories
generated SVG element factories later
React web event types
package:web-compatible refs
web host metadata
client/SSR prop behavior
```

Dependencies:

```yaml
dependencies:
  react:
    path: ../react
  web: <pinned-compatible-version>
```

## `package:react_web_generator`

New development-only generator:

```text
Web IDL snapshot reader
package:web symbol resolver
React DOM overlay
web host semantic model
HTML factory emitter
SSR metadata emitter
golden tests
```

It should not be required by applications at runtime.

## Existing web runtime packages

```text
react_js
    React JS bridge, callback trampoline, value conversion

react_dom
    createRoot, hydrateRoot, browser mounting

react_server
    ReactDOMServer integration, server registry, SSR rendering
```

Both `react_dom` and `react_server` consume the same `react_web` host definitions.

---

# 2. Renderer-neutral host nodes

The current `Intrinsic` model contains a web-style `tag` string.

Before generating hundreds of host factories, generalize it slightly:

```dart
final class HostType<P extends Object?> {
  final String namespace;
  final String name;

  const HostType(
    this.namespace,
    this.name,
  );

  @override
  String toString() => '$namespace:$name';
}

final class HostNode<P extends Object?>
    extends ReactNode {
  final HostType<P> type;
  final P props;
  final List<ReactNode> children;
  final String? key;

  const HostNode(
    this.type,
    this.props, {
    this.children = const [],
    this.key,
  });
}
```

Web-generated host types become:

```dart
const divHost = HostType<DivProps>(
  'web',
  'div',
);

const buttonHost = HostType<ButtonProps>(
  'web',
  'button',
);
```

No alternate renderer is implemented now. The namespace merely prevents the core from assuming every host node is HTML.

The existing `Intrinsic` can temporarily remain as a compatibility wrapper:

```dart
@Deprecated('Use a generated host factory.')
final class Intrinsic extends HostNode<
    Map<String, Object?>> {
  Intrinsic(
    String tag, {
    Map<String, Object?> props = const {},
    List<ReactNode> children = const [],
    String? key,
  }) : super(
          HostType('web', tag),
          props,
          children: children,
          key: key,
        );
}
```

---

# 3. SSR-aware runtime scope

The current runtime stores a process-global binding and renderer:

```dart
static late ReactBinding binding;
static late ReactRenderer renderer;
```

That must be replaced before treating SSR as production-capable. Concurrent SSR requests should not rely on mutable global initialization.

Use a scoped runtime:

```dart
import 'dart:async';

enum ReactRenderTarget {
  browser,
  server,
  test,
}

final class ReactRuntimeCapabilities {
  final bool supportsEvents;
  final bool supportsRefs;
  final bool supportsEffects;

  const ReactRuntimeCapabilities({
    required this.supportsEvents,
    required this.supportsRefs,
    required this.supportsEffects,
  });

  static const browser =
      ReactRuntimeCapabilities(
    supportsEvents: true,
    supportsRefs: true,
    supportsEffects: true,
  );

  static const server =
      ReactRuntimeCapabilities(
    supportsEvents: false,
    supportsRefs: false,
    supportsEffects: false,
  );
}

final class ReactRuntime {
  final ReactRenderTarget target;
  final ReactRuntimeCapabilities capabilities;
  final ReactBinding binding;
  final ReactRenderer renderer;

  const ReactRuntime({
    required this.target,
    required this.capabilities,
    required this.binding,
    required this.renderer,
  });
}

final Object _reactRuntimeKey = Object();

ReactRuntime get currentReactRuntime {
  final runtime = Zone.current[_reactRuntimeKey];

  if (runtime is! ReactRuntime) {
    throw StateError(
      'No ReactRuntime is active.',
    );
  }

  return runtime;
}

T runWithReactRuntime<T>(
  ReactRuntime runtime,
  T Function() callback,
) {
  return runZoned(
    callback,
    zoneValues: {
      _reactRuntimeKey: runtime,
    },
  );
}
```

Hooks then use:

```dart
(T, void Function(T)) useState<T>(
  T initial,
) {
  return currentReactRuntime.binding
      .useState(initial);
}
```

This milestone must include a test that executes two SSR renders concurrently and verifies no props, state or renderer context leaks between them.

---

# 4. Upstream Web IDL source

The Dart web repository already has the pipeline needed to collect and normalize browser specifications.

Its generator uses:

* `@webref/idl`
* `@webref/elements`
* `@webref/css`
* `@mdn/browser-compat-data`
* `webidl2`

The update script:

1. Installs the Node dependencies.
2. Pre-parses the IDL sources into `web_apis.json`.
3. Passes that JSON and MDN compatibility data into `js_interop_gen`.
4. Generates the `package:web` DOM bindings.

`js_interop_gen` is the reusable underlying tool for generating Dart JS interop bindings from Web IDL and TypeScript declarations, although it is currently marked as work in progress.

## Integration decision

Do **not** import private classes from:

```text
web_generator/lib/src
js_interop_gen/lib/src
```

into production generator code.

Instead, consume stable artifacts:

```text
normalized web_apis.json
WebRef element data
MDN compatibility data
the installed package:web public API
```

This avoids tightly coupling the project to internal Dart generator implementation details.

---

# 5. Upstream acquisition instructions

The generated surface follows the exact published `package:web` version used
by `react_web` and `react_web_generator`. The current target is `web: 1.1.1`,
whose upstream source is the `web-v1.1.1` tag at commit
`222164b5010cb0324d4132666f1d43750ffc6448`.

The source of truth is `tool/web_idl/pin.json`. The matching Dart web checkout
is the tracked `third_party/web` submodule; do not create a second vendor clone.

```bash
git submodule update --init third_party/web
dart run tool/web_idl/update.dart
dart run tool/web_idl/generate_factories.dart
dart run tool/web_idl/verify.dart --strict
```

The update command validates the submodule commit and both exact `web`
dependencies before reading the upstream lockfile. The workspace-owned
`tool/web_idl/preparse.mjs` then normalizes the locked WebRef datasets into
`tool/web_idl/snapshots/web_apis.json` and records their versions in
`tool/web_idl/snapshots/provenance.json`.

See the [maintainer guide](../../.site/docs/maintainers/maintenance.mdx) for the
complete update, review, and validation checklist.

---

# 6. Direct upstream references

## Main repositories

* [Dart web repository](https://github.com/dart-lang/web)
* [Pinned Dart web revision](https://github.com/dart-lang/web/tree/222164b5010cb0324d4132666f1d43750ffc6448)
* [Web generator at the pinned revision](https://github.com/dart-lang/web/tree/222164b5010cb0324d4132666f1d43750ffc6448/web_generator)
* [`package:web` source at the pinned revision](https://github.com/dart-lang/web/tree/222164b5010cb0324d4132666f1d43750ffc6448/web)
* [`package:web` on pub.dev](https://pub.dev/packages/web)

The workspace normalizer intentionally owns the stable handoff from the
upstream locked datasets. It does not import Dart web's private generator
libraries.

## Source datasets

* [`@webref/idl`](https://www.npmjs.com/package/@webref/idl)
* [`@webref/elements`](https://www.npmjs.com/package/@webref/elements)
* [`@webref/css`](https://www.npmjs.com/package/@webref/css)
* [`@mdn/browser-compat-data`](https://www.npmjs.com/package/@mdn/browser-compat-data)
* [`webidl2`](https://www.npmjs.com/package/webidl2)

## React behavior references

Web IDL describes the browser platform, but React-specific names and event properties require an overlay:

* [React common DOM component props](https://react.dev/reference/react-dom/components/common)
* [React `<button>`](https://react.dev/reference/react-dom/components/button)
* [React `<input>`](https://react.dev/reference/react-dom/components/input)
* [React `<form>`](https://react.dev/reference/react-dom/components/form)
* [React DOM server APIs](https://react.dev/reference/react-dom/server)

---

# 7. Generator inputs

The generator should consume four input classes.

## A. Normalized Web IDL

```text
tool/web_idl/snapshots/web_apis.json
```

Used for:

```text
interface inheritance
attribute types
event interface types
nullability
element interface names
enums
dictionaries
```

## B. Installed `package:web`

Analyze the exact `package:web` version declared by `react_web_generator`.

The resolver maps:

```text
IDL HTMLButtonElement
→ package:web/web.dart#HTMLButtonElement

IDL MouseEvent
→ package:web/web.dart#MouseEvent

IDL EventTarget
→ package:web/web.dart#EventTarget
```

Do not duplicate Dart’s Web IDL-to-Dart naming decisions.

`package:web` generates browser interfaces as extension types over JS objects and preserves relationships such as `UIEvent implements Event`.

## C. React overlay

Create:

```text
packages/react_web_generator/config/react_dom_overlay.yaml
```

Example:

```yaml
propertyRenames:
  class: className
  for: htmlFor
  tabindex: tabIndex
  readonly: readOnly
  maxlength: maxLength
  accept-charset: acceptCharset

globalProps:
  - id
  - className
  - title
  - hidden
  - tabIndex
  - role

events:
  click:
    reactName: onClick
    eventType: ReactMouseEvent
    nativeType: MouseEvent

  input:
    reactName: onInput
    eventType: ReactInputEvent
    nativeType: InputEvent

  change:
    reactName: onChange
    eventType: ReactChangeEvent
    nativeType: Event

  submit:
    reactName: onSubmit
    eventType: ReactFormEvent
    nativeType: SubmitEvent

  keydown:
    reactName: onKeyDown
    eventType: ReactKeyboardEvent
    nativeType: KeyboardEvent

  focus:
    reactName: onFocus
    eventType: ReactFocusEvent
    nativeType: FocusEvent

reactOnlyProps:
  - children
  - key
  - ref
  - dangerouslySetInnerHTML
```

## D. Element factory roots

Create:

```text
packages/react_web_generator/config/roots.json
```

```json
{
  "voidElements": ["area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"],
  "elements": [
    {"tag": "div", "voidElement": false},
    {"tag": "span", "voidElement": false},
    {"tag": "button", "voidElement": false},
    {"tag": "input", "voidElement": true},
    {"tag": "form", "voidElement": false},
    {"tag": "label", "voidElement": false},
    {"tag": "textarea", "voidElement": false},
    {"tag": "select", "voidElement": false},
    {"tag": "option", "voidElement": true},
    {"tag": "a", "voidElement": false},
    {"tag": "img", "voidElement": true}
  ]
}
```

The roots config controls which tags get typed factory functions; the complete neutral
type surface itself is generated for every spec in the snapshot.

---

# 8. Web host intermediate representation

Create a renderer-specific IR in `react_web_generator`, not in `react`.

```dart
enum WebNamespace {
  html,
  svg,
  mathMl,
}

enum WebSsrBehavior {
  attribute,
  booleanAttribute,
  property,
  textContent,
  eventOmitted,
  refOmitted,
  special,
  unsupported,
}

final class WebDartType {
  final String symbol;
  final Uri import;
  final bool nullable;
  final List<WebDartType> typeArguments;

  const WebDartType({
    required this.symbol,
    required this.import,
    required this.nullable,
    this.typeArguments = const [],
  });
}

final class WebHostPropIR {
  final String idlName;
  final String dartName;
  final String reactName;
  final WebDartType dartType;
  final bool required;
  final bool clientOnly;
  final WebSsrBehavior ssrBehavior;

  const WebHostPropIR({
    required this.idlName,
    required this.dartName,
    required this.reactName,
    required this.dartType,
    required this.required,
    required this.clientOnly,
    required this.ssrBehavior,
  });
}

final class WebEventPropIR {
  final String domEventName;
  final String reactName;
  final String captureName;
  final WebDartType reactEventType;
  final WebDartType nativeEventType;

  const WebEventPropIR({
    required this.domEventName,
    required this.reactName,
    required this.captureName,
    required this.reactEventType,
    required this.nativeEventType,
  });
}

final class WebHostElementIR {
  final String tagName;
  final String factoryName;
  final WebNamespace namespace;
  final WebDartType elementType;
  final bool voidElement;
  final List<WebHostPropIR> props;
  final List<WebEventPropIR> events;

  const WebHostElementIR({
    required this.tagName,
    required this.factoryName,
    required this.namespace,
    required this.elementType,
    required this.voidElement,
    required this.props,
    required this.events,
  });
}
```

Every prop must have an explicit SSR behavior. Missing behavior is a generator error.

---

# 9. React event and `package:web` interoperability

Do not keep the current pure-Dart `SyntheticEvent` wrapper as the final web event API.

Generate React event extension types in `react_web`:

```dart
import 'dart:js_interop';

import 'package:web/web.dart' as web;

extension type ReactSyntheticEvent<
  T extends web.EventTarget
>._(JSObject value) implements JSObject {
  external T get currentTarget;

  external web.EventTarget get target;

  external web.Event get nativeEvent;

  external bool get bubbles;

  external bool get cancelable;

  external bool get defaultPrevented;

  external void preventDefault();

  external void stopPropagation();
}

extension type ReactMouseEvent<
  T extends web.EventTarget
>._(JSObject value)
    implements ReactSyntheticEvent<T>, JSObject {
  external web.MouseEvent get nativeEvent;

  external double get clientX;

  external double get clientY;

  external int get button;

  external bool get altKey;

  external bool get ctrlKey;

  external bool get metaKey;

  external bool get shiftKey;
}
```

Generated button signature:

```dart
ReactNode button({
  String? id,
  String? className,
  String? type,
  bool? disabled,
  void Function(
    ReactMouseEvent<
      web.HTMLButtonElement
    > event,
  )? onClick,
  void Function(
    ReactMouseEvent<
      web.HTMLButtonElement
    > event,
  )? onClickCapture,
  void Function(
    web.HTMLButtonElement? element,
  )? ref,
  List<ReactNode> children = const [],
  String? key,
});
```

Browser behavior:

```dart
button(
  ref: (element) {
    element?.focus();
  },
  onClick: (event) {
    event.preventDefault();

    final web.HTMLButtonElement button =
        event.currentTarget;

    final web.MouseEvent nativeEvent =
        event.nativeEvent;

    print(nativeEvent.clientX);
    button.focus();
  },
);
```

SSR behavior:

```text
id, className, type, disabled
→ passed to the server renderer

onClick, onClickCapture
→ omitted from server prop conversion

ref
→ omitted from server prop conversion
```

The Node SSR bundle can compile the types, but it must never attempt to create or inspect browser elements.

---

# 10. Generated host factory model

Use typed records for generated props.

```dart
typedef ButtonProps = ({
  String? id,
  String? className,
  String? type,
  bool? disabled,
  ReactCallback? onClick,
  ReactCallback? onClickCapture,
  ReactCallback? ref,
});
```

Generated host constant:

```dart
const buttonHostType =
    HostType<ButtonProps>(
  'web',
  'button',
);
```

Generated factory:

```dart
ReactNode button({
  String? id,
  String? className,
  String? type,
  bool? disabled,
  void Function(
    ReactMouseEvent<
      web.HTMLButtonElement
    > event,
  )? onClick,
  void Function(
    ReactMouseEvent<
      web.HTMLButtonElement
    > event,
  )? onClickCapture,
  void Function(
    web.HTMLButtonElement? element,
  )? ref,
  List<ReactNode> children = const [],
  String? key,
}) {
  return HostNode<ButtonProps>(
    buttonHostType,
    (
      id: id,
      className: className,
      type: type,
      disabled: disabled,
      onClick: onClick == null
          ? null
          : _buttonOnClick(onClick),
      onClickCapture:
          onClickCapture == null
              ? null
              : _buttonOnClickCapture(
                  onClickCapture,
                ),
      ref: ref == null
          ? null
          : _buttonRef(ref),
    ),
    children: children,
    key: key,
  );
}
```

---

# 11. Separate client and server prop lowering

Do not use one unqualified `toReactJS` path for web host props.

Introduce:

```dart
abstract interface class WebHostPropsEncoder {
  JSObject encodeHostProps(
    HostType<Object?> type,
    Object? props,
  );
}
```

## Browser encoder

Includes:

```text
attributes
properties
events
refs
```

## Server encoder

Includes:

```text
serializable attributes
boolean attributes
safe properties
special SSR props
```

Excludes:

```text
callbacks
events
refs
browser objects
```

The renderer chooses the encoder through the scoped `ReactRuntime`.

```dart
final class WebClientRuntime
    extends ReactRuntime {
  WebClientRuntime({
    required super.binding,
    required super.renderer,
  }) : super(
          target: ReactRenderTarget.browser,
          capabilities:
              ReactRuntimeCapabilities.browser,
        );
}

final class WebServerRuntime
    extends ReactRuntime {
  WebServerRuntime({
    required super.binding,
    required super.renderer,
  }) : super(
          target: ReactRenderTarget.server,
          capabilities:
              ReactRuntimeCapabilities.server,
        );
}
```

This avoids creating callback wrappers during SSR merely for ReactDOMServer to discard them.

---

# 12. Current stabilization work

Complete these before generating the first host surface.

## Fix component diagnostic ownership

The current emitter returns the property name as the component name:

```dart
String _componentName(
  ReactPropModel prop,
) => prop.name;
```

Change `_accessor` to receive both component and prop.

## Canonicalize component IDs

Generated factories and the manual SSR switch currently use different package IDs. The SSR switch still contains `package:react_workspace/...`, while generated output uses `package:examples/ssr/...`.

Generate the server registry from the same component model as the client registry.

## Replace process-global runtime state

Implement the scoped runtime described earlier.

## Preserve existing callback tests

All current callback bridge, emitter and hydration behavior must remain green.

---

# 13. Work packages

## W1.0 — Stabilize component generation

Deliverables:

```text
correct component diagnostics
canonical ComponentId generation
generated SSR registry
no manually duplicated SSR ID strings
```

Tests:

```text
missing required prop identifies component
generated client and server IDs match
unknown ID produces clear diagnostic
```

## W1.1 — Introduce scoped runtime

Deliverables:

```text
ReactRuntime
ReactRuntimeCapabilities
runWithReactRuntime()
browser runtime
server runtime
```

Tests:

```text
hooks fail outside runtime
nested runtime restores parent
two concurrent SSR requests do not leak
server runtime reports no event/ref support
```

## W1.2 — Add `react_web` packages

Create:

```text
packages/react_web/
packages/react_web_generator/
```

Move the handwritten `dom.dart` implementation behind `react_web` temporarily.

## W1.3 — Acquire and pin Web IDL data

Deliverables:

```text
tool/web_idl/pin.json
tool/web_idl/update.dart
tool/web_idl/preparse.mjs
tool/web_idl/snapshots/web_apis.json
tool/web_idl/snapshots/provenance.json
```

The update command must:

1. Validate the tracked `third_party/web` submodule against `pin.json`.
2. Validate the exact `package:web` dependency declarations.
3. Install the WebRef datasets from the upstream lockfile.
4. Normalize those datasets with the workspace pre-parser.
5. Record the package, source, and dataset versions in provenance.
6. Fail instead of silently selecting a different package or source revision.

## W1.4 — Build package:web symbol resolver

Given an IDL interface name, resolve the installed Dart type.

```dart
final class PackageWebResolver {
  WebDartType resolveInterface(
    String idlName,
  );

  bool containsInterface(
    String idlName,
  );
}
```

Generation should fail when an allowlisted element’s required `package:web` interface cannot be resolved.

## W1.5 — Build Web Host IR

Inputs:

```text
web_apis.json
package:web resolver
React overlay YAML
element allowlist
```

Output:

```text
List<WebHostElementIR>
```

Add a human-readable debug output:

```text
build/web_host_ir.json
```

## W1.6 — Generate the first HTML slice

Generate:

```text
div
span
button
input
form
label
textarea
select
option
a
img
```

Generate:

```text
typed attributes
event props
capture event props
refs
children
keys
SSR metadata
```

Keep raw escape hatches:

```dart
Map<String, Object?> additionalProps =
    const {};
```

## W1.7 — Integrate client and server renderers

Client:

```text
events converted through callback trampoline
refs converted through callback trampoline
package:web values passed without copying
```

Server:

```text
events omitted
refs omitted
attributes rendered
boolean attributes rendered correctly
void elements rendered correctly
```

## W1.8 — Integration and conformance tests

Test fixture:

```dart
@reactComponent
ReactNode GeneratedForm(
  ({
    String initialValue,
    void Function(String)? onSubmit,
  }) props,
) {
  final (value, setValue) =
      useState(props.initialValue);

  return form(
    onSubmit: (event) {
      event.preventDefault();
      props.onSubmit?.call(value);
    },
    children: [
      label(
        htmlFor: 'name',
        children: const [
          Text('Name'),
        ],
      ),
      input(
        id: 'name',
        value: value,
        onInput: (event) {
          setValue(
            event.currentTarget.value,
          );
        },
      ),
      button(
        type: 'submit',
        children: const [
          Text('Save'),
        ],
      ),
    ],
  );
}
```

Required test matrix:

```text
dart analyze
all unit tests
generator golden tests
deterministic regeneration
client compile -O0
client compile -O2
SSR compile -O2
SSR render
browser hydration
input event
form submit
package:web currentTarget typing
ref callback typing
concurrent SSR isolation
```

---

# 14. Acceptance criteria

Milestone W1 is complete when all of these are true:

1. `packages/react/lib/src/dom.dart` is no longer the authoritative handwritten DOM API.
2. `button`, `input`, `form`, and the remaining allowlisted elements are generated.
3. `package:react` has no `package:web` or JS interop dependency.
4. Event handlers expose React event types with typed `package:web` `currentTarget` and `nativeEvent`.
5. Refs expose the corresponding `package:web` element type.
6. The same generated host model is consumed by browser and server renderers.
7. Server rendering does not create event or ref callback wrappers.
8. SSR output hydrates without mismatches.
9. Client and server component IDs come from one generated source.
10. Two concurrent SSR renders do not share runtime state.
11. Generation is deterministic.
12. Every generated prop has explicit browser and SSR behavior.
13. Existing component and callback tests remain green.
14. The first vertical slice passes under both `-O0` and `-O2`.

---

# 15. Recommended commit sequence

```text
1. fix: correct generated diagnostics and canonical component IDs

2. feat: generate shared client and SSR component registry

3. refactor: replace global ReactInternal state with scoped ReactRuntime

4. refactor: introduce renderer-qualified HostType and HostNode

5. chore: add react_web and react_web_generator packages

6. build: add pinned Web IDL snapshot acquisition tool

7. feat: add package:web symbol resolver

8. feat: add React web overlay and WebHostIR

9. feat: generate initial HTML host factories

10. feat: add typed React events and package:web refs

11. feat: add separate client and SSR web prop encoders

12. test: add SSR, hydration, event, ref and concurrency integration suite

13. docs: document Web IDL provenance and regeneration workflow
```

This milestone keeps today’s work focused entirely on the web renderer while preserving the one future-facing invariant that matters: **the React component language stays independent of the environment that ultimately renders it.**
