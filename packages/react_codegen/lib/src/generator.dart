import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Visitor for [DartType] to decide the kind of conversion needed.
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

/// Generates an expression that converts a Dart expression to a JS interop value.
/// Caller must handle nullable checking externally.
String _toJSFor(String expr, DartType t) {
  return switch (_kind(t)) {
    _TypeKind.string || _TypeKind.bool_ || _TypeKind.int_ ||
    _TypeKind.double_ || _TypeKind.num_ =>
      '$expr.toJS',
    _TypeKind.list =>
      '$expr.map((e) => toReactJS(e)).toList().toJS as JSAny',
    _TypeKind.function => '$expr.toJS as JSAny',
    _TypeKind.reactNode => 'toReactJS($expr)!',
    _TypeKind.other => '$expr as JSAny',
  };
}

/// Generates a statement that reads a JS property and stores it as Dart in [fieldName].
String _fromJSStatement(
    String fieldName, DartType t, String fieldKey, String jsExpr) {
  final nullable = _typeStr(t).endsWith('?');
  final str = t.getDisplayString(withNullability: true).replaceAll('?', '');
  final kind = _kind(t);

  // Build the core conversion expression
  String core() => switch (kind) {
        _TypeKind.string => '($jsExpr as JSString).toDart',
        _TypeKind.bool_ => '($jsExpr as JSBoolean).toDart',
        _TypeKind.int_ => '($jsExpr as JSNumber).toDartInt',
        _TypeKind.double_ || _TypeKind.num_ =>
          '($jsExpr as JSNumber).toDartDouble',
        _TypeKind.list => _fromJSList(t),
        _TypeKind.function => _fromJSFunction(t),
        _TypeKind.reactNode => '$jsExpr as ReactNode',
        _TypeKind.other => '$jsExpr as $str',
      };

  if (nullable) {
    return 'final $fieldName = (() { final _v = $jsExpr; return _v.isUndefined ? null : ${core()}; })();';
  }
  return 'final $fieldName = ${core()};';
}

/// Handle List<T> conversion.
String _fromJSList(DartType t) {
  final typeArg = (t as InterfaceType).typeArguments.first;
  final elemStr = typeArg.getDisplayString(withNullability: true);
  // For lists of primitives, we can use .toDart.cast()
  final elemKind = _kind(typeArg);
  switch (elemKind) {
    case _TypeKind.string:
      return '(\$jsExpr as JSArray).toDart.cast<JSString>().map((e) => e.toDart).toList()';
    case _TypeKind.int_:
      return '(\$jsExpr as JSArray).toDart.cast<JSNumber>().map((e) => e.toDartInt).toList()';
    case _TypeKind.bool_:
      return '(\$jsExpr as JSArray).toDart.cast<JSBoolean>().map((e) => e.toDart).toList()';
    default:
      return '(\$jsExpr as JSArray).toDart.cast<$elemStr>()';
  }
}

/// Handle Function type — wrap JSFunction in a Dart closure.
String _fromJSFunction(DartType t) {
  // For now generate a simple void callback wrapper
  if (t.getDisplayString(withNullability: true) == 'void Function()') {
    return '(() { final fn = \$jsExpr as JSFunction; return () => fn.callAsFunction(null); })()';
  }
  // General case: return a closure that calls with the right args
  return '''
(() {
  final fn = \$jsExpr as JSFunction;
  return () => fn.callAsFunction(null);
})()''';
}

String _typeStr(DartType t) => t.getDisplayString(withNullability: true);

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
      final id =
          'package:${step.inputId.package}/${step.inputId.path}#$name';
      final fields = r.namedFields;
      final inputFile = step.inputId.pathSegments.last;
      final reactFile = inputFile.replaceAll('.dart', '.react.dart');

      // ── .react.dart ── pure Dart, zero js_interop ─────────
      final pureParams = [
        ...fields.map(
            (f) => 'required ${_typeStr(f.type)} ${f.name}'),
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
        final expr = _toJSFor('props.${f.name}', f.type);
        if (_typeStr(f.type).endsWith('?')) {
          return 'if (props.${f.name} != null) o.setProperty(\'${f.name}\'.toJS, $expr!);';
        }
        return 'o.setProperty(\'${f.name}\'.toJS, $expr);';
      }).join('\n');

      final fromJSStatements = fields.map((f) {
        return _fromJSStatement(
            f.name, f.type, f.name, 'js.getProperty(\'${f.name}\'.toJS)');
      }).join('\n');

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
        '  JSObject wrapper(JSObject p){',
        '    final dartProps = _${name}_fromJS(p);',
        '    final tree = impl.${name}(dartProps);',
        '    return toReactJS(tree) as JSObject;',
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
