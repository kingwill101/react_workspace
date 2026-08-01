import 'package:test/test.dart';
import 'package:react_codegen/src/server_function/codec_emitter.dart';
import 'package:react_codegen/src/server_function/server_function_model.dart';

void main() {
  group('CodecEmitter', () {
    const emitter = CodecEmitter();

    test('computeContractHash returns deterministic SHA-256', () {
      final h1 = emitter.computeContractHash('test|args|result');
      final h2 = emitter.computeContractHash('test|args|result');
      expect(h1, equals(h2));
      expect(h1.length, equals(64)); // SHA-256 hex = 64 chars
    });

    test('codecClassName formats correctly', () {
      expect(
        emitter.codecClassName('toggleTodo', 'args'),
        equals(r'_$toggleTodo_argsCodec'),
      );
      expect(
        emitter.codecClassName('listTodos', 'result'),
        equals(r'_$listTodos_resultCodec'),
      );
    });
  });

  group('emitArgsCodec', () {
    test('emits basic record codec', () {
      const model = ServerFunctionModel(
        name: 'testFunc',
        importUri: 'package:app/test.dart',
        arguments: RecordSerialization([
          FieldSerialization(
            name: 'name',
            serialization: PrimitiveSerialization('String'),
          ),
          FieldSerialization(
            name: 'count',
            serialization: PrimitiveSerialization('int'),
          ),
        ]),
        result: PrimitiveSerialization('String'),
      );

      const emitter = CodecEmitter();
      final output = emitter.emitArgsCodec(model);
      expect(output, contains('_\$testFunc_argsCodec'));
      expect(
        output,
        contains('ServerFunctionJsonCodec<({String name, int count})>'),
      );
      expect(output, contains("m['name']"));
      expect(output, contains("m['count']"));
      expect(output, contains("'name': value.name"));
      expect(output, contains("'count': value.count"));
    });
  });

  group('TypeSerialization', () {
    test('collectContractUris returns empty for primitives', () {
      final uris = collectContractUris(const PrimitiveSerialization('String'));
      expect(uris, isEmpty);
    });

    test('collectContractUris returns importUri for serverData', () {
      final uris = collectContractUris(
        const ServerDataSerialization(
          importUri: 'package:app/data.dart',
          className: 'MyData',
          fields: [],
        ),
      );
      expect(uris, contains('package:app/data.dart'));
    });
  });

  group('Syntax', () {
    test('contract canonical format is deterministic', () {
      const m1 = ServerFunctionModel(
        name: 'toggleTodo',
        importUri: 'package:app/todos.dart',
        arguments: RecordSerialization([
          FieldSerialization(
            name: 'id',
            serialization: PrimitiveSerialization('String'),
          ),
        ]),
        result: ServerDataSerialization(
          importUri: 'package:app/data.dart',
          className: 'TodoItem',
          fields: [
            FieldSerialization(
              name: 'completed',
              serialization: PrimitiveSerialization('bool'),
            ),
          ],
        ),
      );
      expect(m1.functionId, 'package:app/todos.dart#toggleTodo');
      expect(
        m1.contractCanonical,
        startsWith('package:app/todos.dart#toggleTodo|'),
      );
    });
  });
}
