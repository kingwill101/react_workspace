# Full callback design: one descriptor, one trampoline

The new design removes this limitation:

```dart
void Function() c => _callback0ToJS(c),
void Function(int) c => _callback1IntToJS(c),
```

Your current converter supports callbacks by explicitly matching known Dart signatures, so every new combination would otherwise require another branch.

The replacement architecture is:

```text
Typed Dart callback
        ↓
one pure-Dart ReactCallback descriptor
        ↓
one JavaScript (...args) trampoline
        ↓
one statically typed Dart dispatcher
        ↓
decode arguments using signature metadata
        ↓
invoke callback
        ↓
encode result
```

There will be:

* No `ReactCallback0`, `ReactCallback1`, `ReactCallback2`.
* No runtime matching of `void Function(String)`, `void Function(int)`, etc.
* No `.toJS` calls in application components.
* No `dart:js_interop` outside the low-level interop packages.
* No callback arity limit imposed by Dart wrapper classes.
* No dynamic `.toJS` invocation.

Dart’s `Function.toJS` requires the function’s static signature to be known, and the number of arguments forwarded from JavaScript is determined by that static type. That is why `(function as dynamic).toJS` failed and why a single statically typed dispatcher is the correct boundary. ([Dart API Docs][1])

---

## 1. Final package responsibilities

| Package                | Responsibility                                                         |     JS interop |
| ---------------------- | ---------------------------------------------------------------------- | -------------: |
| `react`                | Nodes, callback descriptors, signatures, event interfaces, annotations |             No |
| `react_js`             | Callback trampoline, JS converters, renderer, registry                 |            Yes |
| `react_dom`            | Browser mounting and hydration                                         |            Yes |
| `react_server`         | SSR bridge and render registration                                     |            Yes |
| `react_codegen`        | Analyze callback types and emit bridge code                            | Generator only |
| Application components | Pure Dart React component code                                         |             No |

The application still looks like:

```dart
import 'package:react/react.dart';

@reactComponent
ReactNode Counter(CounterProps props) {
  return button(
    onClick: () {
      // Pure Dart.
    },
    children: const [
      Text('+1'),
    ],
  );
}
```

---

# 2. Pure-Dart callback representation

Add:

```text
packages/react/lib/src/callback.dart
```

## Value kinds

Use one small set of value kinds rather than callback types:

```dart
enum ReactValueKind {
  void_,
  any,
  string,
  integer,
  number,
  boolean,
  reactNode,
  syntheticEvent,
  object,
}
```

For nullability and custom codecs, use a record:

```dart
typedef ReactValueSpec = ({
  ReactValueKind kind,
  bool nullable,
  String? codecId,
});
```

Create constants for common types:

```dart
const reactVoid = (
  kind: ReactValueKind.void_,
  nullable: false,
  codecId: null,
);

const reactAny = (
  kind: ReactValueKind.any,
  nullable: true,
  codecId: null,
);

const reactString = (
  kind: ReactValueKind.string,
  nullable: false,
  codecId: null,
);

const reactNullableString = (
  kind: ReactValueKind.string,
  nullable: true,
  codecId: null,
);

const reactInt = (
  kind: ReactValueKind.integer,
  nullable: false,
  codecId: null,
);

const reactBool = (
  kind: ReactValueKind.boolean,
  nullable: false,
  codecId: null,
);

const reactSyntheticEvent = (
  kind: ReactValueKind.syntheticEvent,
  nullable: false,
  codecId: null,
);
```

## Callback signature

The signature is also a record:

```dart
typedef ReactCallbackSignature = ({
  List<ReactValueSpec> positional,
  ReactValueSpec result,
  bool asynchronous,
});
```

Example:

```dart
const onChangeSignature = (
  positional: [reactInt],
  result: reactVoid,
  asynchronous: false,
);
```

A two-argument callback becomes:

```dart
const compareSignature = (
  positional: [
    reactString,
    reactInt,
  ],
  result: reactBool,
  asynchronous: false,
);
```

No callback class is generated for either signature.

