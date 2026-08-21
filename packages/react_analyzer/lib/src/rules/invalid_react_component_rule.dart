import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:react_analysis/react_analysis.dart';

class InvalidReactComponentRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'invalid_react_component',
    'Invalid @ReactComponent signature.',
    correctionMessage:
        'Fix the component signature to match the expected shape.',
  );

  InvalidReactComponentRule()
    : super(
        name: 'invalid_react_component',
        description: 'Validates @ReactComponent signatures.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addFunctionDeclaration(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;
  _Visitor(this.rule, this.context);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    const analyzer = ReactComponentAnalyzer();
    final diagnostics = analyzer.analyzeDeclaration(node);
    if (diagnostics.isNotEmpty) {
      rule.reportAtNode(node);
    }
    // Also handle diagnostics that need specific messages via custom reporting:
    // Fall back to generic code; detailed diagnostics live in react_analysis.
  }
}
