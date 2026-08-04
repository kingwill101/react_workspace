// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webvtt
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

typedef AlignSetting = String;

typedef AutoKeyword = String;

typedef DirectionSetting = String;

typedef LineAlignSetting = String;

typedef LineAndPositionSetting = Object;

typedef PositionAlignSetting = String;

typedef ScrollSetting = String;

abstract interface class VTTCue {
  VTTRegion? get region;
   set region(VTTRegion? value);
  DirectionSetting get vertical;
   set vertical(DirectionSetting value);
  bool get snapToLines;
   set snapToLines(bool value);
  LineAndPositionSetting get line;
   set line(LineAndPositionSetting value);
  LineAlignSetting get lineAlign;
   set lineAlign(LineAlignSetting value);
  LineAndPositionSetting get position;
   set position(LineAndPositionSetting value);
  PositionAlignSetting get positionAlign;
   set positionAlign(PositionAlignSetting value);
  double get size;
   set size(double value);
  AlignSetting get align;
   set align(AlignSetting value);
  String get text;
   set text(String value);
  DocumentFragment getCueAsHTML();
}

abstract interface class VTTRegion {
  String get id;
   set id(String value);
  double get width;
   set width(double value);
  int get lines;
   set lines(int value);
  double get regionAnchorX;
   set regionAnchorX(double value);
  double get regionAnchorY;
   set regionAnchorY(double value);
  double get viewportAnchorX;
   set viewportAnchorX(double value);
  double get viewportAnchorY;
   set viewportAnchorY(double value);
  ScrollSetting get scroll;
   set scroll(ScrollSetting value);
}

