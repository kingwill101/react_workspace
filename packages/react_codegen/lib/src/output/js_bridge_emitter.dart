import '../model/model.dart';
import 'callback_emitter.dart';

final class JsBridgeEmitter {
  final CallbackEmitter callbackEmitter;

  const JsBridgeEmitter({required this.callbackEmitter});

  String emit(ReactLibraryModel model) {
    final buffer = StringBuffer()
      ..writeln("import 'dart:js_interop';")
      ..writeln("import 'dart:js_interop_unsafe';")
      ..writeln("import 'package:react_js/react_js.dart';")
      ..writeln("import '${model.inputFile}' as impl;");
    for (final component in model.components) {
      buffer.writeln("import '${model.reactFile}' show id${component.name};");
    }
    buffer.writeln();

    for (final component in model.components) {
      buffer.writeln(_componentSource(model, component));
    }

    return buffer.toString();
  }

  String _componentSource(
    ReactLibraryModel model,
    ReactComponentModel component,
  ) {
    final toJSBuffer = StringBuffer();
    final fromJSBuffer = StringBuffer();
    final registrationBuffer = StringBuffer();

    toJSBuffer.writeln(
      'JSObject _${component.name}_toJS(${_recordCode(component.propsRecord)} props) {',
    );
    toJSBuffer.writeln('  final o = JSObject();');

    for (final prop in component.props) {
      if (_isCallback(prop.type)) {
        final modelCode = callbackEmitter.descriptor(
          callbackExpression: 'props.${prop.name}',
          debugName: '${component.name}.${prop.name}',
          callback: _callbackModel(prop.type),
        );
        toJSBuffer.writeln(
          "  o.setProperty('${prop.name}'.toJS, ${prop.required ? 'callbackToJS($modelCode)' : 'props.${prop.name} == null ? null : callbackToJS($modelCode)'});",
        );
      } else if (_isNullable(prop.type)) {
        toJSBuffer.writeln(
          "  if (props.${prop.name} != null) o.setProperty('${prop.name}'.toJS, props.${prop.name}!.toJS);",
        );
      } else {
        toJSBuffer.writeln(
          "  o.setProperty('${prop.name}'.toJS, props.${prop.name}.toJS);",
        );
      }
    }

    toJSBuffer.writeln('  return o;');
    toJSBuffer.writeln('}');

    fromJSBuffer.writeln(
      '${_recordCode(component.propsRecord)} _${component.name}_fromJS(JSObject js) {',
    );
    for (final prop in component.props) {
      if (_isCallback(prop.type)) {
        final proxy = callbackEmitter.jsProxy(
          fieldName: prop.name,
          callback: _callbackModel(prop.type),
        );
        fromJSBuffer.writeln(proxy);
      } else {
        fromJSBuffer.writeln(
          'final ${prop.name} = ${_accessor(prop, component.name)};',
        );
      }
    }

    final propsReturn = component.props
        .map((prop) => '${prop.name}: ${prop.name}')
        .join(', ');
    fromJSBuffer.writeln('  return ($propsReturn);');
    fromJSBuffer.writeln('}');

    registrationBuffer.writeln('final JSFunction \$${component.name} = (() {');
    registrationBuffer.writeln('  JSAny? wrapper(JSObject props) {');
    registrationBuffer.writeln(
      '    final dartProps = _${component.name}_fromJS(props);',
    );
    registrationBuffer.writeln(
      '    return toReactJS(impl.${component.name}(dartProps));',
    );
    registrationBuffer.writeln('  }');
    registrationBuffer.writeln('  return wrapper.toJS;');
    registrationBuffer.writeln('})() as JSFunction;');
    registrationBuffer.writeln('void register${component.name}(){');
    registrationBuffer.writeln(
      "  ReactRegistry.register(id${component.name}.value, \$${component.name},",
    );
    registrationBuffer.writeln(
      "      toJS: (p) => _${component.name}_toJS(p as ${_recordCode(component.propsRecord)}),",
    );
    registrationBuffer.writeln(
      "      fromJS: (js) => _${component.name}_fromJS(js));",
    );
    registrationBuffer.writeln('}');

    return [
      toJSBuffer.toString(),
      fromJSBuffer.toString(),
      registrationBuffer.toString(),
    ].join('\n');
  }

  bool _isNullable(ReactTypeRef type) {
    if (type is NamedTypeRef) {
      return type.nullable;
    }

    if (type is FunctionTypeRef) {
      return type.nullable;
    }

    if (type is RecordTypeRef) {
      return type.nullable;
    }

    return false;
  }

  bool _isCallback(ReactTypeRef type) => type is FunctionTypeRef;

  ReactCallbackModel _callbackModel(ReactTypeRef type) {
    if (type is! FunctionTypeRef) {
      throw StateError('Expected callback type.');
    }

    return ReactCallbackModel(
      positional: type.positional
          .map(
            (param) => ReactCallbackParameter(
              name: param.name,
              type: param.type,
              valueSpec: _toValueSpec(param.type),
            ),
          )
          .toList(),
      resultType: type.result,
      result: _toValueSpec(type.result),
      nullable: type.nullable,
      asynchronous: type.asynchronous,
    );
  }

  ReactValueSpecModel _toValueSpec(ReactTypeRef type) {
    if (type is NamedTypeRef) {
      final kind = switch (type.symbol) {
        'void' => ReactValueKind.void_,
        'String' => ReactValueKind.string,
        'int' => ReactValueKind.integer,
        'num' || 'double' => ReactValueKind.number,
        'bool' => ReactValueKind.boolean,
        'ReactNode' => ReactValueKind.reactNode,
        _ => ReactValueKind.encodedObject,
      };

      return ReactValueSpecModel(kind: kind, nullable: type.nullable);
    }

    return const ReactValueSpecModel(
      kind: ReactValueKind.encodedObject,
      nullable: true,
    );
  }

  String _recordCode(ReactTypeRef type) {
    if (type is! RecordTypeRef) {
      return 'dynamic';
    }

    final fields = <String>[];

    for (final field in type.named) {
      fields.add('${_typeCode(field.type)} ${field.name}');
    }

    return '({${fields.join(', ')}})';
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
      final named = type.named.isEmpty
          ? ''
          : '{${type.named.map((p) => '${_typeCode(p.type)} ${p.name}').join(', ')}}';
      final suffix = type.nullable ? '?' : '';
      return '${_typeCode(type.result)} Function($params${named.isEmpty ? '' : ' $named'})$suffix';
    }

    return 'dynamic';
  }

  String _accessor(ReactPropModel prop, String componentName) {
    final nullable = _isNullable(prop.type)
        ? ''
        : ', component: "$componentName"';
    return switch ((prop.type, prop.required)) {
      (NamedTypeRef(symbol: 'String'), true) =>
        'requiredJSString(js, "${prop.name}"$nullable)',
      (NamedTypeRef(symbol: 'String'), false) =>
        'nullableJSString(js, "${prop.name}")',
      (NamedTypeRef(symbol: 'int'), true) =>
        'requiredJSInt(js, "${prop.name}"$nullable)',
      (NamedTypeRef(symbol: 'num'), true) ||
      (
        NamedTypeRef(symbol: 'double'),
        true,
      ) => 'requiredJSDouble(js, "${prop.name}"$nullable)',
      (NamedTypeRef(symbol: 'bool'), true) =>
        'requiredJSBool(js, "${prop.name}"$nullable)',
      _ => 'jsAnyOrNull(js, "${prop.name}")',
    };
  }
}
