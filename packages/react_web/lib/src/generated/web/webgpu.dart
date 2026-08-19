// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webgpu
// ignore_for_file: type=lint

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

final class GPUBindGroupDescriptorValue implements GPUBindGroupDescriptor {
  @override
  Object layout;
  @override
  List<GPUBindGroupEntry> entries;

  GPUBindGroupDescriptorValue({
    required this.layout,
    required this.entries,
  });
}

abstract interface class GPUBindGroupEntry {
  GPUIndex32 get binding;
  set binding(GPUIndex32 value);
  GPUBindingResource get resource;
  set resource(GPUBindingResource value);
}

final class GPUBindGroupEntryValue implements GPUBindGroupEntry {
  @override
  GPUIndex32 binding;
  @override
  GPUBindingResource resource;

  GPUBindGroupEntryValue({
    required this.binding,
    required this.resource,
  });
}

abstract interface class GPUBindGroupLayoutDescriptor {
  List<GPUBindGroupLayoutEntry> get entries;
  set entries(List<GPUBindGroupLayoutEntry> value);
}

final class GPUBindGroupLayoutDescriptorValue implements GPUBindGroupLayoutDescriptor {
  @override
  List<GPUBindGroupLayoutEntry> entries;

  GPUBindGroupLayoutDescriptorValue({
    required this.entries,
  });
}

abstract interface class GPUBindGroupLayoutEntry {
  GPUIndex32 get binding;
  set binding(GPUIndex32 value);
  GPUShaderStageFlags get visibility;
  set visibility(GPUShaderStageFlags value);
  GPUBufferBindingLayout? get buffer;
  set buffer(GPUBufferBindingLayout? value);
  GPUSamplerBindingLayout? get sampler;
  set sampler(GPUSamplerBindingLayout? value);
  GPUTextureBindingLayout? get texture;
  set texture(GPUTextureBindingLayout? value);
  GPUStorageTextureBindingLayout? get storageTexture;
  set storageTexture(GPUStorageTextureBindingLayout? value);
  GPUExternalTextureBindingLayout? get externalTexture;
  set externalTexture(GPUExternalTextureBindingLayout? value);
}

final class GPUBindGroupLayoutEntryValue implements GPUBindGroupLayoutEntry {
  @override
  GPUIndex32 binding;
  @override
  GPUShaderStageFlags visibility;
  @override
  GPUBufferBindingLayout? buffer;
  @override
  GPUSamplerBindingLayout? sampler;
  @override
  GPUTextureBindingLayout? texture;
  @override
  GPUStorageTextureBindingLayout? storageTexture;
  @override
  GPUExternalTextureBindingLayout? externalTexture;

  GPUBindGroupLayoutEntryValue({
    required this.binding,
    required this.visibility,
    this.buffer,
    this.sampler,
    this.texture,
    this.storageTexture,
    this.externalTexture,
  });
}

abstract interface class GPUBindingCommandsMixin {
  void setBindGroup(GPUIndex32 index, Object bindGroup, Object dynamicOffsetsData, GPUSize64 dynamicOffsetsDataStart, GPUSize32 dynamicOffsetsDataLength);
}

typedef GPUBindingResource = Object;

abstract interface class GPUBlendComponent {
  GPUBlendOperation? get operation;
  set operation(GPUBlendOperation? value);
  GPUBlendFactor? get srcFactor;
  set srcFactor(GPUBlendFactor? value);
  GPUBlendFactor? get dstFactor;
  set dstFactor(GPUBlendFactor? value);
}

final class GPUBlendComponentValue implements GPUBlendComponent {
  @override
  GPUBlendOperation? operation;
  @override
  GPUBlendFactor? srcFactor;
  @override
  GPUBlendFactor? dstFactor;

  GPUBlendComponentValue({
    this.operation,
    this.srcFactor,
    this.dstFactor,
  });
}

typedef GPUBlendFactor = String;

typedef GPUBlendOperation = String;

abstract interface class GPUBlendState {
  GPUBlendComponent get color;
  set color(GPUBlendComponent value);
  GPUBlendComponent get alpha;
  set alpha(GPUBlendComponent value);
}

final class GPUBlendStateValue implements GPUBlendState {
  @override
  GPUBlendComponent color;
  @override
  GPUBlendComponent alpha;

  GPUBlendStateValue({
    required this.color,
    required this.alpha,
  });
}

abstract interface class GPUBufferBinding {
  Object get buffer;
  set buffer(Object value);
  GPUSize64? get offset;
  set offset(GPUSize64? value);
  GPUSize64? get size;
  set size(GPUSize64? value);
}

final class GPUBufferBindingValue implements GPUBufferBinding {
  @override
  Object buffer;
  @override
  GPUSize64? offset;
  @override
  GPUSize64? size;

  GPUBufferBindingValue({
    required this.buffer,
    this.offset,
    this.size,
  });
}

abstract interface class GPUBufferBindingLayout {
  GPUBufferBindingType? get type_;
  set type_(GPUBufferBindingType? value);
  bool? get hasDynamicOffset;
  set hasDynamicOffset(bool? value);
  GPUSize64? get minBindingSize;
  set minBindingSize(GPUSize64? value);
}

