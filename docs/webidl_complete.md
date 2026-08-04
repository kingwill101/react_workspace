Yes—**that is the correct architecture**.

I was wrongly treating the browser surface as something to curate. You already have the exact normalized Web IDL snapshot and mappings used by `package:web`; the generator should consume that entire corpus and emit the entire surface. `package:web` itself generates interop types and members directly from Web IDL and keeps the original IDL names, so staying pinned to its generator inputs is the right way to remain compatible. ([GitHub][1])

The contract should be:

> For the pinned `dart-lang/web` revision, every definition and member present in its `web_apis.json` must exist in `react_web`. Unsupported SSR operations fail at runtime; they are not omitted from the API.

## Remove the reachability model from API generation

The current idea of:

```text
selected elements
    ↓
reachable interfaces
    ↓
emit those interfaces
```

must disappear from the **Web API surface** pipeline.

Replace it with:

```text
package:web web_apis.json
        ↓
load every IDL definition
        ↓
normalize the complete graph
        ↓
emit every definition and member
```

That means removing these as inclusion mechanisms:

* Element roots
* Milestone allowlists
* “Reachable from selected elements”
* Interface allowlists
* Member filtering
* `full`, `exposed`, or similar policies that decide whether something is generated
* Special searches for `HTMLElement`, `Storage`, events, or other named types

The generator should not ask:

```dart
bool shouldGenerate(
  IdlDefinition definition,
);
```

It should simply do:

```dart
for (final definition
    in snapshot.definitions) {
  emitDefinition(definition);
}
```

## Keep two independent generation pipelines

You currently have two related—but different—products.

### Complete Web platform surface

This generates everything from the IDL:

```text
Window
Document
Storage
StorageEvent
IDBFactory
Clipboard
Navigator
History
WebSocket
Worker
AudioContext
CanvasRenderingContext2D
WebGLRenderingContext
GPUDevice
...
```

### React host-element surface

This generates:

```text
div()
button()
input()
video()
canvas()
svg()
...
```

along with:

* React props
* Event props
* HTML/SVG element mappings
* Void-element metadata
* SSR attribute behaviour

The element snapshot is valid for the second pipeline. It must not restrict the first.

```text
Complete IDL model
├── platform API emitter        → everything
└── React host emitter          → elements/factories/SSR markup
```

## Generate every IDL definition kind

The complete model needs to retain all definitions from the snapshot:

```dart
sealed class WebIdlDefinition {}

final class InterfaceDefinition
    extends WebIdlDefinition {}

final class InterfaceMixinDefinition
    extends WebIdlDefinition {}

final class DictionaryDefinition
    extends WebIdlDefinition {}

final class NamespaceDefinition
    extends WebIdlDefinition {}

final class EnumDefinition
    extends WebIdlDefinition {}

final class TypedefDefinition
    extends WebIdlDefinition {}

final class CallbackDefinition
    extends WebIdlDefinition {}

final class CallbackInterfaceDefinition
    extends WebIdlDefinition {}

final class IncludesDefinition
    extends WebIdlDefinition {}
```

Members must include:

```text
attributes
operations
operation overloads
constructors
constants
iterable
async iterable
maplike
setlike
stringifier
toJSON
static members
special operations
```

Types must preserve:

```text
nullable
union
sequence
FrozenArray
ObservableArray
record
Promise
typed arrays
generics
optional parameters
variadic parameters
default values
```

Extended attributes must also remain available:

```text
Exposed
Global
SecureContext
CrossOriginIsolated
SameObject
NewObject
Replaceable
PutForwards
LegacyWindowAlias
CEReactions
Clamp
EnforceRange
```

Do not discard unknown extended attributes. Preserve them in the IR even before the emitter understands their behaviour.

## Do not silently drop unsupported shapes

When the generator does not yet understand a particular IDL construct, the rule should be:

```text
strongly typed
    if supported

opaque but present
    if not fully supported

missing
    never
```

For example:

```dart
abstract interface class WebOpaqueObject {}
```

Then:

```dart
/// IDL type currently lowered opaquely:
/// SomeComplexUnionOrExperimentalType
abstract interface class
    SomeComplexUnionOrExperimentalType
    implements WebOpaqueObject {}
```

For an unknown parameter type:

```dart
void doSomething(
  WebOpaqueValue value,
);
```

This is preferable to omitting the method.

However, because you are using the exact inputs and mappings from the same pinned `package:web` revision, a missing mapping should generally be treated as a generator defect:

```text
IDL definition exists
package:web mapping exists
react_web cannot emit it
        ↓
generation fails
```

Do not quietly continue with a partial public surface.

## Exact names

The public names should match Web IDL/package:web names:

```dart
Window
Storage
StorageEvent
IDBFactory
localStorage
requestAnimationFrame
querySelector
```

