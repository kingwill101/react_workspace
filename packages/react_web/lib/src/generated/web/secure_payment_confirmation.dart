// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: secure-payment-confirmation
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';
import 'webauthn.dart';
import 'webidl.dart';
import 'fido.dart';

abstract interface class AuthenticationExtensionsPaymentInputs {
  bool get isPayment;
  set isPayment(bool value);
  String get rpId;
  set rpId(String value);
  String get topOrigin;
  set topOrigin(String value);
  String get payeeName;
  set payeeName(String value);
  String get payeeOrigin;
  set payeeOrigin(String value);
  PaymentCurrencyAmount get total;
  set total(PaymentCurrencyAmount value);
  PaymentCredentialInstrument get instrument;
  set instrument(PaymentCredentialInstrument value);
}

abstract interface class CollectedClientAdditionalPaymentData {
  String get rpId;
  set rpId(String value);
  String get topOrigin;
  set topOrigin(String value);
  String get payeeName;
  set payeeName(String value);
  String get payeeOrigin;
  set payeeOrigin(String value);
  PaymentCurrencyAmount get total;
  set total(PaymentCurrencyAmount value);
  PaymentCredentialInstrument get instrument;
  set instrument(PaymentCredentialInstrument value);
}

abstract interface class CollectedClientPaymentData {
  CollectedClientAdditionalPaymentData get payment;
  set payment(CollectedClientAdditionalPaymentData value);
}

abstract interface class PaymentCredentialInstrument {
  String get displayName;
  set displayName(String value);
  String get icon;
  set icon(String value);
  bool get iconMustBeShown;
  set iconMustBeShown(bool value);
}

abstract interface class SecurePaymentConfirmationRequest {
  BufferSource get challenge;
  set challenge(BufferSource value);
  String get rpId;
  set rpId(String value);
  List<BufferSource> get credentialIds;
  set credentialIds(List<BufferSource> value);
  PaymentCredentialInstrument get instrument;
  set instrument(PaymentCredentialInstrument value);
  int get timeout;
  set timeout(int value);
  String get payeeName;
  set payeeName(String value);
  String get payeeOrigin;
  set payeeOrigin(String value);
  AuthenticationExtensionsClientInputs get extensions;
  set extensions(AuthenticationExtensionsClientInputs value);
  List<String> get locale;
  set locale(List<String> value);
  bool get showOptOut;
  set showOptOut(bool value);
}

