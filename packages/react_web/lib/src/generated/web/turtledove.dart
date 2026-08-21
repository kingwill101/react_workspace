// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: turtledove
// ignore_for_file: type=lint

import 'dom.dart';

abstract interface class AdRender {
  String get url;
  set url(String value);
  String? get width;
  set width(String? value);
  String? get height;
  set height(String? value);
}

final class AdRenderValue implements AdRender {
  @override
  String url;
  @override
  String? width;
  @override
  String? height;

  AdRenderValue({required this.url, this.width, this.height});
}

abstract interface class AuctionAd {
  String get renderURL;
  set renderURL(String value);
  Object? get metadata;
  set metadata(Object? value);
  String? get buyerReportingId;
  set buyerReportingId(String? value);
  String? get buyerAndSellerReportingId;
  set buyerAndSellerReportingId(String? value);
  List<String>? get allowedReportingOrigins;
  set allowedReportingOrigins(List<String>? value);
}

final class AuctionAdValue implements AuctionAd {
  @override
  String renderURL;
  @override
  Object? metadata;
  @override
  String? buyerReportingId;
  @override
  String? buyerAndSellerReportingId;
  @override
  List<String>? allowedReportingOrigins;

  AuctionAdValue({
    required this.renderURL,
    this.metadata,
    this.buyerReportingId,
    this.buyerAndSellerReportingId,
    this.allowedReportingOrigins,
  });
}

abstract interface class AuctionAdConfig {
  String get seller;
  set seller(String value);
  String get decisionLogicURL;
  set decisionLogicURL(String value);
  String? get trustedScoringSignalsURL;
  set trustedScoringSignalsURL(String? value);
  int? get maxTrustedScoringSignalsURLLength;
  set maxTrustedScoringSignalsURLLength(int? value);
  List<String>? get interestGroupBuyers;
  set interestGroupBuyers(List<String>? value);
  Future<Object>? get auctionSignals;
  set auctionSignals(Future<Object>? value);
  Future<Object>? get sellerSignals;
  set sellerSignals(Future<Object>? value);
  Future<String>? get directFromSellerSignalsHeaderAdSlot;
  set directFromSellerSignalsHeaderAdSlot(Future<String>? value);
  Future<Map<String, String>>? get deprecatedRenderURLReplacements;
  set deprecatedRenderURLReplacements(Future<Map<String, String>>? value);
  int? get sellerTimeout;
  set sellerTimeout(int? value);
  int? get sellerExperimentGroupId;
  set sellerExperimentGroupId(int? value);
  Future<Map<String, Object>>? get perBuyerSignals;
  set perBuyerSignals(Future<Map<String, Object>>? value);
  Future<Map<String, int>>? get perBuyerTimeouts;
  set perBuyerTimeouts(Future<Map<String, int>>? value);
  Future<Map<String, int>>? get perBuyerCumulativeTimeouts;
  set perBuyerCumulativeTimeouts(Future<Map<String, int>>? value);
  int? get reportingTimeout;
  set reportingTimeout(int? value);
  String? get sellerCurrency;
  set sellerCurrency(String? value);
  Future<Map<String, String>>? get perBuyerCurrencies;
  set perBuyerCurrencies(Future<Map<String, String>>? value);
  Map<String, int>? get perBuyerMultiBidLimits;
  set perBuyerMultiBidLimits(Map<String, int>? value);
  Map<String, int>? get perBuyerGroupLimits;
  set perBuyerGroupLimits(Map<String, int>? value);
  Map<String, int>? get perBuyerExperimentGroupIds;
  set perBuyerExperimentGroupIds(Map<String, int>? value);
  Map<String, Map<String, double>>? get perBuyerPrioritySignals;
  set perBuyerPrioritySignals(Map<String, Map<String, double>>? value);
  List<String>? get requiredSellerCapabilities;
  set requiredSellerCapabilities(List<String>? value);
  Map<String, String>? get requestedSize;
  set requestedSize(Map<String, String>? value);
  List<Map<String, String>>? get allSlotsRequestedSizes;
  set allSlotsRequestedSizes(List<Map<String, String>>? value);
  Future<void>? get additionalBids;
  set additionalBids(Future<void>? value);
  String? get auctionNonce;
  set auctionNonce(String? value);
  List<AuctionAdConfig>? get componentAuctions;
  set componentAuctions(List<AuctionAdConfig>? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  Future<bool>? get resolveToConfig;
  set resolveToConfig(Future<bool>? value);
}

final class AuctionAdConfigValue implements AuctionAdConfig {
  @override
  String seller;
  @override
  String decisionLogicURL;
  @override
  String? trustedScoringSignalsURL;
  @override
  int? maxTrustedScoringSignalsURLLength;
  @override
  List<String>? interestGroupBuyers;
  @override
  Future<Object>? auctionSignals;
  @override
  Future<Object>? sellerSignals;
  @override
  Future<String>? directFromSellerSignalsHeaderAdSlot;
  @override
  Future<Map<String, String>>? deprecatedRenderURLReplacements;
  @override
  int? sellerTimeout;
  @override
  int? sellerExperimentGroupId;
  @override
  Future<Map<String, Object>>? perBuyerSignals;
  @override
  Future<Map<String, int>>? perBuyerTimeouts;
  @override
  Future<Map<String, int>>? perBuyerCumulativeTimeouts;
  @override
  int? reportingTimeout;
  @override
  String? sellerCurrency;
  @override
  Future<Map<String, String>>? perBuyerCurrencies;
  @override
  Map<String, int>? perBuyerMultiBidLimits;
  @override
  Map<String, int>? perBuyerGroupLimits;
  @override
  Map<String, int>? perBuyerExperimentGroupIds;
  @override
  Map<String, Map<String, double>>? perBuyerPrioritySignals;
  @override
  List<String>? requiredSellerCapabilities;
  @override
  Map<String, String>? requestedSize;
  @override
  List<Map<String, String>>? allSlotsRequestedSizes;
  @override
  Future<void>? additionalBids;
  @override
  String? auctionNonce;
  @override
  List<AuctionAdConfig>? componentAuctions;
  @override
  AbortSignal? signal;
  @override
  Future<bool>? resolveToConfig;

