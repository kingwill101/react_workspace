// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webgpu
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'webcodecs.dart';
import 'cssom_view.dart';
import 'dom.dart';

typedef GPUAddressMode = String;

typedef GPUAutoLayoutMode = String;

abstract interface class GPUBindGroupDescriptor {
  Object get layout;
  set layout(Object value);
  List<GPUBindGroupEntry> get entries;
  set entries(List<GPUBindGroupEntry> value);
}

abstract interface class GPUBindGroupEntry {
  GPUIndex32 get binding;
  set binding(GPUIndex32 value);
  GPUBindingResource get resource;
  set resource(GPUBindingResource value);
}

abstract interface class GPUBindGroupLayoutDescriptor {
  List<GPUBindGroupLayoutEntry> get entries;
  set entries(List<GPUBindGroupLayoutEntry> value);
}

abstract interface class GPUBindGroupLayoutEntry {
  GPUIndex32 get binding;
  set binding(GPUIndex32 value);
  GPUShaderStageFlags get visibility;
  set visibility(GPUShaderStageFlags value);
  GPUBufferBindingLayout get buffer;
  set buffer(GPUBufferBindingLayout value);
  GPUSamplerBindingLayout get sampler;
  set sampler(GPUSamplerBindingLayout value);
  GPUTextureBindingLayout get texture;
  set texture(GPUTextureBindingLayout value);
  GPUStorageTextureBindingLayout get storageTexture;
  set storageTexture(GPUStorageTextureBindingLayout value);
  GPUExternalTextureBindingLayout get externalTexture;
  set externalTexture(GPUExternalTextureBindingLayout value);
}

abstract interface class GPUBindingCommandsMixin {
  void setBindGroup(GPUIndex32 index, Object bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
}

typedef GPUBindingResource = Object;

abstract interface class GPUBlendComponent {
  GPUBlendOperation get operation;
  set operation(GPUBlendOperation value);
  GPUBlendFactor get srcFactor;
  set srcFactor(GPUBlendFactor value);
  GPUBlendFactor get dstFactor;
  set dstFactor(GPUBlendFactor value);
}

typedef GPUBlendFactor = String;

typedef GPUBlendOperation = String;

abstract interface class GPUBlendState {
  GPUBlendComponent get color;
  set color(GPUBlendComponent value);
  GPUBlendComponent get alpha;
  set alpha(GPUBlendComponent value);
}

abstract interface class GPUBufferBinding {
  Object get buffer;
  set buffer(Object value);
  GPUSize64 get offset;
  set offset(GPUSize64 value);
  GPUSize64 get size;
  set size(GPUSize64 value);
}

abstract interface class GPUBufferBindingLayout {
  GPUBufferBindingType get type;
  set type(GPUBufferBindingType value);
  bool get hasDynamicOffset;
  set hasDynamicOffset(bool value);
  GPUSize64 get minBindingSize;
  set minBindingSize(GPUSize64 value);
}

typedef GPUBufferBindingType = String;

abstract interface class GPUBufferDescriptor {
  GPUSize64 get size;
  set size(GPUSize64 value);
  GPUBufferUsageFlags get usage;
  set usage(GPUBufferUsageFlags value);
  bool get mappedAtCreation;
  set mappedAtCreation(bool value);
}

typedef GPUBufferDynamicOffset = int;

typedef GPUBufferMapState = String;

typedef GPUBufferUsageFlags = int;

typedef GPUCanvasAlphaMode = String;

abstract interface class GPUCanvasConfiguration {
  Object get device;
  set device(Object value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureUsageFlags get usage;
  set usage(GPUTextureUsageFlags value);
  List<GPUTextureFormat> get viewFormats;
  set viewFormats(List<GPUTextureFormat> value);
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
  GPUCanvasAlphaMode get alphaMode;
  set alphaMode(GPUCanvasAlphaMode value);
}

typedef GPUColor = Object;

abstract interface class GPUColorDict {
  double get r;
  set r(double value);
  double get g;
  set g(double value);
  double get b;
  set b(double value);
  double get a;
  set a(double value);
}

abstract interface class GPUColorTargetState {
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUBlendState get blend;
  set blend(GPUBlendState value);
  GPUColorWriteFlags get writeMask;
  set writeMask(GPUColorWriteFlags value);
}

typedef GPUColorWriteFlags = int;

abstract interface class GPUCommandBufferDescriptor {
}

abstract interface class GPUCommandEncoderDescriptor {
}

abstract interface class GPUCommandsMixin {
}

typedef GPUCompareFunction = String;

typedef GPUCompilationMessageType = String;

abstract interface class GPUComputePassDescriptor {
  GPUComputePassTimestampWrites get timestampWrites;
  set timestampWrites(GPUComputePassTimestampWrites value);
}

abstract interface class GPUComputePassTimestampWrites {
  Object get querySet;
  set querySet(Object value);
  GPUSize32 get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32 value);
  GPUSize32 get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32 value);
}

