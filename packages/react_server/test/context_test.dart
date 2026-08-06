import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  group('CancellationToken', () {
    test('initially not cancelled', () {
      final token = CancellationToken();
      expect(token.isCancelled, isFalse);
    });

    test('cancel sets isCancelled', () {
      final token = CancellationToken();
      token.cancel();
      expect(token.isCancelled, isTrue);
    });

    test('cancel is idempotent', () {
      final token = CancellationToken();
      token.cancel();
      token.cancel();
      expect(token.isCancelled, isTrue);
    });
  });

  group('ServerFunctionContext', () {
    test('stores fields', () {
      final ctx = ServerFunctionContext(
        requestId: 'req-1',
        principal: 'user-42',
        headers: {'authorization': 'Bearer x'},
        requestUri: Uri.parse('/__react/actions'),
        deadline: DateTime(2030, 1, 1),
        cancellation: CancellationToken(),
      );
      expect(ctx.requestId, 'req-1');
      expect(ctx.principal, 'user-42');
      expect(ctx.headers['authorization'], 'Bearer x');
      expect(ctx.requestUri.path, '/__react/actions');
    });

    test('requireUser returns principal when authenticated', () {
      final ctx = ServerFunctionContext(
        requestId: 'req-1',
        principal: 'Ada',
        headers: const {},
        requestUri: Uri.parse('/'),
        deadline: DateTime.now(),
        cancellation: CancellationToken(),
      );
      expect(ctx.requireUser(), 'Ada');
    });

    test('requireUser throws 401 when unauthenticated', () {
      final ctx = ServerFunctionContext(
        requestId: 'req-1',
        principal: null,
        headers: const {},
        requestUri: Uri.parse('/'),
        deadline: DateTime.now(),
        cancellation: CancellationToken(),
      );
      expect(
        () => ctx.requireUser(),
        throwsA(
          isA<ServerFunctionFailure>()
              .having((e) => e.code, 'code', 'unauthenticated')
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('requireUser returns non-string principal', () {
      final ctx = ServerFunctionContext(
        requestId: 'req-1',
        principal: {'id': 123},
        headers: const {},
        requestUri: Uri.parse('/'),
        deadline: DateTime.now(),
        cancellation: CancellationToken(),
      );
      expect(ctx.requireUser(), {'id': 123});
    });
  });
}
