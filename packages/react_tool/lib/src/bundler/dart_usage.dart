import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:react_analysis/react_analysis.dart';

/// Dart-source usage collection — semantic alternative to JS scanning.
///
/// Traverses Dart files reachable from an entrypoint using
/// [AnalysisContextCollection] and resolved units, so that
/// `foreignComponent`, `@ReactRuntimeSymbol` and `@ReactHook` are discovered
/// via element metadata, imports, exports, parts and package configuration —
/// not via `parseString` + regex.
///
/// Used by `react_tool` to emit per-target manifests:
/// `.dart_tool/react/browser_usage.json` etc. The bundler treats the
/// semantic manifest as authoritative only when `complete == true`; otherwise
/// it unions with the compiled-JS scan.
final class DartUsageCollector {
  final ReactRuntimeUsageCollector _collector =
      const ReactRuntimeUsageCollector();

  /// Collect usage for a single Dart file (no import walk).
  /// Returns incomplete result (complete == false) — for isolated plugin use.
  ReactUsageResult collectFile(String path) {
    final content = File(path).readAsStringSync();
    final unit = parseString(content: content, path: path).unit;
    final res = _collector.collectUnit(unit);
    return ReactUsageResult(
      components: res.components,
      hooks: res.hooks,
      functions: res.functions,
      values: res.values,
      rawComponentKeys: res.rawComponentKeys,
      rawHookKeys: res.rawHookKeys,
      rawFunctionKeys: res.rawFunctionKeys,
      rawValueKeys: res.rawValueKeys,
      complete: false,
      resolvedLibraries: 0,
      unresolvedLibraries: [p.normalize(p.absolute(path))],
    );
  }

