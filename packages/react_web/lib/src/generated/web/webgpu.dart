// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webgpu
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'webcodecs.dart';
import 'webidl.dart';
import 'dom.dart';

abstract interface class GPU {
  Future<GPUAdapter?> requestAdapter([GPURequestAdapterOptions? options]);
  GPUTextureFormat getPreferredCanvasFormat();
  WGSLLanguageFeatures get wgslLanguageFeatures;
}

abstract interface class GPUAdapter {
  GPUSupportedFeatures get features;
  GPUSupportedLimits get limits;
  GPUAdapterInfo get info;
  bool get isFallbackAdapter;
  Future<GPUDevice> requestDevice([GPUDeviceDescriptor? descriptor]);
}

abstract interface class GPUAdapterInfo {
  String get vendor;
  String get architecture;
  String get device;
  String get description;
  int get subgroupMinSize;
  int get subgroupMaxSize;
}

typedef GPUAddressMode = String;

typedef GPUAutoLayoutMode = String;

abstract interface class GPUBindGroup {
  String get label;
   set label(String value);
}

abstract interface class GPUBindGroupDescriptor {
  GPUBindGroupLayout get layout;
  set layout(GPUBindGroupLayout value);
  List<GPUBindGroupEntry> get entries;
  set entries(List<GPUBindGroupEntry> value);
}

abstract interface class GPUBindGroupEntry {
  GPUIndex32 get binding;
  set binding(GPUIndex32 value);
  GPUBindingResource get resource;
  set resource(GPUBindingResource value);
}

