import 'package:react_web_generator/src/web_dart_type.dart';
import 'package:react_web_generator/src/web_host_ir.dart';

final class FactoryEmitter {
  final List<WebHostElementIR> elements;

  const FactoryEmitter(this.elements);

  String emit() {
    final buf = StringBuffer();
    buf.writeln("// GENERATED CODE — DO NOT EDIT");
    buf.writeln();

    buf.writeln("import 'package:react/react.dart';");
    buf.writeln("import 'package:react_web/src/event_interfaces.dart';");
    buf.writeln("import 'package:react_web/src/types/html_interfaces.dart';");
    buf.writeln();

    for (final el in elements) {
      _emitElement(buf, el);
    }

    // Value spec constants
    for (final el in elements) {
      final et = _dartTypeString(el.elementType);
      for (final event in el.events) {
        _emitEventSpec(buf, el, event);
      }
      _emitRefSpec(buf, el, et);
    }

    // Callback wrapper helpers
    for (final el in elements) {
      final et = _dartTypeString(el.elementType);
      for (final event in el.events) {
        _emitEventWrapper(buf, el, event, et);
      }
      _emitRefWrapper(buf, el, et);
    }

    return buf.toString();
  }

  void _emitElement(StringBuffer buf, WebHostElementIR el) {
    final hc = '_${el.factoryName}HostType';

    buf.writeln("const $hc = HostType<Map<String, Object?>>('${el.namespace.name}', '${el.tagName}');");
    buf.writeln();

    buf.writeln("ReactNode ${el.factoryName}({");
    for (final p in el.props) {
      buf.writeln("  ${_dt(p.dartType, nullable: true)} ${p.reactName},");
    }
    for (final e in el.events) {
      final rt = _dartTypeString(e.reactEventType);
      buf.writeln("  void Function($rt)? ${e.reactName},");
      buf.writeln("  void Function($rt)? ${e.captureName},");
    }
    buf.writeln("  void Function(${_dt(el.elementType)}?)? ref,");
    buf.writeln("  List<ReactNode> children = const [],");
    buf.writeln("  String? key,");
    buf.writeln("  Map<String, Object?> additionalProps = const {},");
    buf.writeln("}) {");
    buf.writeln("  return HostNode<Map<String, Object?>>(");
    buf.writeln("    $hc,");
    buf.writeln("    {");
    for (final p in el.props) {
      buf.writeln("      if (${p.reactName} != null) '${p.reactName}': ${p.reactName},");
    }
    for (final e in el.events) {
      buf.writeln("      if (${e.reactName} != null) '${e.reactName}': ReactEventProp(_${el.factoryName}${_pascal(e.reactName)}(${e.reactName})),");
      buf.writeln("      if (${e.captureName} != null) '${e.captureName}': ReactEventProp(_${el.factoryName}${_pascal(e.captureName)}(${e.captureName})),");
    }
      buf.writeln("      if (ref != null) 'ref': ReactRefProp(_${el.factoryName}Ref(ref)),");
    buf.writeln("      ...additionalProps,");
    buf.writeln("    },");
    buf.writeln("    children: children,");
    buf.writeln("    key: key,");
    buf.writeln("  );");
    buf.writeln("}");
    buf.writeln();
  }

  void _emitEventSpec(StringBuffer buf, WebHostElementIR el, WebEventPropIR event) {
    final reactType = _dartTypeString(event.reactEventType);
    for (final name in [event.reactName, event.captureName]) {
      final specName = '_${el.factoryName}_${name}Spec';
      buf.writeln("const $specName = (");
      buf.writeln("  kind: ReactValueKind.hostValue,");
      buf.writeln("  nullable: false,");
      buf.writeln("  hostNamespace: 'web',");
      buf.writeln("  typeId: '$reactType',");
      buf.writeln("  codecId: null,");
      buf.writeln(");");
      buf.writeln();
    }
  }

  void _emitRefSpec(StringBuffer buf, WebHostElementIR el, String elementType) {
    buf.writeln("const _${el.factoryName}_refSpec = (");
    buf.writeln("  kind: ReactValueKind.hostValue,");
    buf.writeln("  nullable: true,");
    buf.writeln("  hostNamespace: 'web',");
    buf.writeln("  typeId: '$elementType',");
    buf.writeln("  codecId: null,");
    buf.writeln(");");
    buf.writeln();
  }

  void _emitEventWrapper(StringBuffer buf, WebHostElementIR el, WebEventPropIR event, String elementType) {
    final reactType = _dartTypeString(event.reactEventType);
    for (final entry in [
      (name: event.reactName, specName: '_${el.factoryName}_${event.reactName}Spec'),
      (name: event.captureName, specName: '_${el.factoryName}_${event.captureName}Spec'),
    ]) {
      final funcName = '_${el.factoryName}${_pascal(entry.name)}';
      buf.writeln("ReactCallback $funcName(void Function($reactType) callback) {");
      buf.writeln("  return ReactCallback(");
      buf.writeln("    debugName: '${el.factoryName}.${entry.name}',");
      buf.writeln("    signature: const (positional: [${entry.specName}], result: reactVoid, asynchronous: false),");
      buf.writeln("    invoke: (arguments) {");
      buf.writeln("      callback(arguments[0] as $reactType);");
      buf.writeln("      return null;");
      buf.writeln("    },");
      buf.writeln("  );");
      buf.writeln("}");
      buf.writeln();
    }
  }

  void _emitRefWrapper(StringBuffer buf, WebHostElementIR el, String elementType) {
    buf.writeln("ReactCallback _${el.factoryName}Ref(void Function($elementType?) callback) {");
    buf.writeln("  return ReactCallback(");
    buf.writeln("    debugName: '${el.factoryName}.ref',");
    buf.writeln("    signature: const (positional: [_${el.factoryName}_refSpec], result: reactVoid, asynchronous: false),");
    buf.writeln("    invoke: (arguments) {");
    buf.writeln("      final value = arguments[0];");
    buf.writeln("      callback(value == null ? null : value as $elementType);");
    buf.writeln("      return null;");
    buf.writeln("    },");
    buf.writeln("  );");
    buf.writeln("}");
    buf.writeln();
  }

  String _dt(WebDartType t, {bool nullable = false}) =>
      _dartTypeString(t, nullable: nullable);

  String _dartTypeString(WebDartType type, {bool nullable = false}) {
    final isNullable = type.nullable || nullable;
    final clean = type.symbol.endsWith('?')
        ? type.symbol.substring(0, type.symbol.length - 1)
        : type.symbol;
    final base = isNullable ? '$clean?' : clean;
    if (type.typeArguments.isEmpty) return base;
    return '${base}<${type.typeArguments.map((t) => _dartTypeString(t)).join(', ')}>';
  }

  String _pascal(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
