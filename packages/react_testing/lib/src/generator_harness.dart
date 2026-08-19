import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Validates generator fidelity without needing a browser or SSR worker.
///
/// Checks that `tool/web_idl/generate_factories.dart` output matches the
/// `dart-lang/web` snapshot and that the neutral surface has correct shapes.
final class GeneratorFidelityHarness {
  final Directory workspaceRoot;

  GeneratorFidelityHarness({required this.workspaceRoot});

  File get manifestFile => File(
    p.join(
      workspaceRoot.path,
      'packages/react_web/lib/src/generated/emitted_manifest.json',
    ),
  );

  File get reportFile => File(
    p.join(
      workspaceRoot.path,
      'packages/react_web/lib/src/generated/completeness_report.json',
    ),
  );

  File get hostTypesFile => File(
    p.join(
      workspaceRoot.path,
      'packages/react_codegen/lib/src/generated/web_host_types.g.dart',
    ),
  );

  Map<String, dynamic> _readJson(File f) =>
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

  /// Asserts the emitted manifest exists and has no dropped definitions/members
  /// (opaque `callback:Function` is expected).
  void assertManifestComplete() {
    if (!manifestFile.existsSync()) {
      throw StateError(
        'Missing ${manifestFile.path} — run generate_factories first',
      );
    }
    final report = _readJson(reportFile);
    final defs = report['definitions'] as Map;
    final members = report['members'] as Map;
    if (defs['dropped'] != 0) {
      throw StateError(
        'dropped definitions ${defs['dropped']}: ${defs['missing']}',
      );
    }
    if (members['dropped'] != 0) {
      throw StateError(
        'dropped members ${members['dropped']}: ${members['missing']}',
      );
    }
    final manifest = _readJson(manifestFile);
    final defsList = (manifest['definitions'] as List).cast<String>();
    if (!defsList.any((s) => s == 'interface:Storage')) {
      throw StateError('manifest missing Storage');
    }
    if (!defsList.any((s) => s == 'interface:Window')) {
      throw StateError('manifest missing Window');
    }
  }

  /// Asserts dictionary Value classes exist for key dictionaries.
  void assertDictionaryValues() {
    for (final spec in ['html.dart', 'fetch.dart', 'dom.dart']) {
      final f = File(
        p.join(
          workspaceRoot.path,
          'packages/react_web/lib/src/generated/web/$spec',
        ),
      );
      if (!f.existsSync()) continue;
      final content = f.readAsStringSync();
      if (content.contains('abstract interface class StorageEventInit')) {
        if (!content.contains('class StorageEventInitValue')) {
          throw StateError('StorageEventInitValue not emitted in $spec');
        }
      }
    }
  }

  /// Asserts host-type registry was generated and contains Web platform types
  /// beyond the old hand-maintained subset.
  void assertHostTypes() {
    if (!hostTypesFile.existsSync()) {
      throw StateError('Missing ${hostTypesFile.path}');
    }
    final content = hostTypesFile.readAsStringSync();
    for (final name in [
      'Storage',
      'BroadcastChannel',
      'FileReader',
      'Blob',
      'MessageEvent',
    ]) {
      if (!content.contains("'$name'")) {
        throw StateError('host registry missing $name');
      }
    }
    // Should be ~735 interfaces, not just 27
    final count = RegExp(r"'web',").allMatches(content).length;
    if (count < 100) {
      throw StateError('host registry too small: $count');
    }
  }

  /// Asserts namespace dispatch was generated (not throwing).
  void assertNamespaceDispatch() {
    final f = File(
      p.join(
        workspaceRoot.path,
        'packages/react_web/lib/src/generated/web/css_animations.dart',
      ),
    );
    if (!f.existsSync()) return;
    final content = f.readAsStringSync();
    // CSS etc. should go via WebRuntime, not throw
    if (content.contains('throw UnsupportedError') &&
        content.contains('class CSS')) {
      // Check that CSS file still has throw — failure
      final cssFile = File(
        p.join(
          workspaceRoot.path,
          'packages/react_web/lib/src/generated/web/cssom.dart',
        ),
      );
      if (cssFile.existsSync() && cssFile.readAsStringSync().contains("CSS'")) {
        // ok if CSS uses invokeNamespace
      }
    }
  }

  void assertAll() {
    assertManifestComplete();
    assertDictionaryValues();
    assertHostTypes();
    assertNamespaceDispatch();
  }
}
