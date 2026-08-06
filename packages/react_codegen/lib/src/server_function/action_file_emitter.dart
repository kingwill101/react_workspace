import 'codec_emitter.dart';
import 'server_function_model.dart';

/// Emits `*.action.g.dart` — the shared artifact with ref + codecs.
///
/// This file is compiled into both the browser JS bundle and the native
/// Dart server binary. It imports only browser-safe contract files and
/// [react_actions], NOT the server-only source file.
final class ActionFileEmitter {
  final CodecEmitter codecEmitter;

  const ActionFileEmitter({required this.codecEmitter});

  /// Emit the action file for a single model.
  String emit(ServerFunctionModel model) => emitAll([model]);

  /// Emit a combined action file for all [models] from the same source.
  String emitAll(List<ServerFunctionModel> models) {
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED CODE - DO NOT EDIT');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln();
    buffer.writeln("import 'package:react_actions/react_actions.dart';");

    // Collect all unique contract import URIs
    final allUris = <String>{};
    for (final m in models) {
      allUris.addAll(m.contractImportUris);
    }
    for (final uri in allUris) {
      final rel = _relativeImport(uri, models.first.importUri);
      if (rel.isNotEmpty) {
        buffer.writeln("import '$rel';");
      }
    }
    buffer.writeln();

    buffer.writeln(
      '// ------------------------------------------------------------------',
    );
    buffer.writeln('// Codecs');
    buffer.writeln(
      '// ------------------------------------------------------------------',
    );
    buffer.writeln();

    for (final model in models) {
      buffer.writeln(codecEmitter.emitArgsCodec(model));
      buffer.writeln();
      buffer.writeln(codecEmitter.emitResultCodec(model));
      buffer.writeln();
    }

    buffer.writeln(
      '// ------------------------------------------------------------------',
    );
    buffer.writeln('// Refs');
    buffer.writeln(
      '// ------------------------------------------------------------------',
    );
    buffer.writeln();

    for (final model in models) {
      _emitRef(buffer, model);
      buffer.writeln();
    }

    return buffer.toString();
  }

  void _emitRef(StringBuffer buffer, ServerFunctionModel model) {
    final argsClassName = codecEmitter.codecClassName(model.name, 'args');
    final resultClassName = codecEmitter.codecClassName(model.name, 'result');
    final argsType = _typeAnnotation(model.arguments);
    final resultType = _typeAnnotation(model.result);
    final contractHash = codecEmitter.computeContractHash(
      model.contractCanonical,
    );

    // NOTE: dart2js does NOT handle a multi-line break between `>` and `(`
    // when the type arguments contain record types with named fields.
    // Keep the type args and constructor start on consecutive lines.
    buffer.writeln('final ${model.name}Ref = ServerFunctionRef<');
    buffer.writeln('  $argsType, $resultType>(');
    buffer.writeln("  id: ServerFunctionId('${model.functionId}'),");
    buffer.writeln("  contractHash: '$contractHash',");
    buffer.writeln('  argumentsCodec: $argsClassName(),');
    buffer.writeln('  resultCodec: $resultClassName(),');
    buffer.writeln(');');
  }

  String _typeAnnotation(TypeSerialization type) {
    return switch (type) {
      VoidSerialization() => 'void',
      PrimitiveSerialization(dartName: var n, nullable: var q) => q ? '$n?' : n,
      ListSerialization(element: var e) => 'List<${_typeAnnotation(e)}>',
      MapSerialization(value: var v) => 'Map<String, ${_typeAnnotation(v)}>',
      DateTimeSerialization(nullable: var q) => q ? 'DateTime?' : 'DateTime',
      UriSerialization(nullable: var q) => q ? 'Uri?' : 'Uri',
      EnumSerialization(className: var c, nullable: var q) => q ? '$c?' : c,
      RecordSerialization(fields: var f) =>
        f.isEmpty
            ? '({})'
            : '({${f.map((field) => '${_typeAnnotation(field.serialization)} ${field.name}').join(', ')}})',
      ServerDataSerialization(className: var c) => c,
    };
  }

  /// Converts a `package:` URI to a relative import suitable for
  /// the generated `*.action.g.dart` file.
  ///
  /// The action file is generated alongside the source file, so we
  /// compute the relative path from the source file's directory.
  /// For example:
  ///   source: `package:app/lib/foo/todos_actions.dart`
  ///   target: `package:app/lib/foo/todos_contract.dart`
  ///   result: `todos_contract.dart`
  ///
  ///   source: `package:app/lib/foo/todos_actions.dart`
  ///   target: `package:app/lib/models/todo.dart`
  ///   result: `../models/todo.dart`
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
}
