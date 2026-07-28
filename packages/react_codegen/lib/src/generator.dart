import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:source_gen/source_gen.dart';

enum _TypeKind { string, int_, double_, bool_, num_, list, function, reactNode, other }

_TypeKind _kind(DartType t) {
  final b = t.getDisplayString(withNullability: true).replaceAll('?', '');
  if (t.isDartCoreString) return _TypeKind.string;
  if (t.isDartCoreBool) return _TypeKind.bool_;
  if (t.isDartCoreInt) return _TypeKind.int_;
  if (t.isDartCoreDouble) return _TypeKind.double_;
  if (t.isDartCoreNum) return _TypeKind.num_;
  if (t is InterfaceType && t.element.name == 'List') return _TypeKind.list;
  if (t is FunctionType) return _TypeKind.function;
  if (b == 'ReactNode') return _TypeKind.reactNode;
  return _TypeKind.other;
}

String _typeStr(DartType t) => t.getDisplayString(withNullability: true);

// ═══════════════════════════════════════════════
// Dart→JS conversion expressions
// ═══════════════════════════════════════════════

String _toJSFor(String expr, DartType t) {
  return switch (_kind(t)) {
    _TypeKind.string || _TypeKind.bool_ || _TypeKind.int_ ||
    _TypeKind.double_ || _TypeKind.num_ =>
      '$expr.toJS',
    _TypeKind.list =>
      '$expr.map((e) => toReactJS(e)).toList().toJS as JSAny',
    _TypeKind.function => _toJSForFn(expr, t as FunctionType),
    _TypeKind.reactNode => 'toReactJS($expr)!',
    _TypeKind.other => '$expr as JSAny',
  };
}

bool _isFuture(DartType type) {
  final display = type.getDisplayString();
  return display == 'Future' || display.startsWith('Future<');
}

String _valueSpecFor(DartType type) {
  final nullable = type.nullabilitySuffix == NullabilitySuffix.question;
  if (type is VoidType) {
    return 'reactVoid';
  }
  if (type.isDartCoreString) {
    return nullable ? 'reactNullableString' : 'reactString';
  }
  if (type.isDartCoreBool) {
    return nullable
        ? '(kind: ReactValueKind.boolean, nullable: true, codecId: null)'
        : 'reactBool';
  }
  if (type.isDartCoreInt) {
    return nullable
        ? '(kind: ReactValueKind.integer, nullable: true, codecId: null)'
        : 'reactInt';
  }
  if (type.isDartCoreDouble || type.isDartCoreNum) {
    return '(kind: ReactValueKind.number, nullable: $nullable, codecId: null)';
  }
  return '(kind: ReactValueKind.any, nullable: $nullable, codecId: null)';
}

String _toJSForFn(String expr, FunctionType ft) {
  final nullable = _typeStr(ft).endsWith('?');
  final paramTypes = ft.formalParameters
      .map((p) => _typeStr(p.type))
      .toList();
  final async = _isFuture(ft.returnType);

  final positionalSpecs = paramTypes.map((t) {
    final index = paramTypes.indexOf(t);
    final pt = ft.formalParameters[index].type;
    return _valueSpecFor(pt);
  }).join(', ');

  final resultSpec = _valueSpecFor(ft.returnType);

  final descriptorArgs = '''
      debugName: '$expr',
      signature: const (
        positional: [$positionalSpecs],
        result: $resultSpec,
        asynchronous: $async,
      ),''';

  final callExpr = nullable ? '$expr!' : expr;
  final resultIsVoid = ft.returnType is VoidType;

  final invokeBody = paramTypes.isEmpty
      ? '$callExpr();\n      return null;'
      : '${paramTypes.indexed.map((e) {
          final arg = 'arguments[${e.$1}]';
          final cast = switch (paramTypes[e.$1]) {
            'int' => ' as int',
            'double' => ' as double',
            'num' => ' as num',
            'String' => ' as String',
            'bool' => ' as bool',
            _ => '',
          };
          final call = '$callExpr($arg$cast)';
          return resultIsVoid ? '$call;' : 'return $call;';
        }).join('\n')}${resultIsVoid ? '\n      return null;' : ''}';

  final descriptor = '''ReactCallback(
    $descriptorArgs
    invoke: (arguments) {
      $invokeBody
    },
  )''';

  final callbackExpr = 'callbackToJS($descriptor)';

  return nullable ? '($expr == null ? null : $callbackExpr)' : callbackExpr;
}

