/// Emits the complete neutral Web surface split per specification module.
library;

import 'dart:convert';
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
  final Set<String> _renderedTypeDependencies = {};

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
      _emitSpec(dir, spec, defs);
    }

    _emitWebBarrel(dir, specs.keys.toList());
    _emitGlobals(dir);
    _writeEmittedManifest(outputDir);
  }

  void _writeEmittedManifest(String outputDir) {
    // Build manifest from actually emitted definitions/members (mirrors
    // CompletenessVerifier._memberIds but collected during emission).
    final definitions = <String>{};
    final members = <String>{};
    for (final d in model.allDefinitions) {
      if (_reservedTypeNames.containsKey(d.name)) continue;
      definitions.add('${d.kindName}:${d.name}');
      switch (d) {
        case IdlInterface():
          final flat = flattenMembers(model, d);
          final ops = <String, IdlOperation>{};
          for (final m in flat) {
            if (m is IdlOperation) {
              final ex = ops[m.name];
              if (ex == null || m.parameters.length > ex.parameters.length) {
                ops[m.name] = m;
              }
            }
          }
          final seen = <String>{};
          for (final m in flat) {
            switch (m) {
              case IdlOperation():
                if (!seen.add(m.name)) continue;
                members.add('${d.name}.${ops[m.name]!.name}:operation');
              case IdlAttribute():
                members.add('${d.name}.${m.name}:attribute');
              case IdlConstant():
                members.add('${d.name}.${m.name}:const');
              case IdlIterable():
                members.add('${d.name}.iterable:iterable');
              case IdlMaplike():
                members.add('${d.name}.maplike:maplike');
              case IdlSetlike():
                members.add('${d.name}.setlike:setlike');
              case IdlConstructor():
                members.add('${d.name}.constructor:constructor');
              case IdlField():
                break;
            }
          }
        case IdlMixin():
          for (final m in d.members) {
            switch (m) {
              case IdlAttribute():
                members.add('${d.name}.${m.name}:attribute');
              case IdlOperation():
                members.add('${d.name}.${m.name}:operation');
              case IdlConstant():
                members.add('${d.name}.${m.name}:const');
              case IdlIterable():
                members.add('${d.name}.iterable:iterable');
              case IdlMaplike():
                members.add('${d.name}.maplike:maplike');
              case IdlSetlike():
                members.add('${d.name}.setlike:setlike');
              case _:
                break;
            }
          }
        case IdlDictionary():
          for (final f in d.fields) {
            members.add('${d.name}.${f.name}:field');
          }
        case IdlNamespace():
          for (final m in d.members) {
            switch (m) {
              case IdlOperation():
                members.add('${d.name}.${m.name}:operation');
              case IdlAttribute():
                members.add('${d.name}.${m.name}:attribute');
              case IdlConstant():
                members.add('${d.name}.${m.name}:const');
              case _:
                break;
            }
          }
        case IdlCallbackInterface():
          for (final m in d.members) {
            switch (m) {
              case IdlAttribute():
                members.add('${d.name}.${m.name}:attribute');
              case IdlOperation():
                members.add('${d.name}.${m.name}:operation');
              case IdlConstant():
                members.add('${d.name}.${m.name}:const');
              case _:
                break;
            }
          }
        case IdlEnum() || IdlTypedef() || IdlCallback() || IdlIncludes():
          break;
      }
    }
    final manifest = {
      'definitions': (definitions.toList()..sort()),
      'members': (members.toList()..sort()),
    };
    File(
      '${Directory(outputDir).parent.path}/emitted_manifest.json',
    ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
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
  ///
  /// Stale files are removed first (everything in [apisDir] is generated) and
  /// a focused library is only emitted when its corresponding surface file
  /// exists under [surfaceDir].
  void emitFocusedLibraries(
    String apisDir,
    List<String> specs, {
    String surfaceDir = 'packages/react_web/lib/src/generated/web',
  }) {
    final dir = Directory(apisDir);
    dir.createSync(recursive: true);
    for (final stale in dir.listSync()) {
      if (stale is File && stale.path.endsWith('.dart')) {
        stale.deleteSync();
      }
    }
    final files = specs.map(specFileName).toSet()..remove('web');
    for (final f in files) {
      if (!File('$surfaceDir/$f.dart').existsSync()) continue;
      File('${dir.path}/$f.dart').writeAsStringSync(
        '// GENERATED CODE — DO NOT EDIT\n'
        '// Focused library for a specification module.\n'
        "export 'package:react_web/src/generated/web/$f.dart';\n",
      );
    }
  }

  String _fileName(String spec) => specFileName(spec);

  void _emitSpec(Directory dir, String spec, List<WebIdlDefinition> defs) {
    _renderedTypeDependencies.clear();
    final body = StringBuffer();
    for (final d in defs) {
      if (_reservedTypeNames.containsKey(d.name)) continue;
      _emitDefinition(body, d);
      body.writeln();
    }

    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// Neutral Web surface for spec: $spec');
    buf.writeln('// ignore_for_file: type=lint');
    buf.writeln();

    final importSpecs =
        <String>{
            for (final name in _renderedTypeDependencies) model.specOf[name]!,
          }.toList()
          ..remove(spec)
          ..sort();
    for (final s in importSpecs) {
      buf.writeln("import '${_fileName(s)}.dart';");
    }
    if (body.toString().contains('WebRuntime.')) {
      buf.writeln("import 'package:react_web/src/web_runtime.dart';");
    }
    buf.writeln();
    buf.write(body);

    File(
      '${dir.path}/${_fileName(spec)}.dart',
    ).writeAsStringSync(buf.toString());
  }

  String _resolve(TypeRef ref) {
    _recordRenderedTypeDependencies(ref);
    return _resolver.resolve(ref);
  }

  void _recordRenderedTypeDependencies(TypeRef ref) {
    switch (ref) {
      case NamedTypeRef():
        final id = ref.typeId;
        if (id.startsWith('web.')) {
          final name = id.substring(4);
          if (!_reservedTypeNames.containsKey(name) &&
              model.definitionByName(name) != null) {
            _renderedTypeDependencies.add(name);
          }
        }
        for (final argument in ref.arguments) {
          _recordRenderedTypeDependencies(argument);
        }
      case UnionTypeRef():
        // NeutralTypeResolver lowers the entire union to Object, so none of
        // its alternatives appear in the emitted signature.
        break;
      case TypeParameterRef():
        break;
    }
  }

  void _emitDefinition(StringBuffer buf, WebIdlDefinition d) {
    switch (d) {
      case IdlInterface():
        _emitInterface(buf, d);
      case IdlMixin():
        _emitMixin(buf, d);
      case IdlDictionary():
        _emitDictionary(buf, d);
      case IdlNamespace():
        _emitNamespace(buf, d);
      case IdlEnum():
        _emitEnum(buf, d);
      case IdlTypedef():
        _emitTypedef(buf, d);
      case IdlCallback():
        _emitCallback(buf, d);
      case IdlCallbackInterface():
        _emitCallbackInterface(buf, d);
      case IdlIncludes():
        break;
    }
  }

  void _emitInterface(StringBuffer buf, IdlInterface d) {
    buf.writeln('abstract interface class ${d.name} {');
    _emitConstructors(buf, d);
    _emitMembers(buf, flattenMembers(model, d), indent: '  ');
    buf.writeln('}');
  }

  /// Emits runtime-dispatched factory constructors for constructible
  /// interfaces. The factory hands the IDL constructor arguments to the
  /// installed [WebRuntime], which returns the backend implementation (a
  /// `Browser*` proxy on the browser, a throwing `Ssr*` stub during SSR).
  void _emitConstructors(StringBuffer buf, IdlInterface d) {
    final ctors = d.members.whereType<IdlConstructor>().toList();
    for (var i = 0; i < ctors.length; i++) {
      final c = ctors[i];
      final ctorName = i == 0 ? d.name : '${d.name}.named$i';
      buf.writeln('  factory $ctorName(${_paramStrings(c.parameters)}) =>');
      buf.writeln('      WebRuntime.current.createWebObject<${d.name}>(');
      buf.writeln("        '${d.name}',");
      buf.writeln('        [${_ctorArgNames(c.parameters)}],');
      buf.writeln('      );');
    }
  }

  String _ctorArgNames(List<IdlParameter> params) => [
    for (var i = 0; i < params.length; i++)
      escapeIdentifier(params[i].name.isEmpty ? 'arg$i' : params[i].name),
  ].join(', ');

  void _emitMixin(StringBuffer buf, IdlMixin d) {
    buf.writeln('abstract interface class ${d.name} {');
    _emitMembers(
      buf,
      d.members.where((m) => !m.staticMember).toList(),
      indent: '  ',
    );
    buf.writeln('}');
  }

  void _emitDictionary(StringBuffer buf, IdlDictionary d) {
    String dictionaryType(IdlField f) {
      var t = _resolve(f.type);
      if (!f.required && !t.endsWith('?')) t = '$t?';
      return t;
    }

    buf.writeln('abstract interface class ${d.name} {');
    for (final f in d.fields) {
      final t = dictionaryType(f);
      final fn = escapeIdentifier(f.name);
      buf.writeln('  $t get $fn;');
      buf.writeln('  set $fn($t value);');
    }
    buf.writeln('}');
    buf.writeln();
    // Portable construction value type so callers can build dictionary
    // arguments (e.g. StorageEventInit) without hand-writing JS objects.
    buf.writeln('final class ${d.name}Value implements ${d.name} {');
    for (final f in d.fields) {
      final t = dictionaryType(f);
      final fn = escapeIdentifier(f.name);
      buf.writeln('  @override');
      buf.writeln('  $t $fn;');
    }
    buf.writeln();
    if (d.fields.isEmpty) {
      buf.writeln('  ${d.name}Value();');
    } else {
      buf.writeln('  ${d.name}Value({');
      for (final f in d.fields) {
        final fn = escapeIdentifier(f.name);
        if (f.required) {
          buf.writeln('    required this.$fn,');
        } else {
          buf.writeln('    this.$fn,');
        }
      }
      buf.writeln('  });');
    }
    buf.writeln('}');
  }

  void _emitEnum(StringBuffer buf, IdlEnum d) {
    buf.writeln('typedef ${d.name} = String;');
  }

  void _emitTypedef(StringBuffer buf, IdlTypedef d) {
    buf.writeln('typedef ${d.name} = ${_resolve(d.type)};');
  }

  void _emitCallback(StringBuffer buf, IdlCallback d) {
    final ret = _resolve(d.returnType);
    buf.write('typedef ${d.name} = $ret Function(');
    final parts = <String>[];
    for (var i = 0; i < d.parameters.length; i++) {
      final p = d.parameters[i];
      parts.add(
        '${_resolve(p.type)} ${escapeIdentifier(p.name.isEmpty ? 'arg$i' : p.name)}',
      );
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
          if (existing == null ||
              m.parameters.length > existing.parameters.length) {
            ops[m.name] = m;
          }
        default:
          break;
      }
    }
    for (final m in d.members) {
      if (m is IdlOperation) {
        if (!emitted.add(m.name)) continue;
        final op = ops[m.name]!;
        final ret = _resolve(op.returnType);
        final paramNames = [
          for (var i = 0; i < op.parameters.length; i++)
            escapeIdentifier(
              op.parameters[i].name.isEmpty ? 'arg$i' : op.parameters[i].name,
            ),
        ];
        buf.write('  static $ret ${escapeIdentifier(op.name)}(');
        buf.write(_paramStrings(op.parameters));
        buf.writeln(') => WebRuntime.current.invokeNamespace(');
        buf.writeln(
          "      '${d.name}', '${op.name}', [${paramNames.join(', ')}]) as $ret;",
        );
      } else if (m is IdlAttribute) {
        final t = _resolve(m.type);
        final name = escapeIdentifier(m.name);
        buf.writeln('  static $t get $name =>');
        buf.writeln(
          "      WebRuntime.current.getNamespaceProperty('${d.name}', '${m.name}') as $t;",
        );
        if (!m.readonly) {
          buf.writeln('  static set $name($t value) =>');
          buf.writeln(
            "      WebRuntime.current.setNamespaceProperty('${d.name}', '${m.name}', value);",
          );
        }
      } else if (m is IdlConstant) {
        _emitStaticConstant(buf, m);
      }
    }
    buf.writeln('}');
  }

  void _emitStaticConstant(StringBuffer buf, IdlConstant m) {
    buf.writeln(
      '  static const ${_resolve(m.type)} ${escapeIdentifier(m.name)} =',
    );
    buf.writeln("      ${m.value ?? 'null'};");
  }

  void _emitMembers(
    StringBuffer buf,
    List<IdlMember> members, {
    required String indent,
  }) {
    final emitOrder = <IdlMember>[];
    for (final m in members) {
      if (m is IdlOperation) {
        if (!emitOrder.any((e) => e is IdlOperation && e.name == m.name)) {
          emitOrder.add(m);
        }
      } else {
        emitOrder.add(m);
      }
    }
    // For now keep simple max-params collapse to stay in sync with
    // SsrSurfaceEmitter (which uses same dedup). Full overload merging
    // will be re-enabled once SSR is updated to match.
    final ops = <String, IdlOperation>{};
    for (final m in members.whereType<IdlOperation>()) {
      final ex = ops[m.name];
      if (ex == null || m.parameters.length > ex.parameters.length) {
        ops[m.name] = m;
      }
    }
    final usedNames = <String>{
      for (final m in emitOrder.where((m) => m is! IdlConstant))
        if (m.name.isNotEmpty) escapeIdentifier(m.name),
    };
    for (final m in emitOrder) {
      switch (m) {
        case IdlOperation():
          _emitMethod(buf, ops[m.name]!, indent);
        case IdlAttribute():
          _emitAttribute(buf, m, indent);
        case IdlConstant():
          var name = escapeIdentifier(m.name);
          if (!usedNames.add(name)) {
            final base = '${name}Constant';
            name = base;
            var suffix = 2;
            while (!usedNames.add(name)) {
              name = '$base$suffix';
              suffix++;
            }
          }
          _emitConst(buf, m, indent, name: name);
        case IdlIterable():
          _emitIterable(buf, m, indent);
        case IdlMaplike():
          _emitMaplike(buf, m, indent);
        case IdlSetlike():
          _emitSetlike(buf, m, indent);
        case IdlConstructor():
          break;
        case IdlField():
          break;
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
    _recordRenderedTypeDependencies(m.returnType);
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
      var t = _resolve(p.type);
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
    final t = _resolve(m.type);
    final name = escapeIdentifier(m.name);
    buf.writeln('$indent$t get $name;');
    if (!m.readonly) {
      buf.writeln('$indent set $name($t value);');
    }
  }

  void _emitConst(
    StringBuffer buf,
    IdlConstant m,
    String indent, {
    required String name,
  }) {
    buf.writeln('$indent static const ${_resolve(m.type)} $name =');
    buf.writeln('$indent    ${m.value ?? 'null'};');
  }

  void _emitIterable(StringBuffer buf, IdlIterable m, String indent) {
    final names = m.types.map(_resolve).toList();
    if (m.types.length >= 2) {
      buf.writeln('$indent Iterable<(${names[0]}, ${names[1]})> get entries;');
      buf.writeln('$indent Iterable<${names[0]}> get keys;');
      buf.writeln('$indent Iterable<${names[1]}> get values;');
    } else {
      buf.writeln('$indent Iterable<${names.first}> get values;');
    }
  }

  void _emitMaplike(StringBuffer buf, IdlMaplike m, String indent) {
    final k = _resolve(m.keyType);
    final v = _resolve(m.valueType);
    buf.writeln('$indent Iterable<$k> get keys;');
    buf.writeln('$indent Iterable<$v> get values;');
    buf.writeln('$indent Iterable<MapEntry<$k, $v>> get entries;');
    buf.writeln('$indent $v? operator [](Object key);');
    buf.writeln('$indent bool has(Object key);');
  }

  void _emitSetlike(StringBuffer buf, IdlSetlike m, String indent) {
    final v = _resolve(m.valueType);
    buf.writeln('$indent Iterable<$v> get values;');
    buf.writeln('$indent bool has(Object value);');
  }

  void _emitWebBarrel(Directory dir, List<String> specs) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// ignore_for_file: type=lint');
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
    buf.writeln('// ignore_for_file: type=lint');
    buf.writeln();
    buf.writeln("import 'package:react_web/src/web_runtime.dart';");
    buf.writeln("import 'web.dart';");
    buf.writeln();
    buf.writeln('Window get window => WebRuntime.current.window;');
    buf.writeln('Document get document => WebRuntime.current.document;');
    File('${dir.path}/globals.dart').writeAsStringSync(buf.toString());
  }
}
