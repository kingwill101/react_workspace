// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: notifications
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'hr_time.dart';
import 'service_workers.dart';
import 'vibration.dart';

abstract interface class GetNotificationOptions {
  String get tag;
  set tag(String value);
}

abstract interface class Notification {
  EventHandler get onclick;
   set onclick(EventHandler value);
  EventHandler get onshow;
   set onshow(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  String get title;
  NotificationDirection get dir;
  String get lang;
  String get body;
  String get tag;
  String get image;
  String get icon;
  String get badge;
  List<int> get vibrate;
  EpochTimeStamp get timestamp;
  bool get renotify;
  bool? get silent;
  bool get requireInteraction;
  Object get data;
  List<NotificationAction> get actions;
  void close();
}

abstract interface class NotificationAction {
  String get action;
  set action(String value);
  String get title;
  set title(String value);
  String get icon;
  set icon(String value);
}

typedef NotificationDirection = String;

abstract interface class NotificationEvent {
  Notification get notification;
  String get action;
}

abstract interface class NotificationEventInit {
  Notification get notification;
  set notification(Notification value);
  String get action;
  set action(String value);
}

abstract interface class NotificationOptions {
  NotificationDirection get dir;
  set dir(NotificationDirection value);
  String get lang;
  set lang(String value);
  String get body;
  set body(String value);
  String get tag;
  set tag(String value);
  String get image;
  set image(String value);
  String get icon;
  set icon(String value);
  String get badge;
  set badge(String value);
  VibratePattern get vibrate;
  set vibrate(VibratePattern value);
  EpochTimeStamp get timestamp;
  set timestamp(EpochTimeStamp value);
  bool get renotify;
  set renotify(bool value);
  bool? get silent;
  set silent(bool? value);
  bool get requireInteraction;
  set requireInteraction(bool value);
  Object get data;
  set data(Object value);
  List<NotificationAction> get actions;
  set actions(List<NotificationAction> value);
}

typedef NotificationPermission = String;

typedef NotificationPermissionCallback = void Function(NotificationPermission permission,);

