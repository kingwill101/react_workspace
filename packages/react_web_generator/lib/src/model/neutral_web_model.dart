import 'dart:convert';
import 'type_ref.dart';
import 'type_decl.dart';
import 'element_decl.dart';

final class NeutralWebModel {
  final Map<String, InterfaceDecl> types;
  final Map<String, ElementDecl> elements;
  final Map<String, Object?>? sources;

  const NeutralWebModel({
    required this.types,
    required this.elements,
    this.sources,
  });

  Map<String, Object?> toJson() => {
    'schemaVersion': 1,
    if (sources != null) 'sources': sources,
    'types': types.map((k, v) => MapEntry(k, v.toJson())),
    'elements': elements.map((k, v) => MapEntry(k, v.toJson())),
  };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

NeutralWebModel neutralWebModelFromJson(Map<String, dynamic> json) {
  return NeutralWebModel(
    sources: json['sources'] as Map<String, Object?>?,
    types: (json['types'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, interfaceDeclFromJson(v as Map<String, dynamic>)),
    ),
    elements:
        (json['elements'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, elementDeclFromJson(v as Map<String, dynamic>)),
        ) ??
        {},
  );
}

ElementDecl elementDeclFromJson(Map<String, dynamic> json) {
  return ElementDecl(
    tagName: json['tagName'] as String,
    namespace: json['namespace'] as String? ?? 'html',
    elementType: typeRefFromJson(json['elementType'] as Map<String, dynamic>),
    voidElement: json['voidElement'] as bool? ?? false,
    props:
        (json['props'] as List<dynamic>?)
            ?.map(
              (p) => PropDecl(
                name: p['name'] as String,
                type: typeRefFromJson(p['type'] as Map<String, dynamic>),
                required: p['required'] as bool? ?? false,
              ),
            )
            .toList() ??
        [],
    events:
        (json['events'] as List<dynamic>?)
            ?.map(
              (e) => EventDecl(
                name: e['name'] as String,
                eventType: typeRefFromJson(
                  e['eventType'] as Map<String, dynamic>,
                ),
              ),
            )
            .toList() ??
        [],
  );
}
