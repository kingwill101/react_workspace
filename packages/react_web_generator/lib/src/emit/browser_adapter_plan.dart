/// Analysis model used by [BrowserAdapterEmitter].
///
/// Keeping closure discovery, IDL conflict resolution, and conversion-kind
/// classification separate from source rendering makes both phases testable
/// without comparing fragments of generated Dart text.
library;

import '../complete/definition.dart';
import '../complete/member.dart';
import '../complete/members.dart';
import '../complete/model.dart';
import '../model/type_ref.dart';
import 'react_event_defs.dart';

/// Immutable decisions required to render the browser adapter.
final class BrowserAdapterPlan {
  /// Interfaces that need browser proxy classes.
  final Set<String> wrapperNames;

  /// Interfaces that expose a JavaScript constructor.
  final List<String> constructibleNames;

  /// Conversion kind keyed by `BrowserType.member`.
  final Map<String, String> memberKinds;

  /// Escaped Dart member name to JavaScript member name.
  final Map<String, String> jsNames;

  final CompleteWebModel _model;

  const BrowserAdapterPlan._({
    required this.wrapperNames,
    required this.constructibleNames,
    required this.memberKinds,
    required this.jsNames,
    required this._model,
  });

  /// Whether [name] is a Dart/core type rather than a generated Web type.
  bool isReserved(String name) => _reservedTypeNames.contains(name);

  /// Whether [name] anchors browser host-value registration.
  bool isElementLike(String name) =>
      name.startsWith('HTML') ||
      name.startsWith('SVG') ||
      name.startsWith('MathML') ||
      _elementSeeds.contains(name);

  /// Computes the compatible neutral interfaces implemented by a proxy.
  List<String> implementsNames(String name) {
    final result = <String>[name];
    final covered = _resolvedMembers(name);
    final seen = <String>{name};
    var current = _model.interfaces[name]?.inheritance;
    while (current != null && seen.add(current)) {
      final parent = _model.interfaces[current];
      if (parent == null || isReserved(current)) break;
      final resolved = _resolvedMembers(current);
      final conflicts = resolved.values.any((member) {
        final prior = covered[member.name];
        return prior != null &&
            _memberSignature(prior) != _memberSignature(member);
      });
      if (!conflicts) {
        result.add(current);
        covered.addAll(resolved);
      }
      current = parent.inheritance;
    }
    return result;
  }

  Map<String, IdlMember> _resolvedMembers(String interfaceName) {
    final interface = _model.interfaces[interfaceName];
    if (interface == null) return const {};
    final operations = <String, IdlOperation>{};
    final seenNames = <String>{};
    final members = <IdlMember>[];
    for (final member in flattenMembers(_model, interface)) {
      if (member is IdlOperation) {
        final existing = operations[member.name];
        if (existing == null ||
            member.parameters.length > existing.parameters.length) {
          operations[member.name] = member;
        }
        if (seenNames.add(member.name)) members.add(member);
      } else if (member is IdlAttribute && seenNames.add(member.name)) {
        members.add(member);
      }
    }
    return {
      for (final member in members)
        member.name: member is IdlOperation ? operations[member.name]! : member,
    };
  }
}

/// Builds a [BrowserAdapterPlan] from the complete Web IDL model.
final class BrowserAdapterPlanner {
  final CompleteWebModel model;

  const BrowserAdapterPlanner(this.model);

  /// Resolves the browser proxy closure and member conversion tables.
  BrowserAdapterPlan build() {
    final wrapperNames = _wrapperClosure();
    final callbackNames = _callbackNames();
    final memberKinds = <String, String>{};
    final jsNames = <String, String>{};

    for (final name in wrapperNames.toList()..sort()) {
      _collectMemberTable(
        className: 'Browser$name',
        interface: model.interfaces[name]!,
        callbackNames: callbackNames,
        memberKinds: memberKinds,
        jsNames: jsNames,
      );
    }
    for (final definition in reactEventDefs) {
      _collectEventTable(definition, memberKinds);
    }

    final constructibleNames = [
      for (final name in model.interfaces.keys)
        if (_isConstructible(name) && !_reservedTypeNames.contains(name)) name,
    ]..sort();

    return BrowserAdapterPlan._(
      wrapperNames: Set.unmodifiable(wrapperNames),
      constructibleNames: List.unmodifiable(constructibleNames),
      memberKinds: Map.unmodifiable(memberKinds),
      jsNames: Map.unmodifiable(jsNames),
      model: model,
    );
  }

  Set<String> _wrapperClosure() {
    final wrapperNames = <String>{};
    final queue = <String>[
      for (final name in model.interfaces.keys)
        if (_isElementLike(name) || _isConstructible(name)) name,
    ];
    while (queue.isNotEmpty) {
      final name = queue.removeLast();
      if (!wrapperNames.add(name)) continue;
      final interface = model.interfaces[name];
      if (interface == null) continue;
      for (final member in flattenMembers(model, interface)) {
        for (final reference in _referencedTypeNames(member)) {
          if (model.interfaces.containsKey(reference)) queue.add(reference);
        }
      }
    }
    return wrapperNames;
  }

  bool _isElementLike(String name) =>
      name.startsWith('HTML') ||
      name.startsWith('SVG') ||
      name.startsWith('MathML') ||
      _elementSeeds.contains(name);

