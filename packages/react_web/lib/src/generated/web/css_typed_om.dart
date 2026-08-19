// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-typed-om
// ignore_for_file: type=lint

import 'geometry.dart';
import 'cssom.dart';
import 'package:react_web/src/web_runtime.dart';

typedef CSSColorAngle = Object;

typedef CSSColorNumber = Object;

typedef CSSColorPercent = Object;

typedef CSSColorRGBComp = Object;

abstract interface class CSSImageValue {
}

abstract interface class CSSKeywordValue {
  factory CSSKeywordValue(String value) =>
      WebRuntime.current.createWebObject<CSSKeywordValue>(
        'CSSKeywordValue',
        [value],
      );
  String get value;
   set value(String value);
}

typedef CSSKeywordish = Object;

abstract interface class CSSMathClamp {
  factory CSSMathClamp(CSSNumberish lower, CSSNumberish value, CSSNumberish upper) =>
      WebRuntime.current.createWebObject<CSSMathClamp>(
        'CSSMathClamp',
        [lower, value, upper],
      );
  CSSNumericValue get lower;
  CSSNumericValue get value;
  CSSNumericValue get upper;
}

abstract interface class CSSMathInvert {
  factory CSSMathInvert(CSSNumberish arg) =>
      WebRuntime.current.createWebObject<CSSMathInvert>(
        'CSSMathInvert',
        [arg],
      );
  CSSNumericValue get value;
}

abstract interface class CSSMathMax {
  factory CSSMathMax([List<CSSNumberish>? args]) =>
      WebRuntime.current.createWebObject<CSSMathMax>(
        'CSSMathMax',
        [args],
      );
  CSSNumericArray get values;
}

abstract interface class CSSMathMin {
  factory CSSMathMin([List<CSSNumberish>? args]) =>
      WebRuntime.current.createWebObject<CSSMathMin>(
        'CSSMathMin',
        [args],
      );
  CSSNumericArray get values;
}

abstract interface class CSSMathNegate {
  factory CSSMathNegate(CSSNumberish arg) =>
      WebRuntime.current.createWebObject<CSSMathNegate>(
        'CSSMathNegate',
        [arg],
      );
  CSSNumericValue get value;
}

typedef CSSMathOperator = String;

abstract interface class CSSMathProduct {
  factory CSSMathProduct([List<CSSNumberish>? args]) =>
      WebRuntime.current.createWebObject<CSSMathProduct>(
        'CSSMathProduct',
        [args],
      );
  CSSNumericArray get values;
}

abstract interface class CSSMathSum {
  factory CSSMathSum([List<CSSNumberish>? args]) =>
      WebRuntime.current.createWebObject<CSSMathSum>(
        'CSSMathSum',
        [args],
      );
  CSSNumericArray get values;
}

abstract interface class CSSMathValue {
  CSSMathOperator get operator_;
}

abstract interface class CSSMatrixComponent {
  factory CSSMatrixComponent(DOMMatrixReadOnly matrix, [CSSMatrixComponentOptions? options]) =>
      WebRuntime.current.createWebObject<CSSMatrixComponent>(
        'CSSMatrixComponent',
        [matrix, options],
      );
  DOMMatrix get matrix;
   set matrix(DOMMatrix value);
}

abstract interface class CSSMatrixComponentOptions {
  bool? get is2D;
  set is2D(bool? value);
}

final class CSSMatrixComponentOptionsValue implements CSSMatrixComponentOptions {
  @override
  bool? is2D;

  CSSMatrixComponentOptionsValue({
    this.is2D,
  });
}

typedef CSSNumberish = Object;

abstract interface class CSSNumericArray {
  int get length;
}

typedef CSSNumericBaseType = String;

abstract interface class CSSNumericType {
  int? get length;
  set length(int? value);
  int? get angle;
  set angle(int? value);
  int? get time;
  set time(int? value);
  int? get frequency;
  set frequency(int? value);
  int? get resolution;
  set resolution(int? value);
  int? get flex;
  set flex(int? value);
  int? get percent;
  set percent(int? value);
  CSSNumericBaseType? get percentHint;
  set percentHint(CSSNumericBaseType? value);
}

final class CSSNumericTypeValue implements CSSNumericType {
  @override
  int? length;
  @override
  int? angle;
  @override
  int? time;
  @override
  int? frequency;
  @override
  int? resolution;
  @override
  int? flex;
  @override
  int? percent;
  @override
  CSSNumericBaseType? percentHint;

