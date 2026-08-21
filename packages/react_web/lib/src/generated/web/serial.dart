// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: serial
// ignore_for_file: type=lint

import 'web_bluetooth.dart';

typedef FlowControlType = String;

typedef ParityType = String;

abstract interface class SerialInputSignals {
  bool get dataCarrierDetect;
  set dataCarrierDetect(bool value);
  bool get clearToSend;
  set clearToSend(bool value);
  bool get ringIndicator;
  set ringIndicator(bool value);
  bool get dataSetReady;
  set dataSetReady(bool value);
}

final class SerialInputSignalsValue implements SerialInputSignals {
  @override
  bool dataCarrierDetect;
  @override
  bool clearToSend;
  @override
  bool ringIndicator;
  @override
  bool dataSetReady;

  SerialInputSignalsValue({
    required this.dataCarrierDetect,
    required this.clearToSend,
    required this.ringIndicator,
    required this.dataSetReady,
  });
}

abstract interface class SerialOptions {
  int get baudRate;
  set baudRate(int value);
  Object? get dataBits;
  set dataBits(Object? value);
  Object? get stopBits;
  set stopBits(Object? value);
  ParityType? get parity;
  set parity(ParityType? value);
  int? get bufferSize;
  set bufferSize(int? value);
  FlowControlType? get flowControl;
  set flowControl(FlowControlType? value);
}

final class SerialOptionsValue implements SerialOptions {
  @override
  int baudRate;
  @override
  Object? dataBits;
  @override
  Object? stopBits;
  @override
  ParityType? parity;
  @override
  int? bufferSize;
  @override
  FlowControlType? flowControl;

  SerialOptionsValue({
    required this.baudRate,
    this.dataBits,
    this.stopBits,
    this.parity,
    this.bufferSize,
    this.flowControl,
  });
}

abstract interface class SerialOutputSignals {
  bool? get dataTerminalReady;
  set dataTerminalReady(bool? value);
  bool? get requestToSend;
  set requestToSend(bool? value);
  bool? get break_;
  set break_(bool? value);
}

final class SerialOutputSignalsValue implements SerialOutputSignals {
  @override
  bool? dataTerminalReady;
  @override
  bool? requestToSend;
  @override
  bool? break_;

  SerialOutputSignalsValue({
    this.dataTerminalReady,
    this.requestToSend,
    this.break_,
  });
}

abstract interface class SerialPortFilter {
  int? get usbVendorId;
  set usbVendorId(int? value);
  int? get usbProductId;
  set usbProductId(int? value);
  BluetoothServiceUUID? get bluetoothServiceClassId;
  set bluetoothServiceClassId(BluetoothServiceUUID? value);
}

final class SerialPortFilterValue implements SerialPortFilter {
  @override
  int? usbVendorId;
  @override
  int? usbProductId;
  @override
  BluetoothServiceUUID? bluetoothServiceClassId;

  SerialPortFilterValue({
    this.usbVendorId,
    this.usbProductId,
    this.bluetoothServiceClassId,
  });
}

abstract interface class SerialPortInfo {
  int? get usbVendorId;
  set usbVendorId(int? value);
  int? get usbProductId;
  set usbProductId(int? value);
  BluetoothServiceUUID? get bluetoothServiceClassId;
  set bluetoothServiceClassId(BluetoothServiceUUID? value);
}

final class SerialPortInfoValue implements SerialPortInfo {
  @override
  int? usbVendorId;
  @override
  int? usbProductId;
  @override
  BluetoothServiceUUID? bluetoothServiceClassId;

  SerialPortInfoValue({
    this.usbVendorId,
    this.usbProductId,
    this.bluetoothServiceClassId,
  });
}

abstract interface class SerialPortRequestOptions {
  List<SerialPortFilter>? get filters;
  set filters(List<SerialPortFilter>? value);
  List<BluetoothServiceUUID>? get allowedBluetoothServiceClassIds;
  set allowedBluetoothServiceClassIds(List<BluetoothServiceUUID>? value);
}

final class SerialPortRequestOptionsValue implements SerialPortRequestOptions {
  @override
  List<SerialPortFilter>? filters;
  @override
  List<BluetoothServiceUUID>? allowedBluetoothServiceClassIds;

  SerialPortRequestOptionsValue({
    this.filters,
    this.allowedBluetoothServiceClassIds,
  });
}
