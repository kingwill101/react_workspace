// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: filter-effects
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'svg.dart';

abstract interface class SVGComponentTransferFunctionElement {
   static const int SVG_FECOMPONENTTRANSFER_TYPE_UNKNOWN =
      0;
   static const int SVG_FECOMPONENTTRANSFER_TYPE_IDENTITY =
      1;
   static const int SVG_FECOMPONENTTRANSFER_TYPE_TABLE =
      2;
   static const int SVG_FECOMPONENTTRANSFER_TYPE_DISCRETE =
      3;
   static const int SVG_FECOMPONENTTRANSFER_TYPE_LINEAR =
      4;
   static const int SVG_FECOMPONENTTRANSFER_TYPE_GAMMA =
      5;
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
   static const int SVG_FEBLEND_MODE_UNKNOWN =
      0;
   static const int SVG_FEBLEND_MODE_NORMAL =
      1;
   static const int SVG_FEBLEND_MODE_MULTIPLY =
      2;
   static const int SVG_FEBLEND_MODE_SCREEN =
      3;
   static const int SVG_FEBLEND_MODE_DARKEN =
      4;
   static const int SVG_FEBLEND_MODE_LIGHTEN =
      5;
   static const int SVG_FEBLEND_MODE_OVERLAY =
      6;
   static const int SVG_FEBLEND_MODE_COLOR_DODGE =
      7;
   static const int SVG_FEBLEND_MODE_COLOR_BURN =
      8;
   static const int SVG_FEBLEND_MODE_HARD_LIGHT =
      9;
   static const int SVG_FEBLEND_MODE_SOFT_LIGHT =
      10;
   static const int SVG_FEBLEND_MODE_DIFFERENCE =
      11;
   static const int SVG_FEBLEND_MODE_EXCLUSION =
      12;
   static const int SVG_FEBLEND_MODE_HUE =
      13;
   static const int SVG_FEBLEND_MODE_SATURATION =
      14;
   static const int SVG_FEBLEND_MODE_COLOR =
      15;
   static const int SVG_FEBLEND_MODE_LUMINOSITY =
      16;
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
   static const int SVG_FECOLORMATRIX_TYPE_UNKNOWN =
      0;
   static const int SVG_FECOLORMATRIX_TYPE_MATRIX =
      1;
   static const int SVG_FECOLORMATRIX_TYPE_SATURATE =
      2;
   static const int SVG_FECOLORMATRIX_TYPE_HUEROTATE =
      3;
   static const int SVG_FECOLORMATRIX_TYPE_LUMINANCETOALPHA =
      4;
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
   static const int SVG_FECOMPOSITE_OPERATOR_UNKNOWN =
      0;
   static const int SVG_FECOMPOSITE_OPERATOR_OVER =
      1;
   static const int SVG_FECOMPOSITE_OPERATOR_IN =
      2;
   static const int SVG_FECOMPOSITE_OPERATOR_OUT =
      3;
   static const int SVG_FECOMPOSITE_OPERATOR_ATOP =
      4;
   static const int SVG_FECOMPOSITE_OPERATOR_XOR =
      5;
   static const int SVG_FECOMPOSITE_OPERATOR_ARITHMETIC =
      6;
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
   static const int SVG_EDGEMODE_UNKNOWN =
      0;
   static const int SVG_EDGEMODE_DUPLICATE =
      1;
   static const int SVG_EDGEMODE_WRAP =
      2;
   static const int SVG_EDGEMODE_NONE =
      3;
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
   static const int SVG_CHANNEL_UNKNOWN =
      0;
   static const int SVG_CHANNEL_R =
      1;
   static const int SVG_CHANNEL_G =
      2;
   static const int SVG_CHANNEL_B =
      3;
   static const int SVG_CHANNEL_A =
      4;
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
   static const int SVG_EDGEMODE_UNKNOWN =
      0;
   static const int SVG_EDGEMODE_DUPLICATE =
      1;
   static const int SVG_EDGEMODE_WRAP =
      2;
   static const int SVG_EDGEMODE_NONE =
      3;
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
   static const int SVG_MORPHOLOGY_OPERATOR_UNKNOWN =
      0;
   static const int SVG_MORPHOLOGY_OPERATOR_ERODE =
      1;
   static const int SVG_MORPHOLOGY_OPERATOR_DILATE =
      2;
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
   static const int SVG_TURBULENCE_TYPE_UNKNOWN =
      0;
   static const int SVG_TURBULENCE_TYPE_FRACTALNOISE =
      1;
   static const int SVG_TURBULENCE_TYPE_TURBULENCE =
      2;
   static const int SVG_STITCHTYPE_UNKNOWN =
      0;
   static const int SVG_STITCHTYPE_STITCH =
      1;
   static const int SVG_STITCHTYPE_NOSTITCH =
      2;
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

