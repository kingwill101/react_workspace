// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediacapture-transform
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';
import 'capture_handle_identity.dart';

abstract interface class MediaStreamTrackProcessor {
  ReadableStream get readable;
}

abstract interface class MediaStreamTrackProcessorInit {
  MediaStreamTrack get track;
  set track(MediaStreamTrack value);
  int get maxBufferSize;
  set maxBufferSize(int value);
}

abstract interface class VideoTrackGenerator {
  WritableStream get writable;
  bool get muted;
   set muted(bool value);
  MediaStreamTrack get track;
}

