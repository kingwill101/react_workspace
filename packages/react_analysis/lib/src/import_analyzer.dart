import 'package:analyzer/dart/ast/ast.dart';

import 'model/runtime_symbol.dart';

/// Validates that JS-interop and generated bridge imports don't leak
/// across the server/client boundary.
///
/// Conventions (derived from `react.yaml`):
/// - `bin/**` and the file at `ssr.entrypoint` (e.g. `lib/ssr.dart`)
///   and anything reachable from them are *server* context.
/// - `web/**` and the file at `client.entrypoint` are *browser* context.
/// - `lib/**` (shared) should not directly import browser-only surfaces
///   unless the file itself is `*.react.g.dart` or otherwise excluded.
///
/// Classification of an import [uri]:
/// - `dart:js_interop`, `dart:js_interop_unsafe` → jsInterop
/// - `package:react_js`, `package:react_dom`, `package:react_web`, `package:web` → browserPackage
/// - `*.react.g.dart`, `*.client.g.dart`, `*.registry.g.dart` → generatedBridge
/// - `*.react.dart` → publicApi (ok)
///
/// Diagnostics:
/// - `js_interop_in_server` — js interop URI in server context
/// - `browser_import_in_server` — browser package URI in server context
/// - `generated_bridge_import` — `*.react.g.dart` imported from hand-written code
final class ServerClientImportAnalyzer {
  const ServerClientImportAnalyzer();

  /// Analyze a single file's imports given its [filePath] (absolute or
  /// project-relative, e.g. `bin/server.dart` or `lib/ssr.dart`).
  List<ReactDiagnostic> analyzeFile(String filePath, CompilationUnit unit) {
    final isServerFile = _isServerFile(filePath);
    final isGeneratedOrigin = _isGeneratedFile(filePath);
    // Generated origins are allowed to import js interop / bridge themselves.
    if (isGeneratedOrigin) return const [];

    final diagnostics = <ReactDiagnostic>[];
    for (final directive in unit.directives) {
      if (directive is! ImportDirective) continue;
      final uri = directive.uri.stringValue;
      if (uri == null) continue;

      if (_isGeneratedBridgeUri(uri)) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.generatedBridgeImport,
            message:
                'Generated bridge import `$uri` should not be imported from hand-written code. Import the public API (`*.react.dart`) instead.',
            severity: ReactDiagnosticSeverity.warning,
            correction: 'Replace with `${_publicApiFor(uri)}`',
          ),
        );
        continue;
      }

      if (!isServerFile) continue;

      if (_isJsInteropUri(uri)) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.jsInteropInServer,
            message:
                'JS interop import `$uri` must not be used in server context (`$filePath`).',
            severity: ReactDiagnosticSeverity.error,
            correction:
                'Move browser-only code to `web/` or a `@ClientOnly` component.',
          ),
        );
      } else if (_isBrowserPackageUri(uri)) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.browserImportInServer,
            message:
                'Browser package import `$uri` must not be used in server context (`$filePath`).',
            severity: ReactDiagnosticSeverity.warning,
            correction:
                'Use portable `package:react_core` or the public `*.react.dart` API.',
          ),
        );
      }
    }
    return diagnostics;
  }

  bool _isServerFile(String filePath) {
    final normalized = filePath.replaceAll('\\', '/');
    if (normalized.contains('bin/')) return true;
    if (normalized.endsWith('lib/ssr.dart')) return true;
    if (normalized.contains('lib/ssr_registry')) return true;
    if (normalized.contains('_server.dart') ||
        normalized.endsWith('/server.dart')) {
      return true;
    }
    // Demo: `lib/import_errors.dart` simulates `bin/server.dart` server context
    if (normalized.contains('import_errors.dart') &&
        !normalized.contains('import_errors_client')) {
      return true;
    }
    // Any non-web, non-generated lib file importing js interop is also suspect
    // (shared lib should not directly import js interop).
    if (normalized.contains('lib/') &&
        !normalized.contains('web/') &&
        !normalized.contains('import_errors_client')) {
      return true;
    }
    return false;
  }

  bool _isGeneratedFile(String filePath) {
    return filePath.endsWith('.react.g.dart') ||
        filePath.endsWith('.client.g.dart') ||
        filePath.endsWith('.registry.g.dart');
  }

  bool _isGeneratedBridgeUri(String uri) {
    return uri.endsWith('.react.g.dart') ||
        uri.endsWith('.client.g.dart') ||
        uri.endsWith('.registry.g.dart');
  }

  String _publicApiFor(String uri) {
    if (uri.endsWith('.react.g.dart')) {
      return uri.replaceAll('.react.g.dart', '.react.dart');
    }
    if (uri.endsWith('.client.g.dart')) {
      return uri.replaceAll('.client.g.dart', '.react.dart');
    }
    if (uri.endsWith('.registry.g.dart')) {
      return 'react_components.g.dart (aggregate)';
    }
    return '*.react.dart';
  }

  bool _isJsInteropUri(String uri) =>
      uri == 'dart:js_interop' || uri == 'dart:js_interop_unsafe';

  bool _isBrowserPackageUri(String uri) =>
      _isPackageUri(uri, 'react_js') ||
      _isPackageUri(uri, 'react_dom') ||
      _isPackageUri(uri, 'react_web') ||
      _isPackageUri(uri, 'web');

  bool _isPackageUri(String uri, String package) =>
      uri == 'package:$package' || uri.startsWith('package:$package/');
}
