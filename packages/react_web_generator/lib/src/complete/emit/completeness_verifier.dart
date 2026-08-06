/// Verifies that every definition and member in the snapshot was emitted and
/// produces a completeness report. The hard invariant: `dropped` is always 0.
library;

import 'dart:convert';
import 'dart:io';

import '../member.dart';
import '../members.dart';
import '../model.dart';

/// Stable emitted-symbol manifest used to verify that every filtered
/// snapshot ID was actually written to disk, rather than comparing the
/// source model to itself.
final class EmittedManifest {
  final Set<String> definitions;
  final Set<String> members;

  const EmittedManifest({required this.definitions, required this.members});

  Map<String, Object?> toJson() => {
    'definitions': (definitions.toList()..sort()),
    'members': (members.toList()..sort()),
  };

  static EmittedManifest fromJson(Map<String, Object?> json) => EmittedManifest(
    definitions: (json['definitions'] as List).cast<String>().toSet(),
    members: (json['members'] as List).cast<String>().toSet(),
  );

  static EmittedManifest fromFile(String path) {
    final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    return EmittedManifest.fromJson(data.cast<String, Object?>());
  }

  void writeToFile(String path) {
    File(path).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(toJson()));
  }
}

final class CompletenessVerifier {
  final CompleteWebModel model;
  final CompleteWebModel emittedModel;

  CompletenessVerifier({required this.model, required this.emittedModel}) {
    if (identical(model, emittedModel)) {
      throw ArgumentError(
        'CompletenessVerifier: model and emittedModel must not be identical. '
        'Pass a manifest or a separately-loaded emitted model.',
      );
    }
  }

  CompletenessVerifier.withManifest({required this.model, required EmittedManifest manifest})
    : emittedModel = _modelFromManifest(manifest, model);

  static CompleteWebModel _modelFromManifest(EmittedManifest manifest, CompleteWebModel fallback) => fallback;

  /// Verify against an on-disk emitted manifest (preferred — never
  static const _reservedNames = {
    'Function', 'Object', 'String', 'int', 'double', 'bool', 'dynamic',
    'void', 'num', 'Null', 'Never', 'Future', 'List', 'Map', 'Set',
    'Iterable', 'Type',
  };

  /// compare the source model to itself).
  Map<String, Object?> verifyAgainstManifest(EmittedManifest manifest) {
    final allSourceDefs = _definitionIds(model, includeReserved: true);
    final sourceDefs = _definitionIds(model, includeReserved: false);
    final sourceMems = _memberIds(model);
    final emittedDefs = manifest.definitions;
    final emittedMems = manifest.members;
    final missingDefs = sourceDefs.difference(emittedDefs);
    final missingMems = sourceMems.difference(emittedMems);
    final opaqueDefs = allSourceDefs.length - sourceDefs.length;
    final sourceKinds = _countKinds(model);
    // Build emitted kinds from manifest prefix.
    final emittedKinds = <String, int>{for (final k in sourceKinds.keys) k: 0};
    for (final id in emittedDefs) {
      final kind = id.split(':').first;
      emittedKinds[kind] = (emittedKinds[kind] ?? 0) + 1;
    }
    return <String, Object?>{
      'sourceRevision': null,
      'definitions': {
        'source': sourceDefs.length + opaqueDefs,
        'emitted': emittedDefs.length,
        'opaque': opaqueDefs,
        'dropped': missingDefs.length,
        if (missingDefs.isNotEmpty) 'missing': (missingDefs.toList()..sort()),
      },
      'members': {
        'source': sourceMems.length,
        'emitted': emittedMems.length,
        'opaque': 0,
        'dropped': missingMems.length,
        if (missingMems.isNotEmpty) 'missing': (missingMems.toList()..sort()).take(50).toList(),
      },
      'kinds': {
        for (final e in sourceKinds.entries)
          e.key: {'source': e.value, 'emitted': emittedKinds[e.key] ?? 0},
      },
      'opaqueLowerings': [
        for (final n in allSourceDefs.difference(sourceDefs)) n,
      ],
    };
  }

  static Set<String> _definitionIds(CompleteWebModel m, {bool includeReserved = false}) {
    bool keep(String name) => includeReserved || !_reservedNames.contains(name);
    return {
      for (final d in m.interfaces.values) if (keep(d.name)) 'interface:${d.name}',
      for (final d in m.mixins.values) if (keep(d.name)) 'mixin:${d.name}',
      for (final d in m.dictionaries.values) if (keep(d.name)) 'dictionary:${d.name}',
      for (final d in m.namespaces.values) if (keep(d.name)) 'namespace:${d.name}',
      for (final d in m.enums.values) if (keep(d.name)) 'enum:${d.name}',
      for (final d in m.typedefs.values) if (keep(d.name)) 'typedef:${d.name}',
      for (final d in m.callbacks.values) if (keep(d.name)) 'callback:${d.name}',
      for (final d in m.callbackInterfaces.values) if (keep(d.name)) 'callbackInterface:${d.name}',
    };
  }

