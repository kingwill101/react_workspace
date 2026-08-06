// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: web-bluetooth
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'webidl.dart';
import 'html.dart';
import 'permissions.dart';

abstract interface class AllowedBluetoothDevice {
  String get deviceId;
  set deviceId(String value);
  bool get mayUseGATT;
  set mayUseGATT(bool value);
  Object get allowedServices;
  set allowedServices(Object value);
  List<int> get allowedManufacturerData;
  set allowedManufacturerData(List<int> value);
}

final class AllowedBluetoothDeviceValue implements AllowedBluetoothDevice {
  @override
  String deviceId;
  @override
  bool mayUseGATT;
  @override
  Object allowedServices;
  @override
  List<int> allowedManufacturerData;

  AllowedBluetoothDeviceValue({
    required this.deviceId,
    required this.mayUseGATT,
    required this.allowedServices,
    required this.allowedManufacturerData,
  });
}

abstract interface class BluetoothAdvertisingEventInit {
  Object get device;
  set device(Object value);
  List<Object>? get uuids;
  set uuids(List<Object>? value);
  String? get name;
  set name(String? value);
  int? get appearance;
  set appearance(int? value);
  int? get txPower;
  set txPower(int? value);
  int? get rssi;
  set rssi(int? value);
  Object? get manufacturerData;
  set manufacturerData(Object? value);
  Object? get serviceData;
  set serviceData(Object? value);
}

final class BluetoothAdvertisingEventInitValue implements BluetoothAdvertisingEventInit {
  @override
  Object device;
  @override
  List<Object>? uuids;
  @override
  String? name;
  @override
  int? appearance;
  @override
  int? txPower;
  @override
  int? rssi;
  @override
  Object? manufacturerData;
  @override
  Object? serviceData;

  BluetoothAdvertisingEventInitValue({
    required this.device,
    this.uuids,
    this.name,
    this.appearance,
    this.txPower,
    this.rssi,
    this.manufacturerData,
    this.serviceData,
  });
}

typedef BluetoothCharacteristicUUID = Object;

abstract interface class BluetoothDataFilterInit {
  BufferSource? get dataPrefix;
  set dataPrefix(BufferSource? value);
  BufferSource? get mask;
  set mask(BufferSource? value);
}

final class BluetoothDataFilterInitValue implements BluetoothDataFilterInit {
  @override
  BufferSource? dataPrefix;
  @override
  BufferSource? mask;

  BluetoothDataFilterInitValue({
    this.dataPrefix,
    this.mask,
  });
}

typedef BluetoothDescriptorUUID = Object;

abstract interface class BluetoothDeviceEventHandlers {
  EventHandler get onadvertisementreceived;
   set onadvertisementreceived(EventHandler value);
  EventHandler get ongattserverdisconnected;
   set ongattserverdisconnected(EventHandler value);
}

abstract interface class BluetoothLEScanFilterInit {
  List<BluetoothServiceUUID>? get services;
  set services(List<BluetoothServiceUUID>? value);
  String? get name;
  set name(String? value);
  String? get namePrefix;
  set namePrefix(String? value);
  List<BluetoothManufacturerDataFilterInit>? get manufacturerData;
  set manufacturerData(List<BluetoothManufacturerDataFilterInit>? value);
  List<BluetoothServiceDataFilterInit>? get serviceData;
  set serviceData(List<BluetoothServiceDataFilterInit>? value);
}

final class BluetoothLEScanFilterInitValue implements BluetoothLEScanFilterInit {
  @override
  List<BluetoothServiceUUID>? services;
  @override
  String? name;
  @override
  String? namePrefix;
  @override
  List<BluetoothManufacturerDataFilterInit>? manufacturerData;
  @override
  List<BluetoothServiceDataFilterInit>? serviceData;

  BluetoothLEScanFilterInitValue({
    this.services,
    this.name,
    this.namePrefix,
    this.manufacturerData,
    this.serviceData,
  });
}

abstract interface class BluetoothManufacturerDataFilterInit {
  int get companyIdentifier;
  set companyIdentifier(int value);
}

final class BluetoothManufacturerDataFilterInitValue implements BluetoothManufacturerDataFilterInit {
  @override
  int companyIdentifier;

