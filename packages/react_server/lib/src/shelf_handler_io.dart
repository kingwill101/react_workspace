import 'dart:async';
import 'dart:convert';

import 'package:react_actions/react_actions.dart';
import 'package:shelf/shelf.dart';

import 'context.dart';
import 'registry.dart';

/// Creates a Shelf handler for server function dispatch at
/// `/__react/actions`.
///
/// Usage:
/// ```dart
/// final registry = ServerFunctionRegistry();
/// registerMyFunctions(registry);
///
/// final handler = Router()
///   ..post('/__react/actions', createServerActionHandler(registry))
///   ..get('/<page|.*>', (req) => ...);
/// ```
FutureOr<Response> Function(Request) createServerActionHandler(
  ServerFunctionRegistry registry, {
  Object? Function(Request req) authenticate = _noopAuthenticate,
  Duration requestTimeout = const Duration(seconds: 30),
  int maxBodySize = 1024 * 1024,
}) {
  return (Request req) async {
    // POST only
    if (req.method != 'POST') {
      return Response(405);
    }

    // Content-Type check
    final contentType = req.headers['content-type'] ?? '';
    if (!contentType.startsWith('application/json')) {
      return Response(415);
    }

    // Body-size limit
    final body = await req.readAsString();
    if (body.length > maxBodySize) {
      return _errorResponse('request_too_large', 'Request too large.', 413);
    }

    // Parse JSON
    late Map<String, dynamic> payload;
    try {
      payload = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return _errorResponse('invalid_json', 'Invalid JSON.', 400);
    }

    // Protocol version
    if (payload['protocol'] != 1) {
      return _errorResponse(
        'unsupported_protocol',
        'Unsupported protocol version.',
        400,
      );
    }

    final id = payload['id'] as String?;
    if (id == null || id.isEmpty) {
      return _errorResponse('missing_id', 'Missing function ID.', 400);
    }

    final contract = payload['contract'] as String?;
    final arguments = payload['arguments'];

    // Contract hash validation
    final expectedHash = registry.contractHashFor(id);
    if (expectedHash != null && contract != null && contract != expectedHash) {
      return _errorResponse(
        'contract_mismatch',
        'The action contract has changed. Please reload the page.',
        400,
      );
    }

    final cancellation = CancellationToken();
    final context = ServerFunctionContext(
      requestId: _generateId(),
      principal: authenticate(req),
      headers: req.headers,
      requestUri: req.url,
      deadline: DateTime.now().add(requestTimeout),
      cancellation: cancellation,
    );

    try {
      final encoded = await registry
          .dispatch(id, arguments, context)
          .timeout(requestTimeout);

      return Response.ok(
        jsonEncode(ServerFunctionResponse.ok(encoded).toJson()),
        headers: {'content-type': 'application/json'},
      );
    } on TimeoutException {
      return _errorResponse('timeout', 'The action timed out.', 504);
    } on ServerFunctionFailure catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode(
          ServerFunctionResponse.error(
            ServerFunctionError(
              code: e.code,
              message: e.message,
              details: e.details,
              requestId: context.requestId,
            ),
          ).toJson(),
        ),
        headers: {'content-type': 'application/json'},
      );
    } on UnknownServerFunctionException catch (e) {
      return _errorResponse('unknown_function', 'Unknown function: ${e.id}.', 404);
    } catch (_) {
      return _errorResponse(
        'internal_error',
        'Internal server error.',
        500,
        requestId: context.requestId,
      );
    }
  };
}

Response _errorResponse(
  String code,
  String message,
  int statusCode, {
  String? requestId,
}) {
  return Response(
    statusCode,
    body: jsonEncode(
      ServerFunctionResponse.error(
        ServerFunctionError(
          code: code,
          message: message,
          requestId: requestId,
        ),
      ).toJson(),
    ),
    headers: {'content-type': 'application/json'},
  );
}

Object? _noopAuthenticate(Request req) => null;

int _idCounter = 0;
String _generateId() => 'req_${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';
