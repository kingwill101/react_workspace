import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'package:react_codegen/src/analyzer/component_reader.dart';
import 'package:react_codegen/src/model/model.dart';
import 'package:react_codegen/src/output/public_api_emitter.dart';
import 'package:react_codegen/src/output/js_bridge_emitter.dart';

final class ReactCompileOutput {
  final String publicApi;
  final String jsBridge;

  const ReactCompileOutput({required this.publicApi, required this.jsBridge});
}

final class ReactCompiler {
  final ReactComponentReader reader;
  final PublicApiEmitter publicApiEmitter;
  final JsBridgeEmitter jsBridgeEmitter;

  const ReactCompiler({
    required this.reader,
    required this.publicApiEmitter,
    required this.jsBridgeEmitter,
  });

  ReactCompileOutput? compile(LibraryElement library, AssetId input) {
    final model = reader.read(library, input);

    if (model.isEmpty) {
      return null;
    }

    _validate(model);

    return ReactCompileOutput(
      publicApi: publicApiEmitter.emit(model),
      jsBridge: jsBridgeEmitter.emit(model),
    );
  }

  void _validate(ReactLibraryModel model) {
    for (final component in model.components) {
      for (final prop in component.props) {
        if (_unsupportedProp(prop.type)) {
          throw StateError(
            '${component.name}.${prop.name} has unsupported type ${_typeCode(prop.type)}.',
          );
        }
      }
    }
  }

  bool _unsupportedProp(ReactTypeRef type) {
    if (type is NamedTypeRef && type.symbol == 'dynamic') {
      return false;
    }

    if (type is NamedTypeRef && type.symbol == 'Object') {
      return false;
    }

    if (type is FunctionTypeRef) {
      return false;
    }

    if (type is RecordTypeRef) {
      return false;
    }

    if (type is NamedTypeRef) {
      return const <String>{
            'String',
            'int',
            'num',
            'double',
            'bool',
            'List',
            'ReactNode',
            'Map',
            'Object',
          }.contains(type.symbol) ==
          false;
    }

    return true;
  }

  String _typeCode(ReactTypeRef type) {
    if (type is NamedTypeRef) {
      final args = type.typeArguments.map(_typeCode).join(', ');
      final suffix = args.isEmpty ? '' : '<$args>';
      final nullable = type.nullable ? '?' : '';
      return '${type.symbol}$suffix$nullable';
    }

    if (type is FunctionTypeRef) {
      return 'Function';
    }

    if (type is RecordTypeRef) {
      return '({...})';
    }

    return 'dynamic';
  }
}
