/// Turns a [RawWebModel] into a [CompleteWebModel] by merging `partial`
/// declarations and folding `includes` into their target interfaces.
library;

import 'definition.dart';
import 'member.dart';
import 'model.dart';
import 'raw_model.dart';

CompleteWebModel mergeRawModel(RawWebModel raw) {
  final interfaces = _mergeInterfaces(raw);
  final mixins = _mergeMixins(raw);
  final dictionaries = _mergeDictionaries(raw);
  final namespaces = _mergeNamespaces(raw);

  return CompleteWebModel(
    interfaces: interfaces,
    mixins: mixins,
    dictionaries: dictionaries,
    namespaces: namespaces,
    enums: raw.enums,
    typedefs: raw.typedefs,
    callbacks: raw.callbacks,
    callbackInterfaces: raw.callbackInterfaces,
    specOf: raw.specOf,
  );
}

Map<String, IdlInterface> _mergeInterfaces(RawWebModel raw) {
  final out = <String, IdlInterface>{};
  for (final entry in raw.interfaces.entries) {
    final list = entry.value;
    String? inheritance;
    final members = <IdlMember>[];
    final attrs = <ExtAttr>[];
    for (final p in list) {
      if (p.inheritance != null) inheritance = p.inheritance;
      members.addAll(p.members);
      attrs.addAll(p.extAttrs);
    }
    out[entry.key] = IdlInterface(
      name: entry.key,
      spec: raw.specOf[entry.key] ?? list.first.spec,
      inheritance: inheritance,
      members: members,
      partial: list.any((p) => p.partial),
      extAttrs: attrs,
    );
  }
  // Fold includes: append mixin names onto the target interface.
  for (final incl in raw.includes) {
    final iface = out[incl.target];
    if (iface != null && !iface.includedMixins.contains(incl.includes)) {
      out[incl.target] = IdlInterface(
        name: iface.name,
        spec: iface.spec,
        inheritance: iface.inheritance,
        members: iface.members,
        includedMixins: [...iface.includedMixins, incl.includes],
        partial: iface.partial,
        extAttrs: iface.extAttrs,
      );
    }
  }
  return out;
}

Map<String, IdlMixin> _mergeMixins(RawWebModel raw) {
  final out = <String, IdlMixin>{};
  for (final entry in raw.mixins.entries) {
    final list = entry.value;
    final members = <IdlMember>[];
    final attrs = <ExtAttr>[];
    for (final p in list) {
      members.addAll(p.members);
      attrs.addAll(p.extAttrs);
    }
    out[entry.key] = IdlMixin(
      name: entry.key,
      spec: raw.specOf[entry.key] ?? list.first.spec,
      members: members,
      partial: list.any((p) => p.partial),
      extAttrs: attrs,
    );
  }
  return out;
}

Map<String, IdlDictionary> _mergeDictionaries(RawWebModel raw) {
  final out = <String, IdlDictionary>{};
  for (final entry in raw.dictionaries.entries) {
    final list = entry.value;
    String? inheritance;
    final fields = <IdlField>[];
    final attrs = <ExtAttr>[];
    for (final p in list) {
      if (p.inheritance != null) inheritance = p.inheritance;
      fields.addAll(p.fields);
      attrs.addAll(p.extAttrs);
    }
    out[entry.key] = IdlDictionary(
      name: entry.key,
      spec: raw.specOf[entry.key] ?? list.first.spec,
      inheritance: inheritance,
      fields: fields,
      partial: list.any((p) => p.partial),
      extAttrs: attrs,
    );
  }
  return out;
}

Map<String, IdlNamespace> _mergeNamespaces(RawWebModel raw) {
  final out = <String, IdlNamespace>{};
  for (final entry in raw.namespaces.entries) {
    final list = entry.value;
    final members = <IdlMember>[];
    final attrs = <ExtAttr>[];
    for (final p in list) {
      members.addAll(p.members);
      attrs.addAll(p.extAttrs);
    }
    out[entry.key] = IdlNamespace(
      name: entry.key,
      spec: raw.specOf[entry.key] ?? list.first.spec,
      members: members,
      partial: list.any((p) => p.partial),
      extAttrs: attrs,
    );
  }
  return out;
}
