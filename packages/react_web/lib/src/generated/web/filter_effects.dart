// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: filter-effects
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'svg.dart';

abstract interface class SVGComponentTransferFunctionElement {
  SVGAnimatedEnumeration get type;
  SVGAnimatedNumberList get tableValues;
  SVGAnimatedNumber get slope;
  SVGAnimatedNumber get intercept;
  SVGAnimatedNumber get amplitude;
  SVGAnimatedNumber get exponent;
  SVGAnimatedNumber get offset;
}

abstract interface class SVGFEBlendElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedString get in2;
  SVGAnimatedEnumeration get mode;
}

abstract interface class SVGFEColorMatrixElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedEnumeration get type;
  SVGAnimatedNumberList get values;
}

abstract interface class SVGFEComponentTransferElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
}

abstract interface class SVGFECompositeElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedString get in2;
  SVGAnimatedEnumeration get operator_;
  SVGAnimatedNumber get k1;
  SVGAnimatedNumber get k2;
  SVGAnimatedNumber get k3;
  SVGAnimatedNumber get k4;
}

abstract interface class SVGFEConvolveMatrixElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedInteger get orderX;
  SVGAnimatedInteger get orderY;
  SVGAnimatedNumberList get kernelMatrix;
  SVGAnimatedNumber get divisor;
  SVGAnimatedNumber get bias;
  SVGAnimatedInteger get targetX;
  SVGAnimatedInteger get targetY;
  SVGAnimatedEnumeration get edgeMode;
  SVGAnimatedNumber get kernelUnitLengthX;
  SVGAnimatedNumber get kernelUnitLengthY;
  SVGAnimatedBoolean get preserveAlpha;
}

abstract interface class SVGFEDiffuseLightingElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedNumber get surfaceScale;
  SVGAnimatedNumber get diffuseConstant;
  SVGAnimatedNumber get kernelUnitLengthX;
  SVGAnimatedNumber get kernelUnitLengthY;
}

abstract interface class SVGFEDisplacementMapElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedString get in2;
  SVGAnimatedNumber get scale;
  SVGAnimatedEnumeration get xChannelSelector;
  SVGAnimatedEnumeration get yChannelSelector;
}

abstract interface class SVGFEDistantLightElement {
  SVGAnimatedNumber get azimuth;
  SVGAnimatedNumber get elevation;
}

abstract interface class SVGFEDropShadowElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedNumber get dx;
  SVGAnimatedNumber get dy;
  SVGAnimatedNumber get stdDeviationX;
  SVGAnimatedNumber get stdDeviationY;
  void setStdDeviation(double stdDeviationX, double stdDeviationY);
}

abstract interface class SVGFEFloodElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
}

abstract interface class SVGFEFuncAElement {
}

abstract interface class SVGFEFuncBElement {
}

abstract interface class SVGFEFuncGElement {
}

abstract interface class SVGFEFuncRElement {
}

abstract interface class SVGFEGaussianBlurElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedNumber get stdDeviationX;
  SVGAnimatedNumber get stdDeviationY;
  SVGAnimatedEnumeration get edgeMode;
  void setStdDeviation(double stdDeviationX, double stdDeviationY);
}

abstract interface class SVGFEImageElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get href;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
  SVGAnimatedString get crossOrigin;
}

abstract interface class SVGFEMergeElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
}

abstract interface class SVGFEMergeNodeElement {
  SVGAnimatedString get in1;
}

abstract interface class SVGFEMorphologyElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedEnumeration get operator_;
  SVGAnimatedNumber get radiusX;
  SVGAnimatedNumber get radiusY;
}

abstract interface class SVGFEOffsetElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedNumber get dx;
  SVGAnimatedNumber get dy;
}

abstract interface class SVGFEPointLightElement {
  SVGAnimatedNumber get x;
  SVGAnimatedNumber get y;
  SVGAnimatedNumber get z;
}

abstract interface class SVGFESpecularLightingElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
  SVGAnimatedNumber get surfaceScale;
  SVGAnimatedNumber get specularConstant;
  SVGAnimatedNumber get specularExponent;
  SVGAnimatedNumber get kernelUnitLengthX;
  SVGAnimatedNumber get kernelUnitLengthY;
}

abstract interface class SVGFESpotLightElement {
  SVGAnimatedNumber get x;
  SVGAnimatedNumber get y;
  SVGAnimatedNumber get z;
  SVGAnimatedNumber get pointsAtX;
  SVGAnimatedNumber get pointsAtY;
  SVGAnimatedNumber get pointsAtZ;
  SVGAnimatedNumber get specularExponent;
  SVGAnimatedNumber get limitingConeAngle;
}

abstract interface class SVGFETileElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedString get in1;
}

abstract interface class SVGFETurbulenceElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
  SVGAnimatedNumber get baseFrequencyX;
  SVGAnimatedNumber get baseFrequencyY;
  SVGAnimatedInteger get numOctaves;
  SVGAnimatedNumber get seed;
  SVGAnimatedEnumeration get stitchTiles;
  SVGAnimatedEnumeration get type;
}

abstract interface class SVGFilterElement {
  SVGAnimatedString get href;
  SVGAnimatedEnumeration get filterUnits;
  SVGAnimatedEnumeration get primitiveUnits;
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
}

abstract interface class SVGFilterPrimitiveStandardAttributes {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedString get result;
}

