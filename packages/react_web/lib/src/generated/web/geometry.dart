// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: geometry
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class DOMMatrix {
  factory DOMMatrix([Object? init]) =>
      WebRuntime.current.createWebObject<DOMMatrix>(
        'DOMMatrix',
        [init],
      );
  double get a;
   set a(double value);
  double get b;
   set b(double value);
  double get c;
   set c(double value);
  double get d;
   set d(double value);
  double get e;
   set e(double value);
  double get f;
   set f(double value);
  double get m11;
   set m11(double value);
  double get m12;
   set m12(double value);
  double get m13;
   set m13(double value);
  double get m14;
   set m14(double value);
  double get m21;
   set m21(double value);
  double get m22;
   set m22(double value);
  double get m23;
   set m23(double value);
  double get m24;
   set m24(double value);
  double get m31;
   set m31(double value);
  double get m32;
   set m32(double value);
  double get m33;
   set m33(double value);
  double get m34;
   set m34(double value);
  double get m41;
   set m41(double value);
  double get m42;
   set m42(double value);
  double get m43;
   set m43(double value);
  double get m44;
   set m44(double value);
  DOMMatrix multiplySelf([DOMMatrixInit? other]);
  DOMMatrix preMultiplySelf([DOMMatrixInit? other]);
  DOMMatrix translateSelf([double? tx, double? ty, double? tz]);
  DOMMatrix scaleSelf([double? scaleX, double? scaleY, double? scaleZ, double? originX, double? originY, double? originZ]);
  DOMMatrix scale3dSelf([double? scale, double? originX, double? originY, double? originZ]);
  DOMMatrix rotateSelf([double? rotX, double? rotY, double? rotZ]);
  DOMMatrix rotateFromVectorSelf([double? x, double? y]);
  DOMMatrix rotateAxisAngleSelf([double? x, double? y, double? z, double? angle]);
  DOMMatrix skewXSelf([double? sx]);
  DOMMatrix skewYSelf([double? sy]);
  DOMMatrix invertSelf();
  DOMMatrix setMatrixValue(String transformList);
}

abstract interface class DOMMatrix2DInit {
  double? get a;
  set a(double? value);
  double? get b;
  set b(double? value);
  double? get c;
  set c(double? value);
  double? get d;
  set d(double? value);
  double? get e;
  set e(double? value);
  double? get f;
  set f(double? value);
  double? get m11;
  set m11(double? value);
  double? get m12;
  set m12(double? value);
  double? get m21;
  set m21(double? value);
  double? get m22;
  set m22(double? value);
  double? get m41;
  set m41(double? value);
  double? get m42;
  set m42(double? value);
}

final class DOMMatrix2DInitValue implements DOMMatrix2DInit {
  @override
  double? a;
  @override
  double? b;
  @override
  double? c;
  @override
  double? d;
  @override
  double? e;
  @override
  double? f;
  @override
  double? m11;
  @override
  double? m12;
  @override
  double? m21;
  @override
  double? m22;
  @override
  double? m41;
  @override
  double? m42;

  DOMMatrix2DInitValue({
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.m11,
    this.m12,
    this.m21,
    this.m22,
    this.m41,
    this.m42,
  });
}

abstract interface class DOMMatrixInit {
  double? get m13;
  set m13(double? value);
  double? get m14;
  set m14(double? value);
  double? get m23;
  set m23(double? value);
  double? get m24;
  set m24(double? value);
  double? get m31;
  set m31(double? value);
  double? get m32;
  set m32(double? value);
  double? get m33;
  set m33(double? value);
  double? get m34;
  set m34(double? value);
  double? get m43;
  set m43(double? value);
  double? get m44;
  set m44(double? value);
  bool? get is2D;
  set is2D(bool? value);
}

final class DOMMatrixInitValue implements DOMMatrixInit {
  @override
  double? m13;
  @override
  double? m14;
  @override
  double? m23;
  @override
  double? m24;
  @override
  double? m31;
  @override
  double? m32;
  @override
  double? m33;
  @override
  double? m34;
  @override
  double? m43;
  @override
  double? m44;
  @override
  bool? is2D;

  DOMMatrixInitValue({
    this.m13,
    this.m14,
    this.m23,
    this.m24,
    this.m31,
    this.m32,
    this.m33,
    this.m34,
    this.m43,
    this.m44,
    this.is2D,
  });
}

