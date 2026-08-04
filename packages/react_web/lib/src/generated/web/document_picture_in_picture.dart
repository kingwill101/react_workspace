// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: document-picture-in-picture
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'anonymous_iframe.dart';
import 'html.dart';
import 'dom.dart';

abstract interface class DocumentPictureInPicture {
  Future<Window> requestWindow([DocumentPictureInPictureOptions? options]);
  Window get window;
  EventHandler get onenter;
   set onenter(EventHandler value);
}

abstract interface class DocumentPictureInPictureEvent {
  Window get window;
}

abstract interface class DocumentPictureInPictureEventInit {
  Window get window;
  set window(Window value);
}

abstract interface class DocumentPictureInPictureOptions {
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  bool get disallowReturnToOpener;
  set disallowReturnToOpener(bool value);
  bool get preferInitialWindowPlacement;
  set preferInitialWindowPlacement(bool value);
}

