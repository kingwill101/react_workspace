import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:react_analysis/react_analysis.dart';
import 'package:test/test.dart';

void main() {
  const analyzer = ServerClientImportAnalyzer();

  test('allows portable React DOM host factories in shared and SSR code', () {
    final unit = parseString(
      content: "import 'package:react_dom/react_dom.dart';",
    ).unit;
    for (final path in [
      'lib/react/app.dart',
      'lib/ssr.dart',
      'bin/server.dart',
    ]) {
      expect(analyzer.analyzeFile(path, unit), isEmpty, reason: path);
    }
  });

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

  test('still rejects direct browser mounting implementation imports', () {
    final unit = parseString(
      content: "import 'package:react_dom/src/mount.dart';",
    ).unit;
    expect(
      analyzer.analyzeFile('lib/ssr.dart', unit).map((d) => d.code),
      contains(ReactDiagnosticCode.browserImportInServer),
    );
  });
}
