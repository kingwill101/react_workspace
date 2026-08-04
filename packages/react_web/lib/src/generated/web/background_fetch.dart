// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: background-fetch
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'service_workers.dart';
import 'fetch.dart';
import 'html.dart';
import 'image_resource.dart';
import 'cookie_store.dart';
import 'background_sync.dart';
import 'content_index.dart';
import 'notifications.dart';
import 'payment_handler.dart';
import 'periodic_background_sync.dart';
import 'push_api.dart';

abstract interface class BackgroundFetchEvent {
  BackgroundFetchRegistration get registration;
}

abstract interface class BackgroundFetchEventInit {
  BackgroundFetchRegistration get registration;
  set registration(BackgroundFetchRegistration value);
}

typedef BackgroundFetchFailureReason = String;

abstract interface class BackgroundFetchManager {
  Future<BackgroundFetchRegistration> fetch(String id, Object requests, [BackgroundFetchOptions? options]);
  Future<BackgroundFetchRegistration?> get_(String id);
  Future<List<String>> getIds();
}

abstract interface class BackgroundFetchOptions {
  int get downloadTotal;
  set downloadTotal(int value);
}

abstract interface class BackgroundFetchRecord {
  Request get request;
  Future<Response> get responseReady;
}

abstract interface class BackgroundFetchRegistration {
  String get id;
  int get uploadTotal;
  int get uploaded;
  int get downloadTotal;
  int get downloaded;
  BackgroundFetchResult get result;
  BackgroundFetchFailureReason get failureReason;
  bool get recordsAvailable;
  EventHandler get onprogress;
   set onprogress(EventHandler value);
  Future<bool> abort();
  Future<BackgroundFetchRecord> match(RequestInfo request, [CacheQueryOptions? options]);
  Future<List<BackgroundFetchRecord>> matchAll([RequestInfo? request, CacheQueryOptions? options]);
}

typedef BackgroundFetchResult = String;

abstract interface class BackgroundFetchUIOptions {
  List<ImageResource> get icons;
  set icons(List<ImageResource> value);
  String get title;
  set title(String value);
}

abstract interface class BackgroundFetchUpdateUIEvent {
  Future<void> updateUI([BackgroundFetchUIOptions? options]);
}

abstract interface class ServiceWorkerGlobalScope {
  EventHandler get onbackgroundfetchsuccess;
   set onbackgroundfetchsuccess(EventHandler value);
  EventHandler get onbackgroundfetchfail;
   set onbackgroundfetchfail(EventHandler value);
  EventHandler get onbackgroundfetchabort;
   set onbackgroundfetchabort(EventHandler value);
  EventHandler get onbackgroundfetchclick;
   set onbackgroundfetchclick(EventHandler value);
  EventHandler get onsync;
   set onsync(EventHandler value);
  EventHandler get oncontentdelete;
   set oncontentdelete(EventHandler value);
  CookieStore get cookieStore;
  EventHandler get oncookiechange;
   set oncookiechange(EventHandler value);
  EventHandler get onnotificationclick;
   set onnotificationclick(EventHandler value);
  EventHandler get onnotificationclose;
   set onnotificationclose(EventHandler value);
  EventHandler get oncanmakepayment;
   set oncanmakepayment(EventHandler value);
  EventHandler get onpaymentrequest;
   set onpaymentrequest(EventHandler value);
  EventHandler get onperiodicsync;
   set onperiodicsync(EventHandler value);
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
  BackgroundFetchManager get backgroundFetch;
  SyncManager get sync_;
  ContentIndex get index;
  CookieStoreManager get cookies;
  Future<void> showNotification(String title, [NotificationOptions? options]);
  Future<List<Notification>> getNotifications([GetNotificationOptions? filter]);
  PaymentManager get paymentManager;
  PeriodicSyncManager get periodicSync;
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

