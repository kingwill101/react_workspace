import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:build/build.dart';
import 'package:react_codegen/src/server_function/server_function_reader.dart';
import 'package:test/test.dart';

void main() {
  test('reader finds @serverFunction in its package fixture', () async {
    final todosFile = File('test/fixtures/todos_actions.dart').absolute;
    final result = await resolveFile(path: todosFile.path);

    expect(result, isA<ResolvedUnitResult>());
    final resolved = result as ResolvedUnitResult;
    final input = AssetId('react_codegen', 'test/fixtures/todos_actions.dart');
    final models = ServerFunctionReader().read(resolved.libraryElement, input);

    expect(
      models,
      isNotEmpty,
      reason: 'Should find @serverFunction annotations',
    );
    expect(
      models.map((model) => model.name),
      containsAll(['listTodos', 'toggleTodo', 'addTodo']),
    );
  }, timeout: const Timeout(Duration(seconds: 30)));
}
