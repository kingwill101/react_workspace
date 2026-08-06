import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:react_analysis/react_analysis.dart';

class BrowserImportInServerRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'browser_import_in_server',
    'Browser package import must not be used in server context.',
    correctionMessage: 'Use portable package:react or the public *.react.dart API.',
  );

  BrowserImportInServerRule()
      : super(name: 'browser_import_in_server', description: 'Flags react_web/react_js in server files.');

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
    if (diags.any((d) => d.code == ReactDiagnosticCode.browserImportInServer)) {
      rule.reportAtNode(node);
    }
  }
}
