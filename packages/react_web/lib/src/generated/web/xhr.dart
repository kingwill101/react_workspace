// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: xhr
// ignore_for_file: type=lint

import 'html.dart';
import 'cssom_view.dart';
import 'fileapi.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class FormData {
  factory FormData([HTMLFormElement? form, HTMLElement? submitter]) =>
      WebRuntime.current.createWebObject<FormData>(
        'FormData',
        [form, submitter],
      );
  void append(String name, Blob blobValue, [String? filename]);
  void delete(String name);
  FormDataEntryValue? get_(String name);
  List<FormDataEntryValue> getAll(String name);
  bool has(String name);
  void set_(String name, Blob blobValue, [String? filename]);
}

typedef FormDataEntryValue = Object;

abstract interface class ProgressEvent {
  factory ProgressEvent(String type, [ProgressEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ProgressEvent>(
        'ProgressEvent',
        [type, eventInitDict],
      );
  bool get lengthComputable;
  int get loaded;
  int get total;
}

abstract interface class ProgressEventInit {
  bool? get lengthComputable;
  set lengthComputable(bool? value);
  int? get loaded;
  set loaded(int? value);
  int? get total;
  set total(int? value);
}

final class ProgressEventInitValue implements ProgressEventInit {
  @override
  bool? lengthComputable;
  @override
  int? loaded;
  @override
  int? total;

  ProgressEventInitValue({
    this.lengthComputable,
    this.loaded,
    this.total,
  });
}

abstract interface class XMLHttpRequestEventTarget {
  EventHandler get onloadstart;
   set onloadstart(EventHandler value);
  EventHandler get onprogress;
   set onprogress(EventHandler value);
  EventHandler get onabort;
   set onabort(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onload;
   set onload(EventHandler value);
  EventHandler get ontimeout;
   set ontimeout(EventHandler value);
  EventHandler get onloadend;
   set onloadend(EventHandler value);
}

typedef XMLHttpRequestResponseType = String;

abstract interface class XMLHttpRequestUpload {
}

