You are thinking about this in the right way, but there are **two different SSR directions** that should remain separate:

1. **Run the real React server renderer inside JavaScript**
2. **Implement a native Dart HTML renderer**

Embedding a JavaScript runtime through FFI belongs to the first direction. `package:html` belongs mainly to the second—or as a supporting utility around the first.

# Recommended long-term shape

```text
                    generated neutral web model
                               │
             ┌─────────────────┴─────────────────┐
             │                                   │
        browser renderer                     SSR engine
             │                                   │
     package:web + React DOM          ┌──────────┴───────────┐
                                      │                      │
                               JavaScript SSR          Native Dart SSR
                               ReactDOMServer          HTML writer
                                      │                      │
                              Node process now         possible later
                              embedded JS later        package:html optional
```

The critical point is:

> Replacing Node with an embedded JavaScript engine should not require redesigning the component model or generated web definitions.

Node should be treated as the current **JavaScript execution host**, not as part of the SSR architecture.

# 1. Put a server-engine boundary in place now

Instead of allowing `react_server` to assume it launches or communicates with Node, define an engine contract:

```dart
abstract interface class ReactServerEngine {
  Future<ReactServerResult> render(
    ReactServerRequest request,
  );

  Future<void> close();
}

final class ReactServerRequest {
  final String componentId;
  final Map<String, Object?> props;
  final String? identifierPrefix;

  const ReactServerRequest({
    required this.componentId,
    required this.props,
    this.identifierPrefix,
  });
}

final class ReactServerResult {
  final String html;

  const ReactServerResult({
    required this.html,
  });
}
```

Implementations:

```text
NodeProcessReactServerEngine
EmbeddedJavaScriptReactServerEngine
NativeDartReactServerEngine          // possible later
```

Today:

```dart
final engine =
    NodeProcessReactServerEngine(
  bundlePath: 'build/ssr.js',
);
```

Later:

```dart
final engine =
    EmbeddedJavaScriptReactServerEngine(
  runtime: quickJsRuntime,
  bundle: embeddedSsrBundle,
);
```

The request and result contracts remain unchanged.

# 2. How the embedded JavaScript plan would work

The future native server binary would contain:

```text
Dart VM application
      │
      ├── HTTP server
      ├── FFI bindings
      └── embedded JavaScript engine
              │
              ├── React
              ├── react-dom/server
              └── Dart SSR bundle compiled to JavaScript
```

This is important: initially, the embedded engine should execute the **same Dart-to-JavaScript SSR bundle** that Node executes today.

```text
Current:
Dart server entrypoint
    → dart compile js
    → Node
    → ReactDOMServer

Future:
Dart server entrypoint
    → dart compile js
    → embedded JS runtime through FFI
    → ReactDOMServer
```

That preserves:

* Existing generated component bridges
* React hooks
* React component execution
* React context
* React hydration behavior
* React’s own HTML rules

A small embeddable engine such as QuickJS is designed to be embedded through its C API, so it is a plausible execution host, although compatibility and performance need to be proven with the actual React bundle. ([GitHub][1])

## Do not start with Node-specific streaming

For an embedded runtime, the simplest initial React API is:

```javascript
renderToString(reactNode)
```

`renderToString` is non-streaming but works without requiring Node stream infrastructure. React classifies it as a legacy non-streaming API with less functionality than the streaming APIs, but it is still suitable as the first portable engine target. ([React][2])

Later, an embedded engine could support:

```javascript
renderToReadableStream(reactNode)
```

but that requires:

* Promises and microtask processing
* Web Streams support or a compatible polyfill
* An FFI bridge from JavaScript chunks to Dart
* Cancellation and error propagation

React’s Web Streams API is `renderToReadableStream`; its Node-specific streaming counterpart is `renderToPipeableStream`. ([React][2])

Therefore:

```text
Embedded SSR milestone 1:
renderToString

Embedded SSR milestone 2:
renderToReadableStream

Avoid:
renderToPipeableStream, unless intentionally emulating Node streams
```

# 3. The SSR JavaScript bundle needs a stable protocol

Do not expose arbitrary JavaScript calls through FFI. Bundle one controlled server API:

```javascript
globalThis.__dartReactServer = {
  async render(requestJson) {
    const request = JSON.parse(requestJson);

    const component =
      globalThis.__dartReactComponents[
        request.componentId
      ];

    if (!component) {
      throw new Error(
        `Unknown component: ${request.componentId}`
      );
    }

    const node = React.createElement(
      component,
      request.props
    );

    return ReactDOMServer.renderToString(
      node,
      {
        identifierPrefix:
          request.identifierPrefix
      }
    );
  }
};
```

The FFI layer only needs generic operations such as:

