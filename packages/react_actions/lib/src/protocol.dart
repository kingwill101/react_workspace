import 'exceptions.dart';

/// A JSON-serializable request envelope sent from the browser to the
/// server function endpoint.
final class ServerFunctionRequest {
  final int protocolVersion;
  final String? clientBuild;
  final String id;
  final String? contract;
  final dynamic arguments;

  const ServerFunctionRequest({
    required this.protocolVersion,
    this.clientBuild,
    required this.id,
    this.contract,
    required this.arguments,
  });

  Map<String, dynamic> toJson() => {
    'protocol': protocolVersion,
    if (clientBuild != null) 'clientBuild': clientBuild,
    'id': id,
    if (contract != null) 'contract': contract,
    'arguments': arguments,
  };
}

/// A structured error payload inside a [ServerFunctionResponse].
final class ServerFunctionError {
  final String code;
  final String message;
  final Map<String, Object?>? details;
  final String? requestId;

  const ServerFunctionError({
    required this.code,
    required this.message,
    this.details,
    this.requestId,
  });

  factory ServerFunctionError.fromJson(Map<String, dynamic> json) =>
      ServerFunctionError(
        code: json['code'] as String,
        message: json['message'] as String,
        details: json['details'] as Map<String, Object?>?,
        requestId: json['requestId'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    if (details != null) 'details': details,
    if (requestId != null) 'requestId': requestId,
  };
}

/// A JSON-serializable response envelope sent from the server back to
/// the browser.
final class ServerFunctionResponse {
  final bool ok;
  final dynamic result;
  final ServerFunctionError? error;

  const ServerFunctionResponse.ok(this.result)
      : ok = true,
        error = null;

  const ServerFunctionResponse.error(this.error)
      : ok = false,
        result = null;

  factory ServerFunctionResponse.fromJson(dynamic json) {
    final m = json as Map<String, dynamic>;
    if (m['ok'] == true) {
      return ServerFunctionResponse.ok(m['result']);
    }
    return ServerFunctionResponse.error(
      ServerFunctionError.fromJson(m['error'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => ok
      ? {'ok': true, 'result': result}
      : {'ok': false, 'error': error!.toJson()};
}

/// Converts a [ServerFunctionFailure] into a [ServerFunctionResponse].
ServerFunctionResponse failureToResponse(
  ServerFunctionFailure failure, {
  String? requestId,
}) {
  return ServerFunctionResponse.error(
    ServerFunctionError(
      code: failure.code,
      message: failure.message,
      details: failure.details,
      requestId: requestId,
    ),
  );
}
