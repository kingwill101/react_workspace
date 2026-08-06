// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: remote-playback
// ignore_for_file: type=lint

import 'html.dart';

abstract interface class RemotePlayback {
  Future<int> watchAvailability(RemotePlaybackAvailabilityCallback callback);
  Future<void> cancelWatchAvailability([int? id]);
  RemotePlaybackState get state;
  EventHandler get onconnecting;
   set onconnecting(EventHandler value);
  EventHandler get onconnect;
   set onconnect(EventHandler value);
  EventHandler get ondisconnect;
   set ondisconnect(EventHandler value);
  Future<void> prompt();
}

typedef RemotePlaybackAvailabilityCallback = void Function(bool available,);

typedef RemotePlaybackState = String;

