/// Loads a full `dart-lang/web` `web_apis.json` snapshot into a [RawWebModel].
/// Partial-merging and `includes` folding happens in `merger.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'definition.dart';
import 'idl_type_parser.dart';
import 'member.dart';
import 'member_parser.dart';
import 'raw_model.dart';

final class CompleteWebModelBuilder {
  final String webIdlPath;

  CompleteWebModelBuilder({required this.webIdlPath});

  RawWebModel loadRaw() {
    final file = File(webIdlPath);
    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final idl = data['idl'] as Map<String, dynamic>? ?? {};

    final interfaces = <String, List<IdlInterface>>{};
    final mixins = <String, List<IdlMixin>>{};
    final dictionaries = <String, List<IdlDictionary>>{};
    final namespaces = <String, List<IdlNamespace>>{};
    final enums = <String, IdlEnum>{};
    final typedefs = <String, IdlTypedef>{};
    final callbacks = <String, IdlCallback>{};
    final callbackInterfaces = <String, IdlCallbackInterface>{};
    final includes = <IdlIncludes>[];
    final specOf = <String, String>{};

    for (final specEntry in idl.entries) {
      final spec = specEntry.key;
      final entries = specEntry.value;
      if (entries is! List) continue;
      for (final e in entries) {
        if (e is! Map<String, dynamic>) continue;
        final type = e['type'] as String?;
        final name = (e['name'] as String?) ?? '';
        final extAttrs = _extAttrsOf(e['extAttrs']);
        final members = parseMembers(e['members']);
        switch (type) {
          case 'interface':
            _addInterface(interfaces, specOf, name, spec, e, members, extAttrs);
          case 'callback interface':
            callbackInterfaces.update(
              name,
              (existing) => IdlCallbackInterface(
                name: name,
                spec: spec,
                members: [...existing.members, ...members],
                extAttrs: [...existing.extAttrs, ...extAttrs],
              ),
              ifAbsent: () => IdlCallbackInterface(
                name: name,
                spec: spec,
                members: members,
                extAttrs: extAttrs,
              ),
            );
            specOf.putIfAbsent(name, () => spec);
          case 'interface mixin':
            mixins.update(
              name,
              (l) => l..add(IdlMixin(
                name: name,
                spec: spec,
                members: members,
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )),
              ifAbsent: () => [IdlMixin(
                name: name,
                spec: spec,
                members: members,
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )],
            );
            specOf.putIfAbsent(name, () => spec);
          case 'dictionary':
            dictionaries.update(
              name,
              (l) => l..add(IdlDictionary(
                name: name,
                spec: spec,
                inheritance: e['inheritance'] as String?,
                fields: members.whereType<IdlField>().toList(),
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )),
              ifAbsent: () => [IdlDictionary(
                name: name,
                spec: spec,
                inheritance: e['inheritance'] as String?,
                fields: members.whereType<IdlField>().toList(),
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )],
            );
            specOf.putIfAbsent(name, () => spec);
          case 'namespace':
            namespaces.update(
              name,
              (l) => l..add(IdlNamespace(
                name: name,
                spec: spec,
                members: members,
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )),
              ifAbsent: () => [IdlNamespace(
                name: name,
                spec: spec,
                members: members,
                partial: e['partial'] as bool? ?? false,
                extAttrs: extAttrs,
              )],
            );
            specOf.putIfAbsent(name, () => spec);
          case 'enum':
            final values = (e['values'] as List<dynamic>? ?? [])
                .whereType<Map<String, dynamic>>()
                .map((v) => v['value'] as String? ?? '')
                .toList();
            enums[name] = IdlEnum(
              name: name,
              spec: spec,
              values: values,
              extAttrs: extAttrs,
            );
            specOf.putIfAbsent(name, () => spec);
          case 'typedef':
            typedefs[name] = IdlTypedef(
              name: name,
              spec: spec,
              type: parseIdlType(e['idlType']),
              extAttrs: extAttrs,
            );
            specOf.putIfAbsent(name, () => spec);
          case 'callback':
            callbacks[name] = IdlCallback(
              name: name,
              spec: spec,
              returnType: parseIdlType(e['idlType']),
              parameters: parseArguments(e['arguments']),
              extAttrs: extAttrs,
            );
            specOf.putIfAbsent(name, () => spec);
          case 'includes':
            final target = e['target'] as String? ?? '';
            final incl = e['includes'] as String? ?? '';
            includes.add(IdlIncludes(
              name: '$target|$incl',
              spec: spec,
              target: target,
              includes: incl,
            ));
        }
      }
    }

    return RawWebModel(
      interfaces: interfaces,
      mixins: mixins,
      dictionaries: dictionaries,
      namespaces: namespaces,
      enums: enums,
      typedefs: typedefs,
      callbacks: callbacks,
      callbackInterfaces: callbackInterfaces,
      includes: includes,
      specOf: specOf,
    );
  }

  void _addInterface(
    Map<String, List<IdlInterface>> interfaces,
    Map<String, String> specOf,
    String name,
    String spec,
    Map<String, dynamic> e,
    List<IdlMember> members,
    List<ExtAttr> extAttrs,
  ) {
    interfaces.update(
      name,
      (l) => l..add(IdlInterface(
        name: name,
        spec: spec,
        inheritance: e['inheritance'] as String?,
        members: members,
        partial: e['partial'] as bool? ?? false,
        extAttrs: extAttrs,
      )),
      ifAbsent: () => [IdlInterface(
        name: name,
        spec: spec,
        inheritance: e['inheritance'] as String?,
        members: members,
        partial: e['partial'] as bool? ?? false,
        extAttrs: extAttrs,
      )],
    );
    specOf.putIfAbsent(name, () => spec);
  }

  List<ExtAttr> _extAttrsOf(Object? raw) {
    final list = raw as List<dynamic>? ?? [];
    return list.whereType<Map<String, dynamic>>().map(parseExtAttr).toList();
  }
}
