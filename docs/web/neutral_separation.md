You are thinking about it correctly.

The **code generator should be the neutral layer**. The current generated `react_web` file is mixing three concerns:

1. The shared web component API.
2. Browser-only `package:web` types.
3. JS callback adaptation.

That is why SSR now feels awkward.

The shared generated API should not directly import:

```dart
import 'dart:js_interop';
import 'package:web/web.dart';
```

Those imports belong in the browser implementation produced from the same Web IDL model.

# Intended architecture

```text
Web IDL / WebRef data
          ↓
Neutral Web Host IR
          ↓
    ┌─────┴────────┐
    │              │
shared API      renderer adapters
react_web       ├── browser/package:web
pure Dart       └── SSR
```

The IDL compiler produces one semantic model, then multiple outputs.

## Shared output

```text
react_web
```

Contains:

* HTML/SVG factories.
* Neutral web element interfaces.
* Neutral React event interfaces.
* Host property metadata.
* Callback descriptors.
* SSR behavior metadata.

It remains safe to compile on both client and server.

## Browser output

```text
react_web_js
or react_js/src/web
```

Contains:

* `package:web` integration.
* JS event wrappers.
* DOM-element wrappers.
* Callback decoding.
* Browser refs.
* `package:web` escape hatches.

## SSR output

```text
react_server
```

Contains:

* Prop filtering.
* Event omission.
* Ref omission.
* ReactDOMServer prop conversion.
* Component registry and request-scoped rendering.

It does not need `package:web`.

# What `react_web` should generate

Instead of this:

```dart
void Function(ReactMouseEvent)? onClick,
void Function(web.HTMLDivElement?)? ref,
```

generate neutral types:

```dart
void Function(
  ReactMouseEvent<HTMLDivElement>,
)? onClick,

void Function(
  HTMLDivElement?,
)? ref,
```

Here, `HTMLDivElement` is **not** `web.HTMLDivElement`.

It is a generated, pure-Dart web interface:

```dart
abstract interface class WebEventTarget {}

abstract interface class WebElement
    implements WebEventTarget {}

abstract interface class HTMLElement
    implements WebElement {
  String get id;
  set id(String value);

  String get title;
  set title(String value);

  void focus();
}

abstract interface class HTMLDivElement
    implements HTMLElement {
  String get align;
  set align(String value);
}
```

Similarly, events are neutral interfaces:

```dart
abstract interface class ReactSyntheticEvent<
  T extends WebEventTarget
> {
  T get currentTarget;

  WebEventTarget get target;

  bool get bubbles;

  bool get cancelable;

  bool get defaultPrevented;

  void preventDefault();

  void stopPropagation();
}

abstract interface class ReactMouseEvent<
  T extends WebEventTarget
> implements ReactSyntheticEvent<T> {
  MouseEvent get nativeEvent;

  double get clientX;

  double get clientY;

  int get button;

  bool get altKey;

  bool get ctrlKey;

  bool get shiftKey;
}
```

`MouseEvent` can also be a generated neutral Web IDL interface.

That allows this component to compile for both browser and SSR:

```dart
import 'package:react_web/react_web.dart';

ReactNode Example() {
  return div(
    onClick: (event) {
      event.preventDefault();

      final HTMLDivElement element =
          event.currentTarget;

      element.focus();
    },
  );
}
```

During SSR, this callback is never invoked. However, the callback body still type-checks because the neutral web interfaces exist on the server.

# Browser mapping to `package:web`

The browser adapter implements those neutral interfaces using `package:web`.

Conceptually:

```dart
import 'package:web/web.dart' as web;

final class JsHTMLDivElement
    implements HTMLDivElement {
  final web.HTMLDivElement value;

  JsHTMLDivElement(this.value);

  @override
  String get id => value.id;

  @override
  set id(String value) {
    this.value.id = value;
  }

  @override
  String get title => value.title;

  @override
  set title(String value) {
    this.value.title = value;
  }

  @override
  String get align => value.align;

  @override
  set align(String value) {
    this.value.align = value;
  }

  @override
  void focus() {
    value.focus();
  }
}
```

A mouse event adapter:

