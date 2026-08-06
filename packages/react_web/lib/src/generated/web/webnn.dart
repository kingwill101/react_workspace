// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webnn
// ignore_for_file: type=lint

import 'webidl.dart';

abstract interface class MLArgMinMaxOptions {
  List<int>? get axes;
  set axes(List<int>? value);
  bool? get keepDimensions;
  set keepDimensions(bool? value);
  bool? get selectLastIndex;
  set selectLastIndex(bool? value);
}

final class MLArgMinMaxOptionsValue implements MLArgMinMaxOptions {
  @override
  List<int>? axes;
  @override
  bool? keepDimensions;
  @override
  bool? selectLastIndex;

  MLArgMinMaxOptionsValue({
    this.axes,
    this.keepDimensions,
    this.selectLastIndex,
  });
}

abstract interface class MLBatchNormalizationOptions {
  Object? get scale;
  set scale(Object? value);
  Object? get bias;
  set bias(Object? value);
  int? get axis;
  set axis(int? value);
  double? get epsilon;
  set epsilon(double? value);
}

final class MLBatchNormalizationOptionsValue implements MLBatchNormalizationOptions {
  @override
  Object? scale;
  @override
  Object? bias;
  @override
  int? axis;
  @override
  double? epsilon;

  MLBatchNormalizationOptionsValue({
    this.scale,
    this.bias,
    this.axis,
    this.epsilon,
  });
}

abstract interface class MLClampOptions {
  double? get minValue;
  set minValue(double? value);
  double? get maxValue;
  set maxValue(double? value);
}

final class MLClampOptionsValue implements MLClampOptions {
  @override
  double? minValue;
  @override
  double? maxValue;

  MLClampOptionsValue({
    this.minValue,
    this.maxValue,
  });
}

abstract interface class MLComputeResult {
  MLNamedArrayBufferViews? get inputs;
  set inputs(MLNamedArrayBufferViews? value);
  MLNamedArrayBufferViews? get outputs;
  set outputs(MLNamedArrayBufferViews? value);
}

final class MLComputeResultValue implements MLComputeResult {
  @override
  MLNamedArrayBufferViews? inputs;
  @override
  MLNamedArrayBufferViews? outputs;

  MLComputeResultValue({
    this.inputs,
    this.outputs,
  });
}

abstract interface class MLContextOptions {
  MLDeviceType? get deviceType;
  set deviceType(MLDeviceType? value);
  MLPowerPreference? get powerPreference;
  set powerPreference(MLPowerPreference? value);
}

final class MLContextOptionsValue implements MLContextOptions {
  @override
  MLDeviceType? deviceType;
  @override
  MLPowerPreference? powerPreference;

  MLContextOptionsValue({
    this.deviceType,
    this.powerPreference,
  });
}

typedef MLConv2dFilterOperandLayout = String;

abstract interface class MLConv2dOptions {
  List<int>? get padding;
  set padding(List<int>? value);
  List<int>? get strides;
  set strides(List<int>? value);
  List<int>? get dilations;
  set dilations(List<int>? value);
  int? get groups;
  set groups(int? value);
  MLInputOperandLayout? get inputLayout;
  set inputLayout(MLInputOperandLayout? value);
  MLConv2dFilterOperandLayout? get filterLayout;
  set filterLayout(MLConv2dFilterOperandLayout? value);
  Object? get bias;
  set bias(Object? value);
}

final class MLConv2dOptionsValue implements MLConv2dOptions {
  @override
  List<int>? padding;
  @override
  List<int>? strides;
  @override
  List<int>? dilations;
  @override
  int? groups;
  @override
  MLInputOperandLayout? inputLayout;
  @override
  MLConv2dFilterOperandLayout? filterLayout;
  @override
  Object? bias;

  MLConv2dOptionsValue({
    this.padding,
    this.strides,
    this.dilations,
    this.groups,
    this.inputLayout,
    this.filterLayout,
    this.bias,
  });
}

typedef MLConvTranspose2dFilterOperandLayout = String;

abstract interface class MLConvTranspose2dOptions {
  List<int>? get padding;
  set padding(List<int>? value);
  List<int>? get strides;
  set strides(List<int>? value);
  List<int>? get dilations;
  set dilations(List<int>? value);
  List<int>? get outputPadding;
  set outputPadding(List<int>? value);
  List<int>? get outputSizes;
  set outputSizes(List<int>? value);
  int? get groups;
  set groups(int? value);
  MLInputOperandLayout? get inputLayout;
  set inputLayout(MLInputOperandLayout? value);
  MLConvTranspose2dFilterOperandLayout? get filterLayout;
  set filterLayout(MLConvTranspose2dFilterOperandLayout? value);
  Object? get bias;
  set bias(Object? value);
}

