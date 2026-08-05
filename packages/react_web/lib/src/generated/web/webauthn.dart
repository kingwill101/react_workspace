// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webauthn
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'fido.dart';

typedef AttestationConveyancePreference = String;

abstract interface class AuthenticationExtensionsClientInputsJSON {
}

abstract interface class AuthenticationExtensionsClientOutputsJSON {
}

abstract interface class AuthenticationExtensionsLargeBlobInputs {
  String get support;
  set support(String value);
  bool get read;
  set read(bool value);
  BufferSource get write;
  set write(BufferSource value);
}

abstract interface class AuthenticationExtensionsLargeBlobOutputs {
  bool get supported;
  set supported(bool value);
  Object get blob;
  set blob(Object value);
  bool get written;
  set written(bool value);
}

abstract interface class AuthenticationExtensionsPRFInputs {
  AuthenticationExtensionsPRFValues get eval;
  set eval(AuthenticationExtensionsPRFValues value);
  Map<String, AuthenticationExtensionsPRFValues> get evalByCredential;
  set evalByCredential(Map<String, AuthenticationExtensionsPRFValues> value);
}

abstract interface class AuthenticationExtensionsPRFOutputs {
  bool get enabled;
  set enabled(bool value);
  AuthenticationExtensionsPRFValues get results;
  set results(AuthenticationExtensionsPRFValues value);
}

abstract interface class AuthenticationExtensionsPRFValues {
  BufferSource get first;
  set first(BufferSource value);
  BufferSource get second;
  set second(BufferSource value);
}

abstract interface class AuthenticationExtensionsSupplementalPubKeysInputs {
  List<String> get scopes;
  set scopes(List<String> value);
  String get attestation;
  set attestation(String value);
  List<String> get attestationFormats;
  set attestationFormats(List<String> value);
}

abstract interface class AuthenticationExtensionsSupplementalPubKeysOutputs {
  List<Object> get signatures;
  set signatures(List<Object> value);
}

abstract interface class AuthenticationResponseJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  Base64URLString get rawId;
  set rawId(Base64URLString value);
  AuthenticatorAssertionResponseJSON get response;
  set response(AuthenticatorAssertionResponseJSON value);
  String get authenticatorAttachment;
  set authenticatorAttachment(String value);
  AuthenticationExtensionsClientOutputsJSON get clientExtensionResults;
  set clientExtensionResults(AuthenticationExtensionsClientOutputsJSON value);
  String get type;
  set type(String value);
}

abstract interface class AuthenticatorAssertionResponse {
  Object get authenticatorData;
  Object get signature;
  Object get userHandle;
}

abstract interface class AuthenticatorAssertionResponseJSON {
  Base64URLString get clientDataJSON;
  set clientDataJSON(Base64URLString value);
  Base64URLString get authenticatorData;
  set authenticatorData(Base64URLString value);
  Base64URLString get signature;
  set signature(Base64URLString value);
  Base64URLString get userHandle;
  set userHandle(Base64URLString value);
}

typedef AuthenticatorAttachment = String;

abstract interface class AuthenticatorAttestationResponse {
  Object get attestationObject;
  List<String> getTransports();
  Object getAuthenticatorData();
  Object getPublicKey();
  COSEAlgorithmIdentifier getPublicKeyAlgorithm();
}

abstract interface class AuthenticatorAttestationResponseJSON {
  Base64URLString get clientDataJSON;
  set clientDataJSON(Base64URLString value);
  Base64URLString get authenticatorData;
  set authenticatorData(Base64URLString value);
  List<String> get transports;
  set transports(List<String> value);
  Base64URLString get publicKey;
  set publicKey(Base64URLString value);
  int get publicKeyAlgorithm;
  set publicKeyAlgorithm(int value);
  Base64URLString get attestationObject;
  set attestationObject(Base64URLString value);
}

abstract interface class AuthenticatorResponse {
  Object get clientDataJSON;
}

abstract interface class AuthenticatorSelectionCriteria {
  String get authenticatorAttachment;
  set authenticatorAttachment(String value);
  String get residentKey;
  set residentKey(String value);
  bool get requireResidentKey;
  set requireResidentKey(bool value);
  String get userVerification;
  set userVerification(String value);
}

typedef AuthenticatorTransport = String;

typedef Base64URLString = String;

typedef COSEAlgorithmIdentifier = int;

typedef ClientCapability = String;

abstract interface class CollectedClientData {
  String get type;
  set type(String value);
  String get challenge;
  set challenge(String value);
  String get origin;
  set origin(String value);
  String get topOrigin;
  set topOrigin(String value);
  bool get crossOrigin;
  set crossOrigin(bool value);
}

abstract interface class CredentialPropertiesOutput {
  bool get rk;
  set rk(bool value);
  String get authenticatorDisplayName;
  set authenticatorDisplayName(String value);
}

typedef LargeBlobSupport = String;

abstract interface class PublicKeyCredential {
  Object get rawId;
  AuthenticatorResponse get response;
  String? get authenticatorAttachment;
  AuthenticationExtensionsClientOutputs getClientExtensionResults();
}

typedef PublicKeyCredentialClientCapabilities = Map<String, bool>;

