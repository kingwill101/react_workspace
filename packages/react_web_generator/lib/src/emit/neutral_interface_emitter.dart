import 'dart:io';
import '../model/model.dart';
import 'type_ref_resolver.dart';

final class NeutralInterfaceEmitter {
  final NeutralWebModel model;

  NeutralInterfaceEmitter(this.model) : _resolver = TypeRefResolver(model.types);

  final TypeRefResolver _resolver;

  void emitToDirectory(String outputDir) {
    final htmlTypes = <String, InterfaceDecl>{};
    final eventTypes = <String, InterfaceDecl>{};
    for (final entry in model.types.entries) {
      if (entry.key.startsWith('react.')) {
        eventTypes[entry.key] = entry.value;
      } else {
        htmlTypes[entry.key] = entry.value;
      }
    }

    final allRefs = _collectReferencedTypes(htmlTypes)..addAll(_collectReferencedTypes(eventTypes));
    allRefs.removeWhere((id) => TypeRefResolver.isCoreType(id) || htmlTypes.containsKey(id) || eventTypes.containsKey(id));

    File('$outputDir/html_interfaces.dart')
        .writeAsStringSync(_emitHtmlTypes(htmlTypes, allRefs));

    final eventDir = Directory(outputDir);
    eventDir.createSync(recursive: true);
    File('$outputDir/event_interfaces.dart')
        .writeAsStringSync(_emitEventTypes(eventTypes));
  }

  Set<String> _collectReferencedTypes(Map<String, InterfaceDecl> types) {
    final refs = <String>{};
    for (final decl in types.values) {
      for (final ext in decl.extends_) {
        _collectRefsFromTypeRef(ext, refs);
      }
      for (final tp in decl.typeParameters) {
        if (tp.bound != null) _collectRefsFromTypeRef(tp.bound!, refs);
      }
      for (final member in decl.members) {
        if (member is AttributeDecl) {
          _collectRefsFromTypeRef(member.type, refs);
        } else if (member is OperationDecl) {
          _collectRefsFromTypeRef(member.returnType, refs);
          for (final p in member.parameters) {
            _collectRefsFromTypeRef(p.type, refs);
          }
        }
      }
    }
    return refs;
  }

  void _collectRefsFromTypeRef(TypeRef ref, Set<String> refs) {
    if (ref is NamedTypeRef) {
      refs.add(ref.typeId);
      for (final a in ref.arguments) {
        _collectRefsFromTypeRef(a, refs);
      }
    } else if (ref is UnionTypeRef) {
      for (final o in ref.options) {
        _collectRefsFromTypeRef(o, refs);
      }
    }
  }

  String _emitHtmlTypes(Map<String, InterfaceDecl> types, Set<String> stubs) {
    final buf = StringBuffer();
    buf.writeln('/// Neutral Web IDL interfaces — generated from neutral_web_model.json');
    buf.writeln('///');
    buf.writeln('/// These abstract interfaces correspond to Web IDL interface types.');
    buf.writeln();

    final sorted = _topologicalSort(types);

    for (final stubId in stubs) {
      final name = _typeIdToName(stubId);
      buf.writeln('abstract interface class $name {}');
      buf.writeln();
    }

    for (final decl in sorted) {
      buf.writeln(_emitInterface(decl, types));
      buf.writeln();
    }

    return buf.toString();
  }

  String _emitEventTypes(Map<String, InterfaceDecl> types) {
    final buf = StringBuffer();
    buf.writeln('/// Neutral React event interfaces — generated from neutral_web_model.json');
    buf.writeln('///');
    buf.writeln('/// These abstract interfaces correspond to React synthetic events.');
    buf.writeln();

    buf.writeln("import 'html_interfaces.dart';");
    buf.writeln();

    final sorted = _topologicalSort(types);
    for (final decl in sorted) {
      buf.writeln(_emitInterface(decl, types));
      buf.writeln();
    }

    return buf.toString();
  }

  String _typeIdToName(String typeId) {
    if (typeId.startsWith('web.')) return typeId.substring(4);
    if (typeId.startsWith('react.')) return typeId.substring(6);
    return typeId;
  }

  Set<String> _inheritedMemberNames(InterfaceDecl decl, Map<String, InterfaceDecl> allTypes) {
    final names = <String>{};
    void walk(InterfaceDecl d) {
      for (final ext in d.extends_) {
        if (ext is NamedTypeRef && allTypes.containsKey(ext.typeId)) {
          final parent = allTypes[ext.typeId]!;
          for (final m in parent.members) {
            names.add(m.name);
          }
          walk(parent);
        }
      }
    }
    walk(decl);
    return names;
  }

  String _emitInterface(InterfaceDecl decl, Map<String, InterfaceDecl> allTypes) {
    final buf = StringBuffer();
    buf.write('abstract interface class ${decl.name}');

    if (decl.typeParameters.isNotEmpty) {
      buf.write('<');
      for (int i = 0; i < decl.typeParameters.length; i++) {
        if (i > 0) buf.write(', ');
        buf.write(decl.typeParameters[i].name);
        if (decl.typeParameters[i].bound != null) {
          buf.write(' extends ${_resolver.resolve(decl.typeParameters[i].bound!)}');
        }
      }
      buf.write('>');
    }

    if (decl.extends_.isNotEmpty) {
      buf.write(' implements ');
      for (int i = 0; i < decl.extends_.length; i++) {
        if (i > 0) buf.write(', ');
        buf.write(_resolver.resolve(decl.extends_[i]));
      }
    }

    buf.writeln(' {');

    final inherited = _inheritedMemberNames(decl, allTypes);

    for (final member in decl.members) {
      if (inherited.contains(member.name)) continue;
      final safeName = _escapeDartKeyword(member.name);
      if (member is AttributeDecl) {
        final dartType = _resolver.resolve(member.type);
        if (member.readable && member.writable) {
          buf.writeln('  $dartType get $safeName;');
          buf.writeln('  set $safeName($dartType value);');
        } else if (member.readable) {
          buf.writeln('  $dartType get $safeName;');
        } else if (member.writable) {
          buf.writeln('  set $safeName($dartType value);');
        }
      } else if (member is OperationDecl) {
        if (member.name.isEmpty || member.name == '\$') continue;
        final returnType = _resolver.resolve(member.returnType);
        buf.write('  $returnType ${member.name}(');
        for (int i = 0; i < member.parameters.length; i++) {
          if (i > 0) buf.write(', ');
          final p = member.parameters[i];
          buf.write('${_resolver.resolve(p.type)} ${p.name.isNotEmpty ? _escapeDartKeyword(p.name) : 'arg$i'}');
        }
        buf.writeln(');');
      }
    }

    buf.writeln('}');
    return buf.toString();
  }

  String _escapeDartKeyword(String name) {
    if (_dartKeywords.contains(name)) return '${name}_';
    return name;
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

  List<InterfaceDecl> _topologicalSort(Map<String, InterfaceDecl> types) {
    final visited = <String>{};
    final result = <InterfaceDecl>[];

    void visit(String typeId) {
      if (visited.contains(typeId)) return;
      visited.add(typeId);
      final decl = types[typeId];
      if (decl == null) return;
      for (final ext in decl.extends_) {
        if (ext is NamedTypeRef && types.containsKey(ext.typeId)) {
          visit(ext.typeId);
        }
      }
      result.add(decl);
    }

    for (final typeId in types.keys) {
      visit(typeId);
    }

    return result;
  }
}
