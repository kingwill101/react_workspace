// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webnn
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';

abstract interface class MLArgMinMaxOptions {
  List<int> get axes;
  set axes(List<int> value);
  bool get keepDimensions;
  set keepDimensions(bool value);
  bool get selectLastIndex;
  set selectLastIndex(bool value);
}

abstract interface class MLBatchNormalizationOptions {
  Object get scale;
  set scale(Object value);
  Object get bias;
  set bias(Object value);
  int get axis;
  set axis(int value);
  double get epsilon;
  set epsilon(double value);
}

abstract interface class MLClampOptions {
  double get minValue;
  set minValue(double value);
  double get maxValue;
  set maxValue(double value);
}

abstract interface class MLComputeResult {
  MLNamedArrayBufferViews get inputs;
  set inputs(MLNamedArrayBufferViews value);
  MLNamedArrayBufferViews get outputs;
  set outputs(MLNamedArrayBufferViews value);
}

abstract interface class MLContextOptions {
  MLDeviceType get deviceType;
  set deviceType(MLDeviceType value);
  MLPowerPreference get powerPreference;
  set powerPreference(MLPowerPreference value);
}

typedef MLConv2dFilterOperandLayout = String;

abstract interface class MLConv2dOptions {
  List<int> get padding;
  set padding(List<int> value);
  List<int> get strides;
  set strides(List<int> value);
  List<int> get dilations;
  set dilations(List<int> value);
  int get groups;
  set groups(int value);
  MLInputOperandLayout get inputLayout;
  set inputLayout(MLInputOperandLayout value);
  MLConv2dFilterOperandLayout get filterLayout;
  set filterLayout(MLConv2dFilterOperandLayout value);
  Object get bias;
  set bias(Object value);
}

typedef MLConvTranspose2dFilterOperandLayout = String;

abstract interface class MLConvTranspose2dOptions {
  List<int> get padding;
  set padding(List<int> value);
  List<int> get strides;
  set strides(List<int> value);
  List<int> get dilations;
  set dilations(List<int> value);
  List<int> get outputPadding;
  set outputPadding(List<int> value);
  List<int> get outputSizes;
  set outputSizes(List<int> value);
  int get groups;
  set groups(int value);
  MLInputOperandLayout get inputLayout;
  set inputLayout(MLInputOperandLayout value);
  MLConvTranspose2dFilterOperandLayout get filterLayout;
  set filterLayout(MLConvTranspose2dFilterOperandLayout value);
  Object get bias;
  set bias(Object value);
}

typedef MLDeviceType = String;

abstract interface class MLEluOptions {
  double get alpha;
  set alpha(double value);
}

abstract interface class MLGatherOptions {
  int get axis;
  set axis(int value);
}

abstract interface class MLGemmOptions {
  Object get c;
  set c(Object value);
  double get alpha;
  set alpha(double value);
  double get beta;
  set beta(double value);
  bool get aTranspose;
  set aTranspose(bool value);
  bool get bTranspose;
  set bTranspose(bool value);
}

abstract interface class MLGruCellOptions {
  Object get bias;
  set bias(Object value);
  Object get recurrentBias;
  set recurrentBias(Object value);
  bool get resetAfter;
  set resetAfter(bool value);
  MLGruWeightLayout get layout;
  set layout(MLGruWeightLayout value);
  List<Object> get activations;
  set activations(List<Object> value);
}

abstract interface class MLGruOptions {
  Object get bias;
  set bias(Object value);
  Object get recurrentBias;
  set recurrentBias(Object value);
  Object get initialHiddenState;
  set initialHiddenState(Object value);
  bool get resetAfter;
  set resetAfter(bool value);
  bool get returnSequence;
  set returnSequence(bool value);
  MLRecurrentNetworkDirection get direction;
  set direction(MLRecurrentNetworkDirection value);
  MLGruWeightLayout get layout;
  set layout(MLGruWeightLayout value);
  List<Object> get activations;
  set activations(List<Object> value);
}

typedef MLGruWeightLayout = String;

abstract interface class MLHardSigmoidOptions {
  double get alpha;
  set alpha(double value);
  double get beta;
  set beta(double value);
}

