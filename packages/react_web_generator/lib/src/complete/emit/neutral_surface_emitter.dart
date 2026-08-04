/// Emits the complete neutral Web surface split per specification module.
library;

import 'dart:io';

import '../../model/type_ref.dart';
import '../definition.dart';
import '../member.dart';
import '../members.dart';
import '../model.dart';
import '../type_resolver.dart';

final class NeutralSurfaceEmitter {
  final CompleteWebModel model;
  final NeutralTypeResolver _resolver;

  NeutralSurfaceEmitter(this.model) : _resolver = NeutralTypeResolver(model);

  /// Web IDL definition names that collide with Dart reserved type or core
  /// identifiers and therefore cannot be declared; references lower to the
  /// analogous Dart built-in type instead.
  static const _reservedTypeNames = <String, String>{
    'Function': 'Function',
    'Object': 'Object',
    'String': 'String',
    'int': 'int',
    'double': 'double',
    'bool': 'bool',
    'dynamic': 'dynamic',
    'void': 'void',
    'num': 'num',
    'Null': 'Null',
    'Never': 'Never',
    'Future': 'Future',
    'List': 'List',
    'Map': 'Map',
    'Set': 'Set',
    'Iterable': 'Iterable',
    'Type': 'Type',
  };

  void emitTo(String outputDir) {
    final dir = Directory(outputDir);
    dir.createSync(recursive: true);

    final specs = <String, List<WebIdlDefinition>>{};
    for (final d in model.allDefinitions) {
      specs.putIfAbsent(d.spec, () => []).add(d);
    }

    for (final spec in specs.keys.toList()..sort()) {
      final defs = specs[spec]!..sort((a, b) => a.name.compareTo(b.name));
      _emitSpec(dir, spec, defs, specs.keys.toList());
    }

    _emitWebBarrel(dir, specs.keys.toList());
    _emitGlobals(dir);
  }

  /// Deterministic, sanitized module file name for a spec group.
  static String specFileName(String spec) {
    final sb = StringBuffer();
    for (final c in spec.toLowerCase().split('')) {
      if ((c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122) ||
          (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57)) {
        sb.write(c);
      } else {
        sb.write('_');
      }
    }
    var name = sb.toString();
    while (name.contains('__')) {
      name = name.replaceAll('__', '_');
    }
    name = name.replaceAll(RegExp(r'^_+|_+$'), '');
    return name.isEmpty ? 'misc' : name;
  }

  /// Emits a focused `package:react_web/<spec>.dart` library per module so
  /// users can `import 'package:react_web/storage.dart';` etc.
  void emitFocusedLibraries(String apisDir, List<String> specs) {
    final dir = Directory(apisDir);
    dir.createSync(recursive: true);
    final files = specs.map(specFileName).toSet()..remove('web');
    for (final f in files) {
      File('${dir.path}/$f.dart').writeAsStringSync(
        '// GENERATED CODE — DO NOT EDIT\n'
        '// Focused library for a specification module.\n'
        "export 'package:react_web/src/generated/web/$f.dart';\n",
      );
    }
  }

  String _fileName(String spec) => specFileName(spec);

  void _emitSpec(Directory dir, String spec, List<WebIdlDefinition> defs, List<String> allSpecs) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// Neutral Web surface for spec: $spec');
    buf.writeln('// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import');
    buf.writeln();

    final importSpecs = _requiredSpecs(defs, allSpecs)..remove(spec);
    for (final s in importSpecs) {
      buf.writeln("import '${_fileName(s)}.dart';");
    }
    buf.writeln();

    for (final d in defs) {
      if (_reservedTypeNames.containsKey(d.name)) continue;
      _emitDefinition(buf, d);
      buf.writeln();
    }

