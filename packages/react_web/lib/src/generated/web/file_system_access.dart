// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: file-system-access
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fs.dart';
import 'permissions.dart';

abstract interface class DirectoryPickerOptions {
  String get id;
  set id(String value);
  StartInDirectory get startIn;
  set startIn(StartInDirectory value);
  FileSystemPermissionMode get mode;
  set mode(FileSystemPermissionMode value);
}

abstract interface class FilePickerAcceptType {
  String get description;
  set description(String value);
  Map<String, Object> get accept;
  set accept(Map<String, Object> value);
}

abstract interface class FilePickerOptions {
  List<FilePickerAcceptType> get types;
  set types(List<FilePickerAcceptType> value);
  bool get excludeAcceptAllOption;
  set excludeAcceptAllOption(bool value);
  String get id;
  set id(String value);
  StartInDirectory get startIn;
  set startIn(StartInDirectory value);
}

abstract interface class FileSystemHandle {
  FileSystemHandleKind get kind;
  String get name;
  Future<bool> isSameEntry(FileSystemHandle other);
}

abstract interface class FileSystemHandlePermissionDescriptor {
  FileSystemPermissionMode get mode;
  set mode(FileSystemPermissionMode value);
}

abstract interface class FileSystemPermissionDescriptor {
  FileSystemHandle get handle;
  set handle(FileSystemHandle value);
  FileSystemPermissionMode get mode;
  set mode(FileSystemPermissionMode value);
}

typedef FileSystemPermissionMode = String;

abstract interface class OpenFilePickerOptions {
  bool get multiple;
  set multiple(bool value);
}

abstract interface class SaveFilePickerOptions {
  String? get suggestedName;
  set suggestedName(String? value);
}

typedef StartInDirectory = Object;

typedef WellKnownDirectory = String;

