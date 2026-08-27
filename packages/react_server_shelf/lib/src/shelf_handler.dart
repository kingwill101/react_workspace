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
    if (_isCompactContentType(contentType)) {
      return _handleCompactAction(
        req,
        registry,
        authenticate: authenticate,
        requestTimeout: requestTimeout,
        maxBodySize: maxBodySize,
      );
    }
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

    final afterResponse = ReactAfterResponse();
    final context = ServerFunctionContext(
      requestId: _generateId(),
      principal: authenticate(req),
      headers: req.headers,
      requestUri: req.url,
      deadline: DateTime.now().add(requestTimeout),
      cancellation: CancellationToken(),
      afterResponse: afterResponse,
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
    } finally {
      unawaited(Future<void>.delayed(Duration.zero, afterResponse.run));
    }
  };
}

Future<Response> _handleCompactAction(
  Request req,
  ServerFunctionRegistry registry, {
  required Object? Function(Request req) authenticate,
  required Duration requestTimeout,
  required int maxBodySize,
}) async {
  late CompactServerFunctionRequest request;
  try {
    final bytes = <int>[];
    await for (final chunk in req.read()) {
      bytes.addAll(chunk);
      if (bytes.length > maxBodySize) {
        return _compactErrorResponse(
          req,
          null,
          'request_too_large',
          'Request too large.',
          413,
        );
      }
    }
    if (bytes.length > maxBodySize) {
      return _compactErrorResponse(
        req,
        null,
        'request_too_large',
        'Request too large.',
        413,
      );
    }
    request = CompactServerFunctionRequest.decode(bytes);
  } on FormatException catch (error) {
    return _errorResponse('invalid_frame', error.message, 400);
  }

  final headerProtocol = req.headers[serverFunctionProtocolHeader];
  if (headerProtocol != null && headerProtocol != '$compactProtocolVersion') {
    return _compactErrorResponse(
      req,
      request,
      'protocol_mismatch',
      'The protocol header does not match the frame.',
      400,
    );
  }
  if (req.headers[serverFunctionIdHeader] case final headerId?
      when headerId != request.id) {
    return _compactErrorResponse(
      req,
      request,
      'id_mismatch',
      'The action header does not match the frame.',
      400,
    );
  }
  if (req.headers[serverFunctionContractHeader] case final headerContract?
      when headerContract != request.contract) {
    return _compactErrorResponse(
      req,
      request,
      'contract_mismatch',
      'The contract header does not match the frame.',
      400,
    );
  }

  final expectedHash = registry.contractHashFor(request.id);
  if (expectedHash != null && request.contract != expectedHash) {
    return _compactErrorResponse(
      req,
      request,
      'contract_mismatch',
      'The action contract has changed. Please reload the page.',
      400,
    );
  }

  final afterResponse = ReactAfterResponse();
  final context = ServerFunctionContext(
    requestId: _generateId(),
    principal: authenticate(req),
    headers: req.headers,
    requestUri: req.url,
    deadline: DateTime.now().add(requestTimeout),
    cancellation: CancellationToken(),
    afterResponse: afterResponse,
  );
  try {
    final result = await registry
        .dispatch(request.id, request.arguments, context)
        .timeout(requestTimeout);
    return _compactResponse(req, 200, request.success(result));
  } on TimeoutException {
    return _compactErrorResponse(
      req,
      request,
      'timeout',
      'The action timed out.',
      504,
      requestId: context.requestId,
    );
  } on ServerFunctionFailure catch (error) {
    return _compactResponse(
      req,
      error.statusCode,
      request.failure(
        ServerFunctionError(
          code: error.code,
          message: error.message,
          details: error.details,
          requestId: context.requestId,
        ),
      ),
    );
  } on UnknownServerFunctionException catch (error) {
    return _compactErrorResponse(
      req,
      request,
      'unknown_function',
      'Unknown function: ${error.id}.',
      404,
    );
  } catch (_) {
    return _compactErrorResponse(
      req,
      request,
      'internal_error',
      'Internal server error.',
      500,
      requestId: context.requestId,
    );
  } finally {
    unawaited(Future<void>.delayed(Duration.zero, afterResponse.run));
  }
}

Response _compactResponse(Request req, int statusCode, ReactFrame frame) =>
    Response(
      statusCode,
      body: frame.encode(),
      headers: {'content-type': compactProtocolContentType},
    );

Response _compactErrorResponse(
  Request req,
  CompactServerFunctionRequest? request,
  String code,
  String message,
  int statusCode, {
  String? requestId,
}) => request == null
    ? _errorResponse(code, message, statusCode, requestId: requestId)
    : _compactResponse(
        req,
        statusCode,
        request.failure(
          ServerFunctionError(
            code: code,
            message: message,
            requestId: requestId,
          ),
        ),
      );

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

bool _isCompactContentType(String contentType) =>
    contentType.split(';').first.trim() == compactProtocolContentType;

int _idCounter = 0;
String _generateId() =>
    'req_${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';
