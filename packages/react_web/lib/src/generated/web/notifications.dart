// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: notifications
// ignore_for_file: type=lint

import 'html.dart';
import 'service_workers.dart';
import 'vibration.dart';
import 'hr_time.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class GetNotificationOptions {
  String? get tag;
  set tag(String? value);
}

final class GetNotificationOptionsValue implements GetNotificationOptions {
  @override
  String? tag;

  GetNotificationOptionsValue({this.tag});
}

abstract interface class Notification {
  factory Notification(String title, [NotificationOptions? options]) =>
      WebRuntime.current.createWebObject<Notification>('Notification', [
        title,
        options,
      ]);
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
  String get icon;
  String get badge;
  bool? get silent;
  bool get requireInteraction;
  Object get data;
  void close();
}

abstract interface class NotificationAction {
  String get action;
  set action(String value);
  String get title;
  set title(String value);
  String? get icon;
  set icon(String? value);
}

final class NotificationActionValue implements NotificationAction {
  @override
  String action;
  @override
  String title;
  @override
  String? icon;

  NotificationActionValue({
    required this.action,
    required this.title,
    this.icon,
  });
}

typedef NotificationDirection = String;

abstract interface class NotificationEvent {
  factory NotificationEvent(
    String type_,
    NotificationEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<NotificationEvent>(
    'NotificationEvent',
    [type_, eventInitDict],
  );
  Notification get notification;
  String get action;
}

abstract interface class NotificationEventInit {
  Notification get notification;
  set notification(Notification value);
  String? get action;
  set action(String? value);
}

final class NotificationEventInitValue implements NotificationEventInit {
  @override
  Notification notification;
  @override
  String? action;

  NotificationEventInitValue({required this.notification, this.action});
}

abstract interface class NotificationOptions {
  NotificationDirection? get dir;
  set dir(NotificationDirection? value);
  String? get lang;
  set lang(String? value);
  String? get body;
  set body(String? value);
  String? get tag;
  set tag(String? value);
  String? get image;
  set image(String? value);
  String? get icon;
  set icon(String? value);
  String? get badge;
  set badge(String? value);
  VibratePattern? get vibrate;
  set vibrate(VibratePattern? value);
  EpochTimeStamp? get timestamp;
  set timestamp(EpochTimeStamp? value);
  bool? get renotify;
  set renotify(bool? value);
  bool? get silent;
  set silent(bool? value);
  bool? get requireInteraction;
  set requireInteraction(bool? value);
  Object? get data;
  set data(Object? value);
  List<NotificationAction>? get actions;
  set actions(List<NotificationAction>? value);
}

final class NotificationOptionsValue implements NotificationOptions {
  @override
  NotificationDirection? dir;
  @override
  String? lang;
  @override
  String? body;
  @override
  String? tag;
  @override
  String? image;
  @override
  String? icon;
  @override
  String? badge;
  @override
  VibratePattern? vibrate;
  @override
  EpochTimeStamp? timestamp;
  @override
  bool? renotify;
  @override
  bool? silent;
  @override
  bool? requireInteraction;
  @override
  Object? data;
  @override
  List<NotificationAction>? actions;

  NotificationOptionsValue({
    this.dir,
    this.lang,
    this.body,
    this.tag,
    this.image,
    this.icon,
    this.badge,
    this.vibrate,
    this.timestamp,
    this.renotify,
    this.silent,
    this.requireInteraction,
    this.data,
    this.actions,
  });
}

typedef NotificationPermission = String;

typedef NotificationPermissionCallback =
    void Function(NotificationPermission permission);
