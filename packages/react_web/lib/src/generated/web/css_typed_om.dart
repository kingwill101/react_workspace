// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-typed-om
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'cssom.dart';

abstract interface class CSSColor {
  CSSKeywordish get colorSpace;
   set colorSpace(CSSKeywordish value);
  List<CSSColorPercent> get channels;
   set channels(List<CSSColorPercent> value);
  CSSNumberish get alpha;
   set alpha(CSSNumberish value);
}

typedef CSSColorAngle = Object;

typedef CSSColorNumber = Object;

typedef CSSColorPercent = Object;

typedef CSSColorRGBComp = Object;

abstract interface class CSSColorValue {
}

abstract interface class CSSHSL {
  CSSColorAngle get h;
   set h(CSSColorAngle value);
  CSSColorPercent get s;
   set s(CSSColorPercent value);
  CSSColorPercent get l;
   set l(CSSColorPercent value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSHWB {
  CSSNumericValue get h;
   set h(CSSNumericValue value);
  CSSNumberish get w;
   set w(CSSNumberish value);
  CSSNumberish get b;
   set b(CSSNumberish value);
  CSSNumberish get alpha;
   set alpha(CSSNumberish value);
}

abstract interface class CSSImageValue {
}

abstract interface class CSSKeywordValue {
  String get value;
   set value(String value);
}

typedef CSSKeywordish = Object;

abstract interface class CSSLCH {
  CSSColorPercent get l;
   set l(CSSColorPercent value);
  CSSColorPercent get c;
   set c(CSSColorPercent value);
  CSSColorAngle get h;
   set h(CSSColorAngle value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSLab {
  CSSColorPercent get l;
   set l(CSSColorPercent value);
  CSSColorNumber get a;
   set a(CSSColorNumber value);
  CSSColorNumber get b;
   set b(CSSColorNumber value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSMathClamp {
  CSSNumericValue get lower;
  CSSNumericValue get value;
  CSSNumericValue get upper;
}

abstract interface class CSSMathInvert {
  CSSNumericValue get value;
}

abstract interface class CSSMathMax {
  CSSNumericArray get values;
}

abstract interface class CSSMathMin {
  CSSNumericArray get values;
}

abstract interface class CSSMathNegate {
  CSSNumericValue get value;
}

typedef CSSMathOperator = String;

abstract interface class CSSMathProduct {
  CSSNumericArray get values;
}

abstract interface class CSSMathSum {
  CSSNumericArray get values;
}

abstract interface class CSSMathValue {
  CSSMathOperator get operator_;
}

abstract interface class CSSMatrixComponent {
  DOMMatrix get matrix;
   set matrix(DOMMatrix value);
}

abstract interface class CSSMatrixComponentOptions {
  bool get is2D;
  set is2D(bool value);
}

typedef CSSNumberish = Object;

abstract interface class CSSNumericArray {
   Iterable<CSSNumericValue> get values;
  int get length;
}

typedef CSSNumericBaseType = String;

abstract interface class CSSNumericType {
  int get length;
  set length(int value);
  int get angle;
  set angle(int value);
  int get time;
  set time(int value);
  int get frequency;
  set frequency(int value);
  int get resolution;
  set resolution(int value);
  int get flex;
  set flex(int value);
  int get percent;
  set percent(int value);
  CSSNumericBaseType get percentHint;
  set percentHint(CSSNumericBaseType value);
}

abstract interface class CSSNumericValue {
  CSSNumericValue add([List<CSSNumberish>? values]);
  CSSNumericValue sub([List<CSSNumberish>? values]);
  CSSNumericValue mul([List<CSSNumberish>? values]);
  CSSNumericValue div([List<CSSNumberish>? values]);
  CSSNumericValue min([List<CSSNumberish>? values]);
  CSSNumericValue max([List<CSSNumberish>? values]);
  bool equals([List<CSSNumberish>? value]);
  CSSUnitValue to(String unit);
  CSSMathSum toSum([List<String>? units]);
  CSSNumericType type();
}

abstract interface class CSSOKLCH {
  CSSColorPercent get l;
   set l(CSSColorPercent value);
  CSSColorPercent get c;
   set c(CSSColorPercent value);
  CSSColorAngle get h;
   set h(CSSColorAngle value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSOKLab {
  CSSColorPercent get l;
   set l(CSSColorPercent value);
  CSSColorNumber get a;
   set a(CSSColorNumber value);
  CSSColorNumber get b;
   set b(CSSColorNumber value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSPerspective {
  CSSPerspectiveValue get length;
   set length(CSSPerspectiveValue value);
}

typedef CSSPerspectiveValue = Object;

abstract interface class CSSRGB {
  CSSColorRGBComp get r;
   set r(CSSColorRGBComp value);
  CSSColorRGBComp get g;
   set g(CSSColorRGBComp value);
  CSSColorRGBComp get b;
   set b(CSSColorRGBComp value);
  CSSColorPercent get alpha;
   set alpha(CSSColorPercent value);
}

abstract interface class CSSRotate {
  CSSNumberish get x;
   set x(CSSNumberish value);
  CSSNumberish get y;
   set y(CSSNumberish value);
  CSSNumberish get z;
   set z(CSSNumberish value);
  CSSNumericValue get angle;
   set angle(CSSNumericValue value);
}

abstract interface class CSSScale {
  CSSNumberish get x;
   set x(CSSNumberish value);
  CSSNumberish get y;
   set y(CSSNumberish value);
  CSSNumberish get z;
   set z(CSSNumberish value);
}

abstract interface class CSSSkew {
  CSSNumericValue get ax;
   set ax(CSSNumericValue value);
  CSSNumericValue get ay;
   set ay(CSSNumericValue value);
}

abstract interface class CSSSkewX {
  CSSNumericValue get ax;
   set ax(CSSNumericValue value);
}

abstract interface class CSSSkewY {
  CSSNumericValue get ay;
   set ay(CSSNumericValue value);
}

abstract interface class CSSStyleRule {
  StylePropertyMap get styleMap;
  Object get selectorText;
   set selectorText(Object value);
  CSSStyleProperties get style;
}

abstract interface class CSSStyleValue {
}

abstract interface class CSSTransformComponent {
  bool get is2D;
   set is2D(bool value);
  DOMMatrix toMatrix();
}

abstract interface class CSSTransformValue {
   Iterable<CSSTransformComponent> get values;
  int get length;
  bool get is2D;
  DOMMatrix toMatrix();
}

abstract interface class CSSTranslate {
  CSSNumericValue get x;
   set x(CSSNumericValue value);
  CSSNumericValue get y;
   set y(CSSNumericValue value);
  CSSNumericValue get z;
   set z(CSSNumericValue value);
}

abstract interface class CSSUnitValue {
  double get value;
   set value(double value);
  String get unit;
}

typedef CSSUnparsedSegment = Object;

abstract interface class CSSUnparsedValue {
   Iterable<CSSUnparsedSegment> get values;
  int get length;
}

abstract interface class CSSVariableReferenceValue {
  String get variable;
   set variable(String value);
  CSSUnparsedValue? get fallback;
}

abstract interface class ElementCSSInlineStyle {
  StylePropertyMap get attributeStyleMap;
  CSSStyleDeclaration get style;
}

abstract interface class StylePropertyMap {
  void set_(String property, [List<Object>? values]);
  void append(String property, [List<Object>? values]);
  void delete(String property);
  void clear();
}

abstract interface class StylePropertyMapReadOnly {
   Iterable<(String, List<CSSStyleValue>)> get entries;
   Iterable<String> get keys;
   Iterable<List<CSSStyleValue>> get values;
  CSSStyleValue get_(String property);
  List<CSSStyleValue> getAll(String property);
  bool has(String property);
  int get size;
}

