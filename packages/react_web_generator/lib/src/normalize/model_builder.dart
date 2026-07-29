import '../model/model.dart';
import '../source/web_idl_loader.dart';
import '../source/react_declarations.dart';
import 'reachability.dart';

final class ModelBuilder {
  final String webIdlPath;
  final Set<String> rootElementNames;

  const ModelBuilder({
    required this.webIdlPath,
    this.rootElementNames = const {
      'HTMLDivElement',
      'HTMLSpanElement',
      'HTMLButtonElement',
      'HTMLInputElement',
      'HTMLFormElement',
      'HTMLLabelElement',
      'HTMLTextAreaElement',
      'HTMLSelectElement',
      'HTMLOptionElement',
      'HTMLAnchorElement',
      'HTMLImageElement',
    },
  });

  NeutralWebModel build() {
    // 1. Load Web IDL interfaces from relevant specs
    final webInterfaces = loadAllInterfaces(webIdlPath, specFilter: {
      'html', 'dom', 'cssom', 'cssom-view',
    });

    // 2. Add React event interfaces
    final reactInterfaces = reactEventInterfaces();

    // 3. Merge into one registry keyed by typeId
    final allTypes = <String, InterfaceDecl>{};
    for (final entry in webInterfaces.entries) {
      allTypes['web.${entry.key}'] = entry.value;
    }
    for (final entry in reactInterfaces.entries) {
      allTypes['react.${entry.key}'] = entry.value;
    }

    // 4. Compute reachable types from roots
    final parentTypes = <String>{};
    for (final elName in rootElementNames) {
      final typeId = 'web.$elName';
      var decl = allTypes[typeId];
      while (decl != null && parentTypes.add(decl.typeId)) {
        bool found = false;
        for (final ext in decl.extends_) {
          if (ext is NamedTypeRef && allTypes.containsKey(ext.typeId)) {
            decl = allTypes[ext.typeId];
            found = true;
            break;
          }
        }
        if (!found) decl = null;
      }
    }

    final reachableRoots = <String>{
      for (final el in rootElementNames) 'web.$el',
      for (final p in parentTypes) p,
      for (final r in reactInterfaces.keys) 'react.$r',
    };

    final reachable = computeReachableTypes(
      allTypes: allTypes,
      roots: reachableRoots,
    );

    // 5. Ensure auxiliary types referenced by reachable types are included
    // (discovered naturally by member traversal, but ensure they exist)
    final finalTypes = <String, InterfaceDecl>{};
    for (final typeId in reachable) {
      final decl = allTypes[typeId];
      if (decl != null) {
        finalTypes[typeId] = decl;
      }
    }

    // 6. Build element declarations
    final elements = <String, ElementDecl>{};
    for (final elName in rootElementNames) {
      final typeId = 'web.$elName';
      final decl = allTypes[typeId];
      if (decl != null) {
        elements[_tagName(elName)] = ElementDecl(
          tagName: _tagName(elName),
          namespace: 'html',
          elementType: NamedTypeRef(typeId: typeId),
          voidElement: elName == 'HTMLImageElement' || elName == 'HTMLInputElement',
          props: [],
          events: [],
        );
      }
    }

    return NeutralWebModel(
      types: finalTypes,
      elements: elements,
      sources: {
        'webIdlSnapshot': webIdlPath,
      },
    );
  }

  Map<String, InterfaceDecl> loadAllTypes() {
    final webInterfaces = loadAllInterfaces(webIdlPath, specFilter: {
      'html', 'dom', 'cssom', 'cssom-view',
    });
    final reactInterfaces = reactEventInterfaces();
    final allTypes = <String, InterfaceDecl>{};
    for (final entry in webInterfaces.entries) {
      allTypes['web.${entry.key}'] = entry.value;
    }
    for (final entry in reactInterfaces.entries) {
      allTypes['react.${entry.key}'] = entry.value;
    }
    return allTypes;
  }

  static String _tagName(String elName) {
    if (elName == 'HTMLAnchorElement') return 'a';
    if (elName == 'HTMLImageElement') return 'img';
    var name = elName;
    if (name.startsWith('HTML')) name = name.substring(4);
    if (name.endsWith('Element')) name = name.substring(0, name.length - 7);
    return name.toLowerCase();
  }
}
