import 'package:example/todos/todos_contract.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:test/test.dart';

class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  dynamic encode(String value) => value;
}

class _ListArgsCodec
    extends ServerFunctionJsonCodec<({bool? completedFilter})> {
  @override
  ({bool? completedFilter}) decode(dynamic json) {
    final m = json as Map<String, dynamic>;
    return (completedFilter: m['completedFilter'] as bool?);
  }

  @override
  dynamic encode(({bool? completedFilter}) value) => {
    'completedFilter': value.completedFilter,
  };
}

class _ListResultCodec extends ServerFunctionJsonCodec<TodoListResult> {
  @override
  TodoListResult decode(dynamic json) {
    final m = json as Map<String, dynamic>;
    final items = (m['items'] as List)
        .map(
          (e) => TodoItem(
            id: e['id'] as String,
            title: e['title'] as String,
            completed: e['completed'] as bool,
          ),
        )
        .toList();
    return TodoListResult(items: items, total: m['total'] as int);
  }

  @override
  dynamic encode(TodoListResult value) => {
    'items': value.items
        .map((e) => {'id': e.id, 'title': e.title, 'completed': e.completed})
        .toList(),
    'total': value.total,
  };
}

void main() {
  group('todos server functions (ServerFunctionHarness)', () {
    test('dispatch validates codec round-trip', () async {
      final harness = ServerFunctionHarness();
      final ref = ServerFunctionRef<({bool? completedFilter}), TodoListResult>(
        id: const ServerFunctionId('demo.listTodos'),
        contractHash: 'sha256:demo-list',
        argumentsCodec: _ListArgsCodec(),
        resultCodec: _ListResultCodec(),
      );
      harness.registry.register(ref, (args, ctx) async {
        final items = [
          const TodoItem(id: '1', title: 'Demo', completed: false),
        ];
        return TodoListResult(items: items, total: 1);
      });

      final result = await harness.dispatch(ref, (completedFilter: null));
      expect(result.items, hasLength(1));
      expect(result.total, 1);
      expect(result.items.first.title, 'Demo');
    });

    test('envelope helpers build correct protocol', () {
      final h = ServerFunctionHarness();
      final ref = ServerFunctionRef<String, String>(
        id: const ServerFunctionId('demo.echo'),
        contractHash: 'sha256:echo',
        argumentsCodec: _StringCodec(),
        resultCodec: _StringCodec(),
      );
      h.registry.register(ref, (args, ctx) async => args);
      final env = h.envelope(ref, 'hi');
      expect(env['protocol'], 1);
      expect(env['id'], 'demo.echo');
      expect(env['contract'], 'sha256:echo');
      final stale = h.staleEnvelope(ref, 'hi');
      expect(stale['contract'], isNot('sha256:echo'));
    });

    test('contract mismatch is asserted via HTTP', () async {
      final harness = ServerFunctionHarness();
      final ref = ServerFunctionRef<String, String>(
        id: const ServerFunctionId('demo.fail'),
        contractHash: 'sha256:good',
        argumentsCodec: _StringCodec(),
        resultCodec: _StringCodec(),
      );
      harness.registry.register(ref, (args, ctx) => args);
      final client = harness.createClient(
        ShelfRequestHandler(createServerActionHandler(harness.registry)),
      );
      final resp = await client.postJson(
        '/__react/actions',
        harness.staleEnvelope(ref, 'x'),
      );
      resp.assertContractMismatch();
      await client.close();
    });
  });
}
