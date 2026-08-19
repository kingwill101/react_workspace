// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: content-index
// ignore_for_file: type=lint

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
  ContentCategory? get category;
  set category(ContentCategory? value);
  List<ImageResource>? get icons;
  set icons(List<ImageResource>? value);
  String get url;
  set url(String value);
}

final class ContentDescriptionValue implements ContentDescription {
  @override
  String id;
  @override
  String title;
  @override
  String description;
  @override
  ContentCategory? category;
  @override
  List<ImageResource>? icons;
  @override
  String url;

  ContentDescriptionValue({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.icons,
    required this.url,
  });
}

abstract interface class ContentIndexEventInit {
  String get id;
  set id(String value);
}

final class ContentIndexEventInitValue implements ContentIndexEventInit {
  @override
  String id;

  ContentIndexEventInitValue({required this.id});
}
