// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webhid
// ignore_for_file: type=lint

abstract interface class HIDCollectionInfo {
  int? get usagePage;
  set usagePage(int? value);
  int? get usage;
  set usage(int? value);
  Object? get type_;
  set type_(Object? value);
  List<HIDCollectionInfo>? get children;
  set children(List<HIDCollectionInfo>? value);
  List<HIDReportInfo>? get inputReports;
  set inputReports(List<HIDReportInfo>? value);
  List<HIDReportInfo>? get outputReports;
  set outputReports(List<HIDReportInfo>? value);
  List<HIDReportInfo>? get featureReports;
  set featureReports(List<HIDReportInfo>? value);
}

final class HIDCollectionInfoValue implements HIDCollectionInfo {
  @override
  int? usagePage;
  @override
  int? usage;
  @override
  Object? type_;
  @override
  List<HIDCollectionInfo>? children;
  @override
  List<HIDReportInfo>? inputReports;
  @override
  List<HIDReportInfo>? outputReports;
  @override
  List<HIDReportInfo>? featureReports;

  HIDCollectionInfoValue({
    this.usagePage,
    this.usage,
    this.type_,
    this.children,
    this.inputReports,
    this.outputReports,
    this.featureReports,
  });
}

abstract interface class HIDConnectionEventInit {
  Object get device;
  set device(Object value);
}

final class HIDConnectionEventInitValue implements HIDConnectionEventInit {
  @override
  Object device;

  HIDConnectionEventInitValue({required this.device});
}

abstract interface class HIDDeviceFilter {
  int? get vendorId;
  set vendorId(int? value);
  int? get productId;
  set productId(int? value);
  int? get usagePage;
  set usagePage(int? value);
  int? get usage;
  set usage(int? value);
}

final class HIDDeviceFilterValue implements HIDDeviceFilter {
  @override
  int? vendorId;
  @override
  int? productId;
  @override
  int? usagePage;
  @override
  int? usage;

  HIDDeviceFilterValue({
    this.vendorId,
    this.productId,
    this.usagePage,
    this.usage,
  });
}

abstract interface class HIDDeviceRequestOptions {
  List<HIDDeviceFilter> get filters;
  set filters(List<HIDDeviceFilter> value);
  List<HIDDeviceFilter>? get exclusionFilters;
  set exclusionFilters(List<HIDDeviceFilter>? value);
}

final class HIDDeviceRequestOptionsValue implements HIDDeviceRequestOptions {
  @override
  List<HIDDeviceFilter> filters;
  @override
  List<HIDDeviceFilter>? exclusionFilters;

  HIDDeviceRequestOptionsValue({required this.filters, this.exclusionFilters});
}

abstract interface class HIDInputReportEventInit {
  Object get device;
  set device(Object value);
  Object get reportId;
  set reportId(Object value);
  Object get data;
  set data(Object value);
}

final class HIDInputReportEventInitValue implements HIDInputReportEventInit {
  @override
  Object device;
  @override
  Object reportId;
  @override
  Object data;

  HIDInputReportEventInitValue({
    required this.device,
    required this.reportId,
    required this.data,
  });
}

abstract interface class HIDReportInfo {
  Object? get reportId;
  set reportId(Object? value);
  List<HIDReportItem>? get items;
  set items(List<HIDReportItem>? value);
}

final class HIDReportInfoValue implements HIDReportInfo {
  @override
  Object? reportId;
  @override
  List<HIDReportItem>? items;

  HIDReportInfoValue({this.reportId, this.items});
}

abstract interface class HIDReportItem {
  bool? get isAbsolute;
  set isAbsolute(bool? value);
  bool? get isArray;
  set isArray(bool? value);
  bool? get isBufferedBytes;
  set isBufferedBytes(bool? value);
  bool? get isConstant;
  set isConstant(bool? value);
  bool? get isLinear;
  set isLinear(bool? value);
  bool? get isRange;
  set isRange(bool? value);
  bool? get isVolatile;
  set isVolatile(bool? value);
  bool? get hasNull;
  set hasNull(bool? value);
  bool? get hasPreferredState;
  set hasPreferredState(bool? value);
  bool? get wrap;
  set wrap(bool? value);
  List<int>? get usages;
  set usages(List<int>? value);
  int? get usageMinimum;
  set usageMinimum(int? value);
  int? get usageMaximum;
  set usageMaximum(int? value);
  int? get reportSize;
  set reportSize(int? value);
  int? get reportCount;
  set reportCount(int? value);
  int? get unitExponent;
  set unitExponent(int? value);
  HIDUnitSystem? get unitSystem;
  set unitSystem(HIDUnitSystem? value);
  int? get unitFactorLengthExponent;
  set unitFactorLengthExponent(int? value);
  int? get unitFactorMassExponent;
  set unitFactorMassExponent(int? value);
  int? get unitFactorTimeExponent;
  set unitFactorTimeExponent(int? value);
  int? get unitFactorTemperatureExponent;
  set unitFactorTemperatureExponent(int? value);
  int? get unitFactorCurrentExponent;
  set unitFactorCurrentExponent(int? value);
  int? get unitFactorLuminousIntensityExponent;
  set unitFactorLuminousIntensityExponent(int? value);
  int? get logicalMinimum;
  set logicalMinimum(int? value);
  int? get logicalMaximum;
  set logicalMaximum(int? value);
  int? get physicalMinimum;
  set physicalMinimum(int? value);
  int? get physicalMaximum;
  set physicalMaximum(int? value);
  List<String>? get strings;
  set strings(List<String>? value);
}

final class HIDReportItemValue implements HIDReportItem {
  @override
  bool? isAbsolute;
  @override
  bool? isArray;
  @override
  bool? isBufferedBytes;
  @override
  bool? isConstant;
  @override
  bool? isLinear;
  @override
  bool? isRange;
  @override
  bool? isVolatile;
  @override
  bool? hasNull;
  @override
  bool? hasPreferredState;
  @override
  bool? wrap;
  @override
  List<int>? usages;
  @override
  int? usageMinimum;
  @override
  int? usageMaximum;
  @override
  int? reportSize;
  @override
  int? reportCount;
  @override
  int? unitExponent;
  @override
  HIDUnitSystem? unitSystem;
  @override
  int? unitFactorLengthExponent;
  @override
  int? unitFactorMassExponent;
  @override
  int? unitFactorTimeExponent;
  @override
  int? unitFactorTemperatureExponent;
  @override
  int? unitFactorCurrentExponent;
  @override
  int? unitFactorLuminousIntensityExponent;
  @override
  int? logicalMinimum;
  @override
  int? logicalMaximum;
  @override
  int? physicalMinimum;
  @override
  int? physicalMaximum;
  @override
  List<String>? strings;

  HIDReportItemValue({
    this.isAbsolute,
    this.isArray,
    this.isBufferedBytes,
    this.isConstant,
    this.isLinear,
    this.isRange,
    this.isVolatile,
    this.hasNull,
    this.hasPreferredState,
    this.wrap,
    this.usages,
    this.usageMinimum,
    this.usageMaximum,
    this.reportSize,
    this.reportCount,
    this.unitExponent,
    this.unitSystem,
    this.unitFactorLengthExponent,
    this.unitFactorMassExponent,
    this.unitFactorTimeExponent,
    this.unitFactorTemperatureExponent,
    this.unitFactorCurrentExponent,
    this.unitFactorLuminousIntensityExponent,
    this.logicalMinimum,
    this.logicalMaximum,
    this.physicalMinimum,
    this.physicalMaximum,
    this.strings,
  });
}

typedef HIDUnitSystem = String;
