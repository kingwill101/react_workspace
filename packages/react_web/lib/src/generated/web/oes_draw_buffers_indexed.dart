// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: OES_draw_buffers_indexed
// ignore_for_file: type=lint

import 'webgl1.dart';

abstract interface class OES_draw_buffers_indexed {
  void enableiOES(GLenum target, GLuint index);
  void disableiOES(GLenum target, GLuint index);
  void blendEquationiOES(GLuint buf, GLenum mode);
  void blendEquationSeparateiOES(GLuint buf, GLenum modeRGB, GLenum modeAlpha);
  void blendFunciOES(GLuint buf, GLenum src, GLenum dst);
  void blendFuncSeparateiOES(GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
  void colorMaskiOES(GLuint buf, GLboolean r, GLboolean g, GLboolean b, GLboolean a);
}