final class GPUBufferBindingLayoutValue implements GPUBufferBindingLayout {
  @override
  GPUBufferBindingType? type_;
  @override
  bool? hasDynamicOffset;
  @override
  GPUSize64? minBindingSize;

  GPUBufferBindingLayoutValue({
    this.type_,
    this.hasDynamicOffset,
    this.minBindingSize,
  });
}

typedef GPUBufferBindingType = String;

abstract interface class GPUBufferDescriptor {
  GPUSize64 get size;
  set size(GPUSize64 value);
  GPUBufferUsageFlags get usage;
  set usage(GPUBufferUsageFlags value);
  bool? get mappedAtCreation;
  set mappedAtCreation(bool? value);
}

final class GPUBufferDescriptorValue implements GPUBufferDescriptor {
  @override
  GPUSize64 size;
  @override
  GPUBufferUsageFlags usage;
  @override
  bool? mappedAtCreation;

  GPUBufferDescriptorValue({
    required this.size,
    required this.usage,
    this.mappedAtCreation,
  });
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
  GPUTextureUsageFlags? get usage;
  set usage(GPUTextureUsageFlags? value);
  List<GPUTextureFormat>? get viewFormats;
  set viewFormats(List<GPUTextureFormat>? value);
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
  GPUCanvasAlphaMode? get alphaMode;
  set alphaMode(GPUCanvasAlphaMode? value);
}

final class GPUCanvasConfigurationValue implements GPUCanvasConfiguration {
  @override
  Object device;
  @override
  GPUTextureFormat format;
  @override
  GPUTextureUsageFlags? usage;
  @override
  List<GPUTextureFormat>? viewFormats;
  @override
  PredefinedColorSpace? colorSpace;
  @override
  GPUCanvasAlphaMode? alphaMode;

  GPUCanvasConfigurationValue({
    required this.device,
    required this.format,
    this.usage,
    this.viewFormats,
    this.colorSpace,
    this.alphaMode,
  });
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

final class GPUColorDictValue implements GPUColorDict {
  @override
  double r;
  @override
  double g;
  @override
  double b;
  @override
  double a;

  GPUColorDictValue({
    required this.r,
    required this.g,
    required this.b,
    required this.a,
  });
}

abstract interface class GPUColorTargetState {
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUBlendState? get blend;
  set blend(GPUBlendState? value);
  GPUColorWriteFlags? get writeMask;
  set writeMask(GPUColorWriteFlags? value);
}

final class GPUColorTargetStateValue implements GPUColorTargetState {
  @override
  GPUTextureFormat format;
  @override
  GPUBlendState? blend;
  @override
  GPUColorWriteFlags? writeMask;

  GPUColorTargetStateValue({
    required this.format,
    this.blend,
    this.writeMask,
  });
}

typedef GPUColorWriteFlags = int;

abstract interface class GPUCommandBufferDescriptor {
}

final class GPUCommandBufferDescriptorValue implements GPUCommandBufferDescriptor {

  GPUCommandBufferDescriptorValue();
}

abstract interface class GPUCommandEncoderDescriptor {
}

final class GPUCommandEncoderDescriptorValue implements GPUCommandEncoderDescriptor {

  GPUCommandEncoderDescriptorValue();
}

abstract interface class GPUCommandsMixin {
}

typedef GPUCompareFunction = String;

typedef GPUCompilationMessageType = String;

abstract interface class GPUComputePassDescriptor {
  GPUComputePassTimestampWrites? get timestampWrites;
  set timestampWrites(GPUComputePassTimestampWrites? value);
}

final class GPUComputePassDescriptorValue implements GPUComputePassDescriptor {
  @override
  GPUComputePassTimestampWrites? timestampWrites;

  GPUComputePassDescriptorValue({
    this.timestampWrites,
  });
}

abstract interface class GPUComputePassTimestampWrites {
  Object get querySet;
  set querySet(Object value);
  GPUSize32? get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32? value);
  GPUSize32? get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32? value);
}

final class GPUComputePassTimestampWritesValue implements GPUComputePassTimestampWrites {
  @override
  Object querySet;
  @override
  GPUSize32? beginningOfPassWriteIndex;
  @override
  GPUSize32? endOfPassWriteIndex;

  GPUComputePassTimestampWritesValue({
    required this.querySet,
    this.beginningOfPassWriteIndex,
    this.endOfPassWriteIndex,
  });
}

abstract interface class GPUComputePipelineDescriptor {
  GPUProgrammableStage get compute;
  set compute(GPUProgrammableStage value);
}

final class GPUComputePipelineDescriptorValue implements GPUComputePipelineDescriptor {
  @override
  GPUProgrammableStage compute;

  GPUComputePipelineDescriptorValue({
    required this.compute,
  });
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
  bool? get depthWriteEnabled;
  set depthWriteEnabled(bool? value);
  GPUCompareFunction? get depthCompare;
  set depthCompare(GPUCompareFunction? value);
  GPUStencilFaceState? get stencilFront;
  set stencilFront(GPUStencilFaceState? value);
  GPUStencilFaceState? get stencilBack;
  set stencilBack(GPUStencilFaceState? value);
  GPUStencilValue? get stencilReadMask;
  set stencilReadMask(GPUStencilValue? value);
  GPUStencilValue? get stencilWriteMask;
  set stencilWriteMask(GPUStencilValue? value);
  GPUDepthBias? get depthBias;
  set depthBias(GPUDepthBias? value);
  double? get depthBiasSlopeScale;
  set depthBiasSlopeScale(double? value);
  double? get depthBiasClamp;
  set depthBiasClamp(double? value);
}

