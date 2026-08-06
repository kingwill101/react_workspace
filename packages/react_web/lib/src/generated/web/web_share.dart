// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: web-share
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fileapi.dart';

abstract interface class ShareData {
  List<File>? get files;
  set files(List<File>? value);
  String? get title;
  set title(String? value);
  String? get text;
  set text(String? value);
  String? get url;
  set url(String? value);
}

final class ShareDataValue implements ShareData {
  @override
  List<File>? files;
  @override
  String? title;
  @override
  String? text;
  @override
  String? url;

  ShareDataValue({
    this.files,
    this.title,
    this.text,
    this.url,
  });
}

