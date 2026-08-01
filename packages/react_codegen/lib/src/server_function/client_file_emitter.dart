import 'server_function_model.dart';

/// Emits `*.client.g.dart` — the browser proxy for a server function.
final class ClientFileEmitter {
  const ClientFileEmitter();

  /// Emit the client file for a single model.
  String emit(ServerFunctionModel model) => emitAll([model]);

  /// Emit a combined client file for all [models] from the same source.
  String emitAll(List<ServerFunctionModel> models) {
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED CODE - DO NOT EDIT');
    buffer.writeln();
    buffer.writeln("import 'package:react_actions/react_actions.dart';");
    final first = models.first;
    buffer.writeln("import '${first.sourceFileName}.action.g.dart';");

    // Import all contract files for @serverData types
    final allUris = <String>{};
    for (final m in models) {
      allUris.addAll(m.contractImportUris);
    }
    for (final uri in allUris) {
      final rel = _relativeImport(uri, first.importUri);
      if (rel.isNotEmpty) {
        buffer.writeln("import '$rel';");
      }
    }
    buffer.writeln();

    for (final model in models) {
      _emitClientProxy(buffer, model);
      buffer.writeln();
    }

    return buffer.toString();
  }

  void _emitClientProxy(StringBuffer buffer, ServerFunctionModel model) {
    final args = model.arguments;
    final params = args.fields
        .map((f) {
          final typeStr = _paramTypeAnnotation(f.serialization);
          return 'required $typeStr ${f.name}';
        })
        .join(',\n  ');

    final argFields = args.fields.map((f) => '${f.name}: ${f.name}');
    final recordLiteral = '(${argFields.join(', ')})';
    final resultType = _paramTypeAnnotation(model.result);

    buffer.writeln('/// Invokes the server function `#${model.name}`.');
    buffer.writeln('///');
    buffer.writeln('/// Must be called from within a browser context where a');
    buffer.writeln('/// [ServerFunctionClient] has been configured via');
    buffer.writeln('/// `runWithServerFunctionClient`.');
    buffer.writeln('///');
    buffer.writeln(
      '/// Throws [RemoteServerFunctionException] on server errors,',
    );
    buffer.writeln(
      '/// [ServerFunctionTransportException] on network failures.',
    );
    buffer.writeln('Future<$resultType> ${model.name}Action({');
    buffer.writeln('  $params,');
    buffer.writeln('}) async {');
    buffer.writeln('  final client = currentServerFunctionClient;');
    buffer.writeln('  return client.invoke(');
    buffer.writeln('    ${model.name}Ref,');
    buffer.writeln('    $recordLiteral,');
    buffer.writeln('  );');
    buffer.writeln('}');
  }

  /// Converts a `package:` URI to a relative import.
  String _relativeImport(String packageUri, String sourceUri) {
    if (!packageUri.startsWith('package:') ||
        !sourceUri.startsWith('package:')) {
      return packageUri;
    }

    final target = _packagePath(packageUri);
    final source = _packagePath(sourceUri);
    if (target.package != source.package) return packageUri;

    final sourceDirectory = source.path.split('/')..removeLast();
    final targetSegments = target.path.split('/');
    final common = _commonPrefixLength(sourceDirectory, targetSegments);
    final relative = <String>[
      ...List.filled(sourceDirectory.length - common, '..'),
      ...targetSegments.skip(common),
    ];
    return relative.isEmpty ? targetSegments.last : relative.join('/');
  }

  ({String package, String path}) _packagePath(String uri) {
    final value = uri.substring('package:'.length);
    final slash = value.indexOf('/');
    if (slash == -1) return (package: value, path: '');
    return (
      package: value.substring(0, slash),
      path: value.substring(slash + 1),
    );
  }

  int _commonPrefixLength(List<String> left, List<String> right) {
    var index = 0;
    while (index < left.length &&
        index < right.length &&
        left[index] == right[index]) {
      index++;
    }
    return index;
  }

  String _paramTypeAnnotation(TypeSerialization type) {
    return switch (type) {
      VoidSerialization() => 'void',
      PrimitiveSerialization(dartName: var n, nullable: var q) => q ? '$n?' : n,
      ListSerialization(element: var e) => 'List<${_paramTypeAnnotation(e)}>',
      MapSerialization(value: var v) =>
        'Map<String, ${_paramTypeAnnotation(v)}>',
      DateTimeSerialization(nullable: var q) => q ? 'DateTime?' : 'DateTime',
      UriSerialization(nullable: var q) => q ? 'Uri?' : 'Uri',
      EnumSerialization(className: var c, nullable: var q) => q ? '$c?' : c,
      RecordSerialization(fields: var f) =>
        f.isEmpty
            ? '({})'
            : '({${f.map((field) => '${_paramTypeAnnotation(field.serialization)} ${field.name}').join(', ')}})',
      ServerDataSerialization(className: var c) => c,
    };
  }
}
