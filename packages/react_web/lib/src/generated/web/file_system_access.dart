// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: file-system-access
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fs.dart';
import 'permissions.dart';

abstract interface class DirectoryPickerOptions {
  String? get id;
  set id(String? value);
  StartInDirectory? get startIn;
  set startIn(StartInDirectory? value);
  FileSystemPermissionMode? get mode;
  set mode(FileSystemPermissionMode? value);
}

final class DirectoryPickerOptionsValue implements DirectoryPickerOptions {
  @override
  String? id;
  @override
  StartInDirectory? startIn;
  @override
  FileSystemPermissionMode? mode;

  DirectoryPickerOptionsValue({
    this.id,
    this.startIn,
    this.mode,
  });
}

abstract interface class FilePickerAcceptType {
  String? get description;
  set description(String? value);
  Map<String, Object>? get accept;
  set accept(Map<String, Object>? value);
}

final class FilePickerAcceptTypeValue implements FilePickerAcceptType {
  @override
  String? description;
  @override
  Map<String, Object>? accept;

  FilePickerAcceptTypeValue({
    this.description,
    this.accept,
  });
}

abstract interface class FilePickerOptions {
  List<FilePickerAcceptType>? get types;
  set types(List<FilePickerAcceptType>? value);
  bool? get excludeAcceptAllOption;
  set excludeAcceptAllOption(bool? value);
  String? get id;
  set id(String? value);
  StartInDirectory? get startIn;
  set startIn(StartInDirectory? value);
}

final class FilePickerOptionsValue implements FilePickerOptions {
  @override
  List<FilePickerAcceptType>? types;
  @override
  bool? excludeAcceptAllOption;
  @override
  String? id;
  @override
  StartInDirectory? startIn;

  FilePickerOptionsValue({
    this.types,
    this.excludeAcceptAllOption,
    this.id,
    this.startIn,
  });
}

abstract interface class FileSystemHandle {
  FileSystemHandleKind get kind;
  String get name;
  Future<bool> isSameEntry(FileSystemHandle other);
}

abstract interface class FileSystemHandlePermissionDescriptor {
  FileSystemPermissionMode? get mode;
  set mode(FileSystemPermissionMode? value);
}

final class FileSystemHandlePermissionDescriptorValue implements FileSystemHandlePermissionDescriptor {
  @override
  FileSystemPermissionMode? mode;

  FileSystemHandlePermissionDescriptorValue({
    this.mode,
  });
}

abstract interface class FileSystemPermissionDescriptor {
  FileSystemHandle get handle;
  set handle(FileSystemHandle value);
  FileSystemPermissionMode? get mode;
  set mode(FileSystemPermissionMode? value);
}

final class FileSystemPermissionDescriptorValue implements FileSystemPermissionDescriptor {
  @override
  FileSystemHandle handle;
  @override
  FileSystemPermissionMode? mode;

  FileSystemPermissionDescriptorValue({
    required this.handle,
    this.mode,
  });
}

typedef FileSystemPermissionMode = String;

abstract interface class OpenFilePickerOptions {
  bool? get multiple;
  set multiple(bool? value);
}

final class OpenFilePickerOptionsValue implements OpenFilePickerOptions {
  @override
  bool? multiple;

  OpenFilePickerOptionsValue({
    this.multiple,
  });
}

abstract interface class SaveFilePickerOptions {
  String? get suggestedName;
  set suggestedName(String? value);
}

final class SaveFilePickerOptionsValue implements SaveFilePickerOptions {
  @override
  String? suggestedName;

  SaveFilePickerOptionsValue({
    this.suggestedName,
  });
}

typedef StartInDirectory = Object;

typedef WellKnownDirectory = String;

