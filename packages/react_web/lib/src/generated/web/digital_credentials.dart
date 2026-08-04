// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: digital-credentials
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class DigitalCredential {
  String get protocol;
  Object get data;
}

abstract interface class DigitalCredentialRequest {
  String get protocol;
  set protocol(String value);
  Object get data;
  set data(Object value);
}

abstract interface class DigitalCredentialRequestOptions {
  List<DigitalCredentialRequest> get requests;
  set requests(List<DigitalCredentialRequest> value);
}

