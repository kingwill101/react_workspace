import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'model/runtime_symbol.dart';

/// Validates `@ReactComponent` function signatures.
///
/// This is the shared validator consumed by both the analyzer plugin
/// (live diagnostics) and the generator (`react_codegen`). The two must not
/// diverge — keep this as the single source of truth.
///
/// Rules checked:
/// - Annotated element must be a top-level or static function.
/// - Must not be generic.
/// - Must accept exactly one record parameter with only named fields.
/// - Return type must be `ReactNode` (nullable allowed for conditional returns).
/// - Duplicate `componentId` within the library is reported.
/// - Prop types are validated for bridge support (delegates to codec check).
final class ReactComponentAnalyzer {
  const ReactComponentAnalyzer();

  /// Analyze a library's `@ReactComponent` declarations and return diagnostics.
  ///
  /// [library] is the resolved library element. [unitDiagnostics] maps
  /// compilation units to their diagnostics so call sites can attach
  /// source ranges without re-resolving.
  List<ReactDiagnostic> analyzeLibrary(
    LibraryElement library, {
    Set<String>? seenComponentIds,
  }) {
    final diagnostics = <ReactDiagnostic>[];
    seenComponentIds ??= <String>{};

    for (final element in library.topLevelFunctions) {
      if (!_hasReactComponent(element)) continue;
      diagnostics.addAll(
        _analyzeFunction(element, library, seenComponentIds),
      );
    }
    return diagnostics;
  }

  /// Analyze a single function element. Public for unit testing and for the
  /// `analysis_server_plugin` rule which visits AST nodes.
  List<ReactDiagnostic> analyzeFunction(ExecutableElement element) {
    final lib = element.library;
    return _analyzeFunction(element, lib, <String>{});
  }

  /// AST-level helper for the plugin rule — reports on a FunctionDeclaration.
  List<ReactDiagnostic> analyzeDeclaration(FunctionDeclaration node) {
    final diagnostics = <ReactDiagnostic>[];
    final element = node.declaredFragment?.element;
    if (element is! ExecutableElement) return diagnostics;
    if (!_hasReactComponent(element)) return diagnostics;
    return analyzeFunction(element);
  }

  List<ReactDiagnostic> _analyzeFunction(
    ExecutableElement element,
    LibraryElement library,
    Set<String> seenIds,
  ) {
    final diagnostics = <ReactDiagnostic>[];
    final name = element.name ?? '<anonymous>';

    // Must not be generic.
    if (element.typeParameters.isNotEmpty) {
      diagnostics.add(
        const ReactDiagnostic(
          code: ReactDiagnosticCode.componentCannotBeGeneric,
          message: '@ReactComponent function cannot be generic.',
          severity: ReactDiagnosticSeverity.error,
          correction: 'Remove type parameters from the component function.',
        ),
      );
    }

    // Must return ReactNode.
    final returnType = element.returnType;
    if (!_isReactNode(returnType)) {
      diagnostics.add(
        const ReactDiagnostic(
          code: ReactDiagnosticCode.invalidComponentReturn,
          message: '@ReactComponent function must return ReactNode.',
          severity: ReactDiagnosticSeverity.error,
          correction: 'Change return type to ReactNode (e.g. Text("...") or div()).',
        ),
      );
    }

    // Must have exactly one parameter which is a record with only named fields.
    final params = element.formalParameters;
    if (params.length != 1) {
      diagnostics.add(
        ReactDiagnostic(
          code: ReactDiagnosticCode.invalidComponentParamShape,
          message: '$name must accept exactly one record parameter.',
          severity: ReactDiagnosticSeverity.error,
          correction: 'Use a single record: ({required String name})',
        ),
      );
    } else {
      final param = params.single;
      final type = param.type;
      if (type is! RecordType) {
        diagnostics.add(
          ReactDiagnostic(
            code: ReactDiagnosticCode.invalidComponentParamShape,
            message: '$name must accept a record parameter.',
            severity: ReactDiagnosticSeverity.error,
            correction: 'Change parameter to a record, e.g. ({required String title})',
          ),
        );
      } else {
        if (type.positionalFields.isNotEmpty) {
          diagnostics.add(
            const ReactDiagnostic(
              code: ReactDiagnosticCode.invalidComponentParamShape,
              message: 'Props must use named record fields.',
              severity: ReactDiagnosticSeverity.error,
              correction: 'Use named fields: ({String? title})',
            ),
          );
        }
        // Validate each prop type for bridge support.
        for (final field in type.namedFields) {
          final propDiag = _validatePropType(name, field.name, field.type);
          if (propDiag != null) diagnostics.add(propDiag);
        }
        if (type.namedFields.any((f) => f.name == 'children')) {
          final childrenField =
              type.namedFields.firstWhere((f) => f.name == 'children');
          if (!_isValidChildrenType(childrenField.type)) {
            diagnostics.add(
              const ReactDiagnostic(
                code: ReactDiagnosticCode.childrenParamInvalidType,
                message: 'children parameter has an invalid type.',
                severity: ReactDiagnosticSeverity.error,
                correction: 'Use List<ReactNode> or ReactNode for children.',
              ),
            );
          }
        }
      }
    }

    // Duplicate component ID check (library-scoped).
    final componentId = _componentId(element);
    if (!seenIds.add(componentId)) {
      diagnostics.add(
        ReactDiagnostic(
          code: ReactDiagnosticCode.duplicateComponentId,
          message: 'Duplicate generated component ID: $componentId.',
          severity: ReactDiagnosticSeverity.error,
        ),
      );
    }

    return diagnostics;
  }

