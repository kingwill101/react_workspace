// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webauthn
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'fido.dart';

typedef AttestationConveyancePreference = String;

abstract interface class AuthenticationExtensionsClientInputsJSON {
}

final class AuthenticationExtensionsClientInputsJSONValue implements AuthenticationExtensionsClientInputsJSON {

  AuthenticationExtensionsClientInputsJSONValue();
}

abstract interface class AuthenticationExtensionsClientOutputsJSON {
}

final class AuthenticationExtensionsClientOutputsJSONValue implements AuthenticationExtensionsClientOutputsJSON {

  AuthenticationExtensionsClientOutputsJSONValue();
}

abstract interface class AuthenticationExtensionsLargeBlobInputs {
  String? get support;
  set support(String? value);
  bool? get read;
  set read(bool? value);
  BufferSource? get write;
  set write(BufferSource? value);
}

final class AuthenticationExtensionsLargeBlobInputsValue implements AuthenticationExtensionsLargeBlobInputs {
  @override
  String? support;
  @override
  bool? read;
  @override
  BufferSource? write;

  AuthenticationExtensionsLargeBlobInputsValue({
    this.support,
    this.read,
    this.write,
  });
}

abstract interface class AuthenticationExtensionsLargeBlobOutputs {
  bool? get supported;
  set supported(bool? value);
  Object? get blob;
  set blob(Object? value);
  bool? get written;
  set written(bool? value);
}

final class AuthenticationExtensionsLargeBlobOutputsValue implements AuthenticationExtensionsLargeBlobOutputs {
  @override
  bool? supported;
  @override
  Object? blob;
  @override
  bool? written;

  AuthenticationExtensionsLargeBlobOutputsValue({
    this.supported,
    this.blob,
    this.written,
  });
}

abstract interface class AuthenticationExtensionsPRFInputs {
  AuthenticationExtensionsPRFValues? get eval;
  set eval(AuthenticationExtensionsPRFValues? value);
  Map<String, AuthenticationExtensionsPRFValues>? get evalByCredential;
  set evalByCredential(Map<String, AuthenticationExtensionsPRFValues>? value);
}

final class AuthenticationExtensionsPRFInputsValue implements AuthenticationExtensionsPRFInputs {
  @override
  AuthenticationExtensionsPRFValues? eval;
  @override
  Map<String, AuthenticationExtensionsPRFValues>? evalByCredential;

  AuthenticationExtensionsPRFInputsValue({
    this.eval,
    this.evalByCredential,
  });
}

abstract interface class AuthenticationExtensionsPRFOutputs {
  bool? get enabled;
  set enabled(bool? value);
  AuthenticationExtensionsPRFValues? get results;
  set results(AuthenticationExtensionsPRFValues? value);
}

final class AuthenticationExtensionsPRFOutputsValue implements AuthenticationExtensionsPRFOutputs {
  @override
  bool? enabled;
  @override
  AuthenticationExtensionsPRFValues? results;

  AuthenticationExtensionsPRFOutputsValue({
    this.enabled,
    this.results,
  });
}

abstract interface class AuthenticationExtensionsPRFValues {
  BufferSource get first;
  set first(BufferSource value);
  BufferSource? get second;
  set second(BufferSource? value);
}

final class AuthenticationExtensionsPRFValuesValue implements AuthenticationExtensionsPRFValues {
  @override
  BufferSource first;
  @override
  BufferSource? second;

  AuthenticationExtensionsPRFValuesValue({
    required this.first,
    this.second,
  });
}

abstract interface class AuthenticationExtensionsSupplementalPubKeysInputs {
  List<String> get scopes;
  set scopes(List<String> value);
  String? get attestation;
  set attestation(String? value);
  List<String>? get attestationFormats;
  set attestationFormats(List<String>? value);
}

final class AuthenticationExtensionsSupplementalPubKeysInputsValue implements AuthenticationExtensionsSupplementalPubKeysInputs {
  @override
  List<String> scopes;
  @override
  String? attestation;
  @override
  List<String>? attestationFormats;

