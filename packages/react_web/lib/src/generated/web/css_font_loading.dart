// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-font-loading
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'html.dart';
import 'dom.dart';

abstract interface class FontFace {
  Object get family;
   set family(Object value);
  Object get style;
   set style(Object value);
  Object get weight;
   set weight(Object value);
  Object get stretch;
   set stretch(Object value);
  Object get unicodeRange;
   set unicodeRange(Object value);
  Object get featureSettings;
   set featureSettings(Object value);
  Object get variationSettings;
   set variationSettings(Object value);
  Object get display;
   set display(Object value);
  Object get ascentOverride;
   set ascentOverride(Object value);
  Object get descentOverride;
   set descentOverride(Object value);
  Object get lineGapOverride;
   set lineGapOverride(Object value);
  FontFaceLoadStatus get status;
  Future<FontFace> load();
  Future<FontFace> get loaded;
  FontFaceFeatures get features;
  FontFaceVariations get variations;
  FontFacePalettes get palettes;
}

abstract interface class FontFaceDescriptors {
  Object get style;
  set style(Object value);
  Object get weight;
  set weight(Object value);
  Object get stretch;
  set stretch(Object value);
  Object get unicodeRange;
  set unicodeRange(Object value);
  Object get featureSettings;
  set featureSettings(Object value);
  Object get variationSettings;
  set variationSettings(Object value);
  Object get display;
  set display(Object value);
  Object get ascentOverride;
  set ascentOverride(Object value);
  Object get descentOverride;
  set descentOverride(Object value);
  Object get lineGapOverride;
  set lineGapOverride(Object value);
}

abstract interface class FontFaceFeatures {
}

typedef FontFaceLoadStatus = String;

abstract interface class FontFacePalette {
   Iterable<String> get values;
  int get length;
  bool get usableWithLightBackground;
  bool get usableWithDarkBackground;
}

abstract interface class FontFacePalettes {
   Iterable<FontFacePalette> get values;
  int get length;
}

abstract interface class FontFaceSet {
   Iterable<FontFace> get values;
   bool has(Object value);
  FontFaceSet add(FontFace font);
  bool delete(FontFace font);
  void clear();
  EventHandler get onloading;
   set onloading(EventHandler value);
  EventHandler get onloadingdone;
   set onloadingdone(EventHandler value);
  EventHandler get onloadingerror;
   set onloadingerror(EventHandler value);
  Future<List<FontFace>> load(Object font, [Object? text]);
  bool check(Object font, [Object? text]);
  Future<FontFaceSet> get ready;
  FontFaceSetLoadStatus get status;
}

abstract interface class FontFaceSetLoadEvent {
  List<FontFace> get fontfaces;
}

abstract interface class FontFaceSetLoadEventInit {
  List<FontFace> get fontfaces;
  set fontfaces(List<FontFace> value);
}

typedef FontFaceSetLoadStatus = String;

abstract interface class FontFaceSource {
  FontFaceSet get fonts;
}

abstract interface class FontFaceVariationAxis {
  String get name;
  String get axisTag;
  double get minimumValue;
  double get maximumValue;
  double get defaultValue;
}

abstract interface class FontFaceVariations {
   Iterable<FontFaceVariationAxis> get values;
   bool has(Object value);
}

