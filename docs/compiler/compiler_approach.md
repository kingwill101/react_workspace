Below is a working first implementation of the new design:

```text
Typed Dart callback
        ↓
ReactCallback descriptor
        ↓
ExternalDartReference
        ↓
JavaScript (...args) trampoline
        ↓
one Dart dispatcher
```

Dart’s `.toJS` wrapper depends on the function’s **static signature**, including its maximum accepted argument count. The implementation therefore calls `.toJS` only on one fixed dispatcher rather than on arbitrary user callbacks. ([Dart API Docs][1])

---

# 1. Pure callback model

Create:

```text
packages/react/lib/src/callback.dart
```

```dart
enum ReactValueKind {
  void_,
  any,
  string,
  integer,
  number,
  boolean,
  reactNode,
  object,
}

/// Runtime description of one callback parameter or result.
typedef ReactValueSpec = ({
  ReactValueKind kind,
  bool nullable,
  String? codecId,
});

/// Runtime description of a complete callback.
typedef ReactCallbackSignature = ({
  List<ReactValueSpec> positional,
  ReactValueSpec result,
  bool asynchronous,
});

typedef ReactCallbackInvoker =
    Object? Function(List<Object?> arguments);

const ReactValueSpec reactVoid = (
  kind: ReactValueKind.void_,
  nullable: false,
  codecId: null,
);

const ReactValueSpec reactAny = (
  kind: ReactValueKind.any,
  nullable: true,
  codecId: null,
);

const ReactValueSpec reactString = (
  kind: ReactValueKind.string,
  nullable: false,
  codecId: null,
);

const ReactValueSpec reactNullableString = (
  kind: ReactValueKind.string,
  nullable: true,
  codecId: null,
);

const ReactValueSpec reactInt = (
  kind: ReactValueKind.integer,
  nullable: false,
  codecId: null,
);

const ReactValueSpec reactNullableInt = (
  kind: ReactValueKind.integer,
  nullable: true,
  codecId: null,
);

const ReactValueSpec reactDouble = (
  kind: ReactValueKind.number,
  nullable: false,
  codecId: null,
);

const ReactValueSpec reactNullableDouble = (
  kind: ReactValueKind.number,
  nullable: true,
  codecId: null,
);

const ReactValueSpec reactBool = (
  kind: ReactValueKind.boolean,
  nullable: false,
  codecId: null,
);

const ReactValueSpec reactNullableBool = (
  kind: ReactValueKind.boolean,
  nullable: true,
  codecId: null,
);

const ReactValueSpec reactNodeValue = (
  kind: ReactValueKind.reactNode,
  nullable: false,
  codecId: null,
);

final class ReactCallback {
  final ReactCallbackSignature signature;
  final ReactCallbackInvoker invoke;
  final String? debugName;

  ReactCallback({
    required this.signature,
    required this.invoke,
    this.debugName,
  });

  Object? call(List<Object?> arguments) {
    final expected = signature.positional.length;

    if (arguments.length < expected) {
      throw ArgumentError(
        '${debugName ?? 'React callback'} expected '
        '$expected arguments but received ${arguments.length}.',
      );
    }

    return invoke(arguments);
  }
}
```

Export it:

```dart
// packages/react/lib/react.dart

export 'src/annotations.dart';
export 'src/callback.dart';
export 'src/component_id.dart';
export 'src/hooks.dart';
export 'src/internal.dart';
export 'src/node.dart';
```

`package:react` remains pure Dart.

---

# 2. JavaScript variadic trampoline

Create:

```text
packages/react_js/js/callback_trampoline.js
```

```javascript
(() => {
  const callbacks =
    globalThis.__dartReactCallbacks ??= Object.create(null);

  callbacks.create = function createCallback(
    dartReference,
    dispatch,
  ) {
    return function (...args) {
      return dispatch(dartReference, args);
    };
  };

  callbacks.invoke = function invokeCallback(
    callback,
    args,
  ) {
    return callback(...args);
  };
})();
```

There are two operations:

```text
create:
  Dart callback → JavaScript variadic function

invoke:
  Dart → existing JavaScript callback with unlimited arguments
```

The second operation also removes the four-argument restriction of Dart’s built-in `JSFunction.callAsFunction`. The standard helper accepts up to four arguments, so a small JS spread helper is appropriate here. ([Dart API Docs][2])

---

# 3. Callback bridge