final class MLConvTranspose2dOptionsValue implements MLConvTranspose2dOptions {
  @override
  List<int>? padding;
  @override
  List<int>? strides;
  @override
  List<int>? dilations;
  @override
  List<int>? outputPadding;
  @override
  List<int>? outputSizes;
  @override
  int? groups;
  @override
  MLInputOperandLayout? inputLayout;
  @override
  MLConvTranspose2dFilterOperandLayout? filterLayout;
  @override
  Object? bias;

  MLConvTranspose2dOptionsValue({
    this.padding,
    this.strides,
    this.dilations,
    this.outputPadding,
    this.outputSizes,
    this.groups,
    this.inputLayout,
    this.filterLayout,
    this.bias,
  });
}

typedef MLDeviceType = String;

abstract interface class MLEluOptions {
  double? get alpha;
  set alpha(double? value);
}

final class MLEluOptionsValue implements MLEluOptions {
  @override
  double? alpha;

  MLEluOptionsValue({
    this.alpha,
  });
}

abstract interface class MLGatherOptions {
  int? get axis;
  set axis(int? value);
}

final class MLGatherOptionsValue implements MLGatherOptions {
  @override
  int? axis;

  MLGatherOptionsValue({
    this.axis,
  });
}

abstract interface class MLGemmOptions {
  Object? get c;
  set c(Object? value);
  double? get alpha;
  set alpha(double? value);
  double? get beta;
  set beta(double? value);
  bool? get aTranspose;
  set aTranspose(bool? value);
  bool? get bTranspose;
  set bTranspose(bool? value);
}

final class MLGemmOptionsValue implements MLGemmOptions {
  @override
  Object? c;
  @override
  double? alpha;
  @override
  double? beta;
  @override
  bool? aTranspose;
  @override
  bool? bTranspose;

  MLGemmOptionsValue({
    this.c,
    this.alpha,
    this.beta,
    this.aTranspose,
    this.bTranspose,
  });
}

abstract interface class MLGruCellOptions {
  Object? get bias;
  set bias(Object? value);
  Object? get recurrentBias;
  set recurrentBias(Object? value);
  bool? get resetAfter;
  set resetAfter(bool? value);
  MLGruWeightLayout? get layout;
  set layout(MLGruWeightLayout? value);
  List<Object>? get activations;
  set activations(List<Object>? value);
}

final class MLGruCellOptionsValue implements MLGruCellOptions {
  @override
  Object? bias;
  @override
  Object? recurrentBias;
  @override
  bool? resetAfter;
  @override
  MLGruWeightLayout? layout;
  @override
  List<Object>? activations;

  MLGruCellOptionsValue({
    this.bias,
    this.recurrentBias,
    this.resetAfter,
    this.layout,
    this.activations,
  });
}

abstract interface class MLGruOptions {
  Object? get bias;
  set bias(Object? value);
  Object? get recurrentBias;
  set recurrentBias(Object? value);
  Object? get initialHiddenState;
  set initialHiddenState(Object? value);
  bool? get resetAfter;
  set resetAfter(bool? value);
  bool? get returnSequence;
  set returnSequence(bool? value);
  MLRecurrentNetworkDirection? get direction;
  set direction(MLRecurrentNetworkDirection? value);
  MLGruWeightLayout? get layout;
  set layout(MLGruWeightLayout? value);
  List<Object>? get activations;
  set activations(List<Object>? value);
}

final class MLGruOptionsValue implements MLGruOptions {
  @override
  Object? bias;
  @override
  Object? recurrentBias;
  @override
  Object? initialHiddenState;
  @override
  bool? resetAfter;
  @override
  bool? returnSequence;
  @override
  MLRecurrentNetworkDirection? direction;
  @override
  MLGruWeightLayout? layout;
  @override
  List<Object>? activations;

  MLGruOptionsValue({
    this.bias,
    this.recurrentBias,
    this.initialHiddenState,
    this.resetAfter,
    this.returnSequence,
    this.direction,
    this.layout,
    this.activations,
  });
}

typedef MLGruWeightLayout = String;

abstract interface class MLHardSigmoidOptions {
  double? get alpha;
  set alpha(double? value);
  double? get beta;
  set beta(double? value);
}

