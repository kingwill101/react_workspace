// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: credential-management
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'webauthn.dart';
import 'digital_credentials.dart';
import 'fedcm.dart';
import 'web_otp.dart';
import 'html.dart';

abstract interface class Credential {
  String get id;
  String get type;
}

abstract interface class CredentialCreationOptions {
  CredentialMediationRequirement get mediation;
  set mediation(CredentialMediationRequirement value);
  AbortSignal get signal;
  set signal(AbortSignal value);
  PasswordCredentialInit get password;
  set password(PasswordCredentialInit value);
  FederatedCredentialInit get federated;
  set federated(FederatedCredentialInit value);
  PublicKeyCredentialCreationOptions get publicKey;
  set publicKey(PublicKeyCredentialCreationOptions value);
}

abstract interface class CredentialData {
  String get id;
  set id(String value);
}

typedef CredentialMediationRequirement = String;

abstract interface class CredentialRequestOptions {
  CredentialMediationRequirement get mediation;
  set mediation(CredentialMediationRequirement value);
  AbortSignal get signal;
  set signal(AbortSignal value);
  bool get password;
  set password(bool value);
  FederatedCredentialRequestOptions get federated;
  set federated(FederatedCredentialRequestOptions value);
  DigitalCredentialRequestOptions get digital;
  set digital(DigitalCredentialRequestOptions value);
  IdentityCredentialRequestOptions get identity;
  set identity(IdentityCredentialRequestOptions value);
  OTPCredentialRequestOptions get otp;
  set otp(OTPCredentialRequestOptions value);
  PublicKeyCredentialRequestOptions get publicKey;
  set publicKey(PublicKeyCredentialRequestOptions value);
}

abstract interface class CredentialUserData {
  String get name;
  String get iconURL;
}

abstract interface class CredentialsContainer {
  Future<Credential?> get_([CredentialRequestOptions? options]);
  Future<void> store(Credential credential);
  Future<Credential?> create([CredentialCreationOptions? options]);
  Future<void> preventSilentAccess();
}

abstract interface class FederatedCredential {
  String get name;
  String get iconURL;
  String get provider;
  String? get protocol;
}

abstract interface class FederatedCredentialInit {
  String get name;
  set name(String value);
  String get iconURL;
  set iconURL(String value);
  String get origin;
  set origin(String value);
  String get provider;
  set provider(String value);
  String get protocol;
  set protocol(String value);
}

abstract interface class FederatedCredentialRequestOptions {
  List<String> get providers;
  set providers(List<String> value);
  List<String> get protocols;
  set protocols(List<String> value);
}

abstract interface class PasswordCredential {
  String get name;
  String get iconURL;
  String get password;
}

abstract interface class PasswordCredentialData {
  String get name;
  set name(String value);
  String get iconURL;
  set iconURL(String value);
  String get origin;
  set origin(String value);
  String get password;
  set password(String value);
}

typedef PasswordCredentialInit = Object;