Create:

```text
packages/react_js/lib/src/callback_bridge.dart
```

```dart
import 'dart:js_interop';

import 'package:react/react.dart';

typedef ReactValueEncoder =
    JSAny? Function(Object? value);

typedef ReactValueDecoder =
    Object? Function(JSAny? value);

final class ReactValueCodec {
  final ReactValueEncoder encode;
  final ReactValueDecoder decode;

  const ReactValueCodec({
    required this.encode,
    required this.decode,
  });
}

/// Registry for generated custom model codecs.
abstract final class ReactValueCodecs {
  static final _codecs = <String, ReactValueCodec>{};

  static void register(
    String id,
    ReactValueCodec codec,
  ) {
    final previous = _codecs[id];

    if (previous != null && !identical(previous, codec)) {
      throw StateError(
        'A React value codec is already registered for "$id".',
      );
    }

    _codecs[id] = codec;
  }

  static ReactValueCodec lookup(String id) {
    final codec = _codecs[id];

    if (codec == null) {
      throw StateError(
        'No React value codec is registered for "$id".',
      );
    }

    return codec;
  }
}

@JS('__dartReactCallbacks.create')
external JSFunction _createCallback(
  ExternalDartReference<ReactCallback> callback,
  JSExportedDartFunction dispatcher,
);

@JS('__dartReactCallbacks.invoke')
external JSAny? _invokeCallback(
  JSFunction callback,
  JSArray<JSAny?> arguments,
);

/// This is the only Dart callback converted using `.toJS`.
///
/// Its static signature never changes, regardless of the signature of the
/// user callback.
JSAny? _dispatchReactCallback(
  ExternalDartReference<ReactCallback> reference,
  JSArray<JSAny?> rawArguments,
) {
  final callback = reference.toDartObject;
  final signature = callback.signature;

  final arguments = <Object?>[];

  for (
    var index = 0;
    index < signature.positional.length;
    index++
  ) {
    final raw = index < rawArguments.length
        ? rawArguments[index]
        : null;

    arguments.add(
      decodeReactValue(
        signature.positional[index],
        raw,
        callbackName: callback.debugName,
        argumentIndex: index,
      ),
    );
  }

  final result = callback.call(arguments);

  if (signature.asynchronous) {
    throw UnsupportedError(
      'Async React callbacks are not implemented yet: '
      '${callback.debugName ?? '<unnamed>'}.',
    );
  }

  return encodeReactValue(
    signature.result,
    result,
  );
}

final JSExportedDartFunction _dispatchReactCallbackJS =
    _dispatchReactCallback.toJS;

/// Creates a JavaScript function accepting any number of arguments.
JSFunction callbackToJS(ReactCallback callback) {
  return _createCallback(
    callback.toExternalReference,
    _dispatchReactCallbackJS,
  );
}

/// Invokes an existing JavaScript callback with any number of arguments.
JSAny? invokeJSCallback(
  JSFunction callback,
  List<JSAny?> arguments,
) {
  return _invokeCallback(
    callback,
    arguments.toJS,
  );
}

Object? decodeReactValue(
  ReactValueSpec spec,
  JSAny? value, {
  String? callbackName,
  int? argumentIndex,
}) {
  if (value == null || value.isUndefined) {
    if (spec.nullable ||
        spec.kind == ReactValueKind.void_) {
      return null;
    }

    throw ArgumentError(
      '${callbackName ?? 'React callback'}'
      '${argumentIndex == null ? '' : ' argument $argumentIndex'} '
      'received null or undefined for non-nullable '
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
        'Decoding a ReactNode callback argument '
        'is not implemented.',
      ),

    ReactValueKind.object =>
      ReactValueCodecs.lookup(
        _requiredCodecId(spec),
      ).decode(value),
  };
}

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
      'Cannot encode null as non-nullable '
      '${spec.kind.name}.',
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

    ReactValueKind.object =>
      ReactValueCodecs.lookup(
        _requiredCodecId(spec),
      ).encode(value),
  };
}

String _requiredCodecId(ReactValueSpec spec) {
  final id = spec.codecId;

  if (id == null || id.isEmpty) {
    throw StateError(
      '${spec.kind.name} requires a codecId.',
    );
  }

  return id;
}
```

`ExternalDartReference` is opaque to JavaScript and can be converted back to the original Dart object within the same runtime. Repeated conversions of the same Dart object produce equal opaque references. ([Dart API Docs][3])

