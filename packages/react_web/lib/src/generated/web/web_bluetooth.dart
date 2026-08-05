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

abstract interface class BluetoothAdvertisingEventInit {
  Object get device;
  set device(Object value);
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
  Object get manufacturerData;
  set manufacturerData(Object value);
  Object get serviceData;
  set serviceData(Object value);
}

typedef BluetoothCharacteristicUUID = Object;

abstract interface class BluetoothDataFilterInit {
  BufferSource get dataPrefix;
  set dataPrefix(BufferSource value);
  BufferSource get mask;
  set mask(BufferSource value);
}

typedef BluetoothDescriptorUUID = Object;

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

abstract interface class BluetoothPermissionStorage {
  List<AllowedBluetoothDevice> get allowedDevices;
  set allowedDevices(List<AllowedBluetoothDevice> value);
}

abstract interface class BluetoothServiceDataFilterInit {
  BluetoothServiceUUID get service;
  set service(BluetoothServiceUUID value);
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

abstract interface class ValueEventInit {
  Object get value;
  set value(Object value);
}

abstract interface class WatchAdvertisementsOptions {
  AbortSignal get signal;
  set signal(AbortSignal value);
}

