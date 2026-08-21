// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-share
// ignore_for_file: type=lint

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

  ShareDataValue({this.files, this.title, this.text, this.url});
}
