/// Verifies that every definition and member in the snapshot was emitted and
/// produces a completeness report. The hard invariant: `dropped` is always 0.
library;

import 'dart:convert';

import '../member.dart';
import '../members.dart';
import '../model.dart';

final class CompletenessVerifier {
  final CompleteWebModel model;
  final CompleteWebModel emittedModel;

  CompletenessVerifier({required this.model, required this.emittedModel});

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
