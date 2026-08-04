// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-pseudo
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'geometry.dart';
import 'cssom_view.dart';
import 'css_nav.dart';

abstract interface class CSSPseudoElement {
  List<DOMQuad> getBoxQuads([BoxQuadOptions? options]);
  DOMQuad convertQuadFromNode(DOMQuadInit quad, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMQuad convertRectFromNode(DOMRectReadOnly rect, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMPoint convertPointFromNode(DOMPointInit point, GeometryNode from, [ConvertCoordinateOptions? options]);
  Object get type;
  Element get element;
  Object get parent;
  CSSPseudoElement? pseudo(Object type);
}

