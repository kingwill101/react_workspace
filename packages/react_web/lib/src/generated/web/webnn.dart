// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webnn
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webgpu.dart';
import 'webidl.dart';

abstract interface class ML {
  Future<MLContext> createContext([MLContextOptions? options]);
}

abstract interface class MLArgMinMaxOptions {
  bool get keepDimensions;
  set keepDimensions(bool value);
  MLOperandDataType get outputDataType;
  set outputDataType(MLOperandDataType value);
}

abstract interface class MLBatchNormalizationOptions {
  MLOperand get scale;
  set scale(MLOperand value);
  MLOperand get bias;
  set bias(MLOperand value);
  int get axis;
  set axis(int value);
  double get epsilon;
  set epsilon(double value);
}

abstract interface class MLBatchNormalizationSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get mean;
  set mean(MLSupportLimits value);
  MLSupportLimits get variance;
  set variance(MLSupportLimits value);
  MLSupportLimits get scale;
  set scale(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLBinarySupportLimits {
  MLSupportLimits get a;
  set a(MLSupportLimits value);
  MLSupportLimits get b;
  set b(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLClampOptions {
  MLNumber get minValue;
  set minValue(MLNumber value);
  MLNumber get maxValue;
  set maxValue(MLNumber value);
}

abstract interface class MLConcatSupportLimits {
  MLSupportLimits get inputs;
  set inputs(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLContext {
  void dispatch(MLGraph graph, MLNamedTensors inputs, MLNamedTensors outputs);
  Future<MLTensor> createTensor(MLTensorDescriptor descriptor);
  Future<void> readTensor(MLTensor tensor, AllowSharedBufferSource outputData);
  void writeTensor(MLTensor tensor, AllowSharedBufferSource inputData);
  MLOpSupportLimits opSupportLimits();
  void destroy();
  Future<MLContextLostInfo> get lost;
}

abstract interface class MLContextLostInfo {
  String get message;
  set message(String value);
}

abstract interface class MLContextOptions {
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
  MLOperand get bias;
  set bias(MLOperand value);
}

abstract interface class MLConv2dSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get filter;
  set filter(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
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
  MLOperand get bias;
  set bias(MLOperand value);
}

abstract interface class MLEluOptions {
  double get alpha;
  set alpha(double value);
}

abstract interface class MLGatherOptions {
  int get axis;
  set axis(int value);
}

abstract interface class MLGatherSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get indices;
  set indices(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLGemmOptions {
  MLOperand get c;
  set c(MLOperand value);
  double get alpha;
  set alpha(double value);
  double get beta;
  set beta(double value);
  bool get aTranspose;
  set aTranspose(bool value);
  bool get bTranspose;
  set bTranspose(bool value);
}

abstract interface class MLGemmSupportLimits {
  MLSupportLimits get a;
  set a(MLSupportLimits value);
  MLSupportLimits get b;
  set b(MLSupportLimits value);
  MLSupportLimits get c;
  set c(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLGraph {
  void destroy();
}

abstract interface class MLGraphBuilder {
  MLOperand input(String name, MLOperandDescriptor descriptor);
  MLOperand constant(MLOperandDescriptor descriptor, AllowSharedBufferSource buffer);
  Future<MLGraph> build(MLNamedOperands outputs);
  MLOperand argMin(MLOperand input, int axis, [MLArgMinMaxOptions? options]);
  MLOperand argMax(MLOperand input, int axis, [MLArgMinMaxOptions? options]);
  MLOperand batchNormalization(MLOperand input, MLOperand mean, MLOperand variance, [MLBatchNormalizationOptions? options]);
  MLOperand cast(MLOperand input, MLOperandDataType type, [MLOperatorOptions? options]);
  MLOperand clamp(MLOperand input, [MLClampOptions? options]);
  MLOperand concat(List<MLOperand> inputs, int axis, [MLOperatorOptions? options]);
  MLOperand conv2d(MLOperand input, MLOperand filter, [MLConv2dOptions? options]);
  MLOperand convTranspose2d(MLOperand input, MLOperand filter, [MLConvTranspose2dOptions? options]);
  MLOperand add(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand sub(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand mul(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand div(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand max(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand min(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand pow(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand equal(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand greater(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand greaterOrEqual(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand lesser(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand lesserOrEqual(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand logicalNot(MLOperand a, [MLOperatorOptions? options]);
  MLOperand abs(MLOperand input, [MLOperatorOptions? options]);
  MLOperand ceil(MLOperand input, [MLOperatorOptions? options]);
  MLOperand cos(MLOperand input, [MLOperatorOptions? options]);
  MLOperand erf(MLOperand input, [MLOperatorOptions? options]);
  MLOperand exp(MLOperand input, [MLOperatorOptions? options]);
  MLOperand floor(MLOperand input, [MLOperatorOptions? options]);
  MLOperand identity(MLOperand input, [MLOperatorOptions? options]);
  MLOperand log(MLOperand input, [MLOperatorOptions? options]);
  MLOperand neg(MLOperand input, [MLOperatorOptions? options]);
  MLOperand reciprocal(MLOperand input, [MLOperatorOptions? options]);
  MLOperand sin(MLOperand input, [MLOperatorOptions? options]);
  MLOperand sqrt(MLOperand input, [MLOperatorOptions? options]);
  MLOperand tan(MLOperand input, [MLOperatorOptions? options]);
  MLOperand elu(MLOperand input, [MLEluOptions? options]);
  MLOperand expand(MLOperand input, List<int> newShape, [MLOperatorOptions? options]);
  MLOperand gather(MLOperand input, MLOperand indices, [MLGatherOptions? options]);
  MLOperand gelu(MLOperand input, [MLOperatorOptions? options]);
  MLOperand gemm(MLOperand a, MLOperand b, [MLGemmOptions? options]);
  List<MLOperand> gru(MLOperand input, MLOperand weight, MLOperand recurrentWeight, int steps, int hiddenSize, [MLGruOptions? options]);
  MLOperand gruCell(MLOperand input, MLOperand weight, MLOperand recurrentWeight, MLOperand hiddenState, int hiddenSize, [MLGruCellOptions? options]);
  MLOperand hardSigmoid(MLOperand input, [MLHardSigmoidOptions? options]);
  MLOperand hardSwish(MLOperand input, [MLOperatorOptions? options]);
  MLOperand instanceNormalization(MLOperand input, [MLInstanceNormalizationOptions? options]);
  MLOperand layerNormalization(MLOperand input, [MLLayerNormalizationOptions? options]);
  MLOperand leakyRelu(MLOperand input, [MLLeakyReluOptions? options]);
  MLOperand linear(MLOperand input, [MLLinearOptions? options]);
  List<MLOperand> lstm(MLOperand input, MLOperand weight, MLOperand recurrentWeight, int steps, int hiddenSize, [MLLstmOptions? options]);
  List<MLOperand> lstmCell(MLOperand input, MLOperand weight, MLOperand recurrentWeight, MLOperand hiddenState, MLOperand cellState, int hiddenSize, [MLLstmCellOptions? options]);
  MLOperand matmul(MLOperand a, MLOperand b, [MLOperatorOptions? options]);
  MLOperand pad(MLOperand input, List<int> beginningPadding, List<int> endingPadding, [MLPadOptions? options]);
  MLOperand averagePool2d(MLOperand input, [MLPool2dOptions? options]);
  MLOperand l2Pool2d(MLOperand input, [MLPool2dOptions? options]);
  MLOperand maxPool2d(MLOperand input, [MLPool2dOptions? options]);
  MLOperand prelu(MLOperand input, MLOperand slope, [MLOperatorOptions? options]);
  MLOperand reduceL1(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceL2(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceLogSum(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceLogSumExp(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceMax(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceMean(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceMin(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceProduct(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceSum(MLOperand input, [MLReduceOptions? options]);
  MLOperand reduceSumSquare(MLOperand input, [MLReduceOptions? options]);
  MLOperand relu(MLOperand input, [MLOperatorOptions? options]);
  MLOperand resample2d(MLOperand input, [MLResample2dOptions? options]);
  MLOperand reshape(MLOperand input, List<int> newShape, [MLOperatorOptions? options]);
  MLOperand sigmoid(MLOperand input, [MLOperatorOptions? options]);
  MLOperand slice(MLOperand input, List<int> starts, List<int> sizes, [MLOperatorOptions? options]);
  MLOperand softmax(MLOperand input, int axis, [MLOperatorOptions? options]);
  MLOperand softplus(MLOperand input, [MLOperatorOptions? options]);
  MLOperand softsign(MLOperand input, [MLOperatorOptions? options]);
  List<MLOperand> split(MLOperand input, Object splits, [MLSplitOptions? options]);
  MLOperand tanh(MLOperand input, [MLOperatorOptions? options]);
  MLOperand transpose(MLOperand input, [MLTransposeOptions? options]);
  MLOperand triangular(MLOperand input, [MLTriangularOptions? options]);
  MLOperand where(MLOperand condition, MLOperand trueValue, MLOperand falseValue, [MLOperatorOptions? options]);
}

abstract interface class MLGruCellOptions {
  MLOperand get bias;
  set bias(MLOperand value);
  MLOperand get recurrentBias;
  set recurrentBias(MLOperand value);
  bool get resetAfter;
  set resetAfter(bool value);
  MLGruWeightLayout get layout;
  set layout(MLGruWeightLayout value);
  List<MLRecurrentNetworkActivation> get activations;
  set activations(List<MLRecurrentNetworkActivation> value);
}

abstract interface class MLGruCellSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get weight;
  set weight(MLSupportLimits value);
  MLSupportLimits get recurrentWeight;
  set recurrentWeight(MLSupportLimits value);
  MLSupportLimits get hiddenState;
  set hiddenState(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get recurrentBias;
  set recurrentBias(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLGruOptions {
  MLOperand get bias;
  set bias(MLOperand value);
  MLOperand get recurrentBias;
  set recurrentBias(MLOperand value);
  MLOperand get initialHiddenState;
  set initialHiddenState(MLOperand value);
  bool get resetAfter;
  set resetAfter(bool value);
  bool get returnSequence;
  set returnSequence(bool value);
  MLRecurrentNetworkDirection get direction;
  set direction(MLRecurrentNetworkDirection value);
  MLGruWeightLayout get layout;
  set layout(MLGruWeightLayout value);
  List<MLRecurrentNetworkActivation> get activations;
  set activations(List<MLRecurrentNetworkActivation> value);
}

abstract interface class MLGruSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get weight;
  set weight(MLSupportLimits value);
  MLSupportLimits get recurrentWeight;
  set recurrentWeight(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get recurrentBias;
  set recurrentBias(MLSupportLimits value);
  MLSupportLimits get initialHiddenState;
  set initialHiddenState(MLSupportLimits value);
  MLSupportLimits get outputs;
  set outputs(MLSupportLimits value);
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
  MLOperand get scale;
  set scale(MLOperand value);
  MLOperand get bias;
  set bias(MLOperand value);
  double get epsilon;
  set epsilon(double value);
  MLInputOperandLayout get layout;
  set layout(MLInputOperandLayout value);
}

typedef MLInterpolationMode = String;

abstract interface class MLLayerNormalizationOptions {
  MLOperand get scale;
  set scale(MLOperand value);
  MLOperand get bias;
  set bias(MLOperand value);
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

abstract interface class MLLogicalNotSupportLimits {
  MLSupportLimits get a;
  set a(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLLstmCellOptions {
  MLOperand get bias;
  set bias(MLOperand value);
  MLOperand get recurrentBias;
  set recurrentBias(MLOperand value);
  MLOperand get peepholeWeight;
  set peepholeWeight(MLOperand value);
  MLLstmWeightLayout get layout;
  set layout(MLLstmWeightLayout value);
  List<MLRecurrentNetworkActivation> get activations;
  set activations(List<MLRecurrentNetworkActivation> value);
}

abstract interface class MLLstmCellSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get weight;
  set weight(MLSupportLimits value);
  MLSupportLimits get recurrentWeight;
  set recurrentWeight(MLSupportLimits value);
  MLSupportLimits get hiddenState;
  set hiddenState(MLSupportLimits value);
  MLSupportLimits get cellState;
  set cellState(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get recurrentBias;
  set recurrentBias(MLSupportLimits value);
  MLSupportLimits get peepholeWeight;
  set peepholeWeight(MLSupportLimits value);
  MLSupportLimits get outputs;
  set outputs(MLSupportLimits value);
}

abstract interface class MLLstmOptions {
  MLOperand get bias;
  set bias(MLOperand value);
  MLOperand get recurrentBias;
  set recurrentBias(MLOperand value);
  MLOperand get peepholeWeight;
  set peepholeWeight(MLOperand value);
  MLOperand get initialHiddenState;
  set initialHiddenState(MLOperand value);
  MLOperand get initialCellState;
  set initialCellState(MLOperand value);
  bool get returnSequence;
  set returnSequence(bool value);
  MLRecurrentNetworkDirection get direction;
  set direction(MLRecurrentNetworkDirection value);
  MLLstmWeightLayout get layout;
  set layout(MLLstmWeightLayout value);
  List<MLRecurrentNetworkActivation> get activations;
  set activations(List<MLRecurrentNetworkActivation> value);
}

abstract interface class MLLstmSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get weight;
  set weight(MLSupportLimits value);
  MLSupportLimits get recurrentWeight;
  set recurrentWeight(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get recurrentBias;
  set recurrentBias(MLSupportLimits value);
  MLSupportLimits get peepholeWeight;
  set peepholeWeight(MLSupportLimits value);
  MLSupportLimits get initialHiddenState;
  set initialHiddenState(MLSupportLimits value);
  MLSupportLimits get initialCellState;
  set initialCellState(MLSupportLimits value);
  MLSupportLimits get outputs;
  set outputs(MLSupportLimits value);
}

typedef MLLstmWeightLayout = String;

typedef MLNamedOperands = Map<String, MLOperand>;

typedef MLNamedTensors = Map<String, MLTensor>;

abstract interface class MLNormalizationSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get scale;
  set scale(MLSupportLimits value);
  MLSupportLimits get bias;
  set bias(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

typedef MLNumber = Object;

abstract interface class MLOpSupportLimits {
  MLInputOperandLayout get preferredInputLayout;
  set preferredInputLayout(MLInputOperandLayout value);
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get constant;
  set constant(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
  MLSingleInputSupportLimits get argMin;
  set argMin(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get argMax;
  set argMax(MLSingleInputSupportLimits value);
  MLBatchNormalizationSupportLimits get batchNormalization;
  set batchNormalization(MLBatchNormalizationSupportLimits value);
  MLSingleInputSupportLimits get cast;
  set cast(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get clamp;
  set clamp(MLSingleInputSupportLimits value);
  MLConcatSupportLimits get concat;
  set concat(MLConcatSupportLimits value);
  MLConv2dSupportLimits get conv2d;
  set conv2d(MLConv2dSupportLimits value);
  MLConv2dSupportLimits get convTranspose2d;
  set convTranspose2d(MLConv2dSupportLimits value);
  MLBinarySupportLimits get add;
  set add(MLBinarySupportLimits value);
  MLBinarySupportLimits get sub;
  set sub(MLBinarySupportLimits value);
  MLBinarySupportLimits get mul;
  set mul(MLBinarySupportLimits value);
  MLBinarySupportLimits get div;
  set div(MLBinarySupportLimits value);
  MLBinarySupportLimits get max;
  set max(MLBinarySupportLimits value);
  MLBinarySupportLimits get min;
  set min(MLBinarySupportLimits value);
  MLBinarySupportLimits get pow;
  set pow(MLBinarySupportLimits value);
  MLBinarySupportLimits get equal;
  set equal(MLBinarySupportLimits value);
  MLBinarySupportLimits get greater;
  set greater(MLBinarySupportLimits value);
  MLBinarySupportLimits get greaterOrEqual;
  set greaterOrEqual(MLBinarySupportLimits value);
  MLBinarySupportLimits get lesser;
  set lesser(MLBinarySupportLimits value);
  MLBinarySupportLimits get lesserOrEqual;
  set lesserOrEqual(MLBinarySupportLimits value);
  MLLogicalNotSupportLimits get logicalNot;
  set logicalNot(MLLogicalNotSupportLimits value);
  MLSingleInputSupportLimits get abs;
  set abs(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get ceil;
  set ceil(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get cos;
  set cos(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get erf;
  set erf(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get exp;
  set exp(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get floor;
  set floor(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get identity;
  set identity(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get log;
  set log(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get neg;
  set neg(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reciprocal;
  set reciprocal(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get sin;
  set sin(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get sqrt;
  set sqrt(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get tan;
  set tan(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get elu;
  set elu(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get expand;
  set expand(MLSingleInputSupportLimits value);
  MLGatherSupportLimits get gather;
  set gather(MLGatherSupportLimits value);
  MLSingleInputSupportLimits get gelu;
  set gelu(MLSingleInputSupportLimits value);
  MLGemmSupportLimits get gemm;
  set gemm(MLGemmSupportLimits value);
  MLGruSupportLimits get gru;
  set gru(MLGruSupportLimits value);
  MLGruCellSupportLimits get gruCell;
  set gruCell(MLGruCellSupportLimits value);
  MLSingleInputSupportLimits get hardSigmoid;
  set hardSigmoid(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get hardSwish;
  set hardSwish(MLSingleInputSupportLimits value);
  MLNormalizationSupportLimits get instanceNormalization;
  set instanceNormalization(MLNormalizationSupportLimits value);
  MLNormalizationSupportLimits get layerNormalization;
  set layerNormalization(MLNormalizationSupportLimits value);
  MLSingleInputSupportLimits get leakyRelu;
  set leakyRelu(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get linear;
  set linear(MLSingleInputSupportLimits value);
  MLLstmSupportLimits get lstm;
  set lstm(MLLstmSupportLimits value);
  MLLstmCellSupportLimits get lstmCell;
  set lstmCell(MLLstmCellSupportLimits value);
  MLBinarySupportLimits get matmul;
  set matmul(MLBinarySupportLimits value);
  MLSingleInputSupportLimits get pad;
  set pad(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get averagePool2d;
  set averagePool2d(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get l2Pool2d;
  set l2Pool2d(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get maxPool2d;
  set maxPool2d(MLSingleInputSupportLimits value);
  MLPreluSupportLimits get prelu;
  set prelu(MLPreluSupportLimits value);
  MLSingleInputSupportLimits get reduceL1;
  set reduceL1(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceL2;
  set reduceL2(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceLogSum;
  set reduceLogSum(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceLogSumExp;
  set reduceLogSumExp(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceMax;
  set reduceMax(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceMean;
  set reduceMean(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceMin;
  set reduceMin(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceProduct;
  set reduceProduct(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceSum;
  set reduceSum(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reduceSumSquare;
  set reduceSumSquare(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get relu;
  set relu(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get resample2d;
  set resample2d(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get reshape;
  set reshape(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get sigmoid;
  set sigmoid(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get slice;
  set slice(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get softmax;
  set softmax(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get softplus;
  set softplus(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get softsign;
  set softsign(MLSingleInputSupportLimits value);
  MLSplitSupportLimits get split;
  set split(MLSplitSupportLimits value);
  MLSingleInputSupportLimits get tanh;
  set tanh(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get transpose;
  set transpose(MLSingleInputSupportLimits value);
  MLSingleInputSupportLimits get triangular;
  set triangular(MLSingleInputSupportLimits value);
  MLWhereSupportLimits get where;
  set where(MLWhereSupportLimits value);
}

abstract interface class MLOperand {
  MLOperandDataType get dataType;
  List<int> get shape;
}

typedef MLOperandDataType = String;

abstract interface class MLOperandDescriptor {
  MLOperandDataType get dataType;
  set dataType(MLOperandDataType value);
  List<int> get shape;
  set shape(List<int> value);
}

abstract interface class MLOperatorOptions {
  String get label;
  set label(String value);
}

abstract interface class MLPadOptions {
  MLPaddingMode get mode;
  set mode(MLPaddingMode value);
  MLNumber get value;
  set value(MLNumber value);
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

abstract interface class MLPreluSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get slope;
  set slope(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

typedef MLRecurrentNetworkActivation = String;

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

abstract interface class MLSingleInputSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class MLSplitOptions {
  int get axis;
  set axis(int value);
}

abstract interface class MLSplitSupportLimits {
  MLSupportLimits get input;
  set input(MLSupportLimits value);
  MLSupportLimits get outputs;
  set outputs(MLSupportLimits value);
}

abstract interface class MLSupportLimits {
  List<MLOperandDataType> get dataTypes;
  set dataTypes(List<MLOperandDataType> value);
}

abstract interface class MLTensor {
  MLOperandDataType get dataType;
  List<int> get shape;
  bool get readable;
  bool get writable;
  void destroy();
}

abstract interface class MLTensorDescriptor {
  bool get readable;
  set readable(bool value);
  bool get writable;
  set writable(bool value);
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

abstract interface class MLWhereSupportLimits {
  MLSupportLimits get condition;
  set condition(MLSupportLimits value);
  MLSupportLimits get trueValue;
  set trueValue(MLSupportLimits value);
  MLSupportLimits get falseValue;
  set falseValue(MLSupportLimits value);
  MLSupportLimits get output;
  set output(MLSupportLimits value);
}

abstract interface class NavigatorML {
  ML get ml;
}