  BluetoothManufacturerDataFilterInitValue({
    required this.companyIdentifier,
  });
}

abstract interface class BluetoothPermissionDescriptor {
  String? get deviceId;
  set deviceId(String? value);
  List<BluetoothLEScanFilterInit>? get filters;
  set filters(List<BluetoothLEScanFilterInit>? value);
  List<BluetoothServiceUUID>? get optionalServices;
  set optionalServices(List<BluetoothServiceUUID>? value);
  List<int>? get optionalManufacturerData;
  set optionalManufacturerData(List<int>? value);
  bool? get acceptAllDevices;
  set acceptAllDevices(bool? value);
}

final class BluetoothPermissionDescriptorValue implements BluetoothPermissionDescriptor {
  @override
  String? deviceId;
  @override
  List<BluetoothLEScanFilterInit>? filters;
  @override
  List<BluetoothServiceUUID>? optionalServices;
  @override
  List<int>? optionalManufacturerData;
  @override
  bool? acceptAllDevices;

  BluetoothPermissionDescriptorValue({
    this.deviceId,
    this.filters,
    this.optionalServices,
    this.optionalManufacturerData,
    this.acceptAllDevices,
  });
}

abstract interface class BluetoothPermissionStorage {
  List<AllowedBluetoothDevice> get allowedDevices;
  set allowedDevices(List<AllowedBluetoothDevice> value);
}

final class BluetoothPermissionStorageValue implements BluetoothPermissionStorage {
  @override
  List<AllowedBluetoothDevice> allowedDevices;

  BluetoothPermissionStorageValue({
    required this.allowedDevices,
  });
}

abstract interface class BluetoothServiceDataFilterInit {
  BluetoothServiceUUID get service;
  set service(BluetoothServiceUUID value);
}

final class BluetoothServiceDataFilterInitValue implements BluetoothServiceDataFilterInit {
  @override
  BluetoothServiceUUID service;

  BluetoothServiceDataFilterInitValue({
    required this.service,
  });
}

typedef BluetoothServiceUUID = Object;

abstract interface class BluetoothUUID {
}

abstract interface class CharacteristicEventHandlers {
  EventHandler get oncharacteristicvaluechanged;
   set oncharacteristicvaluechanged(EventHandler value);
}

abstract interface class RequestDeviceOptions {
  List<BluetoothLEScanFilterInit>? get filters;
  set filters(List<BluetoothLEScanFilterInit>? value);
  List<BluetoothLEScanFilterInit>? get exclusionFilters;
  set exclusionFilters(List<BluetoothLEScanFilterInit>? value);
  List<BluetoothServiceUUID>? get optionalServices;
  set optionalServices(List<BluetoothServiceUUID>? value);
  List<int>? get optionalManufacturerData;
  set optionalManufacturerData(List<int>? value);
  bool? get acceptAllDevices;
  set acceptAllDevices(bool? value);
}

final class RequestDeviceOptionsValue implements RequestDeviceOptions {
  @override
  List<BluetoothLEScanFilterInit>? filters;
  @override
  List<BluetoothLEScanFilterInit>? exclusionFilters;
  @override
  List<BluetoothServiceUUID>? optionalServices;
  @override
  List<int>? optionalManufacturerData;
  @override
  bool? acceptAllDevices;

  RequestDeviceOptionsValue({
    this.filters,
    this.exclusionFilters,
    this.optionalServices,
    this.optionalManufacturerData,
    this.acceptAllDevices,
  });
}

abstract interface class ServiceEventHandlers {
  EventHandler get onserviceadded;
   set onserviceadded(EventHandler value);
  EventHandler get onservicechanged;
   set onservicechanged(EventHandler value);
  EventHandler get onserviceremoved;
   set onserviceremoved(EventHandler value);
}

typedef UUID = String;

abstract interface class ValueEventInit {
  Object? get value;
  set value(Object? value);
}

final class ValueEventInitValue implements ValueEventInit {
  @override
  Object? value;

  ValueEventInitValue({
    this.value,
  });
}

abstract interface class WatchAdvertisementsOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class WatchAdvertisementsOptionsValue implements WatchAdvertisementsOptions {
  @override
  AbortSignal? signal;

  WatchAdvertisementsOptionsValue({
    this.signal,
  });
}

