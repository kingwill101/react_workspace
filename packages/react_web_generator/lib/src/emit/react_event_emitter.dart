import 'dart:io';

import 'react_event_defs.dart';

/// Emits the neutral React synthetic event interfaces into
/// `generated/react_events.dart`.
///
/// React synthetic events are React-specific (not part of the Web IDL
/// snapshot), so they are authored as stable declarations (see
/// [reactEventDefs]). They reference the complete neutral surface
/// (`web/web.dart`) for DOM types such as `EventTarget`, keeping everything on
/// a single type system.
final class ReactEventEmitter {
  const ReactEventEmitter();

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// ignore_for_file: type=lint');
    buf.writeln();
    buf.writeln('/// Neutral React synthetic event interfaces.');
    buf.writeln('///');
    buf.writeln(
      '/// These abstract interfaces correspond to React synthetic events and are',
    );
    buf.writeln(
      '/// typed against the complete neutral surface (`web/web.dart`).',
    );
    buf.writeln('library;');
    buf.writeln();
    buf.writeln("import 'web/web.dart';");
    buf.writeln();

    for (final decl in reactEventDefs) {
      _emitInterface(buf, decl);
      buf.writeln();
    }

    final file = File('$outputDir/react_events.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitInterface(StringBuffer buf, ReactEventDef decl) {
    buf.write('abstract interface class ${decl.name}<T extends EventTarget>');
    if (decl.implements_.isNotEmpty) {
      buf.write(' implements ');
      buf.write(decl.implements_.join(', '));
    }
    buf.writeln(' {');
    for (final m in decl.members) {
      buf.writeln('  ${m.returnType} get ${m.name};');
    }
    for (final m in decl.methods) {
      buf.writeln('  ${m.returnType} ${m.name}();');
    }
    buf.writeln('}');
  }
}
