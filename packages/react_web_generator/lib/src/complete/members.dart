/// Utilities to render member signatures for the neutral surface, including
/// inheritance/mixin flattening, deduplication and identifier escaping.
library;

import '../model/type_ref.dart';
import 'definition.dart';
import 'member.dart';
import 'model.dart';

/// Flattened member list for an interface: own + inherited (via extends chain)
/// + members of included mixins. Deduplicated by an (kind,name,type) key, with
/// first-encountered kept. Static members are omitted (they are not part of
/// the instance contract).
List<IdlMember> flattenMembers(
  CompleteWebModel model,
  IdlInterface iface, {
  Set<String>? seen,
  Set<String>? visiting,
}) {
  final seenSet = seen ?? <String>{};
  final visitingSet = visiting ?? <String>{};
  final out = <IdlMember>[];

  void visitMembers(List<IdlMember> members) {
    for (final m in members) {
      if (m.staticMember) continue;
      final key = _memberKey(m);
      if (!seenSet.add(key)) continue;
      out.add(m);
    }
  }

  void includeMixin(String name) {
    if (!visitingSet.add(name)) return;
    final mixin = model.mixins[name];
    if (mixin != null) {
      visitMembers(mixin.members);
    }
    visitingSet.remove(name);
  }

  if (iface.inheritance != null) {
    final parent = model.interfaces[iface.inheritance];
    if (parent != null) {
      flattenMembers(
        model,
        parent,
        seen: seenSet,
        visiting: visitingSet,
      );
    }
  }

  for (final m in iface.includedMixins) {
    includeMixin(m);
  }

  visitMembers(iface.members);
  return out;
}

String _memberKey(IdlMember m) {
  String t(TypeRef? r) => r == null ? '' : r.toString();
  return switch (m) {
    IdlAttribute() => 'attr:${m.name}:${t(m.type)}:${m.readonly}',
    IdlOperation() => 'op:${m.name}:${t(m.returnType)}:${m.parameters.map((p) => '${p.name}${t(p.type)}').join(',')}:${m.special}',
    IdlConstructor() => 'ctor:${m.parameters.map((p) => '${p.name}${t(p.type)}').join(',')}',
    IdlConstant() => 'const:${m.name}',
    IdlIterable() => 'iter:${m.async}:${m.types.map(t).join(',')}',
    IdlMaplike() => 'map:${t(m.keyType)}:${t(m.valueType)}',
    IdlSetlike() => 'set:${t(m.valueType)}',
    IdlField() => 'field:${m.name}',
  };
}

String escapeIdentifier(String name) {
  var s = name
      .replaceAll('-', '_')
      .replaceAll(' ', '_')
      .replaceAll('.', '_')
      .replaceAll('#', '_');
  if (s.isEmpty) s = '_';
  if (RegExp(r'^[0-9]').hasMatch(s)) s = '_$s';
  if (_keywords.contains(s)) return '${s}_';
  return s;
}

const _keywords = <String>{
  'abstract','as','assert','async','await','break','case','catch','class','const',
  'continue','covariant','default','deferred','do','dynamic','else','enum','export',
  'extends','extension','external','factory','false','final','finally','for',
  'Function','get','hide','if','implements','import','in','interface','is','late',
  'library','mixin','new','null','on','operator','out','part','required','rethrow',
  'return','set','show','static','super','switch','sync','this','throw','true','try',
  'typedef','var','void','while','with','yield','when','override',
};
