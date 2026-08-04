// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: turtledove
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'private_aggregation_api.dart';

abstract interface class AdAuctionData {
  String get requestId;
  set requestId(String value);
  Object get request;
  set request(Object value);
  List<AdAuctionPerSellerData> get requests;
  set requests(List<AdAuctionPerSellerData> value);
}

abstract interface class AdAuctionDataBuyerConfig {
  int get targetSize;
  set targetSize(int value);
}

abstract interface class AdAuctionDataConfig {
  String get seller;
  set seller(String value);
  String get coordinatorOrigin;
  set coordinatorOrigin(String value);
  List<AdAuctionOneSeller> get sellers;
  set sellers(List<AdAuctionOneSeller> value);
  int get requestSize;
  set requestSize(int value);
  Map<String, AdAuctionDataBuyerConfig> get perBuyerConfig;
  set perBuyerConfig(Map<String, AdAuctionDataBuyerConfig> value);
}

abstract interface class AdAuctionOneSeller {
  String get seller;
  set seller(String value);
  String get coordinatorOrigin;
  set coordinatorOrigin(String value);
}

abstract interface class AdAuctionPerSellerData {
  String get seller;
  set seller(String value);
  Object get request;
  set request(Object value);
  String get error;
  set error(String value);
}

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
  String get sizeGroup;
  set sizeGroup(String value);
  Object get metadata;
  set metadata(Object value);
  String get buyerReportingId;
  set buyerReportingId(String value);
  String get buyerAndSellerReportingId;
  set buyerAndSellerReportingId(String value);
  List<String> get selectableBuyerAndSellerReportingIds;
  set selectableBuyerAndSellerReportingIds(List<String> value);
  List<String> get allowedReportingOrigins;
  set allowedReportingOrigins(List<String> value);
  String get adRenderId;
  set adRenderId(String value);
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
  String get trustedScoringSignalsCoordinator;
  set trustedScoringSignalsCoordinator(String value);
  List<String> get interestGroupBuyers;
  set interestGroupBuyers(List<String> value);
  Future<Object> get auctionSignals;
  set auctionSignals(Future<Object> value);
  Future<Object> get sellerSignals;
  set sellerSignals(Future<Object> value);
  Future<String?> get directFromSellerSignalsHeaderAdSlot;
  set directFromSellerSignalsHeaderAdSlot(Future<String?> value);
  Future<Map<String, String>?> get deprecatedRenderURLReplacements;
  set deprecatedRenderURLReplacements(Future<Map<String, String>?> value);
  int get sellerTimeout;
  set sellerTimeout(int value);
  int get sellerExperimentGroupId;
  set sellerExperimentGroupId(int value);
  Future<Map<String, Object>?> get perBuyerSignals;
  set perBuyerSignals(Future<Map<String, Object>?> value);
  Future<Map<String, int>?> get perBuyerTimeouts;
  set perBuyerTimeouts(Future<Map<String, int>?> value);
  Future<Map<String, int>?> get perBuyerCumulativeTimeouts;
  set perBuyerCumulativeTimeouts(Future<Map<String, int>?> value);
  int get reportingTimeout;
  set reportingTimeout(int value);
  String get sellerCurrency;
  set sellerCurrency(String value);
  Future<Map<String, String>?> get perBuyerCurrencies;
  set perBuyerCurrencies(Future<Map<String, String>?> value);
  Map<String, int> get perBuyerMultiBidLimits;
  set perBuyerMultiBidLimits(Map<String, int> value);
  Map<String, int> get perBuyerGroupLimits;
  set perBuyerGroupLimits(Map<String, int> value);
  Map<String, int> get perBuyerExperimentGroupIds;
  set perBuyerExperimentGroupIds(Map<String, int> value);
  Map<String, Map<String, double>> get perBuyerPrioritySignals;
  set perBuyerPrioritySignals(Map<String, Map<String, double>> value);
  List<Object> get auctionReportBuyerKeys;
  set auctionReportBuyerKeys(List<Object> value);
  Map<String, AuctionReportBuyersConfig> get auctionReportBuyers;
  set auctionReportBuyers(Map<String, AuctionReportBuyersConfig> value);
  AuctionReportBuyerDebugModeConfig get auctionReportBuyerDebugModeConfig;
  set auctionReportBuyerDebugModeConfig(AuctionReportBuyerDebugModeConfig value);
  List<String> get requiredSellerCapabilities;
  set requiredSellerCapabilities(List<String> value);
  ProtectedAudiencePrivateAggregationConfig get privateAggregationConfig;
  set privateAggregationConfig(ProtectedAudiencePrivateAggregationConfig value);
  Map<String, String> get requestedSize;
  set requestedSize(Map<String, String> value);
  List<Map<String, String>> get allSlotsRequestedSizes;
  set allSlotsRequestedSizes(List<Map<String, String>> value);
  Future<void> get additionalBids;
  set additionalBids(Future<void> value);
  String get auctionNonce;
  set auctionNonce(String value);
  AuctionRealTimeReportingConfig get sellerRealTimeReportingConfig;
  set sellerRealTimeReportingConfig(AuctionRealTimeReportingConfig value);
  Map<String, AuctionRealTimeReportingConfig> get perBuyerRealTimeReportingConfig;
  set perBuyerRealTimeReportingConfig(Map<String, AuctionRealTimeReportingConfig> value);
  List<AuctionAdConfig> get componentAuctions;
  set componentAuctions(List<AuctionAdConfig> value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  Future<bool> get resolveToConfig;
  set resolveToConfig(Future<bool> value);
  Future<Object> get serverResponse;
  set serverResponse(Future<Object> value);
  String get requestId;
  set requestId(String value);
}

