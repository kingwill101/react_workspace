import 'package:react_codegen/src/aggregate.dart';
import 'package:test/test.dart';

void main() {
  group('AggregateBuilder.registrationFunctions', () {
    test('matches Actions-style registries', () {
      const content = '''
// GENERATED CODE — DO NOT EDIT

import 'package:react_server/react_server.dart';

void registerTodosActions({
  required ServerFunctionRegistry registry,
}) {
  registry.register(todoRef, (args, context) async {});
}
''';
      expect(
        AggregateBuilder.registrationFunctions(content),
        ['registerTodosActions'],
      );
    });

    test('matches library-name registries without an Actions suffix', () {
      const content = '''
// GENERATED CODE — DO NOT EDIT

import 'package:react_server/react_server.dart';

void registerGreeting({
  required ServerFunctionRegistry registry,
}) {
  registry.register(greetRef, (args, context) async {});
}
''';
      expect(
        AggregateBuilder.registrationFunctions(content),
        ['registerGreeting'],
      );
    });
  });
}
