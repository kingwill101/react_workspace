`package:react` should **not define web-specific callback interfaces** such as `MouseEvent`, `HTMLButtonElement`, or `SyntheticEvent`.

It should define the renderer-neutral machinery needed to transport and invoke callbacks. The generated `react_web` package then uses that machinery to expose ordinary Dart callbacks whose arguments are typed with `package:web`.

```text
package:react
    generic callback descriptor
    generic value metadata
    generic ref callback typedef
            ↑
package:react_web
    ReactMouseEvent<web.HTMLButtonElement>
    ReactKeyboardEvent<web.HTMLInputElement>
    ReactRefCallback<web.HTMLButtonElement>
    generated button(), input(), form()
            ↑
package:react_js
    turns descriptors into JS functions
    passes JS host values through unchanged
```

# 1. Correct the current core model

The current `package:react` contains:

```dart
ReactValueKind.syntheticEvent
SyntheticEventHandle
SyntheticEvent
```

Those are browser concepts and should move out of the renderer-neutral core.   

Replace the browser-specific kind with a generic **host value**:

```dart
enum ReactValueKind {
  void_,
  any,
  string,
  integer,
  number,
  boolean,
  reactNode,

  /// A value owned by a renderer.
  ///
  /// Examples:
  /// - a browser Event or Element
  /// - a React synthetic event object
  /// - a future native-renderer handle
  hostValue,

  /// Structured application data converted through a registered codec.
  encodedObject,
}
```

The distinction is:

```text
hostValue
    Passed through by the renderer.
    Not serialized or structurally converted.

encodedObject
    Converted using a codec.
    Used for application models such as User or Track.
```

# 2. Renderer-neutral callback metadata

Update `ReactValueSpec`:

```dart
typedef ReactValueSpec = ({
  ReactValueKind kind,
  bool nullable,

  /// Renderer that owns this value.
  ///
  /// Examples: "web", "test".
  String? hostNamespace,

  /// Stable type identifier used for diagnostics and generated adapters.
  ///
  /// Example:
  /// package:react_web/events.dart#ReactMouseEvent
  String? typeId,

  /// Codec for structured application objects.
  String? codecId,
});
```

The callback signature remains generic:

```dart
typedef ReactCallbackSignature = ({
  List<ReactValueSpec> positional,
  ReactValueSpec result,
  bool asynchronous,
});
```

And the descriptor remains:

```dart
final class ReactCallback {
  final ReactCallbackSignature signature;

  final Object? Function(
    List<Object?> arguments,
  ) invoke;

  final String? debugName;

  const ReactCallback({
    required this.signature,
    required this.invoke,
    this.debugName,
  });
}
```

This contains no `package:web` or JS interop types.

# 3. Generic ref callback in `package:react`

A ref callback is generic enough to live in core:

```dart
typedef ReactRefCallback<T> =
    void Function(T? value);
```

This does not make `package:react` web-specific.

Web can instantiate it as:

```dart
ReactRefCallback<
  web.HTMLButtonElement
>
```

A future renderer could instantiate it with one of its own host types.

Use the name `ReactRefCallback<T>`, not `ReactRef<T>`, because React may later support mutable/object refs as a separate abstraction:

```dart
sealed class ReactRef<T> {}

final class CallbackRef<T>
    implements ReactRef<T> {
  final ReactRefCallback<T> callback;
}

final class MutableRef<T>
    implements ReactRef<T> {
  T? current;
}
```

That does not need to be implemented during W1.

# 4. Web types belong in `react_web`

The generated web package imports:

```dart
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:react/react.dart';
```

`package:web` represents browser interfaces as extension types over JavaScript objects. For example, its generated `UIEvent` is an extension type implementing `Event` and `JSObject`.

Dart extension types provide a static interface over their representation without allocating an ordinary wrapper object, which makes them suitable for this boundary. ([Dart][1])

## Base React event

```dart
extension type ReactSyntheticEvent
    .fromJS(JSObject _value)
    implements JSObject {
  external web.EventTarget get target;

  external web.EventTarget get currentTarget;

  external web.Event get nativeEvent;

  external bool get bubbles;

  external bool get cancelable;

  external bool get defaultPrevented;

  external bool get isTrusted;

  external void preventDefault();

  external void stopPropagation();
}
```

## Mouse event

```dart
extension type ReactMouseEvent<
  T extends web.EventTarget
>.fromJS(JSObject _value)
    implements JSObject {
  external web.EventTarget get target;

  external web.MouseEvent get nativeEvent;

  external double get clientX;

  external double get clientY;

  external double get screenX;

  external double get screenY;

  external int get button;

  external int get buttons;

  external bool get altKey;

  external bool get ctrlKey;

  external bool get metaKey;

  external bool get shiftKey;

  external bool get defaultPrevented;

  external void preventDefault();

  external void stopPropagation();

  /// Typed view of React's currentTarget.
  T get currentTarget {
    return _readCurrentTarget(_value) as T;
  }
}
```

