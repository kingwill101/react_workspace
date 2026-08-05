// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: resize-observer
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_nav.dart';
import 'geometry.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class ResizeObserver {
  factory ResizeObserver(ResizeObserverCallback callback) =>
      WebRuntime.current.createWebObject<ResizeObserver>(
        'ResizeObserver',
        [callback],
      );
  void observe(Element target, [ResizeObserverOptions? options]);
  void unobserve(Element target);
  void disconnect();
}

typedef ResizeObserverBoxOptions = String;

typedef ResizeObserverCallback = void Function(List<ResizeObserverEntry> entries, ResizeObserver observer,);

abstract interface class ResizeObserverEntry {
  Element get target;
  DOMRectReadOnly get contentRect;
  List<ResizeObserverSize> get borderBoxSize;
  List<ResizeObserverSize> get contentBoxSize;
  List<ResizeObserverSize> get devicePixelContentBoxSize;
}

abstract interface class ResizeObserverOptions {
  ResizeObserverBoxOptions get box;
  set box(ResizeObserverBoxOptions value);
}

abstract interface class ResizeObserverSize {
  double get inlineSize;
  double get blockSize;
}

