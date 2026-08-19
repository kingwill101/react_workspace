// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: ANGLE_instanced_arrays
// ignore_for_file: type=lint

import 'webgl1.dart';

abstract interface class ANGLE_instanced_arrays {
  void drawArraysInstancedANGLE(
    GLenum mode,
    GLint first,
    GLsizei count,
    GLsizei primcount,
  );
  void drawElementsInstancedANGLE(
    GLenum mode,
    GLsizei count,
    GLenum type_,
    GLintptr offset,
    GLsizei primcount,
  );
  void vertexAttribDivisorANGLE(GLuint index, GLuint divisor);
}
