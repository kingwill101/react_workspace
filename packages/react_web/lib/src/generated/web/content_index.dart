// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: content-index
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'image_resource.dart';
import 'service_workers.dart';

typedef ContentCategory = String;

abstract interface class ContentDescription {
  String get id;
  set id(String value);
  String get title;
  set title(String value);
  String get description;
  set description(String value);
  ContentCategory get category;
  set category(ContentCategory value);
  List<ImageResource> get icons;
  set icons(List<ImageResource> value);
  String get url;
  set url(String value);
}

abstract interface class ContentIndexEventInit {
  String get id;
  set id(String value);
}

