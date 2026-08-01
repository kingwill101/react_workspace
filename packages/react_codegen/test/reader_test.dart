import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:build/build.dart';
import 'package:react_codegen/src/server_function/server_function_reader.dart';
import 'package:test/test.dart';
import 'package:source_gen/source_gen.dart';

void main() {
  test('@serverFunction annotation resolves correctly', () async {
    final checker = TypeChecker.fromUrl(
      'package:react_actions/src/annotations.dart#ServerFunctionAnnotation',
    );
    expect(checker, isNotNull, reason: 'TypeChecker should be constructable');
  });

  test(
    'todos_actions.dart has @serverFunction',
    () async {
      // Use the analyzer to resolve the todo actions file
      final result = await resolveFile(
        path: File('example/lib/todos/todos_actions.dart').absolute.path,
      );

      expect(result, isA<ResolvedUnitResult>());
      final resolved = result as ResolvedUnitResult;
      final library = resolved.libraryElement;

      final inputId = AssetId('example', 'lib/todos/todos_actions.dart');
      final reader = ServerFunctionReader();

      final models = reader.read(library, inputId);
      expect(
        models,
        isNotEmpty,
        reason: 'Should find @serverFunction annotations',
      );

      final names = models.map((m) => m.name).toList();
      print('Found functions: $names');
      expect(names, containsAll(['listTodos', 'toggleTodo', 'addTodo']));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