Do not create a second naming scheme such as:

```text
WebWindow
WebStorage
BrowserLocalStorage
```

unless those names are private adapter implementation classes.

The public neutral surface should feel like `package:web`, because that is what users will search and what browser documentation uses. `package:web` intentionally preserves original IDL names rather than Dart-renamed equivalents. ([Dart][2])

A browser adapter can remain private:

```dart
final class BrowserStorage
    implements Storage {
  final web.Storage _inner;

  BrowserStorage(this._inner);
}
```

But users see:

```dart
Storage storage =
    window.localStorage;
```

## Browser and SSR should expose the same declarations

The public API must not change between browser and SSR compilation.

This should compile in both:

```dart
final storage = window.localStorage;
storage.setItem('theme', 'dark');
```

In a browser it works.

During SSR it fails clearly:

```text
Unsupported Web API during SSR:
Window.localStorage

The Storage API requires a Window browser realm.
```

Do not return `null` where IDL says the value is non-null. That would alter the API semantics merely to accommodate SSR.

Generate an explicit error:

```dart
final class UnsupportedWebApiError
    extends UnsupportedError {
  final String api;
  final String? exposed;

  UnsupportedWebApiError(
    this.api, {
    this.exposed,
  }) : super(
         '$api is unavailable during SSR'
         '${exposed == null
             ? ''
             : ' (Exposed=$exposed)'}.',
       );
}
```

Generated SSR member:

```dart
@override
Storage get localStorage =>
    throw UnsupportedWebApiError(
      'Window.localStorage',
      exposed: 'Window',
    );
```

Generated unsupported method:

```dart
@override
Future<ClipboardItem> read() =>
    throw UnsupportedWebApiError(
      'Clipboard.read',
      exposed: 'Window',
    );
```

Generated constructor:

```dart
factory AudioContext([
  AudioContextOptions? options,
]) {
  throw UnsupportedWebApiError(
    'AudioContext constructor',
    exposed: 'Window',
  );
}
```

## Use runtime backends, not `dart.library.js_interop`

Your browser client and SSR renderer both compile to JavaScript, so both satisfy JS-interop compilation conditions. A conditional export based only on:

```dart
dart.library.js_interop
```

cannot distinguish the browser from the Node SSR worker.

Use the runtime target you already control:

```text
browser entry
    installs BrowserWebRuntime

SSR entry
    installs SsrWebRuntime
```

For example:

```dart
abstract interface class WebRuntime {
  Window get window;
  Document get document;
  Navigator get navigator;

  static WebRuntime get current =>
      _current ??
      (throw StateError(
        'WebRuntime has not been installed.',
      ));

  static WebRuntime? _current;

  static void install(
    WebRuntime runtime,
  ) {
    _current = runtime;
  }
}
```

Browser entry:

```dart
WebRuntime.install(
  BrowserWebRuntime(),
);
```

SSR entry:

```dart
WebRuntime.install(
  SsrWebRuntime(),
);
```

Generated globals:

```dart
Window get window =>
    WebRuntime.current.window;

Document get document =>
    WebRuntime.current.document;

Navigator get navigator =>
    WebRuntime.current.navigator;
```

This prevents accidental reliance on whatever globals happen to exist in the current Node version.

## SSR implementation strategy

Everything should be declared, but runtime support can fall into generated categories.

### Host-renderable

HTML/SVG elements used to describe the React tree:

```text
HTMLDivElement
HTMLButtonElement
SVGElement
attributes
children
```

These remain supported through your virtual host-node/SSR metadata pipeline.

### Type-only during SSR

Events and browser callback objects:

```text
MouseEvent
KeyboardEvent
StorageEvent
PointerEvent
DragEvent
```

They can appear in signatures, but the server does not construct them under normal rendering.

### Unsupported live browser capabilities

These throw:

```text
localStorage
sessionStorage
clipboard
geolocation
mediaDevices
screen
window.open
Notification
AudioContext
WebGL
WebGPU
```

### Explicit server implementations

Some APIs may later receive real implementations:

```text
URL
URLSearchParams
Headers
Request
Response
AbortController
crypto
fetch
```

But support should be added through runtime implementations—not by changing whether those APIs are generated.

Default rule:

```text
API is always generated.
SSR implementation defaults to throwing.
A real server adapter may override it.
```

## Do not maintain an SSR YAML list

You should not replace an inclusion list with:

```yaml
ssr:
  supported:
    - URL
    - Headers
  unsupported:
    - Storage
    - Clipboard
```

That is the same maintenance problem.

Instead, generate defaults mechanically:

```text
all live Web APIs
    → throwing SSR implementation

host element API
    → virtual SSR implementation

pure value declarations
    → ordinary Dart representation

explicit framework adapter exists
    → concrete SSR implementation
```

