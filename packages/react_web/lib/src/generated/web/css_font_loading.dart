// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: css-font-loading
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'html.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

typedef BinaryData = Object;

abstract interface class FontFace {
  factory FontFace(Object family, Object source, [FontFaceDescriptors? descriptors]) =>
      WebRuntime.current.createWebObject<FontFace>(
        'FontFace',
        [family, source, descriptors],
      );
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
}

abstract interface class FontFaceDescriptors {
  Object? get style;
  set style(Object? value);
  Object? get weight;
  set weight(Object? value);
  Object? get stretch;
  set stretch(Object? value);
  Object? get unicodeRange;
  set unicodeRange(Object? value);
  Object? get featureSettings;
  set featureSettings(Object? value);
  Object? get variationSettings;
  set variationSettings(Object? value);
  Object? get display;
  set display(Object? value);
  Object? get ascentOverride;
  set ascentOverride(Object? value);
  Object? get descentOverride;
  set descentOverride(Object? value);
  Object? get lineGapOverride;
  set lineGapOverride(Object? value);
}

final class FontFaceDescriptorsValue implements FontFaceDescriptors {
  @override
  Object? style;
  @override
  Object? weight;
  @override
  Object? stretch;
  @override
  Object? unicodeRange;
  @override
  Object? featureSettings;
  @override
  Object? variationSettings;
  @override
  Object? display;
  @override
  Object? ascentOverride;
  @override
  Object? descentOverride;
  @override
  Object? lineGapOverride;

  FontFaceDescriptorsValue({
    this.style,
    this.weight,
    this.stretch,
    this.unicodeRange,
    this.featureSettings,
    this.variationSettings,
    this.display,
    this.ascentOverride,
    this.descentOverride,
    this.lineGapOverride,
  });
}

typedef FontFaceLoadStatus = String;

abstract interface class FontFaceSet {
  factory FontFaceSet(List<FontFace> initialFaces) =>
      WebRuntime.current.createWebObject<FontFaceSet>(
        'FontFaceSet',
        [initialFaces],
      );
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
  factory FontFaceSetLoadEvent(Object type, [FontFaceSetLoadEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<FontFaceSetLoadEvent>(
        'FontFaceSetLoadEvent',
        [type, eventInitDict],
      );
  List<FontFace> get fontfaces;
}

abstract interface class FontFaceSetLoadEventInit {
  List<FontFace>? get fontfaces;
  set fontfaces(List<FontFace>? value);
}

final class FontFaceSetLoadEventInitValue implements FontFaceSetLoadEventInit {
  @override
  List<FontFace>? fontfaces;

  FontFaceSetLoadEventInitValue({
    this.fontfaces,
  });
}

typedef FontFaceSetLoadStatus = String;

abstract interface class FontFaceSource {
  FontFaceSet get fonts;
}