abstract interface class AuctionAdInterestGroup {
  double get priority;
  set priority(double value);
  Map<String, double> get prioritySignalsOverrides;
  set prioritySignalsOverrides(Map<String, double> value);
  double get lifetimeMs;
  set lifetimeMs(double value);
  String get additionalBidKey;
  set additionalBidKey(String value);
  ProtectedAudiencePrivateAggregationConfig get privateAggregationConfig;
  set privateAggregationConfig(ProtectedAudiencePrivateAggregationConfig value);
}

abstract interface class AuctionAdInterestGroupKey {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
}

abstract interface class AuctionAdInterestGroupSize {
  String get width;
  set width(String value);
  String get height;
  set height(String value);
}

abstract interface class AuctionRealTimeReportingConfig {
  String get type;
  set type(String value);
}

abstract interface class AuctionReportBuyerDebugModeConfig {
  bool get enabled;
  set enabled(bool value);
  Object get debugKey;
  set debugKey(Object value);
}

abstract interface class AuctionReportBuyersConfig {
  Object get bucket;
  set bucket(Object value);
  double get scale;
  set scale(double value);
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
  int get crossOriginDataVersion;
  set crossOriginDataVersion(int value);
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

abstract interface class ForDebuggingOnly {
  void reportAdAuctionWin(String url);
  void reportAdAuctionLoss(String url);
}

abstract interface class GenerateBidInterestGroup {
  String get owner;
  set owner(String value);
  String get name;
  set name(String value);
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
  String get trustedBiddingSignalsCoordinator;
  set trustedBiddingSignalsCoordinator(String value);
  Object get userBiddingSignals;
  set userBiddingSignals(Object value);
  List<AuctionAd> get ads;
  set ads(List<AuctionAd> value);
  List<AuctionAd> get adComponents;
  set adComponents(List<AuctionAd> value);
  Map<String, AuctionAdInterestGroupSize> get adSizes;
  set adSizes(Map<String, AuctionAdInterestGroupSize> value);
  Map<String, List<String>> get sizeGroups;
  set sizeGroups(Map<String, List<String>> value);
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
  String get selectedBuyerAndSellerReportingId;
  set selectedBuyerAndSellerReportingId(String value);
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

abstract interface class InterestGroupBiddingAndScoringScriptRunnerGlobalScope {
  ForDebuggingOnly get forDebuggingOnly;
  RealTimeReporting get realTimeReporting;
}

abstract interface class InterestGroupBiddingScriptRunnerGlobalScope {
  bool setBid([Object? oneOrManyBids]);
  void setPriority(double priority);
  void setPrioritySignalsOverride(String key, [double? priority]);
}

abstract interface class InterestGroupReportingScriptRunnerGlobalScope {
  void sendReportTo(String url);
  void registerAdBeacon(Map<String, String> map);
  void registerAdMacro(String name, String value);
}

abstract interface class InterestGroupScoringScriptRunnerGlobalScope {
}

abstract interface class InterestGroupScriptRunnerGlobalScope {
  PrivateAggregation? get privateAggregation;
}

typedef KAnonStatus = String;

abstract interface class PAExtendedHistogramContribution {
  Object get bucket;
  set bucket(Object value);
  Object get value;
  set value(Object value);
  Object get filteringId;
  set filteringId(Object value);
}

abstract interface class PASignalValue {
  String get baseValue;
  set baseValue(String value);
  double get scale;
  set scale(double value);
  Object get offset;
  set offset(Object value);
}

typedef PreviousWin = List<PreviousWinElement>;

typedef PreviousWinElement = Object;

abstract interface class ProtectedAudience {
  Object queryFeatureSupport(String feature);
}

abstract interface class ProtectedAudiencePrivateAggregationConfig {
  String get aggregationCoordinatorOrigin;
  set aggregationCoordinatorOrigin(String value);
}

abstract interface class RealTimeContribution {
  int get bucket;
  set bucket(int value);
  double get priorityWeight;
  set priorityWeight(double value);
  int get latencyThreshold;
  set latencyThreshold(int value);
}

abstract interface class RealTimeReporting {
  void contributeToHistogram(RealTimeContribution contribution);
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
  String get selectedBuyerAndSellerReportingId;
  set selectedBuyerAndSellerReportingId(String value);
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
  int get crossOriginDataVersion;
  set crossOriginDataVersion(int value);
  List<String> get adComponents;
  set adComponents(List<String> value);
  bool get forDebuggingOnlyInCooldownOrLockout;
  set forDebuggingOnlyInCooldownOrLockout(bool value);
}

abstract interface class StorageInterestGroup {
  int get joinCount;
  set joinCount(int value);
  int get bidCount;
  set bidCount(int value);
  List<PreviousWin> get prevWinsMs;
  set prevWinsMs(List<PreviousWin> value);
  String get joiningOrigin;
  set joiningOrigin(String value);
  int get timeSinceGroupJoinedMs;
  set timeSinceGroupJoinedMs(int value);
  int get lifetimeRemainingMs;
  set lifetimeRemainingMs(int value);
  int get timeSinceLastUpdateMs;
  set timeSinceLastUpdateMs(int value);
  int get timeUntilNextUpdateMs;
  set timeUntilNextUpdateMs(int value);
  int get estimatedSize;
  set estimatedSize(int value);
}

