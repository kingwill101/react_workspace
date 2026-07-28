import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart' as elem;
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

String _typeStr(DartType t) => t.getDisplayString(withNullability: true);

bool _isNullable(DartType t) => _typeStr(t).endsWith('?');

class ComponentBuilder implements Builder {
  @override
  final buildExtensions = {'.dart': ['.react.dart', '.react.g.dart']};
  final _checker =
      TypeChecker.fromUrl('package:react/src/annotations.dart#ReactComponent');

  @override
  Future<void> build(BuildStep step) async {
    if (step.inputId.path.contains('.react.')) return;
    final lib = await step.resolver.libraryFor(step.inputId);
    for (final ann in LibraryReader(lib).annotatedWith(_checker)) {
      final fn = ann.element as elem.ExecutableElement;
      final r = fn.formalParameters.first.type as RecordType;
      final name = fn.name;
      final id =
          'package:${step.inputId.package}/${step.inputId.path}#$name';
      final named = r.namedFields;
      final pos = r.positionalFields;

      // Build parameter list for the public factory function
      final params = [
        for (var i = 0; i < pos.length; i++)
          '${_typeStr(pos[i].type)} \$$i',
        for (final f in named)
          'required ${_typeStr(f.type)} ${f.name}',
        'String? key',
        'List<ReactNode> children = const []',
      ].join(', ');

      // Argument list to pass to _${name}Props
      final posArgs = [
        for (var i = 0; i < pos.length; i++) '\$$i'
      ].join(', ');
      final namedArgs = [
        for (final f in named) '${f.name}: ${f.name}'
      ].join(', ');
      final allArgs = [
        if (posArgs.isNotEmpty) posArgs,
        if (namedArgs.isNotEmpty) namedArgs,
      ].join(', ');

      // Generate _${name}Props body
      final sb = StringBuffer('final o = JSObject();\n');
      for (var i = 0; i < pos.length; i++) {
        final t = pos[i].type;
        if (_isNullable(t)) {
          sb.writeln(
              "if (\$$i != null) o.setProperty('\$$i'.toJS, (\$$i as Object).toJS);");
        } else {
          sb.writeln("o.setProperty('\$$i'.toJS, \$$i.toJS);");
        }
      }
      for (final f in named) {
        final t = f.type;
        if (_isNullable(t)) {
          sb.writeln(
              "if (${f.name} != null) o.setProperty('${f.name}'.toJS, (${f.name} as Object).toJS);");
        } else {
          sb.writeln(
              "o.setProperty('${f.name}'.toJS, ${f.name}.toJS);");
        }
      }
      sb.write('return o;');

      final pure = [
        "import 'dart:js_interop';",
        "import 'dart:js_interop_unsafe';",
        "import 'package:react/react.dart';",
        "const id$name = ComponentId('$id');",
        'JSObject _${name}Props({${[
          for (var i = 0; i < pos.length; i++)
            '${_typeStr(pos[i].type)} \$$i',
          for (final f in named) 'required ${_typeStr(f.type)} ${f.name}',
        ].join(', ')}}) {',
        sb.toString().replaceAll('\n', '\n  '),
        '}',
        'ReactNode $name({$params}){',
        "  return Component(id$name, _${name}Props($allArgs),",
        '      key: key, children: children);',
        '}',
      ].join('\n');
      await step.writeAsString(
          step.inputId.changeExtension('.react.dart'), pure);

      // ---- .react.g.dart ----
      final getters = [
        for (var i = 0; i < pos.length; i++)
          "  @JS('\$$i') external JSAny get \$$i;",
        for (final f in named)
          '  external JSAny get ${f.name};',
      ].join('\n');
      final fromItems = [
        for (var i = 0; i < pos.length; i++)
          "\$$i: js.\$$i as ${_typeStr(pos[i].type)}",
        for (final f in named)
          '${f.name}: js.${f.name} as ${_typeStr(f.type)}',
      ];
      final from = fromItems.join(',\n');
      final inputFile = step.inputId.pathSegments.last;
      final reactFile = inputFile.replaceAll('.dart', '.react.dart');
      final js = [
        "import 'dart:js_interop';",
        "import 'package:react/react.dart';",
        "import '$inputFile' as impl;",
        "import '$reactFile' show id$name;",
        '@JS()',
        'extension type ${name}PropsJS._(JSObject _) implements JSObject {',
        getters,
        '}',
        '${_typeStr(r)} _${name}_fromJS(${name}PropsJS js) => (',
        from,
        ');',
        'final JSFunction \$$name = (() {',
        '  JSObject wrapper(JSObject p) {',
        '    final props = _${name}_fromJS(p as ${name}PropsJS);',
        '    final tree = impl.${name}(props);',
        '    return ReactInternal.renderer.render(tree) as JSObject;',
        '  }',
        '  return wrapper.toJS;',
        '})() as JSFunction;',
        'void register$name() =>'
            " ReactRegistry.register(id$name.value, \$$name);",
      ].join('\n');
      await step.writeAsString(
          step.inputId.changeExtension('.react.g.dart'), js);
    }
  }
}