final class MLHardSigmoidOptionsValue implements MLHardSigmoidOptions {
  @override
  double? alpha;
  @override
  double? beta;

  MLHardSigmoidOptionsValue({
    this.alpha,
    this.beta,
  });
}

typedef MLInputOperandLayout = String;

abstract interface class MLInstanceNormalizationOptions {
  Object? get scale;
  set scale(Object? value);
  Object? get bias;
  set bias(Object? value);
  double? get epsilon;
  set epsilon(double? value);
  MLInputOperandLayout? get layout;
  set layout(MLInputOperandLayout? value);
}

final class MLInstanceNormalizationOptionsValue implements MLInstanceNormalizationOptions {
  @override
  Object? scale;
  @override
  Object? bias;
  @override
  double? epsilon;
  @override
  MLInputOperandLayout? layout;

  MLInstanceNormalizationOptionsValue({
    this.scale,
    this.bias,
    this.epsilon,
    this.layout,
  });
}

typedef MLInterpolationMode = String;

abstract interface class MLLayerNormalizationOptions {
  Object? get scale;
  set scale(Object? value);
  Object? get bias;
  set bias(Object? value);
  List<int>? get axes;
  set axes(List<int>? value);
  double? get epsilon;
  set epsilon(double? value);
}

final class MLLayerNormalizationOptionsValue implements MLLayerNormalizationOptions {
  @override
  Object? scale;
  @override
  Object? bias;
  @override
  List<int>? axes;
  @override
  double? epsilon;

  MLLayerNormalizationOptionsValue({
    this.scale,
    this.bias,
    this.axes,
    this.epsilon,
  });
}

abstract interface class MLLeakyReluOptions {
  double? get alpha;
  set alpha(double? value);
}

final class MLLeakyReluOptionsValue implements MLLeakyReluOptions {
  @override
  double? alpha;

  MLLeakyReluOptionsValue({
    this.alpha,
  });
}

abstract interface class MLLinearOptions {
  double? get alpha;
  set alpha(double? value);
  double? get beta;
  set beta(double? value);
}

final class MLLinearOptionsValue implements MLLinearOptions {
  @override
  double? alpha;
  @override
  double? beta;

  MLLinearOptionsValue({
    this.alpha,
    this.beta,
  });
}

abstract interface class MLLstmCellOptions {
  Object? get bias;
  set bias(Object? value);
  Object? get recurrentBias;
  set recurrentBias(Object? value);
  Object? get peepholeWeight;
  set peepholeWeight(Object? value);
  MLLstmWeightLayout? get layout;
  set layout(MLLstmWeightLayout? value);
  List<Object>? get activations;
  set activations(List<Object>? value);
}

final class MLLstmCellOptionsValue implements MLLstmCellOptions {
  @override
  Object? bias;
  @override
  Object? recurrentBias;
  @override
  Object? peepholeWeight;
  @override
  MLLstmWeightLayout? layout;
  @override
  List<Object>? activations;

  MLLstmCellOptionsValue({
    this.bias,
    this.recurrentBias,
    this.peepholeWeight,
    this.layout,
    this.activations,
  });
}

abstract interface class MLLstmOptions {
  Object? get bias;
  set bias(Object? value);
  Object? get recurrentBias;
  set recurrentBias(Object? value);
  Object? get peepholeWeight;
  set peepholeWeight(Object? value);
  Object? get initialHiddenState;
  set initialHiddenState(Object? value);
  Object? get initialCellState;
  set initialCellState(Object? value);
  bool? get returnSequence;
  set returnSequence(bool? value);
  MLRecurrentNetworkDirection? get direction;
  set direction(MLRecurrentNetworkDirection? value);
  MLLstmWeightLayout? get layout;
  set layout(MLLstmWeightLayout? value);
  List<Object>? get activations;
  set activations(List<Object>? value);
}

final class MLLstmOptionsValue implements MLLstmOptions {
  @override
  Object? bias;
  @override
  Object? recurrentBias;
  @override
  Object? peepholeWeight;
  @override
  Object? initialHiddenState;
  @override
  Object? initialCellState;
  @override
  bool? returnSequence;
  @override
  MLRecurrentNetworkDirection? direction;
  @override
  MLLstmWeightLayout? layout;
  @override
  List<Object>? activations;

  MLLstmOptionsValue({
    this.bias,
    this.recurrentBias,
    this.peepholeWeight,
    this.initialHiddenState,
    this.initialCellState,
    this.returnSequence,
    this.direction,
    this.layout,
    this.activations,
  });
}

