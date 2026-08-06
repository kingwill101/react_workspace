// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: credential-management
// ignore_for_file: type=lint

import 'dom.dart';
import 'webauthn.dart';
import 'fedcm.dart';
import 'html.dart';

abstract interface class Credential {
  String get id;
  String get type;
}

abstract interface class CredentialCreationOptions {
  CredentialMediationRequirement? get mediation;
  set mediation(CredentialMediationRequirement? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  PasswordCredentialInit? get password;
  set password(PasswordCredentialInit? value);
  FederatedCredentialInit? get federated;
  set federated(FederatedCredentialInit? value);
  PublicKeyCredentialCreationOptions? get publicKey;
  set publicKey(PublicKeyCredentialCreationOptions? value);
}

final class CredentialCreationOptionsValue implements CredentialCreationOptions {
  @override
  CredentialMediationRequirement? mediation;
  @override
  AbortSignal? signal;
  @override
  PasswordCredentialInit? password;
  @override
  FederatedCredentialInit? federated;
  @override
  PublicKeyCredentialCreationOptions? publicKey;

  CredentialCreationOptionsValue({
    this.mediation,
    this.signal,
    this.password,
    this.federated,
    this.publicKey,
  });
}

abstract interface class CredentialData {
  String get id;
  set id(String value);
}

final class CredentialDataValue implements CredentialData {
  @override
  String id;

  CredentialDataValue({
    required this.id,
  });
}

typedef CredentialMediationRequirement = String;

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

abstract interface class FederatedCredentialInit {
  String? get name;
  set name(String? value);
  String? get iconURL;
  set iconURL(String? value);
  String get origin;
  set origin(String value);
  String get provider;
  set provider(String value);
  String? get protocol;
  set protocol(String? value);
}

final class FederatedCredentialInitValue implements FederatedCredentialInit {
  @override
  String? name;
  @override
  String? iconURL;
  @override
  String origin;
  @override
  String provider;
  @override
  String? protocol;

  FederatedCredentialInitValue({
    this.name,
    this.iconURL,
    required this.origin,
    required this.provider,
    this.protocol,
  });
}

abstract interface class FederatedCredentialRequestOptions {
  List<String>? get providers;
  set providers(List<String>? value);
  List<String>? get protocols;
  set protocols(List<String>? value);
}

final class FederatedCredentialRequestOptionsValue implements FederatedCredentialRequestOptions {
  @override
  List<String>? providers;
  @override
  List<String>? protocols;

  FederatedCredentialRequestOptionsValue({
    this.providers,
    this.protocols,
  });
}

abstract interface class PasswordCredentialData {
  String? get name;
  set name(String? value);
  String? get iconURL;
  set iconURL(String? value);
  String get origin;
  set origin(String value);
  String get password;
  set password(String value);
}

final class PasswordCredentialDataValue implements PasswordCredentialData {
  @override
  String? name;
  @override
  String? iconURL;
  @override
  String origin;
  @override
  String password;

  PasswordCredentialDataValue({
    this.name,
    this.iconURL,
    required this.origin,
    required this.password,
  });
}

typedef PasswordCredentialInit = Object;

