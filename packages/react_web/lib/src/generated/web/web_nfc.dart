// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-nfc
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'html.dart';

abstract interface class NDEFMakeReadOnlyOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

abstract interface class NDEFMessage {
  List<NDEFRecord> get records;
}

abstract interface class NDEFMessageInit {
  List<NDEFRecordInit> get records;
  set records(List<NDEFRecordInit> value);
}

typedef NDEFMessageSource = Object;

abstract interface class NDEFReader {
  EventHandler get onreading;
   set onreading(EventHandler value);
  EventHandler get onreadingerror;
   set onreadingerror(EventHandler value);
  Future<void> scan([NDEFScanOptions? options]);
  Future<void> write(NDEFMessageSource message, [NDEFWriteOptions? options]);
  Future<void> makeReadOnly([NDEFMakeReadOnlyOptions? options]);
}

abstract interface class NDEFReadingEvent {
  String get serialNumber;
  NDEFMessage get message;
}

abstract interface class NDEFReadingEventInit {
  String? get serialNumber;
  set serialNumber(String? value);
  NDEFMessageInit get message;
  set message(NDEFMessageInit value);
}

abstract interface class NDEFRecord {
  String get recordType;
  String? get mediaType;
  String? get id;
  Object get data;
  String? get encoding;
  String? get lang;
  List<NDEFRecord>? toRecords();
}

abstract interface class NDEFRecordInit {
  String get recordType;
  set recordType(String value);
  String get mediaType;
  set mediaType(String value);
  String get id;
  set id(String value);
  String get encoding;
  set encoding(String value);
  String get lang;
  set lang(String value);
  Object get data;
  set data(Object value);
}

abstract interface class NDEFScanOptions {
  AbortSignal get signal;
  set signal(AbortSignal value);
}

abstract interface class NDEFWriteOptions {
  bool get overwrite;
  set overwrite(bool value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