typedef MLInputOperandLayout = String;

abstract interface class MLInstanceNormalizationOptions {
  Object get scale;
  set scale(Object value);
  Object get bias;
  set bias(Object value);
  double get epsilon;
  set epsilon(double value);
  MLInputOperandLayout get layout;
  set layout(MLInputOperandLayout value);
}

typedef MLInterpolationMode = String;

abstract interface class MLLayerNormalizationOptions {
  Object get scale;
  set scale(Object value);
  Object get bias;
  set bias(Object value);
  List<int> get axes;
  set axes(List<int> value);
  double get epsilon;
  set epsilon(double value);
}

abstract interface class MLLeakyReluOptions {
  double get alpha;
  set alpha(double value);
}

abstract interface class MLLinearOptions {
  double get alpha;
  set alpha(double value);
  double get beta;
  set beta(double value);
}

abstract interface class MLLstmCellOptions {
  Object get bias;
  set bias(Object value);
  Object get recurrentBias;
  set recurrentBias(Object value);
  Object get peepholeWeight;
  set peepholeWeight(Object value);
  MLLstmWeightLayout get layout;
  set layout(MLLstmWeightLayout value);
  List<Object> get activations;
  set activations(List<Object> value);
}

abstract interface class MLLstmOptions {
  Object get bias;
  set bias(Object value);
  Object get recurrentBias;
  set recurrentBias(Object value);
  Object get peepholeWeight;
  set peepholeWeight(Object value);
  Object get initialHiddenState;
  set initialHiddenState(Object value);
  Object get initialCellState;
  set initialCellState(Object value);
  bool get returnSequence;
  set returnSequence(bool value);
  MLRecurrentNetworkDirection get direction;
  set direction(MLRecurrentNetworkDirection value);
  MLLstmWeightLayout get layout;
  set layout(MLLstmWeightLayout value);
  List<Object> get activations;
  set activations(List<Object> value);
}

typedef MLLstmWeightLayout = String;

typedef MLNamedArrayBufferViews = Map<String, ArrayBufferView>;

typedef MLNamedOperands = Map<String, Object>;

typedef MLOperandDataType = String;

abstract interface class MLOperandDescriptor {
  MLOperandDataType get dataType;
  set dataType(MLOperandDataType value);
  List<int> get dimensions;
  set dimensions(List<int> value);
}

abstract interface class MLPadOptions {
  MLPaddingMode get mode;
  set mode(MLPaddingMode value);
  double get value;
  set value(double value);
}

typedef MLPaddingMode = String;

abstract interface class MLPool2dOptions {
  List<int> get windowDimensions;
  set windowDimensions(List<int> value);
  List<int> get padding;
  set padding(List<int> value);
  List<int> get strides;
  set strides(List<int> value);
  List<int> get dilations;
  set dilations(List<int> value);
  MLInputOperandLayout get layout;
  set layout(MLInputOperandLayout value);
  MLRoundingType get roundingType;
  set roundingType(MLRoundingType value);
  List<int> get outputSizes;
  set outputSizes(List<int> value);
}

typedef MLPowerPreference = String;

typedef MLRecurrentNetworkDirection = String;

abstract interface class MLReduceOptions {
  List<int> get axes;
  set axes(List<int> value);
  bool get keepDimensions;
  set keepDimensions(bool value);
}

abstract interface class MLResample2dOptions {
  MLInterpolationMode get mode;
  set mode(MLInterpolationMode value);
  List<double> get scales;
  set scales(List<double> value);
  List<int> get sizes;
  set sizes(List<int> value);
  List<int> get axes;
  set axes(List<int> value);
}

typedef MLRoundingType = String;

abstract interface class MLSplitOptions {
  int get axis;
  set axis(int value);
}

abstract interface class MLTransposeOptions {
  List<int> get permutation;
  set permutation(List<int> value);
}

abstract interface class MLTriangularOptions {
  bool get upper;
  set upper(bool value);
  int get diagonal;
  set diagonal(int value);
}

abstract interface class NavigatorML {
  Object get ml;
}