  CSSNumericTypeValue({
    this.length,
    this.angle,
    this.time,
    this.frequency,
    this.resolution,
    this.flex,
    this.percent,
    this.percentHint,
  });
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
  CSSNumericType type_();
}

abstract interface class CSSPerspective {
  factory CSSPerspective(CSSPerspectiveValue length) =>
      WebRuntime.current.createWebObject<CSSPerspective>(
        'CSSPerspective',
        [length],
      );
  CSSPerspectiveValue get length;
   set length(CSSPerspectiveValue value);
}

typedef CSSPerspectiveValue = Object;

abstract interface class CSSRotate {
  factory CSSRotate(CSSNumericValue angle) =>
      WebRuntime.current.createWebObject<CSSRotate>(
        'CSSRotate',
        [angle],
      );
  factory CSSRotate.named1(CSSNumberish x, CSSNumberish y, CSSNumberish z, CSSNumericValue angle) =>
      WebRuntime.current.createWebObject<CSSRotate>(
        'CSSRotate',
        [x, y, z, angle],
      );
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
  factory CSSScale(CSSNumberish x, CSSNumberish y, [CSSNumberish? z]) =>
      WebRuntime.current.createWebObject<CSSScale>(
        'CSSScale',
        [x, y, z],
      );
  CSSNumberish get x;
   set x(CSSNumberish value);
  CSSNumberish get y;
   set y(CSSNumberish value);
  CSSNumberish get z;
   set z(CSSNumberish value);
}

abstract interface class CSSSkew {
  factory CSSSkew(CSSNumericValue ax, CSSNumericValue ay) =>
      WebRuntime.current.createWebObject<CSSSkew>(
        'CSSSkew',
        [ax, ay],
      );
  CSSNumericValue get ax;
   set ax(CSSNumericValue value);
  CSSNumericValue get ay;
   set ay(CSSNumericValue value);
}

abstract interface class CSSSkewX {
  factory CSSSkewX(CSSNumericValue ax) =>
      WebRuntime.current.createWebObject<CSSSkewX>(
        'CSSSkewX',
        [ax],
      );
  CSSNumericValue get ax;
   set ax(CSSNumericValue value);
}

abstract interface class CSSSkewY {
  factory CSSSkewY(CSSNumericValue ay) =>
      WebRuntime.current.createWebObject<CSSSkewY>(
        'CSSSkewY',
        [ay],
      );
  CSSNumericValue get ay;
   set ay(CSSNumericValue value);
}

abstract interface class CSSStyleRule {
  StylePropertyMap get styleMap;
  Object get selectorText;
   set selectorText(Object value);
  Object get style;
}

abstract interface class CSSStyleValue {
}

abstract interface class CSSTransformComponent {
  bool get is2D;
   set is2D(bool value);
  DOMMatrix toMatrix();
}

abstract interface class CSSTransformValue {
  factory CSSTransformValue(List<CSSTransformComponent> transforms) =>
      WebRuntime.current.createWebObject<CSSTransformValue>(
        'CSSTransformValue',
        [transforms],
      );
  int get length;
  bool get is2D;
  DOMMatrix toMatrix();
}

abstract interface class CSSTranslate {
  factory CSSTranslate(CSSNumericValue x, CSSNumericValue y, [CSSNumericValue? z]) =>
      WebRuntime.current.createWebObject<CSSTranslate>(
        'CSSTranslate',
        [x, y, z],
      );
  CSSNumericValue get x;
   set x(CSSNumericValue value);
  CSSNumericValue get y;
   set y(CSSNumericValue value);
  CSSNumericValue get z;
   set z(CSSNumericValue value);
}

abstract interface class CSSUnitValue {
  factory CSSUnitValue(double value, String unit) =>
      WebRuntime.current.createWebObject<CSSUnitValue>(
        'CSSUnitValue',
        [value, unit],
      );
  double get value;
   set value(double value);
  String get unit;
}

typedef CSSUnparsedSegment = Object;

abstract interface class CSSUnparsedValue {
  factory CSSUnparsedValue(List<CSSUnparsedSegment> members) =>
      WebRuntime.current.createWebObject<CSSUnparsedValue>(
        'CSSUnparsedValue',
        [members],
      );
  int get length;
}

abstract interface class CSSVariableReferenceValue {
  factory CSSVariableReferenceValue(String variable, [CSSUnparsedValue? fallback]) =>
      WebRuntime.current.createWebObject<CSSVariableReferenceValue>(
        'CSSVariableReferenceValue',
        [variable, fallback],
      );
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
  CSSStyleValue get_(String property);
  List<CSSStyleValue> getAll(String property);
  bool has(String property);
  int get size;
}