  AuthenticationExtensionsSupplementalPubKeysInputsValue({
    required this.scopes,
    this.attestation,
    this.attestationFormats,
  });
}

abstract interface class AuthenticationExtensionsSupplementalPubKeysOutputs {
  List<Object> get signatures;
  set signatures(List<Object> value);
}

final class AuthenticationExtensionsSupplementalPubKeysOutputsValue implements AuthenticationExtensionsSupplementalPubKeysOutputs {
  @override
  List<Object> signatures;

  AuthenticationExtensionsSupplementalPubKeysOutputsValue({
    required this.signatures,
  });
}

abstract interface class AuthenticationResponseJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  Base64URLString get rawId;
  set rawId(Base64URLString value);
  AuthenticatorAssertionResponseJSON get response;
  set response(AuthenticatorAssertionResponseJSON value);
  String? get authenticatorAttachment;
  set authenticatorAttachment(String? value);
  AuthenticationExtensionsClientOutputsJSON get clientExtensionResults;
  set clientExtensionResults(AuthenticationExtensionsClientOutputsJSON value);
  String get type;
  set type(String value);
}

final class AuthenticationResponseJSONValue implements AuthenticationResponseJSON {
  @override
  Base64URLString id;
  @override
  Base64URLString rawId;
  @override
  AuthenticatorAssertionResponseJSON response;
  @override
  String? authenticatorAttachment;
  @override
  AuthenticationExtensionsClientOutputsJSON clientExtensionResults;
  @override
  String type;

  AuthenticationResponseJSONValue({
    required this.id,
    required this.rawId,
    required this.response,
    this.authenticatorAttachment,
    required this.clientExtensionResults,
    required this.type,
  });
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
  Base64URLString? get userHandle;
  set userHandle(Base64URLString? value);
}

final class AuthenticatorAssertionResponseJSONValue implements AuthenticatorAssertionResponseJSON {
  @override
  Base64URLString clientDataJSON;
  @override
  Base64URLString authenticatorData;
  @override
  Base64URLString signature;
  @override
  Base64URLString? userHandle;

  AuthenticatorAssertionResponseJSONValue({
    required this.clientDataJSON,
    required this.authenticatorData,
    required this.signature,
    this.userHandle,
  });
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
  Base64URLString? get publicKey;
  set publicKey(Base64URLString? value);
  int get publicKeyAlgorithm;
  set publicKeyAlgorithm(int value);
  Base64URLString get attestationObject;
  set attestationObject(Base64URLString value);
}

final class AuthenticatorAttestationResponseJSONValue implements AuthenticatorAttestationResponseJSON {
  @override
  Base64URLString clientDataJSON;
  @override
  Base64URLString authenticatorData;
  @override
  List<String> transports;
  @override
  Base64URLString? publicKey;
  @override
  int publicKeyAlgorithm;
  @override
  Base64URLString attestationObject;

  AuthenticatorAttestationResponseJSONValue({
    required this.clientDataJSON,
    required this.authenticatorData,
    required this.transports,
    this.publicKey,
    required this.publicKeyAlgorithm,
    required this.attestationObject,
  });
}

abstract interface class AuthenticatorResponse {
  Object get clientDataJSON;
}

abstract interface class AuthenticatorSelectionCriteria {
  String? get authenticatorAttachment;
  set authenticatorAttachment(String? value);
  String? get residentKey;
  set residentKey(String? value);
  bool? get requireResidentKey;
  set requireResidentKey(bool? value);
  String? get userVerification;
  set userVerification(String? value);
}

final class AuthenticatorSelectionCriteriaValue implements AuthenticatorSelectionCriteria {
  @override
  String? authenticatorAttachment;
  @override
  String? residentKey;
  @override
  bool? requireResidentKey;
  @override
  String? userVerification;