abstract interface class DOMMatrixReadOnly {
  factory DOMMatrixReadOnly([Object? init]) =>
      WebRuntime.current.createWebObject<DOMMatrixReadOnly>(
        'DOMMatrixReadOnly',
        [init],
      );
  double get a;
  double get b;
  double get c;
  double get d;
  double get e;
  double get f;
  double get m11;
  double get m12;
  double get m13;
  double get m14;
  double get m21;
  double get m22;
  double get m23;
  double get m24;
  double get m31;
  double get m32;
  double get m33;
  double get m34;
  double get m41;
  double get m42;
  double get m43;
  double get m44;
  bool get is2D;
  bool get isIdentity;
  DOMMatrix translate([double? tx, double? ty, double? tz]);
  DOMMatrix scale([double? scaleX, double? scaleY, double? scaleZ, double? originX, double? originY, double? originZ]);
  DOMMatrix scaleNonUniform([double? scaleX, double? scaleY]);
  DOMMatrix scale3d([double? scale, double? originX, double? originY, double? originZ]);
  DOMMatrix rotate([double? rotX, double? rotY, double? rotZ]);
  DOMMatrix rotateFromVector([double? x, double? y]);
  DOMMatrix rotateAxisAngle([double? x, double? y, double? z, double? angle]);
  DOMMatrix skewX([double? sx]);
  DOMMatrix skewY([double? sy]);
  DOMMatrix multiply([DOMMatrixInit? other]);
  DOMMatrix flipX();
  DOMMatrix flipY();
  DOMMatrix inverse();
  DOMPoint transformPoint([DOMPointInit? point]);
  Object toFloat32Array();
  Object toFloat64Array();
  Object toJSON();
}

abstract interface class DOMPoint {
  factory DOMPoint([double? x, double? y, double? z, double? w]) =>
      WebRuntime.current.createWebObject<DOMPoint>(
        'DOMPoint',
        [x, y, z, w],
      );
  double get x;
   set x(double value);
  double get y;
   set y(double value);
  double get z;
   set z(double value);
  double get w;
   set w(double value);
}

abstract interface class DOMPointInit {
  double? get x;
  set x(double? value);
  double? get y;
  set y(double? value);
  double? get z;
  set z(double? value);
  double? get w;
  set w(double? value);
}

final class DOMPointInitValue implements DOMPointInit {
  @override
  double? x;
  @override
  double? y;
  @override
  double? z;
  @override
  double? w;

  DOMPointInitValue({
    this.x,
    this.y,
    this.z,
    this.w,
  });
}

abstract interface class DOMPointReadOnly {
  factory DOMPointReadOnly([double? x, double? y, double? z, double? w]) =>
      WebRuntime.current.createWebObject<DOMPointReadOnly>(
        'DOMPointReadOnly',
        [x, y, z, w],
      );
  double get x;
  double get y;
  double get z;
  double get w;
  DOMPoint matrixTransform([DOMMatrixInit? matrix]);
  Object toJSON();
}

abstract interface class DOMQuad {
  factory DOMQuad([DOMPointInit? p1, DOMPointInit? p2, DOMPointInit? p3, DOMPointInit? p4]) =>
      WebRuntime.current.createWebObject<DOMQuad>(
        'DOMQuad',
        [p1, p2, p3, p4],
      );
  DOMPoint get p1;
  DOMPoint get p2;
  DOMPoint get p3;
  DOMPoint get p4;
  DOMRect getBounds();
  Object toJSON();
}

abstract interface class DOMQuadInit {
  DOMPointInit? get p1;
  set p1(DOMPointInit? value);
  DOMPointInit? get p2;
  set p2(DOMPointInit? value);
  DOMPointInit? get p3;
  set p3(DOMPointInit? value);
  DOMPointInit? get p4;
  set p4(DOMPointInit? value);
}

final class DOMQuadInitValue implements DOMQuadInit {
  @override
  DOMPointInit? p1;
  @override
  DOMPointInit? p2;
  @override
  DOMPointInit? p3;
  @override
  DOMPointInit? p4;

  DOMQuadInitValue({
    this.p1,
    this.p2,
    this.p3,
    this.p4,
  });
}

abstract interface class DOMRect {
  factory DOMRect([double? x, double? y, double? width, double? height]) =>
      WebRuntime.current.createWebObject<DOMRect>(
        'DOMRect',
        [x, y, width, height],
      );
  double get x;
   set x(double value);
  double get y;
   set y(double value);
  double get width;
   set width(double value);
  double get height;
   set height(double value);
}

abstract interface class DOMRectInit {
  double? get x;
  set x(double? value);
  double? get y;
  set y(double? value);
  double? get width;
  set width(double? value);
  double? get height;
  set height(double? value);
}

final class DOMRectInitValue implements DOMRectInit {
  @override
  double? x;
  @override
  double? y;
  @override
  double? width;
  @override
  double? height;

  DOMRectInitValue({
    this.x,
    this.y,
    this.width,
    this.height,
  });
}

abstract interface class DOMRectList {
  int get length;
  DOMRect? item(int index);
}

abstract interface class DOMRectReadOnly {
  factory DOMRectReadOnly([double? x, double? y, double? width, double? height]) =>
      WebRuntime.current.createWebObject<DOMRectReadOnly>(
        'DOMRectReadOnly',
        [x, y, width, height],
      );
  double get x;
  double get y;
  double get width;
  double get height;
  double get top;
  double get right;
  double get bottom;
  double get left;
  Object toJSON();
}

