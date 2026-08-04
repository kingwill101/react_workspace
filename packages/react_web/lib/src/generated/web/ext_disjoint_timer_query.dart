// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: EXT_disjoint_timer_query
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';

abstract interface class EXT_disjoint_timer_query {
   static const GLenum QUERY_COUNTER_BITS_EXT =
      0x8864;
   static const GLenum CURRENT_QUERY_EXT =
      0x8865;
   static const GLenum QUERY_RESULT_EXT =
      0x8866;
   static const GLenum QUERY_RESULT_AVAILABLE_EXT =
      0x8867;
   static const GLenum TIME_ELAPSED_EXT =
      0x88BF;
   static const GLenum TIMESTAMP_EXT =
      0x8E28;
   static const GLenum GPU_DISJOINT_EXT =
      0x8FBB;
  WebGLTimerQueryEXT createQueryEXT();
  void deleteQueryEXT(WebGLTimerQueryEXT? query);
  bool isQueryEXT(WebGLTimerQueryEXT? query);
  void beginQueryEXT(GLenum target, WebGLTimerQueryEXT query);
  void endQueryEXT(GLenum target);
  void queryCounterEXT(WebGLTimerQueryEXT query, GLenum target);
  Object getQueryEXT(GLenum target, GLenum pname);
  Object getQueryObjectEXT(WebGLTimerQueryEXT query, GLenum pname);
}

typedef GLuint64EXT = int;

abstract interface class WebGLTimerQueryEXT {
}