Concrete adapters can be discovered by interface implementation, registration, or generated source integration rather than symbol lists.

For example:

```dart
final class SsrWebRuntime
    extends GeneratedThrowingWebRuntime {
  @override
  URL createURL(
    String value, [
    String? base,
  ]) {
    return SsrURL.parse(
      value,
      base: base,
    );
  }
}
```

The generated base class covers everything automatically; the handwritten subclass only overrides APIs for which the framework genuinely has an implementation.

## Output organization

One enormous source file would be hard for tooling. Generate complete coverage but split deterministically using the source groups already present in the snapshot:

```text
react_web/lib/src/generated/web/
├── dom.dart
├── html.dart
├── storage.dart
├── indexed_db.dart
├── fetch.dart
├── streams.dart
├── workers.dart
├── service_workers.dart
├── canvas.dart
├── web_audio.dart
├── webgl.dart
├── webgpu.dart
├── media_capture.dart
├── clipboard.dart
├── permissions.dart
├── notifications.dart
├── interfaces.dart
├── dictionaries.dart
├── callbacks.dart
├── typedefs.dart
├── globals.dart
└── metadata.dart
```

Then:

```dart
// package:react_web/web.dart
export 'src/generated/web/dom.dart';
export 'src/generated/web/html.dart';
export 'src/generated/web/storage.dart';
// Generated export list containing
// every specification module.
```

Users can use the complete surface:

```dart
import 'package:react_web/web.dart';
```

Or a focused library:

```dart
import 'package:react_web/storage.dart';
```

Both export lists should themselves be generated from the snapshot—not manually maintained.

## Completeness needs to be a hard invariant

Generate a report alongside the code:

```json
{
  "sourceRevision":
    "dart-lang/web@<pinned-sha>",

  "definitions": {
    "source": 1850,
    "emitted": 1850,
    "opaque": 12,
    "dropped": 0
  },

  "members": {
    "source": 16240,
    "emitted": 16240,
    "opaque": 43,
    "dropped": 0
  },

  "kinds": {
    "interface": {
      "source": 1100,
      "emitted": 1100
    },
    "dictionary": {
      "source": 390,
      "emitted": 390
    },
    "enum": {
      "source": 210,
      "emitted": 210
    }
  }
}
```

CI fails when:

```text
dropped definitions > 0
dropped members > 0
unresolved references > 0
duplicate emitted names > 0
generated output differs
package:web mapping is missing
```

Also record why something is opaque:

```json
{
  "opaqueLowerings": [
    {
      "api":
        "SomeInterface.someMember",
      "reason":
        "Unsupported nested union"
    }
  ]
}
```

Opaque is visible technical debt. Missing is invisible technical debt.

## Concrete refactor

The model-builder entrypoint should become roughly:

```dart
final snapshot =
    PackageWebIdlSnapshot.load(
  webApisJson,
);

final model =
    CompleteWebModelBuilder(
  snapshot: snapshot,
  packageWebMappings:
      PackageWebMappings.load(
    mappingFiles,
  ),
).build();

FullWebSurfaceEmitter(
  model,
).emit();

BrowserAdapterEmitter(
  model,
).emit();

SsrStubEmitter(
  model,
).emit();

ReactHostEmitter(
  model,
  elements:
      snapshot.elements,
).emit();

CompletenessVerifier(
  snapshot: snapshot,
  model: model,
).verify();
```

Notice that only `ReactHostEmitter` consumes the element mapping as a subset. Everything else consumes the complete model.

## What to delete or narrow

Remove from the full-model path:

```text
reachability.dart
roots.json
milestone element lists
selected interface roots
reachable type closure
interface inclusion policies
```

They may remain only where needed for React host factory concerns.

Change overlays from:

```yaml
typePolicies:
  Storage:
    exposed: true
```

to representation-only corrections:

```yaml
typePolicies:
  SomeIDLType:
    lowering: opaqueUnion
```

An overlay must never decide whether an IDL definition exists in `react_web`.

## Final model

```text
Pinned package:web revision
        ↓
package:web's own normalized IDL
and mappings
        ↓
complete neutral model
(no reachability filter)
        ↓
┌──────────────────────────────┐
│ Full react_web API surface   │
│ Browser package:web adapters │
│ Generated SSR throwing stubs │
│ React host factories         │
│ SSR host metadata            │
└──────────────────────────────┘
```

So yes: **rip through the complete snapshot**. `localStorage` should appear naturally because `Window.localStorage` and `Storage` are in that snapshot, not because the generator knows to search for them. The same must be true for every other API in the pinned `package:web` corpus.

[1]: https://github.com/dart-lang/web "GitHub - dart-lang/web: Lightweight browser API bindings built around JS static interop. · GitHub"
[2]: https://dart.dev/interop/js-interop/package-web "Migrate to package:web"
