import 'dart:io';

import '../web_dart_type.dart';
import '../web_host_ir.dart';

/// Emits SVG intrinsic factories under the collision-free `Svg` namespace.
final class SvgFactoryEmitter {
  final List<WebHostElementIR> elements;

  const SvgFactoryEmitter(this.elements);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// ignore_for_file: type=lint');
    buf.writeln();
    buf.writeln("import 'package:react/react.dart';");
    buf.writeln("import 'package:react_web/src/generated/react_events.dart';");
    buf.writeln("import 'package:react_web/src/generated/web/web.dart';");
    buf.writeln();
    buf.writeln('abstract final class Svg {');

    final sorted = elements.toList()
      ..sort((a, b) => a.tagName.compareTo(b.tagName));
    for (final element in sorted) {
      _emitFactory(buf, element);
    }
    buf.writeln('}');

    final file = File('$outputDir/svg.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitFactory(StringBuffer buf, WebHostElementIR element) {
    final method = _safeIdent(element.factoryName);
    buf.writeln('  static ReactNode $method({');
    for (final prop in element.props) {
      buf.writeln(
        '    ${_dt(prop.dartType, nullable: true)} ${_safeIdent(prop.reactName)},',
      );
    }
    for (final event in element.events) {
      final eventType = _dartTypeString(event.reactEventType);
      buf.writeln(
        '    void Function($eventType)? ${_safeIdent(event.reactName)},',
      );
      buf.writeln(
        '    void Function($eventType)? ${_safeIdent(event.captureName)},',
      );
    }
    buf.writeln('    void Function(${_dt(element.elementType)}?)? ref,');
    buf.writeln('    ReactChildren children = const [],');
    buf.writeln('    String? key,');
    buf.writeln('    Map<String, Object?> additionalProps = const {},');
    buf.writeln('  }) {');
    buf.writeln('    return HostNode<Map<String, Object?>>(');
    buf.writeln(
      "      const HostType<Map<String, Object?>>('svg', '${element.tagName}'),",
    );
    buf.writeln('      {');
    for (final prop in element.props) {
      final name = _safeIdent(prop.reactName);
      buf.writeln("        if ($name != null) '${prop.reactName}': $name,");
    }
    for (final event in element.events) {
      _emitEvent(buf, element, event, capture: false);
      _emitEvent(buf, element, event, capture: true);
    }
    final refSpec =
        "(kind: ReactValueKind.hostValue, nullable: true, hostNamespace: 'web', typeId: '${element.elementType.symbol}', codecId: null)";
    buf.writeln("        if (ref != null) 'ref': ReactRefProp(ReactCallback(");
    buf.writeln("          debugName: 'Svg.$method.ref',");
    buf.writeln(
      '          signature: const (positional: [$refSpec], result: reactVoid, asynchronous: false),',
    );
    buf.writeln('          invoke: (args) {');
    buf.writeln('            ref(args[0] as ${_dt(element.elementType)}?);');
    buf.writeln('            return null;');
    buf.writeln('          },');
    buf.writeln('        )),');
    buf.writeln('        ...additionalProps,');
    buf.writeln('      },');
    buf.writeln('      children: normalizeChildren(children),');
    buf.writeln('      key: key,');
    buf.writeln('    );');
    buf.writeln('  }');
    buf.writeln();
  }

  void _emitEvent(
    StringBuffer buf,
    WebHostElementIR element,
    WebEventPropIR event, {
    required bool capture,
  }) {
    final reactName = capture ? event.captureName : event.reactName;
    final name = _safeIdent(reactName);
    final eventType = _dartTypeString(event.reactEventType);
    final eventSpec =
        "(kind: ReactValueKind.hostValue, nullable: false, hostNamespace: 'web', typeId: '$eventType', codecId: null)";
    buf.writeln(
      "        if ($name != null) '$reactName': ReactEventProp(ReactCallback(",
    );
    buf.writeln(
      "          debugName: 'Svg.${element.factoryName}.$reactName',",
    );
    buf.writeln(
      '          signature: const (positional: [$eventSpec], result: reactVoid, asynchronous: false),',
    );
    buf.writeln('          invoke: (args) {');
    buf.writeln('            $name(args[0] as $eventType);');
    buf.writeln('            return null;');
    buf.writeln('          },');
    buf.writeln('        )),');
  }

  String _dt(WebDartType type, {bool nullable = false}) =>
      _dartTypeString(type, nullable: nullable);

  String _dartTypeString(WebDartType type, {bool nullable = false}) {
    final isNullable = type.nullable || nullable;
    final clean = type.symbol.endsWith('?')
        ? type.symbol.substring(0, type.symbol.length - 1)
        : type.symbol;
    final base = type.typeArguments.isEmpty
        ? clean
        : '$clean<${type.typeArguments.map((t) => _dartTypeString(t)).join(', ')}>';
    return isNullable ? '$base?' : base;
  }

  String _safeIdent(String value) {
    final base = value.replaceAll('-', '_');
    return _dartKeywords.contains(base) ? '${base}_' : base;
  }

  static const _dartKeywords = <String>{
    'class',
    'default',
    'do',
    'for',
    'in',
    'is',
    'new',
    'switch',
    'var',
    'with',
  };
}