## One callback descriptor

Do not store only the raw `Function`. Store a normalized invoker that accepts a list:

```dart
typedef ReactCallbackInvoker =
    Object? Function(List<Object?> arguments);

final class ReactCallback {
  final ReactCallbackSignature signature;
  final ReactCallbackInvoker invoke;
  final String? debugName;

  const ReactCallback({
    required this.signature,
    required this.invoke,
    this.debugName,
  });
}
```

This avoids depending on `Function.apply`, gives you better validation, and lets generated code perform typed casts explicitly.

Example descriptor:

```dart
ReactCallback(
  debugName: 'Counter.onChange',
  signature: const (
    positional: [reactInt],
    result: reactVoid,
    asynchronous: false,
  ),
  invoke: (arguments) {
    onChange(arguments[0] as int);
    return null;
  },
);
```

---

# 3. One JavaScript rest-argument trampoline

Add a tiny JavaScript module:

```text
packages/react_js/js/callback_trampoline.mjs
```

```javascript
globalThis.__dartReactCallbacks ??= {};

globalThis.__dartReactCallbacks.create = function create(
  reference,
  dispatch
) {
  return function (...args) {
    return dispatch(reference, args);
  };
};
```

This JavaScript function accepts any number of arguments:

```javascript
callback()
callback(event)
callback(value, index)
callback(a, b, c, d, e)
```

Every invocation is normalized into:

```javascript
dispatch(reference, argsArray)
```

Dart therefore exports only one fixed function signature.

---

# 4. Passing the Dart callback through JavaScript

Use `ExternalDartReference<ReactCallback>`.

Dart defines `ExternalDartReference` as an opaque reference to a Dart object that can be passed through JavaScript and converted back inside the same Dart runtime. It is explicitly intended for external interop members and callbacks. ([Dart API Docs][2])

In `react_js`:

```dart
import 'dart:js_interop';

import 'package:react/react.dart';

@JS('__dartReactCallbacks.create')
external JSFunction _createCallback(
  ExternalDartReference<ReactCallback> reference,
  JSExportedDartFunction dispatcher,
);
```

The descriptor itself remains a normal Dart object. JavaScript receives only an opaque reference.

---

# 5. One Dart dispatcher

Create:

```text
packages/react_js/lib/src/callback_bridge.dart
```

```dart
import 'dart:js_interop';

import 'package:react/react.dart';

JSAny? _dispatchReactCallback(
  ExternalDartReference<ReactCallback> reference,
  JSArray<JSAny?> rawArguments,
) {
  final callback = reference.toDartObject;
  final rawList = rawArguments.toDart;

  final signature = callback.signature;
  final decoded = <Object?>[];

  for (var index = 0;
      index < signature.positional.length;
      index++) {
    final rawValue = index < rawList.length
        ? rawList[index]
        : null;

    decoded.add(
      decodeReactValue(
        signature.positional[index],
        rawValue,
      ),
    );
  }

  final result = callback.invoke(decoded);

  return encodeReactValue(
    signature.result,
    result,
  );
}
```

Create the JS-callable dispatcher once:

```dart
final JSExportedDartFunction _dispatchReactCallbackJS =
    _dispatchReactCallback.toJS;
```

Then expose:

```dart
JSFunction callbackToJS(
  ReactCallback callback,
) {
  return _createCallback(
    callback.toExternalReference,
    _dispatchReactCallbackJS,
  );
}
```

The important part is that `.toJS` is called only here:

```dart
_dispatchReactCallback.toJS
```

Its static signature is always known:

```dart
JSAny? Function(
  ExternalDartReference<ReactCallback>,
  JSArray<JSAny?>,
)
```

The user callback’s arity no longer affects `.toJS`.

---

# 6. Centralized callback argument codecs

Put encoding and decoding into one registry.

## Built-in decoding

