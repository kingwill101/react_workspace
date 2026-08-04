// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: cssom
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_animations.dart';
import 'css_nav.dart';
import 'web_animations_2.dart';
import 'dom.dart';

abstract interface class CSSGroupingRule {
  CSSRuleList get cssRules;
  int insertRule(Object rule, [int? index]);
  void deleteRule(int index);
}

abstract interface class CSSImportRule {
  String get href;
  MediaList get media;
  CSSStyleSheet? get styleSheet;
  Object get layerName;
  Object get supportsText;
}

abstract interface class CSSMarginRule {
  Object get name;
  CSSStyleDeclaration get style;
}

abstract interface class CSSNamespaceRule {
  Object get namespaceURI;
  Object get prefix;
}

abstract interface class CSSPageDescriptors {
  Object get margin;
   set margin(Object value);
  Object get marginTop;
   set marginTop(Object value);
  Object get marginRight;
   set marginRight(Object value);
  Object get marginBottom;
   set marginBottom(Object value);
  Object get marginLeft;
   set marginLeft(Object value);
  Object get margin_top;
   set margin_top(Object value);
  Object get margin_right;
   set margin_right(Object value);
  Object get margin_bottom;
   set margin_bottom(Object value);
  Object get margin_left;
   set margin_left(Object value);
  Object get size;
   set size(Object value);
  Object get pageOrientation;
   set pageOrientation(Object value);
  Object get page_orientation;
   set page_orientation(Object value);
  Object get marks;
   set marks(Object value);
  Object get bleed;
   set bleed(Object value);
}

abstract interface class CSSPageRule {
  Object get selectorText;
   set selectorText(Object value);
  CSSPageDescriptors get style;
}

abstract interface class CSSRuleList {
  CSSRule? item(int index);
  int get length;
}

abstract interface class CSSStyleDeclaration {
  Object get cssText;
   set cssText(Object value);
  int get length;
  Object item(int index);
  Object getPropertyValue(Object property);
  Object getPropertyPriority(Object property);
  void setProperty(Object property, Object value, [Object? priority]);
  Object removeProperty(Object property);
  CSSRule? get parentRule;
}

abstract interface class CSSStyleProperties {
  Object get cssFloat;
   set cssFloat(Object value);
}

abstract interface class CSSStyleSheet {
  CSSRule? get ownerRule;
  CSSRuleList get cssRules;
  int insertRule(Object rule, [int? index]);
  void deleteRule(int index);
  Future<CSSStyleSheet> replace(String text);
  void replaceSync(String text);
  CSSRuleList get rules;
  int addRule([String? selector, String? style, int? index]);
  void removeRule([int? index]);
}

abstract interface class CSSStyleSheetInit {
  String get baseURL;
  set baseURL(String value);
  Object get media;
  set media(Object value);
  bool get disabled;
  set disabled(bool value);
}

abstract interface class DocumentOrShadowRoot {
  StyleSheetList get styleSheets;
  List<CSSStyleSheet> get adoptedStyleSheets;
   set adoptedStyleSheets(List<CSSStyleSheet> value);
  Element? get fullscreenElement;
  Element? get activeElement;
  Element? get pictureInPictureElement;
  Element? get pointerLockElement;
  List<Animation> getAnimations();
}

abstract interface class LinkStyle {
  CSSStyleSheet? get sheet;
}

abstract interface class MediaList {
  Object get mediaText;
   set mediaText(Object value);
  int get length;
  Object item(int index);
  void appendMedium(Object medium);
  void deleteMedium(Object medium);
}

abstract interface class StyleSheet {
  Object get type;
  String? get href;
  Object get ownerNode;
  CSSStyleSheet? get parentStyleSheet;
  String? get title;
  MediaList get media;
  bool get disabled;
   set disabled(bool value);
}

abstract interface class StyleSheetList {
  CSSStyleSheet? item(int index);
  int get length;
}

