import '../model/model.dart';

Set<String> computeReachableTypes({
  required Map<String, InterfaceDecl> allTypes,
  required Set<String> roots,
}) {
  final visited = <String>{};
  final queue = <String>[...roots];

  while (queue.isNotEmpty) {
    final current = queue.removeLast();
    if (!visited.add(current)) continue;

    final decl = allTypes[current];
    if (decl == null) continue;

    for (final ext in decl.extends_) {
      _collectReferencedTypeIds(ext, allTypes, queue);
    }

    for (final m in decl.members) {
      switch (m) {
        case AttributeDecl():
          _collectReferencedTypeIds(m.type, allTypes, queue);
        case OperationDecl():
          _collectReferencedTypeIds(m.returnType, allTypes, queue);
          for (final p in m.parameters) {
            _collectReferencedTypeIds(p.type, allTypes, queue);
          }
      }
    }
  }

  return visited;
}

void _collectReferencedTypeIds(
  TypeRef type,
  Map<String, InterfaceDecl> allTypes,
  List<String> queue,
) {
  switch (type) {
    case NamedTypeRef():
      if (allTypes.containsKey(type.typeId)) {
        queue.add(type.typeId);
      }
      for (final arg in type.arguments) {
        _collectReferencedTypeIds(arg, allTypes, queue);
      }
    case UnionTypeRef():
      for (final opt in type.options) {
        _collectReferencedTypeIds(opt, allTypes, queue);
      }
    case TypeParameterRef():
      break;
  }
}