  AuctionAdConfigValue({
    required this.seller,
    required this.decisionLogicURL,
    this.trustedScoringSignalsURL,
    this.maxTrustedScoringSignalsURLLength,
    this.interestGroupBuyers,
    this.auctionSignals,
    this.sellerSignals,
    this.directFromSellerSignalsHeaderAdSlot,
    this.deprecatedRenderURLReplacements,
    this.sellerTimeout,
    this.sellerExperimentGroupId,
    this.perBuyerSignals,
    this.perBuyerTimeouts,
    this.perBuyerCumulativeTimeouts,
    this.reportingTimeout,
    this.sellerCurrency,
    this.perBuyerCurrencies,
    this.perBuyerMultiBidLimits,
    this.perBuyerGroupLimits,
    this.perBuyerExperimentGroupIds,
    this.perBuyerPrioritySignals,
    this.requiredSellerCapabilities,
    this.requestedSize,
    this.allSlotsRequestedSizes,
    this.additionalBids,
    this.auctionNonce,
    this.componentAuctions,
    this.signal,
    this.resolveToConfig,
  });
}

abstract interface class AuctionAdInterestGroup {
  double? get priority;
  set priority(double? value);
  Map<String, double>? get prioritySignalsOverrides;
  set prioritySignalsOverrides(Map<String, double>? value);
  String? get additionalBidKey;
  set additionalBidKey(String? value);
}

final class AuctionAdInterestGroupValue implements AuctionAdInterestGroup {
  @override
  double? priority;
  @override
  Map<String, double>? prioritySignalsOverrides;
  @override
  String? additionalBidKey;