```dart
Object? decodeReactValue(
  ReactValueSpec spec,
  JSAny? value,
) {
  if (value == null || value.isUndefined) {
    if (spec.nullable) {
      return null;
    }

    throw ArgumentError(
      'Received null or undefined for '
      '${spec.kind.name}.',
    );
  }

  return switch (spec.kind) {
    ReactValueKind.void_ => null,

    ReactValueKind.any => value,

    ReactValueKind.string =>
      (value as JSString).toDart,

    ReactValueKind.integer =>
      (value as JSNumber).toDartInt,

    ReactValueKind.number =>
      (value as JSNumber).toDartDouble,

    ReactValueKind.boolean =>
      (value as JSBoolean).toDart,

    ReactValueKind.reactNode =>
      throw UnsupportedError(
        'Decoding ReactNode arguments is not implemented.',
      ),

    ReactValueKind.syntheticEvent =>
      decodeSyntheticEvent(value as JSObject),

    ReactValueKind.object =>
      ReactCodecRegistry.decode(
        spec.codecId!,
        value,
      ),
  };
}
```

## Built-in encoding

```dart
JSAny? encodeReactValue(
  ReactValueSpec spec,
  Object? value,
) {
  if (value == null) {
    if (spec.nullable ||
        spec.kind == ReactValueKind.void_) {
      return null;
    }

    throw ArgumentError(
      'Callback returned null for non-nullable '
      '${spec.kind.name}.',
    );
  }

  return switch (spec.kind) {
    ReactValueKind.void_ => null,
    ReactValueKind.any => toReactJS(value),
    ReactValueKind.string => (value as String).toJS,
    ReactValueKind.integer => (value as int).toJS,
    ReactValueKind.number => (value as num).toDouble().toJS,
    ReactValueKind.boolean => (value as bool).toJS,
    ReactValueKind.reactNode =>
      toReactJS(value as ReactNode),
    ReactValueKind.syntheticEvent =>
      throw UnsupportedError(
        'Synthetic events cannot be callback results.',
      ),
    ReactValueKind.object =>
      ReactCodecRegistry.encode(
        spec.codecId!,
        value,
      ),
  };
}
```

## Custom codecs

Generated classes can use codec IDs:

```dart
const userSpec = (
  kind: ReactValueKind.object,
  nullable: false,
  codecId: 'package:app/models.dart#User',
);
```

The bridge registry can store:

```dart
typedef ReactValueEncoder =
    JSAny? Function(Object? value);

typedef ReactValueDecoder =
    Object? Function(JSAny? value);

final class ReactCodec {
  final ReactValueEncoder encode;
  final ReactValueDecoder decode;

  const ReactCodec({
    required this.encode,
    required this.decode,
  });
}
```

```dart
abstract final class ReactCodecRegistry {
  static final _codecs = <String, ReactCodec>{};

  static void register(
    String id,
    ReactCodec codec,
  ) {
    _codecs[id] = codec;
  }

  static JSAny? encode(
    String id,
    Object? value,
  ) {
    final codec = _codecs[id];

    if (codec == null) {
      throw StateError(
        'No React codec registered for "$id".',
      );
    }

    return codec.encode(value);
  }

  static Object? decode(
    String id,
    JSAny? value,
  ) {
    final codec = _codecs[id];

    if (codec == null) {
      throw StateError(
        'No React codec registered for "$id".',
      );
    }

    return codec.decode(value);
  }
}
```

---

# 7. Update `toReactJS`

The runtime converter becomes simpler.

Remove:

```dart
void Function() c => _callback0ToJS(c),
void Function(int) c => _callback1IntToJS(c),
```

Replace them with one descriptor case:

```dart
JSAny? toReactJS(Object? value) => switch (value) {
      null => null,
      String string => string.toJS,
      bool boolean => boolean.toJS,
      int integer => integer.toJS,
      double number => number.toJS,

      ReactNode node =>
        renderNode(node),

      ReactCallback callback =>
        callbackToJS(callback),

      List values => <JSAny?>[
          for (final value in values)
            toReactJS(value),
        ].toJS,

      Map<String, Object?> map =>
        mapToJS(map),

      JSAny jsValue => jsValue,

      Function function =>
        throw UnsupportedError(
          'Raw Dart functions cannot be used as '
          'React properties. Use a typed element '
          'factory or ReactCallback. Received '
          '${function.runtimeType}.',
        ),

      _ => throw UnsupportedError(
          'Unsupported React value: '
          '${value.runtimeType}.',
        ),
    };
```

