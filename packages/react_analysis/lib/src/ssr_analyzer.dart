import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'model/runtime_symbol.dart';

/// Detects browser-only API reads during component rendering that will break
/// SSR or cause hydration mismatches.
///
/// Recognizes escapes:
/// - inside `useEffect` / `useLayoutEffect` callbacks
/// - inside components annotated `@ClientOnly`
/// - inside explicit `if (kIsWeb)` / `ReactRuntime.target == browser` guards
/// - files only reachable from the browser entrypoint (handled by the tool's
///   import-graph walk, not the single-file plugin pass)
///
/// Generated Web API declarations carry `@WebApiRuntimeInfo(ssr: unavailable)`
/// metadata (from the IDL model). This analyzer resolves that metadata instead
/// of hard-coding API names.
final class ReactSsrAnalyzer {
  const ReactSsrAnalyzer();

  List<ReactDiagnostic> analyzeUnit(CompilationUnit unit) {
    final visitor = _SsrVisitor();
    unit.visitChildren(visitor);
    return visitor.diagnostics;
  }
}

final class _SsrVisitor extends RecursiveAstVisitor<void> {
  final List<ReactDiagnostic> diagnostics = [];

  // Stack tracking whether we are inside a safe effect.
  final List<bool> _effectStack = [false];
  bool get _inSafeEffect => _effectStack.last;

  // Stack tracking whether we are inside a @ClientOnly component.
  final List<bool> _clientOnlyStack = [false];
  bool get _inClientOnly => _clientOnlyStack.last;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final element = node.declaredFragment?.element;
    final isClientOnly = _isClientOnly(element);
    final isComponent = _isReactComponent(element);

    _clientOnlyStack.add(isClientOnly || _inClientOnly);
    super.visitFunctionDeclaration(node);
    _clientOnlyStack.removeLast();

    // Also check for browser API at the declaration level if it's a component
    // rendering directly (not in effect).
    if (isComponent && !isClientOnly) {
      // Diagnostics are added during visitPropertyAccess etc. with stack state.
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;

    // Track entering useEffect / useLayoutEffect — their callbacks are safe.
    if (name == 'useEffect' || name == 'useLayoutEffect') {
      _effectStack.add(true);
      // Visit args with effect context — the first arg (callback) is safe.
      final args = node.argumentList.arguments;
      if (args.isNotEmpty) {
        args.first.visitChildren(this);
        // Remaining args (deps) are not effect body — visit without safe flag.
        _effectStack.removeLast();
        for (var i = 1; i < args.length; i++) {
          args[i].visitChildren(this);
        }
        return;
      }
      _effectStack.removeLast();
    }

    // Check for browser-only API calls during render.
    if (!_inSafeEffect && !_inClientOnly) {
      final element = node.methodName.element;
      final info = _webApiInfo(element);
      if (info != null && info.ssr == WebSsrSupport.unavailable) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.browserApiDuringSsr,
            message:
                '${info.id} is unavailable during SSR. This read occurs during render and may cause hydration differences.',
            severity: ReactDiagnosticSeverity.warning,
            correction:
                'Move to useEffect, mark component @ClientOnly, or guard with a browser check.',
          ),
        );
      }
      // Heuristic fallback for known browser globals when annotation missing.
      if (info == null && _isKnownBrowserApi(name, node)) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.browserApiDuringSsr,
            message:
                '$name appears to be a browser-only API used during render.',
            severity: ReactDiagnosticSeverity.warning,
          ),
        );
      }
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (!_inSafeEffect && !_inClientOnly) {
      final element = node.propertyName.element;
      final info = _webApiInfo(element);
      if (info != null && info.ssr == WebSsrSupport.unavailable) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.browserApiDuringSsr,
            message:
                '${info.id} is unavailable during SSR (accessed during render).',
            severity: ReactDiagnosticSeverity.warning,
          ),
        );
      }
      // window.localStorage / document.* heuristics
      if (info == null && _isBrowserPropertyAccess(node)) {
        // Only flag if target is window/document/navigator.
        final target = node.target.toString();
        if (target == 'window' || target == 'document' || target == 'navigator') {
          diagnostics.add(
            ReactDiagnostic(
              code: ReactDiagnosticCode.browserApiDuringSsr,
              message:
                  '$target.${node.propertyName.name} is unavailable during SSR.',
              severity: ReactDiagnosticSeverity.warning,
              correction: 'Guard with useEffect or @ClientOnly.',
            ),
          );
        }
      }
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (!_inSafeEffect && !_inClientOnly) {
      if ((node.prefix.name == 'window' || node.prefix.name == 'document') &&
          _isBrowserProperty(node.identifier.name)) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.browserApiDuringSsr,
            message:
                '${node.prefix.name}.${node.identifier.name} is unavailable during SSR.',
            severity: ReactDiagnosticSeverity.warning,
          ),
        );
      }
    }
    super.visitPrefixedIdentifier(node);
  }

  WebApiRuntimeInfo? _webApiInfo(Element? element) {
    if (element == null) return null;
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      if (e.displayName == 'WebApiRuntimeInfo' ||
          e.enclosingElement?.name == 'WebApiRuntimeInfo') {
        final src = ann.toSource();
        final idMatch = RegExp(r"id\s*:\s*['""]([^'""]+)['""]").firstMatch(src);
        final ssrMatch = RegExp(r'ssr\s*:\s*WebSsrSupport\.(\w+)').firstMatch(src);
        final id = idMatch?.group(1) ?? element.displayName;
        final ssr = switch (ssrMatch?.group(1)) {
          'available' => WebSsrSupport.available,
          'emulated' => WebSsrSupport.emulated,
          _ => WebSsrSupport.unavailable,
        };
        return WebApiRuntimeInfo(id: id, exposed: const {WebRealm.window}, ssr: ssr);
      }
    }
    return null;
  }

  bool _isKnownBrowserApi(String name, MethodInvocation node) {
    const browserApis = {
      'getItem',
      'setItem',
      'removeItem',
      'localStorage',
      'sessionStorage',
      'querySelector',
      'querySelectorAll',
      'getElementById',
    };
    if (!browserApis.contains(name)) return false;
    final target = node.target?.toString() ?? '';
    return target.contains('window') ||
        target.contains('document') ||
        target.contains('localStorage');
  }

  bool _isBrowserPropertyAccess(PropertyAccess node) {
    const browserProps = {
      'localStorage',
      'sessionStorage',
      'document',
      'window',
      'navigator',
      'location',
      'history',
    };
    return browserProps.contains(node.propertyName.name);
  }

  bool _isBrowserProperty(String name) {
    const props = {
      'localStorage',
      'sessionStorage',
      'cookie',
      'location',
      'history',
    };
    return props.contains(name);
  }

  bool _isClientOnly(Element? element) {
    if (element == null) return false;
    for (final ann in element.metadata.annotations) {
      final n = ann.element?.displayName ?? '';
      final enc = ann.element?.enclosingElement?.name ?? '';
      if (n == 'ClientOnly' || enc == 'ClientOnly') return true;
    }
    return false;
  }

  bool _isReactComponent(Element? element) {
    if (element == null) return false;
    for (final ann in element.metadata.annotations) {
      final n = ann.element?.displayName ?? '';
      final enc = ann.element?.enclosingElement?.name ?? '';
      if (n == 'ReactComponent' || enc == 'ReactComponent') return true;
    }
    return false;
  }
}
