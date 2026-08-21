import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:react_analysis/react_analysis.dart';
import 'package:test/test.dart';

void main() {
  const analyzer = ServerClientImportAnalyzer();

  test('does not confuse package prefixes with browser packages', () {
    final unit = parseString(
      content: "import 'package:react_web_generator/react_web_generator.dart';",
    ).unit;

    final diagnostics = analyzer.analyzeFile(
      '/workspace/packages/generator/lib/src/emitter.dart',
      unit,
    );

    expect(diagnostics, isEmpty);
  });

  test('still rejects the exact browser package in shared code', () {
    final unit = parseString(
      content: "import 'package:react_web/react_web.dart';",
    ).unit;

    final diagnostics = analyzer.analyzeFile(
      '/workspace/packages/app/lib/shared.dart',
      unit,
    );

    expect(
      diagnostics.map((diagnostic) => diagnostic.code),
      contains(ReactDiagnosticCode.browserImportInServer),
    );
  });
}