The raw `Function` error is intentional. It ensures that the original dynamic `.toJS` bug cannot quietly return.

---

# 8. Typed intrinsic factories hide everything

Application authors should rarely construct `ReactCallback` manually.

## Zero-argument click handler

```dart
ReactNode button({
  void Function()? onClick,
  bool? disabled,
  String? className,
  String? key,
  List<ReactNode> children = const [],
}) {
  return Intrinsic(
    'button',
    props: {
      if (onClick != null)
        'onClick': ReactCallback(
          debugName: 'button.onClick',
          signature: const (
            positional: [],
            result: reactVoid,
            asynchronous: false,
          ),
          invoke: (_) {
            onClick();
            return null;
          },
        ),
      if (disabled != null)
        'disabled': disabled,
      if (className != null)
        'className': className,
    },
    children: children,
    key: key,
  );
}
```

React will supply an event argument, but the callback signature expects zero arguments, so the dispatcher ignores the extra JS value.

## Event-aware handler

```dart
ReactNode eventButton({
  void Function(SyntheticEvent event)? onClick,
  List<ReactNode> children = const [],
}) {
  return Intrinsic(
    'button',
    props: {
      if (onClick != null)
        'onClick': ReactCallback(
          debugName: 'button.onClick',
          signature: const (
            positional: [
              reactSyntheticEvent,
            ],
            result: reactVoid,
            asynchronous: false,
          ),
          invoke: (arguments) {
            onClick(
              arguments[0] as SyntheticEvent,
            );
            return null;
          },
        ),
    },
    children: children,
  );
}
```

You could also standardize `button` on an event-aware callback:

```dart
ReactNode button({
  void Function(SyntheticEvent event)? onClick,
  ...
})
```

Users who do not need the event simply write:

```dart
button(
  onClick: (_) {
    increment();
  },
);
```

---

# 9. Keep browser events abstract

`package:react` should not expose `JSObject`.

Define a pure-Dart contract:

```dart
abstract interface class SyntheticEventHandle {
  void preventDefault();

  void stopPropagation();

  bool get defaultPrevented;
}

final class SyntheticEvent {
  final SyntheticEventHandle _handle;

  const SyntheticEvent(this._handle);

  void preventDefault() =>
      _handle.preventDefault();

  void stopPropagation() =>
      _handle.stopPropagation();

  bool get defaultPrevented =>
      _handle.defaultPrevented;
}
```

Implement the handle in `react_js`:

```dart
final class JsSyntheticEventHandle
    implements SyntheticEventHandle {
  final JSObject value;

  JsSyntheticEventHandle(this.value);

  @override
  void preventDefault() {
    value.callMethod('preventDefault'.toJS);
  }

  @override
  void stopPropagation() {
    value.callMethod('stopPropagation'.toJS);
  }

  @override
  bool get defaultPrevented {
    return (
      value.getProperty(
        'defaultPrevented'.toJS,
      ) as JSBoolean
    ).toDart;
  }
}
```

Decoder:

```dart
SyntheticEvent decodeSyntheticEvent(
  JSObject value,
) {
  return SyntheticEvent(
    JsSyntheticEventHandle(value),
  );
}
```

Later you can add:

```text
MouseEvent
KeyboardEvent
InputEvent
FormEvent
FocusEvent
PointerEvent
```

as pure-Dart APIs backed by JS implementations.

---

# 10. Code generation for component callback props

The generator already knows the full `FunctionType` for component props and currently generates signature-specific wrapper code directly.

Keep using the analyzer’s `FunctionType`, but generate a `ReactCallback` descriptor rather than calling `.toJS` on each generated closure.

Given:

