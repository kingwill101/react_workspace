// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webgl2
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgl1.dart';
import 'html.dart';
import 'webidl.dart';

typedef GLint64 = int;

typedef GLuint64 = int;

typedef Uint32List = Object;

abstract interface class WebGL2RenderingContext {
   static const GLenum depthBufferBit =
      0x00000100;
   static const GLenum stencilBufferBit =
      0x00000400;
   static const GLenum colorBufferBit =
      0x00004000;
   static const GLenum points =
      0x0000;
   static const GLenum lines =
      0x0001;
   static const GLenum lineLoop =
      0x0002;
   static const GLenum lineStrip =
      0x0003;
   static const GLenum triangles =
      0x0004;
   static const GLenum triangleStrip =
      0x0005;
   static const GLenum triangleFan =
      0x0006;
   static const GLenum zero =
      0;
   static const GLenum one =
      1;
   static const GLenum srcColor =
      0x0300;
   static const GLenum oneMinusSrcColor =
      0x0301;
   static const GLenum srcAlpha =
      0x0302;
   static const GLenum oneMinusSrcAlpha =
      0x0303;
   static const GLenum dstAlpha =
      0x0304;
   static const GLenum oneMinusDstAlpha =
      0x0305;
   static const GLenum dstColor =
      0x0306;
   static const GLenum oneMinusDstColor =
      0x0307;
   static const GLenum srcAlphaSaturate =
      0x0308;
   static const GLenum funcAdd =
      0x8006;
   static const GLenum blendEquation =
      0x8009;
   static const GLenum blendEquationRgb =
      0x8009;
   static const GLenum blendEquationAlpha =
      0x883D;
   static const GLenum funcSubtract =
      0x800A;
   static const GLenum funcReverseSubtract =
      0x800B;
   static const GLenum blendDstRgb =
      0x80C8;
   static const GLenum blendSrcRgb =
      0x80C9;
   static const GLenum blendDstAlpha =
      0x80CA;
   static const GLenum blendSrcAlpha =
      0x80CB;
   static const GLenum constantColor =
      0x8001;
   static const GLenum oneMinusConstantColor =
      0x8002;
   static const GLenum constantAlpha =
      0x8003;
   static const GLenum oneMinusConstantAlpha =
      0x8004;
   static const GLenum blendColor =
      0x8005;
   static const GLenum arrayBuffer =
      0x8892;
   static const GLenum elementArrayBuffer =
      0x8893;
   static const GLenum arrayBufferBinding =
      0x8894;
   static const GLenum elementArrayBufferBinding =
      0x8895;
   static const GLenum streamDraw =
      0x88E0;
   static const GLenum staticDraw =
      0x88E4;
   static const GLenum dynamicDraw =
      0x88E8;
   static const GLenum bufferSize =
      0x8764;
   static const GLenum bufferUsage =
      0x8765;
   static const GLenum currentVertexAttrib =
      0x8626;
   static const GLenum front =
      0x0404;
   static const GLenum back =
      0x0405;
   static const GLenum frontAndBack =
      0x0408;
   static const GLenum cullFace =
      0x0B44;
   static const GLenum blend =
      0x0BE2;
   static const GLenum dither =
      0x0BD0;
   static const GLenum stencilTest =
      0x0B90;
   static const GLenum depthTest =
      0x0B71;
   static const GLenum scissorTest =
      0x0C11;
   static const GLenum polygonOffsetFill =
      0x8037;
   static const GLenum sampleAlphaToCoverage =
      0x809E;
   static const GLenum sampleCoverage =
      0x80A0;
   static const GLenum noError =
      0;
   static const GLenum invalidEnum =
      0x0500;
   static const GLenum invalidValue =
      0x0501;
   static const GLenum invalidOperation =
      0x0502;
   static const GLenum outOfMemory =
      0x0505;
   static const GLenum cw =
      0x0900;
   static const GLenum ccw =
      0x0901;
   static const GLenum lineWidth =
      0x0B21;
   static const GLenum aliasedPointSizeRange =
      0x846D;
   static const GLenum aliasedLineWidthRange =
      0x846E;
   static const GLenum cullFaceMode =
      0x0B45;
   static const GLenum frontFace =
      0x0B46;
   static const GLenum depthRange =
      0x0B70;
   static const GLenum depthWritemask =
      0x0B72;
   static const GLenum depthClearValue =
      0x0B73;
   static const GLenum depthFunc =
      0x0B74;
   static const GLenum stencilClearValue =
      0x0B91;
   static const GLenum stencilFunc =
      0x0B92;
   static const GLenum stencilFail =
      0x0B94;
   static const GLenum stencilPassDepthFail =
      0x0B95;
   static const GLenum stencilPassDepthPass =
      0x0B96;
   static const GLenum stencilRef =
      0x0B97;
   static const GLenum stencilValueMask =
      0x0B93;
   static const GLenum stencilWritemask =
      0x0B98;
   static const GLenum stencilBackFunc =
      0x8800;
   static const GLenum stencilBackFail =
      0x8801;
   static const GLenum stencilBackPassDepthFail =
      0x8802;
   static const GLenum stencilBackPassDepthPass =
      0x8803;
   static const GLenum stencilBackRef =
      0x8CA3;
   static const GLenum stencilBackValueMask =
      0x8CA4;
   static const GLenum stencilBackWritemask =
      0x8CA5;
   static const GLenum viewport =
      0x0BA2;
   static const GLenum scissorBox =
      0x0C10;
   static const GLenum colorClearValue =
      0x0C22;
   static const GLenum colorWritemask =
      0x0C23;
   static const GLenum unpackAlignment =
      0x0CF5;
   static const GLenum packAlignment =
      0x0D05;
   static const GLenum maxTextureSize =
      0x0D33;
   static const GLenum maxViewportDims =
      0x0D3A;
   static const GLenum subpixelBits =
      0x0D50;
   static const GLenum redBits =
      0x0D52;
   static const GLenum greenBits =
      0x0D53;
   static const GLenum blueBits =
      0x0D54;
   static const GLenum alphaBits =
      0x0D55;
   static const GLenum depthBits =
      0x0D56;
   static const GLenum stencilBits =
      0x0D57;
   static const GLenum polygonOffsetUnits =
      0x2A00;
   static const GLenum polygonOffsetFactor =
      0x8038;
   static const GLenum textureBinding2d =
      0x8069;
   static const GLenum sampleBuffers =
      0x80A8;
   static const GLenum samples =
      0x80A9;
   static const GLenum sampleCoverageValue =
      0x80AA;
   static const GLenum sampleCoverageInvert =
      0x80AB;
   static const GLenum compressedTextureFormats =
      0x86A3;
   static const GLenum dontCare =
      0x1100;
   static const GLenum fastest =
      0x1101;
   static const GLenum nicest =
      0x1102;
   static const GLenum generateMipmapHint =
      0x8192;
   static const GLenum byte =
      0x1400;
   static const GLenum unsignedByte =
      0x1401;
   static const GLenum short =
      0x1402;
   static const GLenum unsignedShort =
      0x1403;
   static const GLenum int =
      0x1404;
   static const GLenum unsignedInt =
      0x1405;
   static const GLenum float =
      0x1406;
   static const GLenum depthComponent =
      0x1902;
   static const GLenum alpha =
      0x1906;
   static const GLenum rgb =
      0x1907;
   static const GLenum rgba =
      0x1908;
   static const GLenum luminance =
      0x1909;
   static const GLenum luminanceAlpha =
      0x190A;
   static const GLenum unsignedShort4444 =
      0x8033;
   static const GLenum unsignedShort5551 =
      0x8034;
   static const GLenum unsignedShort565 =
      0x8363;
   static const GLenum fragmentShader =
      0x8B30;
   static const GLenum vertexShader =
      0x8B31;
   static const GLenum maxVertexAttribs =
      0x8869;
   static const GLenum maxVertexUniformVectors =
      0x8DFB;
   static const GLenum maxVaryingVectors =
      0x8DFC;
   static const GLenum maxCombinedTextureImageUnits =
      0x8B4D;
   static const GLenum maxVertexTextureImageUnits =
      0x8B4C;
   static const GLenum maxTextureImageUnits =
      0x8872;
   static const GLenum maxFragmentUniformVectors =
      0x8DFD;
   static const GLenum shaderType =
      0x8B4F;
   static const GLenum deleteStatus =
      0x8B80;
   static const GLenum linkStatus =
      0x8B82;
   static const GLenum validateStatus =
      0x8B83;
   static const GLenum attachedShaders =
      0x8B85;
   static const GLenum activeUniforms =
      0x8B86;
   static const GLenum activeAttributes =
      0x8B89;
   static const GLenum shadingLanguageVersion =
      0x8B8C;
   static const GLenum currentProgram =
      0x8B8D;
   static const GLenum never =
      0x0200;
   static const GLenum less =
      0x0201;
   static const GLenum equal =
      0x0202;
   static const GLenum lequal =
      0x0203;
   static const GLenum greater =
      0x0204;
   static const GLenum notequal =
      0x0205;
   static const GLenum gequal =
      0x0206;
   static const GLenum always =
      0x0207;
   static const GLenum keep =
      0x1E00;
   static const GLenum replace =
      0x1E01;
   static const GLenum incr =
      0x1E02;
   static const GLenum decr =
      0x1E03;
   static const GLenum invert =
      0x150A;
   static const GLenum incrWrap =
      0x8507;
   static const GLenum decrWrap =
      0x8508;
   static const GLenum vendor =
      0x1F00;
   static const GLenum renderer =
      0x1F01;
   static const GLenum version =
      0x1F02;
   static const GLenum nearest =
      0x2600;
   static const GLenum linear =
      0x2601;
   static const GLenum nearestMipmapNearest =
      0x2700;
   static const GLenum linearMipmapNearest =
      0x2701;
   static const GLenum nearestMipmapLinear =
      0x2702;
   static const GLenum linearMipmapLinear =
      0x2703;
   static const GLenum textureMagFilter =
      0x2800;
   static const GLenum textureMinFilter =
      0x2801;
   static const GLenum textureWrapS =
      0x2802;
   static const GLenum textureWrapT =
      0x2803;
   static const GLenum texture2d =
      0x0DE1;
   static const GLenum texture =
      0x1702;
   static const GLenum textureCubeMap =
      0x8513;
   static const GLenum textureBindingCubeMap =
      0x8514;
   static const GLenum textureCubeMapPositiveX =
      0x8515;
   static const GLenum textureCubeMapNegativeX =
      0x8516;
   static const GLenum textureCubeMapPositiveY =
      0x8517;
   static const GLenum textureCubeMapNegativeY =
      0x8518;
   static const GLenum textureCubeMapPositiveZ =
      0x8519;
   static const GLenum textureCubeMapNegativeZ =
      0x851A;
   static const GLenum maxCubeMapTextureSize =
      0x851C;
   static const GLenum texture0 =
      0x84C0;
   static const GLenum texture1 =
      0x84C1;
   static const GLenum texture2 =
      0x84C2;
   static const GLenum texture3 =
      0x84C3;
   static const GLenum texture4 =
      0x84C4;
   static const GLenum texture5 =
      0x84C5;
   static const GLenum texture6 =
      0x84C6;
   static const GLenum texture7 =
      0x84C7;
   static const GLenum texture8 =
      0x84C8;
   static const GLenum texture9 =
      0x84C9;
   static const GLenum texture10 =
      0x84CA;
   static const GLenum texture11 =
      0x84CB;
   static const GLenum texture12 =
      0x84CC;
   static const GLenum texture13 =
      0x84CD;
   static const GLenum texture14 =
      0x84CE;
   static const GLenum texture15 =
      0x84CF;
   static const GLenum texture16 =
      0x84D0;
   static const GLenum texture17 =
      0x84D1;
   static const GLenum texture18 =
      0x84D2;
   static const GLenum texture19 =
      0x84D3;
   static const GLenum texture20 =
      0x84D4;
   static const GLenum texture21 =
      0x84D5;
   static const GLenum texture22 =
      0x84D6;
   static const GLenum texture23 =
      0x84D7;
   static const GLenum texture24 =
      0x84D8;
   static const GLenum texture25 =
      0x84D9;
   static const GLenum texture26 =
      0x84DA;
   static const GLenum texture27 =
      0x84DB;
   static const GLenum texture28 =
      0x84DC;
   static const GLenum texture29 =
      0x84DD;
   static const GLenum texture30 =
      0x84DE;
   static const GLenum texture31 =
      0x84DF;
   static const GLenum activeTexture =
      0x84E0;
   static const GLenum repeat =
      0x2901;
   static const GLenum clampToEdge =
      0x812F;
   static const GLenum mirroredRepeat =
      0x8370;
   static const GLenum floatVec2 =
      0x8B50;
   static const GLenum floatVec3 =
      0x8B51;
   static const GLenum floatVec4 =
      0x8B52;
   static const GLenum intVec2 =
      0x8B53;
   static const GLenum intVec3 =
      0x8B54;
   static const GLenum intVec4 =
      0x8B55;
   static const GLenum bool =
      0x8B56;
   static const GLenum boolVec2 =
      0x8B57;
   static const GLenum boolVec3 =
      0x8B58;
   static const GLenum boolVec4 =
      0x8B59;
   static const GLenum floatMat2 =
      0x8B5A;
   static const GLenum floatMat3 =
      0x8B5B;
   static const GLenum floatMat4 =
      0x8B5C;
   static const GLenum sampler2d =
      0x8B5E;
   static const GLenum samplerCube =
      0x8B60;
   static const GLenum vertexAttribArrayEnabled =
      0x8622;
   static const GLenum vertexAttribArraySize =
      0x8623;
   static const GLenum vertexAttribArrayStride =
      0x8624;
   static const GLenum vertexAttribArrayType =
      0x8625;
   static const GLenum vertexAttribArrayNormalized =
      0x886A;
   static const GLenum vertexAttribArrayPointer =
      0x8645;
   static const GLenum vertexAttribArrayBufferBinding =
      0x889F;
   static const GLenum implementationColorReadType =
      0x8B9A;
   static const GLenum implementationColorReadFormat =
      0x8B9B;
   static const GLenum compileStatus =
      0x8B81;
   static const GLenum lowFloat =
      0x8DF0;
   static const GLenum mediumFloat =
      0x8DF1;
   static const GLenum highFloat =
      0x8DF2;
   static const GLenum lowInt =
      0x8DF3;
   static const GLenum mediumInt =
      0x8DF4;
   static const GLenum highInt =
      0x8DF5;
   static const GLenum framebuffer =
      0x8D40;
   static const GLenum renderbuffer =
      0x8D41;
   static const GLenum rgba4 =
      0x8056;
   static const GLenum rgb5A1 =
      0x8057;
   static const GLenum rgba8 =
      0x8058;
   static const GLenum rgb565 =
      0x8D62;
   static const GLenum depthComponent16 =
      0x81A5;
   static const GLenum stencilIndex8 =
      0x8D48;
   static const GLenum depthStencil =
      0x84F9;
   static const GLenum renderbufferWidth =
      0x8D42;
   static const GLenum renderbufferHeight =
      0x8D43;
   static const GLenum renderbufferInternalFormat =
      0x8D44;
   static const GLenum renderbufferRedSize =
      0x8D50;
   static const GLenum renderbufferGreenSize =
      0x8D51;
   static const GLenum renderbufferBlueSize =
      0x8D52;
   static const GLenum renderbufferAlphaSize =
      0x8D53;
   static const GLenum renderbufferDepthSize =
      0x8D54;
   static const GLenum renderbufferStencilSize =
      0x8D55;
   static const GLenum framebufferAttachmentObjectType =
      0x8CD0;
   static const GLenum framebufferAttachmentObjectName =
      0x8CD1;
   static const GLenum framebufferAttachmentTextureLevel =
      0x8CD2;
   static const GLenum framebufferAttachmentTextureCubeMapFace =
      0x8CD3;
   static const GLenum colorAttachment0 =
      0x8CE0;
   static const GLenum depthAttachment =
      0x8D00;
   static const GLenum stencilAttachment =
      0x8D20;
   static const GLenum depthStencilAttachment =
      0x821A;
   static const GLenum none =
      0;
   static const GLenum framebufferComplete =
      0x8CD5;
   static const GLenum framebufferIncompleteAttachment =
      0x8CD6;
   static const GLenum framebufferIncompleteMissingAttachment =
      0x8CD7;
   static const GLenum framebufferIncompleteDimensions =
      0x8CD9;
   static const GLenum framebufferUnsupported =
      0x8CDD;
   static const GLenum framebufferBinding =
      0x8CA6;
   static const GLenum renderbufferBinding =
      0x8CA7;
   static const GLenum maxRenderbufferSize =
      0x84E8;
   static const GLenum invalidFramebufferOperation =
      0x0506;
   static const GLenum unpackFlipYWebgl =
      0x9240;
   static const GLenum unpackPremultiplyAlphaWebgl =
      0x9241;
   static const GLenum contextLostWebgl =
      0x9242;
   static const GLenum unpackColorspaceConversionWebgl =
      0x9243;
   static const GLenum browserDefaultWebgl =
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
  WebGLBuffer? createBuffer();
  WebGLFramebuffer? createFramebuffer();
  WebGLProgram? createProgram();
  WebGLRenderbuffer? createRenderbuffer();
  WebGLShader? createShader(GLenum type);
  WebGLTexture? createTexture();
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
   static const GLenum readBuffer =
      0x0C02;
   static const GLenum unpackRowLength =
      0x0CF2;
   static const GLenum unpackSkipRows =
      0x0CF3;
   static const GLenum unpackSkipPixels =
      0x0CF4;
   static const GLenum packRowLength =
      0x0D02;
   static const GLenum packSkipRows =
      0x0D03;
   static const GLenum packSkipPixels =
      0x0D04;
   static const GLenum color =
      0x1800;
   static const GLenum depth =
      0x1801;
   static const GLenum stencil =
      0x1802;
   static const GLenum red =
      0x1903;
   static const GLenum rgb8 =
      0x8051;
   static const GLenum rgb10A2 =
      0x8059;
   static const GLenum textureBinding3d =
      0x806A;
   static const GLenum unpackSkipImages =
      0x806D;
   static const GLenum unpackImageHeight =
      0x806E;
   static const GLenum texture3d =
      0x806F;
   static const GLenum textureWrapR =
      0x8072;
   static const GLenum max3dTextureSize =
      0x8073;
   static const GLenum unsignedInt2101010Rev =
      0x8368;
   static const GLenum maxElementsVertices =
      0x80E8;
   static const GLenum maxElementsIndices =
      0x80E9;
   static const GLenum textureMinLod =
      0x813A;
   static const GLenum textureMaxLod =
      0x813B;
   static const GLenum textureBaseLevel =
      0x813C;
   static const GLenum textureMaxLevel =
      0x813D;
   static const GLenum min =
      0x8007;
   static const GLenum max =
      0x8008;
   static const GLenum depthComponent24 =
      0x81A6;
   static const GLenum maxTextureLodBias =
      0x84FD;
   static const GLenum textureCompareMode =
      0x884C;
   static const GLenum textureCompareFunc =
      0x884D;
   static const GLenum currentQuery =
      0x8865;
   static const GLenum queryResult =
      0x8866;
   static const GLenum queryResultAvailable =
      0x8867;
   static const GLenum streamRead =
      0x88E1;
   static const GLenum streamCopy =
      0x88E2;
   static const GLenum staticRead =
      0x88E5;
   static const GLenum staticCopy =
      0x88E6;
   static const GLenum dynamicRead =
      0x88E9;
   static const GLenum dynamicCopy =
      0x88EA;
   static const GLenum maxDrawBuffers =
      0x8824;
   static const GLenum drawBuffer0 =
      0x8825;
   static const GLenum drawBuffer1 =
      0x8826;
   static const GLenum drawBuffer2 =
      0x8827;
   static const GLenum drawBuffer3 =
      0x8828;
   static const GLenum drawBuffer4 =
      0x8829;
   static const GLenum drawBuffer5 =
      0x882A;
   static const GLenum drawBuffer6 =
      0x882B;
   static const GLenum drawBuffer7 =
      0x882C;
   static const GLenum drawBuffer8 =
      0x882D;
   static const GLenum drawBuffer9 =
      0x882E;
   static const GLenum drawBuffer10 =
      0x882F;
   static const GLenum drawBuffer11 =
      0x8830;
   static const GLenum drawBuffer12 =
      0x8831;
   static const GLenum drawBuffer13 =
      0x8832;
   static const GLenum drawBuffer14 =
      0x8833;
   static const GLenum drawBuffer15 =
      0x8834;
   static const GLenum maxFragmentUniformComponents =
      0x8B49;
   static const GLenum maxVertexUniformComponents =
      0x8B4A;
   static const GLenum sampler3d =
      0x8B5F;
   static const GLenum sampler2dShadow =
      0x8B62;
   static const GLenum fragmentShaderDerivativeHint =
      0x8B8B;
   static const GLenum pixelPackBuffer =
      0x88EB;
   static const GLenum pixelUnpackBuffer =
      0x88EC;
   static const GLenum pixelPackBufferBinding =
      0x88ED;
   static const GLenum pixelUnpackBufferBinding =
      0x88EF;
   static const GLenum floatMat2x3 =
      0x8B65;
   static const GLenum floatMat2x4 =
      0x8B66;
   static const GLenum floatMat3x2 =
      0x8B67;
   static const GLenum floatMat3x4 =
      0x8B68;
   static const GLenum floatMat4x2 =
      0x8B69;
   static const GLenum floatMat4x3 =
      0x8B6A;
   static const GLenum srgb =
      0x8C40;
   static const GLenum srgb8 =
      0x8C41;
   static const GLenum srgb8Alpha8 =
      0x8C43;
   static const GLenum compareRefToTexture =
      0x884E;
   static const GLenum rgba32f =
      0x8814;
   static const GLenum rgb32f =
      0x8815;
   static const GLenum rgba16f =
      0x881A;
   static const GLenum rgb16f =
      0x881B;
   static const GLenum vertexAttribArrayInteger =
      0x88FD;
   static const GLenum maxArrayTextureLayers =
      0x88FF;
   static const GLenum minProgramTexelOffset =
      0x8904;
   static const GLenum maxProgramTexelOffset =
      0x8905;
   static const GLenum maxVaryingComponents =
      0x8B4B;
   static const GLenum texture2dArray =
      0x8C1A;
   static const GLenum textureBinding2dArray =
      0x8C1D;
   static const GLenum r11fG11fB10f =
      0x8C3A;
   static const GLenum unsignedInt10f11f11fRev =
      0x8C3B;
   static const GLenum rgb9E5 =
      0x8C3D;
   static const GLenum unsignedInt5999Rev =
      0x8C3E;
   static const GLenum transformFeedbackBufferMode =
      0x8C7F;
   static const GLenum maxTransformFeedbackSeparateComponents =
      0x8C80;
   static const GLenum transformFeedbackVaryings =
      0x8C83;
   static const GLenum transformFeedbackBufferStart =
      0x8C84;
   static const GLenum transformFeedbackBufferSize =
      0x8C85;
   static const GLenum transformFeedbackPrimitivesWritten =
      0x8C88;
   static const GLenum rasterizerDiscard =
      0x8C89;
   static const GLenum maxTransformFeedbackInterleavedComponents =
      0x8C8A;
   static const GLenum maxTransformFeedbackSeparateAttribs =
      0x8C8B;
   static const GLenum interleavedAttribs =
      0x8C8C;
   static const GLenum separateAttribs =
      0x8C8D;
   static const GLenum transformFeedbackBuffer =
      0x8C8E;
   static const GLenum transformFeedbackBufferBinding =
      0x8C8F;
   static const GLenum rgba32ui =
      0x8D70;
   static const GLenum rgb32ui =
      0x8D71;
   static const GLenum rgba16ui =
      0x8D76;
   static const GLenum rgb16ui =
      0x8D77;
   static const GLenum rgba8ui =
      0x8D7C;
   static const GLenum rgb8ui =
      0x8D7D;
   static const GLenum rgba32i =
      0x8D82;
   static const GLenum rgb32i =
      0x8D83;
   static const GLenum rgba16i =
      0x8D88;
   static const GLenum rgb16i =
      0x8D89;
   static const GLenum rgba8i =
      0x8D8E;
   static const GLenum rgb8i =
      0x8D8F;
   static const GLenum redInteger =
      0x8D94;
   static const GLenum rgbInteger =
      0x8D98;
   static const GLenum rgbaInteger =
      0x8D99;
   static const GLenum sampler2dArray =
      0x8DC1;
   static const GLenum sampler2dArrayShadow =
      0x8DC4;
   static const GLenum samplerCubeShadow =
      0x8DC5;
   static const GLenum unsignedIntVec2 =
      0x8DC6;
   static const GLenum unsignedIntVec3 =
      0x8DC7;
   static const GLenum unsignedIntVec4 =
      0x8DC8;
   static const GLenum intSampler2d =
      0x8DCA;
   static const GLenum intSampler3d =
      0x8DCB;
   static const GLenum intSamplerCube =
      0x8DCC;
   static const GLenum intSampler2dArray =
      0x8DCF;
   static const GLenum unsignedIntSampler2d =
      0x8DD2;
   static const GLenum unsignedIntSampler3d =
      0x8DD3;
   static const GLenum unsignedIntSamplerCube =
      0x8DD4;
   static const GLenum unsignedIntSampler2dArray =
      0x8DD7;
   static const GLenum depthComponent32f =
      0x8CAC;
   static const GLenum depth32fStencil8 =
      0x8CAD;
   static const GLenum float32UnsignedInt248Rev =
      0x8DAD;
   static const GLenum framebufferAttachmentColorEncoding =
      0x8210;
   static const GLenum framebufferAttachmentComponentType =
      0x8211;
   static const GLenum framebufferAttachmentRedSize =
      0x8212;
   static const GLenum framebufferAttachmentGreenSize =
      0x8213;
   static const GLenum framebufferAttachmentBlueSize =
      0x8214;
   static const GLenum framebufferAttachmentAlphaSize =
      0x8215;
   static const GLenum framebufferAttachmentDepthSize =
      0x8216;
   static const GLenum framebufferAttachmentStencilSize =
      0x8217;
   static const GLenum framebufferDefault =
      0x8218;
   static const GLenum unsignedInt248 =
      0x84FA;
   static const GLenum depth24Stencil8 =
      0x88F0;
   static const GLenum unsignedNormalized =
      0x8C17;
   static const GLenum drawFramebufferBinding =
      0x8CA6;
   static const GLenum readFramebuffer =
      0x8CA8;
   static const GLenum drawFramebuffer =
      0x8CA9;
   static const GLenum readFramebufferBinding =
      0x8CAA;
   static const GLenum renderbufferSamples =
      0x8CAB;
   static const GLenum framebufferAttachmentTextureLayer =
      0x8CD4;
   static const GLenum maxColorAttachments =
      0x8CDF;
   static const GLenum colorAttachment1 =
      0x8CE1;
   static const GLenum colorAttachment2 =
      0x8CE2;
   static const GLenum colorAttachment3 =
      0x8CE3;
   static const GLenum colorAttachment4 =
      0x8CE4;
   static const GLenum colorAttachment5 =
      0x8CE5;
   static const GLenum colorAttachment6 =
      0x8CE6;
   static const GLenum colorAttachment7 =
      0x8CE7;
   static const GLenum colorAttachment8 =
      0x8CE8;
   static const GLenum colorAttachment9 =
      0x8CE9;
   static const GLenum colorAttachment10 =
      0x8CEA;
   static const GLenum colorAttachment11 =
      0x8CEB;
   static const GLenum colorAttachment12 =
      0x8CEC;
   static const GLenum colorAttachment13 =
      0x8CED;
   static const GLenum colorAttachment14 =
      0x8CEE;
   static const GLenum colorAttachment15 =
      0x8CEF;
   static const GLenum framebufferIncompleteMultisample =
      0x8D56;
   static const GLenum maxSamples =
      0x8D57;
   static const GLenum halfFloat =
      0x140B;
   static const GLenum rg =
      0x8227;
   static const GLenum rgInteger =
      0x8228;
   static const GLenum r8 =
      0x8229;
   static const GLenum rg8 =
      0x822B;
   static const GLenum r16f =
      0x822D;
   static const GLenum r32f =
      0x822E;
   static const GLenum rg16f =
      0x822F;
   static const GLenum rg32f =
      0x8230;
   static const GLenum r8i =
      0x8231;
   static const GLenum r8ui =
      0x8232;
   static const GLenum r16i =
      0x8233;
   static const GLenum r16ui =
      0x8234;
   static const GLenum r32i =
      0x8235;
   static const GLenum r32ui =
      0x8236;
   static const GLenum rg8i =
      0x8237;
   static const GLenum rg8ui =
      0x8238;
   static const GLenum rg16i =
      0x8239;
   static const GLenum rg16ui =
      0x823A;
   static const GLenum rg32i =
      0x823B;
   static const GLenum rg32ui =
      0x823C;
   static const GLenum vertexArrayBinding =
      0x85B5;
   static const GLenum r8Snorm =
      0x8F94;
   static const GLenum rg8Snorm =
      0x8F95;
   static const GLenum rgb8Snorm =
      0x8F96;
   static const GLenum rgba8Snorm =
      0x8F97;
   static const GLenum signedNormalized =
      0x8F9C;
   static const GLenum copyReadBuffer =
      0x8F36;
   static const GLenum copyWriteBuffer =
      0x8F37;
   static const GLenum copyReadBufferBinding =
      0x8F36;
   static const GLenum copyWriteBufferBinding =
      0x8F37;
   static const GLenum uniformBuffer =
      0x8A11;
   static const GLenum uniformBufferBinding =
      0x8A28;
   static const GLenum uniformBufferStart =
      0x8A29;
   static const GLenum uniformBufferSize =
      0x8A2A;
   static const GLenum maxVertexUniformBlocks =
      0x8A2B;
   static const GLenum maxFragmentUniformBlocks =
      0x8A2D;
   static const GLenum maxCombinedUniformBlocks =
      0x8A2E;
   static const GLenum maxUniformBufferBindings =
      0x8A2F;
   static const GLenum maxUniformBlockSize =
      0x8A30;
   static const GLenum maxCombinedVertexUniformComponents =
      0x8A31;
   static const GLenum maxCombinedFragmentUniformComponents =
      0x8A33;
   static const GLenum uniformBufferOffsetAlignment =
      0x8A34;
   static const GLenum activeUniformBlocks =
      0x8A36;
   static const GLenum uniformType =
      0x8A37;
   static const GLenum uniformSize =
      0x8A38;
   static const GLenum uniformBlockIndex =
      0x8A3A;
   static const GLenum uniformOffset =
      0x8A3B;
   static const GLenum uniformArrayStride =
      0x8A3C;
   static const GLenum uniformMatrixStride =
      0x8A3D;
   static const GLenum uniformIsRowMajor =
      0x8A3E;
   static const GLenum uniformBlockBinding =
      0x8A3F;
   static const GLenum uniformBlockDataSize =
      0x8A40;
   static const GLenum uniformBlockActiveUniforms =
      0x8A42;
   static const GLenum uniformBlockActiveUniformIndices =
      0x8A43;
   static const GLenum uniformBlockReferencedByVertexShader =
      0x8A44;
   static const GLenum uniformBlockReferencedByFragmentShader =
      0x8A46;
   static const GLenum invalidIndex =
      0xFFFFFFFF;
   static const GLenum maxVertexOutputComponents =
      0x9122;
   static const GLenum maxFragmentInputComponents =
      0x9125;
   static const GLenum maxServerWaitTimeout =
      0x9111;
   static const GLenum objectType =
      0x9112;
   static const GLenum syncCondition =
      0x9113;
   static const GLenum syncStatus =
      0x9114;
   static const GLenum syncFlags =
      0x9115;
   static const GLenum syncFence =
      0x9116;
   static const GLenum syncGpuCommandsComplete =
      0x9117;
   static const GLenum unsignaled =
      0x9118;
   static const GLenum signaled =
      0x9119;
   static const GLenum alreadySignaled =
      0x911A;
   static const GLenum timeoutExpired =
      0x911B;
   static const GLenum conditionSatisfied =
      0x911C;
   static const GLenum waitFailed =
      0x911D;
   static const GLenum syncFlushCommandsBit =
      0x00000001;
   static const GLenum vertexAttribArrayDivisor =
      0x88FE;
   static const GLenum anySamplesPassed =
      0x8C2F;
   static const GLenum anySamplesPassedConservative =
      0x8D6A;
   static const GLenum samplerBinding =
      0x8919;
   static const GLenum rgb10A2ui =
      0x906F;
   static const GLenum int2101010Rev =
      0x8D9F;
   static const GLenum transformFeedback =
      0x8E22;
   static const GLenum transformFeedbackPaused =
      0x8E23;
   static const GLenum transformFeedbackActive =
      0x8E24;
   static const GLenum transformFeedbackBinding =
      0x8E25;
   static const GLenum textureImmutableFormat =
      0x912F;
   static const GLenum maxElementIndex =
      0x8D6B;
   static const GLenum textureImmutableLevels =
      0x82DF;
   static const GLint64 timeoutIgnored =
      -1;
   static const GLenum maxClientWaitTimeoutWebgl =
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
  WebGLQuery? createQuery();
  void deleteQuery(WebGLQuery? query);
  GLboolean isQuery(WebGLQuery? query);
  void beginQuery(GLenum target, WebGLQuery query);
  void endQuery(GLenum target);
  WebGLQuery? getQuery(GLenum target, GLenum pname);
  Object getQueryParameter(WebGLQuery query, GLenum pname);
  WebGLSampler? createSampler();
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
  WebGLTransformFeedback? createTransformFeedback();
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
  WebGLVertexArrayObject? createVertexArray();
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
   static const GLenum readBuffer =
      0x0C02;
   static const GLenum unpackRowLength =
      0x0CF2;
   static const GLenum unpackSkipRows =
      0x0CF3;
   static const GLenum unpackSkipPixels =
      0x0CF4;
   static const GLenum packRowLength =
      0x0D02;
   static const GLenum packSkipRows =
      0x0D03;
   static const GLenum packSkipPixels =
      0x0D04;
   static const GLenum color =
      0x1800;
   static const GLenum depth =
      0x1801;
   static const GLenum stencil =
      0x1802;
   static const GLenum red =
      0x1903;
   static const GLenum rgb8 =
      0x8051;
   static const GLenum rgb10A2 =
      0x8059;
   static const GLenum textureBinding3d =
      0x806A;
   static const GLenum unpackSkipImages =
      0x806D;
   static const GLenum unpackImageHeight =
      0x806E;
   static const GLenum texture3d =
      0x806F;
   static const GLenum textureWrapR =
      0x8072;
   static const GLenum max3dTextureSize =
      0x8073;
   static const GLenum unsignedInt2101010Rev =
      0x8368;
   static const GLenum maxElementsVertices =
      0x80E8;
   static const GLenum maxElementsIndices =
      0x80E9;
   static const GLenum textureMinLod =
      0x813A;
   static const GLenum textureMaxLod =
      0x813B;
   static const GLenum textureBaseLevel =
      0x813C;
   static const GLenum textureMaxLevel =
      0x813D;
   static const GLenum min =
      0x8007;
   static const GLenum max =
      0x8008;
   static const GLenum depthComponent24 =
      0x81A6;
   static const GLenum maxTextureLodBias =
      0x84FD;
   static const GLenum textureCompareMode =
      0x884C;
   static const GLenum textureCompareFunc =
      0x884D;
   static const GLenum currentQuery =
      0x8865;
   static const GLenum queryResult =
      0x8866;
   static const GLenum queryResultAvailable =
      0x8867;
   static const GLenum streamRead =
      0x88E1;
   static const GLenum streamCopy =
      0x88E2;
   static const GLenum staticRead =
      0x88E5;
   static const GLenum staticCopy =
      0x88E6;
   static const GLenum dynamicRead =
      0x88E9;
   static const GLenum dynamicCopy =
      0x88EA;
   static const GLenum maxDrawBuffers =
      0x8824;
   static const GLenum drawBuffer0 =
      0x8825;
   static const GLenum drawBuffer1 =
      0x8826;
   static const GLenum drawBuffer2 =
      0x8827;
   static const GLenum drawBuffer3 =
      0x8828;
   static const GLenum drawBuffer4 =
      0x8829;
   static const GLenum drawBuffer5 =
      0x882A;
   static const GLenum drawBuffer6 =
      0x882B;
   static const GLenum drawBuffer7 =
      0x882C;
   static const GLenum drawBuffer8 =
      0x882D;
   static const GLenum drawBuffer9 =
      0x882E;
   static const GLenum drawBuffer10 =
      0x882F;
   static const GLenum drawBuffer11 =
      0x8830;
   static const GLenum drawBuffer12 =
      0x8831;
   static const GLenum drawBuffer13 =
      0x8832;
   static const GLenum drawBuffer14 =
      0x8833;
   static const GLenum drawBuffer15 =
      0x8834;
   static const GLenum maxFragmentUniformComponents =
      0x8B49;
   static const GLenum maxVertexUniformComponents =
      0x8B4A;
   static const GLenum sampler3d =
      0x8B5F;
   static const GLenum sampler2dShadow =
      0x8B62;
   static const GLenum fragmentShaderDerivativeHint =
      0x8B8B;
   static const GLenum pixelPackBuffer =
      0x88EB;
   static const GLenum pixelUnpackBuffer =
      0x88EC;
   static const GLenum pixelPackBufferBinding =
      0x88ED;
   static const GLenum pixelUnpackBufferBinding =
      0x88EF;
   static const GLenum floatMat2x3 =
      0x8B65;
   static const GLenum floatMat2x4 =
      0x8B66;
   static const GLenum floatMat3x2 =
      0x8B67;
   static const GLenum floatMat3x4 =
      0x8B68;
   static const GLenum floatMat4x2 =
      0x8B69;
   static const GLenum floatMat4x3 =
      0x8B6A;
   static const GLenum srgb =
      0x8C40;
   static const GLenum srgb8 =
      0x8C41;
   static const GLenum srgb8Alpha8 =
      0x8C43;
   static const GLenum compareRefToTexture =
      0x884E;
   static const GLenum rgba32f =
      0x8814;
   static const GLenum rgb32f =
      0x8815;
   static const GLenum rgba16f =
      0x881A;
   static const GLenum rgb16f =
      0x881B;
   static const GLenum vertexAttribArrayInteger =
      0x88FD;
   static const GLenum maxArrayTextureLayers =
      0x88FF;
   static const GLenum minProgramTexelOffset =
      0x8904;
   static const GLenum maxProgramTexelOffset =
      0x8905;
   static const GLenum maxVaryingComponents =
      0x8B4B;
   static const GLenum texture2dArray =
      0x8C1A;
   static const GLenum textureBinding2dArray =
      0x8C1D;
   static const GLenum r11fG11fB10f =
      0x8C3A;
   static const GLenum unsignedInt10f11f11fRev =
      0x8C3B;
   static const GLenum rgb9E5 =
      0x8C3D;
   static const GLenum unsignedInt5999Rev =
      0x8C3E;
   static const GLenum transformFeedbackBufferMode =
      0x8C7F;
   static const GLenum maxTransformFeedbackSeparateComponents =
      0x8C80;
   static const GLenum transformFeedbackVaryings =
      0x8C83;
   static const GLenum transformFeedbackBufferStart =
      0x8C84;
   static const GLenum transformFeedbackBufferSize =
      0x8C85;
   static const GLenum transformFeedbackPrimitivesWritten =
      0x8C88;
   static const GLenum rasterizerDiscard =
      0x8C89;
   static const GLenum maxTransformFeedbackInterleavedComponents =
      0x8C8A;
   static const GLenum maxTransformFeedbackSeparateAttribs =
      0x8C8B;
   static const GLenum interleavedAttribs =
      0x8C8C;
   static const GLenum separateAttribs =
      0x8C8D;
   static const GLenum transformFeedbackBuffer =
      0x8C8E;
   static const GLenum transformFeedbackBufferBinding =
      0x8C8F;
   static const GLenum rgba32ui =
      0x8D70;
   static const GLenum rgb32ui =
      0x8D71;
   static const GLenum rgba16ui =
      0x8D76;
   static const GLenum rgb16ui =
      0x8D77;
   static const GLenum rgba8ui =
      0x8D7C;
   static const GLenum rgb8ui =
      0x8D7D;
   static const GLenum rgba32i =
      0x8D82;
   static const GLenum rgb32i =
      0x8D83;
   static const GLenum rgba16i =
      0x8D88;
   static const GLenum rgb16i =
      0x8D89;
   static const GLenum rgba8i =
      0x8D8E;
   static const GLenum rgb8i =
      0x8D8F;
   static const GLenum redInteger =
      0x8D94;
   static const GLenum rgbInteger =
      0x8D98;
   static const GLenum rgbaInteger =
      0x8D99;
   static const GLenum sampler2dArray =
      0x8DC1;
   static const GLenum sampler2dArrayShadow =
      0x8DC4;
   static const GLenum samplerCubeShadow =
      0x8DC5;
   static const GLenum unsignedIntVec2 =
      0x8DC6;
   static const GLenum unsignedIntVec3 =
      0x8DC7;
   static const GLenum unsignedIntVec4 =
      0x8DC8;
   static const GLenum intSampler2d =
      0x8DCA;
   static const GLenum intSampler3d =
      0x8DCB;
   static const GLenum intSamplerCube =
      0x8DCC;
   static const GLenum intSampler2dArray =
      0x8DCF;
   static const GLenum unsignedIntSampler2d =
      0x8DD2;
   static const GLenum unsignedIntSampler3d =
      0x8DD3;
   static const GLenum unsignedIntSamplerCube =
      0x8DD4;
   static const GLenum unsignedIntSampler2dArray =
      0x8DD7;
   static const GLenum depthComponent32f =
      0x8CAC;
   static const GLenum depth32fStencil8 =
      0x8CAD;
   static const GLenum float32UnsignedInt248Rev =
      0x8DAD;
   static const GLenum framebufferAttachmentColorEncoding =
      0x8210;
   static const GLenum framebufferAttachmentComponentType =
      0x8211;
   static const GLenum framebufferAttachmentRedSize =
      0x8212;
   static const GLenum framebufferAttachmentGreenSize =
      0x8213;
   static const GLenum framebufferAttachmentBlueSize =
      0x8214;
   static const GLenum framebufferAttachmentAlphaSize =
      0x8215;
   static const GLenum framebufferAttachmentDepthSize =
      0x8216;
   static const GLenum framebufferAttachmentStencilSize =
      0x8217;
   static const GLenum framebufferDefault =
      0x8218;
   static const GLenum unsignedInt248 =
      0x84FA;
   static const GLenum depth24Stencil8 =
      0x88F0;
   static const GLenum unsignedNormalized =
      0x8C17;
   static const GLenum drawFramebufferBinding =
      0x8CA6;
   static const GLenum readFramebuffer =
      0x8CA8;
   static const GLenum drawFramebuffer =
      0x8CA9;
   static const GLenum readFramebufferBinding =
      0x8CAA;
   static const GLenum renderbufferSamples =
      0x8CAB;
   static const GLenum framebufferAttachmentTextureLayer =
      0x8CD4;
   static const GLenum maxColorAttachments =
      0x8CDF;
   static const GLenum colorAttachment1 =
      0x8CE1;
   static const GLenum colorAttachment2 =
      0x8CE2;
   static const GLenum colorAttachment3 =
      0x8CE3;
   static const GLenum colorAttachment4 =
      0x8CE4;
   static const GLenum colorAttachment5 =
      0x8CE5;
   static const GLenum colorAttachment6 =
      0x8CE6;
   static const GLenum colorAttachment7 =
      0x8CE7;
   static const GLenum colorAttachment8 =
      0x8CE8;
   static const GLenum colorAttachment9 =
      0x8CE9;
   static const GLenum colorAttachment10 =
      0x8CEA;
   static const GLenum colorAttachment11 =
      0x8CEB;
   static const GLenum colorAttachment12 =
      0x8CEC;
   static const GLenum colorAttachment13 =
      0x8CED;
   static const GLenum colorAttachment14 =
      0x8CEE;
   static const GLenum colorAttachment15 =
      0x8CEF;
   static const GLenum framebufferIncompleteMultisample =
      0x8D56;
   static const GLenum maxSamples =
      0x8D57;
   static const GLenum halfFloat =
      0x140B;
   static const GLenum rg =
      0x8227;
   static const GLenum rgInteger =
      0x8228;
   static const GLenum r8 =
      0x8229;
   static const GLenum rg8 =
      0x822B;
   static const GLenum r16f =
      0x822D;
   static const GLenum r32f =
      0x822E;
   static const GLenum rg16f =
      0x822F;
   static const GLenum rg32f =
      0x8230;
   static const GLenum r8i =
      0x8231;
   static const GLenum r8ui =
      0x8232;
   static const GLenum r16i =
      0x8233;
   static const GLenum r16ui =
      0x8234;
   static const GLenum r32i =
      0x8235;
   static const GLenum r32ui =
      0x8236;
   static const GLenum rg8i =
      0x8237;
   static const GLenum rg8ui =
      0x8238;
   static const GLenum rg16i =
      0x8239;
   static const GLenum rg16ui =
      0x823A;
   static const GLenum rg32i =
      0x823B;
   static const GLenum rg32ui =
      0x823C;
   static const GLenum vertexArrayBinding =
      0x85B5;
   static const GLenum r8Snorm =
      0x8F94;
   static const GLenum rg8Snorm =
      0x8F95;
   static const GLenum rgb8Snorm =
      0x8F96;
   static const GLenum rgba8Snorm =
      0x8F97;
   static const GLenum signedNormalized =
      0x8F9C;
   static const GLenum copyReadBuffer =
      0x8F36;
   static const GLenum copyWriteBuffer =
      0x8F37;
   static const GLenum copyReadBufferBinding =
      0x8F36;
   static const GLenum copyWriteBufferBinding =
      0x8F37;
   static const GLenum uniformBuffer =
      0x8A11;
   static const GLenum uniformBufferBinding =
      0x8A28;
   static const GLenum uniformBufferStart =
      0x8A29;
   static const GLenum uniformBufferSize =
      0x8A2A;
   static const GLenum maxVertexUniformBlocks =
      0x8A2B;
   static const GLenum maxFragmentUniformBlocks =
      0x8A2D;
   static const GLenum maxCombinedUniformBlocks =
      0x8A2E;
   static const GLenum maxUniformBufferBindings =
      0x8A2F;
   static const GLenum maxUniformBlockSize =
      0x8A30;
   static const GLenum maxCombinedVertexUniformComponents =
      0x8A31;
   static const GLenum maxCombinedFragmentUniformComponents =
      0x8A33;
   static const GLenum uniformBufferOffsetAlignment =
      0x8A34;
   static const GLenum activeUniformBlocks =
      0x8A36;
   static const GLenum uniformType =
      0x8A37;
   static const GLenum uniformSize =
      0x8A38;
   static const GLenum uniformBlockIndex =
      0x8A3A;
   static const GLenum uniformOffset =
      0x8A3B;
   static const GLenum uniformArrayStride =
      0x8A3C;
   static const GLenum uniformMatrixStride =
      0x8A3D;
   static const GLenum uniformIsRowMajor =
      0x8A3E;
   static const GLenum uniformBlockBinding =
      0x8A3F;
   static const GLenum uniformBlockDataSize =
      0x8A40;
   static const GLenum uniformBlockActiveUniforms =
      0x8A42;
   static const GLenum uniformBlockActiveUniformIndices =
      0x8A43;
   static const GLenum uniformBlockReferencedByVertexShader =
      0x8A44;
   static const GLenum uniformBlockReferencedByFragmentShader =
      0x8A46;
   static const GLenum invalidIndex =
      0xFFFFFFFF;
   static const GLenum maxVertexOutputComponents =
      0x9122;
   static const GLenum maxFragmentInputComponents =
      0x9125;
   static const GLenum maxServerWaitTimeout =
      0x9111;
   static const GLenum objectType =
      0x9112;
   static const GLenum syncCondition =
      0x9113;
   static const GLenum syncStatus =
      0x9114;
   static const GLenum syncFlags =
      0x9115;
   static const GLenum syncFence =
      0x9116;
   static const GLenum syncGpuCommandsComplete =
      0x9117;
   static const GLenum unsignaled =
      0x9118;
   static const GLenum signaled =
      0x9119;
   static const GLenum alreadySignaled =
      0x911A;
   static const GLenum timeoutExpired =
      0x911B;
   static const GLenum conditionSatisfied =
      0x911C;
   static const GLenum waitFailed =
      0x911D;
   static const GLenum syncFlushCommandsBit =
      0x00000001;
   static const GLenum vertexAttribArrayDivisor =
      0x88FE;
   static const GLenum anySamplesPassed =
      0x8C2F;
   static const GLenum anySamplesPassedConservative =
      0x8D6A;
   static const GLenum samplerBinding =
      0x8919;
   static const GLenum rgb10A2ui =
      0x906F;
   static const GLenum int2101010Rev =
      0x8D9F;
   static const GLenum transformFeedback =
      0x8E22;
   static const GLenum transformFeedbackPaused =
      0x8E23;
   static const GLenum transformFeedbackActive =
      0x8E24;
   static const GLenum transformFeedbackBinding =
      0x8E25;
   static const GLenum textureImmutableFormat =
      0x912F;
   static const GLenum maxElementIndex =
      0x8D6B;
   static const GLenum textureImmutableLevels =
      0x82DF;
   static const GLint64 timeoutIgnored =
      -1;
   static const GLenum maxClientWaitTimeoutWebgl =
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
  WebGLQuery? createQuery();
  void deleteQuery(WebGLQuery? query);
  GLboolean isQuery(WebGLQuery? query);
  void beginQuery(GLenum target, WebGLQuery query);
  void endQuery(GLenum target);
  WebGLQuery? getQuery(GLenum target, GLenum pname);
  Object getQueryParameter(WebGLQuery query, GLenum pname);
  WebGLSampler? createSampler();
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
  WebGLTransformFeedback? createTransformFeedback();
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
  WebGLVertexArrayObject? createVertexArray();
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

