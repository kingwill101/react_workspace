// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: entries-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'fileapi.dart';
import 'webidl.dart';
import 'css_nav.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class DataTransferItem {
  FileSystemEntry? webkitGetAsEntry();
  String get kind;
  String get type;
  void getAsString(FunctionStringCallback? callback);
  File? getAsFile();
}

typedef ErrorCallback = void Function(DOMException err,);

typedef FileCallback = void Function(File file,);

abstract interface class FileSystem {
  String get name;
  FileSystemDirectoryEntry get root;
}

abstract interface class FileSystemDirectoryEntry {
  FileSystemDirectoryReader createReader();
  void getFile([String? path, FileSystemFlags? options, FileSystemEntryCallback? successCallback, ErrorCallback? errorCallback]);
  void getDirectory([String? path, FileSystemFlags? options, FileSystemEntryCallback? successCallback, ErrorCallback? errorCallback]);
}

abstract interface class FileSystemDirectoryReader {
  void readEntries(FileSystemEntriesCallback successCallback, [ErrorCallback? errorCallback]);
}

typedef FileSystemEntriesCallback = void Function(List<FileSystemEntry> entries,);

abstract interface class FileSystemEntry {
  bool get isFile;
  bool get isDirectory;
  String get name;
  String get fullPath;
  FileSystem get filesystem;
  void getParent([FileSystemEntryCallback? successCallback, ErrorCallback? errorCallback]);
}

typedef FileSystemEntryCallback = void Function(FileSystemEntry entry,);

abstract interface class FileSystemFileEntry {
  void file(FileCallback successCallback, [ErrorCallback? errorCallback]);
}

abstract interface class FileSystemFlags {
  bool? get create;
  set create(bool? value);
  bool? get exclusive;
  set exclusive(bool? value);
}

final class FileSystemFlagsValue implements FileSystemFlags {
  @override
  bool? create;
  @override
  bool? exclusive;

  FileSystemFlagsValue({
    this.create,
    this.exclusive,
  });
}

abstract interface class HTMLInputElement {
  factory HTMLInputElement() =>
      WebRuntime.current.createWebObject<HTMLInputElement>(
        'HTMLInputElement',
        [],
      );
  Element? get popoverTargetElement;
   set popoverTargetElement(Element? value);
  String get popoverTargetAction;
   set popoverTargetAction(String value);
  bool get webkitdirectory;
   set webkitdirectory(bool value);
  List<FileSystemEntry> get webkitEntries;
  String get capture;
   set capture(String value);
  String get accept;
   set accept(String value);
  String get alt;
   set alt(String value);
  String get autocomplete;
   set autocomplete(String value);
  bool get defaultChecked;
   set defaultChecked(bool value);
  bool get checked;
   set checked(bool value);
  String get dirName;
   set dirName(String value);
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  FileList? get files;
   set files(FileList? value);
  String get formAction;
   set formAction(String value);
  String get formEnctype;
   set formEnctype(String value);
  String get formMethod;
   set formMethod(String value);
  bool get formNoValidate;
   set formNoValidate(bool value);
  String get formTarget;
   set formTarget(String value);
  int get height;
   set height(int value);
  bool get indeterminate;
   set indeterminate(bool value);
  HTMLDataListElement? get list;
  String get max;
   set max(String value);
  int get maxLength;
   set maxLength(int value);
  String get min;
   set min(String value);
  int get minLength;
   set minLength(int value);
  bool get multiple;
   set multiple(bool value);
  String get name;
   set name(String value);
  String get pattern;
   set pattern(String value);
  String get placeholder;
   set placeholder(String value);
  bool get readOnly;
   set readOnly(bool value);
  bool get required_;
   set required_(bool value);
  int get size;
   set size(int value);
  String get src;
   set src(String value);
  String get step;
   set step(String value);
  String get type;
   set type(String value);
  String get defaultValue;
   set defaultValue(String value);
  String get value;
   set value(String value);
  Object? get valueAsDate;
   set valueAsDate(Object? value);
  double get valueAsNumber;
   set valueAsNumber(double value);
  int get width;
   set width(int value);
  void stepUp([int? n]);
  void stepDown([int? n]);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  NodeList? get labels;
  void select();
  int? get selectionStart;
   set selectionStart(int? value);
  int? get selectionEnd;
   set selectionEnd(int? value);
  String? get selectionDirection;
   set selectionDirection(String? value);
  void setRangeText(String replacement, int start, int end, [SelectionMode? selectionMode]);
  void setSelectionRange(int start, int end, [String? direction]);
  void showPicker();
  String get align;
   set align(String value);
  String get useMap;
   set useMap(String value);
}