// ═══════════════════════════════════════════════
// JS→Dart conversion statements
// ═══════════════════════════════════════════════

String _fromJSStatement(
    String fieldName, DartType t, String fieldKey, String _jsVar, String componentName) {
  final nullable = _typeStr(t).endsWith('?');
  final kind = _kind(t);

  if (kind == _TypeKind.function) {
    return _fromJSForFn(fieldName, t as FunctionType, fieldKey, _jsVar, componentName);
  }

  final acc = nullable ? _nullableAcc(t) : _requiredAcc(t);
  // The accessor takes (JSObject, key) — pass the JS variable and key string.
  return 'final $fieldName = $acc($_jsVar, "$fieldKey"${nullable ? '' : ', component: "$componentName"'});';
}

String _requiredAcc(DartType t) => switch (_kind(t)) {
      _TypeKind.string => 'requiredJSString',
      _TypeKind.int_ => 'requiredJSInt',
      _TypeKind.double_ || _TypeKind.num_ => 'requiredJSDouble',
      _TypeKind.bool_ => 'requiredJSBool',
      _ => 'jsAny',
    };

String _nullableAcc(DartType t) => switch (_kind(t)) {
      _TypeKind.string => 'nullableJSString',
      _TypeKind.int_ => 'nullableJSInt',
      _TypeKind.double_ || _TypeKind.num_ => 'nullableJSDouble',
      _TypeKind.bool_ => 'nullableJSBool',
      _ => 'jsAnyOrNull',
    };

String _fromJSForFn(String fieldName, FunctionType ft, String fieldKey, String jsExpr, String componentName) {
  final nullable = _typeStr(ft).endsWith('?');
  final paramTypes =
      ft.formalParameters.map((p) => _typeStr(p.type)).toList();
  final paramNames = [for (var i = 0; i < paramTypes.length; i++) 'a$i'];
  final returnType = _typeStr(ft.returnType);

  // Dart-side param list for the closure
  final dartParams =
      paramNames.indexed.map((e) => '${paramTypes[e.$1]} ${e.$2}').join(', ');
  // Build JS args when calling the function
  final jsArgs = paramNames.indexed
      .map((e) => _toJSFor(e.$2, ft.formalParameters[e.$1].type))
      .join(', ');

  final isVoid = returnType == 'void';

  // Put the null guard outside the closure so the closure type is
  // non-nullable and dart2js can generate a proper JS wrapper.
  if (paramTypes.isEmpty) {
    if (isVoid) {
      return nullable
          ? '''
final _raw$fieldName = $jsExpr;
final $fieldName = _raw$fieldName == null || _raw$fieldName.isUndefined
    ? null
    : () {
        final _fn = _raw$fieldName as JSFunction;
        _fn.callAsFunction(null);
      };'''
          : '''
final $fieldName = () {
  final _fn = $jsExpr as JSFunction;
  _fn.callAsFunction(null);
};''';
    }
    return nullable
        ? '''
final _raw$fieldName = $jsExpr;
final $fieldName = _raw$fieldName == null || _raw$fieldName.isUndefined
    ? null
    : () {
        final _fn = _raw$fieldName as JSFunction;
        return _fn.callAsFunction(null) as $returnType;
      };'''
        : '''
final $fieldName = () {
  final _fn = $jsExpr as JSFunction;
  return _fn.callAsFunction(null) as $returnType;
};''';
  }

  // Call with args
  final call = '_fn.callAsFunction(null, $jsArgs)';
  final body = isVoid ? '  $call;' : '  return $call as $returnType;';
  final closureBody = body;
  if (isVoid) {
    return nullable
        ? '''
final _raw$fieldName = $jsExpr;
final $fieldName = _raw$fieldName == null || _raw$fieldName.isUndefined
    ? null
    : ($dartParams) {
        final _fn = _raw$fieldName as JSFunction;
$closureBody
      };'''
        : '''
final $fieldName = ($dartParams) {
  final _fn = $jsExpr as JSFunction;
$closureBody
};''';
  }
  return nullable
      ? '''
final _raw$fieldName = $jsExpr;
final $fieldName = _raw$fieldName == null || _raw$fieldName.isUndefined
    ? null
    : ($dartParams) {
        final _fn = _raw$fieldName as JSFunction;
$closureBody
      };'''
      : '''
final $fieldName = ($dartParams) {
  final _fn = $jsExpr as JSFunction;
$closureBody
};''';
}

