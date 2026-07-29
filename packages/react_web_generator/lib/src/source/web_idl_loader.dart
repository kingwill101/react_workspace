import 'dart:convert';
import 'dart:io';

import '../model/model.dart';

InterfaceDecl? loadWebIdlInterface(
  Map<String, dynamic> raw,
  Map<String, List<InterfaceDecl>> registry,
) {
  final type = raw['type'] as String?;
  if (type != 'interface') return null;

  final name = raw['name'] as String?;
  if (name == null) return null;

  final typeId = 'web.$name';
  final inheritance = raw['inheritance'] as String?;

  final members = <MemberDecl>[];
  for (final m in (raw['members'] as List<dynamic>? ?? [])) {
    if (m is! Map<String, dynamic>) continue;
    final member = _parseMember(m);
    if (member != null) members.add(member);
  }

  return InterfaceDecl(
    typeId: typeId,
    name: name,
    sourceName: name,
    extends_: inheritance != null
        ? [NamedTypeRef(typeId: 'web.$inheritance')]
        : [],
    members: members,
    exposure: Exposure.full,
    browserBinding: BrowserBinding(
      library: 'package:web/web.dart',
      symbol: name,
    ),
  );
}

MemberDecl? _parseMember(Map<String, dynamic> raw) {
  final type = raw['type'] as String?;
  final name = raw['name'] as String?;
  if (name == null) return null;

  return switch (type) {
    'attribute' => _parseAttribute(raw),
    'operation' => _parseOperation(raw),
    _ => null,
  };
}

AttributeDecl? _parseAttribute(Map<String, dynamic> raw) {
  final name = raw['name'] as String? ?? '';
  final idlType = raw['idlType'] as Map<String, dynamic>? ?? {};
  final typeRef = _parseIdlType(idlType);
  if (typeRef == null) return null;
  return AttributeDecl(
    name: name,
    readable: true,
    writable: raw['readonly'] != true,
    type: typeRef,
  );
}

OperationDecl? _parseOperation(Map<String, dynamic> raw) {
  final name = raw['name'] as String? ?? '';
  final idlType = raw['idlType'] as Map<String, dynamic>? ?? {};
  final returnType =
      _parseIdlType(idlType) ?? const NamedTypeRef(typeId: 'core.void');
  return OperationDecl(name: name, returnType: returnType);
}

TypeRef? _parseIdlType(Map<String, dynamic> idlType) {
  final rawType = idlType['idlType'];
  final nullable = idlType['nullable'] as bool? ?? false;
  final union = idlType['union'] as bool? ?? false;
  final generic = idlType['generic'] as String? ?? '';

  if (union && rawType is List) {
    final options = rawType
        .map<TypeRef?>((t) => _parseIdlType(t as Map<String, dynamic>))
        .whereType<TypeRef>()
        .toList();
    if (options.isEmpty) return null;
    return UnionTypeRef(nullable: nullable, options: options);
  }

  if (rawType is List &&
      rawType.isNotEmpty &&
      rawType[0] is Map<String, dynamic>) {
    return _parseIdlType(rawType[0] as Map<String, dynamic>);
  }

  final typeStr = rawType as String?;
  if (typeStr == null) return null;

  // generic types (sequence, Promise, FrozenArray, record)
  if (generic == 'sequence' || generic == 'FrozenArray') {
    final inner = _parseIdlType({
      'idlType': rawType,
      'nullable': false,
      'union': false,
      'generic': '',
    });
    // Represent as named type with list-like structure; for now just use the inner type
    return NamedTypeRef(
      typeId: 'core.List',
      nullable: nullable,
      arguments: inner != null ? [inner] : [],
    );
  }

  if (generic == 'Promise') {
    final inner = _parseIdlType({
      'idlType': rawType,
      'nullable': false,
      'union': false,
      'generic': '',
    });
    return NamedTypeRef(
      typeId: 'core.Future',
      nullable: nullable,
      arguments: inner != null ? [inner] : [],
    );
  }

  // Map IDL type to Dart type
  final dartType = _idlPrimitive(typeStr);
  if (dartType != null) {
    return dartType.copyWith(
      nullable: dartType.nullable ? nullable || true : nullable,
    );
  }

  return NamedTypeRef(typeId: 'web.$typeStr', nullable: nullable);
}

NamedTypeRef? _idlPrimitive(String idlType) {
  return switch (idlType) {
    'DOMString' ||
    'USVString' ||
    'ByteString' => const NamedTypeRef(typeId: 'core.String'),
    'boolean' => const NamedTypeRef(typeId: 'core.bool'),
    'long' ||
    'long long' ||
    'short' ||
    'byte' ||
    'unsigned long' ||
    'unsigned long long' ||
    'unsigned short' ||
    'unsigned byte' => const NamedTypeRef(typeId: 'core.int'),
    'double' ||
    'float' ||
    'unrestricted double' => const NamedTypeRef(typeId: 'core.double'),
    'undefined' || 'void' => const NamedTypeRef(typeId: 'core.void'),
    'object' => const NamedTypeRef(typeId: 'core.Object'),
    _ => null,
  };
}

Map<String, InterfaceDecl> loadAllInterfaces(
  String snapshotPath, {
  Set<String>? specFilter,
}) {
  final file = File(snapshotPath);
  final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final idl = data['idl'] as Map<String, dynamic>? ?? {};
  final registry = <String, List<InterfaceDecl>>{};

  // Collect interface declarations from relevant specs
  for (final specEntry in idl.entries) {
    if (specFilter != null && !specFilter.contains(specEntry.key)) continue;
    final spec = specEntry.value;
    if (spec is! List) continue;
    for (final entry in spec) {
      if (entry is! Map<String, dynamic>) continue;
      final decl = loadWebIdlInterface(entry, registry);
      if (decl != null) {
        registry.putIfAbsent(decl.name, () => []).add(decl);
      }
    }
  }

  // Flatten: prefer entries with inheritance, merge members
  final result = <String, InterfaceDecl>{};
  for (final entry in registry.entries) {
    final name = entry.key;
    final decls = entry.value;

    // Find the one with inheritance (or the first)
    decls.sort((a, b) {
      if (a.extends_.isNotEmpty && b.extends_.isEmpty) return -1;
      if (a.extends_.isEmpty && b.extends_.isNotEmpty) return 1;
      return 0;
    });

    final primary = decls.first;
    final mergedMembers = <String, MemberDecl>{};
    for (final d in decls) {
      for (final m in d.members) {
        mergedMembers[m.name] = m;
      }
    }

    result[name] = InterfaceDecl(
      typeId: primary.typeId,
      name: primary.name,
      sourceName: primary.sourceName,
      extends_: primary.extends_,
      members: mergedMembers.values.toList(),
      exposure: primary.exposure,
      browserBinding: primary.browserBinding,
    );
  }

  return result;
}