    File('${dir.path}/${_fileName(spec)}.dart').writeAsStringSync(buf.toString());
  }

  Set<String> _requiredSpecs(List<WebIdlDefinition> defs, List<String> allSpecs) {
    final names = <String>{};
    for (final d in defs) {
      _collectRefs(d, names);
    }
    final out = <String>{};
    for (final n in names) {
      final spec = model.specOf[n];
      if (spec != null) out.add(spec);
    }
    return out;
  }

  void _collectRefs(WebIdlDefinition d, Set<String> names) {
    void ref(TypeRef t) {
      switch (t) {
        case NamedTypeRef():
          final id = t.typeId;
          if (id.startsWith('web.')) names.add(id.substring(4));
          for (final a in t.arguments) {
            ref(a);
          }
        case UnionTypeRef():
          for (final o in t.options) {
            ref(o);
          }
        case TypeParameterRef():
          break;
      }
    }

    // Flatten inherited + mixin members so every referenced type's module is
    // imported (Dart imports are not transitive).
    final members = switch (d) {
      IdlInterface() => flattenMembers(model, d),
      IdlMixin() => d.members,
      IdlNamespace() => d.members,
      IdlCallbackInterface() => d.members,
      IdlDictionary() => d.fields,
      IdlCallback() => d.parameters,
      IdlEnum() || IdlIncludes() => const <Object>[],
      IdlTypedef() => <Object>[d.type],
    } as List;
    for (final m in members) {
      _refMember(m, ref);
    }
    if (d is IdlDictionary && d.inheritance != null) names.add(d.inheritance!);
  }

  void _refMember(Object m, void Function(TypeRef) ref) {
    switch (m) {
      case IdlAttribute(): ref(m.type);
      case IdlOperation():
        ref(m.returnType);
        for (final p in m.parameters) {
          ref(p.type);
        }
      case IdlConstructor():
        for (final p in m.parameters) {
          ref(p.type);
        }
      case IdlConstant(): ref(m.type);
      case IdlIterable():
        for (final t in m.types) {
          ref(t);
        }
      case IdlMaplike():
        ref(m.keyType);
        ref(m.valueType);
      case IdlSetlike(): ref(m.valueType);
      case IdlField(): ref(m.type);
      case IdlParameter(): ref(m.type);
    }
  }

  void _emitDefinition(StringBuffer buf, WebIdlDefinition d) {
    switch (d) {
      case IdlInterface(): _emitInterface(buf, d);
      case IdlMixin(): _emitMixin(buf, d);
      case IdlDictionary(): _emitDictionary(buf, d);
      case IdlNamespace(): _emitNamespace(buf, d);
      case IdlEnum(): _emitEnum(buf, d);
      case IdlTypedef(): _emitTypedef(buf, d);
      case IdlCallback(): _emitCallback(buf, d);
      case IdlCallbackInterface(): _emitCallbackInterface(buf, d);
      case IdlIncludes(): break;
    }
  }

  void _emitInterface(StringBuffer buf, IdlInterface d) {
    buf.writeln('abstract interface class ${d.name} {');
    _emitMembers(buf, flattenMembers(model, d), indent: '  ');
    buf.writeln('}');
  }

  void _emitMixin(StringBuffer buf, IdlMixin d) {
    buf.writeln('abstract interface class ${d.name} {');
    _emitMembers(buf, d.members.where((m) => !m.staticMember).toList(), indent: '  ');
    buf.writeln('}');
  }

  void _emitDictionary(StringBuffer buf, IdlDictionary d) {
    buf.writeln('abstract interface class ${d.name} {');
    for (final f in d.fields) {
      final t = _resolver.resolve(f.type);
      final fn = escapeIdentifier(f.name);
      buf.writeln('  $t get $fn;');
      buf.writeln('  set $fn($t value);');
    }
    buf.writeln('}');
  }

  void _emitEnum(StringBuffer buf, IdlEnum d) {
    buf.writeln('typedef ${d.name} = String;');
  }

  void _emitTypedef(StringBuffer buf, IdlTypedef d) {
    buf.writeln('typedef ${d.name} = ${_resolver.resolve(d.type)};');
  }

  void _emitCallback(StringBuffer buf, IdlCallback d) {
    final ret = _resolver.resolve(d.returnType);
    buf.write('typedef ${d.name} = $ret Function(');
    final parts = <String>[];
    for (var i = 0; i < d.parameters.length; i++) {
      final p = d.parameters[i];
      parts.add('${_resolver.resolve(p.type)} ${escapeIdentifier(p.name.isEmpty ? 'arg$i' : p.name)}');
    }
    if (parts.isNotEmpty) buf.write('${parts.join(', ')},');
    buf.writeln(');');
  }

  void _emitCallbackInterface(StringBuffer buf, IdlCallbackInterface d) {
    buf.writeln('abstract interface class ${d.name} {');
    _emitMembers(buf, d.members, indent: '  ');
    buf.writeln('}');
  }

  void _emitNamespace(StringBuffer buf, IdlNamespace d) {
    buf.writeln('abstract final class ${d.name} {');
    buf.writeln('  ${d.name}._();');
    final ops = <String, IdlOperation>{};
    final emitted = <String>{};
    for (final m in d.members) {
      switch (m) {
        case IdlOperation():
          final existing = ops[m.name];
          if (existing == null || m.parameters.length > existing.parameters.length) {
            ops[m.name] = m;
          }
        default: break;
      }
    }
    for (final m in d.members) {
      if (m is IdlOperation) {
        if (!emitted.add(m.name)) continue;
        _emitStaticOperation(buf, ops[m.name]!);
      } else if (m is IdlAttribute) {
        _emitStaticAttribute(buf, m);
      } else if (m is IdlConstant) {
        _emitStaticConstant(buf, m);
      }
    }
    buf.writeln('}');
  }

  void _emitStaticOperation(StringBuffer buf, IdlOperation m) {
    final ret = _resolver.resolve(m.returnType);
    buf.write('  static $ret ${escapeIdentifier(m.name)}(');
    buf.write(_paramStrings(m.parameters));
    buf.writeln(') => throw UnsupportedError(');
    buf.writeln("      '${m.name} is not supported in the neutral surface');");
  }

  void _emitStaticAttribute(StringBuffer buf, IdlAttribute m) {
    final t = _resolver.resolve(m.type);
    buf.writeln('  static $t get ${escapeIdentifier(m.name)} =>');
    buf.writeln("      throw UnsupportedError('${m.name} not supported in neutral surface');");
  }

  void _emitStaticConstant(StringBuffer buf, IdlConstant m) {
    buf.writeln('  static const ${_resolver.resolve(m.type)} ${escapeIdentifier(m.name)} =');
    buf.writeln("      ${m.value ?? 'null'};");
  }

  void _emitMembers(StringBuffer buf, List<IdlMember> members, {required String indent}) {
    final ops = <String, IdlOperation>{};
    final emitOrder = <IdlMember>[];
    for (final m in members) {
      if (m is IdlOperation) {
        final existing = ops[m.name];
        if (existing == null || m.parameters.length > existing.parameters.length) {
          ops[m.name] = m;
        }
        if (!emitOrder.any((e) => e is IdlOperation && e.name == m.name)) {
          emitOrder.add(m);
        }
      } else {
        emitOrder.add(m);
      }
    }
    for (final m in emitOrder) {
      switch (m) {
        case IdlOperation(): _emitMethod(buf, ops[m.name]!, indent);
        case IdlAttribute(): _emitAttribute(buf, m, indent);
        case IdlConstant(): _emitConst(buf, m, indent);
        case IdlIterable(): _emitIterable(buf, m, indent);
        case IdlMaplike(): _emitMaplike(buf, m, indent);
        case IdlSetlike(): _emitSetlike(buf, m, indent);
        case IdlConstructor(): break;
        case IdlField(): break;
      }
    }
  }

  void _emitMethod(StringBuffer buf, IdlOperation m, String indent) {
    if (m.name.isEmpty) return;
    final ret = _resolver.resolve(m.returnType);
    final name = escapeIdentifier(m.name);
    // Legacy factory functions are named after the type they return; that name
    // shadows the return type in its own signature, so it cannot be declared.
    // It is constructor-like and therefore omitted from the instance contract.
    if (m.name == ret) return;
    buf.write('$indent$ret $name(');
    buf.write(_paramStrings(m.parameters));
    buf.writeln(');');
  }

  String _paramStrings(List<IdlParameter> params) {
    final required = <String>[];
    final optional = <String>[];
    for (var i = 0; i < params.length; i++) {
      final p = params[i];
      final name = escapeIdentifier(p.name.isEmpty ? 'arg$i' : p.name);
      var t = _resolver.resolve(p.type);
      if (p.variadic && !t.endsWith('List')) t = 'List<$t>';
      final s = '$t $name';
      if (!p.required || p.variadic) {
        if (!t.endsWith('?')) t = '$t?';
        optional.add('$t $name');
      } else {
        required.add(s);
      }
    }
    final parts = <String>[];
    if (required.isNotEmpty) parts.add(required.join(', '));
    if (optional.isNotEmpty) parts.add('[${optional.join(', ')}]');
    return parts.join(', ');
  }

  void _emitAttribute(StringBuffer buf, IdlAttribute m, String indent) {
    final t = _resolver.resolve(m.type);
    final name = escapeIdentifier(m.name);
    buf.writeln('$indent$t get $name;');
    if (!m.readonly) {
      buf.writeln('$indent set $name($t value);');
    }
  }

  void _emitConst(StringBuffer buf, IdlConstant m, String indent) {
    buf.writeln('$indent static const ${_resolver.resolve(m.type)} ${escapeIdentifier(m.name)} =');
    buf.writeln('$indent    ${m.value ?? 'null'};');
  }

  void _emitIterable(StringBuffer buf, IdlIterable m, String indent) {
    final names = m.types.map(_resolver.resolve).toList();
    if (m.types.length >= 2) {
      buf.writeln('$indent Iterable<(${names[0]}, ${names[1]})> get entries;');
      buf.writeln('$indent Iterable<${names[0]}> get keys;');
      buf.writeln('$indent Iterable<${names[1]}> get values;');
    } else {
      buf.writeln('$indent Iterable<${names.first}> get values;');
    }
  }

  void _emitMaplike(StringBuffer buf, IdlMaplike m, String indent) {
    final k = _resolver.resolve(m.keyType);
    final v = _resolver.resolve(m.valueType);
    buf.writeln('$indent Iterable<$k> get keys;');
    buf.writeln('$indent Iterable<$v> get values;');
    buf.writeln('$indent Iterable<MapEntry<$k, $v>> get entries;');
    buf.writeln('$indent $v? operator [](Object key);');
    buf.writeln('$indent bool has(Object key);');
  }

  void _emitSetlike(StringBuffer buf, IdlSetlike m, String indent) {
    final v = _resolver.resolve(m.valueType);
    buf.writeln('$indent Iterable<$v> get values;');
    buf.writeln('$indent bool has(Object value);');
  }

  void _emitWebBarrel(Directory dir, List<String> specs) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// Exports the complete neutral Web surface.');
    buf.writeln();
    for (final s in specs.toList()..sort()) {
      buf.writeln("export '${_fileName(s)}.dart';");
    }
    buf.writeln("export 'globals.dart';");
    File('${dir.path}/web.dart').writeAsStringSync(buf.toString());
  }

  void _emitGlobals(Directory dir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'package:react_web/src/web_runtime.dart';");
    buf.writeln("import 'web.dart';");
    buf.writeln();
    buf.writeln('Window get window => WebRuntime.current.window;');
    buf.writeln('Document get document => WebRuntime.current.document;');
    File('${dir.path}/globals.dart').writeAsStringSync(buf.toString());
  }
}
