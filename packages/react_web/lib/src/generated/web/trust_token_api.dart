// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: trust-token-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


typedef OperationType = String;

abstract interface class PrivateToken {
  TokenVersion get version;
  set version(TokenVersion value);
  OperationType get operation;
  set operation(OperationType value);
  RefreshPolicy get refreshPolicy;
  set refreshPolicy(RefreshPolicy value);
  List<String> get issuers;
  set issuers(List<String> value);
}

typedef RefreshPolicy = String;

typedef TokenVersion = String;

