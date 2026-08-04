// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: payment-handler
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';
import 'service_workers.dart';

abstract interface class AddressInit {
  String get country;
  set country(String value);
  List<String> get addressLine;
  set addressLine(List<String> value);
  String get region;
  set region(String value);
  String get city;
  set city(String value);
  String get dependentLocality;
  set dependentLocality(String value);
  String get postalCode;
  set postalCode(String value);
  String get sortingCode;
  set sortingCode(String value);
  String get organization;
  set organization(String value);
  String get recipient;
  set recipient(String value);
  String get phone;
  set phone(String value);
}

abstract interface class CanMakePaymentEvent {
  void respondWith(Future<bool> canMakePaymentResponse);
}

typedef PaymentDelegation = String;

abstract interface class PaymentHandlerResponse {
  String get methodName;
  set methodName(String value);
  Object get details;
  set details(Object value);
  String? get payerName;
  set payerName(String? value);
  String? get payerEmail;
  set payerEmail(String? value);
  String? get payerPhone;
  set payerPhone(String? value);
  AddressInit get shippingAddress;
  set shippingAddress(AddressInit value);
  String? get shippingOption;
  set shippingOption(String? value);
}

abstract interface class PaymentManager {
  String get userHint;
   set userHint(String value);
  Future<void> enableDelegations(List<PaymentDelegation> delegations);
}

abstract interface class PaymentRequestDetailsUpdate {
  String get error;
  set error(String value);
  PaymentCurrencyAmount get total;
  set total(PaymentCurrencyAmount value);
  List<PaymentDetailsModifier> get modifiers;
  set modifiers(List<PaymentDetailsModifier> value);
  List<PaymentShippingOption> get shippingOptions;
  set shippingOptions(List<PaymentShippingOption> value);
  Object get paymentMethodErrors;
  set paymentMethodErrors(Object value);
  AddressErrors get shippingAddressErrors;
  set shippingAddressErrors(AddressErrors value);
}

abstract interface class PaymentRequestEvent {
  String get topOrigin;
  String get paymentRequestOrigin;
  String get paymentRequestId;
  List<PaymentMethodData> get methodData;
  Object get total;
  List<PaymentDetailsModifier> get modifiers;
  Object? get paymentOptions;
  List<PaymentShippingOption>? get shippingOptions;
  Future<WindowClient?> openWindow(String url);
  Future<PaymentRequestDetailsUpdate?> changePaymentMethod(String methodName, [Object? methodDetails]);
  Future<PaymentRequestDetailsUpdate?> changeShippingAddress([AddressInit? shippingAddress]);
  Future<PaymentRequestDetailsUpdate?> changeShippingOption(String shippingOption);
  void respondWith(Future<PaymentHandlerResponse> handlerResponsePromise);
}

abstract interface class PaymentRequestEventInit {
  String get topOrigin;
  set topOrigin(String value);
  String get paymentRequestOrigin;
  set paymentRequestOrigin(String value);
  String get paymentRequestId;
  set paymentRequestId(String value);
  List<PaymentMethodData> get methodData;
  set methodData(List<PaymentMethodData> value);
  PaymentCurrencyAmount get total;
  set total(PaymentCurrencyAmount value);
  List<PaymentDetailsModifier> get modifiers;
  set modifiers(List<PaymentDetailsModifier> value);
  PaymentOptions get paymentOptions;
  set paymentOptions(PaymentOptions value);
  List<PaymentShippingOption> get shippingOptions;
  set shippingOptions(List<PaymentShippingOption> value);
}