  AuthenticatorSelectionCriteriaValue({
    this.authenticatorAttachment,
    this.residentKey,
    this.requireResidentKey,
    this.userVerification,
  });
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
  String? get topOrigin;
  set topOrigin(String? value);
  bool? get crossOrigin;
  set crossOrigin(bool? value);
}

final class CollectedClientDataValue implements CollectedClientData {
  @override
  String type;
  @override
  String challenge;
  @override
  String origin;
  @override
  String? topOrigin;
  @override
  bool? crossOrigin;

  CollectedClientDataValue({
    required this.type,
    required this.challenge,
    required this.origin,
    this.topOrigin,
    this.crossOrigin,
  });
}

abstract interface class CredentialPropertiesOutput {
  bool? get rk;
  set rk(bool? value);
  String? get authenticatorDisplayName;
  set authenticatorDisplayName(String? value);
}

final class CredentialPropertiesOutputValue implements CredentialPropertiesOutput {
  @override
  bool? rk;
  @override
  String? authenticatorDisplayName;

  CredentialPropertiesOutputValue({
    this.rk,
    this.authenticatorDisplayName,
  });
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
  int? get timeout;
  set timeout(int? value);
  List<PublicKeyCredentialDescriptor>? get excludeCredentials;
  set excludeCredentials(List<PublicKeyCredentialDescriptor>? value);
  AuthenticatorSelectionCriteria? get authenticatorSelection;
  set authenticatorSelection(AuthenticatorSelectionCriteria? value);
  List<String>? get hints;
  set hints(List<String>? value);
  String? get attestation;
  set attestation(String? value);
  List<String>? get attestationFormats;
  set attestationFormats(List<String>? value);
  AuthenticationExtensionsClientInputs? get extensions;
  set extensions(AuthenticationExtensionsClientInputs? value);
}

final class PublicKeyCredentialCreationOptionsValue implements PublicKeyCredentialCreationOptions {
  @override
  PublicKeyCredentialRpEntity rp;
  @override
  PublicKeyCredentialUserEntity user;
  @override
  BufferSource challenge;
  @override
  List<PublicKeyCredentialParameters> pubKeyCredParams;
  @override
  int? timeout;
  @override
  List<PublicKeyCredentialDescriptor>? excludeCredentials;
  @override
  AuthenticatorSelectionCriteria? authenticatorSelection;
  @override
  List<String>? hints;
  @override
  String? attestation;
  @override
  List<String>? attestationFormats;
  @override
  AuthenticationExtensionsClientInputs? extensions;

  PublicKeyCredentialCreationOptionsValue({
    required this.rp,
    required this.user,
    required this.challenge,
    required this.pubKeyCredParams,
    this.timeout,
    this.excludeCredentials,
    this.authenticatorSelection,
    this.hints,
    this.attestation,
    this.attestationFormats,
    this.extensions,
  });
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
  int? get timeout;
  set timeout(int? value);
  List<PublicKeyCredentialDescriptorJSON>? get excludeCredentials;
  set excludeCredentials(List<PublicKeyCredentialDescriptorJSON>? value);
  AuthenticatorSelectionCriteria? get authenticatorSelection;
  set authenticatorSelection(AuthenticatorSelectionCriteria? value);
  List<String>? get hints;
  set hints(List<String>? value);
  String? get attestation;
  set attestation(String? value);
  List<String>? get attestationFormats;
  set attestationFormats(List<String>? value);
  AuthenticationExtensionsClientInputsJSON? get extensions;
  set extensions(AuthenticationExtensionsClientInputsJSON? value);
}

final class PublicKeyCredentialCreationOptionsJSONValue implements PublicKeyCredentialCreationOptionsJSON {
  @override
  PublicKeyCredentialRpEntity rp;
  @override
  PublicKeyCredentialUserEntityJSON user;
  @override
  Base64URLString challenge;
  @override
  List<PublicKeyCredentialParameters> pubKeyCredParams;
  @override
  int? timeout;
  @override
  List<PublicKeyCredentialDescriptorJSON>? excludeCredentials;
  @override
  AuthenticatorSelectionCriteria? authenticatorSelection;
  @override
  List<String>? hints;
  @override
  String? attestation;
  @override
  List<String>? attestationFormats;
  @override
  AuthenticationExtensionsClientInputsJSON? extensions;

