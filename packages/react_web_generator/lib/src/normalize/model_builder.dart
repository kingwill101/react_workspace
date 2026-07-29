import 'dart:convert';
import 'dart:io';

import '../model/model.dart';
import '../source/web_idl_loader.dart';
import '../source/react_declarations.dart';
import '../source/element_snapshot.dart';
import 'reachability.dart';

Set<String> loadVoidElements(String rootsPath) {
  final file = File(rootsPath);
  final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return (data['voidElements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet() ??
      {};
}

final class ModelBuilder {
  final String webIdlPath;
  final String rootsPath;

  ModelBuilder({
    required this.webIdlPath,
    this.rootsPath = 'packages/react_web_generator/config/roots.json',
  });

  NeutralWebModel build() {
    final voidElementTags = loadVoidElements(rootsPath);
    final elementSnapshot = ElementSnapshot.load(webIdlPath);

    // 1. Load Web IDL interfaces from relevant specs
    final webInterfaces = loadAllInterfaces(
      webIdlPath,
      specFilter: {'html', 'dom', 'cssom', 'cssom-view'},
    );

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

    // 4. Compute reachable types from all HTML elements
    final rootTypeIds = <String>{
      for (final tag in elementSnapshot.htmlTags)
        if (elementSnapshot.tagToInterface[tag] case final iface?) 'web.$iface',
      for (final r in reactInterfaces.keys) 'react.$r',
    };

    final reachable = computeReachableTypes(
      allTypes: allTypes,
      roots: rootTypeIds,
    );

    // 5. Build final type set
    final finalTypes = <String, InterfaceDecl>{};
    for (final typeId in reachable) {
      final decl = allTypes[typeId];
      if (decl != null) {
        finalTypes[typeId] = decl;
      }
    }

    // 6. Build element declarations for ALL HTML elements
    final elements = <String, ElementDecl>{};
    for (final tag in elementSnapshot.htmlTags) {
      final ifaceName = elementSnapshot.tagToInterface[tag];
      if (ifaceName == null) continue;

      final typeId = 'web.$ifaceName';
      final decl = allTypes[typeId];
      if (decl == null) continue;

      final props = _collectProps(ifaceName, webInterfaces);
      final events = _collectEvents(ifaceName, webInterfaces);

      elements[tag] = ElementDecl(
        tagName: tag,
        namespace: 'html',
        elementType: NamedTypeRef(typeId: typeId),
        voidElement: voidElementTags.contains(tag),
        props: props,
        events: events,
      );
    }

    return NeutralWebModel(
      types: finalTypes,
      elements: elements,
      sources: {'webIdlSnapshot': webIdlPath, 'rootsConfig': rootsPath},
    );
  }

  List<PropDecl> _collectProps(
    String ifaceName,
    Map<String, InterfaceDecl> webInterfaces,
  ) {
    final seen = <String>{};
    final result = <PropDecl>[];

    void walk(String name) {
      final iface = webInterfaces[name];
      if (iface == null || !seen.add(name)) return;

      for (final member in iface.members) {
        if (member is! AttributeDecl) continue;
        result.add(
          PropDecl(name: member.name, type: member.type, required: false),
        );
      }

      for (final ext in iface.extends_) {
        if (ext is NamedTypeRef && ext.typeId.startsWith('web.')) {
          walk(ext.typeId.substring(4));
        }
      }
    }

    walk(ifaceName);
    return result;
  }

  List<EventDecl> _collectEvents(
    String ifaceName,
    Map<String, InterfaceDecl> webInterfaces,
  ) {
    final seen = <String>{};
    final result = <EventDecl>[];

    void walk(String name) {
      final iface = webInterfaces[name];
      if (iface == null || !seen.add(name)) return;

      for (final member in iface.members) {
        if (member is! AttributeDecl) continue;
        if (!member.name.startsWith('on')) continue;
        result.add(EventDecl(name: member.name, eventType: member.type));
      }

      for (final ext in iface.extends_) {
        if (ext is NamedTypeRef && ext.typeId.startsWith('web.')) {
          walk(ext.typeId.substring(4));
        }
      }
    }

    walk(ifaceName);
    return result;
  }
}
