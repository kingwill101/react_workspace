// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: fido
// ignore_for_file: type=lint

import 'secure_payment_confirmation.dart';
import 'webauthn.dart';

abstract interface class AuthenticationExtensionsClientInputs {
  String? get credentialProtectionPolicy;
  set credentialProtectionPolicy(String? value);
  bool? get enforceCredentialProtectionPolicy;
  set enforceCredentialProtectionPolicy(bool? value);
  Object? get credBlob;
  set credBlob(Object? value);
  bool? get getCredBlob;
  set getCredBlob(bool? value);
  bool? get minPinLength;
  set minPinLength(bool? value);
  bool? get hmacCreateSecret;
  set hmacCreateSecret(bool? value);
  HMACGetSecretInput? get hmacGetSecret;
  set hmacGetSecret(HMACGetSecretInput? value);
  AuthenticationExtensionsPaymentInputs? get payment;
  set payment(AuthenticationExtensionsPaymentInputs? value);
  String? get appid;
  set appid(String? value);
  String? get appidExclude;
  set appidExclude(String? value);
  bool? get credProps;
  set credProps(bool? value);
  AuthenticationExtensionsPRFInputs? get prf;
  set prf(AuthenticationExtensionsPRFInputs? value);
  AuthenticationExtensionsLargeBlobInputs? get largeBlob;
  set largeBlob(AuthenticationExtensionsLargeBlobInputs? value);
  bool? get uvm;
  set uvm(bool? value);
  AuthenticationExtensionsSupplementalPubKeysInputs? get supplementalPubKeys;
  set supplementalPubKeys(
    AuthenticationExtensionsSupplementalPubKeysInputs? value,
  );
}

final class AuthenticationExtensionsClientInputsValue
    implements AuthenticationExtensionsClientInputs {
  @override
  String? credentialProtectionPolicy;
  @override
  bool? enforceCredentialProtectionPolicy;
  @override
  Object? credBlob;
  @override
  bool? getCredBlob;
  @override
  bool? minPinLength;
  @override
  bool? hmacCreateSecret;
  @override
  HMACGetSecretInput? hmacGetSecret;
  @override
  AuthenticationExtensionsPaymentInputs? payment;
  @override
  String? appid;
  @override
  String? appidExclude;
  @override
  bool? credProps;
  @override
  AuthenticationExtensionsPRFInputs? prf;
  @override
  AuthenticationExtensionsLargeBlobInputs? largeBlob;
  @override
  bool? uvm;
  @override
  AuthenticationExtensionsSupplementalPubKeysInputs? supplementalPubKeys;

  AuthenticationExtensionsClientInputsValue({
    this.credentialProtectionPolicy,
    this.enforceCredentialProtectionPolicy,
    this.credBlob,
    this.getCredBlob,
    this.minPinLength,
    this.hmacCreateSecret,
    this.hmacGetSecret,
    this.payment,
    this.appid,
    this.appidExclude,
    this.credProps,
    this.prf,
    this.largeBlob,
    this.uvm,
    this.supplementalPubKeys,
  });
}

abstract interface class AuthenticationExtensionsClientOutputs {
  bool? get hmacCreateSecret;
  set hmacCreateSecret(bool? value);
  HMACGetSecretOutput? get hmacGetSecret;
  set hmacGetSecret(HMACGetSecretOutput? value);
  bool? get appid;
  set appid(bool? value);
  bool? get appidExclude;
  set appidExclude(bool? value);
  CredentialPropertiesOutput? get credProps;
  set credProps(CredentialPropertiesOutput? value);
  AuthenticationExtensionsPRFOutputs? get prf;
  set prf(AuthenticationExtensionsPRFOutputs? value);
  AuthenticationExtensionsLargeBlobOutputs? get largeBlob;
  set largeBlob(AuthenticationExtensionsLargeBlobOutputs? value);
  UvmEntries? get uvm;
  set uvm(UvmEntries? value);
  AuthenticationExtensionsSupplementalPubKeysOutputs? get supplementalPubKeys;
  set supplementalPubKeys(
    AuthenticationExtensionsSupplementalPubKeysOutputs? value,
  );
}

final class AuthenticationExtensionsClientOutputsValue
    implements AuthenticationExtensionsClientOutputs {
  @override
  bool? hmacCreateSecret;
  @override
  HMACGetSecretOutput? hmacGetSecret;
  @override
  bool? appid;
  @override
  bool? appidExclude;
  @override
  CredentialPropertiesOutput? credProps;
  @override
  AuthenticationExtensionsPRFOutputs? prf;
  @override
  AuthenticationExtensionsLargeBlobOutputs? largeBlob;
  @override
  UvmEntries? uvm;
  @override
  AuthenticationExtensionsSupplementalPubKeysOutputs? supplementalPubKeys;

  AuthenticationExtensionsClientOutputsValue({
    this.hmacCreateSecret,
    this.hmacGetSecret,
    this.appid,
    this.appidExclude,
    this.credProps,
    this.prf,
    this.largeBlob,
    this.uvm,
    this.supplementalPubKeys,
  });
}

abstract interface class HMACGetSecretInput {
  Object get salt1;
  set salt1(Object value);
  Object? get salt2;
  set salt2(Object? value);
}

final class HMACGetSecretInputValue implements HMACGetSecretInput {
  @override
  Object salt1;
  @override
  Object? salt2;

  HMACGetSecretInputValue({required this.salt1, this.salt2});
}

abstract interface class HMACGetSecretOutput {
  Object get output1;
  set output1(Object value);
  Object? get output2;
  set output2(Object? value);
}

final class HMACGetSecretOutputValue implements HMACGetSecretOutput {
  @override
  Object output1;
  @override
  Object? output2;

  HMACGetSecretOutputValue({required this.output1, this.output2});
}
