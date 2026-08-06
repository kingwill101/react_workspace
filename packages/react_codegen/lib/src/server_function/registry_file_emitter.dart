import 'server_function_model.dart';

/// Emits `*.registry.g.dart` — the server registration for a server function.
final class RegistryFileEmitter {
  const RegistryFileEmitter();

  /// Emit the registry file for a single model.
  String emit(ServerFunctionModel model) => emitAll([model]);

  /// Emit a combined registry file for all [models] from the same source.
  String emitAll(List<ServerFunctionModel> models) {
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED CODE - DO NOT EDIT');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln();
    buffer.writeln("import 'package:react_server/react_server.dart';");
    buffer.writeln();
    final first = models.first;
    buffer.writeln("import '${first.sourceFileName}.action.g.dart';");
    buffer.writeln("import '${_sourceFileName(first.importUri)}';");
    buffer.writeln();

    buffer.writeln('void register${_pascalCase(first.sourceFileName)}({');
    buffer.writeln('  required ServerFunctionRegistry registry,');
    buffer.writeln('}) {');

    for (final model in models) {
      _emitRegistration(buffer, model);
      buffer.writeln();
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  void _emitRegistration(StringBuffer buffer, ServerFunctionModel model) {
    final argsFields = model.arguments.fields;
    final argsType = _argsTypeAnnotation(model.arguments);
    const argsVar = 'args';

    buffer.writeln('  registry.register(');
    buffer.writeln('    ${model.name}Ref,');
    buffer.writeln(
      '    ($argsType $argsVar, ServerFunctionContext context) async {',
    );

    final callArgs = <String>['context'];
    for (final f in argsFields) {
      callArgs.add('${f.name}: $argsVar.${f.name}');
    }
    final callExpr = 'await ${model.name}(${callArgs.join(', ')})';

    if (model.result is VoidSerialization) {
      buffer.writeln('      $callExpr;');
      buffer.writeln('      return null;');
    } else {
      buffer.writeln('      return $callExpr;');
    }

    buffer.writeln('    },');
    buffer.writeln('  );');
  }

  String _argsTypeAnnotation(RecordSerialization record) {
    if (record.fields.isEmpty) return '({})';
    final parts = record.fields.map(
      (f) => '${_fieldTypeAnnotation(f.serialization)} ${f.name}',
    );
    return '({${parts.join(', ')}})';
  }

  String _fieldTypeAnnotation(TypeSerialization type) {
    return switch (type) {
      VoidSerialization() => 'void',
      PrimitiveSerialization(dartName: var n, nullable: var q) => q ? '$n?' : n,
      ListSerialization(element: var e) => 'List<${_fieldTypeAnnotation(e)}>',
      MapSerialization(value: var v) =>
        'Map<String, ${_fieldTypeAnnotation(v)}>',
      DateTimeSerialization(nullable: var q) => q ? 'DateTime?' : 'DateTime',
      UriSerialization(nullable: var q) => q ? 'Uri?' : 'Uri',
      EnumSerialization(className: var c, nullable: var q) => q ? '$c?' : c,
      RecordSerialization(fields: var f) =>
        f.isEmpty
            ? '({})'
            : '({${f.map((field) => '${_fieldTypeAnnotation(field.serialization)} ${field.name}').join(', ')}})',
      ServerDataSerialization(className: var c) => c,
    };
  }

  /// Extracts the file name from a `package:` URI.
  ///
  /// The registry file is generated alongside the source file,
  /// so a simple relative file name is sufficient.
  String _sourceFileName(String packageUri) {
    if (packageUri.startsWith('package:')) {
      return packageUri.split('/').last;
    }
    return packageUri.split('/').last;
  }

  String _pascalCase(String name) {
    if (name.isEmpty) return name;
    return name
        .split('_')
        .map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1);
        })
        .join('');
  }
}
