// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: image-resource
// ignore_for_file: type=lint


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

