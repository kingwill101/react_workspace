// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: payment-handler
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';
import 'service_workers.dart';

abstract interface class AddressErrors {
  String? get addressLine;
  set addressLine(String? value);
  String? get city;
  set city(String? value);
  String? get country;
  set country(String? value);
  String? get dependentLocality;
  set dependentLocality(String? value);
  String? get organization;
  set organization(String? value);
  String? get phone;
  set phone(String? value);
  String? get postalCode;
  set postalCode(String? value);
  String? get recipient;
  set recipient(String? value);
  String? get region;
  set region(String? value);
  String? get sortingCode;
  set sortingCode(String? value);
}

final class AddressErrorsValue implements AddressErrors {
  @override
  String? addressLine;
  @override
  String? city;
  @override
  String? country;
  @override
  String? dependentLocality;
  @override
  String? organization;
  @override
  String? phone;
  @override
  String? postalCode;
  @override
  String? recipient;
  @override
  String? region;
  @override
  String? sortingCode;

  AddressErrorsValue({
    this.addressLine,
    this.city,
    this.country,
    this.dependentLocality,
    this.organization,
    this.phone,
    this.postalCode,
    this.recipient,
    this.region,
    this.sortingCode,
  });
}

abstract interface class AddressInit {
  String? get country;
  set country(String? value);
  List<String>? get addressLine;
  set addressLine(List<String>? value);
  String? get region;
  set region(String? value);
  String? get city;
  set city(String? value);
  String? get dependentLocality;
  set dependentLocality(String? value);
  String? get postalCode;
  set postalCode(String? value);
  String? get sortingCode;
  set sortingCode(String? value);
  String? get organization;
  set organization(String? value);
  String? get recipient;
  set recipient(String? value);
  String? get phone;
  set phone(String? value);
}

final class AddressInitValue implements AddressInit {
  @override
  String? country;
  @override
  List<String>? addressLine;
  @override
  String? region;
  @override
  String? city;
  @override
  String? dependentLocality;
  @override
  String? postalCode;
  @override
  String? sortingCode;
  @override
  String? organization;
  @override
  String? recipient;
  @override
  String? phone;

  AddressInitValue({
    this.country,
    this.addressLine,
    this.region,
    this.city,
    this.dependentLocality,
    this.postalCode,
    this.sortingCode,
    this.organization,
    this.recipient,
    this.phone,
  });
}

typedef PaymentDelegation = String;

abstract interface class PaymentHandlerResponse {
  String? get methodName;
  set methodName(String? value);
  Object? get details;
  set details(Object? value);
  String? get payerName;
  set payerName(String? value);
  String? get payerEmail;
  set payerEmail(String? value);
  String? get payerPhone;
  set payerPhone(String? value);
  AddressInit? get shippingAddress;
  set shippingAddress(AddressInit? value);
  String? get shippingOption;
  set shippingOption(String? value);
}

final class PaymentHandlerResponseValue implements PaymentHandlerResponse {
  @override
  String? methodName;
  @override
  Object? details;
  @override
  String? payerName;
  @override
  String? payerEmail;
  @override
  String? payerPhone;
  @override
  AddressInit? shippingAddress;
  @override
  String? shippingOption;

  PaymentHandlerResponseValue({
    this.methodName,
    this.details,
    this.payerName,
    this.payerEmail,
    this.payerPhone,
    this.shippingAddress,
    this.shippingOption,
  });
}

abstract interface class PaymentOptions {
  bool? get requestPayerName;
  set requestPayerName(bool? value);
  bool? get requestBillingAddress;
  set requestBillingAddress(bool? value);
  bool? get requestPayerEmail;
  set requestPayerEmail(bool? value);
  bool? get requestPayerPhone;
  set requestPayerPhone(bool? value);
  bool? get requestShipping;
  set requestShipping(bool? value);
  PaymentShippingType? get shippingType;
  set shippingType(PaymentShippingType? value);
}

