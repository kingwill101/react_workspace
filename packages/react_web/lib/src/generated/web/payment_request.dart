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

abstract interface class PaymentCurrencyAmount {
  String get currency;
  set currency(String value);
  String get value;
  set value(String value);
}

abstract interface class PaymentDetailsBase {
  List<PaymentItem> get displayItems;
  set displayItems(List<PaymentItem> value);
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
  PaymentItem get total;
  set total(PaymentItem value);
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
  factory PaymentMethodChangeEvent(String type, [PaymentMethodChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PaymentMethodChangeEvent>(
        'PaymentMethodChangeEvent',
        [type, eventInitDict],
      );
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

abstract interface class PaymentResponse {
  Object toJSON();
  String get requestId;
  String get methodName;
  Object get details;
  Future<void> complete([PaymentComplete? result, PaymentCompleteDetails? details]);
  Future<void> retry([PaymentValidationErrors? errorFields]);
}

abstract interface class PaymentValidationErrors {
  String get error;
  set error(String value);
  Object get paymentMethod;
  set paymentMethod(Object value);
}

