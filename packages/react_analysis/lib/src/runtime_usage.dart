import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';


/// Semantic foreign-binding usage collector.
///
/// Unlike the current `react_tool` JS scanner (`usage_scan.dart`) which
/// regex-matches compiled `client.js`/`ssr.js`, this collector resolves
/// Dart elements:
///
/// - `foreignComponent('ns.Name', ...)` string literals → `components`
/// - Calls to functions annotated `@ReactRuntimeSymbol(kind: hook, ...)`
///   or `@ReactHook()` whose `runtimeKey` is `ns.hookName` → `hooks`
///
/// The same collector is used by:
/// - the analyzer plugin (live “what is retained and why” lens)
/// - `react_tool` (authoritative `browser_usage.json` / `ssr_usage.json`)
///
/// The two front-ends differ only in entrypoint reachability: the plugin sees
/// the current file; the tool traverses imports from `client.dart`/`ssr.dart`.
final class ReactRuntimeUsageCollector {
  const ReactRuntimeUsageCollector();

  ReactUsageResult collectUnit(CompilationUnit unit) {
    final visitor = _UsageVisitor();
    unit.visitChildren(visitor);
    return ReactUsageResult(
      components: visitor.components.toList()..sort(),
      hooks: visitor.hooks.toList()..sort(),
      rawComponentKeys: visitor.rawComponentKeys,
      rawHookKeys: visitor.rawHookKeys,
    );
  }

  /// Collect from multiple units (e.g. library + reachable imports).
  ReactUsageResult collectUnits(Iterable<CompilationUnit> units) {
    final components = <String>{};
    final hooks = <String>{};
    final rawComponents = <String, List<String>>{};
    final rawHooks = <String, List<String>>{};

    for (final unit in units) {
      final r = collectUnit(unit);
      components.addAll(r.components);
      hooks.addAll(r.hooks);
      rawComponents.addAll(r.rawComponentKeys);
      rawHooks.addAll(r.rawHookKeys);
    }
    return ReactUsageResult(
      components: components.toList()..sort(),
      hooks: hooks.toList()..sort(),
      rawComponentKeys: rawComponents,
      rawHookKeys: rawHooks,
    );
  }
}

/// Result of a usage collection pass.
final class ReactUsageResult {
  /// Sorted, deduplicated foreign component keys (e.g. `reactRouter.Route`).
  final List<String> components;

  /// Sorted, deduplicated hook keys (e.g. `reactRouter.useLocation`).
  final List<String> hooks;

  /// Where each component key was found — file path → keys (for diagnostics).
  final Map<String, List<String>> rawComponentKeys;

  /// Where each hook key was found.
  final Map<String, List<String>> rawHookKeys;

  const ReactUsageResult({
    required this.components,
    required this.hooks,
    this.rawComponentKeys = const {},
    this.rawHookKeys = const {},
  });

  Map<String, Object?> toJson() => {
        'components': components,
        'hooks': hooks,
      };

  bool get isEmpty => components.isEmpty && hooks.isEmpty;
}

final class _UsageVisitor extends RecursiveAstVisitor<void> {
  final Set<String> components = {};
  final Set<String> hooks = {};
  final Map<String, List<String>> rawComponentKeys = {};
  final Map<String, List<String>> rawHookKeys = {};

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // foreignComponent('ns.Name', ...)
    if (node.methodName.name == 'foreignComponent' ||
        node.methodName.name == 'ForeignComponent') {
      final args = node.argumentList.arguments;
      if (args.isNotEmpty && args.first is StringLiteral) {
        final key = (args.first as StringLiteral).stringValue;
        if (key != null && key.isNotEmpty) {
          components.add(key);
        }
      }
    }

    // Hook bridge calls — resolve via element annotation if available.
    final element = node.methodName.element;
    final hookKey = _hookRuntimeKey(element);
    if (hookKey != null) {
      hooks.add(hookKey);
    } else if (_isHookName(node.methodName.name)) {
      // Fallback for generated shims that use @JS('globalThis.__reactDartBindings.ns.hook')
      // — try to derive key from static element's library prefix.
      final lib = element?.library?.uri.toString() ?? '';
      final prefix = _namespaceFromLibrary(lib);
      if (prefix != null) {
        hooks.add('$prefix.${node.methodName.name}');
      }
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.constructorName.type.name.lexeme == 'ForeignComponent') {
      final args = node.argumentList.arguments;
      if (args.isNotEmpty && args.first is StringLiteral) {
        final key = (args.first as StringLiteral).stringValue;
        if (key != null) components.add(key);
      }
    }
    super.visitInstanceCreationExpression(node);
  }

  String? _hookRuntimeKey(Element? element) {
    if (element == null) return null;
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      final enclosing = e.enclosingElement?.name;
      if (enclosing == 'ReactRuntimeSymbol' || e.displayName == 'ReactRuntimeSymbol') {
        // Best-effort constant evaluation: look for runtimeKey in source.
        // Full constant evaluation requires resolved constant value; we approximate
        // via the annotation's string representation when needed.
        final source = ann.toSource();
        final match = RegExp(r"runtimeKey\s*:\s*['""]([^'""]+)['""]").firstMatch(source);
        if (match != null) return match.group(1);
      }
      if (enclosing == 'ReactHook' || e.displayName == 'ReactHook') {
        // Bare @ReactHook() — derive key from function name + library namespace.
        final lib = element.library?.uri.toString() ?? '';
        final prefix = _namespaceFromLibrary(lib);
        final name = element.displayName;
        if (prefix != null) return '$prefix.$name';
        return name;
      }
    }
    return null;
  }

  bool _isHookName(String name) => name.startsWith('use') && name.length > 3;

  String? _namespaceFromLibrary(String uri) {
    // Heuristic: packages/react_router → reactRouter, react_zustand → reactZustand, etc.
    if (uri.contains('react_router')) return 'reactRouter';
    if (uri.contains('react_zustand')) return 'reactZustand';
    if (uri.contains('react_bloc')) return 'reactBloc';
    if (uri.contains('react_riverpod')) return 'reactRiverpod';
    return null;
  }
}