final class PaymentOptionsValue implements PaymentOptions {
  @override
  bool? requestPayerName;
  @override
  bool? requestBillingAddress;
  @override
  bool? requestPayerEmail;
  @override
  bool? requestPayerPhone;
  @override
  bool? requestShipping;
  @override
  PaymentShippingType? shippingType;

  PaymentOptionsValue({
    this.requestPayerName,
    this.requestBillingAddress,
    this.requestPayerEmail,
    this.requestPayerPhone,
    this.requestShipping,
    this.shippingType,
  });
}

abstract interface class PaymentRequestDetailsUpdate {
  String? get error;
  set error(String? value);
  PaymentCurrencyAmount? get total;
  set total(PaymentCurrencyAmount? value);
  List<PaymentDetailsModifier>? get modifiers;
  set modifiers(List<PaymentDetailsModifier>? value);
  List<PaymentShippingOption>? get shippingOptions;
  set shippingOptions(List<PaymentShippingOption>? value);
  Object? get paymentMethodErrors;
  set paymentMethodErrors(Object? value);
  AddressErrors? get shippingAddressErrors;
  set shippingAddressErrors(AddressErrors? value);
}

final class PaymentRequestDetailsUpdateValue implements PaymentRequestDetailsUpdate {
  @override
  String? error;
  @override
  PaymentCurrencyAmount? total;
  @override
  List<PaymentDetailsModifier>? modifiers;
  @override
  List<PaymentShippingOption>? shippingOptions;
  @override
  Object? paymentMethodErrors;
  @override
  AddressErrors? shippingAddressErrors;

  PaymentRequestDetailsUpdateValue({
    this.error,
    this.total,
    this.modifiers,
    this.shippingOptions,
    this.paymentMethodErrors,
    this.shippingAddressErrors,
  });
}

abstract interface class PaymentRequestEventInit {
  String? get topOrigin;
  set topOrigin(String? value);
  String? get paymentRequestOrigin;
  set paymentRequestOrigin(String? value);
  String? get paymentRequestId;
  set paymentRequestId(String? value);
  List<PaymentMethodData>? get methodData;
  set methodData(List<PaymentMethodData>? value);
  PaymentCurrencyAmount? get total;
  set total(PaymentCurrencyAmount? value);
  List<PaymentDetailsModifier>? get modifiers;
  set modifiers(List<PaymentDetailsModifier>? value);
  PaymentOptions? get paymentOptions;
  set paymentOptions(PaymentOptions? value);
  List<PaymentShippingOption>? get shippingOptions;
  set shippingOptions(List<PaymentShippingOption>? value);
}

final class PaymentRequestEventInitValue implements PaymentRequestEventInit {
  @override
  String? topOrigin;
  @override
  String? paymentRequestOrigin;
  @override
  String? paymentRequestId;
  @override
  List<PaymentMethodData>? methodData;
  @override
  PaymentCurrencyAmount? total;
  @override
  List<PaymentDetailsModifier>? modifiers;
  @override
  PaymentOptions? paymentOptions;
  @override
  List<PaymentShippingOption>? shippingOptions;

  PaymentRequestEventInitValue({
    this.topOrigin,
    this.paymentRequestOrigin,
    this.paymentRequestId,
    this.methodData,
    this.total,
    this.modifiers,
    this.paymentOptions,
    this.shippingOptions,
  });
}

abstract interface class PaymentShippingOption {
  String get id;
  set id(String value);
  String get label;
  set label(String value);
  PaymentCurrencyAmount get amount;
  set amount(PaymentCurrencyAmount value);
  bool? get selected;
  set selected(bool? value);
}

final class PaymentShippingOptionValue implements PaymentShippingOption {
  @override
  String id;
  @override
  String label;
  @override
  PaymentCurrencyAmount amount;
  @override
  bool? selected;

  PaymentShippingOptionValue({
    required this.id,
    required this.label,
    required this.amount,
    this.selected,
  });
}

typedef PaymentShippingType = String;