  bool _hasReactComponent(Element element) {
    for (final ann in element.metadata.annotations) {
      final annElement = ann.element;
      if (annElement == null) continue;
      final lib = annElement.library?.uri.toString() ?? '';
      final name = annElement.displayName;
      if ((name == 'ReactComponent' || name == 'reactComponent') &&
          (lib.contains('react') || lib.contains('annotations'))) {
        return true;
      }
      // Also match @ReactComponent() const instance check via element name.
      final enclosing = annElement.enclosingElement?.name;
      if (enclosing == 'ReactComponent') return true;
    }
    return false;
  }

  bool _isReactNode(DartType type) {
    final display = type.getDisplayString();
    if (display == 'ReactNode') return true;
    // Allow nullable ReactNode as well.
    if (type.getDisplayString().endsWith('?') && display.replaceAll('?', '') == 'ReactNode') {
      return true;
    }
    // Check via element name for aliased imports.
    if (type is InterfaceType && type.element.name == 'ReactNode') return true;
    return false;
  }

  bool _isValidChildrenType(DartType type) {
    final code = type.getDisplayString();
    return code == 'ReactNode' ||
        code == 'List<ReactNode>' ||
        code.startsWith('List<ReactNode') ||
        type is InterfaceType && type.element.name == 'ReactNode';
  }

  ReactDiagnostic? _validatePropType(
    String component,
    String prop,
    DartType type,
  ) {
    // Host types from react_web are allowed.
    if (type is InterfaceType) {
      final libUri = type.element.library.uri.toString();
      final isReactWeb =
          libUri.contains('react_web') || libUri.contains('package:web');
      if (isReactWeb) return null;
    }
    if (type is FunctionType) {
      // Allow callbacks but flag async ones — mirrors ReactTypeReader.
      final rt = type.returnType;
      if (rt is InterfaceType && rt.element.name == 'Future') {
        return ReactDiagnostic(
          code: ReactDiagnosticCode.callbackParamCannotBeBridged,
          message: '$component.$prop has async callback type — not bridged yet.',
          severity: ReactDiagnosticSeverity.error,
        );
      }
      return null;
    }
    if (type is RecordType) return null;
    if (type is InterfaceType &&
        (type.element.name == 'List' || type.element.name == 'Map')) {
      return null;
    }
    final allowed = {
      'String',
      'int',
      'num',
      'double',
      'bool',
      'ReactNode',
      'List',
      'Map',
      'Object',
      'dynamic',
      'void',
    };
    final base = type.getDisplayString().split('<').first.split('?').first;
    if (allowed.contains(base)) return null;
    // For now, unknown named types are flagged as potentially missing codec.
    if (type is InterfaceType) {
      return ReactDiagnostic(
        code: ReactDiagnosticCode.unsupportedPropType,
        message:
            '$component.$prop has type $base which may need a ReactCodec<$base> to cross the bridge.',
        severity: ReactDiagnosticSeverity.warning,
        correction: 'Add a ReactCodec<$base> or mark as native-only.',
      );
    }
    return null;
  }

  String _componentId(ExecutableElement element) {
    final lib = element.library.uri.toString();
    return '$lib#${element.name}';
  }
}
