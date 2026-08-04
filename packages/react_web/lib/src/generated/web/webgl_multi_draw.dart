// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: WEBGL_multi_draw
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';

abstract interface class WEBGL_multi_draw {
  void multiDrawArraysWEBGL(GLenum mode, Object firstsList, int firstsOffset, Object countsList, int countsOffset, GLsizei drawcount);
  void multiDrawElementsWEBGL(GLenum mode, Object countsList, int countsOffset, GLenum type, Object offsetsList, int offsetsOffset, GLsizei drawcount);
  void multiDrawArraysInstancedWEBGL(GLenum mode, Object firstsList, int firstsOffset, Object countsList, int countsOffset, Object instanceCountsList, int instanceCountsOffset, GLsizei drawcount);
  void multiDrawElementsInstancedWEBGL(GLenum mode, Object countsList, int countsOffset, GLenum type, Object offsetsList, int offsetsOffset, Object instanceCountsList, int instanceCountsOffset, GLsizei drawcount);
}

