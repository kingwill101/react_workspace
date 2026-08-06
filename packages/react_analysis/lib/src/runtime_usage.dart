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

  /// Whether this result was produced from a fully resolved analysis context.
  ///
  /// Only when `complete` is true may the builder treat the semantic manifest
  /// as authoritative; otherwise it must be unioned with the compiled-JS scan.
  final bool complete;

  /// Number of libraries successfully resolved.
  final int resolvedLibraries;

  /// Libraries that could not be resolved (e.g. missing package config).
  final List<String> unresolvedLibraries;

  const ReactUsageResult({
    required this.components,
    required this.hooks,
    this.rawComponentKeys = const {},
    this.rawHookKeys = const {},
    this.complete = false,
    this.resolvedLibraries = 0,
    this.unresolvedLibraries = const [],
  });

  Map<String, Object?> toJson() => {
        'components': components,
        'hooks': hooks,
        'complete': complete,
        'resolvedLibraries': resolvedLibraries,
        'unresolvedLibraries': unresolvedLibraries,
      };

  factory ReactUsageResult.fromJson(Map<String, dynamic> json) => ReactUsageResult(
        components: List<String>.from(json['components'] as List? ?? const []),
        hooks: List<String>.from(json['hooks'] as List? ?? const []),
        complete: json['complete'] as bool? ?? false,
        resolvedLibraries: (json['resolvedLibraries'] as num?)?.toInt() ?? 0,
        unresolvedLibraries: List<String>.from(
            json['unresolvedLibraries'] as List? ?? const []),
      );

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
    // The namespace must come exclusively from generated metadata
    // (`runtimeKey` on @ReactRuntimeSymbol), not from hard-coded uri checks.
    final element = node.methodName.element;
    final hookKey = _hookRuntimeKey(element);
    if (hookKey != null) {
      hooks.add(hookKey);
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
    // First, look for @ReactRuntimeSymbol with a runtimeKey (generated hooks).
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      final enclosing = e.enclosingElement?.name;
      final isRuntimeSymbol =
          enclosing == 'ReactRuntimeSymbol' || e.displayName == 'ReactRuntimeSymbol';
      if (!isRuntimeSymbol) continue;
      final constant = ann.computeConstantValue();
      final runtimeKey = constant?.getField('runtimeKey')?.toStringValue();
      if (runtimeKey != null && runtimeKey.isNotEmpty) {
        final kind = constant?.getField('kind')?.getField('index')?.toIntValue();
        if (kind != null && kind != 1) continue;
        return runtimeKey;
      }
    }
    // Fallback: bare @ReactHook (custom hooks) — return element name.
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      final enclosing = e.enclosingElement?.name;
      final isHook = enclosing == 'ReactHook' || e.displayName == 'ReactHook';
      if (!isHook) continue;
      final name = element.displayName;
      if (name != null && name.isNotEmpty) return name;
    }
    return null;
  }
}
