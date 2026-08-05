// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: xhr
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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
  bool get lengthComputable;
  set lengthComputable(bool value);
  int get loaded;
  set loaded(int value);
  int get total;
  set total(int value);
}

abstract interface class XMLHttpRequestEventTarget {
}

typedef XMLHttpRequestResponseType = String;

abstract interface class XMLHttpRequestUpload {
}