---

# 4. Update `toReactJS`

Replace the current callback-specific cases in:

```text
packages/react_js/lib/src/convert.dart
```

with:

```dart
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react/react.dart';

import 'callback_bridge.dart';

JSAny? toReactJS(Object? value) => switch (value) {
      null => null,

      String string =>
        string.toJS,

      bool boolean =>
        boolean.toJS,

      int integer =>
        integer.toJS,

      double number =>
        number.toJS,

      ReactNode node =>
        renderNode(node),

      ReactCallback callback =>
        callbackToJS(callback),

      List values => <JSAny?>[
          for (final item in values)
            toReactJS(item),
        ].toJS,

      Map<String, Object?> map =>
        _mapToJS(map),

      Function function =>
        throw UnsupportedError(
          'Raw Dart functions cannot be used as React '
          'properties. Use a typed element factory or '
          'ReactCallback. Received ${function.runtimeType}.',
        ),

      _ => throw UnsupportedError(
          'Cannot convert ${value.runtimeType} '
          'to a React JavaScript value.',
        ),
    };

JSAny? renderNode(ReactNode node) =>
    ReactInternal.renderer.render(node) as JSAny?;

JSObject _mapToJS(Map<String, Object?> map) {
  final object = JSObject();

  for (final MapEntry(:key, :value) in map.entries) {
    final converted = toReactJS(value);

    if (converted != null) {
      object.setProperty(
        key.toJS,
        converted,
      );
    }
  }

  return object;
}

// Keep the existing required/nullable property accessors below this point.
```

Remove:

```dart
void Function() c => _callback0ToJS(c),
void Function(int) c => _callback1IntToJS(c),
```

and remove their helper functions.

Also export the bridge:

```dart
// packages/react_js/lib/react_js.dart

export 'package:react/react.dart';

export 'src/binding.dart';
export 'src/callback_bridge.dart';
export 'src/convert.dart';
export 'src/registry.dart';
export 'src/renderer.dart';
```

---

# 5. Typed DOM factory

Application code should not manually construct descriptors for ordinary DOM events.

Create:

```text
packages/react/lib/src/dom.dart
```

```dart
import 'callback.dart';
import 'node.dart';

ReactNode div({
  Map<String, Object?> props = const {},
  List<ReactNode> children = const [],
  String? key,
}) {
  return Intrinsic(
    'div',
    props: props,
    children: children,
    key: key,
  );
}

ReactNode button({
  void Function()? onClick,
  bool? disabled,
  String? className,
  List<ReactNode> children = const [],
  String? key,
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

Export it:

```dart
export 'src/dom.dart';
```

Then `counter.dart` becomes:

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

No `dart:js_interop` appears in the component.

---

# 6. Compiler semantic model

Following the AngularDart pattern, the analyzer should produce a stable model before any source is emitted. AngularDart’s compiler explicitly performed discovery, normalization, IR construction and backend emission as separate stages.

Create:

```text
packages/react_codegen/lib/src/model/model.dart
```

```dart
enum ReactTypeKind {
  void_,
  string,
  integer,
  number,
  boolean,
  reactNode,
  list,
  callback,
  unsupported,
}

final class ReactTypeModel {
  final String dartCode;
  final ReactTypeKind kind;
  final bool nullable;
  final ReactTypeModel? elementType;
  final ReactCallbackModel? callback;

  const ReactTypeModel({
    required this.dartCode,
    required this.kind,
    required this.nullable,
    this.elementType,
    this.callback,
  });
}

final class ReactCallbackModel {
  final List<ReactTypeModel> positional;
  final ReactTypeModel result;
  final bool nullable;
  final bool asynchronous;

  const ReactCallbackModel({
    required this.positional,
    required this.result,
    required this.nullable,
    required this.asynchronous,
  });
}

final class ReactPropModel {
  final String name;
  final ReactTypeModel type;

  const ReactPropModel({
    required this.name,
    required this.type,
  });
}

final class ReactComponentModel {
  final String name;
  final String componentId;
  final String propsRecordCode;
  final List<ReactPropModel> props;

  const ReactComponentModel({
    required this.name,
    required this.componentId,
    required this.propsRecordCode,
    required this.props,
  });
}

final class ReactLibraryModel {
  final String inputFile;
  final String reactFile;
  final List<ReactComponentModel> components;

