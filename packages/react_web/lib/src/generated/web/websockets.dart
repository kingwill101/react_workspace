// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: websockets
// ignore_for_file: type=lint

import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

typedef BinaryType = String;

abstract interface class CloseEvent {
  factory CloseEvent(String type_, [CloseEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<CloseEvent>('CloseEvent', [
        type_,
        eventInitDict,
      ]);
  bool get wasClean;
  int get code;
  String get reason;
}

abstract interface class CloseEventInit {
  bool? get wasClean;
  set wasClean(bool? value);
  int? get code;
  set code(int? value);
  String? get reason;
  set reason(String? value);
}

final class CloseEventInitValue implements CloseEventInit {
  @override
  bool? wasClean;
  @override
  int? code;
  @override
  String? reason;

  CloseEventInitValue({this.wasClean, this.code, this.reason});
}

abstract interface class WebSocket {
  factory WebSocket(String url, [Object? protocols]) => WebRuntime.current
      .createWebObject<WebSocket>('WebSocket', [url, protocols]);
  String get url;
  int get readyState;
  int get bufferedAmount;
  EventHandler get onopen;
  set onopen(EventHandler value);
  EventHandler get onerror;
  set onerror(EventHandler value);
  EventHandler get onclose;
  set onclose(EventHandler value);
  String get extensions;
  String get protocol;
  void close([int? code, String? reason]);
  EventHandler get onmessage;
  set onmessage(EventHandler value);
  BinaryType get binaryType;
  set binaryType(BinaryType value);
  void send(Object data);
}
