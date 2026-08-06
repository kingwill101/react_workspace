// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: secure-payment-confirmation
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';
import 'webauthn.dart';
import 'webidl.dart';
import 'fido.dart';

abstract interface class AuthenticationExtensionsPaymentInputs {
  bool? get isPayment;
  set isPayment(bool? value);
  String? get rpId;
  set rpId(String? value);
  String? get topOrigin;
  set topOrigin(String? value);
  String? get payeeName;
  set payeeName(String? value);
  String? get payeeOrigin;
  set payeeOrigin(String? value);
  PaymentCurrencyAmount? get total;
  set total(PaymentCurrencyAmount? value);
  PaymentCredentialInstrument? get instrument;
  set instrument(PaymentCredentialInstrument? value);
}

final class AuthenticationExtensionsPaymentInputsValue implements AuthenticationExtensionsPaymentInputs {
  @override
  bool? isPayment;
  @override
  String? rpId;
  @override
  String? topOrigin;
  @override
  String? payeeName;
  @override
  String? payeeOrigin;
  @override
  PaymentCurrencyAmount? total;
  @override
  PaymentCredentialInstrument? instrument;

  AuthenticationExtensionsPaymentInputsValue({
    this.isPayment,
    this.rpId,
    this.topOrigin,
    this.payeeName,
    this.payeeOrigin,
    this.total,
    this.instrument,
  });
}

abstract interface class CollectedClientAdditionalPaymentData {
  String get rpId;
  set rpId(String value);
  String get topOrigin;
  set topOrigin(String value);
  String? get payeeName;
  set payeeName(String? value);
  String? get payeeOrigin;
  set payeeOrigin(String? value);
  PaymentCurrencyAmount get total;
  set total(PaymentCurrencyAmount value);
  PaymentCredentialInstrument get instrument;
  set instrument(PaymentCredentialInstrument value);
}

final class CollectedClientAdditionalPaymentDataValue implements CollectedClientAdditionalPaymentData {
  @override
  String rpId;
  @override
  String topOrigin;
  @override
  String? payeeName;
  @override
  String? payeeOrigin;
  @override
  PaymentCurrencyAmount total;
  @override
  PaymentCredentialInstrument instrument;

  CollectedClientAdditionalPaymentDataValue({
    required this.rpId,
    required this.topOrigin,
    this.payeeName,
    this.payeeOrigin,
    required this.total,
    required this.instrument,
  });
}

abstract interface class CollectedClientPaymentData {
  CollectedClientAdditionalPaymentData get payment;
  set payment(CollectedClientAdditionalPaymentData value);
}

final class CollectedClientPaymentDataValue implements CollectedClientPaymentData {
  @override
  CollectedClientAdditionalPaymentData payment;

  CollectedClientPaymentDataValue({
    required this.payment,
  });
}

abstract interface class PaymentCredentialInstrument {
  String get displayName;
  set displayName(String value);
  String get icon;
  set icon(String value);
  bool? get iconMustBeShown;
  set iconMustBeShown(bool? value);
}

final class PaymentCredentialInstrumentValue implements PaymentCredentialInstrument {
  @override
  String displayName;
  @override
  String icon;
  @override
  bool? iconMustBeShown;

  PaymentCredentialInstrumentValue({
    required this.displayName,
    required this.icon,
    this.iconMustBeShown,
  });
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
  int? get timeout;
  set timeout(int? value);
  String? get payeeName;
  set payeeName(String? value);
  String? get payeeOrigin;
  set payeeOrigin(String? value);
  AuthenticationExtensionsClientInputs? get extensions;
  set extensions(AuthenticationExtensionsClientInputs? value);
  List<String>? get locale;
  set locale(List<String>? value);
  bool? get showOptOut;
  set showOptOut(bool? value);
}

final class SecurePaymentConfirmationRequestValue implements SecurePaymentConfirmationRequest {
  @override
  BufferSource challenge;
  @override
  String rpId;
  @override
  List<BufferSource> credentialIds;
  @override
  PaymentCredentialInstrument instrument;
  @override
  int? timeout;
  @override
  String? payeeName;
  @override
  String? payeeOrigin;
  @override
  AuthenticationExtensionsClientInputs? extensions;
  @override
  List<String>? locale;
  @override
  bool? showOptOut;

  SecurePaymentConfirmationRequestValue({
    required this.challenge,
    required this.rpId,
    required this.credentialIds,
    required this.instrument,
    this.timeout,
    this.payeeName,
    this.payeeOrigin,
    this.extensions,
    this.locale,
    this.showOptOut,
  });
}

