import 'dart:async';
import 'dart:convert';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';

FutureOr<Response> Function(Request) createServerActionHandler(
  ServerFunctionRegistry registry, {
  Object? Function(Request req) authenticate = _noopAuthenticate,
  Duration requestTimeout = const Duration(seconds: 30),
  int maxBodySize = 1024 * 1024,
}) {
  return (Request req) async {
    if (req.method != 'POST') return Response(405);

    final contentType = req.headers['content-type'] ?? '';
    if (!contentType.startsWith('application/json') &&
        !contentType.startsWith(serverFunctionContentType)) {
      return Response(415);
    }

    final body = await req.readAsString();
    if (utf8.encode(body).length > maxBodySize) {
      return _errorResponse('request_too_large', 'Request too large.', 413);
    }

    late Map<String, dynamic> payload;
    try {
      payload = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return _errorResponse('invalid_json', 'Invalid JSON.', 400);
    }

    final headerProtocol = req.headers[serverFunctionProtocolHeader];
    if (headerProtocol != null && headerProtocol != '${payload['protocol']}') {
      return _errorResponse(
        'protocol_mismatch',
        'The protocol header does not match the request envelope.',
        400,
      );
    }
    if (payload['protocol'] != serverFunctionProtocolVersion) {
      return _errorResponse(
        'unsupported_protocol',
        'Unsupported protocol version.',
        400,
      );
    }

    final rawId = payload['id'];
    if (rawId is! String || rawId.isEmpty) {
      return _errorResponse('missing_id', 'Missing function ID.', 400);
    }
    final id = rawId;
    final headerId = req.headers[serverFunctionIdHeader];
    if (headerId != null && headerId != id) {
      return _errorResponse(
        'id_mismatch',
        'The action header does not match the request envelope.',
        400,
      );
    }

    final rawContract = payload['contract'];
    if (rawContract != null && rawContract is! String) {
      return _errorResponse(
        'invalid_contract',
        'The function contract must be a string.',
        400,
      );
    }
    final contract = rawContract as String?;
    final headerContract = req.headers[serverFunctionContractHeader];
    if (headerContract != null && headerContract != contract) {
      return _errorResponse(
        'contract_mismatch',
        'The contract header does not match the request envelope.',
        400,
      );
    }
    if (!payload.containsKey('arguments')) {
      return _errorResponse(
        'missing_arguments',
        'Missing function arguments.',
        400,
      );
    }

    final expectedHash = registry.contractHashFor(id);
    if (expectedHash != null && contract != expectedHash) {
      return _errorResponse(
        'contract_mismatch',
        'The action contract has changed. Please reload the page.',
        400,
      );
    }

    final context = ServerFunctionContext(
      requestId: _generateId(),
      principal: authenticate(req),
      headers: req.headers,
      requestUri: req.url,
      deadline: DateTime.now().add(requestTimeout),
      cancellation: CancellationToken(),
    );

    try {
      final encoded = await registry
          .dispatch(id, payload['arguments'], context)
          .timeout(requestTimeout);
      return Response.ok(
        jsonEncode(ServerFunctionResponse.ok(encoded).toJson()),
        headers: {'content-type': serverFunctionContentType},
      );
    } on TimeoutException {
      return _errorResponse(
        'timeout',
        'The action timed out.',
        504,
        requestId: context.requestId,
      );
    } on ServerFunctionFailure catch (error) {
      return Response(
        error.statusCode,
        body: jsonEncode(
          ServerFunctionResponse.error(
            ServerFunctionError(
              code: error.code,
              message: error.message,
              details: error.details,
              requestId: context.requestId,
            ),
          ).toJson(),
        ),
        headers: {'content-type': serverFunctionContentType},
      );
    } on UnknownServerFunctionException catch (error) {
      return _errorResponse(
        'unknown_function',
        'Unknown function: ${error.id}.',
        404,
      );
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
}) => Response(
  statusCode,
  body: jsonEncode(
    ServerFunctionResponse.error(
      ServerFunctionError(code: code, message: message, requestId: requestId),
    ).toJson(),
  ),
  headers: {'content-type': serverFunctionContentType},
);

Object? _noopAuthenticate(Request req) => null;

int _idCounter = 0;
String _generateId() =>
    'req_${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';