The non-external getter can reinterpret the property using the generated generic target type:

```dart
import 'dart:js_interop_unsafe';

web.EventTarget _readCurrentTarget(
  JSObject event,
) {
  return event.getProperty(
    'currentTarget'.toJS,
  ) as web.EventTarget;
}
```

This needs explicit `-O0`, `-O2`, and Wasm tests because Dart’s JS interop types provide static guarantees, while underlying runtime representations depend on the compiler backend. ([Dart API Docs][2])

# 5. Generated callback signatures

The generated `button()` API exposes a normal Dart function:

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

The public API uses typed Dart callbacks. The internal host props contain `ReactCallback` descriptors.

# 6. Generated event callback adapter

The generator emits the descriptor:

```dart
const ReactValueSpec _buttonMouseEventSpec = (
  kind: ReactValueKind.hostValue,
  nullable: false,
  hostNamespace: 'web',
  typeId:
      'package:react_web/events.dart'
      '#ReactMouseEvent<HTMLButtonElement>',
  codecId: null,
);
```

Then:

```dart
ReactCallback _buttonOnClick(
  ButtonClickHandler callback,
) {
  return ReactCallback(
    debugName: 'button.onClick',
    signature: const (
      positional: [
        _buttonMouseEventSpec,
      ],
      result: reactVoid,
      asynchronous: false,
    ),
    invoke: (arguments) {
      final rawEvent =
          arguments[0] as JSObject;

      callback(
        ReactMouseEvent<
          web.HTMLButtonElement
        >.fromJS(rawEvent),
      );

      return null;
    },
  );
}
```

This code lives in `react_web`, so importing `JSObject` and `package:web` is allowed.

The generic core descriptor knows only:

```text
one host value arrives
it belongs to the "web" renderer
it is non-nullable
```

The generated web adapter supplies the static Dart type.

# 7. Generated ref callback adapter

A ref receives an element or `null`:

```dart
const ReactValueSpec _buttonElementRefSpec = (
  kind: ReactValueKind.hostValue,
  nullable: true,
  hostNamespace: 'web',
  typeId:
      'package:web/web.dart'
      '#HTMLButtonElement',
  codecId: null,
);
```

Adapter:

```dart
ReactCallback _buttonRef(
  ReactRefCallback<
    web.HTMLButtonElement
  > callback,
) {
  return ReactCallback(
    debugName: 'button.ref',
    signature: const (
      positional: [
        _buttonElementRefSpec,
      ],
      result: reactVoid,
      asynchronous: false,
    ),
    invoke: (arguments) {
      final value = arguments[0];

      callback(
        value == null
            ? null
            : value
                as web.HTMLButtonElement,
      );

      return null;
    },
  );
}
```

Usage:

```dart
button(
  ref: (element) {
    element?.focus();
  },
  onClick: (event) {
    final web.HTMLButtonElement button =
        event.currentTarget;

    final web.MouseEvent nativeEvent =
        event.nativeEvent;

    button.focus();

    print(
      '${nativeEvent.clientX}, '
      '${nativeEvent.clientY}',
    );
  },
);
```

No event or element is copied into a Dart class.

# 8. `react_js` host-value decoding

The JS bridge needs one generic pass-through case:

```dart
Object? decodeReactValue(
  ReactValueSpec spec,
  JSAny? value, [
  String? debugName,
  int? index,
]) {
  if (value == null ||
      value.isUndefined) {
    if (spec.nullable) {
      return null;
    }

    throw ArgumentError(
      'Received null for '
      '${spec.typeId ?? spec.kind.name}'
      '${debugName == null ? '' : ' in $debugName'}.',
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
      decodeReactNode(value),

    // Do not decode or copy it.
    // The generated host adapter supplies
    // the static extension type.
    ReactValueKind.hostValue =>
      value,

    ReactValueKind.encodedObject =>
      ReactCodecRegistry.decode(
        spec.codecId!,
        value,
      ),
  };
}
```

Encoding:

```dart
JSAny? encodeReactValue(
  ReactValueSpec spec,
  Object? value,
) {
  if (value == null) {
    if (spec.nullable ||
        spec.kind ==
            ReactValueKind.void_) {
      return null;
    }

    throw ArgumentError(
      'Cannot encode null as '
      '${spec.typeId ?? spec.kind.name}.',
    );
  }

  return switch (spec.kind) {
    ReactValueKind.void_ => null,
    ReactValueKind.any =>
      toReactJS(value),
    ReactValueKind.string =>
      (value as String).toJS,
    ReactValueKind.integer =>
      (value as int).toJS,
    ReactValueKind.number =>
      (value as num).toDouble().toJS,
    ReactValueKind.boolean =>
      (value as bool).toJS,
    ReactValueKind.reactNode =>
      toReactJS(value as ReactNode),

    ReactValueKind.hostValue =>
      value as JSAny,

    ReactValueKind.encodedObject =>
      ReactCodecRegistry.encode(
        spec.codecId!,
        value,
      ),
  };
}
```

