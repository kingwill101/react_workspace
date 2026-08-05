// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: digital-identities
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class DigitalCredentialRequestOptions {
  List<IdentityRequestProvider> get providers;
  set providers(List<IdentityRequestProvider> value);
}

abstract interface class IdentityRequestProvider {
  String get protocol;
  set protocol(String value);
  Object get request;
  set request(Object value);
}

