// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: cssom
// ignore_for_file: type=lint

import 'css_animations.dart';
import 'css_nav.dart';
import 'web_animations_2.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

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

abstract interface class CSSNamespaceRule {
  Object get namespaceURI;
  Object get prefix;
}

abstract interface class CSSPageRule {
  Object get selectorText;
   set selectorText(Object value);
  Object get style;
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

abstract interface class CSSStyleSheet {
  factory CSSStyleSheet([CSSStyleSheetInit? options]) =>
      WebRuntime.current.createWebObject<CSSStyleSheet>(
        'CSSStyleSheet',
        [options],
      );
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
  String? get baseURL;
  set baseURL(String? value);
  Object? get media;
  set media(Object? value);
  bool? get disabled;
  set disabled(bool? value);
}

final class CSSStyleSheetInitValue implements CSSStyleSheetInit {
  @override
  String? baseURL;
  @override
  Object? media;
  @override
  bool? disabled;

  CSSStyleSheetInitValue({
    this.baseURL,
    this.media,
    this.disabled,
  });
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

