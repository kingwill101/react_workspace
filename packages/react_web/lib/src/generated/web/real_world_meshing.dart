// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: real-world-meshing
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webxr.dart';
import 'hr_time.dart';

abstract interface class XRMesh {
  XRSpace get meshSpace;
  List<Object> get vertices;
  Object get indices;
  DOMHighResTimeStamp get lastChangedTime;
  String? get semanticLabel;
}

abstract interface class XRMeshSet {
   Iterable<XRMesh> get values;
   bool has(Object value);
}

