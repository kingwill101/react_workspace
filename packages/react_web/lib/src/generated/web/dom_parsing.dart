// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: DOM-Parsing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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

