// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: payment-request
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'contact_picker.dart';
import 'html.dart';
import 'dom.dart';

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

abstract interface class PayerErrors {
  String get email;
  set email(String value);
  String get name;
  set name(String value);
  String get phone;
  set phone(String value);
}

typedef PaymentComplete = String;

abstract interface class PaymentCompleteDetails {
  Object? get data;
  set data(Object? value);
}

abstract interface class PaymentCurrencyAmount {
  String get currency;
  set currency(String value);
  String get value;
  set value(String value);
}

abstract interface class PaymentDetailsBase {
  List<PaymentItem> get displayItems;
  set displayItems(List<PaymentItem> value);
  List<PaymentShippingOption> get shippingOptions;
  set shippingOptions(List<PaymentShippingOption> value);
  List<PaymentDetailsModifier> get modifiers;
  set modifiers(List<PaymentDetailsModifier> value);
}

abstract interface class PaymentDetailsInit {
  String get id;
  set id(String value);
  PaymentItem get total;
  set total(PaymentItem value);
}

abstract interface class PaymentDetailsModifier {
  String get supportedMethods;
  set supportedMethods(String value);
  PaymentItem get total;
  set total(PaymentItem value);
  List<PaymentItem> get additionalDisplayItems;
  set additionalDisplayItems(List<PaymentItem> value);
  Object get data;
  set data(Object value);
}

abstract interface class PaymentDetailsUpdate {
  String get error;
  set error(String value);
  PaymentItem get total;
  set total(PaymentItem value);
  AddressErrors get shippingAddressErrors;
  set shippingAddressErrors(AddressErrors value);
  PayerErrors get payerErrors;
  set payerErrors(PayerErrors value);
  Object get paymentMethodErrors;
  set paymentMethodErrors(Object value);
}

abstract interface class PaymentItem {
  String get label;
  set label(String value);
  PaymentCurrencyAmount get amount;
  set amount(PaymentCurrencyAmount value);
  bool get pending;
  set pending(bool value);
}

abstract interface class PaymentMethodChangeEvent {
  String get methodName;
  Object? get methodDetails;
}

abstract interface class PaymentMethodChangeEventInit {
  String get methodName;
  set methodName(String value);
  Object? get methodDetails;
  set methodDetails(Object? value);
}

abstract interface class PaymentMethodData {
  String get supportedMethods;
  set supportedMethods(String value);
  Object get data;
  set data(Object value);
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

abstract interface class PaymentRequest {
  Future<PaymentResponse> show_([Future<PaymentDetailsUpdate>? detailsPromise]);
  Future<void> abort();
  Future<bool> canMakePayment();
  String get id;
  ContactAddress? get shippingAddress;
  String? get shippingOption;
  PaymentShippingType? get shippingType;
  EventHandler get onshippingaddresschange;
   set onshippingaddresschange(EventHandler value);
  EventHandler get onshippingoptionchange;
   set onshippingoptionchange(EventHandler value);
  EventHandler get onpaymentmethodchange;
   set onpaymentmethodchange(EventHandler value);
}

abstract interface class PaymentRequestUpdateEvent {
  void updateWith(Future<PaymentDetailsUpdate> detailsPromise);
}

abstract interface class PaymentRequestUpdateEventInit {
}

abstract interface class PaymentResponse {
  Object toJSON();
  String get requestId;
  String get methodName;
  Object get details;
  ContactAddress? get shippingAddress;
  String? get shippingOption;
  String? get payerName;
  String? get payerEmail;
  String? get payerPhone;
  Future<void> complete([PaymentComplete? result, PaymentCompleteDetails? details]);
  Future<void> retry([PaymentValidationErrors? errorFields]);
  EventHandler get onpayerdetailchange;
   set onpayerdetailchange(EventHandler value);
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

abstract interface class PaymentValidationErrors {
  PayerErrors get payer;
  set payer(PayerErrors value);
  AddressErrors get shippingAddress;
  set shippingAddress(AddressErrors value);
  String get error;
  set error(String value);
  Object get paymentMethod;
  set paymentMethod(Object value);
}