final class GPUDepthStencilStateValue implements GPUDepthStencilState {
  @override
  GPUTextureFormat format;
  @override
  bool? depthWriteEnabled;
  @override
  GPUCompareFunction? depthCompare;
  @override
  GPUStencilFaceState? stencilFront;
  @override
  GPUStencilFaceState? stencilBack;
  @override
  GPUStencilValue? stencilReadMask;
  @override
  GPUStencilValue? stencilWriteMask;
  @override
  GPUDepthBias? depthBias;
  @override
  double? depthBiasSlopeScale;
  @override
  double? depthBiasClamp;

  GPUDepthStencilStateValue({
    required this.format,
    this.depthWriteEnabled,
    this.depthCompare,
    this.stencilFront,
    this.stencilBack,
    this.stencilReadMask,
    this.stencilWriteMask,
    this.depthBias,
    this.depthBiasSlopeScale,
    this.depthBiasClamp,
  });
}

abstract interface class GPUDeviceDescriptor {
  List<GPUFeatureName>? get requiredFeatures;
  set requiredFeatures(List<GPUFeatureName>? value);
  Map<String, GPUSize64>? get requiredLimits;
  set requiredLimits(Map<String, GPUSize64>? value);
  GPUQueueDescriptor? get defaultQueue;
  set defaultQueue(GPUQueueDescriptor? value);
}

final class GPUDeviceDescriptorValue implements GPUDeviceDescriptor {
  @override
  List<GPUFeatureName>? requiredFeatures;
  @override
  Map<String, GPUSize64>? requiredLimits;
  @override
  GPUQueueDescriptor? defaultQueue;

  GPUDeviceDescriptorValue({
    this.requiredFeatures,
    this.requiredLimits,
    this.defaultQueue,
  });
}

typedef GPUDeviceLostReason = String;

typedef GPUErrorFilter = String;

typedef GPUExtent3D = Object;

abstract interface class GPUExtent3DDict {
  GPUIntegerCoordinate get width;
  set width(GPUIntegerCoordinate value);
  GPUIntegerCoordinate? get height;
  set height(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get depthOrArrayLayers;
  set depthOrArrayLayers(GPUIntegerCoordinate? value);
}

final class GPUExtent3DDictValue implements GPUExtent3DDict {
  @override
  GPUIntegerCoordinate width;
  @override
  GPUIntegerCoordinate? height;
  @override
  GPUIntegerCoordinate? depthOrArrayLayers;

  GPUExtent3DDictValue({
    required this.width,
    this.height,
    this.depthOrArrayLayers,
  });
}

abstract interface class GPUExternalTextureBindingLayout {
}

final class GPUExternalTextureBindingLayoutValue implements GPUExternalTextureBindingLayout {

  GPUExternalTextureBindingLayoutValue();
}

abstract interface class GPUExternalTextureDescriptor {
  Object get source;
  set source(Object value);
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
}

final class GPUExternalTextureDescriptorValue implements GPUExternalTextureDescriptor {
  @override
  Object source;
  @override
  PredefinedColorSpace? colorSpace;

  GPUExternalTextureDescriptorValue({
    required this.source,
    this.colorSpace,
  });
}

typedef GPUFeatureName = String;

typedef GPUFilterMode = String;

typedef GPUFlagsConstant = int;

abstract interface class GPUFragmentState {
  List<GPUColorTargetState?> get targets;
  set targets(List<GPUColorTargetState?> value);
}

final class GPUFragmentStateValue implements GPUFragmentState {
  @override
  List<GPUColorTargetState?> targets;

  GPUFragmentStateValue({
    required this.targets,
  });
}

typedef GPUFrontFace = String;

abstract interface class GPUImageCopyBuffer {
  Object get buffer;
  set buffer(Object value);
}

final class GPUImageCopyBufferValue implements GPUImageCopyBuffer {
  @override
  Object buffer;

  GPUImageCopyBufferValue({
    required this.buffer,
  });
}

abstract interface class GPUImageCopyExternalImage {
  GPUImageCopyExternalImageSource get source;
  set source(GPUImageCopyExternalImageSource value);
  GPUOrigin2D? get origin;
  set origin(GPUOrigin2D? value);
  bool? get flipY;
  set flipY(bool? value);
}

final class GPUImageCopyExternalImageValue implements GPUImageCopyExternalImage {
  @override
  GPUImageCopyExternalImageSource source;
  @override
  GPUOrigin2D? origin;
  @override
  bool? flipY;

  GPUImageCopyExternalImageValue({
    required this.source,
    this.origin,
    this.flipY,
  });
}

typedef GPUImageCopyExternalImageSource = Object;

abstract interface class GPUImageCopyTexture {
  Object get texture;
  set texture(Object value);
  GPUIntegerCoordinate? get mipLevel;
  set mipLevel(GPUIntegerCoordinate? value);
  GPUOrigin3D? get origin;
  set origin(GPUOrigin3D? value);
  GPUTextureAspect? get aspect;
  set aspect(GPUTextureAspect? value);
}

final class GPUImageCopyTextureValue implements GPUImageCopyTexture {
  @override
  Object texture;
  @override
  GPUIntegerCoordinate? mipLevel;
  @override
  GPUOrigin3D? origin;
  @override
  GPUTextureAspect? aspect;