abstract interface class GPUComputePipelineDescriptor {
  GPUProgrammableStage get compute;
  set compute(GPUProgrammableStage value);
}

typedef GPUCullMode = String;

abstract interface class GPUDebugCommandsMixin {
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();
  void insertDebugMarker(String markerLabel);
}

typedef GPUDepthBias = int;

abstract interface class GPUDepthStencilState {
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  bool get depthWriteEnabled;
  set depthWriteEnabled(bool value);
  GPUCompareFunction get depthCompare;
  set depthCompare(GPUCompareFunction value);
  GPUStencilFaceState get stencilFront;
  set stencilFront(GPUStencilFaceState value);
  GPUStencilFaceState get stencilBack;
  set stencilBack(GPUStencilFaceState value);
  GPUStencilValue get stencilReadMask;
  set stencilReadMask(GPUStencilValue value);
  GPUStencilValue get stencilWriteMask;
  set stencilWriteMask(GPUStencilValue value);
  GPUDepthBias get depthBias;
  set depthBias(GPUDepthBias value);
  double get depthBiasSlopeScale;
  set depthBiasSlopeScale(double value);
  double get depthBiasClamp;
  set depthBiasClamp(double value);
}

abstract interface class GPUDeviceDescriptor {
  List<GPUFeatureName> get requiredFeatures;
  set requiredFeatures(List<GPUFeatureName> value);
  Map<String, GPUSize64> get requiredLimits;
  set requiredLimits(Map<String, GPUSize64> value);
  GPUQueueDescriptor get defaultQueue;
  set defaultQueue(GPUQueueDescriptor value);
}

typedef GPUDeviceLostReason = String;

typedef GPUErrorFilter = String;

typedef GPUExtent3D = Object;

