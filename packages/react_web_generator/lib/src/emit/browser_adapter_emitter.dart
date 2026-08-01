import 'dart:io';

import '../model/model.dart';
import 'type_ref_resolver.dart';

final class BrowserAdapterEmitter {
  final NeutralWebModel model;
  late final TypeRefResolver _resolver;

  BrowserAdapterEmitter(this.model) {
    _resolver = TypeRefResolver(model.types);
  }

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'dart:js_interop';");
    buf.writeln("import 'dart:js_interop_unsafe';");
    buf.writeln();
    buf.writeln("import 'package:react_js/react_js.dart';");
    buf.writeln("import 'package:web/web.dart' as web;");
    buf.writeln(
      "import 'package:react_web/src/generated/event_interfaces.dart';",
    );
    buf.writeln(
      "import 'package:react_web/src/generated/html_interfaces.dart';",
    );
    buf.writeln();

    _emitElementWrappers(buf, model.types);
    _emitEventWrappers(buf, model.types);
    _emitRegistration(buf, model.types);

    final file = File('$outputDir/browser_adapter.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitElementWrappers(
    StringBuffer buf,
    Map<String, InterfaceDecl> types,
  ) {
    buf.writeln(
      'abstract class BrowserElementAdapter implements HTMLElement {',
    );
    buf.writeln('  @override');
    buf.writeln(
      '  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);',
    );
    buf.writeln('}');
    buf.writeln();

    for (final entry in types.entries) {
      if (!entry.key.startsWith('web.HTML')) continue;
      if (entry.key == 'web.Element' || entry.key == 'web.HTMLElement') {
        continue;
      }
      if (entry.value.typeParameters.isNotEmpty) continue;

      final name = entry.value.name;
      buf.writeln('final class Browser$name extends BrowserElementAdapter');
      buf.writeln('    implements $name {');
      buf.writeln('  final web.$name _element;');
      buf.writeln('  Browser$name(this._element);');
      buf.writeln('  @override');
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
      final members = _collectedMembers(entry.value, types);

      buf.writeln('final class Browser$name<T extends EventTarget>');
      buf.writeln('    implements $name<T> {');
      buf.writeln('  final JSObject _event;');
      buf.writeln('  Browser$name(this._event);');
      buf.writeln('  JSObject get inner => _event;');
      buf.writeln();

      final emitted = <String>{};
      final hasParent = entry.value.extends_.isNotEmpty;
      for (final member in members) {
        if (!emitted.add(member['name'] as String)) continue;
        final isOverride = hasParent;
        _emitMemberImplementation(buf, member, isOverride);
      }

      buf.writeln('}');
      buf.writeln();
    }
  }

  /// Collects all member declarations including inherited ones.
  List<Map<String, dynamic>> _collectedMembers(
    InterfaceDecl decl,
    Map<String, InterfaceDecl> types,
  ) {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];

    void walk(InterfaceDecl d) {
      // Walk parents first so inherited members come first.
      for (final ext in d.extends_) {
        if (ext is NamedTypeRef && types.containsKey(ext.typeId)) {
          walk(types[ext.typeId]!);
        }
      }
      for (final m in d.members) {
        if (!seen.add(m.name)) continue;
        if (m is AttributeDecl) {
          final dartType = _resolver.resolve(m.type);
          result.add({
            'name': m.name,
            'returnType': dartType,
            'kind': 'attribute',
            'nullable': m.type.nullable,
            'writable': m.writable,
          });
        } else if (m is OperationDecl) {
          result.add({
            'name': m.name,
            'returnType': _resolver.resolve(m.returnType),
            'kind': 'method',
            'nullable': m.returnType.nullable,
          });
        }
      }
    }

    walk(decl);
    return result;
  }

  void _emitMemberImplementation(
    StringBuffer buf,
    Map<String, dynamic> member, [
    bool isOverride = false,
  ]) {
    final name = member['name'] as String;
    final returnType = member['returnType'] as String;
    final kind = member['kind'] as String;
    final nullable = member['nullable'] as bool;

    final override = isOverride ? '@override\n  ' : '';
    if (kind == 'attribute') {
      // Skip setters — React event interfaces only expose readable attributes.
      buf.writeln(
        '  $override$returnType get $name => ${_jsGetter(name, returnType, nullable)};',
      );
    } else if (kind == 'method') {
      if (returnType == 'void') {
        buf.writeln(
          '  ${override}void $name() => _event.callMethod(\'$name\'.toJS);',
        );
      } else {
        buf.writeln(
          '  $override$returnType $name() => ${_jsGetter('$name()', returnType, nullable)};',
        );
      }
    }
  }

  String _jsGetter(String jsProp, String dartType, bool nullable) {
    // For methods like 'preventDefault()', strip the '()' suffix.
    final propName = jsProp.endsWith('()')
        ? jsProp.substring(0, jsProp.length - 2)
        : jsProp;
    final getter = "_event.getProperty('$propName'.toJS)";
    final expr = _convertJsToDart(getter, dartType, nullable);
    return expr;
  }

  String _convertJsToDart(String jsExpr, String dartType, bool nullable) {
    final baseType = nullable && dartType.endsWith('?')
        ? dartType.substring(0, dartType.length - 1)
        : dartType;

    String conversion(String nonNullExpr) {
      return switch (baseType) {
        'bool' => '($nonNullExpr as JSBoolean).toDart',
        'int' => '($nonNullExpr as JSNumber).toDartInt',
        'double' => '($nonNullExpr as JSNumber).toDartDouble',
        'String' => '($nonNullExpr as JSString).toDart',
        'void' => nonNullExpr,
        'T' => '($nonNullExpr as JSObject) as T',
        'EventTarget' => '($nonNullExpr as JSObject) as EventTarget',
        _ when baseType.startsWith('T') =>
          '($nonNullExpr as JSObject) as $baseType',
        _ => '($nonNullExpr as JSObject) as $baseType',
      };
    }

    if (nullable) {
      return '$jsExpr == null || $jsExpr.isUndefined ? null : ${conversion(jsExpr)}';
    }
    return conversion(jsExpr);
  }

  void _emitRegistration(StringBuffer buf, Map<String, InterfaceDecl> types) {
    buf.writeln('void registerBrowserAdapters() {');

    for (final entry in types.entries) {
      if (!entry.key.startsWith('web.HTML')) continue;
      if (entry.key == 'web.Element' || entry.key == 'web.HTMLElement') {
        continue;
      }
      if (entry.value.typeParameters.isNotEmpty) continue;

      final typeId = entry.value.name;
      final name = entry.value.name;
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$typeId',");
      buf.writeln("    decoder: (value) => Browser$name(value as web.$name),");
      buf.writeln(
        "    encoder: (value) => (value as Browser$name)._element as JSAny?,",
      );
      buf.writeln("  );");
    }

    for (final entry in types.entries) {
      if (!entry.key.startsWith('react.')) continue;
      if (entry.value.typeParameters.isEmpty) continue;

      final typeId = entry.key;
      final name = entry.value.name;

      // Register with the full generic form.
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$typeId<web.EventTarget>',");
      buf.writeln("    decoder: (value) => Browser$name(value as JSObject),");
      buf.writeln("  );");

      // Register with the short name (used by generated dom.dart).
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$name',");
      buf.writeln("    decoder: (value) => Browser$name(value as JSObject),");
      buf.writeln("  );");
    }

    buf.writeln('}');
    buf.writeln();
  }
}
