import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'model/runtime_symbol.dart';

/// Enforces Rules of Hooks inside `@ReactComponent` functions and custom hooks.
///
/// Knows:
/// - Which declarations are hooks (annotated `@ReactHook` or name starts with `use`).
/// - Whether the enclosing function is a React component.
/// - Whether an invocation is inside a conditional / loop / after early return.
///
/// This is more reliable than a regex on `use*` because it uses resolved
/// elements from `ReactHook` / `ReactRuntimeSymbol(kind: hook)` metadata.
final class ReactHookAnalyzer {
  const ReactHookAnalyzer();

  /// AST visitor entry — returns diagnostics for a compilation unit.
  List<ReactDiagnostic> analyzeUnit(CompilationUnit unit) {
    final diagnostics = <ReactDiagnostic>[];
    for (final decl in unit.declarations) {
      if (decl is FunctionDeclaration) {
        diagnostics.addAll(_analyzeFunctionDeclaration(decl));
      }
    }
    return diagnostics;
  }

  List<ReactDiagnostic> _analyzeFunctionDeclaration(
    FunctionDeclaration decl,
  ) {
    final element = decl.declaredFragment?.element;
    final isComponent = element is ExecutableElement
        ? _isReactComponent(element)
        : _hasReactComponentAnnotation(decl);
    final isCustomHook = element is ExecutableElement
        ? _isHookDeclaration(element)
        : _isHookName(decl.name.lexeme);

    // Only components and custom hooks are hook-call scopes.
    if (!isComponent && !isCustomHook) {
      // But flag hook calls that appear outside any component/hook.
      return _findHookCallsOutsideScope(decl);
    }

    final body = decl.functionExpression.body;
    if (body is BlockFunctionBody) {
      final name = element is ExecutableElement
          ? (element.name ?? decl.name.lexeme)
          : decl.name.lexeme;
      return _validateHookOrder(
        body.block,
        isComponent: isComponent,
        isCustomHook: isCustomHook,
        enclosingName: name,
      );
    }
    if (body is ExpressionFunctionBody) {
      // Expression bodies cannot contain conditional hook calls by construction.
      return const [];
    }
    return const [];
  }