```dart
final class JsReactMouseEvent<
  T extends WebEventTarget
> implements ReactMouseEvent<T> {
  final web.MouseEvent value;
  final T currentTargetValue;

  JsReactMouseEvent(
    this.value,
    this.currentTargetValue,
  );

  @override
  T get currentTarget =>
      currentTargetValue;

  @override
  MouseEvent get nativeEvent =>
      JsMouseEvent(value);

  @override
  double get clientX =>
      value.clientX.toDouble();

  @override
  double get clientY =>
      value.clientY.toDouble();

  @override
  int get button => value.button;

  @override
  void preventDefault() {
    value.preventDefault();
  }

  @override
  void stopPropagation() {
    value.stopPropagation();
  }

  // Remaining members...
}
```

`package:web` itself generates browser interfaces as JS extension types, preserving Web IDL relationships such as `UIEvent` implementing `Event`.  The browser adapter can use those generated types internally without exposing them to SSR.

# Optional direct `package:web` access

Browser-specific code may still need the underlying object.

Provide a separate browser-only library:

```dart
import 'package:react_web/react_web.dart';
import 'package:react_web/browser.dart';
```

The browser adapter interfaces can expose an internal platform handle:

```dart
abstract interface class WebPlatformObject {
  Object get platformObject;
}
```

Then `browser.dart` provides extensions:

```dart
import 'package:web/web.dart' as web;

extension HTMLDivElementWebInterop
    on HTMLDivElement {
  web.HTMLDivElement get asWeb {
    final object =
        (this as WebPlatformObject)
            .platformObject;

    return object as web.HTMLDivElement;
  }
}

extension MouseEventWebInterop
    on MouseEvent {
  web.MouseEvent get asWeb {
    final object =
        (this as WebPlatformObject)
            .platformObject;

    return object as web.MouseEvent;
  }
}
```

Browser-only usage:

```dart
div(
  onClick: (event) {
    final webDiv =
        event.currentTarget.asWeb;

    final nativeMouseEvent =
        event.nativeEvent.asWeb;

    webDiv.focus();

    print(nativeMouseEvent.clientX);
  },
);
```

Shared SSR-safe components do not import `browser.dart`.

This gives two levels of interoperability:

```text
Default:
neutral generated Web IDL interfaces

Browser escape hatch:
neutral type → package:web type
```

# How the generated `div()` should look

The shared generated file should become:

```dart
// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';
import 'package:react_web/src/events.dart';
import 'package:react_web/src/types/html.dart';

const _divHostType =
    HostType<Map<String, Object?>>(
  'web',
  'div',
);

ReactNode div({
  String? align,
  String? id,
  String? className,
  String? title,
  bool? hidden,
  int? tabIndex,
  String? role,
  void Function(
    ReactMouseEvent<HTMLDivElement>,
  )? onClick,
  void Function(
    ReactMouseEvent<HTMLDivElement>,
  )? onClickCapture,
  void Function(
    ReactInputEvent<HTMLDivElement>,
  )? onInput,
  void Function(
    ReactInputEvent<HTMLDivElement>,
  )? onInputCapture,
  void Function(
    ReactKeyboardEvent<HTMLDivElement>,
  )? onKeyDown,
  void Function(
    ReactKeyboardEvent<HTMLDivElement>,
  )? onKeyDownCapture,
  void Function(
    ReactFocusEvent<HTMLDivElement>,
  )? onFocus,
  void Function(
    ReactFocusEvent<HTMLDivElement>,
  )? onFocusCapture,
  void Function(HTMLDivElement?)? ref,
  List<ReactNode> children = const [],
  String? key,
  Map<String, Object?> additionalProps =
      const {},
}) {
  return HostNode<Map<String, Object?>>(
    _divHostType,
    {
      if (align != null)
        'align': align,
      if (id != null)
        'id': id,
      if (className != null)
        'className': className,
      if (title != null)
        'title': title,
      if (hidden != null)
        'hidden': hidden,
      if (tabIndex != null)
        'tabIndex': tabIndex,
      if (role != null)
        'role': role,
      if (onClick != null)
        'onClick': ReactEventProp(
          _divOnClick(onClick),
        ),
      if (onClickCapture != null)
        'onClickCapture':
            ReactEventProp(
          _divOnClickCapture(
            onClickCapture,
          ),
        ),
      if (onInput != null)
        'onInput': ReactEventProp(
          _divOnInput(onInput),
        ),
      if (onInputCapture != null)
        'onInputCapture':
            ReactEventProp(
          _divOnInputCapture(
            onInputCapture,
          ),
        ),
      if (onKeyDown != null)
        'onKeyDown': ReactEventProp(
          _divOnKeyDown(onKeyDown),
        ),
      if (onFocus != null)
        'onFocus': ReactEventProp(
          _divOnFocus(onFocus),
        ),
      if (ref != null)
        'ref': ReactRefProp(
          _divRef(ref),
        ),
      ...additionalProps,
    },
    children: children,
    key: key,
  );
}
```

