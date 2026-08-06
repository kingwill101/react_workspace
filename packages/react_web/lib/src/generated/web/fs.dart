// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: fs
// ignore_for_file: type=lint

import 'file_system_access.dart';
import 'fileapi.dart';
import 'webidl.dart';
import 'storage.dart';

abstract interface class FileSystemCreateWritableOptions {
  bool? get keepExistingData;
  set keepExistingData(bool? value);
}

final class FileSystemCreateWritableOptionsValue implements FileSystemCreateWritableOptions {
  @override
  bool? keepExistingData;

  FileSystemCreateWritableOptionsValue({
    this.keepExistingData,
  });
}

abstract interface class FileSystemDirectoryHandle {
  Future<FileSystemFileHandle> getFileHandle(String name, [FileSystemGetFileOptions? options]);
  Future<FileSystemDirectoryHandle> getDirectoryHandle(String name, [FileSystemGetDirectoryOptions? options]);
  Future<void> removeEntry(String name, [FileSystemRemoveOptions? options]);
  Future<List<String>?> resolve(FileSystemHandle possibleDescendant);
}

abstract interface class FileSystemFileHandle {
  Future<File> getFile();
  Future<FileSystemWritableFileStream> createWritable([FileSystemCreateWritableOptions? options]);
  Future<FileSystemSyncAccessHandle> createSyncAccessHandle();
}

abstract interface class FileSystemGetDirectoryOptions {
  bool? get create;
  set create(bool? value);
}

final class FileSystemGetDirectoryOptionsValue implements FileSystemGetDirectoryOptions {
  @override
  bool? create;

  FileSystemGetDirectoryOptionsValue({
    this.create,
  });
}

abstract interface class FileSystemGetFileOptions {
  bool? get create;
  set create(bool? value);
}

final class FileSystemGetFileOptionsValue implements FileSystemGetFileOptions {
  @override
  bool? create;

  FileSystemGetFileOptionsValue({
    this.create,
  });
}

typedef FileSystemHandleKind = String;

abstract interface class FileSystemReadWriteOptions {
  int? get at;
  set at(int? value);
}

final class FileSystemReadWriteOptionsValue implements FileSystemReadWriteOptions {
  @override
  int? at;

  FileSystemReadWriteOptionsValue({
    this.at,
  });
}

abstract interface class FileSystemRemoveOptions {
  bool? get recursive;
  set recursive(bool? value);
}

final class FileSystemRemoveOptionsValue implements FileSystemRemoveOptions {
  @override
  bool? recursive;

  FileSystemRemoveOptionsValue({
    this.recursive,
  });
}

abstract interface class FileSystemSyncAccessHandle {
  int read(AllowSharedBufferSource buffer, [FileSystemReadWriteOptions? options]);
  int write(AllowSharedBufferSource buffer, [FileSystemReadWriteOptions? options]);
  void truncate(int newSize);
  int getSize();
  void flush();
  void close();
}

abstract interface class FileSystemWritableFileStream {
  Future<void> write(FileSystemWriteChunkType data);
  Future<void> seek(int position);
  Future<void> truncate(int size);
}

typedef FileSystemWriteChunkType = Object;

abstract interface class StorageManager {
  Future<FileSystemDirectoryHandle> getDirectory();
  Future<bool> persisted();
  Future<bool> persist();
  Future<StorageEstimate> estimate();
}

typedef WriteCommandType = String;

abstract interface class WriteParams {
  WriteCommandType get type;
  set type(WriteCommandType value);
  int? get size;
  set size(int? value);
  int? get position;
  set position(int? value);
  Object? get data;
  set data(Object? value);
}

final class WriteParamsValue implements WriteParams {
  @override
  WriteCommandType type;
  @override
  int? size;
  @override
  int? position;
  @override
  Object? data;

  WriteParamsValue({
    required this.type,
    this.size,
    this.position,
    this.data,
  });
}

