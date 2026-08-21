// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-nfc
// ignore_for_file: type=lint

import 'dom.dart';

abstract interface class NDEFMakeReadOnlyOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class NDEFMakeReadOnlyOptionsValue implements NDEFMakeReadOnlyOptions {
  @override
  AbortSignal? signal;

  NDEFMakeReadOnlyOptionsValue({this.signal});
}

abstract interface class NDEFMessageInit {
  List<NDEFRecordInit> get records;
  set records(List<NDEFRecordInit> value);
}

final class NDEFMessageInitValue implements NDEFMessageInit {
  @override
  List<NDEFRecordInit> records;

  NDEFMessageInitValue({required this.records});
}

typedef NDEFMessageSource = Object;

abstract interface class NDEFReadingEventInit {
  String? get serialNumber;
  set serialNumber(String? value);
  NDEFMessageInit get message;
  set message(NDEFMessageInit value);
}

final class NDEFReadingEventInitValue implements NDEFReadingEventInit {
  @override
  String? serialNumber;
  @override
  NDEFMessageInit message;

  NDEFReadingEventInitValue({this.serialNumber, required this.message});
}

abstract interface class NDEFRecordInit {
  String get recordType;
  set recordType(String value);
  String? get mediaType;
  set mediaType(String? value);
  String? get id;
  set id(String? value);
  String? get encoding;
  set encoding(String? value);
  String? get lang;
  set lang(String? value);
  Object? get data;
  set data(Object? value);
}

final class NDEFRecordInitValue implements NDEFRecordInit {
  @override
  String recordType;
  @override
  String? mediaType;
  @override
  String? id;
  @override
  String? encoding;
  @override
  String? lang;
  @override
  Object? data;

  NDEFRecordInitValue({
    required this.recordType,
    this.mediaType,
    this.id,
    this.encoding,
    this.lang,
    this.data,
  });
}

abstract interface class NDEFScanOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class NDEFScanOptionsValue implements NDEFScanOptions {
  @override
  AbortSignal? signal;

  NDEFScanOptionsValue({this.signal});
}

abstract interface class NDEFWriteOptions {
  bool? get overwrite;
  set overwrite(bool? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class NDEFWriteOptionsValue implements NDEFWriteOptions {
  @override
  bool? overwrite;
  @override
  AbortSignal? signal;

  NDEFWriteOptionsValue({this.overwrite, this.signal});
}
