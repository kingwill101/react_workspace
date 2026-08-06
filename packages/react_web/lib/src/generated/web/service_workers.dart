// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: service-workers
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fetch.dart';
import 'page_lifecycle.dart';
import 'dom.dart';
import 'html.dart';
import 'urlpattern.dart';
import 'background_fetch.dart';
import 'trusted_types.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Cache {
  Future<Response> match(RequestInfo request, [CacheQueryOptions? options]);
  Future<List<Response>> matchAll([RequestInfo? request, CacheQueryOptions? options]);
  Future<void> add(RequestInfo request);
  Future<void> addAll(List<RequestInfo> requests);
  Future<void> put(RequestInfo request, Response response);
  Future<bool> delete(RequestInfo request, [CacheQueryOptions? options]);
  Future<List<Request>> keys([RequestInfo? request, CacheQueryOptions? options]);
}

abstract interface class CacheQueryOptions {
  bool? get ignoreSearch;
  set ignoreSearch(bool? value);
  bool? get ignoreMethod;
  set ignoreMethod(bool? value);
  bool? get ignoreVary;
  set ignoreVary(bool? value);
}

final class CacheQueryOptionsValue implements CacheQueryOptions {
  @override
  bool? ignoreSearch;
  @override
  bool? ignoreMethod;
  @override
  bool? ignoreVary;

  CacheQueryOptionsValue({
    this.ignoreSearch,
    this.ignoreMethod,
    this.ignoreVary,
  });
}

abstract interface class CacheStorage {
  Future<Response> match(RequestInfo request, [MultiCacheQueryOptions? options]);
  Future<bool> has(String cacheName);
  Future<Cache> open(String cacheName);
  Future<bool> delete(String cacheName);
  Future<List<String>> keys();
}

abstract interface class ClientQueryOptions {
  bool? get includeUncontrolled;
  set includeUncontrolled(bool? value);
  ClientType? get type;
  set type(ClientType? value);
}

final class ClientQueryOptionsValue implements ClientQueryOptions {
  @override
  bool? includeUncontrolled;
  @override
  ClientType? type;

  ClientQueryOptionsValue({
    this.includeUncontrolled,
    this.type,
  });
}

typedef ClientType = String;

abstract interface class Clients {
  Future<Client> get_(String id);
  Future<List<Client>> matchAll([ClientQueryOptions? options]);
  Future<WindowClient?> openWindow(String url);
  Future<void> claim();
}

