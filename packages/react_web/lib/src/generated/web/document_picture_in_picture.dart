// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: document-picture-in-picture
// ignore_for_file: type=lint

import 'anonymous_iframe.dart';
import 'dom.dart';

abstract interface class DocumentPictureInPictureEventInit {
  Window get window;
  set window(Window value);
}

final class DocumentPictureInPictureEventInitValue implements DocumentPictureInPictureEventInit {
  @override
  Window window;

  DocumentPictureInPictureEventInitValue({
    required this.window,
  });
}

abstract interface class DocumentPictureInPictureOptions {
  int? get width;
  set width(int? value);
  int? get height;
  set height(int? value);
  bool? get disallowReturnToOpener;
  set disallowReturnToOpener(bool? value);
}

final class DocumentPictureInPictureOptionsValue implements DocumentPictureInPictureOptions {
  @override
  int? width;
  @override
  int? height;
  @override
  bool? disallowReturnToOpener;

  DocumentPictureInPictureOptionsValue({
    this.width,
    this.height,
    this.disallowReturnToOpener,
  });
}