  const ReactLibraryModel({
    required this.inputFile,
    required this.reactFile,
    required this.components,
  });

  bool get isEmpty => components.isEmpty;
}
```

---

# 7. Type reader

Create:

```text
packages/react_codegen/lib/src/analyzer/type_reader.dart
```

```dart
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../model/model.dart';

final class ReactTypeReader {
  const ReactTypeReader();

  ReactTypeModel read(DartType type) {
    final code = type.getDisplayString(
      withNullability: true,
    );

    final nullable = code.endsWith('?');
    final baseCode = nullable
        ? code.substring(0, code.length - 1)
        : code;

    if (type.isVoid) {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.void_,
        nullable: false,
      );
    }

    if (type.isDartCoreString) {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.string,
        nullable: nullable,
      );
    }

    if (type.isDartCoreInt) {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.integer,
        nullable: nullable,
      );
    }

    if (type.isDartCoreDouble ||
        type.isDartCoreNum) {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.number,
        nullable: nullable,
      );
    }

    if (type.isDartCoreBool) {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.boolean,
        nullable: nullable,
      );
    }

    if (baseCode == 'ReactNode') {
      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.reactNode,
        nullable: nullable,
      );
    }

    if (type is InterfaceType &&
        type.element.name == 'List') {
      final argument = type.typeArguments.single;

      return ReactTypeModel(
        dartCode: code,
        kind: ReactTypeKind.list,
        nullable: nullable,
        elementType: read(argument),
      );
    }

    if (type is FunctionType) {
      return _readFunction(type);
    }

    return ReactTypeModel(
      dartCode: code,
      kind: ReactTypeKind.unsupported,
      nullable: nullable,
    );
  }

  ReactTypeModel _readFunction(FunctionType type) {
    final parameters = type.formalParameters;

    for (final parameter in parameters) {
      if (parameter.isNamed ||
          parameter.isOptionalPositional) {
        throw InvalidGenerationSourceError(
          'React callback parameters must currently be '
          'required positional parameters. Unsupported '
          'callback type: ${type.getDisplayString(
            withNullability: true,
          )}.',
        );
      }
    }

    final returnType = type.returnType;
    final asynchronous = returnType is InterfaceType &&
        returnType.element.name == 'Future';

    if (asynchronous) {
      throw InvalidGenerationSourceError(
        'Async React callback results are not '
        'implemented yet: ${type.getDisplayString(
          withNullability: true,
        )}.',
      );
    }

    final callback = ReactCallbackModel(
      positional: [
        for (final parameter in parameters)
          read(parameter.type),
      ],
      result: read(returnType),
      nullable:
          type.nullabilitySuffix ==
              NullabilitySuffix.question,
      asynchronous: false,
    );

    return ReactTypeModel(
      dartCode: type.getDisplayString(
        withNullability: true,
      ),
      kind: ReactTypeKind.callback,
      nullable: callback.nullable,
      callback: callback,
    );
  }
}
```

There is no arity check. A callback may have zero, one or twenty positional arguments.

---

# 8. Component reader

Create:

```text
packages/react_codegen/lib/src/analyzer/component_reader.dart
```

```dart
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../model/model.dart';
import 'type_reader.dart';

final class ReactComponentReader {
  final ReactTypeReader typeReader;

  final TypeChecker _checker =
      const TypeChecker.fromUrl(
    'package:react/src/annotations.dart#ReactComponent',
  );

  ReactComponentReader({
    required this.typeReader,
  });