  AuctionAdInterestGroupValue({
    this.priority,
    this.prioritySignalsOverrides,
    this.additionalBidKey,
  });
}

abstract interface class AuctionAdInterestGroupKey {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
}

final class AuctionAdInterestGroupKeyValue
    implements AuctionAdInterestGroupKey {
  @override
  String owner;
  @override
  String name;

  AuctionAdInterestGroupKeyValue({required this.owner, required this.name});
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
  Map<String, String>? get requestedSize;
  set requestedSize(Map<String, String>? value);
  String? get topLevelSeller;
  set topLevelSeller(String? value);
  List<PreviousWin>? get prevWinsMs;
  set prevWinsMs(List<PreviousWin>? value);
  Object? get wasmHelper;
  set wasmHelper(Object? value);
  int? get dataVersion;
  set dataVersion(int? value);
  bool? get forDebuggingOnlyInCooldownOrLockout;
  set forDebuggingOnlyInCooldownOrLockout(bool? value);
}

final class BiddingBrowserSignalsValue implements BiddingBrowserSignals {
  @override
  String topWindowHostname;
  @override
  String seller;
  @override
  int joinCount;
  @override
  int bidCount;
  @override
  int recency;
  @override
  int adComponentsLimit;
  @override
  int multiBidLimit;
  @override
  Map<String, String>? requestedSize;
  @override
  String? topLevelSeller;
  @override
  List<PreviousWin>? prevWinsMs;
  @override
  Object? wasmHelper;
  @override
  int? dataVersion;
  @override
  bool? forDebuggingOnlyInCooldownOrLockout;

  BiddingBrowserSignalsValue({
    required this.topWindowHostname,
    required this.seller,
    required this.joinCount,
    required this.bidCount,
    required this.recency,
    required this.adComponentsLimit,
    required this.multiBidLimit,
    this.requestedSize,
    this.topLevelSeller,
    this.prevWinsMs,
    this.wasmHelper,
    this.dataVersion,
    this.forDebuggingOnlyInCooldownOrLockout,
  });
}

abstract interface class DirectFromSellerSignalsForBuyer {
  Object? get auctionSignals;
  set auctionSignals(Object? value);
  Object? get perBuyerSignals;
  set perBuyerSignals(Object? value);
}

final class DirectFromSellerSignalsForBuyerValue
    implements DirectFromSellerSignalsForBuyer {
  @override
  Object? auctionSignals;
  @override
  Object? perBuyerSignals;

  DirectFromSellerSignalsForBuyerValue({
    this.auctionSignals,
    this.perBuyerSignals,
  });
}

abstract interface class DirectFromSellerSignalsForSeller {
  Object? get auctionSignals;
  set auctionSignals(Object? value);
  Object? get sellerSignals;
  set sellerSignals(Object? value);
}

final class DirectFromSellerSignalsForSellerValue
    implements DirectFromSellerSignalsForSeller {
  @override
  Object? auctionSignals;
  @override
  Object? sellerSignals;

  DirectFromSellerSignalsForSellerValue({
    this.auctionSignals,
    this.sellerSignals,
  });
}

abstract interface class GenerateBidInterestGroup {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
  double get lifetimeMs;
  set lifetimeMs(double value);
  bool? get enableBiddingSignalsPrioritization;
  set enableBiddingSignalsPrioritization(bool? value);
  Map<String, double>? get priorityVector;
  set priorityVector(Map<String, double>? value);
  Map<String, List<String>>? get sellerCapabilities;
  set sellerCapabilities(Map<String, List<String>>? value);
  String? get executionMode;
  set executionMode(String? value);
  String? get biddingLogicURL;
  set biddingLogicURL(String? value);
  String? get biddingWasmHelperURL;
  set biddingWasmHelperURL(String? value);
  String? get updateURL;
  set updateURL(String? value);
  String? get trustedBiddingSignalsURL;
  set trustedBiddingSignalsURL(String? value);
  List<String>? get trustedBiddingSignalsKeys;
  set trustedBiddingSignalsKeys(List<String>? value);
  String? get trustedBiddingSignalsSlotSizeMode;
  set trustedBiddingSignalsSlotSizeMode(String? value);
  int? get maxTrustedBiddingSignalsURLLength;
  set maxTrustedBiddingSignalsURLLength(int? value);
  Object? get userBiddingSignals;
  set userBiddingSignals(Object? value);
  List<AuctionAd>? get ads;
  set ads(List<AuctionAd>? value);
  List<AuctionAd>? get adComponents;
  set adComponents(List<AuctionAd>? value);
}

final class GenerateBidInterestGroupValue implements GenerateBidInterestGroup {
  @override
  String owner;
  @override
  String name;
  @override
  double lifetimeMs;
  @override
  bool? enableBiddingSignalsPrioritization;
  @override
  Map<String, double>? priorityVector;
  @override
  Map<String, List<String>>? sellerCapabilities;
  @override
  String? executionMode;
  @override
  String? biddingLogicURL;
  @override
  String? biddingWasmHelperURL;
  @override
  String? updateURL;
  @override
  String? trustedBiddingSignalsURL;
  @override
  List<String>? trustedBiddingSignalsKeys;
  @override
  String? trustedBiddingSignalsSlotSizeMode;
  @override
  int? maxTrustedBiddingSignalsURLLength;
  @override
  Object? userBiddingSignals;
  @override
  List<AuctionAd>? ads;
  @override
  List<AuctionAd>? adComponents;

