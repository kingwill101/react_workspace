/// Parses raw Web IDL `idlType` JSON nodes into the neutral [TypeRef] model.
///
/// This is representation-only: it preserves nullable/union/generic/record
/// shapes exactly as described in the snapshot. Whether a shape is *strongly
/// typed* or *opaque* is decided later by the emitter, never here, and nothing
/// is dropped.
library;

import '../model/type_ref.dart';
import 'member.dart';

/// Map an IDL primitive token to a `core.*` typeId, or null if it is a named
/// type reference.
String? idlPrimitiveToCore(String idlType) => switch (idlType) {
  'DOMString' || 'USVString' || 'ByteString' => 'core.String',
  'boolean' => 'core.bool',
  'long' ||
  'long long' ||
  'short' ||
  'byte' ||
  'unsigned long' ||
  'unsigned long long' ||
  'unsigned short' ||
  'unsigned byte' => 'core.int',
  'double' ||
  'float' ||
  'unrestricted double' ||
  'unrestricted float' => 'core.double',
  'undefined' || 'void' => 'core.void',
  'object' => 'core.Object',
  'any' => 'core.dynamic',
  _ => null,
};

/// Parse a raw snapshot `idlType` node into a [TypeRef].
TypeRef parseIdlType(Object? raw) {
  if (raw is List) {
    throw ArgumentError('Unexpected top-level idlType list: $raw');
  }
  if (raw is! Map<String, dynamic>) {
    throw ArgumentError('Unexpected idlType node: $raw');
  }

  final generic = raw['generic'] as String? ?? '';
  final rawInner = raw['idlType'];
  final nullable = raw['nullable'] as bool? ?? false;
  final isUnion = raw['union'] as bool? ?? false;
  final memberExtAttrs = (raw['extAttrs'] as List<dynamic>? ?? []);

  // Unions: idlType is a list of member types.
  if (isUnion && rawInner is List) {
    final options = rawInner.map((o) => parseIdlType(o)).toList();
    // Normalize single-option unions and drop 'undefined' variants since Dart
    // models them via optionality. Undefined variants are represented as the
    // surrounding optionality, mirroring how package:web lowers them.
    final filtered = options
        .where((t) => !(t is NamedTypeRef && t.typeId == 'core.void'))
        .toList();
    final sealed = filtered.isEmpty ? null : filtered;
    if (sealed == null) {
      return NamedTypeRef(typeId: 'core.dynamic', nullable: nullable);
    }
    if (sealed.length == 1) {
      return _withNullable(sealed.single, nullable);
    }
    return UnionTypeRef(options: sealed, nullable: nullable);
  }

  switch (generic) {
    case 'Promise':
      final inner = parseIdlType(_firstInner(rawInner));
      return NamedTypeRef(
        typeId: 'core.Future',
        nullable: nullable,
        arguments: [inner],
      );
    case 'sequence':
    case 'FrozenArray':
    case 'ObservableArray':
      final inner = parseIdlType(_firstInner(rawInner));
      final id = generic == 'ObservableArray'
          ? 'core.ObservableArray'
          : 'core.List';
      return NamedTypeRef(typeId: id, nullable: nullable, arguments: [inner]);
    case 'record':
      // idlType is a two-element list: [keyType, valueType].
      final list = rawInner as List;
      final key = parseIdlType(
        list.isNotEmpty ? list[0] : _firstInner(rawInner),
      );
      final value = parseIdlType(
        list.length > 1 ? list[1] : _firstInner(rawInner),
      );
      return NamedTypeRef(
        typeId: 'core.Map',
        nullable: nullable,
        arguments: [key, value],
      );
  }

  // Simple (possibly list-wrapped single) type.
  final inner = rawInner is String ? rawInner : _firstInnerDirect(rawInner);
  if (inner != null) {
    final core = idlPrimitiveToCore(inner);
    if (core != null) {
      return NamedTypeRef(typeId: core, nullable: nullable);
    }
    return NamedTypeRef(typeId: 'web.$inner', nullable: nullable);
    if (inner is Map) {
      // Handle a nested idlType descriptor that is itself a list heading
      // (common for generic-in-generic). Re-parse.
      return parseIdlType(inner);
    }
  }

  return NamedTypeRef(typeId: 'core.dynamic', nullable: nullable);
}

TypeRef _withNullable(TypeRef t, bool nullable) {
  if (!nullable) return t;
  return switch (t) {
    NamedTypeRef() => NamedTypeRef(
      typeId: t.typeId,
      nullable: true,
      arguments: t.arguments,
    ),
    UnionTypeRef() => UnionTypeRef(options: t.options, nullable: true),
    TypeParameterRef() => TypeParameterRef(name: t.name, nullable: true),
  };
}

Object? _firstInner(Object? rawInner) {
  if (rawInner is List && rawInner.isNotEmpty) return rawInner.first;
  return rawInner;
}

String? _firstInnerDirect(Object? rawInner) {
  if (rawInner is String) return rawInner;
  if (rawInner is List && rawInner.isNotEmpty) {
    final f = rawInner.first;
    if (f is String) return f;
    return null;
  }
  return null;
}

/// Capture `Clamp` / `EnforceRange` and similar argument-level extended
/// attributes carried on an idlType node.
List<ExtAttr> idlTypeExtAttrs(Object? raw) {
  if (raw is! Map<String, dynamic>) return const [];
  final extAttrs = raw['extAttrs'] as List<dynamic>? ?? [];
  final out = <ExtAttr>[];
  for (final x in extAttrs) {
    if (x is Map<String, dynamic>) {
      out.add(parseExtAttr(x));
    }
  }
  return out;
}

ExtAttr parseExtAttr(Map<String, dynamic> x) {
  final name = x['name'] as String? ?? '';
  final rhs = x['rhs'];
  return ExtAttr(name: name, rhs: _rhsToString(rhs));
}

String? _rhsToString(Object? rhs) {
  if (rhs == null) return null;
  if (rhs is String) return rhs;
  if (rhs is Map) return rhs['value']?.toString() ?? rhs.toString();
  return rhs.toString();
}
