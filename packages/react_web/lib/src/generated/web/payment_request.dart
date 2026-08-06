// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: payment-request
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

typedef PaymentComplete = String;

abstract interface class PaymentCompleteDetails {
  Object? get data;
  set data(Object? value);
}

final class PaymentCompleteDetailsValue implements PaymentCompleteDetails {
  @override
  Object? data;

  PaymentCompleteDetailsValue({
    this.data,
  });
}

abstract interface class PaymentCurrencyAmount {
  String get currency;
  set currency(String value);
  String get value;
  set value(String value);
}

final class PaymentCurrencyAmountValue implements PaymentCurrencyAmount {
  @override
  String currency;
  @override
  String value;

  PaymentCurrencyAmountValue({
    required this.currency,
    required this.value,
  });
}

abstract interface class PaymentDetailsBase {
  List<PaymentItem>? get displayItems;
  set displayItems(List<PaymentItem>? value);
  List<PaymentDetailsModifier>? get modifiers;
  set modifiers(List<PaymentDetailsModifier>? value);
}

final class PaymentDetailsBaseValue implements PaymentDetailsBase {
  @override
  List<PaymentItem>? displayItems;
  @override
  List<PaymentDetailsModifier>? modifiers;

  PaymentDetailsBaseValue({
    this.displayItems,
    this.modifiers,
  });
}

abstract interface class PaymentDetailsInit {
  String? get id;
  set id(String? value);
  PaymentItem get total;
  set total(PaymentItem value);
}

final class PaymentDetailsInitValue implements PaymentDetailsInit {
  @override
  String? id;
  @override
  PaymentItem total;

  PaymentDetailsInitValue({
    this.id,
    required this.total,
  });
}

abstract interface class PaymentDetailsModifier {
  String get supportedMethods;
  set supportedMethods(String value);
  PaymentItem? get total;
  set total(PaymentItem? value);
  List<PaymentItem>? get additionalDisplayItems;
  set additionalDisplayItems(List<PaymentItem>? value);
  Object? get data;
  set data(Object? value);
}

final class PaymentDetailsModifierValue implements PaymentDetailsModifier {
  @override
  String supportedMethods;
  @override
  PaymentItem? total;
  @override
  List<PaymentItem>? additionalDisplayItems;
  @override
  Object? data;

  PaymentDetailsModifierValue({
    required this.supportedMethods,
    this.total,
    this.additionalDisplayItems,
    this.data,
  });
}

abstract interface class PaymentDetailsUpdate {
  PaymentItem? get total;
  set total(PaymentItem? value);
  Object? get paymentMethodErrors;
  set paymentMethodErrors(Object? value);
}

final class PaymentDetailsUpdateValue implements PaymentDetailsUpdate {
  @override
  PaymentItem? total;
  @override
  Object? paymentMethodErrors;

  PaymentDetailsUpdateValue({
    this.total,
    this.paymentMethodErrors,
  });
}

abstract interface class PaymentItem {
  String get label;
  set label(String value);
  PaymentCurrencyAmount get amount;
  set amount(PaymentCurrencyAmount value);
  bool? get pending;
  set pending(bool? value);
}

final class PaymentItemValue implements PaymentItem {
  @override
  String label;
  @override
  PaymentCurrencyAmount amount;
  @override
  bool? pending;

  PaymentItemValue({
    required this.label,
    required this.amount,
    this.pending,
  });
}

abstract interface class PaymentMethodChangeEvent {
  factory PaymentMethodChangeEvent(String type, [PaymentMethodChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PaymentMethodChangeEvent>(
        'PaymentMethodChangeEvent',
        [type, eventInitDict],
      );
  String get methodName;
  Object? get methodDetails;
}

abstract interface class PaymentMethodChangeEventInit {
  String? get methodName;
  set methodName(String? value);
  Object? get methodDetails;
  set methodDetails(Object? value);
}

final class PaymentMethodChangeEventInitValue implements PaymentMethodChangeEventInit {
  @override
  String? methodName;
  @override
  Object? methodDetails;

  PaymentMethodChangeEventInitValue({
    this.methodName,
    this.methodDetails,
  });
}

abstract interface class PaymentMethodData {
  String get supportedMethods;
  set supportedMethods(String value);
  Object? get data;
  set data(Object? value);
}

final class PaymentMethodDataValue implements PaymentMethodData {
  @override
  String supportedMethods;
  @override
  Object? data;

  PaymentMethodDataValue({
    required this.supportedMethods,
    this.data,
  });
}

abstract interface class PaymentRequest {
  factory PaymentRequest(List<PaymentMethodData> methodData, PaymentDetailsInit details) =>
      WebRuntime.current.createWebObject<PaymentRequest>(
        'PaymentRequest',
        [methodData, details],
      );
  Future<PaymentResponse> show_([Future<PaymentDetailsUpdate>? detailsPromise]);
  Future<void> abort();
  Future<bool> canMakePayment();
  String get id;
  EventHandler get onpaymentmethodchange;
   set onpaymentmethodchange(EventHandler value);
}

abstract interface class PaymentRequestUpdateEvent {
  factory PaymentRequestUpdateEvent(String type, [PaymentRequestUpdateEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PaymentRequestUpdateEvent>(
        'PaymentRequestUpdateEvent',
        [type, eventInitDict],
      );
  void updateWith(Future<PaymentDetailsUpdate> detailsPromise);
}

abstract interface class PaymentRequestUpdateEventInit {
}

final class PaymentRequestUpdateEventInitValue implements PaymentRequestUpdateEventInit {

  PaymentRequestUpdateEventInitValue();
}

abstract interface class PaymentResponse {
  Object toJSON();
  String get requestId;
  String get methodName;
  Object get details;
  Future<void> complete([PaymentComplete? result, PaymentCompleteDetails? details]);
  Future<void> retry([PaymentValidationErrors? errorFields]);
}

abstract interface class PaymentValidationErrors {
  String? get error;
  set error(String? value);
  Object? get paymentMethod;
  set paymentMethod(Object? value);
}

final class PaymentValidationErrorsValue implements PaymentValidationErrors {
  @override
  String? error;
  @override
  Object? paymentMethod;

  PaymentValidationErrorsValue({
    this.error,
    this.paymentMethod,
  });
}

