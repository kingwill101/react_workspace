// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: image-resource
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class ImageResource {
  String get src;
  set src(String value);
  String? get sizes;
  set sizes(String? value);
  String? get type;
  set type(String? value);
  String? get label;
  set label(String? value);
}

final class ImageResourceValue implements ImageResource {
  @override
  String src;
  @override
  String? sizes;
  @override
  String? type;
  @override
  String? label;

  ImageResourceValue({
    required this.src,
    this.sizes,
    this.type,
    this.label,
  });
}

