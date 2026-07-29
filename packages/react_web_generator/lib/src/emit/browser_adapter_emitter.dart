import 'dart:io';

import '../model/model.dart';

final class BrowserAdapterEmitter {
  final NeutralWebModel model;

  BrowserAdapterEmitter(this.model);

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'dart:js_interop';");
    buf.writeln();
    buf.writeln("import 'package:react_js/react_js.dart';");
    buf.writeln("import 'package:web/web.dart' as web;");
    buf.writeln();

    _emitElementWrappers(buf, model.types);
    _emitEventWrappers(buf, model.types);
    _emitRegistration(buf, model.types);

    final file = File('$outputDir/browser_adapter.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitElementWrappers(StringBuffer buf, Map<String, InterfaceDecl> types) {
    for (final entry in types.entries) {
      if (!entry.key.startsWith('web.HTML')) continue;
      if (entry.key == 'web.Element' || entry.key == 'web.HTMLElement') continue;
      if (entry.value.typeParameters.isNotEmpty) continue;

      final name = entry.value.name;
      buf.writeln('final class Browser$name {');
      buf.writeln('  final web.$name _element;');
      buf.writeln('  Browser$name(this._element);');
      buf.writeln('  web.$name get inner => _element;');
      buf.writeln('}');
      buf.writeln();
    }
  }

  void _emitEventWrappers(StringBuffer buf, Map<String, InterfaceDecl> types) {
    for (final entry in types.entries) {
      if (!entry.key.startsWith('react.')) continue;
      if (entry.value.typeParameters.isEmpty) continue;

      final name = entry.value.name;
      buf.writeln('final class Browser$name<T extends web.EventTarget> {');
      buf.writeln('  final web.Event _event;');
      buf.writeln('  Browser$name(this._event);');
      buf.writeln('  web.Event get inner => _event;');
      buf.writeln('}');
      buf.writeln();
    }
  }

  void _emitRegistration(StringBuffer buf, Map<String, InterfaceDecl> types) {
    buf.writeln('void registerBrowserAdapters() {');

    for (final entry in types.entries) {
      if (!entry.key.startsWith('web.HTML')) continue;
      if (entry.key == 'web.Element' || entry.key == 'web.HTMLElement') continue;
      if (entry.value.typeParameters.isNotEmpty) continue;

      final typeId = entry.key;
      final name = entry.value.name;
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$typeId',");
      buf.writeln("    decoder: (value) => Browser$name(value as web.$name),");
      buf.writeln("    encoder: (value) => (value as Browser$name)._element as JSAny?,");
      buf.writeln("  );");
    }

    for (final entry in types.entries) {
      if (!entry.key.startsWith('react.')) continue;
      if (entry.value.typeParameters.isEmpty) continue;

      final typeId = entry.key;
      final name = entry.value.name;
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$typeId<web.EventTarget>',");
      buf.writeln("    decoder: (value) => Browser$name(value as web.Event),");
      buf.writeln("  );");
    }

    buf.writeln('}');
    buf.writeln();
  }
}