typedef MLLstmWeightLayout = String;

typedef MLNamedArrayBufferViews = Map<String, ArrayBufferView>;

typedef MLNamedOperands = Map<String, Object>;

typedef MLOperandDataType = String;

abstract interface class MLOperandDescriptor {
  MLOperandDataType get dataType;
  set dataType(MLOperandDataType value);
  List<int>? get dimensions;
  set dimensions(List<int>? value);
}

final class MLOperandDescriptorValue implements MLOperandDescriptor {
  @override
  MLOperandDataType dataType;
  @override
  List<int>? dimensions;

  MLOperandDescriptorValue({
    required this.dataType,
    this.dimensions,
  });
}

abstract interface class MLPadOptions {
  MLPaddingMode? get mode;
  set mode(MLPaddingMode? value);
  double? get value;
  set value(double? value);
}

final class MLPadOptionsValue implements MLPadOptions {
  @override
  MLPaddingMode? mode;
  @override
  double? value;

  MLPadOptionsValue({
    this.mode,
    this.value,
  });
}

typedef MLPaddingMode = String;

abstract interface class MLPool2dOptions {
  List<int>? get windowDimensions;
  set windowDimensions(List<int>? value);
  List<int>? get padding;
  set padding(List<int>? value);
  List<int>? get strides;
  set strides(List<int>? value);
  List<int>? get dilations;
  set dilations(List<int>? value);
  MLInputOperandLayout? get layout;
  set layout(MLInputOperandLayout? value);
  MLRoundingType? get roundingType;
  set roundingType(MLRoundingType? value);
  List<int>? get outputSizes;
  set outputSizes(List<int>? value);
}

final class MLPool2dOptionsValue implements MLPool2dOptions {
  @override
  List<int>? windowDimensions;
  @override
  List<int>? padding;
  @override
  List<int>? strides;
  @override
  List<int>? dilations;
  @override
  MLInputOperandLayout? layout;
  @override
  MLRoundingType? roundingType;
  @override
  List<int>? outputSizes;

  MLPool2dOptionsValue({
    this.windowDimensions,
    this.padding,
    this.strides,
    this.dilations,
    this.layout,
    this.roundingType,
    this.outputSizes,
  });
}

typedef MLPowerPreference = String;

typedef MLRecurrentNetworkDirection = String;

abstract interface class MLReduceOptions {
  List<int>? get axes;
  set axes(List<int>? value);
  bool? get keepDimensions;
  set keepDimensions(bool? value);
}

final class MLReduceOptionsValue implements MLReduceOptions {
  @override
  List<int>? axes;
  @override
  bool? keepDimensions;

  MLReduceOptionsValue({
    this.axes,
    this.keepDimensions,
  });
}

abstract interface class MLResample2dOptions {
  MLInterpolationMode? get mode;
  set mode(MLInterpolationMode? value);
  List<double>? get scales;
  set scales(List<double>? value);
  List<int>? get sizes;
  set sizes(List<int>? value);
  List<int>? get axes;
  set axes(List<int>? value);
}

final class MLResample2dOptionsValue implements MLResample2dOptions {
  @override
  MLInterpolationMode? mode;
  @override
  List<double>? scales;
  @override
  List<int>? sizes;
  @override
  List<int>? axes;

  MLResample2dOptionsValue({
    this.mode,
    this.scales,
    this.sizes,
    this.axes,
  });
}

typedef MLRoundingType = String;

abstract interface class MLSplitOptions {
  int? get axis;
  set axis(int? value);
}

final class MLSplitOptionsValue implements MLSplitOptions {
  @override
  int? axis;

  MLSplitOptionsValue({
    this.axis,
  });
}

abstract interface class MLTransposeOptions {
  List<int>? get permutation;
  set permutation(List<int>? value);
}

final class MLTransposeOptionsValue implements MLTransposeOptions {
  @override
  List<int>? permutation;

  MLTransposeOptionsValue({
    this.permutation,
  });
}

abstract interface class MLTriangularOptions {
  bool? get upper;
  set upper(bool? value);
  int? get diagonal;
  set diagonal(int? value);
}

final class MLTriangularOptionsValue implements MLTriangularOptions {
  @override
  bool? upper;
  @override
  int? diagonal;

  MLTriangularOptionsValue({
    this.upper,
    this.diagonal,
  });
}

abstract interface class NavigatorML {
  Object get ml;
}

