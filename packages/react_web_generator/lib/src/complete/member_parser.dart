/// Parses raw member and argument JSON nodes for the snapshot loader.
library;

import '../model/type_ref.dart';
import 'idl_type_parser.dart';
import 'member.dart';

List<ExtAttr> _extAttrs(Object? raw) {
  final list = raw as List<dynamic>? ?? [];
  return list.whereType<Map<String, dynamic>>().map(parseExtAttr).toList();
}

String? _constValue(Object? value) {
  if (value is! Map<String, dynamic>) return null;
  final t = value['type'] as String?;
  final v = value['value'];
  switch (t) {
    case 'string':
      return '"$v"';
    case 'boolean':
      return v == true ? 'true' : 'false';
    case 'null':
      return 'null';
    default:
      return v?.toString();
  }
}

String? _defaultExpr(Object? value) {
  if (value is! Map<String, dynamic>) return null;
  final t = value['type'] as String?;
  final v = value['value'];
  switch (t) {
    case 'string':
      return '"$v"';
    case 'boolean':
      return v == true ? 'true' : 'false';
    case 'number':
      return v?.toString();
    case 'null':
      return 'null';
    default:
      return null;
  }
}

/// Parse the `members` list of an interface/mixin/dictionary/namespace.
List<IdlMember> parseMembers(Object? rawMembers) {
  final out = <IdlMember>[];
  final list = rawMembers as List<dynamic>? ?? [];
  for (final m in list) {
    if (m is! Map<String, dynamic>) continue;
    final type = m['type'] as String?;
    final name = (m['name'] as String?) ?? '';
    final extAttrs = _extAttrs(m['extAttrs']);
    final specialRaw = m['special'] as String? ?? '';
    final staticMember =
        extAttrs.any((e) => e.name == 'static') || specialRaw == 'static';
    final special = specialRaw == 'static' ? '' : specialRaw;
    switch (type) {
      case 'attribute':
        final idlType = m['idlType'] as Map<String, dynamic>? ?? {};
        out.add(
          IdlAttribute(
            name: name,
            type: parseIdlType(idlType),
            readonly: m['readonly'] as bool? ?? false,
            special: special,
            staticMember: staticMember,
            extAttrs: [...extAttrs, ...idlTypeExtAttrs(idlType)],
          ),
        );
      case 'operation':
        final idlType = m['idlType'] as Map<String, dynamic>? ?? {};
        out.add(
          IdlOperation(
            name: name,
            returnType: parseIdlType(idlType),
            parameters: parseArguments(m['arguments']),
            special: special,
            staticMember: staticMember,
            extAttrs: extAttrs,
          ),
        );
      case 'constructor':
        out.add(IdlConstructor(parameters: parseArguments(m['arguments'])));
      case 'const':
        out.add(
          IdlConstant(
            name: name,
            type: parseIdlType(m['idlType']),
            value: _constValue(m['value']),
            extAttrs: extAttrs,
          ),
        );
      case 'iterable':
      case 'async iterable':
        out.add(
          IdlIterable(
            types: _iterableTypes(m['idlType']),
            async: type == 'async iterable',
          ),
        );
      case 'maplike':
        final at = _iterableTypes(m['idlType']);
        out.add(
          IdlMaplike(
            keyType: at.isNotEmpty
                ? at[0]
                : const NamedTypeRef(typeId: 'core.dynamic'),
            valueType: at.length > 1
                ? at[1]
                : const NamedTypeRef(typeId: 'core.dynamic'),
            readonly: m['readonly'] as bool? ?? false,
          ),
        );
      case 'setlike':
        final at = _iterableTypes(m['idlType']);
        out.add(
          IdlSetlike(
            valueType: at.isNotEmpty
                ? at[0]
                : const NamedTypeRef(typeId: 'core.dynamic'),
            readonly: m['readonly'] as bool? ?? false,
          ),
        );
      case 'field':
        final idlType = m['idlType'] as Map<String, dynamic>? ?? {};
        out.add(
          IdlField(
            name: name,
            type: parseIdlType(idlType),
            required: m['required'] as bool? ?? false,
            defaultValue: _defaultExpr(m['default']),
            extAttrs: [...extAttrs, ...idlTypeExtAttrs(idlType)],
          ),
        );
    }
  }
  return out;
}

/// Parse the `arguments` list of an operation / constructor / callback.
List<IdlParameter> parseArguments(Object? rawArgs) {
  final out = <IdlParameter>[];
  final list = rawArgs as List<dynamic>? ?? [];
  for (final a in list) {
    if (a is! Map<String, dynamic>) continue;
    final idlType = a['idlType'] as Map<String, dynamic>? ?? {};
    out.add(
      IdlParameter(
        name: (a['name'] as String?) ?? '',
        type: parseIdlType(idlType),
        required: (a['optional'] as bool?) != true,
        defaultValue: _defaultExpr(a['default']),
        variadic: a['variadic'] as bool? ?? false,
        extAttrs: idlTypeExtAttrs(idlType),
      ),
    );
  }
  return out;
}

List<TypeRef> _iterableTypes(Object? raw) {
  final list = raw as List<dynamic>? ?? const [];
  return list.map((t) => parseIdlType(t)).toList();
}
