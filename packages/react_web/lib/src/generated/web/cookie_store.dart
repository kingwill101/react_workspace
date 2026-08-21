// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: cookie-store
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class CookieChangeEvent {
  factory CookieChangeEvent(
    String type_, [
    CookieChangeEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<CookieChangeEvent>(
    'CookieChangeEvent',
    [type_, eventInitDict],
  );
  List<CookieListItem> get changed;
  List<CookieListItem> get deleted;
}

abstract interface class CookieChangeEventInit {
  CookieList? get changed;
  set changed(CookieList? value);
  CookieList? get deleted;
  set deleted(CookieList? value);
}

final class CookieChangeEventInitValue implements CookieChangeEventInit {
  @override
  CookieList? changed;
  @override
  CookieList? deleted;

  CookieChangeEventInitValue({this.changed, this.deleted});
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
  String? get path;
  set path(String? value);
  CookieSameSite? get sameSite;
  set sameSite(CookieSameSite? value);
  bool? get partitioned;
  set partitioned(bool? value);
}

final class CookieInitValue implements CookieInit {
  @override
  String name;
  @override
  String value;
  @override
  DOMHighResTimeStamp? expires;
  @override
  String? domain;
  @override
  String? path;
  @override
  CookieSameSite? sameSite;
  @override
  bool? partitioned;

  CookieInitValue({
    required this.name,
    required this.value,
    this.expires,
    this.domain,
    this.path,
    this.sameSite,
    this.partitioned,
  });
}

typedef CookieList = List<CookieListItem>;

abstract interface class CookieListItem {
  String? get name;
  set name(String? value);
  String? get value;
  set value(String? value);
  String? get domain;
  set domain(String? value);
  String? get path;
  set path(String? value);
  DOMHighResTimeStamp? get expires;
  set expires(DOMHighResTimeStamp? value);
  bool? get secure;
  set secure(bool? value);
  CookieSameSite? get sameSite;
  set sameSite(CookieSameSite? value);
  bool? get partitioned;
  set partitioned(bool? value);
}

final class CookieListItemValue implements CookieListItem {
  @override
  String? name;
  @override
  String? value;
  @override
  String? domain;
  @override
  String? path;
  @override
  DOMHighResTimeStamp? expires;
  @override
  bool? secure;
  @override
  CookieSameSite? sameSite;
  @override
  bool? partitioned;

  CookieListItemValue({
    this.name,
    this.value,
    this.domain,
    this.path,
    this.expires,
    this.secure,
    this.sameSite,
    this.partitioned,
  });
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
  String? get path;
  set path(String? value);
  bool? get partitioned;
  set partitioned(bool? value);
}

final class CookieStoreDeleteOptionsValue implements CookieStoreDeleteOptions {
  @override
  String name;
  @override
  String? domain;
  @override
  String? path;
  @override
  bool? partitioned;

  CookieStoreDeleteOptionsValue({
    required this.name,
    this.domain,
    this.path,
    this.partitioned,
  });
}

abstract interface class CookieStoreGetOptions {
  String? get name;
  set name(String? value);
  String? get url;
  set url(String? value);
}

final class CookieStoreGetOptionsValue implements CookieStoreGetOptions {
  @override
  String? name;
  @override
  String? url;

  CookieStoreGetOptionsValue({this.name, this.url});
}

abstract interface class CookieStoreManager {
  Future<void> subscribe(List<CookieStoreGetOptions> subscriptions);
  Future<List<CookieStoreGetOptions>> getSubscriptions();
  Future<void> unsubscribe(List<CookieStoreGetOptions> subscriptions);
}

abstract interface class ExtendableCookieChangeEvent {
  factory ExtendableCookieChangeEvent(
    String type_, [
    ExtendableCookieChangeEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<ExtendableCookieChangeEvent>(
    'ExtendableCookieChangeEvent',
    [type_, eventInitDict],
  );
  List<CookieListItem> get changed;
  List<CookieListItem> get deleted;
}

abstract interface class ExtendableCookieChangeEventInit {
  CookieList? get changed;
  set changed(CookieList? value);
  CookieList? get deleted;
  set deleted(CookieList? value);
}

final class ExtendableCookieChangeEventInitValue
    implements ExtendableCookieChangeEventInit {
  @override
  CookieList? changed;
  @override
  CookieList? deleted;

  ExtendableCookieChangeEventInitValue({this.changed, this.deleted});
}
