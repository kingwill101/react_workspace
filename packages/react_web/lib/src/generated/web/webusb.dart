// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webusb
// ignore_for_file: type=lint

import 'dom.dart';
import 'permissions.dart';

abstract interface class AllowedUSBDevice {
  Object get vendorId;
  set vendorId(Object value);
  Object get productId;
  set productId(Object value);
  String? get serialNumber;
  set serialNumber(String? value);
}

final class AllowedUSBDeviceValue implements AllowedUSBDevice {
  @override
  Object vendorId;
  @override
  Object productId;
  @override
  String? serialNumber;

  AllowedUSBDeviceValue({
    required this.vendorId,
    required this.productId,
    this.serialNumber,
  });
}

abstract interface class USBBlocklistEntry {
  int get idVendor;
  set idVendor(int value);
  int get idProduct;
  set idProduct(int value);
  int get bcdDevice;
  set bcdDevice(int value);
}

final class USBBlocklistEntryValue implements USBBlocklistEntry {
  @override
  int idVendor;
  @override
  int idProduct;
  @override
  int bcdDevice;

  USBBlocklistEntryValue({
    required this.idVendor,
    required this.idProduct,
    required this.bcdDevice,
  });
}

abstract interface class USBConnectionEventInit {
  Object get device;
  set device(Object value);
}

final class USBConnectionEventInitValue implements USBConnectionEventInit {
  @override
  Object device;

  USBConnectionEventInitValue({required this.device});
}

abstract interface class USBControlTransferParameters {
  USBRequestType get requestType;
  set requestType(USBRequestType value);
  USBRecipient get recipient;
  set recipient(USBRecipient value);
  Object get request;
  set request(Object value);
  int get value;
  set value(int value);
  int get index;
  set index(int value);
}

final class USBControlTransferParametersValue
    implements USBControlTransferParameters {
  @override
  USBRequestType requestType;
  @override
  USBRecipient recipient;
  @override
  Object request;
  @override
  int value;
  @override
  int index;

  USBControlTransferParametersValue({
    required this.requestType,
    required this.recipient,
    required this.request,
    required this.value,
    required this.index,
  });
}

abstract interface class USBDeviceFilter {
  int? get vendorId;
  set vendorId(int? value);
  int? get productId;
  set productId(int? value);
  Object? get classCode;
  set classCode(Object? value);
  Object? get subclassCode;
  set subclassCode(Object? value);
  Object? get protocolCode;
  set protocolCode(Object? value);
  String? get serialNumber;
  set serialNumber(String? value);
}

final class USBDeviceFilterValue implements USBDeviceFilter {
  @override
  int? vendorId;
  @override
  int? productId;
  @override
  Object? classCode;
  @override
  Object? subclassCode;
  @override
  Object? protocolCode;
  @override
  String? serialNumber;

  USBDeviceFilterValue({
    this.vendorId,
    this.productId,
    this.classCode,
    this.subclassCode,
    this.protocolCode,
    this.serialNumber,
  });
}

abstract interface class USBDeviceRequestOptions {
  List<USBDeviceFilter> get filters;
  set filters(List<USBDeviceFilter> value);
  List<USBDeviceFilter>? get exclusionFilters;
  set exclusionFilters(List<USBDeviceFilter>? value);
}

final class USBDeviceRequestOptionsValue implements USBDeviceRequestOptions {
  @override
  List<USBDeviceFilter> filters;
  @override
  List<USBDeviceFilter>? exclusionFilters;

  USBDeviceRequestOptionsValue({required this.filters, this.exclusionFilters});
}

typedef USBDirection = String;

typedef USBEndpointType = String;

abstract interface class USBPermissionDescriptor {
  List<USBDeviceFilter>? get filters;
  set filters(List<USBDeviceFilter>? value);
  List<USBDeviceFilter>? get exclusionFilters;
  set exclusionFilters(List<USBDeviceFilter>? value);
}

final class USBPermissionDescriptorValue implements USBPermissionDescriptor {
  @override
  List<USBDeviceFilter>? filters;
  @override
  List<USBDeviceFilter>? exclusionFilters;

  USBPermissionDescriptorValue({this.filters, this.exclusionFilters});
}

abstract interface class USBPermissionStorage {
  List<AllowedUSBDevice>? get allowedDevices;
  set allowedDevices(List<AllowedUSBDevice>? value);
}

final class USBPermissionStorageValue implements USBPermissionStorage {
  @override
  List<AllowedUSBDevice>? allowedDevices;

  USBPermissionStorageValue({this.allowedDevices});
}

typedef USBRecipient = String;

typedef USBRequestType = String;

typedef USBTransferStatus = String;
