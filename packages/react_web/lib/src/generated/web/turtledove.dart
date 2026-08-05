// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: turtledove
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class AdRender {
  String get url;
  set url(String value);
  String get width;
  set width(String value);
  String get height;
  set height(String value);
}

abstract interface class AuctionAd {
  String get renderURL;
  set renderURL(String value);
  Object get metadata;
  set metadata(Object value);
  String get buyerReportingId;
  set buyerReportingId(String value);
  String get buyerAndSellerReportingId;
  set buyerAndSellerReportingId(String value);
  List<String> get allowedReportingOrigins;
  set allowedReportingOrigins(List<String> value);
}

abstract interface class AuctionAdConfig {
  String get seller;
  set seller(String value);
  String get decisionLogicURL;
  set decisionLogicURL(String value);
  String get trustedScoringSignalsURL;
  set trustedScoringSignalsURL(String value);
  int get maxTrustedScoringSignalsURLLength;
  set maxTrustedScoringSignalsURLLength(int value);
  List<String> get interestGroupBuyers;
  set interestGroupBuyers(List<String> value);
  Future<Object> get auctionSignals;
  set auctionSignals(Future<Object> value);
  Future<Object> get sellerSignals;
  set sellerSignals(Future<Object> value);
  Future<String> get directFromSellerSignalsHeaderAdSlot;
  set directFromSellerSignalsHeaderAdSlot(Future<String> value);
  Future<Map<String, String>> get deprecatedRenderURLReplacements;
  set deprecatedRenderURLReplacements(Future<Map<String, String>> value);
  int get sellerTimeout;
  set sellerTimeout(int value);
  int get sellerExperimentGroupId;
  set sellerExperimentGroupId(int value);
  Future<Map<String, Object>> get perBuyerSignals;
  set perBuyerSignals(Future<Map<String, Object>> value);
  Future<Map<String, int>> get perBuyerTimeouts;
  set perBuyerTimeouts(Future<Map<String, int>> value);
  Future<Map<String, int>> get perBuyerCumulativeTimeouts;
  set perBuyerCumulativeTimeouts(Future<Map<String, int>> value);
  int get reportingTimeout;
  set reportingTimeout(int value);
  String get sellerCurrency;
  set sellerCurrency(String value);
  Future<Map<String, String>> get perBuyerCurrencies;
  set perBuyerCurrencies(Future<Map<String, String>> value);
  Map<String, int> get perBuyerMultiBidLimits;
  set perBuyerMultiBidLimits(Map<String, int> value);
  Map<String, int> get perBuyerGroupLimits;
  set perBuyerGroupLimits(Map<String, int> value);
  Map<String, int> get perBuyerExperimentGroupIds;
  set perBuyerExperimentGroupIds(Map<String, int> value);
  Map<String, Map<String, double>> get perBuyerPrioritySignals;
  set perBuyerPrioritySignals(Map<String, Map<String, double>> value);
  List<String> get requiredSellerCapabilities;
  set requiredSellerCapabilities(List<String> value);
  Map<String, String> get requestedSize;
  set requestedSize(Map<String, String> value);
  List<Map<String, String>> get allSlotsRequestedSizes;
  set allSlotsRequestedSizes(List<Map<String, String>> value);
  Future<void> get additionalBids;
  set additionalBids(Future<void> value);
  String get auctionNonce;
  set auctionNonce(String value);
  List<AuctionAdConfig> get componentAuctions;
  set componentAuctions(List<AuctionAdConfig> value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  Future<bool> get resolveToConfig;
  set resolveToConfig(Future<bool> value);
}

abstract interface class AuctionAdInterestGroup {
  double get priority;
  set priority(double value);
  Map<String, double> get prioritySignalsOverrides;
  set prioritySignalsOverrides(Map<String, double> value);
  String get additionalBidKey;
  set additionalBidKey(String value);
}

abstract interface class AuctionAdInterestGroupKey {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
}

abstract interface class BiddingBrowserSignals {
  String get topWindowHostname;
  set topWindowHostname(String value);
  String get seller;
  set seller(String value);
  int get joinCount;
  set joinCount(int value);
  int get bidCount;
  set bidCount(int value);
  int get recency;
  set recency(int value);
  int get adComponentsLimit;
  set adComponentsLimit(int value);
  int get multiBidLimit;
  set multiBidLimit(int value);
  Map<String, String> get requestedSize;
  set requestedSize(Map<String, String> value);
  String get topLevelSeller;
  set topLevelSeller(String value);
  List<PreviousWin> get prevWinsMs;
  set prevWinsMs(List<PreviousWin> value);
  Object get wasmHelper;
  set wasmHelper(Object value);
  int get dataVersion;
  set dataVersion(int value);
  bool get forDebuggingOnlyInCooldownOrLockout;
  set forDebuggingOnlyInCooldownOrLockout(bool value);
}

abstract interface class DirectFromSellerSignalsForBuyer {
  Object get auctionSignals;
  set auctionSignals(Object value);
  Object get perBuyerSignals;
  set perBuyerSignals(Object value);
}

abstract interface class DirectFromSellerSignalsForSeller {
  Object get auctionSignals;
  set auctionSignals(Object value);
  Object get sellerSignals;
  set sellerSignals(Object value);
}

abstract interface class GenerateBidInterestGroup {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
  double get lifetimeMs;
  set lifetimeMs(double value);
  bool get enableBiddingSignalsPrioritization;
  set enableBiddingSignalsPrioritization(bool value);
  Map<String, double> get priorityVector;
  set priorityVector(Map<String, double> value);
  Map<String, List<String>> get sellerCapabilities;
  set sellerCapabilities(Map<String, List<String>> value);
  String get executionMode;
  set executionMode(String value);
  String get biddingLogicURL;
  set biddingLogicURL(String value);
  String get biddingWasmHelperURL;
  set biddingWasmHelperURL(String value);
  String get updateURL;
  set updateURL(String value);
  String get trustedBiddingSignalsURL;
  set trustedBiddingSignalsURL(String value);
  List<String> get trustedBiddingSignalsKeys;
  set trustedBiddingSignalsKeys(List<String> value);
  String get trustedBiddingSignalsSlotSizeMode;
  set trustedBiddingSignalsSlotSizeMode(String value);
  int get maxTrustedBiddingSignalsURLLength;
  set maxTrustedBiddingSignalsURLLength(int value);
  Object get userBiddingSignals;
  set userBiddingSignals(Object value);
  List<AuctionAd> get ads;
  set ads(List<AuctionAd> value);
  List<AuctionAd> get adComponents;
  set adComponents(List<AuctionAd> value);
}

abstract interface class GenerateBidOutput {
  double get bid;
  set bid(double value);
  String get bidCurrency;
  set bidCurrency(String value);
  Object get render;
  set render(Object value);
  Object get ad;
  set ad(Object value);
  List<Object> get adComponents;
  set adComponents(List<Object> value);
  double get adCost;
  set adCost(double value);
  double get modelingSignals;
  set modelingSignals(double value);
  bool get allowComponentAuction;
  set allowComponentAuction(bool value);
  int get targetNumAdComponents;
  set targetNumAdComponents(int value);
  int get numMandatoryAdComponents;
  set numMandatoryAdComponents(int value);
}

typedef KAnonStatus = String;

abstract interface class PreviousWin {
  int get timeDelta;
  set timeDelta(int value);
  String get adJSON;
  set adJSON(String value);
}

abstract interface class ReportResultBrowserSignals {
  double get desirability;
  set desirability(double value);
  String get topLevelSellerSignals;
  set topLevelSellerSignals(String value);
  double get modifiedBid;
  set modifiedBid(double value);
  int get dataVersion;
  set dataVersion(int value);
}

abstract interface class ReportWinBrowserSignals {
  double get adCost;
  set adCost(double value);
  String get seller;
  set seller(String value);
  bool get madeHighestScoringOtherBid;
  set madeHighestScoringOtherBid(bool value);
  String get interestGroupName;
  set interestGroupName(String value);
  String get buyerReportingId;
  set buyerReportingId(String value);
  int get modelingSignals;
  set modelingSignals(int value);
  int get dataVersion;
  set dataVersion(int value);
  KAnonStatus get kAnonStatus;
  set kAnonStatus(KAnonStatus value);
}

abstract interface class ReportingBrowserSignals {
  String get topWindowHostname;
  set topWindowHostname(String value);
  String get interestGroupOwner;
  set interestGroupOwner(String value);
  String get renderURL;
  set renderURL(String value);
  double get bid;
  set bid(double value);
  double get highestScoringOtherBid;
  set highestScoringOtherBid(double value);
  String get bidCurrency;
  set bidCurrency(String value);
  String get highestScoringOtherBidCurrency;
  set highestScoringOtherBidCurrency(String value);
  String get topLevelSeller;
  set topLevelSeller(String value);
  String get componentSeller;
  set componentSeller(String value);
  String get buyerAndSellerReportingId;
  set buyerAndSellerReportingId(String value);
}

abstract interface class ScoreAdOutput {
  double get desirability;
  set desirability(double value);
  double get bid;
  set bid(double value);
  String get bidCurrency;
  set bidCurrency(String value);
  double get incomingBidInSellerCurrency;
  set incomingBidInSellerCurrency(double value);
  bool get allowComponentAuction;
  set allowComponentAuction(bool value);
}

abstract interface class ScoringBrowserSignals {
  String get topWindowHostname;
  set topWindowHostname(String value);
  String get interestGroupOwner;
  set interestGroupOwner(String value);
  String get renderURL;
  set renderURL(String value);
  int get biddingDurationMsec;
  set biddingDurationMsec(int value);
  String get bidCurrency;
  set bidCurrency(String value);
  Map<String, String> get renderSize;
  set renderSize(Map<String, String> value);
  int get dataVersion;
  set dataVersion(int value);
  List<String> get adComponents;
  set adComponents(List<String> value);
  bool get forDebuggingOnlyInCooldownOrLockout;
  set forDebuggingOnlyInCooldownOrLockout(bool value);
}

