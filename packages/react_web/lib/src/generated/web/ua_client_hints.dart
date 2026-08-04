// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ua-client-hints
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class NavigatorUA {
  NavigatorUAData get userAgentData;
}

abstract interface class NavigatorUABrandVersion {
  String get brand;
  set brand(String value);
  String get version;
  set version(String value);
}

abstract interface class NavigatorUAData {
  List<NavigatorUABrandVersion> get brands;
  bool get mobile;
  String get platform;
  Future<UADataValues> getHighEntropyValues(List<String> hints);
  UALowEntropyJSON toJSON();
}

abstract interface class UADataValues {
  String get architecture;
  set architecture(String value);
  String get bitness;
  set bitness(String value);
  List<NavigatorUABrandVersion> get brands;
  set brands(List<NavigatorUABrandVersion> value);
  List<String> get formFactors;
  set formFactors(List<String> value);
  List<NavigatorUABrandVersion> get fullVersionList;
  set fullVersionList(List<NavigatorUABrandVersion> value);
  String get model;
  set model(String value);
  bool get mobile;
  set mobile(bool value);
  String get platform;
  set platform(String value);
  String get platformVersion;
  set platformVersion(String value);
  String get uaFullVersion;
  set uaFullVersion(String value);
  bool get wow64;
  set wow64(bool value);
}

abstract interface class UALowEntropyJSON {
  List<NavigatorUABrandVersion> get brands;
  set brands(List<NavigatorUABrandVersion> value);
  bool get mobile;
  set mobile(bool value);
  String get platform;
  set platform(String value);
}

