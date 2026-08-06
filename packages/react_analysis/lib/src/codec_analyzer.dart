import 'package:analyzer/dart/element/type.dart';

import 'model/runtime_symbol.dart';

/// Validates that prop / callback types can cross the Dart ↔ JS bridge.
///
/// This is the shared codec check used by the analyzer plugin and the
/// generator. As the Web IDL surface expands it will cover:
/// - Promise/Future conversions
/// - dictionary arguments, typed arrays, callback arity, union lowering,
/// - host object encoding, JS function return values, Map key types.
///
/// For now it mirrors `ReactCompiler._validate` but returns diagnostics
/// instead of throwing, so the IDE can surface them live.
final class ReactCodecAnalyzer {
  const ReactCodecAnalyzer();

  /// Validate a single type that will cross the bridge.
  ReactDiagnostic? validateType(
    DartType type, {
    required String context,
  }) {
    if (type is FunctionType) {
      return _validateFunction(type, context);
    }
    if (type is RecordType) return null; // Records are bridged structurally.
    if (type is InterfaceType) {
      final name = type.element.name;
      final lib = type.element.library.uri.toString();
      final isReactWeb =
          lib.contains('react_web') || lib.contains('package:web');
      if (isReactWeb) return null; // Host types handled by HostTypeRef.

      switch (name) {
        case 'String':
        case 'int':
        case 'num':
        case 'double':
        case 'bool':
        case 'List':
        case 'Map':
        case 'Object':
        case 'dynamic':
        case 'void':
        case 'ReactNode':
          return null;
        case 'Future':
          return ReactDiagnostic(
            code: ReactDiagnosticCode.codecMissing,
            message:
                '$context: Future cannot cross the bridge directly — await it or return a concrete value.',
            severity: ReactDiagnosticSeverity.error,
          );
        default:
          // Unknown class — likely needs a codec.
          return ReactDiagnostic(
            code: ReactDiagnosticCode.codecMissing,
            message:
                '$context: $name cannot cross the React JavaScript bridge. Add a ReactCodec<$name>, mark it native-only, or remove it from the boundary.',
            severity: ReactDiagnosticSeverity.warning,
            correction: 'Create class ${name}Codec implements ReactCodec<$name> {}',
          );
      }
    }
    return null;
  }

  ReactDiagnostic? _validateFunction(FunctionType type, String context) {
    for (final p in type.formalParameters) {
      if (p.isNamed || p.isOptionalPositional) {
        return ReactDiagnostic(
          code: ReactDiagnosticCode.callbackParamCannotBeBridged,
          message:
              '$context: callback parameters must be required positional — ${type.getDisplayString()}',
          severity: ReactDiagnosticSeverity.error,
        );
      }
      final diag = validateType(p.type, context: '$context param ${p.name}');
      if (diag != null) return diag;
    }
    final rt = type.returnType;
    if (rt is InterfaceType && rt.element.name == 'Future') {
      return ReactDiagnostic(
        code: ReactDiagnosticCode.callbackParamCannotBeBridged,
        message: '$context: async callback results are not bridged yet.',
        severity: ReactDiagnosticSeverity.error,
      );
    }
    return null;
  }
}
