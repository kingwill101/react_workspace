/// The complete, normalized Web IDL model built from a `web_apis.json` snapshot.
///
/// All `partial` declarations have been merged and every `includes` is recorded
/// on its target interface via `includedMixins`.
library;

import '../model/type_ref.dart';
import 'definition.dart';
import 'member.dart';

final class CompleteWebModel {
  final Map<String, IdlInterface> interfaces;
  final Map<String, IdlMixin> mixins;
  final Map<String, IdlDictionary> dictionaries;
  final Map<String, IdlNamespace> namespaces;
  final Map<String, IdlEnum> enums;
  final Map<String, IdlTypedef> typedefs;
  final Map<String, IdlCallback> callbacks;
  final Map<String, IdlCallbackInterface> callbackInterfaces;

  /// definition name -> its `idl` spec group key (used for module split).
  final Map<String, String> specOf;

  const CompleteWebModel({
    required this.interfaces,
    required this.mixins,
    required this.dictionaries,
    required this.namespaces,
    required this.enums,
    required this.typedefs,
    required this.callbacks,
    required this.callbackInterfaces,
    required this.specOf,
  });

  Iterable<WebIdlDefinition> get allDefinitions sync* {
    yield* interfaces.values;
    yield* mixins.values;
    yield* dictionaries.values;
    yield* namespaces.values;
    yield* enums.values;
    yield* typedefs.values;
    yield* callbacks.values;
    yield* callbackInterfaces.values;
  }

  int get definitionCount =>
      interfaces.length +
      mixins.length +
      dictionaries.length +
      namespaces.length +
      enums.length +
      typedefs.length +
      callbacks.length +
      callbackInterfaces.length;

  WebIdlDefinition? definitionByName(String name) {
    return interfaces[name] ??
        mixins[name] ??
        dictionaries[name] ??
        namespaces[name] ??
        enums[name] ??
        typedefs[name] ??
        callbacks[name] ??
        callbackInterfaces[name];
  }

  /// Collect every referenced (non-core) type name across all definitions.
  Set<String> referencedTypeNames() {
    final out = <String>{};
    void ref(TypeRef t) {
      switch (t) {
        case NamedTypeRef():
          final id = t.typeId;
          if (!id.startsWith('core.')) {
            out.add(id);
          }
          for (final a in t.arguments) {
            ref(a);
          }
        case UnionTypeRef():
          for (final o in t.options) {
            ref(o);
          }
        case TypeParameterRef():
          break;
      }
    }

    for (final d in allDefinitions) {
      final list = switch (d) {
        IdlInterface() => d.members,
        IdlMixin() => d.members,
        IdlNamespace() => d.members,
        IdlCallbackInterface() => d.members,
        IdlDictionary() => d.fields,
        IdlCallback() => d.parameters,
        IdlEnum() || IdlIncludes() => const <Object>[],
        IdlTypedef() => <Object>[d.type],
      };
      for (final m in list) {
        _memberRefs(m, ref);
      }
    }
    return out;
  }

  void _memberRefs(Object m, void Function(TypeRef) ref) {
    switch (m) {
      case IdlAttribute():
        ref(m.type);
      case IdlOperation():
        ref(m.returnType);
        for (final p in m.parameters) {
          ref(p.type);
        }
      case IdlConstructor():
        for (final p in m.parameters) {
          ref(p.type);
        }
      case IdlConstant():
        ref(m.type);
      case IdlIterable():
        for (final t in m.types) {
          ref(t);
        }
      case IdlMaplike():
        ref(m.keyType);
        ref(m.valueType);
      case IdlSetlike():
        ref(m.valueType);
      case IdlField():
        ref(m.type);
      case IdlParameter():
        ref(m.type);
    }
  }
}
