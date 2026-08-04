// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webusb
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'webidl.dart';
import 'permissions.dart';

abstract interface class AllowedUSBDevice {
  Object get vendorId;
  set vendorId(Object value);
  Object get productId;
  set productId(Object value);
  String get serialNumber;
  set serialNumber(String value);
}

abstract interface class USB {
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get ondisconnect;
   set ondisconnect(EventHandler value);
  Future<List<USBDevice>> getDevices();
  Future<USBDevice> requestDevice(USBDeviceRequestOptions options);
}

abstract interface class USBAlternateInterface {
  Object get alternateSetting;
  Object get interfaceClass;
  Object get interfaceSubclass;
  Object get interfaceProtocol;
  String? get interfaceName;
  List<USBEndpoint> get endpoints;
}

abstract interface class USBBlocklistEntry {
  int get idVendor;
  set idVendor(int value);
  int get idProduct;
  set idProduct(int value);
  int get bcdDevice;
  set bcdDevice(int value);
}

abstract interface class USBConfiguration {
  Object get configurationValue;
  String? get configurationName;
  List<USBInterface> get interfaces;
}

abstract interface class USBConnectionEvent {
  USBDevice get device;
}

abstract interface class USBConnectionEventInit {
  USBDevice get device;
  set device(USBDevice value);
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

abstract interface class USBDevice {
  Object get usbVersionMajor;
  Object get usbVersionMinor;
  Object get usbVersionSubminor;
  Object get deviceClass;
  Object get deviceSubclass;
  Object get deviceProtocol;
  int get vendorId;
  int get productId;
  Object get deviceVersionMajor;
  Object get deviceVersionMinor;
  Object get deviceVersionSubminor;
  String? get manufacturerName;
  String? get productName;
  String? get serialNumber;
  USBConfiguration? get configuration;
  List<USBConfiguration> get configurations;
  bool get opened;
  Future<void> open();
  Future<void> close();
  Future<void> forget();
  Future<void> selectConfiguration(Object configurationValue);
  Future<void> claimInterface(Object interfaceNumber);
  Future<void> releaseInterface(Object interfaceNumber);
  Future<void> selectAlternateInterface(Object interfaceNumber, Object alternateSetting);
  Future<USBInTransferResult> controlTransferIn(USBControlTransferParameters setup, int length);
  Future<USBOutTransferResult> controlTransferOut(USBControlTransferParameters setup, [BufferSource? data]);
  Future<void> clearHalt(USBDirection direction, Object endpointNumber);
  Future<USBInTransferResult> transferIn(Object endpointNumber, int length);
  Future<USBOutTransferResult> transferOut(Object endpointNumber, BufferSource data);
  Future<USBIsochronousInTransferResult> isochronousTransferIn(Object endpointNumber, List<int> packetLengths);
  Future<USBIsochronousOutTransferResult> isochronousTransferOut(Object endpointNumber, BufferSource data, List<int> packetLengths);
  Future<void> reset();
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

abstract interface class USBEndpoint {
  Object get endpointNumber;
  USBDirection get direction;
  USBEndpointType get type;
  int get packetSize;
}

typedef USBEndpointType = String;

abstract interface class USBInTransferResult {
  Object get data;
  USBTransferStatus get status;
}

abstract interface class USBInterface {
  Object get interfaceNumber;
  USBAlternateInterface get alternate;
  List<USBAlternateInterface> get alternates;
  bool get claimed;
}

abstract interface class USBIsochronousInTransferPacket {
  Object get data;
  USBTransferStatus get status;
}

abstract interface class USBIsochronousInTransferResult {
  Object get data;
  List<USBIsochronousInTransferPacket> get packets;
}

abstract interface class USBIsochronousOutTransferPacket {
  int get bytesWritten;
  USBTransferStatus get status;
}

abstract interface class USBIsochronousOutTransferResult {
  List<USBIsochronousOutTransferPacket> get packets;
}

abstract interface class USBOutTransferResult {
  int get bytesWritten;
  USBTransferStatus get status;
}

abstract interface class USBPermissionDescriptor {
  List<USBDeviceFilter> get filters;
  set filters(List<USBDeviceFilter> value);
  List<USBDeviceFilter> get exclusionFilters;
  set exclusionFilters(List<USBDeviceFilter> value);
}

abstract interface class USBPermissionResult {
  List<USBDevice> get devices;
   set devices(List<USBDevice> value);
}

abstract interface class USBPermissionStorage {
  List<AllowedUSBDevice> get allowedDevices;
  set allowedDevices(List<AllowedUSBDevice> value);
}

typedef USBRecipient = String;

typedef USBRequestType = String;

typedef USBTransferStatus = String;

