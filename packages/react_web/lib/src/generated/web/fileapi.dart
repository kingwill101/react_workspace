// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: FileAPI
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';
import 'webidl.dart';
import 'html.dart';
import 'url.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Blob {
  factory Blob([List<BlobPart>? blobParts, BlobPropertyBag? options]) =>
      WebRuntime.current.createWebObject<Blob>(
        'Blob',
        [blobParts, options],
      );
  int get size;
  String get type;
  Blob slice([int? start, int? end, String? contentType]);
  ReadableStream stream();
  Future<String> text();
  Future<Object> arrayBuffer();
}

typedef BlobPart = Object;

abstract interface class BlobPropertyBag {
  String? get type;
  set type(String? value);
  EndingType? get endings;
  set endings(EndingType? value);
}

final class BlobPropertyBagValue implements BlobPropertyBag {
  @override
  String? type;
  @override
  EndingType? endings;

  BlobPropertyBagValue({
    this.type,
    this.endings,
  });
}

typedef EndingType = String;

abstract interface class File {
  factory File(List<BlobPart> fileBits, String fileName, [FilePropertyBag? options]) =>
      WebRuntime.current.createWebObject<File>(
        'File',
        [fileBits, fileName, options],
      );
  String get name;
  int get lastModified;
  String get webkitRelativePath;
}

abstract interface class FileList {
  File? item(int index);
  int get length;
}

abstract interface class FilePropertyBag {
  int? get lastModified;
  set lastModified(int? value);
}

final class FilePropertyBagValue implements FilePropertyBag {
  @override
  int? lastModified;

  FilePropertyBagValue({
    this.lastModified,
  });
}

abstract interface class FileReader {
  factory FileReader() =>
      WebRuntime.current.createWebObject<FileReader>(
        'FileReader',
        [],
      );
  void readAsArrayBuffer(Blob blob);
  void readAsBinaryString(Blob blob);
  void readAsText(Blob blob, [String? encoding]);
  void readAsDataURL(Blob blob);
  void abort();
  int get readyState;
  Object get result;
  DOMException? get error;
  EventHandler get onloadstart;
   set onloadstart(EventHandler value);
  EventHandler get onprogress;
   set onprogress(EventHandler value);
  EventHandler get onload;
   set onload(EventHandler value);
  EventHandler get onabort;
   set onabort(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onloadend;
   set onloadend(EventHandler value);
}

abstract interface class FileReaderSync {
  factory FileReaderSync() =>
      WebRuntime.current.createWebObject<FileReaderSync>(
        'FileReaderSync',
        [],
      );
  Object readAsArrayBuffer(Blob blob);
  String readAsBinaryString(Blob blob);
  String readAsText(Blob blob, [String? encoding]);
  String readAsDataURL(Blob blob);
}

abstract interface class URL {
  factory URL(String url, [String? base]) =>
      WebRuntime.current.createWebObject<URL>(
        'URL',
        [url, base],
      );
  String get href;
   set href(String value);
  String get origin;
  String get protocol;
   set protocol(String value);
  String get username;
   set username(String value);
  String get password;
   set password(String value);
  String get host;
   set host(String value);
  String get hostname;
   set hostname(String value);
  String get port;
   set port(String value);
  String get pathname;
   set pathname(String value);
  String get search;
   set search(String value);
  URLSearchParams get searchParams;
  String get hash;
   set hash(String value);
  String toJSON();
}

