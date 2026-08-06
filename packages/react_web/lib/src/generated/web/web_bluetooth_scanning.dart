// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: web-bluetooth-scanning
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'web_bluetooth.dart';
import 'permissions.dart';

abstract interface class BluetoothLEScanOptions {
  List<BluetoothLEScanFilterInit>? get filters;
  set filters(List<BluetoothLEScanFilterInit>? value);
  bool? get keepRepeatedDevices;
  set keepRepeatedDevices(bool? value);
  bool? get acceptAllAdvertisements;
  set acceptAllAdvertisements(bool? value);
}

final class BluetoothLEScanOptionsValue implements BluetoothLEScanOptions {
  @override
  List<BluetoothLEScanFilterInit>? filters;
  @override
  bool? keepRepeatedDevices;
  @override
  bool? acceptAllAdvertisements;

  BluetoothLEScanOptionsValue({
    this.filters,
    this.keepRepeatedDevices,
    this.acceptAllAdvertisements,
  });
}

abstract interface class BluetoothLEScanPermissionDescriptor {
  List<BluetoothLEScanFilterInit>? get filters;
  set filters(List<BluetoothLEScanFilterInit>? value);
  bool? get keepRepeatedDevices;
  set keepRepeatedDevices(bool? value);
  bool? get acceptAllAdvertisements;
  set acceptAllAdvertisements(bool? value);
}

final class BluetoothLEScanPermissionDescriptorValue implements BluetoothLEScanPermissionDescriptor {
  @override
  List<BluetoothLEScanFilterInit>? filters;
  @override
  bool? keepRepeatedDevices;
  @override
  bool? acceptAllAdvertisements;

  BluetoothLEScanPermissionDescriptorValue({
    this.filters,
    this.keepRepeatedDevices,
    this.acceptAllAdvertisements,
  });
}