abstract interface class GPUExtent3DDict {
  GPUIntegerCoordinate get width;
  set width(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get height;
  set height(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get depthOrArrayLayers;
  set depthOrArrayLayers(GPUIntegerCoordinate value);
}

abstract interface class GPUExternalTextureBindingLayout {
}

abstract interface class GPUExternalTextureDescriptor {
  Object get source;
  set source(Object value);
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
}

typedef GPUFeatureName = String;

typedef GPUFilterMode = String;

typedef GPUFlagsConstant = int;

abstract interface class GPUFragmentState {
  List<GPUColorTargetState?> get targets;
  set targets(List<GPUColorTargetState?> value);
}

typedef GPUFrontFace = String;

abstract interface class GPUImageCopyBuffer {
  Object get buffer;
  set buffer(Object value);
}

abstract interface class GPUImageCopyExternalImage {
  GPUImageCopyExternalImageSource get source;
  set source(GPUImageCopyExternalImageSource value);
  GPUOrigin2D get origin;
  set origin(GPUOrigin2D value);
  bool get flipY;
  set flipY(bool value);
}

typedef GPUImageCopyExternalImageSource = Object;

abstract interface class GPUImageCopyTexture {
  Object get texture;
  set texture(Object value);
  GPUIntegerCoordinate get mipLevel;
  set mipLevel(GPUIntegerCoordinate value);
  GPUOrigin3D get origin;
  set origin(GPUOrigin3D value);
  GPUTextureAspect get aspect;
  set aspect(GPUTextureAspect value);
}

abstract interface class GPUImageCopyTextureTagged {
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
  bool get premultipliedAlpha;
  set premultipliedAlpha(bool value);
}

abstract interface class GPUImageDataLayout {
  GPUSize64 get offset;
  set offset(GPUSize64 value);
  GPUSize32 get bytesPerRow;
  set bytesPerRow(GPUSize32 value);
  GPUSize32 get rowsPerImage;
  set rowsPerImage(GPUSize32 value);
}

typedef GPUIndex32 = int;

typedef GPUIndexFormat = String;

typedef GPUIntegerCoordinate = int;

typedef GPUIntegerCoordinateOut = int;

typedef GPULoadOp = String;

typedef GPUMapModeFlags = int;

typedef GPUMipmapFilterMode = String;

abstract interface class GPUMultisampleState {
  GPUSize32 get count;
  set count(GPUSize32 value);
  GPUSampleMask get mask;
  set mask(GPUSampleMask value);
  bool get alphaToCoverageEnabled;
  set alphaToCoverageEnabled(bool value);
}

abstract interface class GPUObjectBase {
  String get label;
   set label(String value);
}

abstract interface class GPUObjectDescriptorBase {
  String get label;
  set label(String value);
}

typedef GPUOrigin2D = Object;

abstract interface class GPUOrigin2DDict {
  GPUIntegerCoordinate get x;
  set x(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get y;
  set y(GPUIntegerCoordinate value);
}

typedef GPUOrigin3D = Object;

abstract interface class GPUOrigin3DDict {
  GPUIntegerCoordinate get x;
  set x(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get y;
  set y(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get z;
  set z(GPUIntegerCoordinate value);
}

abstract interface class GPUPipelineBase {
  Object getBindGroupLayout(int index);
}

typedef GPUPipelineConstantValue = double;

abstract interface class GPUPipelineDescriptorBase {
  Object get layout;
  set layout(Object value);
}

abstract interface class GPUPipelineErrorInit {
  GPUPipelineErrorReason get reason;
  set reason(GPUPipelineErrorReason value);
}

typedef GPUPipelineErrorReason = String;

abstract interface class GPUPipelineLayoutDescriptor {
  List<Object> get bindGroupLayouts;
  set bindGroupLayouts(List<Object> value);
}

typedef GPUPowerPreference = String;

abstract interface class GPUPrimitiveState {
  GPUPrimitiveTopology get topology;
  set topology(GPUPrimitiveTopology value);
  GPUIndexFormat get stripIndexFormat;
  set stripIndexFormat(GPUIndexFormat value);
  GPUFrontFace get frontFace;
  set frontFace(GPUFrontFace value);
  GPUCullMode get cullMode;
  set cullMode(GPUCullMode value);
  bool get unclippedDepth;
  set unclippedDepth(bool value);
}

typedef GPUPrimitiveTopology = String;

abstract interface class GPUProgrammableStage {
  Object get module;
  set module(Object value);
  String get entryPoint;
  set entryPoint(String value);
  Map<String, GPUPipelineConstantValue> get constants;
  set constants(Map<String, GPUPipelineConstantValue> value);
}

abstract interface class GPUQuerySetDescriptor {
  GPUQueryType get type;
  set type(GPUQueryType value);
  GPUSize32 get count;
  set count(GPUSize32 value);
}

typedef GPUQueryType = String;

abstract interface class GPUQueueDescriptor {
}

abstract interface class GPURenderBundleDescriptor {
}

abstract interface class GPURenderBundleEncoderDescriptor {
  bool get depthReadOnly;
  set depthReadOnly(bool value);
  bool get stencilReadOnly;
  set stencilReadOnly(bool value);
}

abstract interface class GPURenderCommandsMixin {
  void setPipeline(Object pipeline);
  void setIndexBuffer(Object buffer, GPUIndexFormat indexFormat, [GPUSize64? offset, GPUSize64? size]);
  void setVertexBuffer(GPUIndex32 slot, Object buffer, [GPUSize64? offset, GPUSize64? size]);
  void draw(GPUSize32 vertexCount, [GPUSize32? instanceCount, GPUSize32? firstVertex, GPUSize32? firstInstance]);
  void drawIndexed(GPUSize32 indexCount, [GPUSize32? instanceCount, GPUSize32? firstIndex, GPUSignedOffset32? baseVertex, GPUSize32? firstInstance]);
  void drawIndirect(Object indirectBuffer, GPUSize64 indirectOffset);
  void drawIndexedIndirect(Object indirectBuffer, GPUSize64 indirectOffset);
}

abstract interface class GPURenderPassColorAttachment {
  Object get view;
  set view(Object value);
  GPUIntegerCoordinate get depthSlice;
  set depthSlice(GPUIntegerCoordinate value);
  Object get resolveTarget;
  set resolveTarget(Object value);
  GPUColor get clearValue;
  set clearValue(GPUColor value);
  GPULoadOp get loadOp;
  set loadOp(GPULoadOp value);
  GPUStoreOp get storeOp;
  set storeOp(GPUStoreOp value);
}

abstract interface class GPURenderPassDepthStencilAttachment {
  Object get view;
  set view(Object value);
  double get depthClearValue;
  set depthClearValue(double value);
  GPULoadOp get depthLoadOp;
  set depthLoadOp(GPULoadOp value);
  GPUStoreOp get depthStoreOp;
  set depthStoreOp(GPUStoreOp value);
  bool get depthReadOnly;
  set depthReadOnly(bool value);
  GPUStencilValue get stencilClearValue;
  set stencilClearValue(GPUStencilValue value);
  GPULoadOp get stencilLoadOp;
  set stencilLoadOp(GPULoadOp value);
  GPUStoreOp get stencilStoreOp;
  set stencilStoreOp(GPUStoreOp value);
  bool get stencilReadOnly;
  set stencilReadOnly(bool value);
}

abstract interface class GPURenderPassDescriptor {
  List<GPURenderPassColorAttachment?> get colorAttachments;
  set colorAttachments(List<GPURenderPassColorAttachment?> value);
  GPURenderPassDepthStencilAttachment get depthStencilAttachment;
  set depthStencilAttachment(GPURenderPassDepthStencilAttachment value);
  Object get occlusionQuerySet;
  set occlusionQuerySet(Object value);
  GPURenderPassTimestampWrites get timestampWrites;
  set timestampWrites(GPURenderPassTimestampWrites value);
  GPUSize64 get maxDrawCount;
  set maxDrawCount(GPUSize64 value);
}

abstract interface class GPURenderPassLayout {
  List<GPUTextureFormat?> get colorFormats;
  set colorFormats(List<GPUTextureFormat?> value);
  GPUTextureFormat get depthStencilFormat;
  set depthStencilFormat(GPUTextureFormat value);
  GPUSize32 get sampleCount;
  set sampleCount(GPUSize32 value);
}

abstract interface class GPURenderPassTimestampWrites {
  Object get querySet;
  set querySet(Object value);
  GPUSize32 get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32 value);
  GPUSize32 get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32 value);
}

abstract interface class GPURenderPipelineDescriptor {
  GPUVertexState get vertex;
  set vertex(GPUVertexState value);
  GPUPrimitiveState get primitive;
  set primitive(GPUPrimitiveState value);
  GPUDepthStencilState get depthStencil;
  set depthStencil(GPUDepthStencilState value);
  GPUMultisampleState get multisample;
  set multisample(GPUMultisampleState value);
  GPUFragmentState get fragment;
  set fragment(GPUFragmentState value);
}

abstract interface class GPURequestAdapterOptions {
  GPUPowerPreference get powerPreference;
  set powerPreference(GPUPowerPreference value);
  bool get forceFallbackAdapter;
  set forceFallbackAdapter(bool value);
}

typedef GPUSampleMask = int;

abstract interface class GPUSamplerBindingLayout {
  GPUSamplerBindingType get type;
  set type(GPUSamplerBindingType value);
}

typedef GPUSamplerBindingType = String;

abstract interface class GPUSamplerDescriptor {
  GPUAddressMode get addressModeU;
  set addressModeU(GPUAddressMode value);
  GPUAddressMode get addressModeV;
  set addressModeV(GPUAddressMode value);
  GPUAddressMode get addressModeW;
  set addressModeW(GPUAddressMode value);
  GPUFilterMode get magFilter;
  set magFilter(GPUFilterMode value);
  GPUFilterMode get minFilter;
  set minFilter(GPUFilterMode value);
  GPUMipmapFilterMode get mipmapFilter;
  set mipmapFilter(GPUMipmapFilterMode value);
  double get lodMinClamp;
  set lodMinClamp(double value);
  double get lodMaxClamp;
  set lodMaxClamp(double value);
  GPUCompareFunction get compare;
  set compare(GPUCompareFunction value);
  int get maxAnisotropy;
  set maxAnisotropy(int value);
}

abstract interface class GPUShaderModuleCompilationHint {
  String get entryPoint;
  set entryPoint(String value);
  Object get layout;
  set layout(Object value);
}

abstract interface class GPUShaderModuleDescriptor {
  String get code;
  set code(String value);
  Object get sourceMap;
  set sourceMap(Object value);
  List<GPUShaderModuleCompilationHint> get compilationHints;
  set compilationHints(List<GPUShaderModuleCompilationHint> value);
}

typedef GPUShaderStageFlags = int;

typedef GPUSignedOffset32 = int;

typedef GPUSize32 = int;

typedef GPUSize32Out = int;

typedef GPUSize64 = int;

typedef GPUSize64Out = int;

abstract interface class GPUStencilFaceState {
  GPUCompareFunction get compare;
  set compare(GPUCompareFunction value);
  GPUStencilOperation get failOp;
  set failOp(GPUStencilOperation value);
  GPUStencilOperation get depthFailOp;
  set depthFailOp(GPUStencilOperation value);
  GPUStencilOperation get passOp;
  set passOp(GPUStencilOperation value);
}

typedef GPUStencilOperation = String;

typedef GPUStencilValue = int;

typedef GPUStorageTextureAccess = String;

abstract interface class GPUStorageTextureBindingLayout {
  GPUStorageTextureAccess get access;
  set access(GPUStorageTextureAccess value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureViewDimension get viewDimension;
  set viewDimension(GPUTextureViewDimension value);
}

typedef GPUStoreOp = String;

typedef GPUTextureAspect = String;

abstract interface class GPUTextureBindingLayout {
  GPUTextureSampleType get sampleType;
  set sampleType(GPUTextureSampleType value);
  GPUTextureViewDimension get viewDimension;
  set viewDimension(GPUTextureViewDimension value);
  bool get multisampled;
  set multisampled(bool value);
}

abstract interface class GPUTextureDescriptor {
  GPUExtent3D get size;
  set size(GPUExtent3D value);
  GPUIntegerCoordinate get mipLevelCount;
  set mipLevelCount(GPUIntegerCoordinate value);
  GPUSize32 get sampleCount;
  set sampleCount(GPUSize32 value);
  GPUTextureDimension get dimension;
  set dimension(GPUTextureDimension value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureUsageFlags get usage;
  set usage(GPUTextureUsageFlags value);
  List<GPUTextureFormat> get viewFormats;
  set viewFormats(List<GPUTextureFormat> value);
}

typedef GPUTextureDimension = String;

typedef GPUTextureFormat = String;

typedef GPUTextureSampleType = String;

typedef GPUTextureUsageFlags = int;

abstract interface class GPUTextureViewDescriptor {
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureViewDimension get dimension;
  set dimension(GPUTextureViewDimension value);
  GPUTextureAspect get aspect;
  set aspect(GPUTextureAspect value);
  GPUIntegerCoordinate get baseMipLevel;
  set baseMipLevel(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get mipLevelCount;
  set mipLevelCount(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get baseArrayLayer;
  set baseArrayLayer(GPUIntegerCoordinate value);
  GPUIntegerCoordinate get arrayLayerCount;
  set arrayLayerCount(GPUIntegerCoordinate value);
}

typedef GPUTextureViewDimension = String;

abstract interface class GPUUncapturedErrorEventInit {
  Object get error;
  set error(Object value);
}

abstract interface class GPUVertexAttribute {
  GPUVertexFormat get format;
  set format(GPUVertexFormat value);
  GPUSize64 get offset;
  set offset(GPUSize64 value);
  GPUIndex32 get shaderLocation;
  set shaderLocation(GPUIndex32 value);
}

abstract interface class GPUVertexBufferLayout {
  GPUSize64 get arrayStride;
  set arrayStride(GPUSize64 value);
  GPUVertexStepMode get stepMode;
  set stepMode(GPUVertexStepMode value);
  List<GPUVertexAttribute> get attributes;
  set attributes(List<GPUVertexAttribute> value);
}

typedef GPUVertexFormat = String;

abstract interface class GPUVertexState {
  List<GPUVertexBufferLayout?> get buffers;
  set buffers(List<GPUVertexBufferLayout?> value);
}

typedef GPUVertexStepMode = String;

abstract interface class NavigatorGPU {
  Object get gpu;
}

