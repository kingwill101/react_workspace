part of '../ts_bindings.dart';

/// Thrown when TypeScript extraction or binding generation fails.
final class TsBindingException implements Exception {
  /// Human-readable extraction or generation failure.
  final String message;
  const TsBindingException(this.message);

  @override
  String toString() => 'TsBindingException: $message';
}

/// A serialized TypeScript type, as produced by the native extractor.
final class TsIrType {
  /// Serialized type category produced by the native extractor.
  final String kind;

  /// Resolved declaration name when this type came from a named TS
  /// interface/alias (e.g. `FutureConfig`); null for anonymous objects.
  final String? name;

  /// Element type for array-like declarations.
  final TsIrType? element;

  /// Properties of an object or interface type.
  final List<TsIrProp>? members;

  /// Positional parameters of a function type.
  final List<TsIrProp>? params;

  /// Return type of a function declaration.
  final TsIrType? returns;

  /// Serialized values in a TypeScript literal union.
  final List<String>? literals;

  /// Tuple member types (kind == "tuple").
  final List<TsIrType>? elements;

  const TsIrType({
    required this.kind,
    this.name,
    this.element,
    this.members,
    this.params,
    this.returns,
    this.literals,
    this.elements,
  });

  factory TsIrType.fromJson(Map<String, dynamic> json) => TsIrType(
    kind: json['kind'] as String,
    name: json['name'] as String?,
    element: json['element'] == null
        ? null
        : TsIrType.fromJson(json['element'] as Map<String, dynamic>),
    members: (json['members'] as List<dynamic>?)
        ?.map((m) => TsIrProp.fromJson(m as Map<String, dynamic>))
        .toList(),
    params: (json['params'] as List<dynamic>?)
        ?.map((m) => TsIrProp.fromJson(m as Map<String, dynamic>))
        .toList(),
    returns: json['returns'] == null
        ? null
        : TsIrType.fromJson(json['returns'] as Map<String, dynamic>),
    literals: (json['literals'] as List<dynamic>?)
        ?.map((l) => l as String)
        .toList(),
    elements: (json['elements'] as List<dynamic>?)
        ?.map((e) => TsIrType.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A single property of an interface, alias, or component props type.
final class TsIrProp {
  /// TypeScript property or parameter name.
  final String name;

  /// Whether callers must provide this value.
  final bool required;

  /// Extracted TypeScript type.
  final TsIrType type;

  const TsIrProp({
    required this.name,
    required this.required,
    required this.type,
  });

  factory TsIrProp.fromJson(Map<String, dynamic> json) => TsIrProp(
    name: json['name'] as String,
    required: json['required'] as bool,
    type: TsIrType.fromJson(json['ty'] as Map<String, dynamic>),
  );
}

/// One requested exported declaration.
final class TsIrDeclaration {
  /// Exported TypeScript declaration name.
  final String name;

  /// Declaration category, such as `component`, `hook`, or `function`.
  final String kind;

  /// Component props or interface members.
  final List<TsIrProp> props;

  /// Hook formal parameters (kind == "hook").
  final List<TsIrProp> params;

  /// Hook return type (kind == "hook").
  final TsIrType? returns;

  const TsIrDeclaration({
    required this.name,
    required this.kind,
    required this.props,
    this.params = const [],
    this.returns,
  });

  factory TsIrDeclaration.fromJson(Map<String, dynamic> json) =>
      TsIrDeclaration(
        name: json['name'] as String,
        kind: json['kind'] as String,
        props: (json['props'] as List<dynamic>)
            .map((p) => TsIrProp.fromJson(p as Map<String, dynamic>))
            .toList(),
        params:
            (json['params'] as List<dynamic>?)
                ?.map((p) => TsIrProp.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
        returns: json['returns'] == null
            ? null
            : TsIrType.fromJson(json['returns'] as Map<String, dynamic>),
      );
}

/// The result of a successful extraction run.
final class TsBindingsResult {
  /// Resolved TypeScript entrypoint used by extraction.
  final String entry;

  /// Number of declaration files traversed by the extractor.
  final int files;

  /// Requested or discovered exported declarations.
  final List<TsIrDeclaration> declarations;

  /// In discovery mode: public exports that were filtered out because they
  /// are not components (e.g. `createBrowserRouter` returns `RemixRouter`).
  final List<String> skipped;

  const TsBindingsResult({
    required this.entry,
    required this.files,
    required this.declarations,
    this.skipped = const [],
  });

  factory TsBindingsResult.fromJson(Map<String, dynamic> json) =>
      TsBindingsResult(
        entry: json['entry'] as String,
        files: json['files'] as int,
        declarations: (json['declarations'] as List<dynamic>)
            .map((d) => TsIrDeclaration.fromJson(d as Map<String, dynamic>))
            .toList(),
        skipped:
            (json['skipped'] as List<dynamic>?)
                ?.map((s) => s as String)
                .toList() ??
            const [],
      );
}

/// Runs the native oxc extractor over the managed npm environment.
final class TsBindingExtractor {
  /// Directory containing the managed npm project and `node_modules`.
  final String npmRoot;

  const TsBindingExtractor(this.npmRoot);

  /// Extracts [names] exported by [specifier] and returns the parsed IR.
  ///
  /// When [all] is true, [names] is ignored and the extractor discovers the
  /// package's exported components and hooks itself, filtering out exports
  /// whose return type is not a React node.
  Future<TsBindingsResult> extract({
    required String specifier,
    required List<String> names,
    bool all = false,
  }) async {
    final request = jsonEncode({
      'specifier': specifier,
      'names': names,
      'all': all,
    });
    final requestC = request.toNativeUtf8();
    final rootC = npmRoot.toNativeUtf8();
    try {
      final ptr = tsb_extract(requestC.cast(), rootC.cast());
      if (ptr == nullptr) {
        throw const TsBindingException('native extractor returned null.');
      }
      try {
        final text = ptr.cast<Utf8>().toDartString();
        final decoded = jsonDecode(text) as Map<String, dynamic>;
        final error = decoded['error'];
        if (error != null) {
          throw TsBindingException(error as String);
        }
        return TsBindingsResult.fromJson(decoded['ok'] as Map<String, dynamic>);
      } finally {
        tsb_free_string(ptr);
      }
    } finally {
      malloc.free(requestC);
      malloc.free(rootC);
    }
  }
}