```dart
@reactComponent
ReactNode Counter(
  ({
    String title,
    int initialCount,
    void Function(int)? onChange,
  }) props,
) {
  // ...
}
```

## Generated Dart-to-JS conversion

Generate:

```dart
JSObject _Counter_toJS(
  ({
    String title,
    int initialCount,
    void Function(int)? onChange,
  }) props,
) {
  final object = JSObject();

  object.setProperty(
    'title'.toJS,
    props.title.toJS,
  );

  object.setProperty(
    'initialCount'.toJS,
    props.initialCount.toJS,
  );

  if (props.onChange case final onChange?) {
    final descriptor = ReactCallback(
      debugName: 'Counter.onChange',
      signature: const (
        positional: [
          reactInt,
        ],
        result: reactVoid,
        asynchronous: false,
      ),
      invoke: (arguments) {
        onChange(arguments[0] as int);
        return null;
      },
    );

    object.setProperty(
      'onChange'.toJS,
      callbackToJS(descriptor),
    );
  }

  return object;
}
```

The generator creates an invocation adapter, but it does not generate a new callback class.

## Generated JavaScript-to-Dart conversion

This direction still needs a local typed Dart closure because `Counter` expects:

```dart
void Function(int)?
```

Generate:

```dart
final rawOnChange =
    js.getProperty('onChange'.toJS);

final void Function(int)? onChange =
    rawOnChange == null ||
            rawOnChange.isUndefined
        ? null
        : (int value) {
            (
              rawOnChange as JSFunction
            ).callAsFunction(
              null,
              value.toJS,
            );
          };
```

This is normal generated adapter code, not a public callback-type hierarchy.

The distinction is:

```text
Bad:
  Generate Callback0, Callback1, Callback2 classes.

Good:
  Generate a small local adapter closure for each actual prop.
```

Records remove the need for callback class families, but code generation still needs to emit the specific argument casts and codecs for each declared callback.

---

# 11. Generator callback analysis

Introduce a normalized internal model:

```dart
final class CallbackModel {
  final bool nullable;
  final List<DartType> positionalParameters;
  final DartType returnType;
  final bool asynchronous;
  final String debugName;

  const CallbackModel({
    required this.nullable,
    required this.positionalParameters,
    required this.returnType,
    required this.asynchronous,
    required this.debugName,
  });
}
```

Analyze:

```dart
CallbackModel analyzeCallback(
  String component,
  String field,
  FunctionType function,
) {
  final namedParameters = function.formalParameters
      .where((parameter) => parameter.isNamed)
      .toList();

  if (namedParameters.isNotEmpty) {
    throw InvalidGenerationSourceError(
      '$component.$field uses named callback '
      'parameters, which are not supported.',
    );
  }

  return CallbackModel(
    nullable: function.nullabilitySuffix ==
        NullabilitySuffix.question,
    positionalParameters: [
      for (final parameter
          in function.formalParameters)
        parameter.type,
    ],
    returnType: function.returnType,
    asynchronous:
        function.returnType is InterfaceType &&
        (
          function.returnType as InterfaceType
        ).element.name == 'Future',
    debugName: '$component.$field',
  );
}
```

Then create:

```dart
String emitValueSpec(DartType type);
String emitCallbackDescriptor(CallbackModel model);
String emitJSFunctionProxy(CallbackModel model);
```

This is cleaner than maintaining all logic inside `_toJSForFn` and `_fromJSForFn`, which currently independently construct function wrappers.

---

# 12. Raw `Intrinsic` remains an escape hatch

Users can still write:

```dart
Intrinsic(
  'custom-widget',
  props: {
    'onReady': ReactCallback(
      debugName: 'custom-widget.onReady',
      signature: const (
        positional: [
          reactString,
          reactInt,
        ],
        result: reactBool,
        asynchronous: false,
      ),
      invoke: (arguments) {
        return handleReady(
          arguments[0] as String,
          arguments[1] as int,
        );
      },
    ),
  },
);
```

They cannot put a raw function directly into the map:

```dart
// Deliberately unsupported:
props: {
  'onReady': (value) {},
}
```