  PublicKeyCredentialCreationOptionsJSONValue({
    required this.rp,
    required this.user,
    required this.challenge,
    required this.pubKeyCredParams,
    this.timeout,
    this.excludeCredentials,
    this.authenticatorSelection,
    this.hints,
    this.attestation,
    this.attestationFormats,
    this.extensions,
  });
}

abstract interface class PublicKeyCredentialDescriptor {
  String get type;
  set type(String value);
  BufferSource get id;
  set id(BufferSource value);
  List<String>? get transports;
  set transports(List<String>? value);
}

final class PublicKeyCredentialDescriptorValue implements PublicKeyCredentialDescriptor {
  @override
  String type;
  @override
  BufferSource id;
  @override
  List<String>? transports;

  PublicKeyCredentialDescriptorValue({
    required this.type,
    required this.id,
    this.transports,
  });
}

abstract interface class PublicKeyCredentialDescriptorJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  String get type;
  set type(String value);
  List<String>? get transports;
  set transports(List<String>? value);
}

final class PublicKeyCredentialDescriptorJSONValue implements PublicKeyCredentialDescriptorJSON {
  @override
  Base64URLString id;
  @override
  String type;
  @override
  List<String>? transports;

  PublicKeyCredentialDescriptorJSONValue({
    required this.id,
    required this.type,
    this.transports,
  });
}

abstract interface class PublicKeyCredentialEntity {
  String get name;
  set name(String value);
}

final class PublicKeyCredentialEntityValue implements PublicKeyCredentialEntity {
  @override
  String name;

  PublicKeyCredentialEntityValue({
    required this.name,
  });
}

typedef PublicKeyCredentialHints = String;

typedef PublicKeyCredentialJSON = Object;

abstract interface class PublicKeyCredentialParameters {
  String get type;
  set type(String value);
  COSEAlgorithmIdentifier get alg;
  set alg(COSEAlgorithmIdentifier value);
}

final class PublicKeyCredentialParametersValue implements PublicKeyCredentialParameters {
  @override
  String type;
  @override
  COSEAlgorithmIdentifier alg;

  PublicKeyCredentialParametersValue({
    required this.type,
    required this.alg,
  });
}

abstract interface class PublicKeyCredentialRequestOptions {
  BufferSource get challenge;
  set challenge(BufferSource value);
  int? get timeout;
  set timeout(int? value);
  String? get rpId;
  set rpId(String? value);
  List<PublicKeyCredentialDescriptor>? get allowCredentials;
  set allowCredentials(List<PublicKeyCredentialDescriptor>? value);
  String? get userVerification;
  set userVerification(String? value);
  List<String>? get hints;
  set hints(List<String>? value);
  AuthenticationExtensionsClientInputs? get extensions;
  set extensions(AuthenticationExtensionsClientInputs? value);
}

final class PublicKeyCredentialRequestOptionsValue implements PublicKeyCredentialRequestOptions {
  @override
  BufferSource challenge;
  @override
  int? timeout;
  @override
  String? rpId;
  @override
  List<PublicKeyCredentialDescriptor>? allowCredentials;
  @override
  String? userVerification;
  @override
  List<String>? hints;
  @override
  AuthenticationExtensionsClientInputs? extensions;

  PublicKeyCredentialRequestOptionsValue({
    required this.challenge,
    this.timeout,
    this.rpId,
    this.allowCredentials,
    this.userVerification,
    this.hints,
    this.extensions,
  });
}

