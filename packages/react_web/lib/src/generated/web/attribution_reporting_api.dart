// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: attribution-reporting-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fetch.dart';
import 'referrer_policy.dart';
import 'dom.dart';
import 'private_network_access.dart';
import 'trust_token_api.dart';
import 'html.dart';
import 'xhr.dart';
import 'svg.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class AttributionReportingRequestOptions {
  bool get eventSourceEligible;
  set eventSourceEligible(bool value);
  bool get triggerEligible;
  set triggerEligible(bool value);
}

abstract interface class HTMLAttributionSrcElementUtils {
  String get attributionSrc;
   set attributionSrc(String value);
}

abstract interface class RequestInit {
  AttributionReportingRequestOptions get attributionReporting;
  set attributionReporting(AttributionReportingRequestOptions value);
  String get method;
  set method(String value);
  HeadersInit get headers;
  set headers(HeadersInit value);
  BodyInit? get body;
  set body(BodyInit? value);
  String get referrer;
  set referrer(String value);
  ReferrerPolicy get referrerPolicy;
  set referrerPolicy(ReferrerPolicy value);
  RequestMode get mode;
  set mode(RequestMode value);
  RequestCredentials get credentials;
  set credentials(RequestCredentials value);
  RequestCache get cache;
  set cache(RequestCache value);
  RequestRedirect get redirect;
  set redirect(RequestRedirect value);
  String get integrity;
  set integrity(String value);
  bool get keepalive;
  set keepalive(bool value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  RequestDuplex get duplex;
  set duplex(RequestDuplex value);
  RequestPriority get priority;
  set priority(RequestPriority value);
  Object get window;
  set window(Object value);
  IPAddressSpace get targetAddressSpace;
  set targetAddressSpace(IPAddressSpace value);
  bool get sharedStorageWritable;
  set sharedStorageWritable(bool value);
  PrivateToken get privateToken;
  set privateToken(PrivateToken value);
  bool get adAuctionHeaders;
  set adAuctionHeaders(bool value);
}

abstract interface class XMLHttpRequest {
  factory XMLHttpRequest() =>
      WebRuntime.current.createWebObject<XMLHttpRequest>(
        'XMLHttpRequest',
        [],
      );
  EventHandler get onreadystatechange;
   set onreadystatechange(EventHandler value);
  int get readyState;
  void open(String method, String url, bool async_, [String? username, String? password]);
  void setRequestHeader(String name, String value);
  int get timeout;
   set timeout(int value);
  bool get withCredentials;
   set withCredentials(bool value);
  XMLHttpRequestUpload get upload;
  void send([Object? body]);
  void abort();
  String get responseURL;
  int get status;
  String get statusText;
  String? getResponseHeader(String name);
  String getAllResponseHeaders();
  void overrideMimeType(String mime);
  XMLHttpRequestResponseType get responseType;
   set responseType(XMLHttpRequestResponseType value);
  Object get response;
  String get responseText;
  Document? get responseXML;
}

