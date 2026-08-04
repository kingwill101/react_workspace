// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: xhr
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'cssom_view.dart';
import 'fileapi.dart';
import 'dom.dart';

abstract interface class FormData {
  void append(String name, Blob blobValue, [String? filename]);
  void delete(String name);
  FormDataEntryValue? get_(String name);
  List<FormDataEntryValue> getAll(String name);
  bool has(String name);
  void set_(String name, Blob blobValue, [String? filename]);
   Iterable<(String, FormDataEntryValue)> get entries;
   Iterable<String> get keys;
   Iterable<FormDataEntryValue> get values;
}

typedef FormDataEntryValue = Object;

abstract interface class ProgressEvent {
  bool get lengthComputable;
  int get loaded;
  int get total;
}

abstract interface class ProgressEventInit {
  bool get lengthComputable;
  set lengthComputable(bool value);
  int get loaded;
  set loaded(int value);
  int get total;
  set total(int value);
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

