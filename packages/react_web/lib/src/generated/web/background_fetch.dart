// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: background-fetch
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';
import 'image_resource.dart';
import 'html.dart';
import 'background_sync.dart';
import 'notifications.dart';
import 'push_api.dart';

abstract interface class BackgroundFetchEventInit {
  Object get registration;
  set registration(Object value);
}

final class BackgroundFetchEventInitValue implements BackgroundFetchEventInit {
  @override
  Object registration;

  BackgroundFetchEventInitValue({
    required this.registration,
  });
}

typedef BackgroundFetchFailureReason = String;

abstract interface class BackgroundFetchOptions {
  int? get downloadTotal;
  set downloadTotal(int? value);
}

final class BackgroundFetchOptionsValue implements BackgroundFetchOptions {
  @override
  int? downloadTotal;

  BackgroundFetchOptionsValue({
    this.downloadTotal,
  });
}

typedef BackgroundFetchResult = String;

abstract interface class BackgroundFetchUIOptions {
  List<ImageResource>? get icons;
  set icons(List<ImageResource>? value);
  String? get title;
  set title(String? value);
}

final class BackgroundFetchUIOptionsValue implements BackgroundFetchUIOptions {
  @override
  List<ImageResource>? icons;
  @override
  String? title;

  BackgroundFetchUIOptionsValue({
    this.icons,
    this.title,
  });
}

abstract interface class ServiceWorkerGlobalScope {
  EventHandler get onsync;
   set onsync(EventHandler value);
  EventHandler get onnotificationclick;
   set onnotificationclick(EventHandler value);
  EventHandler get onnotificationclose;
   set onnotificationclose(EventHandler value);
  EventHandler get onpush;
   set onpush(EventHandler value);
  EventHandler get onpushsubscriptionchange;
   set onpushsubscriptionchange(EventHandler value);
  Clients get clients;
  ServiceWorkerRegistration get registration;
  ServiceWorker get serviceWorker;
  Future<void> skipWaiting();
  EventHandler get oninstall;
   set oninstall(EventHandler value);
  EventHandler get onactivate;
   set onactivate(EventHandler value);
  EventHandler get onfetch;
   set onfetch(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

abstract interface class ServiceWorkerRegistration {
  SyncManager get sync_;
  Future<void> showNotification(String title, [NotificationOptions? options]);
  Future<List<Notification>> getNotifications([GetNotificationOptions? filter]);
  PushManager get pushManager;
  ServiceWorker? get installing;
  ServiceWorker? get waiting;
  ServiceWorker? get active;
  NavigationPreloadManager get navigationPreload;
  String get scope;
  ServiceWorkerUpdateViaCache get updateViaCache;
  Future<void> update();
  Future<bool> unregister();
  EventHandler get onupdatefound;
   set onupdatefound(EventHandler value);
}

