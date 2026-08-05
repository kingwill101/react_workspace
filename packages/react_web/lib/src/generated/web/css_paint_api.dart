// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-paint-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'html.dart';

abstract interface class PaintRenderingContext2D {
  void save();
  void restore();
  void reset();
  bool isContextLost();
  void scale(double x, double y);
  void rotate(double angle);
  void translate(double x, double y);
  void transform(double a, double b, double c, double d, double e, double f);
  DOMMatrix getTransform();
  void setTransform(double a, double b, double c, double d, double e, double f);
  void resetTransform();
  double get globalAlpha;
   set globalAlpha(double value);
  String get globalCompositeOperation;
   set globalCompositeOperation(String value);
  bool get imageSmoothingEnabled;
   set imageSmoothingEnabled(bool value);
  ImageSmoothingQuality get imageSmoothingQuality;
   set imageSmoothingQuality(ImageSmoothingQuality value);
  Object get strokeStyle;
   set strokeStyle(Object value);
  Object get fillStyle;
   set fillStyle(Object value);
  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1);
  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1);
  CanvasGradient createConicGradient(double startAngle, double x, double y);
  CanvasPattern? createPattern(CanvasImageSource image, String repetition);
  double get shadowOffsetX;
   set shadowOffsetX(double value);
  double get shadowOffsetY;
   set shadowOffsetY(double value);
  double get shadowBlur;
   set shadowBlur(double value);
  String get shadowColor;
   set shadowColor(String value);
  void clearRect(double x, double y, double w, double h);
  void fillRect(double x, double y, double w, double h);
  void strokeRect(double x, double y, double w, double h);
  void beginPath();
  void fill(Path2D path, [CanvasFillRule? fillRule]);
  void stroke(Path2D path);
  void clip(Path2D path, [CanvasFillRule? fillRule]);
  bool isPointInPath(Path2D path, double x, double y, [CanvasFillRule? fillRule]);
  bool isPointInStroke(Path2D path, double x, double y);
  void drawImage(CanvasImageSource image, double sx, double sy, double sw, double sh, double dx, double dy, double dw, double dh);
  double get lineWidth;
   set lineWidth(double value);
  CanvasLineCap get lineCap;
   set lineCap(CanvasLineCap value);
  CanvasLineJoin get lineJoin;
   set lineJoin(CanvasLineJoin value);
  double get miterLimit;
   set miterLimit(double value);
  void setLineDash(List<double> segments);
  List<double> getLineDash();
  double get lineDashOffset;
   set lineDashOffset(double value);
  void closePath();
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  void rect(double x, double y, double w, double h);
  void roundRect(double x, double y, double w, double h, [Object? radii]);
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool? counterclockwise]);
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool? counterclockwise]);
}

abstract interface class PaintRenderingContext2DSettings {
  bool get alpha;
  set alpha(bool value);
}

abstract interface class PaintSize {
  double get width;
  double get height;
}

