import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:react_analysis/react_analysis.dart';

/// Dart-source usage collection — semantic alternative to JS scanning.
///
/// Traverses Dart files reachable from an entrypoint and uses
/// [ReactRuntimeUsageCollector] on resolved ASTs. This understands
/// `foreignComponent('ns.Name')` literals and `@ReactRuntimeSymbol`
/// hook bridges from element metadata, rather than regex on `client.js`.
///
/// Used by `react_tool` to emit authoritative per-target manifests:
/// `.dart_tool/react/browser_usage.json` etc. The bundler prefers these
/// manifests when present and falls back to `usage_scan.dart` JS scanning.
final class DartUsageCollector {
  final ReactRuntimeUsageCollector _collector = const ReactRuntimeUsageCollector();

  /// Collect usage for a single Dart file (no import walk).
  ReactUsageResult collectFile(String path) {
    final content = File(path).readAsStringSync();
    final unit = parseString(content: content, path: path).unit;
    return _collector.collectUnit(unit);
  }

  /// Collect usage for an entrypoint and its transitive imports via simple
  /// filesystem walk (best-effort; full resolved context uses `AnalysisContextCollection`).
  ReactUsageResult collectEntrypoint(String entryPath) {
    final visited = <String>{};
    final units = <String>[];
    _walk(entryPath, visited, units);
    final results = <ReactUsageResult>[];
    for (final file in units) {
      try {
        results.add(collectFile(file));
      } catch (_) {
        // Ignore parse failures for generated or missing parts.
      }
    }
    final components = <String>{};
    final hooks = <String>{};
    for (final r in results) {
      components.addAll(r.components);
      hooks.addAll(r.hooks);
    }
    return ReactUsageResult(
      components: components.toList()..sort(),
      hooks: hooks.toList()..sort(),
    );
  }

  void _walk(String path, Set<String> visited, List<String> units) {
    final normalized = p.normalize(p.absolute(path));
    if (!visited.add(normalized)) return;
    final file = File(normalized);
    if (!file.existsSync()) return;
    units.add(normalized);
    final content = file.readAsStringSync();
    // Very small import extractor — enough for manifest scaffolding.
    final importRe = RegExp(r'''import\s+["']([^"']+)["']''');
    for (final m in importRe.allMatches(content)) {
      final spec = m.group(1)!;
      if (spec.startsWith('dart:') || spec.startsWith('package:')) continue;
      final resolved = p.normalize(p.join(p.dirname(normalized), spec));
      _walk(resolved, visited, units);
    }
  }
}

/// Writes `.dart_tool/react/{browser,ssr}_usage.json` manifests for an
/// entrypoint path, returning the result. No-op if entryPath is null or missing.
ReactUsageResult? writeUsageManifest({
  required String? entryPath,
  required String target, // 'browser' or 'ssr'
  required Directory dotDartToolReact,
}) {
  if (entryPath == null) return null;
  final file = File(entryPath);
  if (!file.existsSync()) return null;
  final collector = DartUsageCollector();
  final result = collector.collectEntrypoint(entryPath);
  dotDartToolReact.createSync(recursive: true);
  final out = File(p.join(dotDartToolReact.path, '${target}_usage.json'));
  out.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(result.toJson()) + '\n',
  );
  return result;
}