  GPUImageCopyTextureValue({
    required this.texture,
    this.mipLevel,
    this.origin,
    this.aspect,
  });
}

abstract interface class GPUImageCopyTextureTagged {
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
  bool? get premultipliedAlpha;
  set premultipliedAlpha(bool? value);
}

final class GPUImageCopyTextureTaggedValue implements GPUImageCopyTextureTagged {
  @override
  PredefinedColorSpace? colorSpace;
  @override
  bool? premultipliedAlpha;

  GPUImageCopyTextureTaggedValue({
    this.colorSpace,
    this.premultipliedAlpha,
  });
}

abstract interface class GPUImageDataLayout {
  GPUSize64? get offset;
  set offset(GPUSize64? value);
  GPUSize32? get bytesPerRow;
  set bytesPerRow(GPUSize32? value);
  GPUSize32? get rowsPerImage;
  set rowsPerImage(GPUSize32? value);
}

final class GPUImageDataLayoutValue implements GPUImageDataLayout {
  @override
  GPUSize64? offset;
  @override
  GPUSize32? bytesPerRow;
  @override
  GPUSize32? rowsPerImage;

  GPUImageDataLayoutValue({
    this.offset,
    this.bytesPerRow,
    this.rowsPerImage,
  });
}

typedef GPUIndex32 = int;

typedef GPUIndexFormat = String;

typedef GPUIntegerCoordinate = int;

typedef GPUIntegerCoordinateOut = int;

typedef GPULoadOp = String;

typedef GPUMapModeFlags = int;

typedef GPUMipmapFilterMode = String;

abstract interface class GPUMultisampleState {
  GPUSize32? get count;
  set count(GPUSize32? value);
  GPUSampleMask? get mask;
  set mask(GPUSampleMask? value);
  bool? get alphaToCoverageEnabled;
  set alphaToCoverageEnabled(bool? value);
}

final class GPUMultisampleStateValue implements GPUMultisampleState {
  @override
  GPUSize32? count;
  @override
  GPUSampleMask? mask;
  @override
  bool? alphaToCoverageEnabled;

  GPUMultisampleStateValue({
    this.count,
    this.mask,
    this.alphaToCoverageEnabled,
  });
}

abstract interface class GPUObjectBase {
  String get label;
   set label(String value);
}

abstract interface class GPUObjectDescriptorBase {
  String? get label;
  set label(String? value);
}

final class GPUObjectDescriptorBaseValue implements GPUObjectDescriptorBase {
  @override
  String? label;

  GPUObjectDescriptorBaseValue({
    this.label,
  });
}

typedef GPUOrigin2D = Object;

abstract interface class GPUOrigin2DDict {
  GPUIntegerCoordinate? get x;
  set x(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get y;
  set y(GPUIntegerCoordinate? value);
}

final class GPUOrigin2DDictValue implements GPUOrigin2DDict {
  @override
  GPUIntegerCoordinate? x;
  @override
  GPUIntegerCoordinate? y;

