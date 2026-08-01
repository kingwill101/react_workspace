/// Standalone script to generate server function action/client/registry files.
///
/// Usage: dart run packages/react_codegen/bin/generate_actions.dart
///
/// This manually generates the output files for the example's todo actions,
/// useful for testing before the builder integration is complete.
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:build/build.dart';
import 'package:react_codegen/src/server_function/codec_emitter.dart';
import 'package:react_codegen/src/server_function/action_file_emitter.dart';
import 'package:react_codegen/src/server_function/client_file_emitter.dart';
import 'package:react_codegen/src/server_function/registry_file_emitter.dart';
import 'package:react_codegen/src/server_function/server_function_reader.dart';

Future<void> main(List<String> args) async {
  final target = args.isNotEmpty
      ? args[0]
      : 'example/lib/todos/todos_actions.dart';

  // Resolve the file using the analyzer
  final file = File(target);
  if (!file.existsSync()) {
    stderr.writeln('File not found: $target');
    exitCode = 1;
    return;
  }

  print('Resolving $target...');
  final result = await resolveFile(path: file.absolute.path);

  if (result is ResolvedUnitResult) {
    final library = result.libraryElement;
    final inputId = AssetId('example', 'lib/todos/todos_actions.dart');

    print('Library: ${library.identifier}');

    final reader = ServerFunctionReader();
    final models = reader.read(library, inputId);

    if (models.isEmpty) {
      print('No @serverFunction annotations found in $target');
      return;
    }

    const codecEmitter = CodecEmitter();
    const actionEmitter = ActionFileEmitter(codecEmitter: codecEmitter);
    const clientEmitter = ClientFileEmitter();
    const registryEmitter = RegistryFileEmitter();

    for (final model in models) {
      print('Generating: ${model.name}');
      print(
        '  Contract hash: ${codecEmitter.computeContractHash(model.contractCanonical)}',
      );
      print('  Contract URIs: ${model.contractImportUris}');
    }

    // A source library can contain multiple server functions. Write each
    // generated artifact once so earlier functions are not overwritten by the
    // last model in the loop.
    final actionFile = target.replaceAll('.dart', '.action.g.dart');
    File(actionFile).writeAsStringSync(actionEmitter.emitAll(models));
    print('  Wrote: $actionFile');

    final clientFile = target.replaceAll('.dart', '.client.g.dart');
    File(clientFile).writeAsStringSync(clientEmitter.emitAll(models));
    print('  Wrote: $clientFile');

    final registryFile = target.replaceAll('.dart', '.registry.g.dart');
    File(registryFile).writeAsStringSync(registryEmitter.emitAll(models));
    print('  Wrote: $registryFile');
  } else {
    stderr.writeln('Unexpected result type: ${result.runtimeType}');
    exitCode = 1;
  }
}
