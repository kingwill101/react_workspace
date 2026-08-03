/// Debug script to diagnose ServerDataAnnotation resolution.
///
/// Usage: dart run packages/react_codegen/bin/debug_builder.dart
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:react_codegen/src/server_function/server_function_model.dart';
import 'package:react_codegen/src/server_function/server_function_reader.dart';

Future<void> main(List<String> args) async {
  final target = args.isNotEmpty ? args[0] : 'examples/ssr/lib/todos/todos_actions.dart';
  final filePath = File(target).absolute.path;

  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
  );

  final context = collection.contextFor(filePath);
  final session = context.currentSession;

  final result = await session.getResolvedUnit(filePath) as ResolvedUnitResult;
  final library = result.libraryElement;

  // Check @serverData resolution by looking at contract file
  final contractPath = File('examples/ssr/lib/todos/todos_contract.dart').absolute.path;
  final contractResult = await session.getResolvedUnit(contractPath) as ResolvedUnitResult;
  final contractLib = contractResult.libraryElement;

  final serverDataChecker = TypeChecker.fromUrl(
    'package:react_actions/src/annotations.dart#ServerDataAnnotation',
  );

  print('ServerDataChecker: $serverDataChecker');
  print('');
  print('Contract classes:');
  for (final cls in contractLib.classes) {
    print('  ${cls.name}:');
    for (final ann in cls.metadata.annotations) {
      final ae = ann.element;
      print('    ann element: ${ae?.name} lib=${ae?.library?.identifier}');
    }
    final hasAnnotation = serverDataChecker.hasAnnotationOf(cls);
    print('    hasAnnotationOf: $hasAnnotation');
  }
  print('');

  // Use the reader
  final inputId = AssetId('example', 'lib/todos/todos_actions.dart');
  final reader = ServerFunctionReader();

  try {
    final models = reader.read(library, inputId);
    print('ServerFunctionReader found ${models.length} server functions:');
    for (final m in models) {
      print('  - ${m.name}');
      print('    contractImportUris: ${m.contractImportUris}');
      print('    result: ${m.result.runtimeType}');
      if (m.result is ServerDataSerialization) {
        final sd = m.result as ServerDataSerialization;
        print('    result className: ${sd.className}');
        print('    result importUri: ${sd.importUri}');
      }
    }
  } catch (e) {
    print('ERROR: $e');
    stderr.writeln('$e');
    exitCode = 1;
  }

  collection.dispose();
}
