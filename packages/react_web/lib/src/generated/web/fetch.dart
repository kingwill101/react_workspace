// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: fetch
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'streams.dart';
import 'fileapi.dart';
import 'xhr.dart';
import 'attribution_reporting_api.dart';
import 'referrer_policy.dart';
import 'dom.dart';
import 'webidl.dart';
import 'url.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Body {
  ReadableStream? get body;
  bool get bodyUsed;
  Future<Object> arrayBuffer();
  Future<Blob> blob();
  Future<Object> bytes();
  Future<FormData> formData();
  Future<Object> json();
  Future<String> text();
}

typedef BodyInit = Object;

abstract interface class Headers {
  factory Headers([HeadersInit? init]) =>
      WebRuntime.current.createWebObject<Headers>(
        'Headers',
        [init],
      );
  void append(String name, String value);
  void delete(String name);
  String? get_(String name);
  List<String> getSetCookie();
  bool has(String name);
  void set_(String name, String value);
}

typedef HeadersInit = Object;

abstract interface class Request {
  factory Request(RequestInfo input, [RequestInit? init]) =>
      WebRuntime.current.createWebObject<Request>(
        'Request',
        [input, init],
      );
  ReadableStream? get body;
  bool get bodyUsed;
  Future<Object> arrayBuffer();
  Future<Blob> blob();
  Future<Object> bytes();
  Future<FormData> formData();
  Future<Object> json();
  Future<String> text();
  String get method;
  String get url;
  Headers get headers;
  RequestDestination get destination;
  String get referrer;
  ReferrerPolicy get referrerPolicy;
  RequestMode get mode;
  RequestCredentials get credentials;
  RequestCache get cache;
  RequestRedirect get redirect;
  String get integrity;
  bool get keepalive;
  bool get isHistoryNavigation;
  AbortSignal get signal;
  Request clone();
}

typedef RequestCache = String;

typedef RequestCredentials = String;

typedef RequestDestination = String;

typedef RequestDuplex = String;

typedef RequestInfo = Object;

typedef RequestMode = String;

typedef RequestPriority = String;

typedef RequestRedirect = String;

abstract interface class Response {
  factory Response([BodyInit? body, ResponseInit? init]) =>
      WebRuntime.current.createWebObject<Response>(
        'Response',
        [body, init],
      );
  ReadableStream? get body;
  bool get bodyUsed;
  Future<Object> arrayBuffer();
  Future<Blob> blob();
  Future<Object> bytes();
  Future<FormData> formData();
  Future<Object> json();
  Future<String> text();
  ResponseType get type;
  String get url;
  bool get redirected;
  int get status;
  bool get ok;
  String get statusText;
  Headers get headers;
  Response clone();
}

abstract interface class ResponseInit {
  int? get status;
  set status(int? value);
  String? get statusText;
  set statusText(String? value);
  HeadersInit? get headers;
  set headers(HeadersInit? value);
}

final class ResponseInitValue implements ResponseInit {
  @override
  int? status;
  @override
  String? statusText;
  @override
  HeadersInit? headers;

  ResponseInitValue({
    this.status,
    this.statusText,
    this.headers,
  });
}

typedef ResponseType = String;

typedef XMLHttpRequestBodyInit = Object;

