// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: fedcm
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class DisconnectedAccount {
  String get account_id;
  set account_id(String value);
}

abstract interface class IdentityAssertionResponse {
  String get token;
  set token(String value);
  String get continue_on;
  set continue_on(String value);
}

abstract interface class IdentityCredential {
  String? get token;
  bool get isAutoSelected;
}

abstract interface class IdentityCredentialDisconnectOptions {
  String get accountHint;
  set accountHint(String value);
}

abstract interface class IdentityCredentialRequestOptions {
  List<IdentityProviderRequestOptions> get providers;
  set providers(List<IdentityProviderRequestOptions> value);
  IdentityCredentialRequestOptionsContext get context;
  set context(IdentityCredentialRequestOptionsContext value);
  IdentityCredentialRequestOptionsMode get mode;
  set mode(IdentityCredentialRequestOptionsMode value);
}

typedef IdentityCredentialRequestOptionsContext = String;

typedef IdentityCredentialRequestOptionsMode = String;

abstract interface class IdentityProvider {
}

abstract interface class IdentityProviderAPIConfig {
  String get accounts_endpoint;
  set accounts_endpoint(String value);
  String get client_metadata_endpoint;
  set client_metadata_endpoint(String value);
  String get id_assertion_endpoint;
  set id_assertion_endpoint(String value);
  String get login_url;
  set login_url(String value);
  String get disconnect_endpoint;
  set disconnect_endpoint(String value);
  IdentityProviderBranding get branding;
  set branding(IdentityProviderBranding value);
}

abstract interface class IdentityProviderAccount {
  String get id;
  set id(String value);
  String get name;
  set name(String value);
  String get email;
  set email(String value);
  String get given_name;
  set given_name(String value);
  String get picture;
  set picture(String value);
  List<String> get approved_clients;
  set approved_clients(List<String> value);
  List<String> get login_hints;
  set login_hints(List<String> value);
  List<String> get domain_hints;
  set domain_hints(List<String> value);
}

abstract interface class IdentityProviderAccountList {
  List<IdentityProviderAccount> get accounts;
  set accounts(List<IdentityProviderAccount> value);
}

abstract interface class IdentityProviderBranding {
  String get background_color;
  set background_color(String value);
  String get color;
  set color(String value);
  List<IdentityProviderIcon> get icons;
  set icons(List<IdentityProviderIcon> value);
  String get name;
  set name(String value);
}

abstract interface class IdentityProviderClientMetadata {
  String get privacy_policy_url;
  set privacy_policy_url(String value);
  String get terms_of_service_url;
  set terms_of_service_url(String value);
}

abstract interface class IdentityProviderConfig {
  String get configURL;
  set configURL(String value);
  String get clientId;
  set clientId(String value);
}

abstract interface class IdentityProviderIcon {
  String get url;
  set url(String value);
  int get size;
  set size(int value);
}

abstract interface class IdentityProviderRequestOptions {
  String get nonce;
  set nonce(String value);
  String get loginHint;
  set loginHint(String value);
  String get domainHint;
  set domainHint(String value);
  List<String> get fields;
  set fields(List<String> value);
  Object get params;
  set params(Object value);
}

abstract interface class IdentityProviderWellKnown {
  List<String> get provider_urls;
  set provider_urls(List<String> value);
  String get accounts_endpoint;
  set accounts_endpoint(String value);
  String get login_url;
  set login_url(String value);
}

abstract interface class IdentityResolveOptions {
  String get accountId;
  set accountId(String value);
}

abstract interface class IdentityUserInfo {
  String get email;
  set email(String value);
  String get name;
  set name(String value);
  String get givenName;
  set givenName(String value);
  String get picture;
  set picture(String value);
}

