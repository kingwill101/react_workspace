// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ua-client-hints
// ignore_for_file: type=lint


abstract interface class NavigatorUA {
  Object get userAgentData;
}

abstract interface class NavigatorUABrandVersion {
  String? get brand;
  set brand(String? value);
  String? get version;
  set version(String? value);
}

final class NavigatorUABrandVersionValue implements NavigatorUABrandVersion {
  @override
  String? brand;
  @override
  String? version;

  NavigatorUABrandVersionValue({
    this.brand,
    this.version,
  });
}

abstract interface class UADataValues {
  String? get architecture;
  set architecture(String? value);
  String? get bitness;
  set bitness(String? value);
  List<NavigatorUABrandVersion>? get brands;
  set brands(List<NavigatorUABrandVersion>? value);
  List<String>? get formFactors;
  set formFactors(List<String>? value);
  List<NavigatorUABrandVersion>? get fullVersionList;
  set fullVersionList(List<NavigatorUABrandVersion>? value);
  String? get model;
  set model(String? value);
  bool? get mobile;
  set mobile(bool? value);
  String? get platform;
  set platform(String? value);
  String? get platformVersion;
  set platformVersion(String? value);
  String? get uaFullVersion;
  set uaFullVersion(String? value);
  bool? get wow64;
  set wow64(bool? value);
}

final class UADataValuesValue implements UADataValues {
  @override
  String? architecture;
  @override
  String? bitness;
  @override
  List<NavigatorUABrandVersion>? brands;
  @override
  List<String>? formFactors;
  @override
  List<NavigatorUABrandVersion>? fullVersionList;
  @override
  String? model;
  @override
  bool? mobile;
  @override
  String? platform;
  @override
  String? platformVersion;
  @override
  String? uaFullVersion;
  @override
  bool? wow64;

  UADataValuesValue({
    this.architecture,
    this.bitness,
    this.brands,
    this.formFactors,
    this.fullVersionList,
    this.model,
    this.mobile,
    this.platform,
    this.platformVersion,
    this.uaFullVersion,
    this.wow64,
  });
}

abstract interface class UALowEntropyJSON {
  List<NavigatorUABrandVersion>? get brands;
  set brands(List<NavigatorUABrandVersion>? value);
  bool? get mobile;
  set mobile(bool? value);
  String? get platform;
  set platform(String? value);
}

final class UALowEntropyJSONValue implements UALowEntropyJSON {
  @override
  List<NavigatorUABrandVersion>? brands;
  @override
  bool? mobile;
  @override
  String? platform;

  UALowEntropyJSONValue({
    this.brands,
    this.mobile,
    this.platform,
  });
}

