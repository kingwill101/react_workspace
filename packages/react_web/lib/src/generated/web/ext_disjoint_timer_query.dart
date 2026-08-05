// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: EXT_disjoint_timer_query
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';

abstract interface class EXT_disjoint_timer_query {
  WebGLTimerQueryEXT? createQueryEXT();
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