No `dart:js_interop`.

No `package:web`.

# How the callback reaches the browser

The shared callback adapter expects a neutral host value:

```dart
ReactCallback _divOnClick(
  void Function(
    ReactMouseEvent<HTMLDivElement>,
  ) callback,
) {
  return ReactCallback(
    debugName: 'div.onClick',
    signature: const (
      positional: [
        (
          kind: ReactValueKind.hostValue,
          nullable: false,
          hostNamespace: 'web',
          typeId: 'ReactMouseEvent<HTMLDivElement>',
          codecId: null,
        ),
      ],
      result: reactVoid,
      asynchronous: false,
    ),
    invoke: (arguments) {
      callback(
        arguments[0]
            as ReactMouseEvent<
                HTMLDivElement>,
      );

      return null;
    },
  );
}
```

The browser runtime decodes the raw JS event into:

```dart
JsReactMouseEvent<HTMLDivElement>
```

before invoking the descriptor.

The SSR runtime never decodes it because server rendering never invokes browser event props.

# How SSR handles the same node

The SSR renderer receives:

```dart
HostNode(
  HostType('web', 'div'),
  {
    'id': 'content',
    'hidden': false,
    'onClick': ReactEventProp(...),
    'ref': ReactRefProp(...),
  },
)
```

Its prop encoder performs:

```dart
for (final entry in props.entries) {
  switch (entry.value) {
    case ReactEventProp():
      // Omit during SSR.
      continue;

    case ReactRefProp():
      // Omit during SSR.
      continue;

    default:
      encodeServerProp(
        entry.key,
        entry.value,
      );
  }
}
```

Result:

```javascript
React.createElement(
  "div",
  {
    id: "content",
    hidden: false
  }
)
```

ReactDOMServer then renders the HTML.

No browser object is imported, created or inspected.

# What the neutral Web IDL IR should generate

The Web IDL pipeline should generate three categories of output from one model:

```text
WebHostIR
    │
    ├── shared API emitter
    │     react_web
    │     pure Dart factories/interfaces
    │
    ├── browser adapter emitter
    │     package:web implementations
    │     JS callback decoders
    │
    └── SSR metadata emitter
          event/ref omission
          attribute/property behavior
          void-element behavior
```

For each interface:

```text
IDL: HTMLInputElement
```

generate:

```text
shared:
HTMLInputElement interface

browser:
JsHTMLInputElement backed by web.HTMLInputElement

SSR:
no runtime implementation required
```

For each event:

```text
IDL: MouseEvent
```

generate:

```text
shared:
MouseEvent interface

browser:
JsMouseEvent backed by web.MouseEvent

SSR:
no runtime implementation required
```

# One important correction to the current generator

The generated example has:

```dart
String? hidden,
String? tabIndex,
```

These should probably be:

```dart
bool? hidden,
int? tabIndex,
```

That indicates the generator still needs a proper type-normalization pass rather than treating attributes as strings by default.

Likewise, events such as `onSubmit` should not necessarily appear on every element merely because they are global React event props. The overlay should classify:

```text
global React events
element-specific events
supported-but-unusual events
```

The first milestone can expose a curated set while the IR remains capable of representing the full event surface.

# Final split

```text
react
    generic component/runtime language

react_web
    generated pure-Dart Web IDL facade
    safe for client and SSR

react_web/browser.dart
    optional package:web interoperability

react_js / react_dom
    browser implementations and callback decoding

react_server
    SSR prop lowering and rendering
```

So yes: **the neutral code-generation layer is precisely what should protect SSR from `package:web` while still letting the browser implementation interoperate with it.** The current generated file is one layer too low because it emits browser implementation types directly into the shared API.