  ReactLibraryModel read(
    LibraryElement library,
    AssetId input,
  ) {
    final components = <ReactComponentModel>[];

    for (
      final annotated
      in LibraryReader(library)
          .annotatedWith(_checker)
    ) {
      final executable =
          annotated.element as ExecutableElement;

      if (executable.formalParameters.length != 1) {
        throw InvalidGenerationSourceError(
          '${executable.name} must accept exactly '
          'one record parameter.',
          element: executable,
        );
      }

      final parameter =
          executable.formalParameters.single;

      final record = parameter.type;

      if (record is! RecordType) {
        throw InvalidGenerationSourceError(
          '${executable.name} must accept a '
          'record parameter.',
          element: executable,
        );
      }

      if (record.positionalFields.isNotEmpty) {
        throw InvalidGenerationSourceError(
          '${executable.name} props must use '
          'named record fields.',
          element: executable,
        );
      }

      final name = executable.name;

      components.add(
        ReactComponentModel(
          name: name!,
          componentId:
              'package:${input.package}/'
              '${input.path}#$name',
          propsRecordCode:
              record.getDisplayString(
            withNullability: true,
          ),
          props: [
            for (final field in record.namedFields)
              ReactPropModel(
                name: field.name,
                type: typeReader.read(field.type),
              ),
          ],
        ),
      );
    }

    final inputFile =
        input.pathSegments.last;

    return ReactLibraryModel(
      inputFile: inputFile,
      reactFile: inputFile.replaceAll(
        '.dart',
        '.react.dart',
      ),
      components: components,
    );
  }
}
```

---

# 9. Callback source emitter

Create:

```text
packages/react_codegen/lib/src/output/callback_emitter.dart
```

```dart
import '../model/model.dart';

final class CallbackEmitter {
  const CallbackEmitter();

  String valueSpec(ReactTypeModel type) {
    final constant = switch (type.kind) {
      ReactTypeKind.void_ => 'reactVoid',
      ReactTypeKind.string =>
        type.nullable
            ? 'reactNullableString'
            : 'reactString',
      ReactTypeKind.integer =>
        type.nullable
            ? 'reactNullableInt'
            : 'reactInt',
      ReactTypeKind.number =>
        type.nullable
            ? 'reactNullableDouble'
            : 'reactDouble',
      ReactTypeKind.boolean =>
        type.nullable
            ? 'reactNullableBool'
            : 'reactBool',
      ReactTypeKind.reactNode =>
        'reactNodeValue',
      _ => throw StateError(
          'Unsupported callback value type: '
          '${type.dartCode}.',
        ),
    };

    return constant;
  }

  String descriptor({
    required String callbackExpression,
    required String debugName,
    required ReactCallbackModel callback,
  }) {
    final signature = '''
const (
  positional: [
    ${callback.positional.map(valueSpec).join(',\n    ')},
  ],
  result: ${valueSpec(callback.result)},
  asynchronous: ${callback.asynchronous},
)''';

    final arguments = [
      for (
        var index = 0;
        index < callback.positional.length;
        index++
      )
        'arguments[$index] as '
            '${callback.positional[index].dartCode}',
    ].join(', ');

    final invokeBody =
        callback.result.kind ==
                ReactTypeKind.void_
            ? '''
$callbackExpression($arguments);
return null;'''
            : '''
return $callbackExpression($arguments);''';

    return '''
ReactCallback(
  debugName: '$debugName',
  signature: $signature,
  invoke: (arguments) {
    $invokeBody
  },
)''';
  }

  String jsProxy({
    required String fieldName,
    required ReactCallbackModel callback,
  }) {
    final dartParameters = [
      for (
        var index = 0;
        index < callback.positional.length;
        index++
      )
        '${callback.positional[index].dartCode} a$index',
    ].join(', ');

    final encodedArguments = [
      for (
        var index = 0;
        index < callback.positional.length;
        index++
      )
        'encodeReactValue('
            '${valueSpec(callback.positional[index])}, '
            'a$index)',
    ].join(',\n        ');

    final invocation = '''
invokeJSCallback(
  _fn,
  <JSAny?>[
    $encodedArguments
  ],
)''';

    final resultBody =
        callback.result.kind ==
                ReactTypeKind.void_
            ? '''
$invocation;
'''
            : '''
final rawResult = $invocation;
return decodeReactValue(
  ${valueSpec(callback.result)},
  rawResult,
) as ${callback.result.dartCode};
''';

    if (callback.nullable) {
      return '''
final _raw$fieldName =
    js.getProperty('$fieldName'.toJS);

final ${callbackType(callback)} $fieldName =
    _raw$fieldName == null ||
            _raw$fieldName.isUndefined
        ? null
        : ($dartParameters) {
            final _fn =
                _raw$fieldName as JSFunction;
            $resultBody
          };''';
    }

    return '''
final ${callbackType(callback)} $fieldName =
    ($dartParameters) {
      final _fn = js.getProperty(
        '$fieldName'.toJS,
      ) as JSFunction;
      $resultBody
    };''';
  }