// ═══════════════════════════════════════════════
// Builder
// ═══════════════════════════════════════════════

class ComponentBuilder implements Builder {
  @override
  final buildExtensions = {'.dart': ['.react.dart', '.react.g.dart']};
  final _checker =
      const TypeChecker.fromUrl('package:react/src/annotations.dart#ReactComponent');

  @override
  Future<void> build(BuildStep step) async {
    if (step.inputId.path.contains('.react.')) return;
    final lib = await step.resolver.libraryFor(step.inputId);
    for (final ann in LibraryReader(lib).annotatedWith(_checker)) {
      final el = ann.element as ExecutableElement;
      final r = el.formalParameters.first.type as RecordType;
      final name = el.name;
      final id = 'package:${step.inputId.package}/${step.inputId.path}#$name';
      final fields = r.namedFields;
      final inputFile = step.inputId.pathSegments.last;
      final reactFile = inputFile.replaceAll('.dart', '.react.dart');

      // ── .react.dart ── pure Dart, zero js_interop ─────────
      final pureParams = [
        ...fields.map((f) => 'required ${_typeStr(f.type)} ${f.name}'),
        'String? key',
        'List<ReactNode> children = const []',
      ].join(', ');
      final pureLit =
          '(${fields.map((f) => '${f.name}: ${f.name}').join(', ')})';
      final pure = [
        "import 'package:react/react.dart';",
        "const id$name = ComponentId('$id');",
        'ReactNode $name({$pureParams}){',
        '  final props = $pureLit;',
        '  return Component(id$name, props, key: key, children: children);',
        '}',
      ].join('\n');
      await step.writeAsString(
          step.inputId.changeExtension('.react.dart'), pure);

      // ── .react.g.dart ── JS interop bridge ────────────────
      final toJSBody = fields.map((f) {
        final isNullable = _typeStr(f.type).endsWith('?');
        final isFn = _kind(f.type) == _TypeKind.function;
        if (isFn) {
          final expr = _toJSFor('props.${f.name}', f.type);
          return 'o.setProperty(\'${f.name}\'.toJS, $expr);';
        }
        if (isNullable) {
          return 'if (props.${f.name} != null) o.setProperty(\'${f.name}\'.toJS, props.${f.name}!.toJS);';
        }
        return 'o.setProperty(\'${f.name}\'.toJS, props.${f.name}.toJS);';
      }).join('\n');

      final fromJSStatements = fields.map((f) {
        final jsExpr = _kind(f.type) == _TypeKind.function
            ? "js.getProperty('${f.name}'.toJS)"
            : 'js';
        return _fromJSStatement(f.name, f.type, f.name, jsExpr, name!);
      })
          .join('\n');

      final fromJSReturn =
          '(${fields.map((f) => '${f.name}: ${f.name}').join(', ')})';

      final g = [
        "import 'dart:js_interop';",
        "import 'dart:js_interop_unsafe';",
        "import 'package:react_js/react_js.dart';",
        "import '$inputFile' as impl;",
        "import '$reactFile' show id$name;",
        '',
        'JSObject _${name}_toJS(${_typeStr(r)} props){',
        '  final o = JSObject();',
        '  $toJSBody',
        '  return o;',
        '}',
        '${_typeStr(r)} _${name}_fromJS(JSObject js){',
        '  $fromJSStatements',
        '  return $fromJSReturn;',
        '}',
        'final JSFunction \$$name = (() {',
        '  JSAny? wrapper(JSObject props){',
        '    final dartProps = _${name}_fromJS(props);',
        '    return toReactJS(impl.$name(dartProps));',
        '  }',
        '  return wrapper.toJS;',
        '})() as JSFunction;',
        'void register$name(){',
        '  ReactRegistry.register(id$name.value, \$$name,',
        '      toJS: (p) => _${name}_toJS(p as ${_typeStr(r)}),',
        '      fromJS: (js) => _${name}_fromJS(js));',
        '}',
      ].join('\n');
      await step.writeAsString(
          step.inputId.changeExtension('.react.g.dart'), g);
    }
  }
}
