// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webidl
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

typedef AllowSharedBufferSource = Object;

typedef ArrayBufferView = Object;

typedef BufferSource = Object;

abstract interface class DOMException {
  factory DOMException([String? message, String? name]) =>
      WebRuntime.current.createWebObject<DOMException>(
        'DOMException',
        [message, name],
      );
  String get name;
  String get message;
  int get code;
}

typedef VoidFunction = void Function();

