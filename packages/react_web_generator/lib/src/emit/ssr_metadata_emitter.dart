import 'dart:io';

import '../web_host_ir.dart';

/// Emits SSR behavior metadata (`generated/ssr_metadata.dart`) from the host
/// IR, so the server renderer knows how to lower each element/prop.
final class SsrMetadataEmitter {
  final List<WebHostElementIR> elements;

  const SsrMetadataEmitter(this.elements);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'package:react_web/src/ssr_metadata.dart';");
    buf.writeln();

    for (final el in elements) {
      _emitElementSsrDefinition(buf, el);
    }

    buf.writeln(
      'const Map<String, WebElementSsrDefinition> ssrDefinitions = {',
    );
    for (final el in elements) {
      buf.writeln(
        "  '${el.tagName}': ${_camelToPascal(el.tagName)}SsrDefinition,",
      );
    }
    buf.writeln('};');
    buf.writeln();

    final file = File('$outputDir/ssr_metadata.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitElementSsrDefinition(StringBuffer buf, WebHostElementIR el) {
    buf.writeln(
      'const ${_camelToPascal(el.tagName)}SsrDefinition = WebElementSsrDefinition(',
    );
    buf.writeln("  tagName: '${el.tagName}',");
    buf.writeln('  voidElement: ${el.voidElement},');
    buf.writeln('  props: {');

    for (final prop in el.props) {
      buf.writeln(
        "    '${prop.reactName}': WebSsrBehavior.${prop.ssrBehavior.name},",
      );
    }
    for (final event in el.events) {
      buf.writeln("    '${event.reactName}': WebSsrBehavior.eventOmitted,");
      buf.writeln("    '${event.captureName}': WebSsrBehavior.eventOmitted,");
    }

    buf.writeln("    'key': WebSsrBehavior.unsupported,");
    buf.writeln("    'ref': WebSsrBehavior.refOmitted,");
    buf.writeln("    'children': WebSsrBehavior.textContent,");
    buf.writeln("    'dangerouslySetInnerHTML': WebSsrBehavior.special,");

    buf.writeln('  },');
    buf.writeln(');');
    buf.writeln();
  }

  String _camelToPascal(String s) {
    final parts = s.split('-');
    return parts.map((p) {
      if (p.isEmpty) return '';
      return p[0].toUpperCase() + p.substring(1);
    }).join();
  }
}
