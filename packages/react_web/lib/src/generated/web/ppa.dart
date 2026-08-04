// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ppa
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class PrivateAttribution {
  PrivateAttributionAggregationServices get aggregationServices;
  void saveImpression(PrivateAttributionImpressionOptions options);
  Future<PrivateAttributionConversionResult> measureConversion(PrivateAttributionConversionOptions options);
}

abstract interface class PrivateAttributionAggregationService {
  String get url;
  set url(String value);
  String get protocol;
  set protocol(String value);
}

abstract interface class PrivateAttributionAggregationServices {
   Iterable<PrivateAttributionAggregationService> get values;
   bool has(Object value);
}

abstract interface class PrivateAttributionConversionOptions {
  String get aggregationService;
  set aggregationService(String value);
  double get epsilon;
  set epsilon(double value);
  int get histogramSize;
  set histogramSize(int value);
  PrivateAttributionLogic get logic;
  set logic(PrivateAttributionLogic value);
  int get value;
  set value(int value);
  int get maxValue;
  set maxValue(int value);
  int get lookbackDays;
  set lookbackDays(int value);
  int get filterData;
  set filterData(int value);
  List<String> get impressionSites;
  set impressionSites(List<String> value);
  List<String> get intermediarySites;
  set intermediarySites(List<String> value);
}

abstract interface class PrivateAttributionConversionResult {
  Object get report;
  set report(Object value);
}

abstract interface class PrivateAttributionImpressionOptions {
  int get histogramIndex;
  set histogramIndex(int value);
  int get filterData;
  set filterData(int value);
  String get conversionSite;
  set conversionSite(String value);
  int get lifetimeDays;
  set lifetimeDays(int value);
}

typedef PrivateAttributionLogic = String;

typedef PrivateAttributionProtocol = String;