The typed DOM factories hide the descriptor for normal use.

---

# 13. Callback identity and optional caching

Each call to `callbackToJS` creates a new JavaScript function.

That is acceptable initially because inline React callbacks commonly have new identities on each render anyway. For stable callback identities later, add caching inside `react_js`:

```dart
final Expando<JSFunction> _callbackCache =
    Expando<JSFunction>(
  'ReactCallbackJSFunction',
);

JSFunction callbackToJS(
  ReactCallback callback,
) {
  final cached = _callbackCache[callback];

  if (cached != null) {
    return cached;
  }

  final created = _createCallback(
    callback.toExternalReference,
    _dispatchReactCallbackJS,
  );

  _callbackCache[callback] = created;
  return created;
}
```

This only helps when the same `ReactCallback` descriptor object is reused.

Later, hook-backed APIs could preserve descriptors:

```dart
final callback = useCallback(
  () => save(),
  [documentId],
);
```

But callback identity optimization should come after correctness.

---

# 14. SSR behavior

The callback reference must never cross the Dart server-to-browser boundary.

The flow is:

```text
Server Dart component
    ↓
compiled SSR JavaScript runtime
    ↓
creates callback descriptor/reference locally
    ↓
ReactDOMServer renders HTML
    ↓
callbacks are not serialized into HTML
    ↓
browser runs its own Dart bundle
    ↓
recreates callback descriptors
    ↓
hydrateRoot attaches client behavior
```

React’s server APIs render React trees into HTML, while `hydrateRoot` attaches the client component logic to that server-generated HTML. ([React][3])

The serialized initial state should contain only data:

```json
{
  "title": "Dashboard",
  "initialCount": 0
}
```

Never:

```json
{
  "onChange": "callback reference"
}
```

`ExternalDartReference` is local to its Dart runtime and is intended to pass a Dart object through JavaScript within that runtime. It is not a cross-process or network reference. ([Dart API Docs][2])

---

# 15. Async callback extension

Keep asynchronous support in the signature now:

```dart
typedef ReactCallbackSignature = ({
  List<ReactValueSpec> positional,
  ReactValueSpec result,
  bool asynchronous,
});
```

MVP behavior:

```dart
if (signature.asynchronous) {
  throw UnsupportedError(
    'Async React callback results are not '
    'implemented yet.',
  );
}
```

Later, the dispatcher can convert a `Future` into a JavaScript promise.

This does not require changing the descriptor or trampoline architecture.

---

# 16. Error diagnostics

The bridge should validate argument counts and types.

```dart
JSAny? _dispatchReactCallback(
  ExternalDartReference<ReactCallback> reference,
  JSArray<JSAny?> rawArguments,
) {
  final callback = reference.toDartObject;
  final rawList = rawArguments.toDart;
  final expected =
      callback.signature.positional.length;

  if (rawList.length < expected) {
    throw ArgumentError(
      '${callback.debugName ?? 'React callback'} '
      'expected $expected arguments but received '
      '${rawList.length}.',
    );
  }

  // Decode and invoke...
}
```

Extra arguments should be ignored. This lets a zero-argument Dart click callback work even though React supplies an event object.

Decoding failures should include:

```text
Counter.onChange argument 0 expected int,
but JavaScript supplied String.
```

That requires passing the callback name and parameter index into the decoder.

---

# 17. Migration plan

## Commit 1: Pure descriptor model

Add to `react`:

```text
callback.dart
ReactValueKind
ReactValueSpec
ReactCallbackSignature
ReactCallback
```

No runtime change yet.

## Commit 2: Variadic JavaScript trampoline

Add:

```text
packages/react_js/js/callback_trampoline.mjs
packages/react_js/lib/src/callback_bridge.dart
```

Test direct callback dispatch with zero, one, and multiple arguments.

## Commit 3: Replace runtime function matching

Remove:

```dart
void Function()
void Function(int)
```

from `toReactJS`.

Add:

```dart
ReactCallback callback => callbackToJS(callback)
```