abstract interface class PublicKeyCredentialRequestOptionsJSON {
  Base64URLString get challenge;
  set challenge(Base64URLString value);
  int? get timeout;
  set timeout(int? value);
  String? get rpId;
  set rpId(String? value);
  List<PublicKeyCredentialDescriptorJSON>? get allowCredentials;
  set allowCredentials(List<PublicKeyCredentialDescriptorJSON>? value);
  String? get userVerification;
  set userVerification(String? value);
  List<String>? get hints;
  set hints(List<String>? value);
  AuthenticationExtensionsClientInputsJSON? get extensions;
  set extensions(AuthenticationExtensionsClientInputsJSON? value);
}

final class PublicKeyCredentialRequestOptionsJSONValue implements PublicKeyCredentialRequestOptionsJSON {
  @override
  Base64URLString challenge;
  @override
  int? timeout;
  @override
  String? rpId;
  @override
  List<PublicKeyCredentialDescriptorJSON>? allowCredentials;
  @override
  String? userVerification;
  @override
  List<String>? hints;
  @override
  AuthenticationExtensionsClientInputsJSON? extensions;

  PublicKeyCredentialRequestOptionsJSONValue({
    required this.challenge,
    this.timeout,
    this.rpId,
    this.allowCredentials,
    this.userVerification,
    this.hints,
    this.extensions,
  });
}

abstract interface class PublicKeyCredentialRpEntity {
  String? get id;
  set id(String? value);
}

final class PublicKeyCredentialRpEntityValue implements PublicKeyCredentialRpEntity {
  @override
  String? id;

  PublicKeyCredentialRpEntityValue({
    this.id,
  });
}

typedef PublicKeyCredentialType = String;

abstract interface class PublicKeyCredentialUserEntity {
  BufferSource get id;
  set id(BufferSource value);
  String get displayName;
  set displayName(String value);
}

final class PublicKeyCredentialUserEntityValue implements PublicKeyCredentialUserEntity {
  @override
  BufferSource id;
  @override
  String displayName;

  PublicKeyCredentialUserEntityValue({
    required this.id,
    required this.displayName,
  });
}

abstract interface class PublicKeyCredentialUserEntityJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  String get name;
  set name(String value);
  String get displayName;
  set displayName(String value);
}

final class PublicKeyCredentialUserEntityJSONValue implements PublicKeyCredentialUserEntityJSON {
  @override
  Base64URLString id;
  @override
  String name;
  @override
  String displayName;

  PublicKeyCredentialUserEntityJSONValue({
    required this.id,
    required this.name,
    required this.displayName,
  });
}

abstract interface class RegistrationResponseJSON {
  Base64URLString get id;
  set id(Base64URLString value);
  Base64URLString get rawId;
  set rawId(Base64URLString value);
  AuthenticatorAttestationResponseJSON get response;
  set response(AuthenticatorAttestationResponseJSON value);
  String? get authenticatorAttachment;
  set authenticatorAttachment(String? value);
  AuthenticationExtensionsClientOutputsJSON get clientExtensionResults;
  set clientExtensionResults(AuthenticationExtensionsClientOutputsJSON value);
  String get type;
  set type(String value);
}

final class RegistrationResponseJSONValue implements RegistrationResponseJSON {
  @override
  Base64URLString id;
  @override
  Base64URLString rawId;
  @override
  AuthenticatorAttestationResponseJSON response;
  @override
  String? authenticatorAttachment;
  @override
  AuthenticationExtensionsClientOutputsJSON clientExtensionResults;
  @override
  String type;

  RegistrationResponseJSONValue({
    required this.id,
    required this.rawId,
    required this.response,
    this.authenticatorAttachment,
    required this.clientExtensionResults,
    required this.type,
  });
}

typedef ResidentKeyRequirement = String;

abstract interface class TokenBinding {
  String get status;
  set status(String value);
  String? get id;
  set id(String? value);
}

final class TokenBindingValue implements TokenBinding {
  @override
  String status;
  @override
  String? id;

  TokenBindingValue({
    required this.status,
    this.id,
  });
}

typedef TokenBindingStatus = String;

typedef UserVerificationRequirement = String;

typedef UvmEntries = List<UvmEntry>;

typedef UvmEntry = List<int>;

