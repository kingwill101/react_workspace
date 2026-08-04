// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: remote-playback
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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

