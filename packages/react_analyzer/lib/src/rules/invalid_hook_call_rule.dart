import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:react_analysis/react_analysis.dart';

class InvalidHookCallRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'invalid_hook_call',
    'Invalid React hook call.',
    correctionMessage: 'Move hooks to the top level of the component.',
  );

  InvalidHookCallRule()
    : super(name: 'invalid_hook_call', description: 'Enforces Rules of Hooks.');

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addCompilationUnit(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;
  _Visitor(this.rule, this.context);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    const analyzer = ReactHookAnalyzer();
    final diagnostics = analyzer.analyzeUnit(node);
    for (final diagnostic in diagnostics) {
      final target = diagnostic.node ?? node;
      rule.reportAtNode(target);
    }
  }
}
