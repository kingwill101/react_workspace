// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: digital-goods
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'payment_request.dart';

abstract interface class DigitalGoodsService {
  Future<List<ItemDetails>> getDetails(List<String> itemIds);
  Future<List<PurchaseDetails>> listPurchases();
  Future<List<PurchaseDetails>> listPurchaseHistory();
  Future<void> consume(String purchaseToken);
}

abstract interface class ItemDetails {
  String get itemId;
  set itemId(String value);
  String get title;
  set title(String value);
  PaymentCurrencyAmount get price;
  set price(PaymentCurrencyAmount value);
  ItemType get type;
  set type(ItemType value);
  String get description;
  set description(String value);
  List<String> get iconURLs;
  set iconURLs(List<String> value);
  String get subscriptionPeriod;
  set subscriptionPeriod(String value);
  String get freeTrialPeriod;
  set freeTrialPeriod(String value);
  PaymentCurrencyAmount get introductoryPrice;
  set introductoryPrice(PaymentCurrencyAmount value);
  String get introductoryPricePeriod;
  set introductoryPricePeriod(String value);
  int get introductoryPriceCycles;
  set introductoryPriceCycles(int value);
}

typedef ItemType = String;

abstract interface class PurchaseDetails {
  String get itemId;
  set itemId(String value);
  String get purchaseToken;
  set purchaseToken(String value);
}