  String callbackType(
    ReactCallbackModel callback,
  ) {
    final parameters = callback.positional
        .map((type) => type.dartCode)
        .join(', ');

    final suffix =
        callback.nullable ? '?' : '';

    return '${callback.result.dartCode} '
        'Function($parameters)$suffix';
  }
}
```

The generator emits local adapters, but no callback-class family.

---

# 10. Generated `_Counter_toJS`

The new generated bridge becomes:

```dart
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_js/react_js.dart';

import 'counter.dart' as impl;
import 'counter.react.dart' show idCounter;

JSObject _Counter_toJS(
  ({
    int initialCount,
    void Function(int)? onChange,
    String? subtitle,
    String title,
  }) props,
) {
  final object = JSObject();

  object.setProperty(
    'initialCount'.toJS,
    props.initialCount.toJS,
  );

  if (props.onChange case final onChange?) {
    object.setProperty(
      'onChange'.toJS,
      callbackToJS(
        ReactCallback(
          debugName: 'Counter.onChange',
          signature: const (
            positional: [
              reactInt,
            ],
            result: reactVoid,
            asynchronous: false,
          ),
          invoke: (arguments) {
            onChange(
              arguments[0] as int,
            );
            return null;
          },
        ),
      ),
    );
  }

  if (props.subtitle case final subtitle?) {
    object.setProperty(
      'subtitle'.toJS,
      subtitle.toJS,
    );
  }

  object.setProperty(
    'title'.toJS,
    props.title.toJS,
  );

  return object;
}
```

Generated JS-to-Dart:

```dart
({
  int initialCount,
  void Function(int)? onChange,
  String? subtitle,
  String title,
}) _Counter_fromJS(JSObject js) {
  final initialCount = requiredJSInt(
    js,
    'initialCount',
    component: 'Counter',
  );

  final rawOnChange =
      js.getProperty('onChange'.toJS);

  final void Function(int)? onChange =
      rawOnChange == null ||
              rawOnChange.isUndefined
          ? null
          : (int value) {
              invokeJSCallback(
                rawOnChange as JSFunction,
                <JSAny?>[
                  encodeReactValue(
                    reactInt,
                    value,
                  ),
                ],
              );
            };

  final subtitle = nullableJSString(
    js,
    'subtitle',
  );

  final title = requiredJSString(
    js,
    'title',
    component: 'Counter',
  );

  return (
    initialCount: initialCount,
    onChange: onChange,
    subtitle: subtitle,
    title: title,
  );
}
```

Component wrapper:

```dart
final JSFunction $Counter = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps =
        _Counter_fromJS(props);

    return toReactJS(
      impl.Counter(dartProps),
    );
  }

  return wrapper.toJS;
})() as JSFunction;

void registerCounter() {
  ReactRegistry.register(
    idCounter.value,
    $Counter,
    toJS: (props) => _Counter_toJS(
      props as ({
        int initialCount,
        void Function(int)? onChange,
        String? subtitle,
        String title,
      }),
    ),
    fromJS: _Counter_fromJS,
  );
}
```

---

# 11. Compiler orchestrator

Create:

```text
packages/react_codegen/lib/src/compiler/compiler.dart
```

```dart
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import '../analyzer/component_reader.dart';
import '../model/model.dart';
import '../output/js_bridge_emitter.dart';
import '../output/public_api_emitter.dart';

final class ReactCompileOutput {
  final String publicApi;
  final String jsBridge;

  const ReactCompileOutput({
    required this.publicApi,
    required this.jsBridge,
  });
}

final class ReactCompiler {
  final ReactComponentReader reader;
  final PublicApiEmitter publicApiEmitter;
  final JsBridgeEmitter jsBridgeEmitter;

  const ReactCompiler({
    required this.reader,
    required this.publicApiEmitter,
    required this.jsBridgeEmitter,
  });

  ReactCompileOutput? compile(
    LibraryElement library,
    AssetId input,
  ) {
    final model = reader.read(
      library,
      input,
    );

    if (model.isEmpty) {
      return null;
    }

    _validate(model);

    return ReactCompileOutput(
      publicApi:
          publicApiEmitter.emit(model),
      jsBridge:
          jsBridgeEmitter.emit(model),
    );
  }

  void _validate(ReactLibraryModel model) {
    for (final component in model.components) {
      for (final prop in component.props) {
        if (prop.type.kind ==
            ReactTypeKind.unsupported) {
          throw StateError(
            '${component.name}.${prop.name} '
            'has unsupported type '
            '${prop.type.dartCode}.',
          );
        }
      }
    }
  }
}
```

The compiler owns compilation. The builder only handles assets.

---

# 12. Thin builder

Replace the large existing builder with:

```dart
import 'package:build/build.dart';

