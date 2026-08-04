// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-bluetooth-scanning
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'web_bluetooth.dart';
import 'permissions.dart';

abstract interface class Bluetooth {
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
  Future<BluetoothLEScan> requestLEScan([BluetoothLEScanOptions? options]);
  Future<bool> getAvailability();
  EventHandler get onavailabilitychanged;
   set onavailabilitychanged(EventHandler value);
  BluetoothDevice? get referringDevice;
  Future<List<BluetoothDevice>> getDevices();
  Future<BluetoothDevice> requestDevice([RequestDeviceOptions? options]);
}

abstract interface class BluetoothDataFilter {
  Object get dataPrefix;
  Object get mask;
}

abstract interface class BluetoothLEScan {
  List<BluetoothLEScanFilter> get filters;
  bool get keepRepeatedDevices;
  bool get acceptAllAdvertisements;
  bool get active;
  void stop();
}

abstract interface class BluetoothLEScanFilter {
  String? get name;
  String? get namePrefix;
  List<UUID> get services;
  BluetoothManufacturerDataFilter get manufacturerData;
  BluetoothServiceDataFilter get serviceData;
}

abstract interface class BluetoothLEScanOptions {
  List<BluetoothLEScanFilterInit> get filters;
  set filters(List<BluetoothLEScanFilterInit> value);
  bool get keepRepeatedDevices;
  set keepRepeatedDevices(bool value);
  bool get acceptAllAdvertisements;
  set acceptAllAdvertisements(bool value);
}

abstract interface class BluetoothLEScanPermissionDescriptor {
  List<BluetoothLEScanFilterInit> get filters;
  set filters(List<BluetoothLEScanFilterInit> value);
  bool get keepRepeatedDevices;
  set keepRepeatedDevices(bool value);
  bool get acceptAllAdvertisements;
  set acceptAllAdvertisements(bool value);
}

abstract interface class BluetoothLEScanPermissionResult {
  List<BluetoothLEScan> get scans;
   set scans(List<BluetoothLEScan> value);
}

abstract interface class BluetoothManufacturerDataFilter {
   Iterable<int> get keys;
   Iterable<BluetoothDataFilter> get values;
   Iterable<MapEntry<int, BluetoothDataFilter>> get entries;
   BluetoothDataFilter? operator [](Object key);
   bool has(Object key);
}

abstract interface class BluetoothServiceDataFilter {
   Iterable<UUID> get keys;
   Iterable<BluetoothDataFilter> get values;
   Iterable<MapEntry<UUID, BluetoothDataFilter>> get entries;
   BluetoothDataFilter? operator [](Object key);
   bool has(Object key);
}

