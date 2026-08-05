// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: payment-handler
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';
import 'service_workers.dart';

abstract interface class AddressErrors {
  String get addressLine;
  set addressLine(String value);
  String get city;
  set city(String value);
  String get country;
  set country(String value);
  String get dependentLocality;
  set dependentLocality(String value);
  String get organization;
  set organization(String value);
  String get phone;
  set phone(String value);
  String get postalCode;
  set postalCode(String value);
  String get recipient;
  set recipient(String value);
  String get region;
  set region(String value);
  String get sortingCode;
  set sortingCode(String value);
}

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

abstract interface class PaymentOptions {
  bool get requestPayerName;
  set requestPayerName(bool value);
  bool get requestBillingAddress;
  set requestBillingAddress(bool value);
  bool get requestPayerEmail;
  set requestPayerEmail(bool value);
  bool get requestPayerPhone;
  set requestPayerPhone(bool value);
  bool get requestShipping;
  set requestShipping(bool value);
  PaymentShippingType get shippingType;
  set shippingType(PaymentShippingType value);
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

abstract interface class PaymentShippingOption {
  String get id;
  set id(String value);
  String get label;
  set label(String value);
  PaymentCurrencyAmount get amount;
  set amount(PaymentCurrencyAmount value);
  bool get selected;
  set selected(bool value);
}

typedef PaymentShippingType = String;

