import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test(
    'TypeScript binding generation stays split into reviewable phases',
    () async {
      final facadeUri = await Isolate.resolvePackageUri(
        Uri.parse('package:react_tool/src/ts_bindings.dart'),
      );
      expect(facadeUri, isNotNull);

      final facade = File.fromUri(facadeUri!);
      final source = await facade.readAsString();
      final phases = <String>[
        'bindings_emitter.dart',
        'hooks_emitter.dart',
        'ir.dart',
        'shim_emitter.dart',
        'type_registry.dart',
      ];

      expect(source.split('\n').length, lessThan(100));
      for (final phase in phases) {
        expect(source, contains("part 'ts_bindings/$phase';"));
        final file = File(p.join(facade.parent.path, 'ts_bindings', phase));
        expect(
          file.existsSync(),
          isTrue,
          reason: 'missing generator phase $phase',
        );
        final phaseSource = await file.readAsString();
        expect(phaseSource, startsWith("part of '../ts_bindings.dart';"));
        expect(
          phaseSource.split('\n').length,
          lessThan(1000),
          reason: '$phase has grown too large; split it by responsibility',
        );
      }
    },
  );
}