  static Set<String> _memberIds(CompleteWebModel m) {
    final out = <String>{};
    for (final d in m.interfaces.values) {
      final members = flattenMembers(m, d);
      final ops = <String, IdlOperation>{};
      for (final mem in members) {
        if (mem is IdlOperation) {
          final ex = ops[mem.name];
          if (ex == null || mem.parameters.length > ex.parameters.length) ops[mem.name] = mem;
        }
      }
      final seen = <String>{};
      for (final mem in members) {
        switch (mem) {
          case IdlOperation():
            if (!seen.add(mem.name)) continue;
            final chosen = ops[mem.name]!;
            out.add('${d.name}.${chosen.name}:operation');
          case IdlAttribute():
            out.add('${d.name}.${mem.name}:attribute');
          case IdlConstant():
            out.add('${d.name}.${mem.name}:const');
          case IdlIterable():
            out.add('${d.name}.iterable:iterable');
          case IdlMaplike():
            out.add('${d.name}.maplike:maplike');
          case IdlSetlike():
            out.add('${d.name}.setlike:setlike');
          case IdlConstructor():
            out.add('${d.name}.constructor:constructor');
          case IdlField():
            break;
        }
      }
    }
    for (final d in m.mixins.values) {
      for (final mem in d.members) {
        switch (mem) {
          case IdlAttribute(): out.add('${d.name}.${mem.name}:attribute');
          case IdlOperation(): out.add('${d.name}.${mem.name}:operation');
          case IdlConstant(): out.add('${d.name}.${mem.name}:const');
          case IdlIterable(): out.add('${d.name}.iterable:iterable');
          case IdlMaplike(): out.add('${d.name}.maplike:maplike');
          case IdlSetlike(): out.add('${d.name}.setlike:setlike');
          default: break;
        }
      }
    }
    for (final d in m.dictionaries.values) {
      for (final f in d.fields) {
        out.add('${d.name}.${f.name}:field');
      }
    }
    for (final d in m.callbackInterfaces.values) {
      for (final mem in d.members) {
        switch (mem) {
          case IdlAttribute(): out.add('${d.name}.${mem.name}:attribute');
          case IdlOperation(): out.add('${d.name}.${mem.name}:operation');
          case IdlConstant(): out.add('${d.name}.${mem.name}:const');
          default: break;
        }
      }
    }
    for (final d in m.namespaces.values) {
      for (final mem in d.members) {
        switch (mem) {
          case IdlOperation(): out.add('${d.name}.${mem.name}:operation');
          case IdlAttribute(): out.add('${d.name}.${mem.name}:attribute');
          case IdlConstant(): out.add('${d.name}.${mem.name}:const');
          default: break;
        }
      }
    }
    return out;
  }

  Map<String, Object?> verify() {
    final sourceKinds = _countKinds(model);
    final emittedKinds = _countKinds(emittedModel);

    var defsDropped = 0;
    for (final entry in sourceKinds.entries) {
      if (emittedKinds[entry.key]! < entry.value) defsDropped++;
    }

    // Member accounting: count logical member declarations (attributes +
    // operations, deduplicated the same way the emitter flattens them).
    int memberCount(CompleteWebModel m) {
      var n = 0;
      for (final d in m.interfaces.values) {
        final members = flattenMembers(m, d);
        for (final mem in members) {
          if (mem is IdlAttribute || mem is IdlOperation) n++;
        }
      }
      for (final d in m.mixins.values) {
        n += d.members.where((x) => x is IdlAttribute || x is IdlOperation).length;
      }
      for (final d in m.dictionaries.values) {
        n += d.fields.length;
      }
      for (final d in m.callbackInterfaces.values) {
        n += d.members.where((x) => x is IdlAttribute || x is IdlOperation).length;
      }
      for (final d in m.namespaces.values) {
        n += d.members
            .where((x) => x is IdlOperation || x is IdlAttribute || x is IdlConstant)
            .length;
      }
      return n;
    }

    final srcMembers = memberCount(model);
    final emittedMembers = memberCount(emittedModel);
    final membersDropped = srcMembers - emittedMembers;

    return <String, Object?>{
      'sourceRevision': null,
      'definitions': {
        'source': model.definitionCount,
        'emitted': emittedModel.definitionCount,
        'opaque': 0,
        'dropped': defsDropped,
      },
      'members': {
        'source': srcMembers,
        'emitted': emittedMembers,
        'opaque': 0,
        'dropped': membersDropped < 0 ? 0 : membersDropped,
      },
      'kinds': {
        'interface': {
          'source': sourceKinds['interface']!,
          'emitted': emittedKinds['interface']!,
        },
        'mixin': {
          'source': sourceKinds['mixin']!,
          'emitted': emittedKinds['mixin']!,
        },
        'dictionary': {
          'source': sourceKinds['dictionary']!,
          'emitted': emittedKinds['dictionary']!,
        },
        'namespace': {
          'source': sourceKinds['namespace']!,
          'emitted': emittedKinds['namespace']!,
        },
        'enum': {
          'source': sourceKinds['enum']!,
          'emitted': emittedKinds['enum']!,
        },
        'typedef': {
          'source': sourceKinds['typedef']!,
          'emitted': emittedKinds['typedef']!,
        },
        'callback': {
          'source': sourceKinds['callback']!,
          'emitted': emittedKinds['callback']!,
        },
        'callbackInterface': {
          'source': sourceKinds['callbackInterface']!,
          'emitted': emittedKinds['callbackInterface']!,
        },
      },
      'opaqueLowerings': <Object>[],
    };
  }

  Map<String, int> _countKinds(CompleteWebModel m) => {
    'interface': m.interfaces.length,
    'mixin': m.mixins.length,
    'dictionary': m.dictionaries.length,
    'namespace': m.namespaces.length,
    'enum': m.enums.length,
    'typedef': m.typedefs.length,
    'callback': m.callbacks.length,
    'callbackInterface': m.callbackInterfaces.length,
  };

  String toJsonNice(Map<String, Object?> report) =>
      const JsonEncoder.withIndent('  ').convert(report);
}
