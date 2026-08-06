// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: picture-in-picture
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class PictureInPictureEvent {
  factory PictureInPictureEvent(String type, PictureInPictureEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<PictureInPictureEvent>(
        'PictureInPictureEvent',
        [type, eventInitDict],
      );
  PictureInPictureWindow get pictureInPictureWindow;
}

abstract interface class PictureInPictureEventInit {
  PictureInPictureWindow get pictureInPictureWindow;
  set pictureInPictureWindow(PictureInPictureWindow value);
}

final class PictureInPictureEventInitValue implements PictureInPictureEventInit {
  @override
  PictureInPictureWindow pictureInPictureWindow;

  PictureInPictureEventInitValue({
    required this.pictureInPictureWindow,
  });
}

abstract interface class PictureInPictureWindow {
  int get width;
  int get height;
  EventHandler get onresize;
   set onresize(EventHandler value);
}

