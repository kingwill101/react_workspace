import 'dart:io';

import '../model/model.dart';

final class DomFactoryEmitter {
  final NeutralWebModel model;

  DomFactoryEmitter(this.model);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'package:react/react.dart';");
    buf.writeln();

    final sorted = model.elements.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in sorted) {
      _emitFactory(buf, entry.key, entry.value);
    }

    final file = File('$outputDir/dom.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitFactory(StringBuffer buf, String tagName, ElementDecl decl) {
    final hostName = '_${_safeIdent(tagName)}Host';

    buf.writeln("const $hostName = HostType<Map<String, Object?>>('${decl.namespace}', '$tagName');");
    buf.writeln();

    buf.write('ReactNode ${_safeIdent(tagName)}(');
    buf.writeln('{');
    buf.writeln('  Map<String, Object?> props = const {},');
    if (!decl.voidElement) {
      buf.writeln('  List<ReactNode> children = const [],');
    }
    buf.writeln('  String? key,');
    buf.writeln('}) {');
    buf.writeln('  return HostNode<Map<String, Object?>>(');
    buf.writeln('    $hostName,');
    buf.writeln('    props,');
    if (!decl.voidElement) {
      buf.writeln('    children: children,');
    }
    buf.writeln('    key: key,');
    buf.writeln('  );');
    buf.writeln('}');
    buf.writeln();
  }

  String _safeIdent(String s) {
    final base = s.contains('-') ? s.replaceAll('-', '_') : s;
    if (_dartKeywords.contains(base)) return '${base}_';
    return base;
  }

  static const _dartKeywords = <String>{
    'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
    'class', 'const', 'continue', 'covariant', 'default', 'deferred', 'do',
    'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
    'factory', 'false', 'final', 'finally', 'for', 'Function', 'get', 'hide',
    'if', 'implements', 'import', 'in', 'interface', 'is', 'late', 'library',
    'mixin', 'new', 'null', 'on', 'operator', 'out', 'part', 'required',
    'rethrow', 'return', 'set', 'show', 'static', 'super', 'switch', 'sync',
    'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield',
  };
}
