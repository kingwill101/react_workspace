// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: trust-token-api
// ignore_for_file: type=lint

typedef OperationType = String;

abstract interface class PrivateToken {
  TokenVersion get version;
  set version(TokenVersion value);
  OperationType get operation;
  set operation(OperationType value);
  RefreshPolicy? get refreshPolicy;
  set refreshPolicy(RefreshPolicy? value);
  List<String>? get issuers;
  set issuers(List<String>? value);
}

final class PrivateTokenValue implements PrivateToken {
  @override
  TokenVersion version;
  @override
  OperationType operation;
  @override
  RefreshPolicy? refreshPolicy;
  @override
  List<String>? issuers;

  PrivateTokenValue({
    required this.version,
    required this.operation,
    this.refreshPolicy,
    this.issuers,
  });
}

typedef RefreshPolicy = String;

typedef TokenVersion = String;
