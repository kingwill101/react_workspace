import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:react_analysis/react_analysis.dart';

class GeneratedBridgeImportRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'generated_bridge_import',
    'Generated bridge import should not be used from hand-written code.',
    correctionMessage: 'Import the public API (*.react.dart) instead.',
  );

  GeneratedBridgeImportRule()
      : super(name: 'generated_bridge_import', description: 'Flags *.react.g.dart imports.');

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    registry.addCompilationUnit(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;
  _Visitor(this.rule, this.context);

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final path = context.definingUnit.file.path;
    const analyzer = ServerClientImportAnalyzer();
    final diags = analyzer.analyzeFile(path, node);
    if (diags.any((d) => d.code == ReactDiagnosticCode.generatedBridgeImport)) {
      rule.reportAtNode(node);
    }
  }
}
