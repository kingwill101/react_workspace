/// Loads a full `dart-lang/web` `web_apis.json` snapshot into a [RawWebModel].
/// Partial-merging and `includes` folding happens in `merger.dart`.
library;

import 'dart:convert';
import 'dart:io';

import '../bcd_filter.dart';
import '../model/type_ref.dart';
import 'definition.dart';
import 'idl_type_parser.dart';
import 'member.dart';
import 'member_parser.dart';
import 'raw_model.dart';

final class CompleteWebModelBuilder {
  final String webIdlPath;
  final BcdFilter? bcdFilter;

  CompleteWebModelBuilder({required this.webIdlPath, this.bcdFilter});

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
            if (bcdFilter != null &&
                !bcdFilter!.shouldGenerateInterface(name)) {
              break;
            }
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
              (l) => l
                ..add(
                  IdlMixin(
                    name: name,
                    spec: spec,
                    members: members,
                    partial: e['partial'] as bool? ?? false,
                    extAttrs: extAttrs,
                  ),
                ),
              ifAbsent: () => [
                IdlMixin(
                  name: name,
                  spec: spec,
                  members: members,
                  partial: e['partial'] as bool? ?? false,
                  extAttrs: extAttrs,
                ),
              ],
            );
            specOf.putIfAbsent(name, () => spec);
          case 'dictionary':
            dictionaries.update(
              name,
              (l) => l
                ..add(
                  IdlDictionary(
                    name: name,
                    spec: spec,
                    inheritance: e['inheritance'] as String?,
                    fields: members.whereType<IdlField>().toList(),
                    partial: e['partial'] as bool? ?? false,
                    extAttrs: extAttrs,
                  ),
                ),
              ifAbsent: () => [
                IdlDictionary(
                  name: name,
                  spec: spec,
                  inheritance: e['inheritance'] as String?,
                  fields: members.whereType<IdlField>().toList(),
                  partial: e['partial'] as bool? ?? false,
                  extAttrs: extAttrs,
                ),
              ],
            );
            specOf.putIfAbsent(name, () => spec);
          case 'namespace':
            if (bcdFilter != null &&
                !bcdFilter!.shouldGenerateInterface(name)) {
              break;
            }
            _addNamespace(namespaces, specOf, name, spec, e, members, extAttrs);
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
            includes.add(
              IdlIncludes(
                name: '$target|$incl',
                spec: spec,
                target: target,
                includes: incl,
              ),
            );
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

  /// Transforms a [TypeRef] by replacing any filtered-out interface
  /// references with [Object?], matching the upstream generator's
  /// behavior of lowering ungeneratable types to a safe fallback.
  TypeRef _lowerFilteredOutTypes(TypeRef type) {
    if (bcdFilter == null) return type;
    if (type is NamedTypeRef) {
      if (type.typeId.startsWith('web.')) {
        final name = type.typeId.substring(5);
        if (bcdFilter!.isFilteredOutInterface(name)) {
          return const NamedTypeRef(typeId: 'core.Object', nullable: true);
        }
      }
      final lowerArgs = type.arguments.map(_lowerFilteredOutTypes).toList();
      if (lowerArgs.length == type.arguments.length &&
          identical(lowerArgs, type.arguments)) {
        return type;
      }
      return NamedTypeRef(
        typeId: type.typeId,
        nullable: type.nullable,
        arguments: lowerArgs,
      );
    }
    if (type is UnionTypeRef) {
      final lowerOptions = type.options.map(_lowerFilteredOutTypes).toList();
      if (lowerOptions.length == type.options.length &&
          identical(lowerOptions, type.options)) {
        return type;
      }
      return UnionTypeRef(nullable: type.nullable, options: lowerOptions);
    }
    return type;
  }

  IdlMember _lowerMemberTypes(IdlMember member) {
    return switch (member) {
      IdlAttribute(
        :final type,
        :final name,
        :final readonly,
        :final special,
        :final staticMember,
        :final extAttrs,
      ) =>
        IdlAttribute(
          name: name,
          type: _lowerFilteredOutTypes(type),
          readonly: readonly,
          special: special,
          staticMember: staticMember,
          extAttrs: extAttrs,
        ),
      IdlOperation(
        :final returnType,
        :final parameters,
        :final name,
        :final special,
        :final staticMember,
        :final extAttrs,
      ) =>
        IdlOperation(
          name: name,
          returnType: _lowerFilteredOutTypes(returnType),
          parameters: parameters
              .map(
                (p) => IdlParameter(
                  name: p.name,
                  type: _lowerFilteredOutTypes(p.type),
                  required: p.required,
                  defaultValue: p.defaultValue,
                  variadic: p.variadic,
                  extAttrs: p.extAttrs,
                ),
              )
              .toList(),
          special: special,
          staticMember: staticMember,
          extAttrs: extAttrs,
        ),
      IdlConstructor(:final parameters, :final extAttrs) => IdlConstructor(
        parameters: parameters
            .map(
              (p) => IdlParameter(
                name: p.name,
                type: _lowerFilteredOutTypes(p.type),
                required: p.required,
                defaultValue: p.defaultValue,
                variadic: p.variadic,
                extAttrs: p.extAttrs,
              ),
            )
            .toList(),
        extAttrs: extAttrs,
      ),
      IdlConstant(:final type, :final name, :final value, :final extAttrs) =>
        IdlConstant(
          name: name,
          type: _lowerFilteredOutTypes(type),
          value: value,
          extAttrs: extAttrs,
        ),
      IdlIterable(:final types, :final async, :final extAttrs) => IdlIterable(
        types: types.map(_lowerFilteredOutTypes).toList(),
        async: async,
        extAttrs: extAttrs,
      ),
      IdlMaplike(
        :final keyType,
        :final valueType,
        :final readonly,
        :final extAttrs,
      ) =>
        IdlMaplike(
          keyType: _lowerFilteredOutTypes(keyType),
          valueType: _lowerFilteredOutTypes(valueType),
          readonly: readonly,
          extAttrs: extAttrs,
        ),
      IdlSetlike(:final valueType, :final readonly, :final extAttrs) =>
        IdlSetlike(
          valueType: _lowerFilteredOutTypes(valueType),
          readonly: readonly,
          extAttrs: extAttrs,
        ),
      IdlField(
        :final type,
        :final name,
        :final required,
        :final defaultValue,
        :final extAttrs,
      ) =>
        IdlField(
          name: name,
          type: _lowerFilteredOutTypes(type),
          required: required,
          defaultValue: defaultValue,
          extAttrs: extAttrs,
        ),
    };
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
    final filteredMembers = bcdFilter != null
        ? members
              .where((m) {
                // Constructors are structural interface info, not member
                // coverage; the BCD filter keys on member names and would drop
                // them.
                if (m is IdlConstructor) return true;
                return bcdFilter!.shouldGenerateMember(name, m.name);
              })
              .map(_lowerMemberTypes)
              .toList()
        : members;
    interfaces.update(
      name,
      (l) => l
        ..add(
          IdlInterface(
            name: name,
            spec: spec,
            inheritance: e['inheritance'] as String?,
            members: filteredMembers,
            partial: e['partial'] as bool? ?? false,
            extAttrs: extAttrs,
          ),
        ),
      ifAbsent: () => [
        IdlInterface(
          name: name,
          spec: spec,
          inheritance: e['inheritance'] as String?,
          members: filteredMembers,
          partial: e['partial'] as bool? ?? false,
          extAttrs: extAttrs,
        ),
      ],
    );
    specOf.putIfAbsent(name, () => spec);
  }

  void _addNamespace(
    Map<String, List<IdlNamespace>> namespaces,
    Map<String, String> specOf,
    String name,
    String spec,
    Map<String, dynamic> e,
    List<IdlMember> members,
    List<ExtAttr> extAttrs,
  ) {
    final filteredMembers = bcdFilter != null
        ? members
              .where((m) {
                return bcdFilter!.shouldGenerateMember(name, m.name);
              })
              .map(_lowerMemberTypes)
              .toList()
        : members;
    namespaces.update(
      name,
      (l) => l
        ..add(
          IdlNamespace(
            name: name,
            spec: spec,
            members: filteredMembers,
            partial: e['partial'] as bool? ?? false,
            extAttrs: extAttrs,
          ),
        ),
      ifAbsent: () => [
        IdlNamespace(
          name: name,
          spec: spec,
          members: filteredMembers,
          partial: e['partial'] as bool? ?? false,
          extAttrs: extAttrs,
        ),
      ],
    );
    specOf.putIfAbsent(name, () => spec);
  }

  List<ExtAttr> _extAttrsOf(Object? raw) {
    final list = raw as List<dynamic>? ?? [];
    return list.whereType<Map<String, dynamic>>().map(parseExtAttr).toList();
  }
}
