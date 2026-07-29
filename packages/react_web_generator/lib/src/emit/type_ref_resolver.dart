import '../model/model.dart';

final class TypeRefResolver {
  static const _coreTypeMap = <String, String>{
    'core.bool': 'bool',
    'core.String': 'String',
    'core.int': 'int',
    'core.double': 'double',
    'core.void': 'void',
    'core.Object': 'Object',
    'core.dynamic': 'Object',
  };

  static bool isCoreType(String typeId) => _coreTypeMap.containsKey(typeId);

  final Map<String, InterfaceDecl> _types;

  const TypeRefResolver(this._types);

  String resolve(TypeRef ref) {
    final buf = StringBuffer();
    bool isCore = false;
    if (ref is NamedTypeRef) {
      if (_coreTypeMap.containsKey(ref.typeId)) {
        buf.write(_coreTypeMap[ref.typeId]);
        isCore = true;
      } else if (ref.typeId.startsWith('web.')) {
        buf.write(ref.typeId.substring(4));
      } else if (ref.typeId.startsWith('react.')) {
        buf.write(ref.typeId.substring(6));
      } else {
        buf.write(ref.typeId);
      }
      if (ref.arguments.isNotEmpty) {
        buf.write('<');
        for (int i = 0; i < ref.arguments.length; i++) {
          if (i > 0) buf.write(', ');
          buf.write(resolve(ref.arguments[i]));
        }
        buf.write('>');
      }
    } else if (ref is TypeParameterRef) {
      buf.write(ref.name);
    } else if (ref is UnionTypeRef) {
      buf.write('Object');
      isCore = true;
    }
    if (ref.nullable && !isCore) {
      buf.write('?');
    }
    return buf.toString();
  }

  InterfaceDecl? typeForName(String name) {
    return _types['web.$name'] ?? _types['react.$name'];
  }

  List<Map<String, dynamic>> collectedMembers(String name) {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];
    void walk(InterfaceDecl decl) {
      for (final m in decl.members) {
        if (!seen.add(m.name)) continue;
        result.add(_memberToMap(m));
      }
      for (final ext in decl.extends_) {
        if (ext is! NamedTypeRef) continue;
        final parent = _types[ext.typeId];
        if (parent != null) walk(parent);
      }
    }
    final decl = typeForName(name);
    if (decl != null) walk(decl);
    return result;
  }

  Map<String, dynamic> _memberToMap(MemberDecl m) {
    if (m is AttributeDecl) {
      return {
        'name': m.name,
        'returnType': resolve(m.type),
        'kind': 'attribute',
      };
    }
    if (m is OperationDecl) {
      return {
        'name': m.name,
        'returnType': resolve(m.returnType),
        'kind': 'method',
      };
    }
    return {'name': m.name, 'returnType': 'void', 'kind': 'method'};
  }
}