  /// Legacy sync entrypoint walk (relative imports only, no package:).
  /// Returns incomplete result; prefer [collectEntrypointResolved].
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
    final functions = <String>{};
    final values = <String>{};
    final rawComp = <String, List<String>>{};
    final rawHooks = <String, List<String>>{};
    final rawFunctions = <String, List<String>>{};
    final rawValues = <String, List<String>>{};
    for (final r in results) {
      components.addAll(r.components);
      hooks.addAll(r.hooks);
      functions.addAll(r.functions);
      values.addAll(r.values);
      rawComp.addAll(r.rawComponentKeys);
      rawHooks.addAll(r.rawHookKeys);
      rawFunctions.addAll(r.rawFunctionKeys);
      rawValues.addAll(r.rawValueKeys);
    }
    return ReactUsageResult(
      components: components.toList()..sort(),
      hooks: hooks.toList()..sort(),
      functions: functions.toList()..sort(),
      values: values.toList()..sort(),
      rawComponentKeys: rawComp,
      rawHookKeys: rawHooks,
      rawFunctionKeys: rawFunctions,
      rawValueKeys: rawValues,
      complete: false,
      resolvedLibraries: 0,
      unresolvedLibraries: ['legacy-walk-incomplete'],
    );
  }

  /// Resolved entrypoint collection using [AnalysisContextCollection].
  ///
  /// Traverses the resolved library graph (imports, exports, parts, package
  /// config) and returns a [ReactUsageResult] with [complete] true only when
  /// every reachable library was successfully resolved.
  Future<ReactUsageResult> collectEntrypointResolved(
    String entryPath, {
    String? projectRoot,
  }) async {
    final absoluteEntry = p.normalize(p.absolute(entryPath));
    final root = projectRoot != null
        ? p.normalize(p.absolute(projectRoot))
        : p.dirname(absoluteEntry);

    final resourceProvider = PhysicalResourceProvider.INSTANCE;
    final collection = AnalysisContextCollection(
      includedPaths: [root],
      resourceProvider: resourceProvider,
    );

    final contexts = collection.contexts;
    if (contexts.isEmpty) {
      return ReactUsageResult(
        components: const [],
        hooks: const [],
        complete: false,
        unresolvedLibraries: [absoluteEntry],
      );
    }

    // Find the context that contains the entry.
    final context = collection.contextFor(absoluteEntry);
    final session = context.currentSession;

    final visitedLibraries = <String>{};
    final unresolved = <String>[];
    final pathUnits = <String, CompilationUnit>{};
    var resolvedCount = 0;

    bool isFrameworkSkippable(String path) {
      // Only framework packages that are proven incapable of containing
      // user runtime symbols may be skipped without affecting completeness.
      // Hosted packages (in .pub-cache) must NOT be whitelisted — they can
      // contain user code like shared_widgets that uses reactRouter hooks.
      return path.contains('/.dart_tool/') ||
          path.contains('/dart-sdk/') ||
          path.contains('packages/react/') ||
          path.contains('packages/react_analysis/') ||
          path.contains('packages/react_tool/') ||
          path.contains('packages/analyzer/');
    }

    final skipped = <String>[];
    Future<void> visitLibrary(String libPath) async {
      final normalized = p.normalize(p.absolute(libPath));
      if (!visitedLibraries.add(normalized)) return;
      final result = await session.getResolvedUnit(normalized);
      if (result is ResolvedUnitResult) {
        resolvedCount++;
        pathUnits[normalized] = result.unit;
        // Traverse imports/exports/parts via resolved directives.
        // Only traverse project-local files; record skipped non-framework
        // package deps so completeness is false when any reachable library
        // that could contain symbols was not inspected.
        for (final directive in result.unit.directives) {
          if (directive is ImportDirective) {
            final imported = directive.libraryImport?.importedLibrary;
            final path = imported?.firstFragment.source.fullName;
            if (path == null || path.isEmpty || path.startsWith('dart:'))
              continue;
            if (!path.startsWith(root)) {
              if (!isFrameworkSkippable(path)) skipped.add(path);
              continue;
            }
            await visitLibrary(path);
          } else if (directive is ExportDirective) {
            final exported = directive.libraryExport?.exportedLibrary;
            final path = exported?.firstFragment.source.fullName;
            if (path == null || path.isEmpty || path.startsWith('dart:'))
              continue;
            if (!path.startsWith(root)) {
              if (!isFrameworkSkippable(path)) skipped.add(path);
              continue;
            }
            await visitLibrary(path);
          } else if (directive is PartDirective) {
            final uriStr = directive.uri.stringValue;
            if (uriStr == null) continue;
            final partPath = p.normalize(p.join(p.dirname(normalized), uriStr));
            await visitLibrary(partPath);
          }
        }
      } else {
        unresolved.add(normalized);
      }
    }

    await visitLibrary(absoluteEntry);

    final allUnresolved = [...unresolved, ...skipped];
    final collected = _collector.collectUnitsWithPaths(pathUnits);
    // Temporary safe rule: any invoked function/value forces incomplete until
    // the bundler correctly prunes function/value keys via shim pruning.
    // Once the shim exposes functionKeys/valueKeys and _bundleForeignTargets
    // handles them, this can be removed and completeness can be purely
    // unresolved/skipped based. For now, force union with JS scan.
    final hasFunctionOrValue =
        collected.functions.isNotEmpty || collected.values.isNotEmpty;
    final baseComplete = unresolved.isEmpty && skipped.isEmpty;
    final complete = baseComplete && !hasFunctionOrValue;
    return ReactUsageResult(
      components: collected.components,
      hooks: collected.hooks,
      functions: collected.functions,
      values: collected.values,
      rawComponentKeys: collected.rawComponentKeys,
      rawHookKeys: collected.rawHookKeys,
      rawFunctionKeys: collected.rawFunctionKeys,
      rawValueKeys: collected.rawValueKeys,
      complete: complete,
      resolvedLibraries: resolvedCount,
      unresolvedLibraries: hasFunctionOrValue && baseComplete
          ? [...allUnresolved, 'function/value-invoked-force-incomplete']
          : allUnresolved,
    );
  }

  void _walk(String path, Set<String> visited, List<String> units) {
    final normalized = p.normalize(p.absolute(path));
    if (!visited.add(normalized)) return;
    final file = File(normalized);
    if (!file.existsSync()) return;
    units.add(normalized);
    final content = file.readAsStringSync();
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
///
/// Prefers resolved collection; falls back to legacy walk on failure.
Future<ReactUsageResult?> writeUsageManifest({
  required String? entryPath,
  required String target,
  required Directory dotDartToolReact,
  String? projectRoot,
}) async {
  if (entryPath == null) return null;
  final file = File(entryPath);
  if (!file.existsSync()) return null;
  final collector = DartUsageCollector();
  ReactUsageResult result;
  try {
    result = await collector.collectEntrypointResolved(
      entryPath,
      projectRoot: projectRoot,
    );
  } catch (_) {
    result = collector.collectEntrypoint(entryPath);
  }
  dotDartToolReact.createSync(recursive: true);
  final out = File(p.join(dotDartToolReact.path, '${target}_usage.json'));
  out.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(result.toJson())}\n',
  );
  return result;
}

/// Sync variant for contexts where async is unavailable.
ReactUsageResult? writeUsageManifestSync({
  required String? entryPath,
  required String target,
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
    '${const JsonEncoder.withIndent('  ').convert(result.toJson())}\n',
  );
  return result;
}
