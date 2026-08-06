// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: mediacapture-transform
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';
import 'capture_handle_identity.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class MediaStreamTrackProcessor {
  factory MediaStreamTrackProcessor(MediaStreamTrackProcessorInit init) =>
      WebRuntime.current.createWebObject<MediaStreamTrackProcessor>(
        'MediaStreamTrackProcessor',
        [init],
      );
  ReadableStream get readable;
}

abstract interface class MediaStreamTrackProcessorInit {
  MediaStreamTrack get track;
  set track(MediaStreamTrack value);
  int? get maxBufferSize;
  set maxBufferSize(int? value);
}

final class MediaStreamTrackProcessorInitValue implements MediaStreamTrackProcessorInit {
  @override
  MediaStreamTrack track;
  @override
  int? maxBufferSize;

  MediaStreamTrackProcessorInitValue({
    required this.track,
    this.maxBufferSize,
  });
}

