// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webgl2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';
import 'html.dart';
import 'webidl.dart';

typedef GLint64 = int;

typedef GLuint64 = int;

typedef Uint32List = Object;

abstract interface class WebGL2RenderingContext {
   static const GLenum DEPTH_BUFFER_BIT =
      0x00000100;
   static const GLenum STENCIL_BUFFER_BIT =
      0x00000400;
   static const GLenum COLOR_BUFFER_BIT =
      0x00004000;
   static const GLenum POINTS =
      0x0000;
   static const GLenum LINES =
      0x0001;
   static const GLenum LINE_LOOP =
      0x0002;
   static const GLenum LINE_STRIP =
      0x0003;
   static const GLenum TRIANGLES =
      0x0004;
   static const GLenum TRIANGLE_STRIP =
      0x0005;
   static const GLenum TRIANGLE_FAN =
      0x0006;
   static const GLenum ZERO =
      0;
   static const GLenum ONE =
      1;
   static const GLenum SRC_COLOR =
      0x0300;
   static const GLenum ONE_MINUS_SRC_COLOR =
      0x0301;
   static const GLenum SRC_ALPHA =
      0x0302;
   static const GLenum ONE_MINUS_SRC_ALPHA =
      0x0303;
   static const GLenum DST_ALPHA =
      0x0304;
   static const GLenum ONE_MINUS_DST_ALPHA =
      0x0305;
   static const GLenum DST_COLOR =
      0x0306;
   static const GLenum ONE_MINUS_DST_COLOR =
      0x0307;
   static const GLenum SRC_ALPHA_SATURATE =
      0x0308;
   static const GLenum FUNC_ADD =
      0x8006;
   static const GLenum BLEND_EQUATION =
      0x8009;
   static const GLenum BLEND_EQUATION_RGB =
      0x8009;
   static const GLenum BLEND_EQUATION_ALPHA =
      0x883D;
   static const GLenum FUNC_SUBTRACT =
      0x800A;
   static const GLenum FUNC_REVERSE_SUBTRACT =
      0x800B;
   static const GLenum BLEND_DST_RGB =
      0x80C8;
   static const GLenum BLEND_SRC_RGB =
      0x80C9;
   static const GLenum BLEND_DST_ALPHA =
      0x80CA;
   static const GLenum BLEND_SRC_ALPHA =
      0x80CB;
   static const GLenum CONSTANT_COLOR =
      0x8001;
   static const GLenum ONE_MINUS_CONSTANT_COLOR =
      0x8002;
   static const GLenum CONSTANT_ALPHA =
      0x8003;
   static const GLenum ONE_MINUS_CONSTANT_ALPHA =
      0x8004;
   static const GLenum BLEND_COLOR =
      0x8005;
   static const GLenum ARRAY_BUFFER =
      0x8892;
   static const GLenum ELEMENT_ARRAY_BUFFER =
      0x8893;
   static const GLenum ARRAY_BUFFER_BINDING =
      0x8894;
   static const GLenum ELEMENT_ARRAY_BUFFER_BINDING =
      0x8895;
   static const GLenum STREAM_DRAW =
      0x88E0;
   static const GLenum STATIC_DRAW =
      0x88E4;
   static const GLenum DYNAMIC_DRAW =
      0x88E8;
   static const GLenum BUFFER_SIZE =
      0x8764;
   static const GLenum BUFFER_USAGE =
      0x8765;
   static const GLenum CURRENT_VERTEX_ATTRIB =
      0x8626;
   static const GLenum FRONT =
      0x0404;
   static const GLenum BACK =
      0x0405;
   static const GLenum FRONT_AND_BACK =
      0x0408;
   static const GLenum CULL_FACE =
      0x0B44;
   static const GLenum BLEND =
      0x0BE2;
   static const GLenum DITHER =
      0x0BD0;
   static const GLenum STENCIL_TEST =
      0x0B90;
   static const GLenum DEPTH_TEST =
      0x0B71;
   static const GLenum SCISSOR_TEST =
      0x0C11;
   static const GLenum POLYGON_OFFSET_FILL =
      0x8037;
   static const GLenum SAMPLE_ALPHA_TO_COVERAGE =
      0x809E;
   static const GLenum SAMPLE_COVERAGE =
      0x80A0;
   static const GLenum NO_ERROR =
      0;
   static const GLenum INVALID_ENUM =
      0x0500;
   static const GLenum INVALID_VALUE =
      0x0501;
   static const GLenum INVALID_OPERATION =
      0x0502;
   static const GLenum OUT_OF_MEMORY =
      0x0505;
   static const GLenum CW =
      0x0900;
   static const GLenum CCW =
      0x0901;
   static const GLenum LINE_WIDTH =
      0x0B21;
   static const GLenum ALIASED_POINT_SIZE_RANGE =
      0x846D;
   static const GLenum ALIASED_LINE_WIDTH_RANGE =
      0x846E;
   static const GLenum CULL_FACE_MODE =
      0x0B45;
   static const GLenum FRONT_FACE =
      0x0B46;
   static const GLenum DEPTH_RANGE =
      0x0B70;
   static const GLenum DEPTH_WRITEMASK =
      0x0B72;
   static const GLenum DEPTH_CLEAR_VALUE =
      0x0B73;
   static const GLenum DEPTH_FUNC =
      0x0B74;
   static const GLenum STENCIL_CLEAR_VALUE =
      0x0B91;
   static const GLenum STENCIL_FUNC =
      0x0B92;
   static const GLenum STENCIL_FAIL =
      0x0B94;
   static const GLenum STENCIL_PASS_DEPTH_FAIL =
      0x0B95;
   static const GLenum STENCIL_PASS_DEPTH_PASS =
      0x0B96;
   static const GLenum STENCIL_REF =
      0x0B97;
   static const GLenum STENCIL_VALUE_MASK =
      0x0B93;
   static const GLenum STENCIL_WRITEMASK =
      0x0B98;
   static const GLenum STENCIL_BACK_FUNC =
      0x8800;
   static const GLenum STENCIL_BACK_FAIL =
      0x8801;
   static const GLenum STENCIL_BACK_PASS_DEPTH_FAIL =
      0x8802;
   static const GLenum STENCIL_BACK_PASS_DEPTH_PASS =
      0x8803;
   static const GLenum STENCIL_BACK_REF =
      0x8CA3;
   static const GLenum STENCIL_BACK_VALUE_MASK =
      0x8CA4;
   static const GLenum STENCIL_BACK_WRITEMASK =
      0x8CA5;
   static const GLenum VIEWPORT =
      0x0BA2;
   static const GLenum SCISSOR_BOX =
      0x0C10;
   static const GLenum COLOR_CLEAR_VALUE =
      0x0C22;
   static const GLenum COLOR_WRITEMASK =
      0x0C23;
   static const GLenum UNPACK_ALIGNMENT =
      0x0CF5;
   static const GLenum PACK_ALIGNMENT =
      0x0D05;
   static const GLenum MAX_TEXTURE_SIZE =
      0x0D33;
   static const GLenum MAX_VIEWPORT_DIMS =
      0x0D3A;
   static const GLenum SUBPIXEL_BITS =
      0x0D50;
   static const GLenum RED_BITS =
      0x0D52;
   static const GLenum GREEN_BITS =
      0x0D53;
   static const GLenum BLUE_BITS =
      0x0D54;
   static const GLenum ALPHA_BITS =
      0x0D55;
   static const GLenum DEPTH_BITS =
      0x0D56;
   static const GLenum STENCIL_BITS =
      0x0D57;
   static const GLenum POLYGON_OFFSET_UNITS =
      0x2A00;
   static const GLenum POLYGON_OFFSET_FACTOR =
      0x8038;
   static const GLenum TEXTURE_BINDING_2D =
      0x8069;
   static const GLenum SAMPLE_BUFFERS =
      0x80A8;
   static const GLenum SAMPLES =
      0x80A9;
   static const GLenum SAMPLE_COVERAGE_VALUE =
      0x80AA;
   static const GLenum SAMPLE_COVERAGE_INVERT =
      0x80AB;
   static const GLenum COMPRESSED_TEXTURE_FORMATS =
      0x86A3;
   static const GLenum DONT_CARE =
      0x1100;
   static const GLenum FASTEST =
      0x1101;
   static const GLenum NICEST =
      0x1102;
   static const GLenum GENERATE_MIPMAP_HINT =
      0x8192;
   static const GLenum BYTE =
      0x1400;
   static const GLenum UNSIGNED_BYTE =
      0x1401;
   static const GLenum SHORT =
      0x1402;
   static const GLenum UNSIGNED_SHORT =
      0x1403;
   static const GLenum INT =
      0x1404;
   static const GLenum UNSIGNED_INT =
      0x1405;
   static const GLenum FLOAT =
      0x1406;
   static const GLenum DEPTH_COMPONENT =
      0x1902;
   static const GLenum ALPHA =
      0x1906;
   static const GLenum RGB =
      0x1907;
   static const GLenum RGBA =
      0x1908;
   static const GLenum LUMINANCE =
      0x1909;
   static const GLenum LUMINANCE_ALPHA =
      0x190A;
   static const GLenum UNSIGNED_SHORT_4_4_4_4 =
      0x8033;
   static const GLenum UNSIGNED_SHORT_5_5_5_1 =
      0x8034;
   static const GLenum UNSIGNED_SHORT_5_6_5 =
      0x8363;
   static const GLenum FRAGMENT_SHADER =
      0x8B30;
   static const GLenum VERTEX_SHADER =
      0x8B31;
   static const GLenum MAX_VERTEX_ATTRIBS =
      0x8869;
   static const GLenum MAX_VERTEX_UNIFORM_VECTORS =
      0x8DFB;
   static const GLenum MAX_VARYING_VECTORS =
      0x8DFC;
   static const GLenum MAX_COMBINED_TEXTURE_IMAGE_UNITS =
      0x8B4D;
   static const GLenum MAX_VERTEX_TEXTURE_IMAGE_UNITS =
      0x8B4C;
   static const GLenum MAX_TEXTURE_IMAGE_UNITS =
      0x8872;
   static const GLenum MAX_FRAGMENT_UNIFORM_VECTORS =
      0x8DFD;
   static const GLenum SHADER_TYPE =
      0x8B4F;
   static const GLenum DELETE_STATUS =
      0x8B80;
   static const GLenum LINK_STATUS =
      0x8B82;
   static const GLenum VALIDATE_STATUS =
      0x8B83;
   static const GLenum ATTACHED_SHADERS =
      0x8B85;
   static const GLenum ACTIVE_UNIFORMS =
      0x8B86;
   static const GLenum ACTIVE_ATTRIBUTES =
      0x8B89;
   static const GLenum SHADING_LANGUAGE_VERSION =
      0x8B8C;
   static const GLenum CURRENT_PROGRAM =
      0x8B8D;
   static const GLenum NEVER =
      0x0200;
   static const GLenum LESS =
      0x0201;
   static const GLenum EQUAL =
      0x0202;
   static const GLenum LEQUAL =
      0x0203;
   static const GLenum GREATER =
      0x0204;
   static const GLenum NOTEQUAL =
      0x0205;
   static const GLenum GEQUAL =
      0x0206;
   static const GLenum ALWAYS =
      0x0207;
   static const GLenum KEEP =
      0x1E00;
   static const GLenum REPLACE =
      0x1E01;
   static const GLenum INCR =
      0x1E02;
   static const GLenum DECR =
      0x1E03;
   static const GLenum INVERT =
      0x150A;
   static const GLenum INCR_WRAP =
      0x8507;
   static const GLenum DECR_WRAP =
      0x8508;
   static const GLenum VENDOR =
      0x1F00;
   static const GLenum RENDERER =
      0x1F01;
   static const GLenum VERSION =
      0x1F02;
   static const GLenum NEAREST =
      0x2600;
   static const GLenum LINEAR =
      0x2601;
   static const GLenum NEAREST_MIPMAP_NEAREST =
      0x2700;
   static const GLenum LINEAR_MIPMAP_NEAREST =
      0x2701;
   static const GLenum NEAREST_MIPMAP_LINEAR =
      0x2702;
   static const GLenum LINEAR_MIPMAP_LINEAR =
      0x2703;
   static const GLenum TEXTURE_MAG_FILTER =
      0x2800;
   static const GLenum TEXTURE_MIN_FILTER =
      0x2801;
   static const GLenum TEXTURE_WRAP_S =
      0x2802;
   static const GLenum TEXTURE_WRAP_T =
      0x2803;
   static const GLenum TEXTURE_2D =
      0x0DE1;
   static const GLenum TEXTURE =
      0x1702;
   static const GLenum TEXTURE_CUBE_MAP =
      0x8513;
   static const GLenum TEXTURE_BINDING_CUBE_MAP =
      0x8514;
   static const GLenum TEXTURE_CUBE_MAP_POSITIVE_X =
      0x8515;
   static const GLenum TEXTURE_CUBE_MAP_NEGATIVE_X =
      0x8516;
   static const GLenum TEXTURE_CUBE_MAP_POSITIVE_Y =
      0x8517;
   static const GLenum TEXTURE_CUBE_MAP_NEGATIVE_Y =
      0x8518;
   static const GLenum TEXTURE_CUBE_MAP_POSITIVE_Z =
      0x8519;
   static const GLenum TEXTURE_CUBE_MAP_NEGATIVE_Z =
      0x851A;
   static const GLenum MAX_CUBE_MAP_TEXTURE_SIZE =
      0x851C;
   static const GLenum TEXTURE0 =
      0x84C0;
   static const GLenum TEXTURE1 =
      0x84C1;
   static const GLenum TEXTURE2 =
      0x84C2;
   static const GLenum TEXTURE3 =
      0x84C3;
   static const GLenum TEXTURE4 =
      0x84C4;
   static const GLenum TEXTURE5 =
      0x84C5;
   static const GLenum TEXTURE6 =
      0x84C6;
   static const GLenum TEXTURE7 =
      0x84C7;
   static const GLenum TEXTURE8 =
      0x84C8;
   static const GLenum TEXTURE9 =
      0x84C9;
   static const GLenum TEXTURE10 =
      0x84CA;
   static const GLenum TEXTURE11 =
      0x84CB;
   static const GLenum TEXTURE12 =
      0x84CC;
   static const GLenum TEXTURE13 =
      0x84CD;
   static const GLenum TEXTURE14 =
      0x84CE;
   static const GLenum TEXTURE15 =
      0x84CF;
   static const GLenum TEXTURE16 =
      0x84D0;
   static const GLenum TEXTURE17 =
      0x84D1;
   static const GLenum TEXTURE18 =
      0x84D2;
   static const GLenum TEXTURE19 =
      0x84D3;
   static const GLenum TEXTURE20 =
      0x84D4;
   static const GLenum TEXTURE21 =
      0x84D5;
   static const GLenum TEXTURE22 =
      0x84D6;
   static const GLenum TEXTURE23 =
      0x84D7;
   static const GLenum TEXTURE24 =
      0x84D8;
   static const GLenum TEXTURE25 =
      0x84D9;
   static const GLenum TEXTURE26 =
      0x84DA;
   static const GLenum TEXTURE27 =
      0x84DB;
   static const GLenum TEXTURE28 =
      0x84DC;
   static const GLenum TEXTURE29 =
      0x84DD;
   static const GLenum TEXTURE30 =
      0x84DE;
   static const GLenum TEXTURE31 =
      0x84DF;
   static const GLenum ACTIVE_TEXTURE =
      0x84E0;
   static const GLenum REPEAT =
      0x2901;
   static const GLenum CLAMP_TO_EDGE =
      0x812F;
   static const GLenum MIRRORED_REPEAT =
      0x8370;
   static const GLenum FLOAT_VEC2 =
      0x8B50;
   static const GLenum FLOAT_VEC3 =
      0x8B51;
   static const GLenum FLOAT_VEC4 =
      0x8B52;
   static const GLenum INT_VEC2 =
      0x8B53;
   static const GLenum INT_VEC3 =
      0x8B54;
   static const GLenum INT_VEC4 =
      0x8B55;
   static const GLenum BOOL =
      0x8B56;
   static const GLenum BOOL_VEC2 =
      0x8B57;
   static const GLenum BOOL_VEC3 =
      0x8B58;
   static const GLenum BOOL_VEC4 =
      0x8B59;
   static const GLenum FLOAT_MAT2 =
      0x8B5A;
   static const GLenum FLOAT_MAT3 =
      0x8B5B;
   static const GLenum FLOAT_MAT4 =
      0x8B5C;
   static const GLenum SAMPLER_2D =
      0x8B5E;
   static const GLenum SAMPLER_CUBE =
      0x8B60;
   static const GLenum VERTEX_ATTRIB_ARRAY_ENABLED =
      0x8622;
   static const GLenum VERTEX_ATTRIB_ARRAY_SIZE =
      0x8623;
   static const GLenum VERTEX_ATTRIB_ARRAY_STRIDE =
      0x8624;
   static const GLenum VERTEX_ATTRIB_ARRAY_TYPE =
      0x8625;
   static const GLenum VERTEX_ATTRIB_ARRAY_NORMALIZED =
      0x886A;
   static const GLenum VERTEX_ATTRIB_ARRAY_POINTER =
      0x8645;
   static const GLenum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING =
      0x889F;
   static const GLenum IMPLEMENTATION_COLOR_READ_TYPE =
      0x8B9A;
   static const GLenum IMPLEMENTATION_COLOR_READ_FORMAT =
      0x8B9B;
   static const GLenum COMPILE_STATUS =
      0x8B81;
   static const GLenum LOW_FLOAT =
      0x8DF0;
   static const GLenum MEDIUM_FLOAT =
      0x8DF1;
   static const GLenum HIGH_FLOAT =
      0x8DF2;
   static const GLenum LOW_INT =
      0x8DF3;
   static const GLenum MEDIUM_INT =
      0x8DF4;
   static const GLenum HIGH_INT =
      0x8DF5;
   static const GLenum FRAMEBUFFER =
      0x8D40;
   static const GLenum RENDERBUFFER =
      0x8D41;
   static const GLenum RGBA4 =
      0x8056;
   static const GLenum RGB5_A1 =
      0x8057;
   static const GLenum RGBA8 =
      0x8058;
   static const GLenum RGB565 =
      0x8D62;
   static const GLenum DEPTH_COMPONENT16 =
      0x81A5;
   static const GLenum STENCIL_INDEX8 =
      0x8D48;
   static const GLenum DEPTH_STENCIL =
      0x84F9;
   static const GLenum RENDERBUFFER_WIDTH =
      0x8D42;
   static const GLenum RENDERBUFFER_HEIGHT =
      0x8D43;
   static const GLenum RENDERBUFFER_INTERNAL_FORMAT =
      0x8D44;
   static const GLenum RENDERBUFFER_RED_SIZE =
      0x8D50;
   static const GLenum RENDERBUFFER_GREEN_SIZE =
      0x8D51;
   static const GLenum RENDERBUFFER_BLUE_SIZE =
      0x8D52;
   static const GLenum RENDERBUFFER_ALPHA_SIZE =
      0x8D53;
   static const GLenum RENDERBUFFER_DEPTH_SIZE =
      0x8D54;
   static const GLenum RENDERBUFFER_STENCIL_SIZE =
      0x8D55;
   static const GLenum FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE =
      0x8CD0;
   static const GLenum FRAMEBUFFER_ATTACHMENT_OBJECT_NAME =
      0x8CD1;
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL =
      0x8CD2;
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE =
      0x8CD3;
   static const GLenum COLOR_ATTACHMENT0 =
      0x8CE0;
   static const GLenum DEPTH_ATTACHMENT =
      0x8D00;
   static const GLenum STENCIL_ATTACHMENT =
      0x8D20;
   static const GLenum DEPTH_STENCIL_ATTACHMENT =
      0x821A;
   static const GLenum NONE =
      0;
   static const GLenum FRAMEBUFFER_COMPLETE =
      0x8CD5;
   static const GLenum FRAMEBUFFER_INCOMPLETE_ATTACHMENT =
      0x8CD6;
   static const GLenum FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT =
      0x8CD7;
   static const GLenum FRAMEBUFFER_INCOMPLETE_DIMENSIONS =
      0x8CD9;
   static const GLenum FRAMEBUFFER_UNSUPPORTED =
      0x8CDD;
   static const GLenum FRAMEBUFFER_BINDING =
      0x8CA6;
   static const GLenum RENDERBUFFER_BINDING =
      0x8CA7;
   static const GLenum MAX_RENDERBUFFER_SIZE =
      0x84E8;
   static const GLenum INVALID_FRAMEBUFFER_OPERATION =
      0x0506;
   static const GLenum UNPACK_FLIP_Y_WEBGL =
      0x9240;
   static const GLenum UNPACK_PREMULTIPLY_ALPHA_WEBGL =
      0x9241;
   static const GLenum CONTEXT_LOST_WEBGL =
      0x9242;
   static const GLenum UNPACK_COLORSPACE_CONVERSION_WEBGL =
      0x9243;
   static const GLenum BROWSER_DEFAULT_WEBGL =
      0x9244;
  Object get canvas;
  GLsizei get drawingBufferWidth;
  GLsizei get drawingBufferHeight;
  GLenum get drawingBufferFormat;
  PredefinedColorSpace get drawingBufferColorSpace;
   set drawingBufferColorSpace(PredefinedColorSpace value);
  PredefinedColorSpace get unpackColorSpace;
   set unpackColorSpace(PredefinedColorSpace value);
  WebGLContextAttributes? getContextAttributes();
  bool isContextLost();
  List<String>? getSupportedExtensions();
  Object? getExtension(String name);
  void drawingBufferStorage(GLenum sizedFormat, int width, int height);
  void activeTexture(GLenum texture);
  void attachShader(WebGLProgram program, WebGLShader shader);
  void bindAttribLocation(WebGLProgram program, GLuint index, String name);
  void bindBuffer(GLenum target, WebGLBuffer? buffer);
  void bindFramebuffer(GLenum target, WebGLFramebuffer? framebuffer);
  void bindRenderbuffer(GLenum target, WebGLRenderbuffer? renderbuffer);
  void bindTexture(GLenum target, WebGLTexture? texture);
  void blendColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
  void blendEquation(GLenum mode);
  void blendEquationSeparate(GLenum modeRGB, GLenum modeAlpha);
  void blendFunc(GLenum sfactor, GLenum dfactor);
  void blendFuncSeparate(GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
  GLenum checkFramebufferStatus(GLenum target);
  void clear(GLbitfield mask);
  void clearColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
  void clearDepth(GLclampf depth);
  void clearStencil(GLint s);
  void colorMask(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
  void compileShader(WebGLShader shader);
  void copyTexImage2D(GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
  void copyTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
  WebGLBuffer createBuffer();
  WebGLFramebuffer createFramebuffer();
  WebGLProgram createProgram();
  WebGLRenderbuffer createRenderbuffer();
  WebGLShader? createShader(GLenum type);
  WebGLTexture createTexture();
  void cullFace(GLenum mode);
  void deleteBuffer(WebGLBuffer? buffer);
  void deleteFramebuffer(WebGLFramebuffer? framebuffer);
  void deleteProgram(WebGLProgram? program);
  void deleteRenderbuffer(WebGLRenderbuffer? renderbuffer);
  void deleteShader(WebGLShader? shader);
  void deleteTexture(WebGLTexture? texture);
  void depthFunc(GLenum func);
  void depthMask(GLboolean flag);
  void depthRange(GLclampf zNear, GLclampf zFar);
  void detachShader(WebGLProgram program, WebGLShader shader);
  void disable(GLenum cap);
  void disableVertexAttribArray(GLuint index);
  void drawArrays(GLenum mode, GLint first, GLsizei count);
  void drawElements(GLenum mode, GLsizei count, GLenum type, GLintptr offset);
  void enable(GLenum cap);
  void enableVertexAttribArray(GLuint index);
  void finish();
  void flush();
  void framebufferRenderbuffer(GLenum target, GLenum attachment, GLenum renderbuffertarget, WebGLRenderbuffer? renderbuffer);
  void framebufferTexture2D(GLenum target, GLenum attachment, GLenum textarget, WebGLTexture? texture, GLint level);
  void frontFace(GLenum mode);
  void generateMipmap(GLenum target);
  WebGLActiveInfo? getActiveAttrib(WebGLProgram program, GLuint index);
  WebGLActiveInfo? getActiveUniform(WebGLProgram program, GLuint index);
  List<WebGLShader>? getAttachedShaders(WebGLProgram program);
  GLint getAttribLocation(WebGLProgram program, String name);
  Object getBufferParameter(GLenum target, GLenum pname);
  Object getParameter(GLenum pname);
  GLenum getError();
  Object getFramebufferAttachmentParameter(GLenum target, GLenum attachment, GLenum pname);
  Object getProgramParameter(WebGLProgram program, GLenum pname);
  String? getProgramInfoLog(WebGLProgram program);
  Object getRenderbufferParameter(GLenum target, GLenum pname);
  Object getShaderParameter(WebGLShader shader, GLenum pname);
  WebGLShaderPrecisionFormat? getShaderPrecisionFormat(GLenum shadertype, GLenum precisiontype);
  String? getShaderInfoLog(WebGLShader shader);
  String? getShaderSource(WebGLShader shader);
  Object getTexParameter(GLenum target, GLenum pname);
  Object getUniform(WebGLProgram program, WebGLUniformLocation location);
  WebGLUniformLocation? getUniformLocation(WebGLProgram program, String name);
  Object getVertexAttrib(GLuint index, GLenum pname);
  GLintptr getVertexAttribOffset(GLuint index, GLenum pname);
  void hint(GLenum target, GLenum mode);
  GLboolean isBuffer(WebGLBuffer? buffer);
  GLboolean isEnabled(GLenum cap);
  GLboolean isFramebuffer(WebGLFramebuffer? framebuffer);
  GLboolean isProgram(WebGLProgram? program);
  GLboolean isRenderbuffer(WebGLRenderbuffer? renderbuffer);
  GLboolean isShader(WebGLShader? shader);
  GLboolean isTexture(WebGLTexture? texture);
  void lineWidth(GLfloat width);
  void linkProgram(WebGLProgram program);
  void pixelStorei(GLenum pname, GLint param);
  void polygonOffset(GLfloat factor, GLfloat units);
  void renderbufferStorage(GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
  void sampleCoverage(GLclampf value, GLboolean invert);
  void scissor(GLint x, GLint y, GLsizei width, GLsizei height);
  void shaderSource(WebGLShader shader, String source);
  void stencilFunc(GLenum func, GLint ref, GLuint mask);
  void stencilFuncSeparate(GLenum face, GLenum func, GLint ref, GLuint mask);
  void stencilMask(GLuint mask);
  void stencilMaskSeparate(GLenum face, GLuint mask);
  void stencilOp(GLenum fail, GLenum zfail, GLenum zpass);
  void stencilOpSeparate(GLenum face, GLenum fail, GLenum zfail, GLenum zpass);
  void texParameterf(GLenum target, GLenum pname, GLfloat param);
  void texParameteri(GLenum target, GLenum pname, GLint param);
  void uniform1f(WebGLUniformLocation? location, GLfloat x);
  void uniform2f(WebGLUniformLocation? location, GLfloat x, GLfloat y);
  void uniform3f(WebGLUniformLocation? location, GLfloat x, GLfloat y, GLfloat z);
  void uniform4f(WebGLUniformLocation? location, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
  void uniform1i(WebGLUniformLocation? location, GLint x);
  void uniform2i(WebGLUniformLocation? location, GLint x, GLint y);
  void uniform3i(WebGLUniformLocation? location, GLint x, GLint y, GLint z);
  void uniform4i(WebGLUniformLocation? location, GLint x, GLint y, GLint z, GLint w);
  void useProgram(WebGLProgram? program);
  void validateProgram(WebGLProgram program);
  void vertexAttrib1f(GLuint index, GLfloat x);
  void vertexAttrib2f(GLuint index, GLfloat x, GLfloat y);
  void vertexAttrib3f(GLuint index, GLfloat x, GLfloat y, GLfloat z);
  void vertexAttrib4f(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
  void vertexAttrib1fv(GLuint index, Float32List values);
  void vertexAttrib2fv(GLuint index, Float32List values);
  void vertexAttrib3fv(GLuint index, Float32List values);
  void vertexAttrib4fv(GLuint index, Float32List values);
  void vertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLintptr offset);
  void viewport(GLint x, GLint y, GLsizei width, GLsizei height);
  Future<void> makeXRCompatible();
   static const GLenum READ_BUFFER =
      0x0C02;
   static const GLenum UNPACK_ROW_LENGTH =
      0x0CF2;
   static const GLenum UNPACK_SKIP_ROWS =
      0x0CF3;
   static const GLenum UNPACK_SKIP_PIXELS =
      0x0CF4;
   static const GLenum PACK_ROW_LENGTH =
      0x0D02;
   static const GLenum PACK_SKIP_ROWS =
      0x0D03;
   static const GLenum PACK_SKIP_PIXELS =
      0x0D04;
   static const GLenum COLOR =
      0x1800;
   static const GLenum DEPTH =
      0x1801;
   static const GLenum STENCIL =
      0x1802;
   static const GLenum RED =
      0x1903;
   static const GLenum RGB8 =
      0x8051;
   static const GLenum RGB10_A2 =
      0x8059;
   static const GLenum TEXTURE_BINDING_3D =
      0x806A;
   static const GLenum UNPACK_SKIP_IMAGES =
      0x806D;
   static const GLenum UNPACK_IMAGE_HEIGHT =
      0x806E;
   static const GLenum TEXTURE_3D =
      0x806F;
   static const GLenum TEXTURE_WRAP_R =
      0x8072;
   static const GLenum MAX_3D_TEXTURE_SIZE =
      0x8073;
   static const GLenum UNSIGNED_INT_2_10_10_10_REV =
      0x8368;
   static const GLenum MAX_ELEMENTS_VERTICES =
      0x80E8;
   static const GLenum MAX_ELEMENTS_INDICES =
      0x80E9;
   static const GLenum TEXTURE_MIN_LOD =
      0x813A;
   static const GLenum TEXTURE_MAX_LOD =
      0x813B;
   static const GLenum TEXTURE_BASE_LEVEL =
      0x813C;
   static const GLenum TEXTURE_MAX_LEVEL =
      0x813D;
   static const GLenum MIN =
      0x8007;
   static const GLenum MAX =
      0x8008;
   static const GLenum DEPTH_COMPONENT24 =
      0x81A6;
   static const GLenum MAX_TEXTURE_LOD_BIAS =
      0x84FD;
   static const GLenum TEXTURE_COMPARE_MODE =
      0x884C;
   static const GLenum TEXTURE_COMPARE_FUNC =
      0x884D;
   static const GLenum CURRENT_QUERY =
      0x8865;
   static const GLenum QUERY_RESULT =
      0x8866;
   static const GLenum QUERY_RESULT_AVAILABLE =
      0x8867;
   static const GLenum STREAM_READ =
      0x88E1;
   static const GLenum STREAM_COPY =
      0x88E2;
   static const GLenum STATIC_READ =
      0x88E5;
   static const GLenum STATIC_COPY =
      0x88E6;
   static const GLenum DYNAMIC_READ =
      0x88E9;
   static const GLenum DYNAMIC_COPY =
      0x88EA;
   static const GLenum MAX_DRAW_BUFFERS =
      0x8824;
   static const GLenum DRAW_BUFFER0 =
      0x8825;
   static const GLenum DRAW_BUFFER1 =
      0x8826;
   static const GLenum DRAW_BUFFER2 =
      0x8827;
   static const GLenum DRAW_BUFFER3 =
      0x8828;
   static const GLenum DRAW_BUFFER4 =
      0x8829;
   static const GLenum DRAW_BUFFER5 =
      0x882A;
   static const GLenum DRAW_BUFFER6 =
      0x882B;
   static const GLenum DRAW_BUFFER7 =
      0x882C;
   static const GLenum DRAW_BUFFER8 =
      0x882D;
   static const GLenum DRAW_BUFFER9 =
      0x882E;
   static const GLenum DRAW_BUFFER10 =
      0x882F;
   static const GLenum DRAW_BUFFER11 =
      0x8830;
   static const GLenum DRAW_BUFFER12 =
      0x8831;
   static const GLenum DRAW_BUFFER13 =
      0x8832;
   static const GLenum DRAW_BUFFER14 =
      0x8833;
   static const GLenum DRAW_BUFFER15 =
      0x8834;
   static const GLenum MAX_FRAGMENT_UNIFORM_COMPONENTS =
      0x8B49;
   static const GLenum MAX_VERTEX_UNIFORM_COMPONENTS =
      0x8B4A;
   static const GLenum SAMPLER_3D =
      0x8B5F;
   static const GLenum SAMPLER_2D_SHADOW =
      0x8B62;
   static const GLenum FRAGMENT_SHADER_DERIVATIVE_HINT =
      0x8B8B;
   static const GLenum PIXEL_PACK_BUFFER =
      0x88EB;
   static const GLenum PIXEL_UNPACK_BUFFER =
      0x88EC;
   static const GLenum PIXEL_PACK_BUFFER_BINDING =
      0x88ED;
   static const GLenum PIXEL_UNPACK_BUFFER_BINDING =
      0x88EF;
   static const GLenum FLOAT_MAT2x3 =
      0x8B65;
   static const GLenum FLOAT_MAT2x4 =
      0x8B66;
   static const GLenum FLOAT_MAT3x2 =
      0x8B67;
   static const GLenum FLOAT_MAT3x4 =
      0x8B68;
   static const GLenum FLOAT_MAT4x2 =
      0x8B69;
   static const GLenum FLOAT_MAT4x3 =
      0x8B6A;
   static const GLenum SRGB =
      0x8C40;
   static const GLenum SRGB8 =
      0x8C41;
   static const GLenum SRGB8_ALPHA8 =
      0x8C43;
   static const GLenum COMPARE_REF_TO_TEXTURE =
      0x884E;
   static const GLenum RGBA32F =
      0x8814;
   static const GLenum RGB32F =
      0x8815;
   static const GLenum RGBA16F =
      0x881A;
   static const GLenum RGB16F =
      0x881B;
   static const GLenum VERTEX_ATTRIB_ARRAY_INTEGER =
      0x88FD;
   static const GLenum MAX_ARRAY_TEXTURE_LAYERS =
      0x88FF;
   static const GLenum MIN_PROGRAM_TEXEL_OFFSET =
      0x8904;
   static const GLenum MAX_PROGRAM_TEXEL_OFFSET =
      0x8905;
   static const GLenum MAX_VARYING_COMPONENTS =
      0x8B4B;
   static const GLenum TEXTURE_2D_ARRAY =
      0x8C1A;
   static const GLenum TEXTURE_BINDING_2D_ARRAY =
      0x8C1D;
   static const GLenum R11F_G11F_B10F =
      0x8C3A;
   static const GLenum UNSIGNED_INT_10F_11F_11F_REV =
      0x8C3B;
   static const GLenum RGB9_E5 =
      0x8C3D;
   static const GLenum UNSIGNED_INT_5_9_9_9_REV =
      0x8C3E;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_MODE =
      0x8C7F;
   static const GLenum MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS =
      0x8C80;
   static const GLenum TRANSFORM_FEEDBACK_VARYINGS =
      0x8C83;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_START =
      0x8C84;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_SIZE =
      0x8C85;
   static const GLenum TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN =
      0x8C88;
   static const GLenum RASTERIZER_DISCARD =
      0x8C89;
   static const GLenum MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS =
      0x8C8A;
   static const GLenum MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS =
      0x8C8B;
   static const GLenum INTERLEAVED_ATTRIBS =
      0x8C8C;
   static const GLenum SEPARATE_ATTRIBS =
      0x8C8D;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER =
      0x8C8E;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_BINDING =
      0x8C8F;
   static const GLenum RGBA32UI =
      0x8D70;
   static const GLenum RGB32UI =
      0x8D71;
   static const GLenum RGBA16UI =
      0x8D76;
   static const GLenum RGB16UI =
      0x8D77;
   static const GLenum RGBA8UI =
      0x8D7C;
   static const GLenum RGB8UI =
      0x8D7D;
   static const GLenum RGBA32I =
      0x8D82;
   static const GLenum RGB32I =
      0x8D83;
   static const GLenum RGBA16I =
      0x8D88;
   static const GLenum RGB16I =
      0x8D89;
   static const GLenum RGBA8I =
      0x8D8E;
   static const GLenum RGB8I =
      0x8D8F;
   static const GLenum RED_INTEGER =
      0x8D94;
   static const GLenum RGB_INTEGER =
      0x8D98;
   static const GLenum RGBA_INTEGER =
      0x8D99;
   static const GLenum SAMPLER_2D_ARRAY =
      0x8DC1;
   static const GLenum SAMPLER_2D_ARRAY_SHADOW =
      0x8DC4;
   static const GLenum SAMPLER_CUBE_SHADOW =
      0x8DC5;
   static const GLenum UNSIGNED_INT_VEC2 =
      0x8DC6;
   static const GLenum UNSIGNED_INT_VEC3 =
      0x8DC7;
   static const GLenum UNSIGNED_INT_VEC4 =
      0x8DC8;
   static const GLenum INT_SAMPLER_2D =
      0x8DCA;
   static const GLenum INT_SAMPLER_3D =
      0x8DCB;
   static const GLenum INT_SAMPLER_CUBE =
      0x8DCC;
   static const GLenum INT_SAMPLER_2D_ARRAY =
      0x8DCF;
   static const GLenum UNSIGNED_INT_SAMPLER_2D =
      0x8DD2;
   static const GLenum UNSIGNED_INT_SAMPLER_3D =
      0x8DD3;
   static const GLenum UNSIGNED_INT_SAMPLER_CUBE =
      0x8DD4;
   static const GLenum UNSIGNED_INT_SAMPLER_2D_ARRAY =
      0x8DD7;
   static const GLenum DEPTH_COMPONENT32F =
      0x8CAC;
   static const GLenum DEPTH32F_STENCIL8 =
      0x8CAD;
   static const GLenum FLOAT_32_UNSIGNED_INT_24_8_REV =
      0x8DAD;
   static const GLenum FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING =
      0x8210;
   static const GLenum FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE =
      0x8211;
   static const GLenum FRAMEBUFFER_ATTACHMENT_RED_SIZE =
      0x8212;
   static const GLenum FRAMEBUFFER_ATTACHMENT_GREEN_SIZE =
      0x8213;
   static const GLenum FRAMEBUFFER_ATTACHMENT_BLUE_SIZE =
      0x8214;
   static const GLenum FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE =
      0x8215;
   static const GLenum FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE =
      0x8216;
   static const GLenum FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE =
      0x8217;
   static const GLenum FRAMEBUFFER_DEFAULT =
      0x8218;
   static const GLenum UNSIGNED_INT_24_8 =
      0x84FA;
   static const GLenum DEPTH24_STENCIL8 =
      0x88F0;
   static const GLenum UNSIGNED_NORMALIZED =
      0x8C17;
   static const GLenum DRAW_FRAMEBUFFER_BINDING =
      0x8CA6;
   static const GLenum READ_FRAMEBUFFER =
      0x8CA8;
   static const GLenum DRAW_FRAMEBUFFER =
      0x8CA9;
   static const GLenum READ_FRAMEBUFFER_BINDING =
      0x8CAA;
   static const GLenum RENDERBUFFER_SAMPLES =
      0x8CAB;
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER =
      0x8CD4;
   static const GLenum MAX_COLOR_ATTACHMENTS =
      0x8CDF;
   static const GLenum COLOR_ATTACHMENT1 =
      0x8CE1;
   static const GLenum COLOR_ATTACHMENT2 =
      0x8CE2;
   static const GLenum COLOR_ATTACHMENT3 =
      0x8CE3;
   static const GLenum COLOR_ATTACHMENT4 =
      0x8CE4;
   static const GLenum COLOR_ATTACHMENT5 =
      0x8CE5;
   static const GLenum COLOR_ATTACHMENT6 =
      0x8CE6;
   static const GLenum COLOR_ATTACHMENT7 =
      0x8CE7;
   static const GLenum COLOR_ATTACHMENT8 =
      0x8CE8;
   static const GLenum COLOR_ATTACHMENT9 =
      0x8CE9;
   static const GLenum COLOR_ATTACHMENT10 =
      0x8CEA;
   static const GLenum COLOR_ATTACHMENT11 =
      0x8CEB;
   static const GLenum COLOR_ATTACHMENT12 =
      0x8CEC;
   static const GLenum COLOR_ATTACHMENT13 =
      0x8CED;
   static const GLenum COLOR_ATTACHMENT14 =
      0x8CEE;
   static const GLenum COLOR_ATTACHMENT15 =
      0x8CEF;
   static const GLenum FRAMEBUFFER_INCOMPLETE_MULTISAMPLE =
      0x8D56;
   static const GLenum MAX_SAMPLES =
      0x8D57;
   static const GLenum HALF_FLOAT =
      0x140B;
   static const GLenum RG =
      0x8227;
   static const GLenum RG_INTEGER =
      0x8228;
   static const GLenum R8 =
      0x8229;
   static const GLenum RG8 =
      0x822B;
   static const GLenum R16F =
      0x822D;
   static const GLenum R32F =
      0x822E;
   static const GLenum RG16F =
      0x822F;
   static const GLenum RG32F =
      0x8230;
   static const GLenum R8I =
      0x8231;
   static const GLenum R8UI =
      0x8232;
   static const GLenum R16I =
      0x8233;
   static const GLenum R16UI =
      0x8234;
   static const GLenum R32I =
      0x8235;
   static const GLenum R32UI =
      0x8236;
   static const GLenum RG8I =
      0x8237;
   static const GLenum RG8UI =
      0x8238;
   static const GLenum RG16I =
      0x8239;
   static const GLenum RG16UI =
      0x823A;
   static const GLenum RG32I =
      0x823B;
   static const GLenum RG32UI =
      0x823C;
   static const GLenum VERTEX_ARRAY_BINDING =
      0x85B5;
   static const GLenum R8_SNORM =
      0x8F94;
   static const GLenum RG8_SNORM =
      0x8F95;
   static const GLenum RGB8_SNORM =
      0x8F96;
   static const GLenum RGBA8_SNORM =
      0x8F97;
   static const GLenum SIGNED_NORMALIZED =
      0x8F9C;
   static const GLenum COPY_READ_BUFFER =
      0x8F36;
   static const GLenum COPY_WRITE_BUFFER =
      0x8F37;
   static const GLenum COPY_READ_BUFFER_BINDING =
      0x8F36;
   static const GLenum COPY_WRITE_BUFFER_BINDING =
      0x8F37;
   static const GLenum UNIFORM_BUFFER =
      0x8A11;
   static const GLenum UNIFORM_BUFFER_BINDING =
      0x8A28;
   static const GLenum UNIFORM_BUFFER_START =
      0x8A29;
   static const GLenum UNIFORM_BUFFER_SIZE =
      0x8A2A;
   static const GLenum MAX_VERTEX_UNIFORM_BLOCKS =
      0x8A2B;
   static const GLenum MAX_FRAGMENT_UNIFORM_BLOCKS =
      0x8A2D;
   static const GLenum MAX_COMBINED_UNIFORM_BLOCKS =
      0x8A2E;
   static const GLenum MAX_UNIFORM_BUFFER_BINDINGS =
      0x8A2F;
   static const GLenum MAX_UNIFORM_BLOCK_SIZE =
      0x8A30;
   static const GLenum MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS =
      0x8A31;
   static const GLenum MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS =
      0x8A33;
   static const GLenum UNIFORM_BUFFER_OFFSET_ALIGNMENT =
      0x8A34;
   static const GLenum ACTIVE_UNIFORM_BLOCKS =
      0x8A36;
   static const GLenum UNIFORM_TYPE =
      0x8A37;
   static const GLenum UNIFORM_SIZE =
      0x8A38;
   static const GLenum UNIFORM_BLOCK_INDEX =
      0x8A3A;
   static const GLenum UNIFORM_OFFSET =
      0x8A3B;
   static const GLenum UNIFORM_ARRAY_STRIDE =
      0x8A3C;
   static const GLenum UNIFORM_MATRIX_STRIDE =
      0x8A3D;
   static const GLenum UNIFORM_IS_ROW_MAJOR =
      0x8A3E;
   static const GLenum UNIFORM_BLOCK_BINDING =
      0x8A3F;
   static const GLenum UNIFORM_BLOCK_DATA_SIZE =
      0x8A40;
   static const GLenum UNIFORM_BLOCK_ACTIVE_UNIFORMS =
      0x8A42;
   static const GLenum UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES =
      0x8A43;
   static const GLenum UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER =
      0x8A44;
   static const GLenum UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER =
      0x8A46;
   static const GLenum INVALID_INDEX =
      0xFFFFFFFF;
   static const GLenum MAX_VERTEX_OUTPUT_COMPONENTS =
      0x9122;
   static const GLenum MAX_FRAGMENT_INPUT_COMPONENTS =
      0x9125;
   static const GLenum MAX_SERVER_WAIT_TIMEOUT =
      0x9111;
   static const GLenum OBJECT_TYPE =
      0x9112;
   static const GLenum SYNC_CONDITION =
      0x9113;
   static const GLenum SYNC_STATUS =
      0x9114;
   static const GLenum SYNC_FLAGS =
      0x9115;
   static const GLenum SYNC_FENCE =
      0x9116;
   static const GLenum SYNC_GPU_COMMANDS_COMPLETE =
      0x9117;
   static const GLenum UNSIGNALED =
      0x9118;
   static const GLenum SIGNALED =
      0x9119;
   static const GLenum ALREADY_SIGNALED =
      0x911A;
   static const GLenum TIMEOUT_EXPIRED =
      0x911B;
   static const GLenum CONDITION_SATISFIED =
      0x911C;
   static const GLenum WAIT_FAILED =
      0x911D;
   static const GLenum SYNC_FLUSH_COMMANDS_BIT =
      0x00000001;
   static const GLenum VERTEX_ATTRIB_ARRAY_DIVISOR =
      0x88FE;
   static const GLenum ANY_SAMPLES_PASSED =
      0x8C2F;
   static const GLenum ANY_SAMPLES_PASSED_CONSERVATIVE =
      0x8D6A;
   static const GLenum SAMPLER_BINDING =
      0x8919;
   static const GLenum RGB10_A2UI =
      0x906F;
   static const GLenum INT_2_10_10_10_REV =
      0x8D9F;
   static const GLenum TRANSFORM_FEEDBACK =
      0x8E22;
   static const GLenum TRANSFORM_FEEDBACK_PAUSED =
      0x8E23;
   static const GLenum TRANSFORM_FEEDBACK_ACTIVE =
      0x8E24;
   static const GLenum TRANSFORM_FEEDBACK_BINDING =
      0x8E25;
   static const GLenum TEXTURE_IMMUTABLE_FORMAT =
      0x912F;
   static const GLenum MAX_ELEMENT_INDEX =
      0x8D6B;
   static const GLenum TEXTURE_IMMUTABLE_LEVELS =
      0x82DF;
   static const GLint64 TIMEOUT_IGNORED =
      -1;
   static const GLenum MAX_CLIENT_WAIT_TIMEOUT_WEBGL =
      0x9247;
  void copyBufferSubData(GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size);
  void getBufferSubData(GLenum target, GLintptr srcByteOffset, ArrayBufferView dstBuffer, [int? dstOffset, GLuint? length]);
  void blitFramebuffer(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
  void framebufferTextureLayer(GLenum target, GLenum attachment, WebGLTexture? texture, GLint level, GLint layer);
  void invalidateFramebuffer(GLenum target, List<GLenum> attachments);
  void invalidateSubFramebuffer(GLenum target, List<GLenum> attachments, GLint x, GLint y, GLsizei width, GLsizei height);
  void readBuffer(GLenum src);
  Object getInternalformatParameter(GLenum target, GLenum internalformat, GLenum pname);
  void renderbufferStorageMultisample(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
  void texStorage2D(GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
  void texStorage3D(GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
  void texImage3D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void texSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, ArrayBufferView? srcData, [int? srcOffset]);
  void copyTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
  void compressedTexImage3D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void compressedTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  GLint getFragDataLocation(WebGLProgram program, String name);
  void uniform1ui(WebGLUniformLocation? location, GLuint v0);
  void uniform2ui(WebGLUniformLocation? location, GLuint v0, GLuint v1);
  void uniform3ui(WebGLUniformLocation? location, GLuint v0, GLuint v1, GLuint v2);
  void uniform4ui(WebGLUniformLocation? location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
  void uniform1uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3x2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4x2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2x3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4x3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2x4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3x4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void vertexAttribI4i(GLuint index, GLint x, GLint y, GLint z, GLint w);
  void vertexAttribI4iv(GLuint index, Int32List values);
  void vertexAttribI4ui(GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
  void vertexAttribI4uiv(GLuint index, Uint32List values);
  void vertexAttribIPointer(GLuint index, GLint size, GLenum type, GLsizei stride, GLintptr offset);
  void vertexAttribDivisor(GLuint index, GLuint divisor);
  void drawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei instanceCount);
  void drawElementsInstanced(GLenum mode, GLsizei count, GLenum type, GLintptr offset, GLsizei instanceCount);
  void drawRangeElements(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLintptr offset);
  void drawBuffers(List<GLenum> buffers);
  void clearBufferfv(GLenum buffer, GLint drawbuffer, Float32List values, [int? srcOffset]);
  void clearBufferiv(GLenum buffer, GLint drawbuffer, Int32List values, [int? srcOffset]);
  void clearBufferuiv(GLenum buffer, GLint drawbuffer, Uint32List values, [int? srcOffset]);
  void clearBufferfi(GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);
  WebGLQuery createQuery();
  void deleteQuery(WebGLQuery? query);
  GLboolean isQuery(WebGLQuery? query);
  void beginQuery(GLenum target, WebGLQuery query);
  void endQuery(GLenum target);
  WebGLQuery? getQuery(GLenum target, GLenum pname);
  Object getQueryParameter(WebGLQuery query, GLenum pname);
  WebGLSampler createSampler();
  void deleteSampler(WebGLSampler? sampler);
  GLboolean isSampler(WebGLSampler? sampler);
  void bindSampler(GLuint unit, WebGLSampler? sampler);
  void samplerParameteri(WebGLSampler sampler, GLenum pname, GLint param);
  void samplerParameterf(WebGLSampler sampler, GLenum pname, GLfloat param);
  Object getSamplerParameter(WebGLSampler sampler, GLenum pname);
  WebGLSync? fenceSync(GLenum condition, GLbitfield flags);
  GLboolean isSync(WebGLSync? sync_);
  void deleteSync(WebGLSync? sync_);
  GLenum clientWaitSync(WebGLSync sync_, GLbitfield flags, GLuint64 timeout);
  void waitSync(WebGLSync sync_, GLbitfield flags, GLint64 timeout);
  Object getSyncParameter(WebGLSync sync_, GLenum pname);
  WebGLTransformFeedback createTransformFeedback();
  void deleteTransformFeedback(WebGLTransformFeedback? tf);
  GLboolean isTransformFeedback(WebGLTransformFeedback? tf);
  void bindTransformFeedback(GLenum target, WebGLTransformFeedback? tf);
  void beginTransformFeedback(GLenum primitiveMode);
  void endTransformFeedback();
  void transformFeedbackVaryings(WebGLProgram program, List<String> varyings, GLenum bufferMode);
  WebGLActiveInfo? getTransformFeedbackVarying(WebGLProgram program, GLuint index);
  void pauseTransformFeedback();
  void resumeTransformFeedback();
  void bindBufferBase(GLenum target, GLuint index, WebGLBuffer? buffer);
  void bindBufferRange(GLenum target, GLuint index, WebGLBuffer? buffer, GLintptr offset, GLsizeiptr size);
  Object getIndexedParameter(GLenum target, GLuint index);
  List<GLuint>? getUniformIndices(WebGLProgram program, List<String> uniformNames);
  Object getActiveUniforms(WebGLProgram program, List<GLuint> uniformIndices, GLenum pname);
  GLuint getUniformBlockIndex(WebGLProgram program, String uniformBlockName);
  Object getActiveUniformBlockParameter(WebGLProgram program, GLuint uniformBlockIndex, GLenum pname);
  String? getActiveUniformBlockName(WebGLProgram program, GLuint uniformBlockIndex);
  void uniformBlockBinding(WebGLProgram program, GLuint uniformBlockIndex, GLuint uniformBlockBinding);
  WebGLVertexArrayObject createVertexArray();
  void deleteVertexArray(WebGLVertexArrayObject? vertexArray);
  GLboolean isVertexArray(WebGLVertexArrayObject? vertexArray);
  void bindVertexArray(WebGLVertexArrayObject? array);
  void bufferData(GLenum target, ArrayBufferView srcData, GLenum usage, int srcOffset, [GLuint? length]);
  void bufferSubData(GLenum target, GLintptr dstByteOffset, ArrayBufferView srcData, int srcOffset, [GLuint? length]);
  void texImage2D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void texSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void compressedTexImage2D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void compressedTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void uniform1fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform1iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void readPixels(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, ArrayBufferView dstData, int dstOffset);
}

abstract interface class WebGL2RenderingContextBase {
   static const GLenum READ_BUFFER =
      0x0C02;
   static const GLenum UNPACK_ROW_LENGTH =
      0x0CF2;
   static const GLenum UNPACK_SKIP_ROWS =
      0x0CF3;
   static const GLenum UNPACK_SKIP_PIXELS =
      0x0CF4;
   static const GLenum PACK_ROW_LENGTH =
      0x0D02;
   static const GLenum PACK_SKIP_ROWS =
      0x0D03;
   static const GLenum PACK_SKIP_PIXELS =
      0x0D04;
   static const GLenum COLOR =
      0x1800;
   static const GLenum DEPTH =
      0x1801;
   static const GLenum STENCIL =
      0x1802;
   static const GLenum RED =
      0x1903;
   static const GLenum RGB8 =
      0x8051;
   static const GLenum RGB10_A2 =
      0x8059;
   static const GLenum TEXTURE_BINDING_3D =
      0x806A;
   static const GLenum UNPACK_SKIP_IMAGES =
      0x806D;
   static const GLenum UNPACK_IMAGE_HEIGHT =
      0x806E;
   static const GLenum TEXTURE_3D =
      0x806F;
   static const GLenum TEXTURE_WRAP_R =
      0x8072;
   static const GLenum MAX_3D_TEXTURE_SIZE =
      0x8073;
   static const GLenum UNSIGNED_INT_2_10_10_10_REV =
      0x8368;
   static const GLenum MAX_ELEMENTS_VERTICES =
      0x80E8;
   static const GLenum MAX_ELEMENTS_INDICES =
      0x80E9;
   static const GLenum TEXTURE_MIN_LOD =
      0x813A;
   static const GLenum TEXTURE_MAX_LOD =
      0x813B;
   static const GLenum TEXTURE_BASE_LEVEL =
      0x813C;
   static const GLenum TEXTURE_MAX_LEVEL =
      0x813D;
   static const GLenum MIN =
      0x8007;
   static const GLenum MAX =
      0x8008;
   static const GLenum DEPTH_COMPONENT24 =
      0x81A6;
   static const GLenum MAX_TEXTURE_LOD_BIAS =
      0x84FD;
   static const GLenum TEXTURE_COMPARE_MODE =
      0x884C;
   static const GLenum TEXTURE_COMPARE_FUNC =
      0x884D;
   static const GLenum CURRENT_QUERY =
      0x8865;
   static const GLenum QUERY_RESULT =
      0x8866;
   static const GLenum QUERY_RESULT_AVAILABLE =
      0x8867;
   static const GLenum STREAM_READ =
      0x88E1;
   static const GLenum STREAM_COPY =
      0x88E2;
   static const GLenum STATIC_READ =
      0x88E5;
   static const GLenum STATIC_COPY =
      0x88E6;
   static const GLenum DYNAMIC_READ =
      0x88E9;
   static const GLenum DYNAMIC_COPY =
      0x88EA;
   static const GLenum MAX_DRAW_BUFFERS =
      0x8824;
   static const GLenum DRAW_BUFFER0 =
      0x8825;
   static const GLenum DRAW_BUFFER1 =
      0x8826;
   static const GLenum DRAW_BUFFER2 =
      0x8827;
   static const GLenum DRAW_BUFFER3 =
      0x8828;
   static const GLenum DRAW_BUFFER4 =
      0x8829;
   static const GLenum DRAW_BUFFER5 =
      0x882A;
   static const GLenum DRAW_BUFFER6 =
      0x882B;
   static const GLenum DRAW_BUFFER7 =
      0x882C;
   static const GLenum DRAW_BUFFER8 =
      0x882D;
   static const GLenum DRAW_BUFFER9 =
      0x882E;
   static const GLenum DRAW_BUFFER10 =
      0x882F;
   static const GLenum DRAW_BUFFER11 =
      0x8830;
   static const GLenum DRAW_BUFFER12 =
      0x8831;
   static const GLenum DRAW_BUFFER13 =
      0x8832;
   static const GLenum DRAW_BUFFER14 =
      0x8833;
   static const GLenum DRAW_BUFFER15 =
      0x8834;
   static const GLenum MAX_FRAGMENT_UNIFORM_COMPONENTS =
      0x8B49;
   static const GLenum MAX_VERTEX_UNIFORM_COMPONENTS =
      0x8B4A;
   static const GLenum SAMPLER_3D =
      0x8B5F;
   static const GLenum SAMPLER_2D_SHADOW =
      0x8B62;
   static const GLenum FRAGMENT_SHADER_DERIVATIVE_HINT =
      0x8B8B;
   static const GLenum PIXEL_PACK_BUFFER =
      0x88EB;
   static const GLenum PIXEL_UNPACK_BUFFER =
      0x88EC;
   static const GLenum PIXEL_PACK_BUFFER_BINDING =
      0x88ED;
   static const GLenum PIXEL_UNPACK_BUFFER_BINDING =
      0x88EF;
   static const GLenum FLOAT_MAT2x3 =
      0x8B65;
   static const GLenum FLOAT_MAT2x4 =
      0x8B66;
   static const GLenum FLOAT_MAT3x2 =
      0x8B67;
   static const GLenum FLOAT_MAT3x4 =
      0x8B68;
   static const GLenum FLOAT_MAT4x2 =
      0x8B69;
   static const GLenum FLOAT_MAT4x3 =
      0x8B6A;
   static const GLenum SRGB =
      0x8C40;
   static const GLenum SRGB8 =
      0x8C41;
   static const GLenum SRGB8_ALPHA8 =
      0x8C43;
   static const GLenum COMPARE_REF_TO_TEXTURE =
      0x884E;
   static const GLenum RGBA32F =
      0x8814;
   static const GLenum RGB32F =
      0x8815;
   static const GLenum RGBA16F =
      0x881A;
   static const GLenum RGB16F =
      0x881B;
   static const GLenum VERTEX_ATTRIB_ARRAY_INTEGER =
      0x88FD;
   static const GLenum MAX_ARRAY_TEXTURE_LAYERS =
      0x88FF;
   static const GLenum MIN_PROGRAM_TEXEL_OFFSET =
      0x8904;
   static const GLenum MAX_PROGRAM_TEXEL_OFFSET =
      0x8905;
   static const GLenum MAX_VARYING_COMPONENTS =
      0x8B4B;
   static const GLenum TEXTURE_2D_ARRAY =
      0x8C1A;
   static const GLenum TEXTURE_BINDING_2D_ARRAY =
      0x8C1D;
   static const GLenum R11F_G11F_B10F =
      0x8C3A;
   static const GLenum UNSIGNED_INT_10F_11F_11F_REV =
      0x8C3B;
   static const GLenum RGB9_E5 =
      0x8C3D;
   static const GLenum UNSIGNED_INT_5_9_9_9_REV =
      0x8C3E;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_MODE =
      0x8C7F;
   static const GLenum MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS =
      0x8C80;
   static const GLenum TRANSFORM_FEEDBACK_VARYINGS =
      0x8C83;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_START =
      0x8C84;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_SIZE =
      0x8C85;
   static const GLenum TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN =
      0x8C88;
   static const GLenum RASTERIZER_DISCARD =
      0x8C89;
   static const GLenum MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS =
      0x8C8A;
   static const GLenum MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS =
      0x8C8B;
   static const GLenum INTERLEAVED_ATTRIBS =
      0x8C8C;
   static const GLenum SEPARATE_ATTRIBS =
      0x8C8D;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER =
      0x8C8E;
   static const GLenum TRANSFORM_FEEDBACK_BUFFER_BINDING =
      0x8C8F;
   static const GLenum RGBA32UI =
      0x8D70;
   static const GLenum RGB32UI =
      0x8D71;
   static const GLenum RGBA16UI =
      0x8D76;
   static const GLenum RGB16UI =
      0x8D77;
   static const GLenum RGBA8UI =
      0x8D7C;
   static const GLenum RGB8UI =
      0x8D7D;
   static const GLenum RGBA32I =
      0x8D82;
   static const GLenum RGB32I =
      0x8D83;
   static const GLenum RGBA16I =
      0x8D88;
   static const GLenum RGB16I =
      0x8D89;
   static const GLenum RGBA8I =
      0x8D8E;
   static const GLenum RGB8I =
      0x8D8F;
   static const GLenum RED_INTEGER =
      0x8D94;
   static const GLenum RGB_INTEGER =
      0x8D98;
   static const GLenum RGBA_INTEGER =
      0x8D99;
   static const GLenum SAMPLER_2D_ARRAY =
      0x8DC1;
   static const GLenum SAMPLER_2D_ARRAY_SHADOW =
      0x8DC4;
   static const GLenum SAMPLER_CUBE_SHADOW =
      0x8DC5;
   static const GLenum UNSIGNED_INT_VEC2 =
      0x8DC6;
   static const GLenum UNSIGNED_INT_VEC3 =
      0x8DC7;
   static const GLenum UNSIGNED_INT_VEC4 =
      0x8DC8;
   static const GLenum INT_SAMPLER_2D =
      0x8DCA;
   static const GLenum INT_SAMPLER_3D =
      0x8DCB;
   static const GLenum INT_SAMPLER_CUBE =
      0x8DCC;
   static const GLenum INT_SAMPLER_2D_ARRAY =
      0x8DCF;
   static const GLenum UNSIGNED_INT_SAMPLER_2D =
      0x8DD2;
   static const GLenum UNSIGNED_INT_SAMPLER_3D =
      0x8DD3;
   static const GLenum UNSIGNED_INT_SAMPLER_CUBE =
      0x8DD4;
   static const GLenum UNSIGNED_INT_SAMPLER_2D_ARRAY =
      0x8DD7;
   static const GLenum DEPTH_COMPONENT32F =
      0x8CAC;
   static const GLenum DEPTH32F_STENCIL8 =
      0x8CAD;
   static const GLenum FLOAT_32_UNSIGNED_INT_24_8_REV =
      0x8DAD;
   static const GLenum FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING =
      0x8210;
   static const GLenum FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE =
      0x8211;
   static const GLenum FRAMEBUFFER_ATTACHMENT_RED_SIZE =
      0x8212;
   static const GLenum FRAMEBUFFER_ATTACHMENT_GREEN_SIZE =
      0x8213;
   static const GLenum FRAMEBUFFER_ATTACHMENT_BLUE_SIZE =
      0x8214;
   static const GLenum FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE =
      0x8215;
   static const GLenum FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE =
      0x8216;
   static const GLenum FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE =
      0x8217;
   static const GLenum FRAMEBUFFER_DEFAULT =
      0x8218;
   static const GLenum UNSIGNED_INT_24_8 =
      0x84FA;
   static const GLenum DEPTH24_STENCIL8 =
      0x88F0;
   static const GLenum UNSIGNED_NORMALIZED =
      0x8C17;
   static const GLenum DRAW_FRAMEBUFFER_BINDING =
      0x8CA6;
   static const GLenum READ_FRAMEBUFFER =
      0x8CA8;
   static const GLenum DRAW_FRAMEBUFFER =
      0x8CA9;
   static const GLenum READ_FRAMEBUFFER_BINDING =
      0x8CAA;
   static const GLenum RENDERBUFFER_SAMPLES =
      0x8CAB;
   static const GLenum FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER =
      0x8CD4;
   static const GLenum MAX_COLOR_ATTACHMENTS =
      0x8CDF;
   static const GLenum COLOR_ATTACHMENT1 =
      0x8CE1;
   static const GLenum COLOR_ATTACHMENT2 =
      0x8CE2;
   static const GLenum COLOR_ATTACHMENT3 =
      0x8CE3;
   static const GLenum COLOR_ATTACHMENT4 =
      0x8CE4;
   static const GLenum COLOR_ATTACHMENT5 =
      0x8CE5;
   static const GLenum COLOR_ATTACHMENT6 =
      0x8CE6;
   static const GLenum COLOR_ATTACHMENT7 =
      0x8CE7;
   static const GLenum COLOR_ATTACHMENT8 =
      0x8CE8;
   static const GLenum COLOR_ATTACHMENT9 =
      0x8CE9;
   static const GLenum COLOR_ATTACHMENT10 =
      0x8CEA;
   static const GLenum COLOR_ATTACHMENT11 =
      0x8CEB;
   static const GLenum COLOR_ATTACHMENT12 =
      0x8CEC;
   static const GLenum COLOR_ATTACHMENT13 =
      0x8CED;
   static const GLenum COLOR_ATTACHMENT14 =
      0x8CEE;
   static const GLenum COLOR_ATTACHMENT15 =
      0x8CEF;
   static const GLenum FRAMEBUFFER_INCOMPLETE_MULTISAMPLE =
      0x8D56;
   static const GLenum MAX_SAMPLES =
      0x8D57;
   static const GLenum HALF_FLOAT =
      0x140B;
   static const GLenum RG =
      0x8227;
   static const GLenum RG_INTEGER =
      0x8228;
   static const GLenum R8 =
      0x8229;
   static const GLenum RG8 =
      0x822B;
   static const GLenum R16F =
      0x822D;
   static const GLenum R32F =
      0x822E;
   static const GLenum RG16F =
      0x822F;
   static const GLenum RG32F =
      0x8230;
   static const GLenum R8I =
      0x8231;
   static const GLenum R8UI =
      0x8232;
   static const GLenum R16I =
      0x8233;
   static const GLenum R16UI =
      0x8234;
   static const GLenum R32I =
      0x8235;
   static const GLenum R32UI =
      0x8236;
   static const GLenum RG8I =
      0x8237;
   static const GLenum RG8UI =
      0x8238;
   static const GLenum RG16I =
      0x8239;
   static const GLenum RG16UI =
      0x823A;
   static const GLenum RG32I =
      0x823B;
   static const GLenum RG32UI =
      0x823C;
   static const GLenum VERTEX_ARRAY_BINDING =
      0x85B5;
   static const GLenum R8_SNORM =
      0x8F94;
   static const GLenum RG8_SNORM =
      0x8F95;
   static const GLenum RGB8_SNORM =
      0x8F96;
   static const GLenum RGBA8_SNORM =
      0x8F97;
   static const GLenum SIGNED_NORMALIZED =
      0x8F9C;
   static const GLenum COPY_READ_BUFFER =
      0x8F36;
   static const GLenum COPY_WRITE_BUFFER =
      0x8F37;
   static const GLenum COPY_READ_BUFFER_BINDING =
      0x8F36;
   static const GLenum COPY_WRITE_BUFFER_BINDING =
      0x8F37;
   static const GLenum UNIFORM_BUFFER =
      0x8A11;
   static const GLenum UNIFORM_BUFFER_BINDING =
      0x8A28;
   static const GLenum UNIFORM_BUFFER_START =
      0x8A29;
   static const GLenum UNIFORM_BUFFER_SIZE =
      0x8A2A;
   static const GLenum MAX_VERTEX_UNIFORM_BLOCKS =
      0x8A2B;
   static const GLenum MAX_FRAGMENT_UNIFORM_BLOCKS =
      0x8A2D;
   static const GLenum MAX_COMBINED_UNIFORM_BLOCKS =
      0x8A2E;
   static const GLenum MAX_UNIFORM_BUFFER_BINDINGS =
      0x8A2F;
   static const GLenum MAX_UNIFORM_BLOCK_SIZE =
      0x8A30;
   static const GLenum MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS =
      0x8A31;
   static const GLenum MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS =
      0x8A33;
   static const GLenum UNIFORM_BUFFER_OFFSET_ALIGNMENT =
      0x8A34;
   static const GLenum ACTIVE_UNIFORM_BLOCKS =
      0x8A36;
   static const GLenum UNIFORM_TYPE =
      0x8A37;
   static const GLenum UNIFORM_SIZE =
      0x8A38;
   static const GLenum UNIFORM_BLOCK_INDEX =
      0x8A3A;
   static const GLenum UNIFORM_OFFSET =
      0x8A3B;
   static const GLenum UNIFORM_ARRAY_STRIDE =
      0x8A3C;
   static const GLenum UNIFORM_MATRIX_STRIDE =
      0x8A3D;
   static const GLenum UNIFORM_IS_ROW_MAJOR =
      0x8A3E;
   static const GLenum UNIFORM_BLOCK_BINDING =
      0x8A3F;
   static const GLenum UNIFORM_BLOCK_DATA_SIZE =
      0x8A40;
   static const GLenum UNIFORM_BLOCK_ACTIVE_UNIFORMS =
      0x8A42;
   static const GLenum UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES =
      0x8A43;
   static const GLenum UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER =
      0x8A44;
   static const GLenum UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER =
      0x8A46;
   static const GLenum INVALID_INDEX =
      0xFFFFFFFF;
   static const GLenum MAX_VERTEX_OUTPUT_COMPONENTS =
      0x9122;
   static const GLenum MAX_FRAGMENT_INPUT_COMPONENTS =
      0x9125;
   static const GLenum MAX_SERVER_WAIT_TIMEOUT =
      0x9111;
   static const GLenum OBJECT_TYPE =
      0x9112;
   static const GLenum SYNC_CONDITION =
      0x9113;
   static const GLenum SYNC_STATUS =
      0x9114;
   static const GLenum SYNC_FLAGS =
      0x9115;
   static const GLenum SYNC_FENCE =
      0x9116;
   static const GLenum SYNC_GPU_COMMANDS_COMPLETE =
      0x9117;
   static const GLenum UNSIGNALED =
      0x9118;
   static const GLenum SIGNALED =
      0x9119;
   static const GLenum ALREADY_SIGNALED =
      0x911A;
   static const GLenum TIMEOUT_EXPIRED =
      0x911B;
   static const GLenum CONDITION_SATISFIED =
      0x911C;
   static const GLenum WAIT_FAILED =
      0x911D;
   static const GLenum SYNC_FLUSH_COMMANDS_BIT =
      0x00000001;
   static const GLenum VERTEX_ATTRIB_ARRAY_DIVISOR =
      0x88FE;
   static const GLenum ANY_SAMPLES_PASSED =
      0x8C2F;
   static const GLenum ANY_SAMPLES_PASSED_CONSERVATIVE =
      0x8D6A;
   static const GLenum SAMPLER_BINDING =
      0x8919;
   static const GLenum RGB10_A2UI =
      0x906F;
   static const GLenum INT_2_10_10_10_REV =
      0x8D9F;
   static const GLenum TRANSFORM_FEEDBACK =
      0x8E22;
   static const GLenum TRANSFORM_FEEDBACK_PAUSED =
      0x8E23;
   static const GLenum TRANSFORM_FEEDBACK_ACTIVE =
      0x8E24;
   static const GLenum TRANSFORM_FEEDBACK_BINDING =
      0x8E25;
   static const GLenum TEXTURE_IMMUTABLE_FORMAT =
      0x912F;
   static const GLenum MAX_ELEMENT_INDEX =
      0x8D6B;
   static const GLenum TEXTURE_IMMUTABLE_LEVELS =
      0x82DF;
   static const GLint64 TIMEOUT_IGNORED =
      -1;
   static const GLenum MAX_CLIENT_WAIT_TIMEOUT_WEBGL =
      0x9247;
  void copyBufferSubData(GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size);
  void getBufferSubData(GLenum target, GLintptr srcByteOffset, ArrayBufferView dstBuffer, [int? dstOffset, GLuint? length]);
  void blitFramebuffer(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
  void framebufferTextureLayer(GLenum target, GLenum attachment, WebGLTexture? texture, GLint level, GLint layer);
  void invalidateFramebuffer(GLenum target, List<GLenum> attachments);
  void invalidateSubFramebuffer(GLenum target, List<GLenum> attachments, GLint x, GLint y, GLsizei width, GLsizei height);
  void readBuffer(GLenum src);
  Object getInternalformatParameter(GLenum target, GLenum internalformat, GLenum pname);
  void renderbufferStorageMultisample(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
  void texStorage2D(GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
  void texStorage3D(GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
  void texImage3D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void texSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, ArrayBufferView? srcData, [int? srcOffset]);
  void copyTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
  void compressedTexImage3D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void compressedTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  GLint getFragDataLocation(WebGLProgram program, String name);
  void uniform1ui(WebGLUniformLocation? location, GLuint v0);
  void uniform2ui(WebGLUniformLocation? location, GLuint v0, GLuint v1);
  void uniform3ui(WebGLUniformLocation? location, GLuint v0, GLuint v1, GLuint v2);
  void uniform4ui(WebGLUniformLocation? location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
  void uniform1uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4uiv(WebGLUniformLocation? location, Uint32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3x2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4x2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2x3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4x3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2x4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3x4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void vertexAttribI4i(GLuint index, GLint x, GLint y, GLint z, GLint w);
  void vertexAttribI4iv(GLuint index, Int32List values);
  void vertexAttribI4ui(GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
  void vertexAttribI4uiv(GLuint index, Uint32List values);
  void vertexAttribIPointer(GLuint index, GLint size, GLenum type, GLsizei stride, GLintptr offset);
  void vertexAttribDivisor(GLuint index, GLuint divisor);
  void drawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei instanceCount);
  void drawElementsInstanced(GLenum mode, GLsizei count, GLenum type, GLintptr offset, GLsizei instanceCount);
  void drawRangeElements(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLintptr offset);
  void drawBuffers(List<GLenum> buffers);
  void clearBufferfv(GLenum buffer, GLint drawbuffer, Float32List values, [int? srcOffset]);
  void clearBufferiv(GLenum buffer, GLint drawbuffer, Int32List values, [int? srcOffset]);
  void clearBufferuiv(GLenum buffer, GLint drawbuffer, Uint32List values, [int? srcOffset]);
  void clearBufferfi(GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);
  WebGLQuery createQuery();
  void deleteQuery(WebGLQuery? query);
  GLboolean isQuery(WebGLQuery? query);
  void beginQuery(GLenum target, WebGLQuery query);
  void endQuery(GLenum target);
  WebGLQuery? getQuery(GLenum target, GLenum pname);
  Object getQueryParameter(WebGLQuery query, GLenum pname);
  WebGLSampler createSampler();
  void deleteSampler(WebGLSampler? sampler);
  GLboolean isSampler(WebGLSampler? sampler);
  void bindSampler(GLuint unit, WebGLSampler? sampler);
  void samplerParameteri(WebGLSampler sampler, GLenum pname, GLint param);
  void samplerParameterf(WebGLSampler sampler, GLenum pname, GLfloat param);
  Object getSamplerParameter(WebGLSampler sampler, GLenum pname);
  WebGLSync? fenceSync(GLenum condition, GLbitfield flags);
  GLboolean isSync(WebGLSync? sync_);
  void deleteSync(WebGLSync? sync_);
  GLenum clientWaitSync(WebGLSync sync_, GLbitfield flags, GLuint64 timeout);
  void waitSync(WebGLSync sync_, GLbitfield flags, GLint64 timeout);
  Object getSyncParameter(WebGLSync sync_, GLenum pname);
  WebGLTransformFeedback createTransformFeedback();
  void deleteTransformFeedback(WebGLTransformFeedback? tf);
  GLboolean isTransformFeedback(WebGLTransformFeedback? tf);
  void bindTransformFeedback(GLenum target, WebGLTransformFeedback? tf);
  void beginTransformFeedback(GLenum primitiveMode);
  void endTransformFeedback();
  void transformFeedbackVaryings(WebGLProgram program, List<String> varyings, GLenum bufferMode);
  WebGLActiveInfo? getTransformFeedbackVarying(WebGLProgram program, GLuint index);
  void pauseTransformFeedback();
  void resumeTransformFeedback();
  void bindBufferBase(GLenum target, GLuint index, WebGLBuffer? buffer);
  void bindBufferRange(GLenum target, GLuint index, WebGLBuffer? buffer, GLintptr offset, GLsizeiptr size);
  Object getIndexedParameter(GLenum target, GLuint index);
  List<GLuint>? getUniformIndices(WebGLProgram program, List<String> uniformNames);
  Object getActiveUniforms(WebGLProgram program, List<GLuint> uniformIndices, GLenum pname);
  GLuint getUniformBlockIndex(WebGLProgram program, String uniformBlockName);
  Object getActiveUniformBlockParameter(WebGLProgram program, GLuint uniformBlockIndex, GLenum pname);
  String? getActiveUniformBlockName(WebGLProgram program, GLuint uniformBlockIndex);
  void uniformBlockBinding(WebGLProgram program, GLuint uniformBlockIndex, GLuint uniformBlockBinding);
  WebGLVertexArrayObject createVertexArray();
  void deleteVertexArray(WebGLVertexArrayObject? vertexArray);
  GLboolean isVertexArray(WebGLVertexArrayObject? vertexArray);
  void bindVertexArray(WebGLVertexArrayObject? array);
}

abstract interface class WebGL2RenderingContextOverloads {
  void bufferData(GLenum target, ArrayBufferView srcData, GLenum usage, int srcOffset, [GLuint? length]);
  void bufferSubData(GLenum target, GLintptr dstByteOffset, ArrayBufferView srcData, int srcOffset, [GLuint? length]);
  void texImage2D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void texSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, ArrayBufferView srcData, int srcOffset);
  void compressedTexImage2D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void compressedTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, ArrayBufferView srcData, [int? srcOffset, GLuint? srcLengthOverride]);
  void uniform1fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4fv(WebGLUniformLocation? location, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform1iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform2iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform3iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniform4iv(WebGLUniformLocation? location, Int32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix2fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix3fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void uniformMatrix4fv(WebGLUniformLocation? location, GLboolean transpose, Float32List data, [int? srcOffset, GLuint? srcLength]);
  void readPixels(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, ArrayBufferView dstData, int dstOffset);
}

abstract interface class WebGLQuery {
}

abstract interface class WebGLSampler {
}

abstract interface class WebGLSync {
}

abstract interface class WebGLTransformFeedback {
}

abstract interface class WebGLVertexArrayObject {
}

