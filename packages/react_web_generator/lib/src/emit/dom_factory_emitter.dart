import 'dart:io';

import '../web_dart_type.dart';
import '../web_host_ir.dart';

final class DomFactoryEmitter {
  final List<WebHostElementIR> elements;

  const DomFactoryEmitter(this.elements);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// ignore_for_file: type=lint');
    buf.writeln();
    buf.writeln("import 'package:react_core/react.dart';");
    buf.writeln("import 'package:react_web/src/generated/react_events.dart';");
    buf.writeln("import 'package:react_web/src/generated/web/web.dart';");
    buf.writeln();

    final sorted = elements.toList()
      ..sort((a, b) => a.tagName.compareTo(b.tagName));

    for (final el in sorted) {
      _emitFactory(buf, el);
      _emitPropsBuilder(buf, el);
    }

    final file = File('$outputDir/dom.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitPropsBuilder(StringBuffer buf, WebHostElementIR el) {
    final factoryName = _safeIdent(el.factoryName);
    final builderName = '${_pascal(factoryName)}PropsBuilder';
    final factoryReference = '_${factoryName}BuilderFactory';

    buf.writeln('final $factoryReference = $factoryName;');
    buf.writeln('$builderName ${factoryName}Props() => $builderName();');
    buf.writeln();
    buf.writeln('final class $builderName {');
    for (final prop in el.props) {
      buf.writeln(
        '  ${_dt(prop.dartType, nullable: true)} ${_safeIdent(prop.reactName)};',
      );
    }
    for (final event in el.events) {
      final eventType = _dartTypeString(event.reactEventType);
      buf.writeln(
        '  void Function($eventType)? ${_safeIdent(event.reactName)};',
      );
      buf.writeln(
        '  void Function($eventType)? ${_safeIdent(event.captureName)};',
      );
    }
    buf.writeln('  void Function(${_dt(el.elementType)}?)? ref;');
    if (!el.voidElement) {
      buf.writeln('  ReactChildren children = const [];');
    }
    buf.writeln('  String? key;');
    buf.writeln('  Map<String, Object?> additionalProps = const {};');
    buf.writeln();
    buf.writeln(
      el.voidElement
          ? '  ReactNode call() {'
          : '  ReactNode call([ReactChildren? childValues]) {',
    );
    buf.writeln('    return $factoryReference(');
    for (final prop in el.props) {
      final name = _safeIdent(prop.reactName);
      buf.writeln('      $name: $name,');
    }
    for (final event in el.events) {
      final eventName = _safeIdent(event.reactName);
      final captureName = _safeIdent(event.captureName);
      buf.writeln('      $eventName: $eventName,');
      buf.writeln('      $captureName: $captureName,');
    }
    buf.writeln('      ref: ref,');
    if (!el.voidElement) {
      buf.writeln('      children: childValues ?? children,');
    }
    buf.writeln('      key: key,');
    buf.writeln('      additionalProps: additionalProps,');
    buf.writeln('    );');
    buf.writeln('  }');
    buf.writeln('}');
    buf.writeln();
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
      buf.writeln('  ReactChildren children = const [],');
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
    final refSpec =
        '(kind: ReactValueKind.hostValue, nullable: true, hostNamespace: \'web\', typeId: \'${el.elementType.symbol}\', codecId: null)';
    buf.writeln(
      '        signature: const (positional: [$refSpec], result: reactVoid, asynchronous: false),',
    );
    buf.writeln('        invoke: (args) {');
    buf.writeln('          ref(args[0] as ${_dt(el.elementType)}?);');
    buf.writeln('          return null;');
    buf.writeln('        },');
    buf.writeln('      )),');
    buf.writeln('      ...additionalProps,');
    buf.writeln('    },');
    if (!el.voidElement) {
      buf.writeln('    children: normalizeChildren(children),');
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
    final base = type.typeArguments.isEmpty
        ? clean
        : '$clean<${type.typeArguments.map((t) => _dartTypeString(t)).join(', ')}>';
    return isNullable ? '$base?' : base;
  }

  String _safeIdent(String s) {
    final base = s.contains('-') ? s.replaceAll('-', '_') : s;
    if (_dartKeywords.contains(base)) return '${base}_';
    return base;
  }

  String _pascal(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
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