```text
create runtime
create context
evaluate bundle
call global function
pass UTF-8 JSON
receive UTF-8 result
drain pending jobs
destroy context
```

A pool will probably be required because one JS context should not be used concurrently by unrelated SSR requests.

```dart
final class EmbeddedJsRuntimePool {
  final List<EmbeddedJsRuntime> runtimes;

  Future<T> withRuntime<T>(
    Future<T> Function(
      EmbeddedJsRuntime runtime,
    ) callback,
  );
}
```

# 4. Keep `package:web` out of the shared SSR contract

The generated shared `react_web` files should still be pure Dart.

That means the current generated file should not contain:

```dart
import 'dart:js_interop';
import 'package:web/web.dart' as web;
```

The browser adapter may contain those imports, but the shared factory must not.

Shared:

```dart
ReactNode button({
  void Function(
    ReactMouseEvent<HTMLButtonElement>,
  )? onClick,
  void Function(HTMLButtonElement?)? ref,
});
```

Browser implementation:

```text
HTMLButtonElement
    wraps or represents web.HTMLButtonElement

ReactMouseEvent
    wraps the React JS event
    nativeEvent maps to web.MouseEvent
```

SSR:

```text
HTMLButtonElement is only a static interface type
no instance is created
ref is omitted
events are omitted
```

This remains true whether SSR uses:

* Node
* QuickJS through FFI
* JavaScriptCore through FFI
* Another embedded ECMAScript engine
* A native Dart renderer

# 5. Can `package:html` be used for SSR?

**Yes, but I would not initially use it as the source-of-truth renderer for hydratable React output.**

`package:html` is a Dart implementation of an HTML5 parser with a simple DOM tree API. It works outside the browser and supports parsing, manipulating and serializing HTML. Its DOM API is intentionally simple and is missing many browser types and APIs. ([Dart packages][3])

It is useful in four areas.

## Good use 1: Document shell composition

ReactDOMServer can render the application fragment:

```html
<div class="app">...</div>
```

Then `package:html` can parse a template and insert the fragment:

```dart
import 'package:html/dom.dart';
import 'package:html/parser.dart';

String composeDocument({
  required String shell,
  required String appHtml,
  required String stateJson,
}) {
  final document = parse(shell);

  final root =
      document.querySelector('#app');

  if (root == null) {
    throw StateError(
      'The document shell has no #app element.',
    );
  }

  root.nodes
    ..clear()
    ..addAll(
      parseFragment(appHtml).nodes,
    );

  final state = Element.tag('script')
    ..attributes['type'] =
        'application/json'
    ..attributes['id'] =
        '__INITIAL_STATE__'
    ..text = stateJson;

  document.body?.nodes.add(state);

  return document.outerHtml;
}
```

The package supports `parse`, `parseFragment`, a DOM-like tree and `outerHtml` serialization. ([Dart packages][3])

## Good use 2: SSR output tests

```dart
final document = parseFragment(html);

expect(
  document.querySelector('button')
      ?.attributes['disabled'],
  isNotNull,
);
```

This is preferable to brittle string matching.

## Good use 3: Post-processing

For example:

* Add preload tags
* Add serialized application state
* Add CSP nonces
* Inject assets
* Inspect generated headings and metadata

## Good use 4: Static rendering

For pages that will not hydrate, a native Dart renderer backed by `package:html` could be entirely reasonable.

React’s `renderToStaticMarkup` is itself intended for non-interactive HTML and explicitly produces output that cannot be hydrated. ([React][4])

# 6. Why `package:html` is risky for hydratable rendering

Hydration is stricter than merely producing valid HTML.

React’s `hydrateRoot` expects the client’s initial output to be identical to the server-rendered content, and React advises treating mismatches as bugs. Attribute differences are not guaranteed to be repaired. ([React][5])

A native Dart renderer would need to reproduce React server behavior for:

* Text escaping
* Attribute names
* Boolean attributes
* Style serialization
* `className` and `htmlFor`
* Controlled inputs
* `<textarea>` values
* `<select>` state
* Namespaces
* SVG
* Void elements
* Adjacent text-node markers
* `useId`
* `identifierPrefix`
* Suspense boundaries
* Streaming markers and bootstrap scripts
* React-version-specific output details

`package:html` can produce valid HTML, but valid HTML is not automatically **ReactDOMServer-compatible HTML**.

For example, this may be valid:

```html
<input disabled="disabled">
```

while React may choose another equivalent representation:

```html
<input disabled="">
```

Browsers treat those similarly, but hydration parity must be tested against the exact React client behavior.

# 7. Better native SSR architecture

If native Dart SSR becomes a goal, I would not make `package:html` the renderer abstraction.

Define:

```dart
abstract interface class ReactHtmlSink {
  void startElement(
    String name,
    Map<String, Object?> attributes,
  );

  void text(String value);

  void comment(String value);

  void endElement(String name);
}
```

Then provide:

```text
StreamingHtmlSink
    writes directly to StringSink or StreamSink

PackageHtmlSink
    builds package:html DOM nodes

DebugHtmlSink
    records operations for tests
```

The production implementation should likely be a direct writer:

```dart
final class StreamingHtmlSink
    implements ReactHtmlSink {
  final StringSink output;

  StreamingHtmlSink(this.output);

  @override
  void text(String value) {
    output.write(
      escapeHtmlText(value),
    );
  }

  // ...
}
```

Advantages over always creating a `package:html` tree:

* Lower allocation
* Natural streaming
* Easier control over exact output
* Easier reproduction of React-specific markers
* No parser normalization
* Better performance for large pages

`package:html` would remain useful as a test and composition backend.

# 8. Native Dart SSR is more than HTML serialization

The difficult part is not generating `<div>` tags. It is executing components and hooks.

There are two native approaches.

## Approach A: Execute compiled Dart-to-JS in embedded JavaScript

```text
Dart component source
      ↓
dart compile js
      ↓
embedded JavaScript runtime
      ↓
React + ReactDOMServer
```

This is the recommended near-to-medium-term path because it preserves the real React runtime.

## Approach B: Execute components natively on the Dart VM

```text
Dart component source
      ↓
Dart VM server runtime
      ↓
native server hook implementation
      ↓
resolved HostNode tree
      ↓
native HTML writer
```

That would require native implementations for:

```text
useState during SSR
useContext
useMemo
useId
Suspense
error boundaries
lazy components
server streaming
identifier stability
component registration
```

`package:html` solves none of those runtime semantics. It only helps with the final tree or string representation.

# 9. Recommended staged roadmap

## Stage 1 — Make Node replaceable

Implement:

```text
ReactServerEngine
NodeProcessReactServerEngine
stable JSON render protocol
SSR bundle manifest
runtime pooling interface
```

Do not change rendering behavior yet.

## Stage 2 — Correct shared web generation

Generate:

```text
react_web:
    pure-Dart interfaces and host factories

browser adapter:
    package:web and JS implementations

SSR metadata:
    events/ref omission and prop rules
```

No `package:web` in shared generated files.

## Stage 3 — Add HTML shell support

Use `package:html` for:

```text
document templates
head manipulation
state injection
asset injection
SSR test assertions
```

Do not yet replace ReactDOMServer.

## Stage 4 — Embedded JS proof of concept

Implement an FFI engine with:

```text
single bundled JS file
renderToString
JSON input/output
runtime pool
error conversion
memory limits
timeouts
```

Run the same conformance tests against:

```text
Node engine
embedded JS engine
```

Expected result:

```text
identical HTML
identical errors
identical hydration behavior
```

## Stage 5 — Streaming embedded SSR

Add:

```text
renderToReadableStream
chunk bridge
backpressure
cancellation
runtime job draining
```

## Stage 6 — Evaluate native Dart SSR

Only after the ReactDOMServer output corpus exists.

Create differential tests:

```dart
expect(
  nativeDartRenderer.render(fixture),
  reactDomServerRenderer.render(fixture),
);
```

Begin with:

```text
text
fragments
basic HTML
attributes
boolean attributes
styles
forms
SVG
```

Then decide whether native SSR parity is worth maintaining.

# Recommended decision

Use both—but for different jobs:

```text
ReactDOMServer inside Node today
ReactDOMServer inside embedded JS later
    → authoritative hydratable SSR

package:html
    → document shell composition
    → inspection and tests
    → static rendering
    → possible native SSR prototype
```

So the immediate architecture should assume:

> **Node is replaceable, ReactDOMServer is not yet replaceable.**

That lets you move to an FFI-embedded JavaScript runtime without forcing a premature native reimplementation of React SSR, while still leaving a clean path for a future native Dart renderer built from the same neutral Web IDL/codegen model.

[1]: https://github.com/quickjs-ng/quickjs?utm_source=chatgpt.com "GitHub - quickjs-ng/quickjs: QuickJS, the Next Generation: a mighty JavaScript engine · GitHub"
[2]: https://react.dev/reference/react-dom/server?utm_source=chatgpt.com "Server React DOM APIs – React"
[3]: https://pub.dev/documentation/html/latest/?utm_source=chatgpt.com "html - Dart API docs"
[4]: https://react.dev/reference/react-dom/server/renderToStaticMarkup?utm_source=chatgpt.com "renderToStaticMarkup – React"
[5]: https://react.dev/reference/react-dom/client/hydrateRoot?utm_source=chatgpt.com "hydrateRoot – React"