  bool _isConstructible(String name) =>
      model.interfaces[name]?.members.any((m) => m is IdlConstructor) ?? false;

  Set<String> _callbackNames() {
    final names = <String>{
      for (final callback in model.callbacks.values) callback.name,
    };
    var changed = true;
    while (changed) {
      changed = false;
      for (final typedef in model.typedefs.entries) {
        if (names.contains(typedef.key)) continue;
        final target = _typeName(typedef.value.type);
        if (target != null &&
            names.contains(target) &&
            names.add(typedef.key)) {
          changed = true;
        }
      }
    }
    return names;
  }

  void _collectMemberTable({
    required String className,
    required IdlInterface interface,
    required Set<String> callbackNames,
    required Map<String, String> memberKinds,
    required Map<String, String> jsNames,
  }) {
    for (final member in flattenMembers(model, interface)) {
      final (name, type) = switch (member) {
        IdlAttribute() => (member.name, member.type),
        IdlOperation() when member.name.isNotEmpty => (
          member.name,
          member.returnType,
        ),
        _ => (null, null),
      };
      if (name == null || type == null) continue;
      final dartName = escapeIdentifier(name);
      memberKinds['$className.$dartName'] = _kindOf(type, callbackNames);
      if (dartName != name) jsNames['$className.$dartName'] = name;
    }
  }

  void _collectEventTable(
    ReactEventDef definition,
    Map<String, String> memberKinds,
  ) {
    final className = 'Browser${definition.name}';
    final base = reactEventDefs.first;
    for (final member in [
      ...base.members,
      ...base.methods,
      ...definition.members,
      ...definition.methods,
    ]) {
      memberKinds['$className.${member.name}'] = _kindFromReturnType(
        member.returnType,
      );
    }
  }
}

const _reservedTypeNames = <String>{
  'Function',
  'Object',
  'String',
  'int',
  'double',
  'bool',
  'dynamic',
  'void',
  'num',
  'Null',
  'Never',
  'Future',
  'List',
  'Map',
  'Set',
  'Iterable',
  'Type',
};

const _elementSeeds = <String>{
  'EventTarget',
  'Node',
  'Element',
  'HTMLElement',
  'SVGElement',
  'MathMLElement',
  'Window',
  'Document',
  'Navigator',
};

String? _typeName(TypeRef type) => switch (type) {
  NamedTypeRef() =>
    type.typeId.contains('.') ? type.typeId.split('.').last : type.typeId,
  _ => null,
};

Iterable<String> _referencedTypeNames(IdlMember member) sync* {
  switch (member) {
    case IdlAttribute():
      yield* _namesOf(member.type);
    case IdlOperation():
      yield* _namesOf(member.returnType);
      for (final parameter in member.parameters) {
        yield* _namesOf(parameter.type);
      }
    case IdlIterable():
      for (final type in member.types) {
        yield* _namesOf(type);
      }
    case IdlMaplike():
      yield* _namesOf(member.keyType);
      yield* _namesOf(member.valueType);
    case IdlSetlike():
      yield* _namesOf(member.valueType);
    case IdlConstant():
      yield* _namesOf(member.type);
    case IdlConstructor() || IdlField():
      break;
  }
}

Iterable<String> _namesOf(TypeRef type) sync* {
  switch (type) {
    case NamedTypeRef():
      final id = type.typeId;
      if (id.startsWith('core.')) return;
      yield id.contains('.') ? id.substring(id.indexOf('.') + 1) : id;
      for (final argument in type.arguments) {
        yield* _namesOf(argument);
      }
    case UnionTypeRef():
      for (final option in type.options) {
        yield* _namesOf(option);
      }
    case TypeParameterRef():
      break;
  }
}

String _kindOf(TypeRef type, Set<String> callbackNames) {
  switch (type) {
    case NamedTypeRef():
      final id = type.typeId;
      final name = id.contains('.') ? id.substring(id.indexOf('.') + 1) : id;
      if (callbackNames.contains(name)) return 'jsfunction';
      if (name == 'Promise') return 'promise';
      if (name == 'sequence' ||
          name == 'FrozenArray' ||
          name == 'ObservableArray') {
        return 'list';
      }
      if (name == 'record') return 'map';
      if (name.endsWith('Array') &&
          (name.startsWith('Int') ||
              name.startsWith('Uint') ||
              name.startsWith('Float') ||
              name == 'ArrayBuffer' ||
              name == 'SharedArrayBuffer')) {
        return 'typedArray';
      }
      return switch (name) {
        'bool' => 'bool',
        'int' => 'int',
        'double' || 'num' => 'double',
        'String' => 'string',
        'void' => 'void',
        _ => 'wrap',
      };
    case UnionTypeRef() || TypeParameterRef():
      return 'wrap';
  }
}

String _kindFromReturnType(String returnType) {
  final clean = returnType.endsWith('?')
      ? returnType.substring(0, returnType.length - 1)
      : returnType;
  return switch (clean) {
    'bool' => 'bool',
    'int' => 'int',
    'double' => 'double',
    'String' => 'string',
    'void' => 'void',
    _ => 'wrap',
  };
}

String _memberSignature(IdlMember member) => switch (member) {
  IdlAttribute() => 'attr:${member.readonly}:${member.type}',
  IdlOperation() =>
    'op:${member.returnType}:${member.parameters.map((p) => '${p.name}:${p.type}').join(',')}',
  _ => 'other',
};