abstract interface class ExtendableEvent {
  factory ExtendableEvent(String type, [ExtendableEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ExtendableEvent>(
        'ExtendableEvent',
        [type, eventInitDict],
      );
  void waitUntil(Future<Object> f);
}

abstract interface class ExtendableEventInit {
}

final class ExtendableEventInitValue implements ExtendableEventInit {

  ExtendableEventInitValue();
}

abstract interface class ExtendableMessageEvent {
  factory ExtendableMessageEvent(String type, [ExtendableMessageEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ExtendableMessageEvent>(
        'ExtendableMessageEvent',
        [type, eventInitDict],
      );
  Object get data;
  String get origin;
  String get lastEventId;
  Object get source;
  List<MessagePort> get ports;
}

abstract interface class ExtendableMessageEventInit {
  Object? get data;
  set data(Object? value);
  String? get origin;
  set origin(String? value);
  String? get lastEventId;
  set lastEventId(String? value);
  Object? get source;
  set source(Object? value);
  List<MessagePort>? get ports;
  set ports(List<MessagePort>? value);
}

final class ExtendableMessageEventInitValue implements ExtendableMessageEventInit {
  @override
  Object? data;
  @override
  String? origin;
  @override
  String? lastEventId;
  @override
  Object? source;
  @override
  List<MessagePort>? ports;

  ExtendableMessageEventInitValue({
    this.data,
    this.origin,
    this.lastEventId,
    this.source,
    this.ports,
  });
}

abstract interface class FetchEvent {
  factory FetchEvent(String type, FetchEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<FetchEvent>(
        'FetchEvent',
        [type, eventInitDict],
      );
  Request get request;
  Future<Object> get preloadResponse;
  String get clientId;
  String get resultingClientId;
  String get replacesClientId;
  Future<void> get handled;
  void respondWith(Future<Response> r);
}

abstract interface class FetchEventInit {
  Request get request;
  set request(Request value);
  Future<Object>? get preloadResponse;
  set preloadResponse(Future<Object>? value);
  String? get clientId;
  set clientId(String? value);
  String? get resultingClientId;
  set resultingClientId(String? value);
  String? get replacesClientId;
  set replacesClientId(String? value);
  Future<void>? get handled;
  set handled(Future<void>? value);
}

final class FetchEventInitValue implements FetchEventInit {
  @override
  Request request;
  @override
  Future<Object>? preloadResponse;
  @override
  String? clientId;
  @override
  String? resultingClientId;
  @override
  String? replacesClientId;
  @override
  Future<void>? handled;

  FetchEventInitValue({
    required this.request,
    this.preloadResponse,
    this.clientId,
    this.resultingClientId,
    this.replacesClientId,
    this.handled,
  });
}

typedef FrameType = String;

abstract interface class InstallEvent {
}

abstract interface class MultiCacheQueryOptions {
  String? get cacheName;
  set cacheName(String? value);
}

final class MultiCacheQueryOptionsValue implements MultiCacheQueryOptions {
  @override
  String? cacheName;

  MultiCacheQueryOptionsValue({
    this.cacheName,
  });
}

abstract interface class NavigationPreloadManager {
  Future<void> enable();
  Future<void> disable();
  Future<void> setHeaderValue(String value);
  Future<NavigationPreloadState> getState();
}

abstract interface class NavigationPreloadState {
  bool? get enabled;
  set enabled(bool? value);
  String? get headerValue;
  set headerValue(String? value);
}

final class NavigationPreloadStateValue implements NavigationPreloadState {
  @override
  bool? enabled;
  @override
  String? headerValue;

  NavigationPreloadStateValue({
    this.enabled,
    this.headerValue,
  });
}

abstract interface class RegistrationOptions {
  String? get scope;
  set scope(String? value);
  WorkerType? get type;
  set type(WorkerType? value);
  ServiceWorkerUpdateViaCache? get updateViaCache;
  set updateViaCache(ServiceWorkerUpdateViaCache? value);
}

final class RegistrationOptionsValue implements RegistrationOptions {
  @override
  String? scope;
  @override
  WorkerType? type;
  @override
  ServiceWorkerUpdateViaCache? updateViaCache;

  RegistrationOptionsValue({
    this.scope,
    this.type,
    this.updateViaCache,
  });
}

abstract interface class RouterCondition {
  URLPatternCompatible? get urlPattern;
  set urlPattern(URLPatternCompatible? value);
  String? get requestMethod;
  set requestMethod(String? value);
  RequestMode? get requestMode;
  set requestMode(RequestMode? value);
  RequestDestination? get requestDestination;
  set requestDestination(RequestDestination? value);
  RunningStatus? get runningStatus;
  set runningStatus(RunningStatus? value);
  List<RouterCondition>? get or;
  set or(List<RouterCondition>? value);
  RouterCondition? get not;
  set not(RouterCondition? value);
}

final class RouterConditionValue implements RouterCondition {
  @override
  URLPatternCompatible? urlPattern;
  @override
  String? requestMethod;
  @override
  RequestMode? requestMode;
  @override
  RequestDestination? requestDestination;
  @override
  RunningStatus? runningStatus;
  @override
  List<RouterCondition>? or;
  @override
  RouterCondition? not;

  RouterConditionValue({
    this.urlPattern,
    this.requestMethod,
    this.requestMode,
    this.requestDestination,
    this.runningStatus,
    this.or,
    this.not,
  });
}

abstract interface class RouterRule {
  RouterCondition get condition;
  set condition(RouterCondition value);
  RouterSource get source;
  set source(RouterSource value);
}

final class RouterRuleValue implements RouterRule {
  @override
  RouterCondition condition;
  @override
  RouterSource source;

  RouterRuleValue({
    required this.condition,
    required this.source,
  });
}

typedef RouterSource = Object;

abstract interface class RouterSourceDict {
  String? get cacheName;
  set cacheName(String? value);
}

final class RouterSourceDictValue implements RouterSourceDict {
  @override
  String? cacheName;

  RouterSourceDictValue({
    this.cacheName,
  });
}

typedef RouterSourceEnum = String;

typedef RunningStatus = String;

abstract interface class ServiceWorker {
  EventHandler get onerror;
   set onerror(EventHandler value);
  String get scriptURL;
  ServiceWorkerState get state;
  void postMessage(Object message, List<Object> transfer);
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
}

abstract interface class ServiceWorkerContainer {
  ServiceWorker? get controller;
  Future<ServiceWorkerRegistration> get ready;
  Future<ServiceWorkerRegistration> register(Object scriptURL, [RegistrationOptions? options]);
  Future<ServiceWorkerRegistration> getRegistration([String? clientURL]);
  Future<List<ServiceWorkerRegistration>> getRegistrations();
  void startMessages();
  EventHandler get oncontrollerchange;
   set oncontrollerchange(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

typedef ServiceWorkerState = String;

typedef ServiceWorkerUpdateViaCache = String;

abstract interface class WindowClient {
  DocumentVisibilityState get visibilityState;
  bool get focused;
  Future<WindowClient> focus();
  Future<WindowClient?> navigate(String url);
}