  GenerateBidInterestGroupValue({
    required this.owner,
    required this.name,
    required this.lifetimeMs,
    this.enableBiddingSignalsPrioritization,
    this.priorityVector,
    this.sellerCapabilities,
    this.executionMode,
    this.biddingLogicURL,
    this.biddingWasmHelperURL,
    this.updateURL,
    this.trustedBiddingSignalsURL,
    this.trustedBiddingSignalsKeys,
    this.trustedBiddingSignalsSlotSizeMode,
    this.maxTrustedBiddingSignalsURLLength,
    this.userBiddingSignals,
    this.ads,
    this.adComponents,
  });
}

abstract interface class GenerateBidOutput {
  double? get bid;
  set bid(double? value);
  String? get bidCurrency;
  set bidCurrency(String? value);
  Object? get render;
  set render(Object? value);
  Object? get ad;
  set ad(Object? value);
  List<Object>? get adComponents;
  set adComponents(List<Object>? value);
  double? get adCost;
  set adCost(double? value);
  double? get modelingSignals;
  set modelingSignals(double? value);
  bool? get allowComponentAuction;
  set allowComponentAuction(bool? value);
  int? get targetNumAdComponents;
  set targetNumAdComponents(int? value);
  int? get numMandatoryAdComponents;
  set numMandatoryAdComponents(int? value);
}

final class GenerateBidOutputValue implements GenerateBidOutput {
  @override
  double? bid;
  @override
  String? bidCurrency;
  @override
  Object? render;
  @override
  Object? ad;
  @override
  List<Object>? adComponents;
  @override
  double? adCost;
  @override
  double? modelingSignals;
  @override
  bool? allowComponentAuction;
  @override
  int? targetNumAdComponents;
  @override
  int? numMandatoryAdComponents;

  GenerateBidOutputValue({
    this.bid,
    this.bidCurrency,
    this.render,
    this.ad,
    this.adComponents,
    this.adCost,
    this.modelingSignals,
    this.allowComponentAuction,
    this.targetNumAdComponents,
    this.numMandatoryAdComponents,
  });
}

typedef KAnonStatus = String;

abstract interface class PreviousWin {
  int get timeDelta;
  set timeDelta(int value);
  String get adJSON;
  set adJSON(String value);
}

final class PreviousWinValue implements PreviousWin {
  @override
  int timeDelta;
  @override
  String adJSON;

  PreviousWinValue({required this.timeDelta, required this.adJSON});
}

abstract interface class ReportResultBrowserSignals {
  double get desirability;
  set desirability(double value);
  String? get topLevelSellerSignals;
  set topLevelSellerSignals(String? value);
  double? get modifiedBid;
  set modifiedBid(double? value);
  int? get dataVersion;
  set dataVersion(int? value);
}

final class ReportResultBrowserSignalsValue
    implements ReportResultBrowserSignals {
  @override
  double desirability;
  @override
  String? topLevelSellerSignals;
  @override
  double? modifiedBid;
  @override
  int? dataVersion;

  ReportResultBrowserSignalsValue({
    required this.desirability,
    this.topLevelSellerSignals,
    this.modifiedBid,
    this.dataVersion,
  });
}

abstract interface class ReportWinBrowserSignals {
  double? get adCost;
  set adCost(double? value);
  String? get seller;
  set seller(String? value);
  bool? get madeHighestScoringOtherBid;
  set madeHighestScoringOtherBid(bool? value);
  String? get interestGroupName;
  set interestGroupName(String? value);
  String? get buyerReportingId;
  set buyerReportingId(String? value);
  int? get modelingSignals;
  set modelingSignals(int? value);
  int? get dataVersion;
  set dataVersion(int? value);
  KAnonStatus? get kAnonStatus;
  set kAnonStatus(KAnonStatus? value);
}

final class ReportWinBrowserSignalsValue implements ReportWinBrowserSignals {
  @override
  double? adCost;
  @override
  String? seller;
  @override
  bool? madeHighestScoringOtherBid;
  @override
  String? interestGroupName;
  @override
  String? buyerReportingId;
  @override
  int? modelingSignals;
  @override
  int? dataVersion;
  @override
  KAnonStatus? kAnonStatus;