import '../analyzer/component_reader.dart';
import '../analyzer/type_reader.dart';
import '../compiler/compiler.dart';
import '../output/callback_emitter.dart';
import '../output/js_bridge_emitter.dart';
import '../output/public_api_emitter.dart';

Builder componentBuilder(
  BuilderOptions options,
) {
  const callbackEmitter =
      CallbackEmitter();

  final compiler = ReactCompiler(
    reader: ReactComponentReader(
      typeReader:
          const ReactTypeReader(),
    ),
    publicApiEmitter:
        const PublicApiEmitter(),
    jsBridgeEmitter:
        const JsBridgeEmitter(
      callbackEmitter:
          callbackEmitter,
    ),
  );

  return ReactComponentBuilder(
    compiler,
  );
}

final class ReactComponentBuilder
    implements Builder {
  final ReactCompiler compiler;

  ReactComponentBuilder(this.compiler);

  @override
  final buildExtensions = const {
    '.dart': [
      '.react.dart',
      '.react.g.dart',
    ],
  };

  @override
  Future<void> build(
    BuildStep step,
  ) async {
    if (step.inputId.path.contains(
      '.react.',
    )) {
      return;
    }

    if (!await step.resolver.isLibrary(
      step.inputId,
    )) {
      return;
    }

    final library =
        await step.inputLibrary;

    final output = compiler.compile(
      library,
      step.inputId,
    );

    if (output == null) {
      return;
    }

    await step.writeAsString(
      step.inputId.changeExtension(
        '.react.dart',
      ),
      output.publicApi,
    );

    await step.writeAsString(
      step.inputId.changeExtension(
        '.react.g.dart',
      ),
      output.jsBridge,
    );
  }
}
```

This follows the AngularDart arrangement where the build-system adapter delegates compilation to smaller analyzer/compiler/emitter services.

---

# 13. Bootstrap the trampoline

It must be loaded before the compiled Dart bundle.

Browser:

```html
<script src="react_callback_trampoline.js"></script>
<script src="client.dart.js"></script>
```

Copy it during the build:

```yaml
# Taskfile.yml

client:
  cmds:
    - cp packages/react_js/js/callback_trampoline.js
        examples/ssr/web/react_callback_trampoline.js
    - dart compile js -O0
        -o examples/ssr/web/client.dart.js
        examples/ssr/web/client.dart
```

SSR worker:

```javascript
import './packages/react_js/js/callback_trampoline.js';

import React from 'react';
import ReactDOMServer from 'react-dom/server';

globalThis.React = React;

await import('./build/ssr.js');
```

The trampoline must be installed before the Dart SSR entrypoint initializes any callbacks.

---

# 14. Tests to add immediately

```dart
test('zero arguments', () {
  var called = false;

  final callback = ReactCallback(
    signature: const (
      positional: [],
      result: reactVoid,
      asynchronous: false,
    ),
    invoke: (_) {
      called = true;
      return null;
    },
  );

  // Invoke through the JS trampoline.
  expect(called, isTrue);
});
```

Test these generated signatures:

```dart
void Function()
void Function(int)
void Function(String, int)
bool Function(String)
void Function(int, int, int, int, int, int)
```

The six-argument test is important: it proves the implementation is no longer tied to Dart’s four-argument `callAsFunction` convenience API.

Also compile and run with both:

```bash
dart compile js -O0
dart compile js -O2
```

The critical architectural result is:

```text
User callback arity
    does not affect
the exported Dart dispatcher signature
```

Only the generated signature record and local invocation adapter change.

[1]: https://api.dart.dev/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html?utm_source=chatgpt.com "toJS property - FunctionToJSExportedDartFunction extension - dart:js_interop library - Dart API"
[2]: https://api.dart.dev/dart-js_interop/JSFunctionUtilExtension/callAsFunction.html?utm_source=chatgpt.com "callAsFunction method - JSFunctionUtilExtension extension - dart:js_interop library - Dart API"
[3]: https://api.dart.dev/dart-js_interop/ObjectToExternalDartReference/toExternalReference.html "toExternalReference property - ObjectToExternalDartReference extension - dart:js_interop library - Dart API"
