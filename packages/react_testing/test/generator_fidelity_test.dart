import 'dart:io';

import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  group('Generator fidelity', () {
    final harness = GeneratorFidelityHarness(
      workspaceRoot: Directory.current.path.endsWith('react_testing')
          ? Directory.current.parent.parent
          : Directory.current,
    );

    test('emitted manifest is complete (no dropped)', () {
      harness.assertManifestComplete();
    });

    test('dictionary Value classes are emitted', () {
      harness.assertDictionaryValues();
    });

    test('host-type registry covers Web platform (not just hand list)', () {
      harness.assertHostTypes();
    });

    test('namespace dispatch is generated', () {
      harness.assertNamespaceDispatch();
    });
  });
}
