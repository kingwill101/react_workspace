// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: cookie-store
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'hr_time.dart';
import 'html.dart';
import 'service_workers.dart';

abstract interface class CookieChangeEvent {
  List<CookieListItem> get changed;
  List<CookieListItem> get deleted;
}

abstract interface class CookieChangeEventInit {
  CookieList get changed;
  set changed(CookieList value);
  CookieList get deleted;
  set deleted(CookieList value);
}

abstract interface class CookieInit {
  String get name;
  set name(String value);
  String get value;
  set value(String value);
  DOMHighResTimeStamp? get expires;
  set expires(DOMHighResTimeStamp? value);
  String? get domain;
  set domain(String? value);
  String get path;
  set path(String value);
  CookieSameSite get sameSite;
  set sameSite(CookieSameSite value);
  bool get partitioned;
  set partitioned(bool value);
}

typedef CookieList = List<CookieListItem>;

abstract interface class CookieListItem {
  String get name;
  set name(String value);
  String get value;
  set value(String value);
  String? get domain;
  set domain(String? value);
  String get path;
  set path(String value);
  DOMHighResTimeStamp? get expires;
  set expires(DOMHighResTimeStamp? value);
  bool get secure;
  set secure(bool value);
  CookieSameSite get sameSite;
  set sameSite(CookieSameSite value);
  bool get partitioned;
  set partitioned(bool value);
}

typedef CookieSameSite = String;

abstract interface class CookieStore {
  Future<CookieListItem?> get_(String name);
  Future<CookieList> getAll(String name);
  Future<void> set_(String name, String value);
  Future<void> delete(String name);
  EventHandler get onchange;
   set onchange(EventHandler value);
}

abstract interface class CookieStoreDeleteOptions {
  String get name;
  set name(String value);
  String? get domain;
  set domain(String? value);
  String get path;
  set path(String value);
  bool get partitioned;
  set partitioned(bool value);
}

abstract interface class CookieStoreGetOptions {
  String get name;
  set name(String value);
  String get url;
  set url(String value);
}

abstract interface class CookieStoreManager {
  Future<void> subscribe(List<CookieStoreGetOptions> subscriptions);
  Future<List<CookieStoreGetOptions>> getSubscriptions();
  Future<void> unsubscribe(List<CookieStoreGetOptions> subscriptions);
}

abstract interface class ExtendableCookieChangeEvent {
  List<CookieListItem> get changed;
  List<CookieListItem> get deleted;
}

abstract interface class ExtendableCookieChangeEventInit {
  CookieList get changed;
  set changed(CookieList value);
  CookieList get deleted;
  set deleted(CookieList value);
}