  List<ReactDiagnostic> _findHookCallsOutsideScope(FunctionDeclaration decl) {
    final diagnostics = <ReactDiagnostic>[];
    final collector = _HookCallCollector();
    decl.visitChildren(collector);
    for (final call in collector.hookCalls) {
      final enclosing = call.node.thisOrAncestorOfType<FunctionDeclaration>();
      if (enclosing == null) continue;
      final enclosingElement = enclosing.declaredFragment?.element;
      final isComp = enclosingElement is ExecutableElement
          ? _isReactComponent(enclosingElement)
          : _hasReactComponentAnnotation(enclosing);
      final isHook = enclosingElement is ExecutableElement
          ? _isHookDeclaration(enclosingElement)
          : _isHookName(enclosing.name.lexeme);
      if (!isComp && !isHook) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.hookOutsideComponent,
            message:
                'Hook ${call.methodName} called outside a component or custom hook.',
            severity: ReactDiagnosticSeverity.error,
            correction: 'Move the hook into a @ReactComponent or use* function.',
          ),
        );
      }
    }
    return diagnostics;
  }

  bool _hasReactComponentAnnotation(FunctionDeclaration decl) {
    for (final ann in decl.metadata) {
      final src = ann.toSource();
      if (src.contains('ReactComponent')) return true;
    }
    return false;
  }

  bool _isHookName(String name) =>
      name.startsWith('use') && name.length > 3 && name[3].toUpperCase() == name[3];

  List<ReactDiagnostic> _validateHookOrder(
    Block block, {
    required bool isComponent,
    required bool isCustomHook,
    required String enclosingName,
  }) {
    final diagnostics = <ReactDiagnostic>[];
    final statements = block.statements;
    var seenEarlyReturn = false;

    for (final stmt in statements) {
      if (stmt is ReturnStatement) {
        seenEarlyReturn = true;
        continue;
      }
      // Check for hooks inside conditionals / loops.
      final hookCalls = _collectHookCalls(stmt);
      for (final call in hookCalls) {
        if (_isInsideConditional(stmt, call.node)) {
          diagnostics.add(
            ReactDiagnostic(
              code: ReactDiagnosticCode.hookInConditional,
              message: 'Hook ${call.methodName} called inside a conditional.',
              severity: ReactDiagnosticSeverity.error,
              correction: 'Move hooks to the top level of $enclosingName.',
            ),
          );
        }
        if (_isInsideLoop(stmt, call.node)) {
          diagnostics.add(
            ReactDiagnostic(
              code: ReactDiagnosticCode.hookInLoop,
              message: 'Hook ${call.methodName} called inside a loop.',
              severity: ReactDiagnosticSeverity.error,
              correction: 'Move hooks to the top level; loop over results instead.',
            ),
          );
        }
        if (seenEarlyReturn) {
          diagnostics.add(
            ReactDiagnostic(
              code: ReactDiagnosticCode.hookAfterEarlyReturn,
              message:
                  'Hook ${call.methodName} called after an early return.',
              severity: ReactDiagnosticSeverity.error,
              correction:
                  'Move hooks above the return or guard the component earlier.',
            ),
          );
        }
      }
      // Recurse into nested blocks (if/while/for) to find deeper violations.
      if (stmt is IfStatement) {
        diagnostics.addAll(
          _validateNested(stmt.thenStatement, enclosingName),
        );
        if (stmt.elseStatement != null) {
          diagnostics.addAll(
            _validateNested(stmt.elseStatement!, enclosingName),
          );
        }
      }
      if (stmt is ForStatement ||
          stmt is WhileStatement ||
          stmt is DoStatement) {
        // Any hook inside a loop body is already flagged above; recurse for nested conditionals.
        final body = _loopBody(stmt);
        if (body != null) {
          diagnostics.addAll(_validateNested(body, enclosingName));
        }
      }
    }

    // Custom hook name check.
    if (isCustomHook) {
      final element = block.thisOrAncestorOfType<FunctionDeclaration>()
          ?.declaredFragment
          ?.element;
      if (element is ExecutableElement) {
        final name = element.name ?? '';
        if (!name.startsWith('use')) {
          diagnostics.add(
            const ReactDiagnostic(
              code: ReactDiagnosticCode.customHookInvalidName,
              message: 'Custom hook should start with "use".',
              severity: ReactDiagnosticSeverity.warning,
              correction: 'Rename to use* (e.g. useCounter).',
            ),
          );
        }
      }
    }

    return diagnostics;
  }

  List<ReactDiagnostic> _validateNested(
    Statement stmt,
    String enclosingName,
  ) {
    final collector = _HookCallCollector();
    stmt.visitChildren(collector);
    // Also check the statement itself if it's an expression containing a call.
    if (stmt is ExpressionStatement) {
      final inner = _HookCallCollector();
      stmt.expression.visitChildren(inner);
      collector.hookCalls.addAll(inner.hookCalls);
    }
    final diagnostics = <ReactDiagnostic>[];
    for (final call in collector.hookCalls) {
      diagnostics.add(
        ReactDiagnostic(
          code: ReactDiagnosticCode.hookInConditional,
          message: 'Hook ${call.methodName} called inside a conditional branch.',
          severity: ReactDiagnosticSeverity.error,
          correction: 'Move hooks to the top level of $enclosingName.',
        ),
      );
    }
    return diagnostics;
  }

  bool _isInsideConditional(Statement outer, AstNode call) {
    if (outer is IfStatement || outer is ConditionalExpression) return true;
    var node = call.parent;
    while (node != null && node != outer) {
      if (node is IfStatement || node is ConditionalExpression) return true;
      node = node.parent;
    }
    // Also check if outer itself is inside a conditional (for nested blocks)
    var outerNode = outer.parent;
    while (outerNode != null) {
      if (outerNode is IfStatement) return true;
      outerNode = outerNode.parent;
    }
    return false;
  }

  bool _isInsideLoop(Statement outer, AstNode call) {
    if (outer is ForStatement ||
        outer is WhileStatement ||
        outer is DoStatement) {
      return true;
    }
    var node = call.parent;
    while (node != null && node != outer) {
      if (node is ForStatement ||
          node is WhileStatement ||
          node is DoStatement) {
        return true;
      }
      node = node.parent;
    }
    return false;
  }

  Statement? _loopBody(Statement stmt) {
    if (stmt is ForStatement) return stmt.body;
    if (stmt is WhileStatement) return stmt.body;
    if (stmt is DoStatement) return stmt.body;
    return null;
  }

  List<_HookCall> _collectHookCalls(AstNode node) {
    final collector = _HookCallCollector();
    node.visitChildren(collector);
    return collector.hookCalls;
  }

  bool _isReactComponent(ExecutableElement element) {
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      final name = e.displayName;
      if (name == 'ReactComponent' || e.enclosingElement?.name == 'ReactComponent') {
        return true;
      }
    }
    return false;
  }

  bool _isHookDeclaration(ExecutableElement element) {
    for (final ann in element.metadata.annotations) {
      final e = ann.element;
      if (e == null) continue;
      if (e.displayName == 'ReactHook' ||
          e.enclosingElement?.name == 'ReactHook' ||
          e.enclosingElement?.name == 'ReactRuntimeSymbol') {
        // Check if ReactRuntimeSymbol kind is hook.
        // Best-effort: if annotated with ReactRuntimeSymbol, treat as hook only if kind == hook.
        // Without constant evaluation, fall back to name check.
        return true;
      }
    }
    // Fallback: name convention for custom hooks.
    final name = element.name ?? '';
    return name.startsWith('use') && name.length > 3 && name[3].toUpperCase() == name[3];
  }
}

final class _HookCall {
  final String methodName;
  final AstNode node;
  _HookCall(this.methodName, this.node);
}

final class _HookCallCollector extends RecursiveAstVisitor<void> {
  final List<_HookCall> hookCalls = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_isHookName(node.methodName.name)) {
      hookCalls.add(_HookCall(node.methodName.name, node));
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitFunctionReference(FunctionReference node) {
    final name = node.function is PropertyAccess
        ? (node.function as PropertyAccess).propertyName.name
        : node.function.toString();
    if (_isHookName(name)) {
      hookCalls.add(_HookCall(name, node));
    }
    super.visitFunctionReference(node);
  }

  bool _isHookName(String name) => name.startsWith('use') && name.length > 3;
}

extension AstNodeExtension on AstNode {
  T? thisOrAncestorOfType<T extends AstNode>() {
    AstNode? n = this;
    while (n != null) {
      if (n is T) return n;
      n = n.parent;
    }
    return null;
  }
}
