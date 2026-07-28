import '../model/model.dart';

final class CallbackEmitter {
  const CallbackEmitter();

  String descriptor({
    required String callbackExpression,
    required String debugName,
    required ReactCallbackModel callback,
  }) {
    final signature = '''
const (
  positional: [
    ${callback.positional.map((param) => _valueSpec(param.valueSpec)).join(',\n    ')},
  ],
  result: ${_valueSpec(callback.result)},
  asynchronous: ${callback.asynchronous},
)''';

    final invokeExpression = callback.nullable ? '$callbackExpression!' : callbackExpression;
    final arguments = callback.positional
        .map((param) => 'arguments[${callback.positional.indexOf(param)}] as ${_typeCode(param.type)}')
        .join(', ');

    final invokeBody = callback.result.kind == ReactValueKind.void_
        ? '''
$invokeExpression($arguments);
return null;'''
        : '''
return $invokeExpression($arguments);''';

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
    final dartParameters = callback.positional
        .map((param) => '${_typeCode(param.type)} ${param.name}')
        .join(', ');

    if (callback.nullable) {
      return _nullableJsProxy(fieldName, callback, dartParameters);
    }

    return _nonNullableJsProxy(fieldName, callback, dartParameters);
  }

  String _nonNullableJsProxy(
    String fieldName,
    ReactCallbackModel callback,
    String dartParameters,
  ) {
    final encodedArguments = callback.positional
        .map((param) =>
            'encodeReactValue(${_valueSpec(param.valueSpec)}, ${param.name})')
        .join(',\n        ');

    final resultBody = callback.result.kind == ReactValueKind.void_
        ? '''
invokeJSCallback(
  _fn,
  <JSAny?>[
    $encodedArguments
  ],
);'''
        : '''
final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    $encodedArguments
  ],
);
return decodeReactValue(
  ${_valueSpec(callback.result)},
  rawResult,
) as ${_typeCode(callback.resultType)};''';

    return '''
final ${_callbackType(callback)} $fieldName =
    ($dartParameters) {
      final _fn = js.getProperty(
        '$fieldName'.toJS,
      ) as JSFunction;
      $resultBody
    };''';
  }

  String _nullableJsProxy(
    String fieldName,
    ReactCallbackModel callback,
    String dartParameters,
  ) {
    final encodedArguments = callback.positional
        .map((param) =>
            'encodeReactValue(${_valueSpec(param.valueSpec)}, ${param.name})')
        .join(',\n        ');

    final resultBody = callback.result.kind == ReactValueKind.void_
        ? '''
invokeJSCallback(
  _fn,
  <JSAny?>[
    $encodedArguments
  ],
);'''
        : '''
final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    $encodedArguments
  ],
);
return decodeReactValue(
  ${_valueSpec(callback.result)},
  rawResult,
) as ${_typeCode(callback.resultType)};''';

    return '''
final _raw$fieldName = js.getProperty('$fieldName'.toJS);

final ${_callbackType(callback)} $fieldName =
    _raw$fieldName == null || _raw$fieldName.isUndefined
        ? null
        : ($dartParameters) {
            final _fn = _raw$fieldName as JSFunction;
            $resultBody
          };''';
  }

  String _callbackType(ReactCallbackModel callback) {
    final parameters = callback.positional.map((param) => _typeCode(param.type)).join(', ');
    final suffix = callback.nullable ? '?' : '';
    return '${_typeCode(callback.resultType)} Function($parameters)$suffix';
  }

  String _valueSpec(ReactValueSpecModel spec) {
    return switch (spec.kind) {
      ReactValueKind.void_ => 'reactVoid',
      ReactValueKind.string => spec.nullable ? 'reactNullableString' : 'reactString',
      ReactValueKind.integer => spec.nullable ? 'reactNullableInt' : 'reactInt',
      ReactValueKind.number => spec.nullable ? 'reactNullableDouble' : 'reactDouble',
      ReactValueKind.boolean => spec.nullable ? 'reactNullableBool' : 'reactBool',
      ReactValueKind.reactNode => 'reactNodeValue',
      ReactValueKind.hostValue => _hostValueSpec(spec),
      ReactValueKind.encodedObject => _encodedObjectSpec(spec),
      ReactValueKind.any => 'reactAny',
    };
  }

  String _hostValueSpec(ReactValueSpecModel spec) {
    if (spec.hostNamespace == null && spec.typeId == null) {
      return 'reactHostValue';
    }

    return '''
(
  kind: ReactValueKind.hostValue,
  nullable: ${spec.nullable},
  hostNamespace: '${spec.hostNamespace}',
  typeId: '${spec.typeId}',
  codecId: null,
)''';
  }

  String _encodedObjectSpec(ReactValueSpecModel spec) {
    return '''
(
  kind: ReactValueKind.encodedObject,
  nullable: ${spec.nullable},
  hostNamespace: null,
  typeId: null,
  codecId: '${spec.codecId}',
)''';
  }

  String _typeCode(ReactTypeRef type) {
    if (type is NamedTypeRef) {
      final args = type.typeArguments.map(_typeCode).join(', ');
      final suffix = args.isEmpty ? '' : '<$args>';
      final nullable = type.nullable ? '?' : '';
      return '${type.symbol}$suffix$nullable';
    }

    if (type is FunctionTypeRef) {
      final params = type.positional.map((p) => _typeCode(p.type)).join(', ');
      final named = type.named.isEmpty ? '' : '{${type.named.map((p) => '${_typeCode(p.type)} ${p.name}').join(', ')}}';
      final suffix = type.nullable ? '?' : '';
      return '${_typeCode(type.result)} Function($params${named.isEmpty ? '' : ' $named'})$suffix';
    }

    return 'dynamic';
  }
}