  GPUOrigin2DDictValue({
    this.x,
    this.y,
  });
}

typedef GPUOrigin3D = Object;

abstract interface class GPUOrigin3DDict {
  GPUIntegerCoordinate? get x;
  set x(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get y;
  set y(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get z;
  set z(GPUIntegerCoordinate? value);
}

final class GPUOrigin3DDictValue implements GPUOrigin3DDict {
  @override
  GPUIntegerCoordinate? x;
  @override
  GPUIntegerCoordinate? y;
  @override
  GPUIntegerCoordinate? z;

  GPUOrigin3DDictValue({
    this.x,
    this.y,
    this.z,
  });
}

abstract interface class GPUPipelineBase {
  Object getBindGroupLayout(int index);
}

typedef GPUPipelineConstantValue = double;

abstract interface class GPUPipelineDescriptorBase {
  Object get layout;
  set layout(Object value);
}

final class GPUPipelineDescriptorBaseValue implements GPUPipelineDescriptorBase {
  @override
  Object layout;

  GPUPipelineDescriptorBaseValue({
    required this.layout,
  });
}

abstract interface class GPUPipelineErrorInit {
  GPUPipelineErrorReason get reason;
  set reason(GPUPipelineErrorReason value);
}

final class GPUPipelineErrorInitValue implements GPUPipelineErrorInit {
  @override
  GPUPipelineErrorReason reason;

  GPUPipelineErrorInitValue({
    required this.reason,
  });
}

typedef GPUPipelineErrorReason = String;

abstract interface class GPUPipelineLayoutDescriptor {
  List<Object> get bindGroupLayouts;
  set bindGroupLayouts(List<Object> value);
}

final class GPUPipelineLayoutDescriptorValue implements GPUPipelineLayoutDescriptor {
  @override
  List<Object> bindGroupLayouts;

  GPUPipelineLayoutDescriptorValue({
    required this.bindGroupLayouts,
  });
}

typedef GPUPowerPreference = String;

abstract interface class GPUPrimitiveState {
  GPUPrimitiveTopology? get topology;
  set topology(GPUPrimitiveTopology? value);
  GPUIndexFormat? get stripIndexFormat;
  set stripIndexFormat(GPUIndexFormat? value);
  GPUFrontFace? get frontFace;
  set frontFace(GPUFrontFace? value);
  GPUCullMode? get cullMode;
  set cullMode(GPUCullMode? value);
  bool? get unclippedDepth;
  set unclippedDepth(bool? value);
}

final class GPUPrimitiveStateValue implements GPUPrimitiveState {
  @override
  GPUPrimitiveTopology? topology;
  @override
  GPUIndexFormat? stripIndexFormat;
  @override
  GPUFrontFace? frontFace;
  @override
  GPUCullMode? cullMode;
  @override
  bool? unclippedDepth;

  GPUPrimitiveStateValue({
    this.topology,
    this.stripIndexFormat,
    this.frontFace,
    this.cullMode,
    this.unclippedDepth,
  });
}

typedef GPUPrimitiveTopology = String;

abstract interface class GPUProgrammableStage {
  Object get module;
  set module(Object value);
  String? get entryPoint;
  set entryPoint(String? value);
  Map<String, GPUPipelineConstantValue>? get constants;
  set constants(Map<String, GPUPipelineConstantValue>? value);
}

final class GPUProgrammableStageValue implements GPUProgrammableStage {
  @override
  Object module;
  @override
  String? entryPoint;
  @override
  Map<String, GPUPipelineConstantValue>? constants;

  GPUProgrammableStageValue({
    required this.module,
    this.entryPoint,
    this.constants,
  });
}

abstract interface class GPUQuerySetDescriptor {
  GPUQueryType get type_;
  set type_(GPUQueryType value);
  GPUSize32 get count;
  set count(GPUSize32 value);
}

final class GPUQuerySetDescriptorValue implements GPUQuerySetDescriptor {
  @override
  GPUQueryType type_;
  @override
  GPUSize32 count;

  GPUQuerySetDescriptorValue({
    required this.type_,
    required this.count,
  });
}

typedef GPUQueryType = String;

abstract interface class GPUQueueDescriptor {
}

final class GPUQueueDescriptorValue implements GPUQueueDescriptor {

  GPUQueueDescriptorValue();
}

abstract interface class GPURenderBundleDescriptor {
}

final class GPURenderBundleDescriptorValue implements GPURenderBundleDescriptor {

  GPURenderBundleDescriptorValue();
}

abstract interface class GPURenderBundleEncoderDescriptor {
  bool? get depthReadOnly;
  set depthReadOnly(bool? value);
  bool? get stencilReadOnly;
  set stencilReadOnly(bool? value);
}

final class GPURenderBundleEncoderDescriptorValue implements GPURenderBundleEncoderDescriptor {
  @override
  bool? depthReadOnly;
  @override
  bool? stencilReadOnly;

  GPURenderBundleEncoderDescriptorValue({
    this.depthReadOnly,
    this.stencilReadOnly,
  });
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
  GPUIntegerCoordinate? get depthSlice;
  set depthSlice(GPUIntegerCoordinate? value);
  Object? get resolveTarget;
  set resolveTarget(Object? value);
  GPUColor? get clearValue;
  set clearValue(GPUColor? value);
  GPULoadOp get loadOp;
  set loadOp(GPULoadOp value);
  GPUStoreOp get storeOp;
  set storeOp(GPUStoreOp value);
}

final class GPURenderPassColorAttachmentValue implements GPURenderPassColorAttachment {
  @override
  Object view;
  @override
  GPUIntegerCoordinate? depthSlice;
  @override
  Object? resolveTarget;
  @override
  GPUColor? clearValue;
  @override
  GPULoadOp loadOp;
  @override
  GPUStoreOp storeOp;

  GPURenderPassColorAttachmentValue({
    required this.view,
    this.depthSlice,
    this.resolveTarget,
    this.clearValue,
    required this.loadOp,
    required this.storeOp,
  });
}

abstract interface class GPURenderPassDepthStencilAttachment {
  Object get view;
  set view(Object value);
  double? get depthClearValue;
  set depthClearValue(double? value);
  GPULoadOp? get depthLoadOp;
  set depthLoadOp(GPULoadOp? value);
  GPUStoreOp? get depthStoreOp;
  set depthStoreOp(GPUStoreOp? value);
  bool? get depthReadOnly;
  set depthReadOnly(bool? value);
  GPUStencilValue? get stencilClearValue;
  set stencilClearValue(GPUStencilValue? value);
  GPULoadOp? get stencilLoadOp;
  set stencilLoadOp(GPULoadOp? value);
  GPUStoreOp? get stencilStoreOp;
  set stencilStoreOp(GPUStoreOp? value);
  bool? get stencilReadOnly;
  set stencilReadOnly(bool? value);
}

final class GPURenderPassDepthStencilAttachmentValue implements GPURenderPassDepthStencilAttachment {
  @override
  Object view;
  @override
  double? depthClearValue;
  @override
  GPULoadOp? depthLoadOp;
  @override
  GPUStoreOp? depthStoreOp;
  @override
  bool? depthReadOnly;
  @override
  GPUStencilValue? stencilClearValue;
  @override
  GPULoadOp? stencilLoadOp;
  @override
  GPUStoreOp? stencilStoreOp;
  @override
  bool? stencilReadOnly;

  GPURenderPassDepthStencilAttachmentValue({
    required this.view,
    this.depthClearValue,
    this.depthLoadOp,
    this.depthStoreOp,
    this.depthReadOnly,
    this.stencilClearValue,
    this.stencilLoadOp,
    this.stencilStoreOp,
    this.stencilReadOnly,
  });
}

abstract interface class GPURenderPassDescriptor {
  List<GPURenderPassColorAttachment?> get colorAttachments;
  set colorAttachments(List<GPURenderPassColorAttachment?> value);
  GPURenderPassDepthStencilAttachment? get depthStencilAttachment;
  set depthStencilAttachment(GPURenderPassDepthStencilAttachment? value);
  Object? get occlusionQuerySet;
  set occlusionQuerySet(Object? value);
  GPURenderPassTimestampWrites? get timestampWrites;
  set timestampWrites(GPURenderPassTimestampWrites? value);
  GPUSize64? get maxDrawCount;
  set maxDrawCount(GPUSize64? value);
}

final class GPURenderPassDescriptorValue implements GPURenderPassDescriptor {
  @override
  List<GPURenderPassColorAttachment?> colorAttachments;
  @override
  GPURenderPassDepthStencilAttachment? depthStencilAttachment;
  @override
  Object? occlusionQuerySet;
  @override
  GPURenderPassTimestampWrites? timestampWrites;
  @override
  GPUSize64? maxDrawCount;

  GPURenderPassDescriptorValue({
    required this.colorAttachments,
    this.depthStencilAttachment,
    this.occlusionQuerySet,
    this.timestampWrites,
    this.maxDrawCount,
  });
}

abstract interface class GPURenderPassLayout {
  List<GPUTextureFormat?> get colorFormats;
  set colorFormats(List<GPUTextureFormat?> value);
  GPUTextureFormat? get depthStencilFormat;
  set depthStencilFormat(GPUTextureFormat? value);
  GPUSize32? get sampleCount;
  set sampleCount(GPUSize32? value);
}

final class GPURenderPassLayoutValue implements GPURenderPassLayout {
  @override
  List<GPUTextureFormat?> colorFormats;
  @override
  GPUTextureFormat? depthStencilFormat;
  @override
  GPUSize32? sampleCount;

  GPURenderPassLayoutValue({
    required this.colorFormats,
    this.depthStencilFormat,
    this.sampleCount,
  });
}

abstract interface class GPURenderPassTimestampWrites {
  Object get querySet;
  set querySet(Object value);
  GPUSize32? get beginningOfPassWriteIndex;
  set beginningOfPassWriteIndex(GPUSize32? value);
  GPUSize32? get endOfPassWriteIndex;
  set endOfPassWriteIndex(GPUSize32? value);
}

final class GPURenderPassTimestampWritesValue implements GPURenderPassTimestampWrites {
  @override
  Object querySet;
  @override
  GPUSize32? beginningOfPassWriteIndex;
  @override
  GPUSize32? endOfPassWriteIndex;

  GPURenderPassTimestampWritesValue({
    required this.querySet,
    this.beginningOfPassWriteIndex,
    this.endOfPassWriteIndex,
  });
}

abstract interface class GPURenderPipelineDescriptor {
  GPUVertexState get vertex;
  set vertex(GPUVertexState value);
  GPUPrimitiveState? get primitive;
  set primitive(GPUPrimitiveState? value);
  GPUDepthStencilState? get depthStencil;
  set depthStencil(GPUDepthStencilState? value);
  GPUMultisampleState? get multisample;
  set multisample(GPUMultisampleState? value);
  GPUFragmentState? get fragment;
  set fragment(GPUFragmentState? value);
}

final class GPURenderPipelineDescriptorValue implements GPURenderPipelineDescriptor {
  @override
  GPUVertexState vertex;
  @override
  GPUPrimitiveState? primitive;
  @override
  GPUDepthStencilState? depthStencil;
  @override
  GPUMultisampleState? multisample;
  @override
  GPUFragmentState? fragment;

  GPURenderPipelineDescriptorValue({
    required this.vertex,
    this.primitive,
    this.depthStencil,
    this.multisample,
    this.fragment,
  });
}

abstract interface class GPURequestAdapterOptions {
  GPUPowerPreference? get powerPreference;
  set powerPreference(GPUPowerPreference? value);
  bool? get forceFallbackAdapter;
  set forceFallbackAdapter(bool? value);
}

final class GPURequestAdapterOptionsValue implements GPURequestAdapterOptions {
  @override
  GPUPowerPreference? powerPreference;
  @override
  bool? forceFallbackAdapter;

  GPURequestAdapterOptionsValue({
    this.powerPreference,
    this.forceFallbackAdapter,
  });
}

typedef GPUSampleMask = int;

abstract interface class GPUSamplerBindingLayout {
  GPUSamplerBindingType? get type_;
  set type_(GPUSamplerBindingType? value);
}

final class GPUSamplerBindingLayoutValue implements GPUSamplerBindingLayout {
  @override
  GPUSamplerBindingType? type_;

  GPUSamplerBindingLayoutValue({
    this.type_,
  });
}

typedef GPUSamplerBindingType = String;

abstract interface class GPUSamplerDescriptor {
  GPUAddressMode? get addressModeU;
  set addressModeU(GPUAddressMode? value);
  GPUAddressMode? get addressModeV;
  set addressModeV(GPUAddressMode? value);
  GPUAddressMode? get addressModeW;
  set addressModeW(GPUAddressMode? value);
  GPUFilterMode? get magFilter;
  set magFilter(GPUFilterMode? value);
  GPUFilterMode? get minFilter;
  set minFilter(GPUFilterMode? value);
  GPUMipmapFilterMode? get mipmapFilter;
  set mipmapFilter(GPUMipmapFilterMode? value);
  double? get lodMinClamp;
  set lodMinClamp(double? value);
  double? get lodMaxClamp;
  set lodMaxClamp(double? value);
  GPUCompareFunction? get compare;
  set compare(GPUCompareFunction? value);
  int? get maxAnisotropy;
  set maxAnisotropy(int? value);
}

final class GPUSamplerDescriptorValue implements GPUSamplerDescriptor {
  @override
  GPUAddressMode? addressModeU;
  @override
  GPUAddressMode? addressModeV;
  @override
  GPUAddressMode? addressModeW;
  @override
  GPUFilterMode? magFilter;
  @override
  GPUFilterMode? minFilter;
  @override
  GPUMipmapFilterMode? mipmapFilter;
  @override
  double? lodMinClamp;
  @override
  double? lodMaxClamp;
  @override
  GPUCompareFunction? compare;
  @override
  int? maxAnisotropy;

  GPUSamplerDescriptorValue({
    this.addressModeU,
    this.addressModeV,
    this.addressModeW,
    this.magFilter,
    this.minFilter,
    this.mipmapFilter,
    this.lodMinClamp,
    this.lodMaxClamp,
    this.compare,
    this.maxAnisotropy,
  });
}

abstract interface class GPUShaderModuleCompilationHint {
  String get entryPoint;
  set entryPoint(String value);
  Object? get layout;
  set layout(Object? value);
}

final class GPUShaderModuleCompilationHintValue implements GPUShaderModuleCompilationHint {
  @override
  String entryPoint;
  @override
  Object? layout;

  GPUShaderModuleCompilationHintValue({
    required this.entryPoint,
    this.layout,
  });
}

abstract interface class GPUShaderModuleDescriptor {
  String get code;
  set code(String value);
  Object? get sourceMap;
  set sourceMap(Object? value);
  List<GPUShaderModuleCompilationHint>? get compilationHints;
  set compilationHints(List<GPUShaderModuleCompilationHint>? value);
}

final class GPUShaderModuleDescriptorValue implements GPUShaderModuleDescriptor {
  @override
  String code;
  @override
  Object? sourceMap;
  @override
  List<GPUShaderModuleCompilationHint>? compilationHints;

  GPUShaderModuleDescriptorValue({
    required this.code,
    this.sourceMap,
    this.compilationHints,
  });
}

typedef GPUShaderStageFlags = int;

typedef GPUSignedOffset32 = int;

typedef GPUSize32 = int;

typedef GPUSize32Out = int;

typedef GPUSize64 = int;

typedef GPUSize64Out = int;

abstract interface class GPUStencilFaceState {
  GPUCompareFunction? get compare;
  set compare(GPUCompareFunction? value);
  GPUStencilOperation? get failOp;
  set failOp(GPUStencilOperation? value);
  GPUStencilOperation? get depthFailOp;
  set depthFailOp(GPUStencilOperation? value);
  GPUStencilOperation? get passOp;
  set passOp(GPUStencilOperation? value);
}

final class GPUStencilFaceStateValue implements GPUStencilFaceState {
  @override
  GPUCompareFunction? compare;
  @override
  GPUStencilOperation? failOp;
  @override
  GPUStencilOperation? depthFailOp;
  @override
  GPUStencilOperation? passOp;

  GPUStencilFaceStateValue({
    this.compare,
    this.failOp,
    this.depthFailOp,
    this.passOp,
  });
}

typedef GPUStencilOperation = String;

typedef GPUStencilValue = int;

typedef GPUStorageTextureAccess = String;

abstract interface class GPUStorageTextureBindingLayout {
  GPUStorageTextureAccess? get access;
  set access(GPUStorageTextureAccess? value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureViewDimension? get viewDimension;
  set viewDimension(GPUTextureViewDimension? value);
}

final class GPUStorageTextureBindingLayoutValue implements GPUStorageTextureBindingLayout {
  @override
  GPUStorageTextureAccess? access;
  @override
  GPUTextureFormat format;
  @override
  GPUTextureViewDimension? viewDimension;

  GPUStorageTextureBindingLayoutValue({
    this.access,
    required this.format,
    this.viewDimension,
  });
}

typedef GPUStoreOp = String;

typedef GPUTextureAspect = String;

abstract interface class GPUTextureBindingLayout {
  GPUTextureSampleType? get sampleType;
  set sampleType(GPUTextureSampleType? value);
  GPUTextureViewDimension? get viewDimension;
  set viewDimension(GPUTextureViewDimension? value);
  bool? get multisampled;
  set multisampled(bool? value);
}

final class GPUTextureBindingLayoutValue implements GPUTextureBindingLayout {
  @override
  GPUTextureSampleType? sampleType;
  @override
  GPUTextureViewDimension? viewDimension;
  @override
  bool? multisampled;

  GPUTextureBindingLayoutValue({
    this.sampleType,
    this.viewDimension,
    this.multisampled,
  });
}

abstract interface class GPUTextureDescriptor {
  GPUExtent3D get size;
  set size(GPUExtent3D value);
  GPUIntegerCoordinate? get mipLevelCount;
  set mipLevelCount(GPUIntegerCoordinate? value);
  GPUSize32? get sampleCount;
  set sampleCount(GPUSize32? value);
  GPUTextureDimension? get dimension;
  set dimension(GPUTextureDimension? value);
  GPUTextureFormat get format;
  set format(GPUTextureFormat value);
  GPUTextureUsageFlags get usage;
  set usage(GPUTextureUsageFlags value);
  List<GPUTextureFormat>? get viewFormats;
  set viewFormats(List<GPUTextureFormat>? value);
}

final class GPUTextureDescriptorValue implements GPUTextureDescriptor {
  @override
  GPUExtent3D size;
  @override
  GPUIntegerCoordinate? mipLevelCount;
  @override
  GPUSize32? sampleCount;
  @override
  GPUTextureDimension? dimension;
  @override
  GPUTextureFormat format;
  @override
  GPUTextureUsageFlags usage;
  @override
  List<GPUTextureFormat>? viewFormats;

  GPUTextureDescriptorValue({
    required this.size,
    this.mipLevelCount,
    this.sampleCount,
    this.dimension,
    required this.format,
    required this.usage,
    this.viewFormats,
  });
}

typedef GPUTextureDimension = String;

typedef GPUTextureFormat = String;

typedef GPUTextureSampleType = String;

typedef GPUTextureUsageFlags = int;

abstract interface class GPUTextureViewDescriptor {
  GPUTextureFormat? get format;
  set format(GPUTextureFormat? value);
  GPUTextureViewDimension? get dimension;
  set dimension(GPUTextureViewDimension? value);
  GPUTextureAspect? get aspect;
  set aspect(GPUTextureAspect? value);
  GPUIntegerCoordinate? get baseMipLevel;
  set baseMipLevel(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get mipLevelCount;
  set mipLevelCount(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get baseArrayLayer;
  set baseArrayLayer(GPUIntegerCoordinate? value);
  GPUIntegerCoordinate? get arrayLayerCount;
  set arrayLayerCount(GPUIntegerCoordinate? value);
}

final class GPUTextureViewDescriptorValue implements GPUTextureViewDescriptor {
  @override
  GPUTextureFormat? format;
  @override
  GPUTextureViewDimension? dimension;
  @override
  GPUTextureAspect? aspect;
  @override
  GPUIntegerCoordinate? baseMipLevel;
  @override
  GPUIntegerCoordinate? mipLevelCount;
  @override
  GPUIntegerCoordinate? baseArrayLayer;
  @override
  GPUIntegerCoordinate? arrayLayerCount;

  GPUTextureViewDescriptorValue({
    this.format,
    this.dimension,
    this.aspect,
    this.baseMipLevel,
    this.mipLevelCount,
    this.baseArrayLayer,
    this.arrayLayerCount,
  });
}

typedef GPUTextureViewDimension = String;

abstract interface class GPUUncapturedErrorEventInit {
  Object get error;
  set error(Object value);
}

final class GPUUncapturedErrorEventInitValue implements GPUUncapturedErrorEventInit {
  @override
  Object error;

  GPUUncapturedErrorEventInitValue({
    required this.error,
  });
}

abstract interface class GPUVertexAttribute {
  GPUVertexFormat get format;
  set format(GPUVertexFormat value);
  GPUSize64 get offset;
  set offset(GPUSize64 value);
  GPUIndex32 get shaderLocation;
  set shaderLocation(GPUIndex32 value);
}

final class GPUVertexAttributeValue implements GPUVertexAttribute {
  @override
  GPUVertexFormat format;
  @override
  GPUSize64 offset;
  @override
  GPUIndex32 shaderLocation;

  GPUVertexAttributeValue({
    required this.format,
    required this.offset,
    required this.shaderLocation,
  });
}

abstract interface class GPUVertexBufferLayout {
  GPUSize64 get arrayStride;
  set arrayStride(GPUSize64 value);
  GPUVertexStepMode? get stepMode;
  set stepMode(GPUVertexStepMode? value);
  List<GPUVertexAttribute> get attributes;
  set attributes(List<GPUVertexAttribute> value);
}

final class GPUVertexBufferLayoutValue implements GPUVertexBufferLayout {
  @override
  GPUSize64 arrayStride;
  @override
  GPUVertexStepMode? stepMode;
  @override
  List<GPUVertexAttribute> attributes;

  GPUVertexBufferLayoutValue({
    required this.arrayStride,
    this.stepMode,
    required this.attributes,
  });
}

typedef GPUVertexFormat = String;

abstract interface class GPUVertexState {
  List<GPUVertexBufferLayout?>? get buffers;
  set buffers(List<GPUVertexBufferLayout?>? value);
}

final class GPUVertexStateValue implements GPUVertexState {
  @override
  List<GPUVertexBufferLayout?>? buffers;

  GPUVertexStateValue({
    this.buffers,
  });
}

typedef GPUVertexStepMode = String;

abstract interface class NavigatorGPU {
  Object get gpu;
}

