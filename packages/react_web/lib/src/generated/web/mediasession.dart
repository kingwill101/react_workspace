// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediasession
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'package:react_web/src/web_runtime.dart';

abstract interface class ChapterInformationInit {
  String get title;
  set title(String value);
  double get startTime;
  set startTime(double value);
  List<MediaImage> get artwork;
  set artwork(List<MediaImage> value);
}

abstract interface class MediaImage {
  String get src;
  set src(String value);
  String get sizes;
  set sizes(String value);
  String get type;
  set type(String value);
}

abstract interface class MediaMetadata {
  factory MediaMetadata([MediaMetadataInit? init]) =>
      WebRuntime.current.createWebObject<MediaMetadata>(
        'MediaMetadata',
        [init],
      );
  String get title;
   set title(String value);
  String get artist;
   set artist(String value);
  String get album;
   set album(String value);
  List<MediaImage> get artwork;
   set artwork(List<MediaImage> value);
}

abstract interface class MediaMetadataInit {
  String get title;
  set title(String value);
  String get artist;
  set artist(String value);
  String get album;
  set album(String value);
  List<MediaImage> get artwork;
  set artwork(List<MediaImage> value);
  List<ChapterInformationInit> get chapterInfo;
  set chapterInfo(List<ChapterInformationInit> value);
}

abstract interface class MediaPositionState {
  double get duration;
  set duration(double value);
  double get playbackRate;
  set playbackRate(double value);
  double get position;
  set position(double value);
}

abstract interface class MediaSession {
  MediaMetadata? get metadata;
   set metadata(MediaMetadata? value);
  MediaSessionPlaybackState get playbackState;
   set playbackState(MediaSessionPlaybackState value);
  void setActionHandler(MediaSessionAction action, MediaSessionActionHandler? handler);
  void setPositionState([MediaPositionState? state]);
}

typedef MediaSessionAction = String;

abstract interface class MediaSessionActionDetails {
  MediaSessionAction get action;
  set action(MediaSessionAction value);
}

typedef MediaSessionActionHandler = void Function(MediaSessionActionDetails details,);

abstract interface class MediaSessionCaptureActionDetails {
  bool get isActivating;
  set isActivating(bool value);
}

typedef MediaSessionPlaybackState = String;

abstract interface class MediaSessionSeekActionDetails {
  double get seekOffset;
  set seekOffset(double value);
}

abstract interface class MediaSessionSeekToActionDetails {
  double get seekTime;
  set seekTime(double value);
  bool get fastSeek;
  set fastSeek(bool value);
}

