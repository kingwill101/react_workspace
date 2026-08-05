// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webusb
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'permissions.dart';

abstract interface class AllowedUSBDevice {
  Object get vendorId;
  set vendorId(Object value);
  Object get productId;
  set productId(Object value);
  String get serialNumber;
  set serialNumber(String value);
}

abstract interface class USBBlocklistEntry {
  int get idVendor;
  set idVendor(int value);
  int get idProduct;
  set idProduct(int value);
  int get bcdDevice;
  set bcdDevice(int value);
}

abstract interface class USBConnectionEventInit {
  Object get device;
  set device(Object value);
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

abstract interface class USBDeviceFilter {
  int get vendorId;
  set vendorId(int value);
  int get productId;
  set productId(int value);
  Object get classCode;
  set classCode(Object value);
  Object get subclassCode;
  set subclassCode(Object value);
  Object get protocolCode;
  set protocolCode(Object value);
  String get serialNumber;
  set serialNumber(String value);
}

abstract interface class USBDeviceRequestOptions {
  List<USBDeviceFilter> get filters;
  set filters(List<USBDeviceFilter> value);
  List<USBDeviceFilter> get exclusionFilters;
  set exclusionFilters(List<USBDeviceFilter> value);
}

typedef USBDirection = String;

typedef USBEndpointType = String;

abstract interface class USBPermissionDescriptor {
  List<USBDeviceFilter> get filters;
  set filters(List<USBDeviceFilter> value);
  List<USBDeviceFilter> get exclusionFilters;
  set exclusionFilters(List<USBDeviceFilter> value);
}

abstract interface class USBPermissionStorage {
  List<AllowedUSBDevice> get allowedDevices;
  set allowedDevices(List<AllowedUSBDevice> value);
}

typedef USBRecipient = String;

typedef USBRequestType = String;

typedef USBTransferStatus = String;