The callback trampoline itself remains unchanged.

# 9. SSR treatment

The callback descriptor may exist in the renderer-neutral `HostNode`, but the server encoder must not convert it to a JS callback.

Generated metadata identifies events and refs:

```dart
const onClickMetadata =
    WebHostPropMetadata(
  reactName: 'onClick',
  kind: WebHostPropKind.event,
  clientOnly: true,
  ssrBehavior:
      WebSsrBehavior.eventOmitted,
);

const refMetadata =
    WebHostPropMetadata(
  reactName: 'ref',
  kind: WebHostPropKind.ref,
  clientOnly: true,
  ssrBehavior:
      WebSsrBehavior.refOmitted,
);
```

Client encoder:

```dart
if (props.onClick != null) {
  object.setProperty(
    'onClick'.toJS,
    callbackToJS(props.onClick!),
  );
}
```

Server encoder:

```dart
// onClick omitted.
// onClickCapture omitted.
// ref omitted.
```

So SSR does not:

* Construct a `web.MouseEvent`.
* Construct an `HTMLButtonElement`.
* Export event callbacks to JavaScript.
* Invoke refs.
* Serialize callbacks into HTML.

It only processes serializable props:

```text
id
className
type
disabled
aria-*
data-*
children
```

# 10. User-defined component callback props

Consider:

```dart
@reactComponent
ReactNode SaveButton(
  ({
    void Function(
      ReactMouseEvent<
        web.HTMLButtonElement
      > event,
    )? onClick,
  }) props,
) {
  return button(
    onClick: props.onClick,
    children: const [
      Text('Save'),
    ],
  );
}
```

The component generator must classify the event parameter as a host value.

Do not hardcode every `package:web` type into `react_codegen`. Add a value-type resolver:

```dart
abstract interface class ReactValueTypeResolver {
  ReactValueSpecModel? resolve(
    DartType type,
  );
}
```

Base resolver:

```text
String
int
double
bool
ReactNode
custom codecs
```

Web resolver:

```text
package:web extension types
react_web event extension types
JSObject-based host values
```

Composition:

```dart
ReactCompiler(
  valueTypeResolvers: [
    CoreValueTypeResolver(),
    WebValueTypeResolver(),
  ],
);
```

`WebValueTypeResolver` can recognize:

```text
package:web/web.dart#HTMLButtonElement
package:web/web.dart#MouseEvent
package:react_web/events.dart#ReactMouseEvent
```

and return:

```dart
ReactValueSpecModel(
  kind: ReactValueKind.hostValue,
  nullable: type.isNullable,
  hostNamespace: 'web',
  typeId: canonicalTypeId(type),
);
```

This keeps web knowledge out of the core model while still allowing web-compatible types in component props.

# 11. Exact package ownership

## `react`

```text
ReactCallback
ReactCallbackSignature
ReactValueSpec
ReactValueKind.hostValue
ReactRefCallback<T>
HostNode
HostType
```

Remove:

```text
ReactValueKind.syntheticEvent
SyntheticEventHandle
SyntheticEvent
```

## `react_web`

```text
ReactSyntheticEvent
ReactMouseEvent<T>
ReactKeyboardEvent<T>
ReactInputEvent<T>
ReactFocusEvent<T>
ReactFormEvent<T>
ReactPointerEvent<T>

generated HTML factories
generated event adapters
generated ref adapters
web host metadata
```

## `react_js`

```text
callbackToJS
invokeJSCallback
hostValue pass-through
client prop encoding
```

## `react_server`

```text
server prop encoding
event omission
ref omission
SSR component registry
```

## `react_web_generator`

```text
Web IDL → package:web type mapping
React event mapping
event adapter generation
ref adapter generation
client metadata
SSR metadata
```

# End-to-end example

```text
User writes:

void Function(
  ReactMouseEvent<HTMLButtonElement>
)

        ↓

react_web factory creates:

ReactCallback(
  positional: [web hostValue],
  invoke: typed adapter,
)

        ↓ browser

react_js creates JS (...args) callback

        ↓ React invokes

JS event object

        ↓

react_js passes raw hostValue unchanged

        ↓

generated adapter reinterprets it as:

ReactMouseEvent<HTMLButtonElement>

        ↓

user callback receives package:web-compatible values
```

On the server:

```text
same HostNode
    ↓
server prop encoder
    ↓
event/ref metadata says omit
    ↓
HTML rendered without callback conversion
```

The immediate core change should therefore be:

```text
refactor: replace core syntheticEvent model with generic hostValue callbacks
```

followed by:

```text
feat: generate react_web event and ref callback adapters
```

[1]: https://dart.dev/language/extension-types?utm_source=chatgpt.com "Extension types"
[2]: https://api.dart.dev/dart-js_interop/?utm_source=chatgpt.com "dart:js_interop library - Dart API"
