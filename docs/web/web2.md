The `react` package should **not define or enumerate web widgets at all**.

It only needs a generic node that can represent a renderer-owned host element. The generated `react_web` package creates those nodes.

```text
react
  knows: “this is a host node owned by renderer X”

react_web
  knows: “this is a <button>, with these props and event types”

react_js / react_server
  know: “how to render a web host node”
```

Currently, `Intrinsic` embeds the web concept directly into core through a `tag` string.  That should be replaced with a renderer-neutral `HostNode`.

# 1. What remains in `package:react_core`

```dart
sealed class ReactNode {
  const ReactNode();
}

final class HostType {
  final String renderer;
  final String name;

  const HostType({
    required this.renderer,
    required this.name,
  });

  @override
  String toString() => '$renderer:$name';
}

final class HostNode extends ReactNode {
  final HostType type;
  final Map<String, Object?> props;
  final List<ReactNode> children;
  final String? key;

  const HostNode(
    this.type, {
    this.props = const {},
    this.children = const [],
    this.key,
  });
}
```

Core understands:

```dart
HostType(
  renderer: 'web',
  name: 'button',
)
```

only as an identifier.

It does not know:

* What an HTML button is.
* Which properties a button accepts.
* What `HTMLButtonElement` is.
* What mouse events are.
* How to serialize a button.
* How to create a React JS element.

# 2. What the Web IDL generator creates

The generator writes into:

```text
packages/react_web/lib/src/generated/
```

For example:

```text
generated/
├── html/
│   ├── div.dart
│   ├── button.dart
│   ├── input.dart
│   └── form.dart
├── events/
│   ├── synthetic_event.dart
│   ├── mouse_event.dart
│   └── input_event.dart
└── host_types.dart
```

Generated button host identity:

```dart
const buttonHostType = HostType(
  renderer: 'web',
  name: 'button',
);
```

Generated public callback:

```dart
typedef ButtonClickHandler = void Function(
  ReactMouseEvent<
    web.HTMLButtonElement
  > event,
);
```

Generated factory:

```dart
ReactNode button({
  String? id,
  String? className,
  String? type,
  bool? disabled,
  ButtonClickHandler? onClick,
  ButtonClickHandler? onClickCapture,
  ReactRefCallback<
    web.HTMLButtonElement
  >? ref,
  List<ReactNode> children = const [],
  String? key,
}) {
  return HostNode(
    buttonHostType,
    props: {
      if (id != null) 'id': id,
      if (className != null)
        'className': className,
      if (type != null) 'type': type,
      if (disabled != null)
        'disabled': disabled,
      if (onClick != null)
        'onClick': _buttonClickCallback(
          onClick,
        ),
      if (onClickCapture != null)
        'onClickCapture':
            _buttonClickCallback(
          onClickCapture,
        ),
      if (ref != null)
        'ref': _buttonRefCallback(ref),
    },
    children: children,
    key: key,
  );
}
```

Nothing from that factory needs to be declared in `package:react_core`.

# 3. How application code imports it

A web component imports the web package:

```dart
import 'package:react_web/react_web.dart';

@reactComponent
ReactNode Counter(({int initial}) props) {
  final (count, setCount) =
      useState(props.initial);

  return div(
    children: [
      Text('Count: $count'),
      button(
        onClick: (_) {
          setCount(count + 1);
        },
        children: const [
          Text('+1'),
        ],
      ),
    ],
  );
}
```

`react_web.dart` should re-export the core API:

```dart
library;

export 'package:react_core/react.dart';

export 'src/events.dart';
export 'src/generated/html.dart';
export 'src/generated/svg.dart';
export 'src/refs.dart';
```

Therefore, web application code normally needs only:

```dart
import 'package:react_web/react_web.dart';
```

That import provides:

```text
ReactNode
Component
Text
Fragment
hooks
callbacks
div()
button()
input()
ReactMouseEvent
package:web-compatible refs
```

Renderer-neutral code can continue to import:

```dart
import 'package:react_core/react.dart';
```

# 4. Remove the handwritten DOM API from core

This file should eventually be removed:

```text
packages/react_core/lib/src/dom.dart
```

And this export should be removed:

```dart
export 'src/dom.dart';
```

The temporary migration can be:

```dart
@Deprecated(
  'Import package:react_web/react_web.dart '
  'for generated web host components.',
)
export 'src/dom.dart';
```

Then delete it once generated `div()` and `button()` are available.

The ownership should become:

| Definition                | Owner                             |
| ------------------------- | --------------------------------- |
| `ReactNode`               | `react`                           |
| `HostNode`                | `react`                           |
| `HostType`                | `react`                           |
| `ReactCallback`           | `react`                           |
| `ReactRefCallback<T>`     | `react`                           |
| `div()`                   | `react_web`, generated            |
| `button()`                | `react_web`, generated            |
| `ReactMouseEvent<T>`      | `react_web`, generated/maintained |
| `web.HTMLButtonElement`   | `package:web`                     |
| Callback-to-JS conversion | `react_js`                        |
| Browser mounting          | `react_dom`                       |
| Server rendering          | `react_server`                    |

# 5. How the renderer recognizes a web widget

The renderer switches on `HostNode`:

```dart
Object? renderNode(ReactNode node) {
  return switch (node) {
    Text(:final value) =>
      value.toJS,

    Fragment(:final children) =>
      renderFragment(children),

    Component(
      :final id,
      :final props,
    ) =>
      renderComponent(id, props),

    HostNode(
      :final type,
      :final props,
      :final children,
    ) =>
      renderHostNode(
        type,
        props,
        children,
      ),

    Empty() => null,
  };
}
```

The web renderer validates the namespace:

```dart
JSAny? renderHostNode(
  HostType type,
  Map<String, Object?> props,
  List<ReactNode> children,
) {
  if (type.renderer != 'web') {
    throw StateError(
      'The web renderer cannot render '
      '$type.',
    );
  }

  return reactCreateElement(
    type.name,
    encodeWebProps(props),
    renderChildren(children),
  );
}
```

For:

```dart
button(...)
```

the node contains:

```text
type.renderer = web
type.name     = button
```

The web renderer translates that to:

```javascript
React.createElement("button", props, children)
```

The core never needs a `switch` containing every HTML element.

# 6. Client and SSR see the same host node

Both paths receive:

```dart
HostNode(
  HostType(
    renderer: 'web',
    name: 'button',
  ),
  props: {
    'disabled': false,
    'onClick': ReactCallback(...),
  },
)
```

## Browser encoder

```dart
JSObject encodeWebClientProps(
  Map<String, Object?> props,
) {
  final result = JSObject();

  for (final entry in props.entries) {
    final value = entry.value;

    result.setProperty(
      entry.key.toJS,
      switch (value) {
        ReactCallback callback =>
          callbackToJS(callback),
        _ => toReactJS(value),
      },
    );
  }

  return result;
}
```

## Server encoder

```dart
JSObject encodeWebServerProps(
  Map<String, Object?> props,
) {
  final result = JSObject();

  for (final entry in props.entries) {
    final value = entry.value;

    if (value is ReactCallback) {
      // Events and callback refs do not become
      // server-rendered HTML props.
      continue;
    }

    result.setProperty(
      entry.key.toJS,
      toReactJS(value),
    );
  }

  return result;
}
```

The Web IDL-generated factory normalizes the property names before either renderer receives the node.

For example:

```dart
label(
  htmlFor: 'email',
)
```

produces:

```dart
props: {
  'htmlFor': 'email',
}
```

React DOM client and React DOM server receive the same React-compatible property name.

# 7. Where SSR metadata fits

For Node-based ReactDOMServer SSR, much of the HTML serialization is already handled by React. The generator does not need to reimplement HTML serialization.

It does need to identify categories such as:

```text
ordinary value
event callback
ref callback
dangerouslySetInnerHTML
style
children
```

Instead of placing large metadata objects inside `package:react_core`, the generated values can carry generic core wrappers:

```dart
sealed class ReactHostPropValue {
  const ReactHostPropValue();
}

final class ReactEventProp
    extends ReactHostPropValue {
  final ReactCallback callback;

  const ReactEventProp(this.callback);
}

final class ReactRefProp
    extends ReactHostPropValue {
  final ReactCallback callback;

  const ReactRefProp(this.callback);
}
```

Generated factory:

```dart
props: {
  if (onClick != null)
    'onClick': ReactEventProp(
      _buttonClickCallback(onClick),
    ),
  if (ref != null)
    'ref': ReactRefProp(
      _buttonRefCallback(ref),
    ),
}
```

Client encoder:

```dart
switch (value) {
  ReactEventProp(:final callback) =>
    callbackToJS(callback),

  ReactRefProp(:final callback) =>
    callbackToJS(callback),

  _ => toReactJS(value),
}
```

Server encoder:

```dart
switch (value) {
  ReactEventProp() => continue,
  ReactRefProp() => continue,
  _ => encodeNormally(value),
}
```

These wrappers are generic enough to live in core because they describe rendering semantics, not browser types.

# 8. Component code generation does not need the element list

`react_codegen` handles:

```dart
@reactComponent
ReactNode Counter(CounterProps props)
```

It generates the component factory and JS bridge.

It does not need to know that the function body contains:

```dart
div(...)
button(...)
input(...)
```

Those are ordinary Dart function calls that already produce `ReactNode` objects.

The division is:

```text
react_codegen
    generates user-defined component bridges

react_web_generator
    generates built-in web host factories
```