  ReportWinBrowserSignalsValue({
    this.adCost,
    this.seller,
    this.madeHighestScoringOtherBid,
    this.interestGroupName,
    this.buyerReportingId,
    this.modelingSignals,
    this.dataVersion,
    this.kAnonStatus,
  });
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
  String? get bidCurrency;
  set bidCurrency(String? value);
  String? get highestScoringOtherBidCurrency;
  set highestScoringOtherBidCurrency(String? value);
  String? get topLevelSeller;
  set topLevelSeller(String? value);
  String? get componentSeller;
  set componentSeller(String? value);
  String? get buyerAndSellerReportingId;
  set buyerAndSellerReportingId(String? value);
}

final class ReportingBrowserSignalsValue implements ReportingBrowserSignals {
  @override
  String topWindowHostname;
  @override
  String interestGroupOwner;
  @override
  String renderURL;
  @override
  double bid;
  @override
  double highestScoringOtherBid;
  @override
  String? bidCurrency;
  @override
  String? highestScoringOtherBidCurrency;
  @override
  String? topLevelSeller;
  @override
  String? componentSeller;
  @override
  String? buyerAndSellerReportingId;

  ReportingBrowserSignalsValue({
    required this.topWindowHostname,
    required this.interestGroupOwner,
    required this.renderURL,
    required this.bid,
    required this.highestScoringOtherBid,
    this.bidCurrency,
    this.highestScoringOtherBidCurrency,
    this.topLevelSeller,
    this.componentSeller,
    this.buyerAndSellerReportingId,
  });
}

abstract interface class ScoreAdOutput {
  double get desirability;
  set desirability(double value);
  double? get bid;
  set bid(double? value);
  String? get bidCurrency;
  set bidCurrency(String? value);
  double? get incomingBidInSellerCurrency;
  set incomingBidInSellerCurrency(double? value);
  bool? get allowComponentAuction;
  set allowComponentAuction(bool? value);
}

final class ScoreAdOutputValue implements ScoreAdOutput {
  @override
  double desirability;
  @override
  double? bid;
  @override
  String? bidCurrency;
  @override
  double? incomingBidInSellerCurrency;
  @override
  bool? allowComponentAuction;

  ScoreAdOutputValue({
    required this.desirability,
    this.bid,
    this.bidCurrency,
    this.incomingBidInSellerCurrency,
    this.allowComponentAuction,
  });
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
  Map<String, String>? get renderSize;
  set renderSize(Map<String, String>? value);
  int? get dataVersion;
  set dataVersion(int? value);
  List<String>? get adComponents;
  set adComponents(List<String>? value);
  bool? get forDebuggingOnlyInCooldownOrLockout;
  set forDebuggingOnlyInCooldownOrLockout(bool? value);
}

final class ScoringBrowserSignalsValue implements ScoringBrowserSignals {
  @override
  String topWindowHostname;
  @override
  String interestGroupOwner;
  @override
  String renderURL;
  @override
  int biddingDurationMsec;
  @override
  String bidCurrency;
  @override
  Map<String, String>? renderSize;
  @override
  int? dataVersion;
  @override
  List<String>? adComponents;
  @override
  bool? forDebuggingOnlyInCooldownOrLockout;

  ScoringBrowserSignalsValue({
    required this.topWindowHostname,
    required this.interestGroupOwner,
    required this.renderURL,
    required this.biddingDurationMsec,
    required this.bidCurrency,
    this.renderSize,
    this.dataVersion,
    this.adComponents,
    this.forDebuggingOnlyInCooldownOrLockout,
  });
}