abstract interface class PublicKeyCredentialCreationOptions {
  PublicKeyCredentialRpEntity get rp;
  set rp(PublicKeyCredentialRpEntity value);
  PublicKeyCredentialUserEntity get user;
  set user(PublicKeyCredentialUserEntity value);
  BufferSource get challenge;
  set challenge(BufferSource value);
  List<PublicKeyCredentialParameters> get pubKeyCredParams;
  set pubKeyCredParams(List<PublicKeyCredentialParameters> value);
  int get timeout;
  set timeout(int value);
  List<PublicKeyCredentialDescriptor> get excludeCredentials;
  set excludeCredentials(List<PublicKeyCredentialDescriptor> value);
  AuthenticatorSelectionCriteria get authenticatorSelection;
  set authenticatorSelection(AuthenticatorSelectionCriteria value);
  List<String> get hints;
  set hints(List<String> value);
  String get attestation;
  set attestation(String value);
  List<String> get attestationFormats;
  set attestationFormats(List<String> value);
  AuthenticationExtensionsClientInputs get extensions;
  set extensions(AuthenticationExtensionsClientInputs value);
}

abstract interface class PublicKeyCredentialCreationOptionsJSON {
  PublicKeyCredentialRpEntity get rp;
  set rp(PublicKeyCredentialRpEntity value);
  PublicKeyCredentialUserEntityJSON get user;
  set user(PublicKeyCredentialUserEntityJSON value);
  Base64URLString get challenge;
  set challenge(Base64URLString value);
  List<PublicKeyCredentialParameters> get pubKeyCredParams;
  set pubKeyCredParams(List<PublicKeyCredentialParameters> value);
  int get timeout;
  set timeout(int value);
  List<PublicKeyCredentialDescriptorJSON> get excludeCredentials;
  set excludeCredentials(List<PublicKeyCredentialDescriptorJSON> value);
  AuthenticatorSelectionCriteria get authenticatorSelection;
  set authenticatorSelection(AuthenticatorSelectionCriteria value);
  List<String> get hints;
  set hints(List<String> value);
  String get attestation;
  set attestation(String value);
  List<String> get attestationFormats;
  set attestationFormats(List<String> value);
  AuthenticationExtensionsClientInputsJSON get extensions;
  set extensions(AuthenticationExtensionsClientInputsJSON value);
}

abstract interface class PublicKeyCredentialDescriptor {
  String get type;
  set type(String value);
  BufferSource get id;
  set id(BufferSource value);
  List<String> get transports;
  set transports(List<String> value);
}

abstract interface class PublicKeyCredentialDescriptorJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  String get type;
  set type(String value);
  List<String> get transports;
  set transports(List<String> value);
}

abstract interface class PublicKeyCredentialEntity {
  String get name;
  set name(String value);
}

typedef PublicKeyCredentialHints = String;

typedef PublicKeyCredentialJSON = Object;

abstract interface class PublicKeyCredentialParameters {
  String get type;
  set type(String value);
  COSEAlgorithmIdentifier get alg;
  set alg(COSEAlgorithmIdentifier value);
}

abstract interface class PublicKeyCredentialRequestOptions {
  BufferSource get challenge;
  set challenge(BufferSource value);
  int get timeout;
  set timeout(int value);
  String get rpId;
  set rpId(String value);
  List<PublicKeyCredentialDescriptor> get allowCredentials;
  set allowCredentials(List<PublicKeyCredentialDescriptor> value);
  String get userVerification;
  set userVerification(String value);
  List<String> get hints;
  set hints(List<String> value);
  AuthenticationExtensionsClientInputs get extensions;
  set extensions(AuthenticationExtensionsClientInputs value);
}

abstract interface class PublicKeyCredentialRequestOptionsJSON {
  Base64URLString get challenge;
  set challenge(Base64URLString value);
  int get timeout;
  set timeout(int value);
  String get rpId;
  set rpId(String value);
  List<PublicKeyCredentialDescriptorJSON> get allowCredentials;
  set allowCredentials(List<PublicKeyCredentialDescriptorJSON> value);
  String get userVerification;
  set userVerification(String value);
  List<String> get hints;
  set hints(List<String> value);
  AuthenticationExtensionsClientInputsJSON get extensions;
  set extensions(AuthenticationExtensionsClientInputsJSON value);
}

abstract interface class PublicKeyCredentialRpEntity {
  String get id;
  set id(String value);
}

typedef PublicKeyCredentialType = String;

abstract interface class PublicKeyCredentialUserEntity {
  BufferSource get id;
  set id(BufferSource value);
  String get displayName;
  set displayName(String value);
}

abstract interface class PublicKeyCredentialUserEntityJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  String get name;
  set name(String value);
  String get displayName;
  set displayName(String value);
}

abstract interface class RegistrationResponseJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  Base64URLString get rawId;
  set rawId(Base64URLString value);
  AuthenticatorAttestationResponseJSON get response;
  set response(AuthenticatorAttestationResponseJSON value);
  String get authenticatorAttachment;
  set authenticatorAttachment(String value);
  AuthenticationExtensionsClientOutputsJSON get clientExtensionResults;
  set clientExtensionResults(AuthenticationExtensionsClientOutputsJSON value);
  String get type;
  set type(String value);
}

typedef ResidentKeyRequirement = String;

abstract interface class TokenBinding {
  String get status;
  set status(String value);
  String get id;
  set id(String value);
}

typedef TokenBindingStatus = String;

typedef UserVerificationRequirement = String;

typedef UvmEntries = List<UvmEntry>;

typedef UvmEntry = List<int>;

