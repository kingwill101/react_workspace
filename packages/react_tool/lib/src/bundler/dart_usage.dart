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
  final ReactRuntimeUsageCollector _collector = const ReactRuntimeUsageCollector();

  /// Collect usage for a single Dart file (no import walk).
  /// Returns incomplete result (complete == false) — for isolated plugin use.
  ReactUsageResult collectFile(String path) {
    final content = File(path).readAsStringSync();
    final unit = parseString(content: content, path: path).unit;
    final res = _collector.collectUnit(unit);
    return ReactUsageResult(
      components: res.components,
      hooks: res.hooks,
      rawComponentKeys: res.rawComponentKeys,
      rawHookKeys: res.rawHookKeys,
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
    final rawComp = <String, List<String>>{};
    final rawHooks = <String, List<String>>{};
    for (final r in results) {
      components.addAll(r.components);
      hooks.addAll(r.hooks);
      rawComp.addAll(r.rawComponentKeys);
      rawHooks.addAll(r.rawHookKeys);
    }
    return ReactUsageResult(
      components: components.toList()..sort(),
      hooks: hooks.toList()..sort(),
      rawComponentKeys: rawComp,
      rawHookKeys: rawHooks,
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
    final units = <CompilationUnit>[];
    var resolvedCount = 0;

    Future<void> visitLibrary(String libPath) async {
      final normalized = p.normalize(p.absolute(libPath));
      if (!visitedLibraries.add(normalized)) return;
      final result = await session.getResolvedUnit(normalized);
      if (result is ResolvedUnitResult) {
        resolvedCount++;
        units.add(result.unit);
        // Traverse imported libraries, exported libraries, and parts via
        // the resolved library element.
        final lib = result.unit.declaredElement?.library;
        if (lib != null) {
          for (final imp in lib.importedLibraries) {
            final uri = imp.source.fullName;
            if (uri.isNotEmpty) await visitLibrary(uri);
          }
          for (final exp in lib.exportedLibraries) {
            final uri = exp.source.fullName;
            if (uri.isNotEmpty) await visitLibrary(uri);
          }
          for (final part in lib.parts) {
            final uri = part.source.fullName;
            if (uri.isNotEmpty) await visitLibrary(uri);
          }
        } else {
          // Fallback: directive-based walk if element not available.
          for (final directive in result.unit.directives) {
            if (directive is ImportDirective) {
              final uriStr = directive.uri.stringValue;
              if (uriStr == null) continue;
              final imported = _resolveDirectiveUri(
                session,
                result.unit,
                directive,
                normalized,
              );
              if (imported != null) await visitLibrary(imported);
            } else if (directive is ExportDirective) {
              final uriStr = directive.uri.stringValue;
              if (uriStr == null) continue;
              final exported = _resolveDirectiveUri(
                session,
                result.unit,
                directive,
                normalized,
              );
              if (exported != null) await visitLibrary(exported);
            } else if (directive is PartDirective) {
              final uriStr = directive.uri.stringValue;
              if (uriStr == null) continue;
              final partPath = p.normalize(p.join(p.dirname(normalized), uriStr));
              await visitLibrary(partPath);
            }
          }
        }
      } else {
        unresolved.add(normalized);
      }
    }

    await visitLibrary(absoluteEntry);

    final collected = _collector.collectUnits(units);
    final complete = unresolved.isEmpty;
    return ReactUsageResult(
      components: collected.components,
      hooks: collected.hooks,
      rawComponentKeys: collected.rawComponentKeys,
      rawHookKeys: collected.rawHookKeys,
      complete: complete,
      resolvedLibraries: resolvedCount,
      unresolvedLibraries: unresolved,
    );
  }

  String? _resolveDirectiveUri(
    dynamic session,
    CompilationUnit unit,
    Directive directive,
    String parentPath,
  ) {
    // Try to resolve via element's source if available.
    LibraryElement? lib;
    if (directive is ImportDirective) {
      lib = directive.element?.importedLibrary;
    } else if (directive is ExportDirective) {
      lib = directive.element?.exportedLibrary;
    }
    if (lib != null) {
      final fullName = lib.source.fullName;
      if (fullName.isNotEmpty) return fullName;
    }
    // Fallback for package: uris — let analysis context handle them; if we
    // can't resolve, return null and let unresolved tracking handle it.
    final uriStr = (directive as dynamic).uri.stringValue as String?;
    if (uriStr == null) return null;
    if (uriStr.startsWith('dart:')) return null;
    if (uriStr.startsWith('package:')) {
      // We can't resolve package: to file path without package config;
      // rely on library element traversal above. Return null to avoid
      // double-counting via filesystem.
      return null;
    }
    return p.normalize(p.join(p.dirname(parentPath), uriStr));
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
  required String target, // 'browser' or 'ssr'
  required Directory dotDartToolReact,
}) async {
  if (entryPath == null) return null;
  final file = File(entryPath);
  if (!file.existsSync()) return null;
  final collector = DartUsageCollector();
  ReactUsageResult result;
  try {
    result = await collector.collectEntrypointResolved(entryPath);
  } catch (_) {
    result = collector.collectEntrypoint(entryPath);
  }
  dotDartToolReact.createSync(recursive: true);
  final out = File(p.join(dotDartToolReact.path, '${target}_usage.json'));
  out.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(result.toJson()) + '\n',
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
    const JsonEncoder.withIndent('  ').convert(result.toJson()) + '\n',
  );
  return result;
}