They are independent pipelines.

# Final package flow

```text
Web IDL
   ↓
react_web_generator
   ↓
generated react_web factories
   ↓
button(...)
   ↓
HostNode(
  renderer: web,
  name: button,
)
   ↓
ReactNode tree
   ├── react_dom browser renderer
   └── react_server SSR renderer
```

So the direct answer is:

> The `react` package does not “see” or define web widgets. It only sees renderer-qualified `HostNode` values. The generated `react_web` package owns every web factory and returns those generic nodes.




Yes—for a web-targeted application, both client and SSR component code use `react_web`.

The split would be:

```text
Application components
    import package:react_web/react_web.dart

Client bootstrap
    imports react_web + react_dom

SSR bootstrap
    imports react_web + react_server
```

`react_web` becomes the authoring package for web components because it re-exports the renderer-neutral core and adds the generated web host surface.

## Shared component

```dart
import 'package:react_web/react_web.dart';

@reactComponent
ReactNode Counter(
  ({
    String title,
    int initialCount,
  }) props,
) {
  final (count, setCount) =
      useState(props.initialCount);

  return div(
    className: 'counter',
    children: [
      Text('${props.title}: $count'),
      button(
        type: 'button',
        onClick: (_) {
          setCount(count + 1);
        },
        children: const [
          Text('+1'),
        ],
      ),
    ],
  );
}
```

That same source is compiled into both the client bundle and the SSR bundle.

It does not import `react_dom` or `react_server` because the component should not care which web renderer is currently executing it.

## Client entrypoint

```dart
import 'package:react_dom/react_dom.dart';
import 'package:react_web/react_web.dart';

import 'app.react.dart';

void main() {
  registerReactComponents();

  hydrateRoot(
    '#app',
    App(title: 'Dashboard'),
  );
}
```

Responsibilities:

```text
react_web
    web elements, web events, refs, ReactNode, hooks

react_dom
    createRoot, hydrateRoot, browser mounting
```

## SSR entrypoint

```dart
import 'package:react_server/react_server.dart';
import 'package:react_web/react_web.dart';

import 'app.react.dart';

void main() {
  registerReactComponents();

  registerServerHandler((request) {
    return renderToString(
      App(title: 'Dashboard'),
    );
  });
}
```

Responsibilities:

```text
react_web
    same web element definitions used by client rendering

react_server
    server runtime, component registration,
    renderToString or streaming
```

In practice, the SSR entrypoint may not need to import `react_web` directly if all it does is import `app.react.dart`. The application component already imported `react_web`. But explicitly importing it is reasonable when the entrypoint uses `ReactNode`, generated web factories, or web-runtime initialization itself.

## `react_web` re-exports core

Its barrel would look roughly like:

```dart
library;

export 'package:react_core/react.dart';

export 'src/events/events.dart';
export 'src/generated/html.dart';
export 'src/generated/svg.dart';
export 'src/refs.dart';
```

Therefore, web application code normally uses:

```dart
import 'package:react_web/react_web.dart';
```

instead of importing both:

```dart
import 'package:react_core/react.dart';
import 'package:react_web/react_web.dart';
```

## Package ownership

| Code                                         | Import                                   |
| -------------------------------------------- | ---------------------------------------- |
| Renderer-neutral component logic             | `package:react_core/react.dart`               |
| Web components shared between client and SSR | `package:react_web/react_web.dart`       |
| Browser bootstrap                            | `package:react_dom/react_dom.dart`       |
| SSR bootstrap                                | `package:react_server/react_server.dart` |
| Explicit browser interface usage             | `package:web/web.dart`                   |

For example, a component using a typed element ref might import both:

```dart
import 'package:react_web/react_web.dart';
import 'package:web/web.dart' as web;

ReactNode FocusButton() {
  return button(
    ref: (web.HTMLButtonElement? element) {
      element?.focus();
    },
    children: const [
      Text('Focus me'),
    ],
  );
}
```

The SSR renderer never invokes that ref. It sees the generated ref metadata and omits it during server prop conversion.

## What remains portable

A package containing no web host nodes can still import only core:

```dart
import 'package:react_core/react.dart';

@reactComponent
ReactNode Conditional(
  ({
    bool visible,
    ReactNode child,
  }) props,
) {
  return props.visible
      ? props.child
      : const Empty();
}
```

That component is renderer-neutral.

Once a component uses:

```dart
div()
button()
input()
ReactMouseEvent
web.HTMLInputElement
```

it is intentionally a web component and should import `react_web`.

So the practical rule is:

```text
react
    component language

react_web
    web component authoring surface

react_dom
    client execution

react_server
    SSR execution
```

Both web client and web SSR consume the same `react_web` nodes; only their runtime encoders differ.
