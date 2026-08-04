// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webhid
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'webidl.dart';

abstract interface class HID {
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get ondisconnect;
   set ondisconnect(EventHandler value);
  Future<List<HIDDevice>> getDevices();
  Future<List<HIDDevice>> requestDevice(HIDDeviceRequestOptions options);
}

abstract interface class HIDCollectionInfo {
  int get usagePage;
  set usagePage(int value);
  int get usage;
  set usage(int value);
  Object get type;
  set type(Object value);
  List<HIDCollectionInfo> get children;
  set children(List<HIDCollectionInfo> value);
  List<HIDReportInfo> get inputReports;
  set inputReports(List<HIDReportInfo> value);
  List<HIDReportInfo> get outputReports;
  set outputReports(List<HIDReportInfo> value);
  List<HIDReportInfo> get featureReports;
  set featureReports(List<HIDReportInfo> value);
}

abstract interface class HIDConnectionEvent {
  HIDDevice get device;
}

abstract interface class HIDConnectionEventInit {
  HIDDevice get device;
  set device(HIDDevice value);
}

abstract interface class HIDDevice {
  EventHandler get oninputreport;
   set oninputreport(EventHandler value);
  bool get opened;
  int get vendorId;
  int get productId;
  String get productName;
  List<HIDCollectionInfo> get collections;
  Future<void> open();
  Future<void> close();
  Future<void> forget();
  Future<void> sendReport(Object reportId, BufferSource data);
  Future<void> sendFeatureReport(Object reportId, BufferSource data);
  Future<Object> receiveFeatureReport(Object reportId);
}

abstract interface class HIDDeviceFilter {
  int get vendorId;
  set vendorId(int value);
  int get productId;
  set productId(int value);
  int get usagePage;
  set usagePage(int value);
  int get usage;
  set usage(int value);
}

abstract interface class HIDDeviceRequestOptions {
  List<HIDDeviceFilter> get filters;
  set filters(List<HIDDeviceFilter> value);
  List<HIDDeviceFilter> get exclusionFilters;
  set exclusionFilters(List<HIDDeviceFilter> value);
}

abstract interface class HIDInputReportEvent {
  HIDDevice get device;
  Object get reportId;
  Object get data;
}

abstract interface class HIDInputReportEventInit {
  HIDDevice get device;
  set device(HIDDevice value);
  Object get reportId;
  set reportId(Object value);
  Object get data;
  set data(Object value);
}

abstract interface class HIDReportInfo {
  Object get reportId;
  set reportId(Object value);
  List<HIDReportItem> get items;
  set items(List<HIDReportItem> value);
}

abstract interface class HIDReportItem {
  bool get isAbsolute;
  set isAbsolute(bool value);
  bool get isArray;
  set isArray(bool value);
  bool get isBufferedBytes;
  set isBufferedBytes(bool value);
  bool get isConstant;
  set isConstant(bool value);
  bool get isLinear;
  set isLinear(bool value);
  bool get isRange;
  set isRange(bool value);
  bool get isVolatile;
  set isVolatile(bool value);
  bool get hasNull;
  set hasNull(bool value);
  bool get hasPreferredState;
  set hasPreferredState(bool value);
  bool get wrap;
  set wrap(bool value);
  List<int> get usages;
  set usages(List<int> value);
  int get usageMinimum;
  set usageMinimum(int value);
  int get usageMaximum;
  set usageMaximum(int value);
  int get reportSize;
  set reportSize(int value);
  int get reportCount;
  set reportCount(int value);
  int get unitExponent;
  set unitExponent(int value);
  HIDUnitSystem get unitSystem;
  set unitSystem(HIDUnitSystem value);
  int get unitFactorLengthExponent;
  set unitFactorLengthExponent(int value);
  int get unitFactorMassExponent;
  set unitFactorMassExponent(int value);
  int get unitFactorTimeExponent;
  set unitFactorTimeExponent(int value);
  int get unitFactorTemperatureExponent;
  set unitFactorTemperatureExponent(int value);
  int get unitFactorCurrentExponent;
  set unitFactorCurrentExponent(int value);
  int get unitFactorLuminousIntensityExponent;
  set unitFactorLuminousIntensityExponent(int value);
  int get logicalMinimum;
  set logicalMinimum(int value);
  int get logicalMaximum;
  set logicalMaximum(int value);
  int get physicalMinimum;
  set physicalMinimum(int value);
  int get physicalMaximum;
  set physicalMaximum(int value);
  List<String> get strings;
  set strings(List<String> value);
}

typedef HIDUnitSystem = String;

