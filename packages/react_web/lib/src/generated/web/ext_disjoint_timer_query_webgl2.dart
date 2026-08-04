// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: EXT_disjoint_timer_query_webgl2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';
import 'webgl2.dart';

abstract interface class EXT_disjoint_timer_query_webgl2 {
   static const GLenum QUERY_COUNTER_BITS_EXT =
      0x8864;
   static const GLenum TIME_ELAPSED_EXT =
      0x88BF;
   static const GLenum TIMESTAMP_EXT =
      0x8E28;
   static const GLenum GPU_DISJOINT_EXT =
      0x8FBB;
  void queryCounterEXT(WebGLQuery query, GLenum target);
}

