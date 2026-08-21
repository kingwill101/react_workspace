import 'package:react_actions/react_actions.dart';
import 'package:test/test.dart';

void main() {
  group('ServerFunctionRequest', () {
    test('toJson includes required fields', () {
      const req = ServerFunctionRequest(
        protocolVersion: 1,
        id: 'myFn',
        arguments: {'value': 42},
      );
      expect(req.toJson(), {
        'protocol': 1,
        'id': 'myFn',
        'arguments': {'value': 42},
      });
    });

    test('toJson omits null contract and clientBuild', () {
      const req = ServerFunctionRequest(
        protocolVersion: 1,
        id: 'fn',
        arguments: null,
      );
      expect(req.toJson().containsKey('contract'), isFalse);
      expect(req.toJson().containsKey('clientBuild'), isFalse);
    });

    test('toJson includes contract when present', () {
      const req = ServerFunctionRequest(
        protocolVersion: 1,
        id: 'fn',
        contract: 'sha256:abc',
        arguments: {'x': 1},
      );
      expect(req.toJson()['contract'], 'sha256:abc');
    });

    test('toJson includes clientBuild when present', () {
      const req = ServerFunctionRequest(
        protocolVersion: 1,
        clientBuild: 'build-123',
        id: 'fn',
        arguments: {},
      );
      expect(req.toJson()['clientBuild'], 'build-123');
    });
  });

  group('ServerFunctionError', () {
    test('round-trips through JSON', () {
      const error = ServerFunctionError(
        code: 'not_found',
        message: 'Missing',
        details: {'id': '123'},
        requestId: 'req-1',
      );
      final json = error.toJson();
      final decoded = ServerFunctionError.fromJson(json);
      expect(decoded.code, 'not_found');
      expect(decoded.message, 'Missing');
      expect(decoded.details, {'id': '123'});
      expect(decoded.requestId, 'req-1');
    });

    test('fromJson handles missing optional fields', () {
      final error = ServerFunctionError.fromJson({
        'code': 'bad',
        'message': 'Bad request',
      });
      expect(error.details, isNull);
      expect(error.requestId, isNull);
    });

    test('toJson omits null details and requestId', () {
      const error = ServerFunctionError(code: 'x', message: 'y');
      expect(error.toJson().containsKey('details'), isFalse);
      expect(error.toJson().containsKey('requestId'), isFalse);
    });
  });

  group('ServerFunctionResponse', () {
    test('ok envelope round-trips', () {
      const resp = ServerFunctionResponse.ok({'value': 42});
      final json = resp.toJson();
      expect(json, {
        'ok': true,
        'result': {'value': 42},
      });
      final decoded = ServerFunctionResponse.fromJson(json);
      expect(decoded.ok, isTrue);
      expect(decoded.result, {'value': 42});
      expect(decoded.error, isNull);
    });

    test('error envelope round-trips', () {
      const resp = ServerFunctionResponse.error(
        ServerFunctionError(code: 'fail', message: 'Nope'),
      );
      final json = resp.toJson();
      expect(json['ok'], isFalse);
      final decoded = ServerFunctionResponse.fromJson(json);
      expect(decoded.ok, isFalse);
      expect(decoded.error!.code, 'fail');
      expect(decoded.result, isNull);
    });

    test('fromJson throws on missing ok', () {
      expect(() => ServerFunctionResponse.fromJson({}), throwsFormatException);
      expect(
        () => ServerFunctionResponse.fromJson({'ok': 'yes'}),
        throwsFormatException,
      );
    });

    test('fromJson throws on ok=true without result', () {
      expect(
        () => ServerFunctionResponse.fromJson({'ok': true}),
        throwsFormatException,
      );
    });

    test('fromJson throws on ok=false without error map', () {
      expect(
        () => ServerFunctionResponse.fromJson({'ok': false}),
        throwsFormatException,
      );
      expect(
        () => ServerFunctionResponse.fromJson({'ok': false, 'error': 'bad'}),
        throwsFormatException,
      );
    });

    test('failureToResponse converts ServerFunctionFailure', () {
      const failure = ServerFunctionFailure(
        code: 'unauthenticated',
        message: 'Login required',
        statusCode: 401,
        details: {'hint': 'token'},
      );
      final resp = failureToResponse(failure, requestId: 'req-xyz');
      expect(resp.ok, isFalse);
      expect(resp.error!.code, 'unauthenticated');
      expect(resp.error!.message, 'Login required');
      expect(resp.error!.details, {'hint': 'token'});
      expect(resp.error!.requestId, 'req-xyz');
    });

    test('constants are correct', () {
      expect(serverFunctionProtocolVersion, 1);
      expect(serverFunctionContentType, contains('application/'));
      expect(serverFunctionIdHeader, 'X-React-Action');
      expect(serverFunctionContractHeader, 'X-React-Action-Contract');
      expect(serverFunctionProtocolHeader, 'X-React-Protocol');
    });
  });

  group('ServerFunctionId', () {
    test('equality is value-based', () {
      const a = ServerFunctionId('foo');
      const b = ServerFunctionId('foo');
      const c = ServerFunctionId('bar');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toString includes value', () {
      expect(const ServerFunctionId('myId').toString(), contains('myId'));
    });
  });
}
