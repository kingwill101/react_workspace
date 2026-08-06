// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: digital-goods
// ignore_for_file: type=lint

import 'payment_request.dart';

abstract interface class ItemDetails {
  String get itemId;
  set itemId(String value);
  String get title;
  set title(String value);
  PaymentCurrencyAmount get price;
  set price(PaymentCurrencyAmount value);
  ItemType? get type;
  set type(ItemType? value);
  String? get description;
  set description(String? value);
  List<String>? get iconURLs;
  set iconURLs(List<String>? value);
  String? get subscriptionPeriod;
  set subscriptionPeriod(String? value);
  String? get freeTrialPeriod;
  set freeTrialPeriod(String? value);
  PaymentCurrencyAmount? get introductoryPrice;
  set introductoryPrice(PaymentCurrencyAmount? value);
  String? get introductoryPricePeriod;
  set introductoryPricePeriod(String? value);
  int? get introductoryPriceCycles;
  set introductoryPriceCycles(int? value);
}

final class ItemDetailsValue implements ItemDetails {
  @override
  String itemId;
  @override
  String title;
  @override
  PaymentCurrencyAmount price;
  @override
  ItemType? type;
  @override
  String? description;
  @override
  List<String>? iconURLs;
  @override
  String? subscriptionPeriod;
  @override
  String? freeTrialPeriod;
  @override
  PaymentCurrencyAmount? introductoryPrice;
  @override
  String? introductoryPricePeriod;
  @override
  int? introductoryPriceCycles;

  ItemDetailsValue({
    required this.itemId,
    required this.title,
    required this.price,
    this.type,
    this.description,
    this.iconURLs,
    this.subscriptionPeriod,
    this.freeTrialPeriod,
    this.introductoryPrice,
    this.introductoryPricePeriod,
    this.introductoryPriceCycles,
  });
}

typedef ItemType = String;

abstract interface class PurchaseDetails {
  String get itemId;
  set itemId(String value);
  String get purchaseToken;
  set purchaseToken(String value);
}

final class PurchaseDetailsValue implements PurchaseDetails {
  @override
  String itemId;
  @override
  String purchaseToken;

  PurchaseDetailsValue({
    required this.itemId,
    required this.purchaseToken,
  });
}

