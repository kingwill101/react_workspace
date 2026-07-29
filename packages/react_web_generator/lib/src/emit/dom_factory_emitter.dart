import 'dart:io';

import '../web_dart_type.dart';
import '../web_host_ir.dart';

final class DomFactoryEmitter {
  final List<WebHostElementIR> elements;

  const DomFactoryEmitter(this.elements);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'package:react/react.dart';");
    buf.writeln(
      "import 'package:react_web/src/generated/event_interfaces.dart';",
    );
    buf.writeln(
      "import 'package:react_web/src/generated/html_interfaces.dart';",
    );
    buf.writeln();

    final sorted = elements.toList()
      ..sort((a, b) => a.tagName.compareTo(b.tagName));

    for (final el in sorted) {
      _emitFactory(buf, el);
    }

    final file = File('$outputDir/dom.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitFactory(StringBuffer buf, WebHostElementIR el) {
    final hostName = '_${_safeIdent(el.tagName)}Host';

    buf.writeln(
      "const $hostName = HostType<Map<String, Object?>>('${_ns(el.namespace)}', '${el.tagName}');",
    );
    buf.writeln();

    buf.write('ReactNode ${_safeIdent(el.factoryName)}(');
    buf.writeln('{');
    for (final p in el.props) {
      final pn = _safeIdent(p.reactName);
      buf.writeln('  ${_dt(p.dartType, nullable: true)} $pn,');
    }
    for (final e in el.events) {
      final rt = _dartTypeString(e.reactEventType);
      final en = _safeIdent(e.reactName);
      final cn = _safeIdent(e.captureName);
      buf.writeln('  void Function($rt)? $en,');
      buf.writeln('  void Function($rt)? $cn,');
    }
    buf.writeln('  void Function(${_dt(el.elementType)}?)? ref,');
    if (!el.voidElement) {
      buf.writeln('  List<ReactNode> children = const [],');
    }
    buf.writeln('  String? key,');
    buf.writeln('  Map<String, Object?> additionalProps = const {},');
    buf.writeln('}) {');
    buf.writeln('  return HostNode<Map<String, Object?>>(');
    buf.writeln('    $hostName,');
    buf.writeln('    {');
    for (final p in el.props) {
      final pn = _safeIdent(p.reactName);
      buf.writeln("      if ($pn != null) '${p.reactName}': $pn,");
    }
    for (final e in el.events) {
      final rt = _dartTypeString(e.reactEventType);
      final en = _safeIdent(e.reactName);
      final cn = _safeIdent(e.captureName);
      final eventSpec =
          '(kind: ReactValueKind.hostValue, nullable: false, hostNamespace: \'web\', typeId: \'$rt\', codecId: null)';
      buf.writeln(
        "      if ($en != null) '${e.reactName}': ReactEventProp(ReactCallback(",
      );
      buf.writeln("        debugName: '${el.factoryName}.${e.reactName}',");
      buf.writeln(
        '        signature: const (positional: [$eventSpec], result: reactVoid, asynchronous: false),',
      );
      buf.writeln('        invoke: (args) {');
      buf.writeln('          $en(args[0] as $rt);');
      buf.writeln('          return null;');
      buf.writeln('        },');
      buf.writeln('      )),');
      buf.writeln(
        "      if ($cn != null) '${e.captureName}': ReactEventProp(ReactCallback(",
      );
      buf.writeln("        debugName: '${el.factoryName}.${e.captureName}',");
      buf.writeln(
        '        signature: const (positional: [$eventSpec], result: reactVoid, asynchronous: false),',
      );
      buf.writeln('        invoke: (args) {');
      buf.writeln('          $cn(args[0] as $rt);');
      buf.writeln('          return null;');
      buf.writeln('        },');
      buf.writeln('      )),');
    }
    buf.writeln("      if (ref != null) 'ref': ReactRefProp(ReactCallback(");
    buf.writeln("        debugName: '${el.factoryName}.ref',");
    buf.writeln(
      '        signature: const (positional: [reactAny], result: reactVoid, asynchronous: false),',
    );
    buf.writeln('        invoke: (args) {');
    buf.writeln('          ref(args[0] as ${_dt(el.elementType)}?);');
    buf.writeln('          return null;');
    buf.writeln('        },');
    buf.writeln('      )),');
    buf.writeln('      ...additionalProps,');
    buf.writeln('    },');
    if (!el.voidElement) {
      buf.writeln('    children: children,');
    }
    buf.writeln('    key: key,');
    buf.writeln('  );');
    buf.writeln('}');
    buf.writeln();
  }

  String _ns(WebNamespace ns) => switch (ns) {
    WebNamespace.html => 'html',
    WebNamespace.svg => 'svg',
    WebNamespace.mathMl => 'mathml',
  };

  String _dt(WebDartType t, {bool nullable = false}) =>
      _dartTypeString(t, nullable: nullable);

  String _dartTypeString(WebDartType type, {bool nullable = false}) {
    final isNullable = type.nullable || nullable;
    final clean = type.symbol.endsWith('?')
        ? type.symbol.substring(0, type.symbol.length - 1)
        : type.symbol;
    final base = isNullable ? '$clean?' : clean;
    if (type.typeArguments.isEmpty) return base;
    return '$base<${type.typeArguments.map((t) => _dartTypeString(t)).join(', ')}>';
  }

  String _safeIdent(String s) {
    final base = s.contains('-') ? s.replaceAll('-', '_') : s;
    if (_dartKeywords.contains(base)) return '${base}_';
    return base;
  }

  static const _dartKeywords = <String>{
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'out',
    'part',
    'required',
    'rethrow',
    'return',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  };
}
