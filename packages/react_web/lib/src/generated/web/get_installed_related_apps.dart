// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: get-installed-related-apps
// ignore_for_file: type=lint


abstract interface class RelatedApplication {
  String get platform;
  set platform(String value);
  String? get url;
  set url(String? value);
  String? get id;
  set id(String? value);
  String? get version;
  set version(String? value);
}

final class RelatedApplicationValue implements RelatedApplication {
  @override
  String platform;
  @override
  String? url;
  @override
  String? id;
  @override
  String? version;

  RelatedApplicationValue({
    required this.platform,
    this.url,
    this.id,
    this.version,
  });
}

