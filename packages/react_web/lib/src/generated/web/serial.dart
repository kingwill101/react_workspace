// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: serial
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'streams.dart';
import 'web_bluetooth.dart';

typedef FlowControlType = String;

typedef ParityType = String;

abstract interface class Serial {
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get ondisconnect;
   set ondisconnect(EventHandler value);
  Future<List<SerialPort>> getPorts();
  Future<SerialPort> requestPort([SerialPortRequestOptions? options]);
}

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

abstract interface class SerialOptions {
  int get baudRate;
  set baudRate(int value);
  Object get dataBits;
  set dataBits(Object value);
  Object get stopBits;
  set stopBits(Object value);
  ParityType get parity;
  set parity(ParityType value);
  int get bufferSize;
  set bufferSize(int value);
  FlowControlType get flowControl;
  set flowControl(FlowControlType value);
}

abstract interface class SerialOutputSignals {
  bool get dataTerminalReady;
  set dataTerminalReady(bool value);
  bool get requestToSend;
  set requestToSend(bool value);
  bool get break_;
  set break_(bool value);
}

abstract interface class SerialPort {
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get ondisconnect;
   set ondisconnect(EventHandler value);
  bool get connected;
  ReadableStream get readable;
  WritableStream get writable;
  SerialPortInfo getInfo();
  Future<void> open(SerialOptions options);
  Future<void> setSignals([SerialOutputSignals? signals]);
  Future<SerialInputSignals> getSignals();
  Future<void> close();
  Future<void> forget();
}

abstract interface class SerialPortFilter {
  int get usbVendorId;
  set usbVendorId(int value);
  int get usbProductId;
  set usbProductId(int value);
  BluetoothServiceUUID get bluetoothServiceClassId;
  set bluetoothServiceClassId(BluetoothServiceUUID value);
}

abstract interface class SerialPortInfo {
  int get usbVendorId;
  set usbVendorId(int value);
  int get usbProductId;
  set usbProductId(int value);
  BluetoothServiceUUID get bluetoothServiceClassId;
  set bluetoothServiceClassId(BluetoothServiceUUID value);
}

abstract interface class SerialPortRequestOptions {
  List<SerialPortFilter> get filters;
  set filters(List<SerialPortFilter> value);
  List<BluetoothServiceUUID> get allowedBluetoothServiceClassIds;
  set allowedBluetoothServiceClassIds(List<BluetoothServiceUUID> value);
}

