import 'exceptions.dart';

/// Current wire protocol version for React Dart server functions.
const int serverFunctionProtocolVersion = 1;

/// Media type for the JSON server-function envelope.
const String serverFunctionContentType =
    'application/vnd.react.dart.action+json';

/// Header carrying the generated server-function ID.
///
/// This mirrors the role of Next.js's `Next-Action` header while keeping the
/// React Dart protocol independently versioned.
const String serverFunctionIdHeader = 'X-React-Action';

/// Header carrying the generated codec contract hash.
const String serverFunctionContractHeader = 'X-React-Action-Contract';

/// Header carrying the protocol version.
const String serverFunctionProtocolHeader = 'X-React-Protocol';

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

  const ServerFunctionResponse.ok(this.result) : ok = true, error = null;

  const ServerFunctionResponse.error(this.error) : ok = false, result = null;

  factory ServerFunctionResponse.fromJson(dynamic json) {
    if (json is! Map || json['ok'] is! bool) {
      throw const FormatException('Invalid server function response envelope.');
    }
    final map = Map<String, dynamic>.from(json);
    if (map['ok'] == true) {
      if (!map.containsKey('result')) {
        throw const FormatException('Successful response is missing result.');
      }
      return ServerFunctionResponse.ok(map['result']);
    }

    final error = map['error'];
    if (error is! Map) {
      throw const FormatException('Error response is missing error details.');
    }
    return ServerFunctionResponse.error(
      ServerFunctionError.fromJson(Map<String, dynamic>.from(error)),
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
