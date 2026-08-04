// GENERATED CODE — DO NOT EDIT
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

abstract interface class BluetoothAdvertisingEvent {
  BluetoothDevice get device;
  List<UUID> get uuids;
  String? get name;
  int? get appearance;
  int? get txPower;
  int? get rssi;
  BluetoothManufacturerDataMap get manufacturerData;
  BluetoothServiceDataMap get serviceData;
}

abstract interface class BluetoothAdvertisingEventInit {
  BluetoothDevice get device;
  set device(BluetoothDevice value);
  List<Object> get uuids;
  set uuids(List<Object> value);
  String get name;
  set name(String value);
  int get appearance;
  set appearance(int value);
  int get txPower;
  set txPower(int value);
  int get rssi;
  set rssi(int value);
  BluetoothManufacturerDataMap get manufacturerData;
  set manufacturerData(BluetoothManufacturerDataMap value);
  BluetoothServiceDataMap get serviceData;
  set serviceData(BluetoothServiceDataMap value);
}

abstract interface class BluetoothCharacteristicProperties {
  bool get broadcast;
  bool get read;
  bool get writeWithoutResponse;
  bool get write;
  bool get notify;
  bool get indicate;
  bool get authenticatedSignedWrites;
  bool get reliableWrite;
  bool get writableAuxiliaries;
}

typedef BluetoothCharacteristicUUID = Object;

abstract interface class BluetoothDataFilterInit {
  BufferSource get dataPrefix;
  set dataPrefix(BufferSource value);
  BufferSource get mask;
  set mask(BufferSource value);
}

typedef BluetoothDescriptorUUID = Object;

abstract interface class BluetoothDevice {
  EventHandler get onadvertisementreceived;
   set onadvertisementreceived(EventHandler value);
  EventHandler get ongattserverdisconnected;
   set ongattserverdisconnected(EventHandler value);
  EventHandler get oncharacteristicvaluechanged;
   set oncharacteristicvaluechanged(EventHandler value);
  EventHandler get onserviceadded;
   set onserviceadded(EventHandler value);
  EventHandler get onservicechanged;
   set onservicechanged(EventHandler value);
  EventHandler get onserviceremoved;
   set onserviceremoved(EventHandler value);
  String get id;
  String? get name;
  BluetoothRemoteGATTServer? get gatt;
  Future<void> forget();
  Future<void> watchAdvertisements([WatchAdvertisementsOptions? options]);
  bool get watchingAdvertisements;
}

abstract interface class BluetoothDeviceEventHandlers {
  EventHandler get onadvertisementreceived;
   set onadvertisementreceived(EventHandler value);
  EventHandler get ongattserverdisconnected;
   set ongattserverdisconnected(EventHandler value);
}

abstract interface class BluetoothLEScanFilterInit {
  List<BluetoothServiceUUID> get services;
  set services(List<BluetoothServiceUUID> value);
  String get name;
  set name(String value);
  String get namePrefix;
  set namePrefix(String value);
  List<BluetoothManufacturerDataFilterInit> get manufacturerData;
  set manufacturerData(List<BluetoothManufacturerDataFilterInit> value);
  List<BluetoothServiceDataFilterInit> get serviceData;
  set serviceData(List<BluetoothServiceDataFilterInit> value);
}

abstract interface class BluetoothManufacturerDataFilterInit {
  int get companyIdentifier;
  set companyIdentifier(int value);
}

abstract interface class BluetoothManufacturerDataMap {
   Iterable<int> get keys;
   Iterable<Object> get values;
   Iterable<MapEntry<int, Object>> get entries;
   Object? operator [](Object key);
   bool has(Object key);
}

abstract interface class BluetoothPermissionDescriptor {
  String get deviceId;
  set deviceId(String value);
  List<BluetoothLEScanFilterInit> get filters;
  set filters(List<BluetoothLEScanFilterInit> value);
  List<BluetoothServiceUUID> get optionalServices;
  set optionalServices(List<BluetoothServiceUUID> value);
  List<int> get optionalManufacturerData;
  set optionalManufacturerData(List<int> value);
  bool get acceptAllDevices;
  set acceptAllDevices(bool value);
}

abstract interface class BluetoothPermissionResult {
  List<BluetoothDevice> get devices;
   set devices(List<BluetoothDevice> value);
}