Make raw `Function` values throw.

## Commit 4: Typed button factory

Change Counter from:

```dart
Intrinsic(
  'button',
  props: {
    'onClick': () {},
  },
);
```

to:

```dart
button(
  onClick: () {},
);
```

The factory creates the descriptor.

## Commit 5: Generator integration

Update generated component callback props to use:

```dart
ReactCallback(
  signature: ...,
  invoke: ...,
)
```

Keep generated JS-to-Dart typed proxy closures.

## Commit 6: Synthetic events

Add the pure event interface and JS-backed implementation.

## Commit 7: Custom codec registry

Support generated model codecs using `codecId`.

## Commit 8: Async results and caching

Add Future-to-Promise handling and optional callback wrapper caching.

---

# 18. Acceptance tests

## Callback arity

Test:

```text
0 arguments
1 argument
2 arguments
5 arguments
extra JavaScript arguments
too few JavaScript arguments
```

No new runtime class should be needed for any arity.

## Primitive types

Test:

```text
String
String?
int
double
bool
Object?
```

## Component callbacks

Test:

```dart
void Function()
void Function(int)
void Function(String, int)
bool Function(String)
```

## DOM callbacks

Test:

```text
button onClick
input onInput
form onSubmit
keyboard onKeyDown
```

## SSR and hydration

Verify:

1. Server rendering succeeds with callbacks present.
2. Callback references do not appear in initial JSON.
3. Client hydration produces no mismatch.
4. Click handlers execute after hydration.
5. `useState` updates correctly.
6. Parent component callbacks receive child values.

## Optimization builds

Run all callback tests with:

```bash
dart compile js -O0
dart compile js -O2
dart compile wasm
```

The JS interop API is designed to provide a shared abstraction for JavaScript and Wasm compilation, although runtime representations differ, so code should rely on static conversions rather than runtime checks involving JS types. ([Dart API Docs][4])

---

# 19. Final Counter authoring experience

Application code remains pure and ordinary:

```dart
import 'package:react/react.dart';

@reactComponent
ReactNode Counter(
  ({
    String title,
    int initialCount,
    String? subtitle,
    void Function(int)? onChange,
  }) props,
) {
  final (count, setCount) =
      useState(props.initialCount);

  final (effectRan, setEffectRan) =
      useState(false);

  useEffect(() {
    setEffectRan(true);
  }, const []);

  return div(
    children: [
      Text(props.title),
      Text('Count: $count'),
      button(
        onClick: () {
          final next = count + 1;

          setCount(next);
          props.onChange?.call(next);
        },
        children: const [
          Text('+1'),
        ],
      ),
      if (props.subtitle case final subtitle?)
        Text(subtitle),
      Text(
        effectRan
            ? 'effect:ran'
            : 'effect:pending',
      ),
    ],
  );
}
```

Internally:

```text
onClick Dart closure
      ↓
ReactCallback descriptor
      ↓
ExternalDartReference
      ↓
JS (...args) function
      ↓
single Dart dispatcher
      ↓
callback.invoke(decodedArguments)
```

## Final design decision

Use records for:

```text
ReactValueSpec
ReactCallbackSignature
```

Use one class for:

```text
ReactCallback
```

Use generated local closures for:

```text
typed component prop adapters
```

Use one JavaScript trampoline for:

```text
every callback arity
```

That gives the project a scalable callback system without generating an artificial family of callback types.

[1]: https://api.dart.dev/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html?utm_source=chatgpt.com "toJS property - FunctionToJSExportedDartFunction extension - dart:js_interop library - Dart API"
[2]: https://api.dart.dev/dart-js_interop/ExternalDartReference-extension-type.html?utm_source=chatgpt.com "ExternalDartReference extension type - dart:js_interop library - Dart API"
[3]: https://react.dev/reference/react-dom/client/hydrateRoot?utm_source=chatgpt.com "hydrateRoot – React"
[4]: https://api.dart.dev/dart-js_interop/?utm_source=chatgpt.com "dart:js_interop library - Dart API"
