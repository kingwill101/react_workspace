// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: OVR_multiview2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';

abstract interface class OVR_multiview2 {
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_NUM_VIEWS_OVR =
      0x9630;
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_BASE_VIEW_INDEX_OVR =
      0x9632;
   static const GLenum MAX_VIEWS_OVR =
      0x9631;
   static const GLenum FRAMEBUFFER_INCOMPLETE_VIEW_TARGETS_OVR =
      0x9633;
  void framebufferTextureMultiviewOVR(GLenum target, GLenum attachment, WebGLTexture? texture, GLint level, GLint baseViewIndex, GLsizei numViews);
}