abstract interface class BluetoothPermissionStorage {
  List<AllowedBluetoothDevice> get allowedDevices;
  set allowedDevices(List<AllowedBluetoothDevice> value);
}

abstract interface class BluetoothRemoteGATTCharacteristic {
  EventHandler get oncharacteristicvaluechanged;
   set oncharacteristicvaluechanged(EventHandler value);
  BluetoothRemoteGATTService get service;
  UUID get uuid;
  BluetoothCharacteristicProperties get properties;
  Object get value;
  Future<BluetoothRemoteGATTDescriptor> getDescriptor(BluetoothDescriptorUUID descriptor);
  Future<List<BluetoothRemoteGATTDescriptor>> getDescriptors([BluetoothDescriptorUUID? descriptor]);
  Future<Object> readValue();
  Future<void> writeValue(BufferSource value);
  Future<void> writeValueWithResponse(BufferSource value);
  Future<void> writeValueWithoutResponse(BufferSource value);
  Future<BluetoothRemoteGATTCharacteristic> startNotifications();
  Future<BluetoothRemoteGATTCharacteristic> stopNotifications();
}

abstract interface class BluetoothRemoteGATTDescriptor {
  BluetoothRemoteGATTCharacteristic get characteristic;
  UUID get uuid;
  Object get value;
  Future<Object> readValue();
  Future<void> writeValue(BufferSource value);
}

abstract interface class BluetoothRemoteGATTServer {
  BluetoothDevice get device;
  bool get connected;
  Future<BluetoothRemoteGATTServer> connect();
  void disconnect();
  Future<BluetoothRemoteGATTService> getPrimaryService(BluetoothServiceUUID service);
  Future<List<BluetoothRemoteGATTService>> getPrimaryServices([BluetoothServiceUUID? service]);
}

abstract interface class BluetoothRemoteGATTService {
  EventHandler get oncharacteristicvaluechanged;
   set oncharacteristicvaluechanged(EventHandler value);
  EventHandler get onserviceadded;
   set onserviceadded(EventHandler value);
  EventHandler get onservicechanged;
   set onservicechanged(EventHandler value);
  EventHandler get onserviceremoved;
   set onserviceremoved(EventHandler value);
  BluetoothDevice get device;
  UUID get uuid;
  bool get isPrimary;
  Future<BluetoothRemoteGATTCharacteristic> getCharacteristic(BluetoothCharacteristicUUID characteristic);
  Future<List<BluetoothRemoteGATTCharacteristic>> getCharacteristics([BluetoothCharacteristicUUID? characteristic]);
  Future<BluetoothRemoteGATTService> getIncludedService(BluetoothServiceUUID service);
  Future<List<BluetoothRemoteGATTService>> getIncludedServices([BluetoothServiceUUID? service]);
}

abstract interface class BluetoothServiceDataFilterInit {
  BluetoothServiceUUID get service;
  set service(BluetoothServiceUUID value);
}

abstract interface class BluetoothServiceDataMap {
   Iterable<UUID> get keys;
   Iterable<Object> get values;
   Iterable<MapEntry<UUID, Object>> get entries;
   Object? operator [](Object key);
   bool has(Object key);
}

typedef BluetoothServiceUUID = Object;

abstract interface class BluetoothUUID {
}

abstract interface class CharacteristicEventHandlers {
  EventHandler get oncharacteristicvaluechanged;
   set oncharacteristicvaluechanged(EventHandler value);
}

abstract interface class RequestDeviceOptions {
  List<BluetoothLEScanFilterInit> get filters;
  set filters(List<BluetoothLEScanFilterInit> value);
  List<BluetoothLEScanFilterInit> get exclusionFilters;
  set exclusionFilters(List<BluetoothLEScanFilterInit> value);
  List<BluetoothServiceUUID> get optionalServices;
  set optionalServices(List<BluetoothServiceUUID> value);
  List<int> get optionalManufacturerData;
  set optionalManufacturerData(List<int> value);
  bool get acceptAllDevices;
  set acceptAllDevices(bool value);
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

abstract interface class ValueEvent {
  Object get value;
}

abstract interface class ValueEventInit {
  Object get value;
  set value(Object value);
}

abstract interface class WatchAdvertisementsOptions {
  AbortSignal get signal;
  set signal(AbortSignal value);
}

