import 'dart:io';

import '../model/model.dart';

final class SsrMetadataEmitter {
  final NeutralWebModel model;

  SsrMetadataEmitter(this.model);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'package:react_web/src/ssr_metadata.dart';");
    buf.writeln();

    for (final entry in model.elements.entries) {
      _emitElementSsrDefinition(buf, entry.value);
    }

    final file = File('$outputDir/ssr_metadata.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitElementSsrDefinition(StringBuffer buf, ElementDecl decl) {
    final tagName = decl.tagName;
    final voidElement = decl.voidElement;

    buf.writeln('const ${_camelToPascal(tagName)}SsrDefinition = WebElementSsrDefinition(');
    buf.writeln("  tagName: '$tagName',");
    buf.writeln('  voidElement: $voidElement,');
    buf.writeln('  props: {');

    for (final prop in decl.props) {
      final ssrBehavior = _propSsrBehavior(prop);
      buf.writeln("    '${prop.name}': $ssrBehavior,");
    }

    buf.writeln('  },');
    buf.writeln(');');
    buf.writeln();
  }

  String _propSsrBehavior(PropDecl prop) {
    if (prop.name.startsWith('on')) return 'WebSsrBehavior.eventOmitted';
    if (prop.name == 'ref') return 'WebSsrBehavior.refOmitted';
    if (prop.name == 'dangerouslySetInnerHTML') return 'WebSsrBehavior.special';
    if (prop.name == 'children') return 'WebSsrBehavior.textContent';
    if (_isBooleanAttribute(prop)) return 'WebSsrBehavior.booleanAttribute';
    return 'WebSsrBehavior.attribute';
  }

  bool _isBooleanAttribute(PropDecl prop) {
    final type = prop.type;
    if (type is NamedTypeRef && type.typeId == 'core.bool') return true;
    return false;
  }

  String _camelToPascal(String s) {
    final parts = s.split('-');
    return parts.map((p) {
      if (p.isEmpty) return '';
      return p[0].toUpperCase() + p.substring(1);
    }).join();
  }
}