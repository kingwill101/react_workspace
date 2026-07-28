import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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

String _toJSForFn(String expr, FunctionType ft) {
  final nullable = _typeStr(ft).endsWith('?');
  final paramTypes = ft.formalParameters
      .map((p) => _typeStr(p.type))
      .toList();
  final paramNames = [for (var i = 0; i < paramTypes.length; i++) 'a$i'];
  final returnType = _typeStr(ft.returnType);

  // Build Dart arrow function params
  final dartParams =
      paramNames.indexed.map((e) => '${paramTypes[e.$1]} ${e.$2}').join(', ');
  // Build call args — pass Dart values directly (the closure receives
  // Dart-converted values from dart2js, and the Dart callback expects
  // Dart types, not JS interop types).
  final callArgs = paramNames.join(', ');

  final nullableGuard = nullable ? '($expr == null ? null : ' : '';
  final closeParen = nullable ? ')' : '';

  // Force non-null when nullable — outer guard ensures the expression
  // is non-null before reaching the inner arrow function body.
  final innerExpr = nullable ? '(${expr}!)' : expr;

  if (returnType == 'void') {
    return '$nullableGuard(($dartParams) { $innerExpr($callArgs); }).toJS as JSAny$closeParen';
  }
  // Non-void return: just let the JS runtime handle the return
  return '$nullableGuard(($dartParams) => $innerExpr($callArgs)).toJS as JSAny$closeParen';
}

// ═══════════════════════════════════════════════
// JS→Dart conversion statements
// ═══════════════════════════════════════════════

String _fromJSStatement(String fieldName, DartType t, String fieldKey, String _jsVar) {
  final nullable = _typeStr(t).endsWith('?');
  final kind = _kind(t);

  if (kind == _TypeKind.function) {
    return _fromJSForFn(fieldName, t as FunctionType, fieldKey, _jsVar);
  }

  final acc = nullable ? _nullableAcc(t) : _requiredAcc(t);
  // The accessor takes (JSObject, key) — pass the JS variable and key string.
  return 'final $fieldName = $acc(${_jsVar}, "$fieldKey"${nullable ? '' : ', component: "$fieldName"'});';
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

String _fromJSForFn(String fieldName, FunctionType ft, String fieldKey, String jsExpr) {
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

  final nullGuard = nullable
      ? 'final _raw = $jsExpr;\n'
      : '';
  final nullCheck = nullable
      ? '  if (_raw == null || _raw.isUndefined) return null;\n  final _fn = _raw as JSFunction;\n'
      : '  final _fn = $jsExpr as JSFunction;\n';
  final fnVar = nullable ? '_fn' : '_fn';

  if (paramTypes.isEmpty) {
    if (isVoid) {
      return '''
final $fieldName = () {
$nullGuard$nullCheck  $fnVar.callAsFunction(null);
};''';
    }
    return '''
final $fieldName = () {
$nullGuard$nullCheck  return $fnVar.callAsFunction(null) as $returnType;
};''';
  }

  // Call with args
  final call = '$fnVar.callAsFunction(null, $jsArgs)';
  if (isVoid) {
    return '''
final $fieldName = ($dartParams) {
$nullGuard$nullCheck  $call;
};''';
  }
  return '''
final $fieldName = ($dartParams) {
$nullGuard$nullCheck  return $call as $returnType;
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
          // _toJSForFn handles null guard internally
          final expr = _toJSFor('props.${f.name}', f.type);
          return 'o.setProperty(\'${f.name}\'.toJS, $expr);';
        }
        if (isNullable) {
          // dart2js optimizes away `!` on record fields; use explicit guard.
          // `!.toJS` avoids calling toJS on nullable type.
          return 'if (props.${f.name} != null) o.setProperty(\'${f.name}\'.toJS, props.${f.name}!.toJS);';
        }
        return 'o.setProperty(\'${f.name}\'.toJS, props.${f.name}.toJS);';
      }).join('\n');

      final fromJSStatements = fields.map((f) {
        final jsExpr = _kind(f.type) == _TypeKind.function
            ? "js.getProperty('${f.name}'.toJS)"
            : 'js';
        return _fromJSStatement(f.name, f.type, f.name, jsExpr);
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
        '    return toReactJS(impl.${name}(dartProps));',
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