abstract interface class GPUBindGroupLayout {
  String get label;
   set label(String value);
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
  void setBindGroup(GPUIndex32 index, GPUBindGroup? bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
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

abstract interface class GPUBuffer {
  String get label;
   set label(String value);
  GPUSize64Out get size;
  GPUFlagsConstant get usage;
  GPUBufferMapState get mapState;
  Future<void> mapAsync(GPUMapModeFlags mode, [GPUSize64? offset, GPUSize64? size]);
  Object getMappedRange([GPUSize64? offset, GPUSize64? size]);
  void unmap();
  void destroy();
}

abstract interface class GPUBufferBinding {
  GPUBuffer get buffer;
  set buffer(GPUBuffer value);
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

abstract final class GPUBufferUsage {
  GPUBufferUsage._();
  static const GPUFlagsConstant MAP_READ =
      0x0001;
  static const GPUFlagsConstant MAP_WRITE =
      0x0002;
  static const GPUFlagsConstant COPY_SRC =
      0x0004;
  static const GPUFlagsConstant COPY_DST =
      0x0008;
  static const GPUFlagsConstant INDEX =
      0x0010;
  static const GPUFlagsConstant VERTEX =
      0x0020;
  static const GPUFlagsConstant UNIFORM =
      0x0040;
  static const GPUFlagsConstant STORAGE =
      0x0080;
  static const GPUFlagsConstant INDIRECT =
      0x0100;
  static const GPUFlagsConstant QUERY_RESOLVE =
      0x0200;
}

typedef GPUBufferUsageFlags = int;

typedef GPUCanvasAlphaMode = String;

abstract interface class GPUCanvasConfiguration {
  GPUDevice get device;
  set device(GPUDevice value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureUsageFlags get usage;
  set usage(GPUTextureUsageFlags value);
  List<GPUTextureFormat> get viewFormats;
  set viewFormats(List<GPUTextureFormat> value);
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
  GPUCanvasToneMapping get toneMapping;
  set toneMapping(GPUCanvasToneMapping value);
  GPUCanvasAlphaMode get alphaMode;
  set alphaMode(GPUCanvasAlphaMode value);
}

abstract interface class GPUCanvasContext {
  Object get canvas;
  void configure(GPUCanvasConfiguration configuration);
  void unconfigure();
  GPUCanvasConfiguration? getConfiguration();
  GPUTexture getCurrentTexture();
}

abstract interface class GPUCanvasToneMapping {
  GPUCanvasToneMappingMode get mode;
  set mode(GPUCanvasToneMappingMode value);
}

typedef GPUCanvasToneMappingMode = String;

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

abstract final class GPUColorWrite {
  GPUColorWrite._();
  static const GPUFlagsConstant RED =
      0x1;
  static const GPUFlagsConstant GREEN =
      0x2;
  static const GPUFlagsConstant BLUE =
      0x4;
  static const GPUFlagsConstant ALPHA =
      0x8;
  static const GPUFlagsConstant ALL =
      0xF;
}

typedef GPUColorWriteFlags = int;

abstract interface class GPUCommandBuffer {
  String get label;
   set label(String value);
}

abstract interface class GPUCommandBufferDescriptor {
}

abstract interface class GPUCommandEncoder {
  String get label;
   set label(String value);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();
  void insertDebugMarker(String markerLabel);
  GPURenderPassEncoder beginRenderPass(GPURenderPassDescriptor descriptor);
  GPUComputePassEncoder beginComputePass([GPUComputePassDescriptor? descriptor]);
  void copyBufferToBuffer(GPUBuffer source, GPUSize64 sourceOffset, GPUBuffer destination, GPUSize64 destinationOffset, GPUSize64 size);
  void copyBufferToTexture(GPUTexelCopyBufferInfo source, GPUTexelCopyTextureInfo destination, GPUExtent3D copySize);
  void copyTextureToBuffer(GPUTexelCopyTextureInfo source, GPUTexelCopyBufferInfo destination, GPUExtent3D copySize);
  void copyTextureToTexture(GPUTexelCopyTextureInfo source, GPUTexelCopyTextureInfo destination, GPUExtent3D copySize);
  void clearBuffer(GPUBuffer buffer, [GPUSize64? offset, GPUSize64? size]);
  void resolveQuerySet(GPUQuerySet querySet, GPUSize32 firstQuery, GPUSize32 queryCount, GPUBuffer destination, GPUSize64 destinationOffset);
  GPUCommandBuffer finish([GPUCommandBufferDescriptor? descriptor]);
}

abstract interface class GPUCommandEncoderDescriptor {
}

abstract interface class GPUCommandsMixin {
}

typedef GPUCompareFunction = String;

abstract interface class GPUCompilationInfo {
  List<GPUCompilationMessage> get messages;
}

abstract interface class GPUCompilationMessage {
  String get message;
  GPUCompilationMessageType get type;
  int get lineNum;
  int get linePos;
  int get offset;
  int get length;
}

typedef GPUCompilationMessageType = String;

abstract interface class GPUComputePassDescriptor {
  GPUComputePassTimestampWrites get timestampWrites;
  set timestampWrites(GPUComputePassTimestampWrites value);
}

abstract interface class GPUComputePassEncoder {
  String get label;
   set label(String value);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();
  void insertDebugMarker(String markerLabel);
  void setBindGroup(GPUIndex32 index, GPUBindGroup? bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
  void setPipeline(GPUComputePipeline pipeline);
  void dispatchWorkgroups(GPUSize32 workgroupCountX, [GPUSize32? workgroupCountY, GPUSize32? workgroupCountZ]);
  void dispatchWorkgroupsIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  void end();
}

abstract interface class GPUComputePassTimestampWrites {
  GPUQuerySet get querySet;
  set querySet(GPUQuerySet value);
  GPUSize32 get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32 value);
  GPUSize32 get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32 value);
}

abstract interface class GPUComputePipeline {
  String get label;
   set label(String value);
  GPUBindGroupLayout getBindGroupLayout(int index);
}

abstract interface class GPUComputePipelineDescriptor {
  GPUProgrammableStage get compute;
  set compute(GPUProgrammableStage value);
}

abstract interface class GPUCopyExternalImageDestInfo {
  PredefinedColorSpace get colorSpace;
  set colorSpace(PredefinedColorSpace value);
  bool get premultipliedAlpha;
  set premultipliedAlpha(bool value);
}

typedef GPUCopyExternalImageSource = Object;

abstract interface class GPUCopyExternalImageSourceInfo {
  GPUCopyExternalImageSource get source;
  set source(GPUCopyExternalImageSource value);
  GPUOrigin2D get origin;
  set origin(GPUOrigin2D value);
  bool get flipY;
  set flipY(bool value);
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

abstract interface class GPUDevice {
  String get label;
   set label(String value);
  GPUSupportedFeatures get features;
  GPUSupportedLimits get limits;
  GPUAdapterInfo get adapterInfo;
  GPUQueue get queue;
  void destroy();
  GPUBuffer createBuffer(GPUBufferDescriptor descriptor);
  GPUTexture createTexture(GPUTextureDescriptor descriptor);
  GPUSampler createSampler([GPUSamplerDescriptor? descriptor]);
  GPUExternalTexture importExternalTexture(GPUExternalTextureDescriptor descriptor);
  GPUBindGroupLayout createBindGroupLayout(GPUBindGroupLayoutDescriptor descriptor);
  GPUPipelineLayout createPipelineLayout(GPUPipelineLayoutDescriptor descriptor);
  GPUBindGroup createBindGroup(GPUBindGroupDescriptor descriptor);
  GPUShaderModule createShaderModule(GPUShaderModuleDescriptor descriptor);
  GPUComputePipeline createComputePipeline(GPUComputePipelineDescriptor descriptor);
  GPURenderPipeline createRenderPipeline(GPURenderPipelineDescriptor descriptor);
  Future<GPUComputePipeline> createComputePipelineAsync(GPUComputePipelineDescriptor descriptor);
  Future<GPURenderPipeline> createRenderPipelineAsync(GPURenderPipelineDescriptor descriptor);
  GPUCommandEncoder createCommandEncoder([GPUCommandEncoderDescriptor? descriptor]);
  GPURenderBundleEncoder createRenderBundleEncoder(GPURenderBundleEncoderDescriptor descriptor);
  GPUQuerySet createQuerySet(GPUQuerySetDescriptor descriptor);
  Future<GPUDeviceLostInfo> get lost;
  void pushErrorScope(GPUErrorFilter filter);
  Future<GPUError?> popErrorScope();
  EventHandler get onuncapturederror;
   set onuncapturederror(EventHandler value);
}

abstract interface class GPUDeviceDescriptor {
  List<GPUFeatureName> get requiredFeatures;
  set requiredFeatures(List<GPUFeatureName> value);
  Map<String, GPUSize64> get requiredLimits;
  set requiredLimits(Map<String, GPUSize64> value);
  GPUQueueDescriptor get defaultQueue;
  set defaultQueue(GPUQueueDescriptor value);
}

abstract interface class GPUDeviceLostInfo {
  GPUDeviceLostReason get reason;
  String get message;
}

typedef GPUDeviceLostReason = String;

abstract interface class GPUError {
  String get message;
}

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

abstract interface class GPUExternalTexture {
  String get label;
   set label(String value);
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

typedef GPUIndex32 = int;

typedef GPUIndexFormat = String;

typedef GPUIntegerCoordinate = int;

typedef GPUIntegerCoordinateOut = int;

abstract interface class GPUInternalError {
}

typedef GPULoadOp = String;

abstract final class GPUMapMode {
  GPUMapMode._();
  static const GPUFlagsConstant READ =
      0x0001;
  static const GPUFlagsConstant WRITE =
      0x0002;
}

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

abstract interface class GPUOutOfMemoryError {
}

abstract interface class GPUPipelineBase {
  GPUBindGroupLayout getBindGroupLayout(int index);
}

typedef GPUPipelineConstantValue = double;

abstract interface class GPUPipelineDescriptorBase {
  Object get layout;
  set layout(Object value);
}

abstract interface class GPUPipelineError {
  GPUPipelineErrorReason get reason;
}

abstract interface class GPUPipelineErrorInit {
  GPUPipelineErrorReason get reason;
  set reason(GPUPipelineErrorReason value);
}

typedef GPUPipelineErrorReason = String;

abstract interface class GPUPipelineLayout {
  String get label;
   set label(String value);
}

abstract interface class GPUPipelineLayoutDescriptor {
  List<GPUBindGroupLayout?> get bindGroupLayouts;
  set bindGroupLayouts(List<GPUBindGroupLayout?> value);
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
  GPUShaderModule get module;
  set module(GPUShaderModule value);
  String get entryPoint;
  set entryPoint(String value);
  Map<String, GPUPipelineConstantValue> get constants;
  set constants(Map<String, GPUPipelineConstantValue> value);
}

abstract interface class GPUQuerySet {
  String get label;
   set label(String value);
  void destroy();
  GPUQueryType get type;
  GPUSize32Out get count;
}

abstract interface class GPUQuerySetDescriptor {
  GPUQueryType get type;
  set type(GPUQueryType value);
  GPUSize32 get count;
  set count(GPUSize32 value);
}

typedef GPUQueryType = String;

abstract interface class GPUQueue {
  String get label;
   set label(String value);
  void submit(List<GPUCommandBuffer> commandBuffers);
  Future<void> onSubmittedWorkDone();
  void writeBuffer(GPUBuffer buffer, GPUSize64 bufferOffset, AllowSharedBufferSource data, [GPUSize64? dataOffset, GPUSize64? size]);
  void writeTexture(GPUTexelCopyTextureInfo destination, AllowSharedBufferSource data, GPUTexelCopyBufferLayout dataLayout, GPUExtent3D size);
  void copyExternalImageToTexture(GPUCopyExternalImageSourceInfo source, GPUCopyExternalImageDestInfo destination, GPUExtent3D copySize);
}

abstract interface class GPUQueueDescriptor {
}

abstract interface class GPURenderBundle {
  String get label;
   set label(String value);
}

abstract interface class GPURenderBundleDescriptor {
}

abstract interface class GPURenderBundleEncoder {
  String get label;
   set label(String value);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();
  void insertDebugMarker(String markerLabel);
  void setBindGroup(GPUIndex32 index, GPUBindGroup? bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
  void setPipeline(GPURenderPipeline pipeline);
  void setIndexBuffer(GPUBuffer buffer, GPUIndexFormat indexFormat, [GPUSize64? offset, GPUSize64? size]);
  void setVertexBuffer(GPUIndex32 slot, GPUBuffer? buffer, [GPUSize64? offset, GPUSize64? size]);
  void draw(GPUSize32 vertexCount, [GPUSize32? instanceCount, GPUSize32? firstVertex, GPUSize32? firstInstance]);
  void drawIndexed(GPUSize32 indexCount, [GPUSize32? instanceCount, GPUSize32? firstIndex, GPUSignedOffset32? baseVertex, GPUSize32? firstInstance]);
  void drawIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  void drawIndexedIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  GPURenderBundle finish([GPURenderBundleDescriptor? descriptor]);
}

abstract interface class GPURenderBundleEncoderDescriptor {
  bool get depthReadOnly;
  set depthReadOnly(bool value);
  bool get stencilReadOnly;
  set stencilReadOnly(bool value);
}

abstract interface class GPURenderCommandsMixin {
  void setPipeline(GPURenderPipeline pipeline);
  void setIndexBuffer(GPUBuffer buffer, GPUIndexFormat indexFormat, [GPUSize64? offset, GPUSize64? size]);
  void setVertexBuffer(GPUIndex32 slot, GPUBuffer? buffer, [GPUSize64? offset, GPUSize64? size]);
  void draw(GPUSize32 vertexCount, [GPUSize32? instanceCount, GPUSize32? firstVertex, GPUSize32? firstInstance]);
  void drawIndexed(GPUSize32 indexCount, [GPUSize32? instanceCount, GPUSize32? firstIndex, GPUSignedOffset32? baseVertex, GPUSize32? firstInstance]);
  void drawIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  void drawIndexedIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
}

abstract interface class GPURenderPassColorAttachment {
  GPUTextureView get view;
  set view(GPUTextureView value);
  GPUIntegerCoordinate get depthSlice;
  set depthSlice(GPUIntegerCoordinate value);
  GPUTextureView get resolveTarget;
  set resolveTarget(GPUTextureView value);
  GPUColor get clearValue;
  set clearValue(GPUColor value);
  GPULoadOp get loadOp;
  set loadOp(GPULoadOp value);
  GPUStoreOp get storeOp;
  set storeOp(GPUStoreOp value);
}

abstract interface class GPURenderPassDepthStencilAttachment {
  GPUTextureView get view;
  set view(GPUTextureView value);
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
  GPUQuerySet get occlusionQuerySet;
  set occlusionQuerySet(GPUQuerySet value);
  GPURenderPassTimestampWrites get timestampWrites;
  set timestampWrites(GPURenderPassTimestampWrites value);
  GPUSize64 get maxDrawCount;
  set maxDrawCount(GPUSize64 value);
}

abstract interface class GPURenderPassEncoder {
  String get label;
   set label(String value);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();
  void insertDebugMarker(String markerLabel);
  void setBindGroup(GPUIndex32 index, GPUBindGroup? bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
  void setPipeline(GPURenderPipeline pipeline);
  void setIndexBuffer(GPUBuffer buffer, GPUIndexFormat indexFormat, [GPUSize64? offset, GPUSize64? size]);
  void setVertexBuffer(GPUIndex32 slot, GPUBuffer? buffer, [GPUSize64? offset, GPUSize64? size]);
  void draw(GPUSize32 vertexCount, [GPUSize32? instanceCount, GPUSize32? firstVertex, GPUSize32? firstInstance]);
  void drawIndexed(GPUSize32 indexCount, [GPUSize32? instanceCount, GPUSize32? firstIndex, GPUSignedOffset32? baseVertex, GPUSize32? firstInstance]);
  void drawIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  void drawIndexedIndirect(GPUBuffer indirectBuffer, GPUSize64 indirectOffset);
  void setViewport(double x, double y, double width, double height, double minDepth, double maxDepth);
  void setScissorRect(GPUIntegerCoordinate x, GPUIntegerCoordinate y, GPUIntegerCoordinate width, GPUIntegerCoordinate height);
  void setBlendConstant(GPUColor color);
  void setStencilReference(GPUStencilValue reference);
  void beginOcclusionQuery(GPUSize32 queryIndex);
  void endOcclusionQuery();
  void executeBundles(List<GPURenderBundle> bundles);
  void end();
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
  GPUQuerySet get querySet;
  set querySet(GPUQuerySet value);
  GPUSize32 get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32 value);
  GPUSize32 get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32 value);
}

abstract interface class GPURenderPipeline {
  String get label;
   set label(String value);
  GPUBindGroupLayout getBindGroupLayout(int index);
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
  String get featureLevel;
  set featureLevel(String value);
  GPUPowerPreference get powerPreference;
  set powerPreference(GPUPowerPreference value);
  bool get forceFallbackAdapter;
  set forceFallbackAdapter(bool value);
  bool get xrCompatible;
  set xrCompatible(bool value);
}

typedef GPUSampleMask = int;

abstract interface class GPUSampler {
  String get label;
   set label(String value);
}

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

abstract interface class GPUShaderModule {
  String get label;
   set label(String value);
  Future<GPUCompilationInfo> getCompilationInfo();
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
  List<GPUShaderModuleCompilationHint> get compilationHints;
  set compilationHints(List<GPUShaderModuleCompilationHint> value);
}

abstract final class GPUShaderStage {
  GPUShaderStage._();
  static const GPUFlagsConstant VERTEX =
      0x1;
  static const GPUFlagsConstant FRAGMENT =
      0x2;
  static const GPUFlagsConstant COMPUTE =
      0x4;
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

abstract interface class GPUSupportedFeatures {
   Iterable<String> get values;
   bool has(Object value);
}

abstract interface class GPUSupportedLimits {
  int get maxTextureDimension1D;
  int get maxTextureDimension2D;
  int get maxTextureDimension3D;
  int get maxTextureArrayLayers;
  int get maxBindGroups;
  int get maxBindGroupsPlusVertexBuffers;
  int get maxBindingsPerBindGroup;
  int get maxDynamicUniformBuffersPerPipelineLayout;
  int get maxDynamicStorageBuffersPerPipelineLayout;
  int get maxSampledTexturesPerShaderStage;
  int get maxSamplersPerShaderStage;
  int get maxStorageBuffersPerShaderStage;
  int get maxStorageTexturesPerShaderStage;
  int get maxUniformBuffersPerShaderStage;
  int get maxUniformBufferBindingSize;
  int get maxStorageBufferBindingSize;
  int get minUniformBufferOffsetAlignment;
  int get minStorageBufferOffsetAlignment;
  int get maxVertexBuffers;
  int get maxBufferSize;
  int get maxVertexAttributes;
  int get maxVertexBufferArrayStride;
  int get maxInterStageShaderVariables;
  int get maxColorAttachments;
  int get maxColorAttachmentBytesPerSample;
  int get maxComputeWorkgroupStorageSize;
  int get maxComputeInvocationsPerWorkgroup;
  int get maxComputeWorkgroupSizeX;
  int get maxComputeWorkgroupSizeY;
  int get maxComputeWorkgroupSizeZ;
  int get maxComputeWorkgroupsPerDimension;
}

abstract interface class GPUTexelCopyBufferInfo {
  GPUBuffer get buffer;
  set buffer(GPUBuffer value);
}

abstract interface class GPUTexelCopyBufferLayout {
  GPUSize64 get offset;
  set offset(GPUSize64 value);
  GPUSize32 get bytesPerRow;
  set bytesPerRow(GPUSize32 value);
  GPUSize32 get rowsPerImage;
  set rowsPerImage(GPUSize32 value);
}

abstract interface class GPUTexelCopyTextureInfo {
  GPUTexture get texture;
  set texture(GPUTexture value);
  GPUIntegerCoordinate get mipLevel;
  set mipLevel(GPUIntegerCoordinate value);
  GPUOrigin3D get origin;
  set origin(GPUOrigin3D value);
  GPUTextureAspect get aspect;
  set aspect(GPUTextureAspect value);
}

abstract interface class GPUTexture {
  String get label;
   set label(String value);
  GPUTextureView createView([GPUTextureViewDescriptor? descriptor]);
  void destroy();
  GPUIntegerCoordinateOut get width;
  GPUIntegerCoordinateOut get height;
  GPUIntegerCoordinateOut get depthOrArrayLayers;
  GPUIntegerCoordinateOut get mipLevelCount;
  GPUSize32Out get sampleCount;
  GPUTextureDimension get dimension;
  GPUTextureFormat get format;
  GPUFlagsConstant get usage;
}

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

abstract final class GPUTextureUsage {
  GPUTextureUsage._();
  static const GPUFlagsConstant COPY_SRC =
      0x01;
  static const GPUFlagsConstant COPY_DST =
      0x02;
  static const GPUFlagsConstant TEXTURE_BINDING =
      0x04;
  static const GPUFlagsConstant STORAGE_BINDING =
      0x08;
  static const GPUFlagsConstant RENDER_ATTACHMENT =
      0x10;
}

typedef GPUTextureUsageFlags = int;

abstract interface class GPUTextureView {
  String get label;
   set label(String value);
}

abstract interface class GPUTextureViewDescriptor {
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureViewDimension get dimension;
  set dimension(GPUTextureViewDimension value);
  GPUTextureUsageFlags get usage;
  set usage(GPUTextureUsageFlags value);
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

abstract interface class GPUUncapturedErrorEvent {
  GPUError get error;
}

abstract interface class GPUUncapturedErrorEventInit {
  GPUError get error;
  set error(GPUError value);
}

abstract interface class GPUValidationError {
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
  GPU get gpu;
}

abstract interface class WGSLLanguageFeatures {
   Iterable<String> get values;
   bool has(Object value);
}

