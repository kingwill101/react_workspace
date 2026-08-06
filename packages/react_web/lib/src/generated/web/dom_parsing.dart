// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: DOM-Parsing
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class XMLSerializer {
  factory XMLSerializer() =>
      WebRuntime.current.createWebObject<XMLSerializer>(
        'XMLSerializer',
        [],
      );
  String serializeToString(Node root);
}

