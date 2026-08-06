// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-nav
// ignore_for_file: type=lint

import 'cssom_view.dart';
import 'geometry.dart';
import 'dom.dart';
import 'trusted_types.dart';
import 'html.dart';
import 'web_animations_2.dart';
import 'web_animations.dart';
import 'css_typed_om.dart';
import 'fullscreen.dart';
import 'pointerlock.dart';
import 'input_device_capabilities.dart';

abstract interface class Element {
  Object get regionOverset;
  List<Range>? getRegionFlowRanges();
  List<DOMQuad> getBoxQuads([BoxQuadOptions? options]);
  DOMQuad convertQuadFromNode(DOMQuadInit quad, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMQuad convertRectFromNode(DOMRectReadOnly rect, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMPoint convertPointFromNode(DOMPointInit point, GeometryNode from, [ConvertCoordinateOptions? options]);
  HTMLCollection get children;
  Element? get firstElementChild;
  Element? get lastElementChild;
  int get childElementCount;
  void prepend([List<Object>? nodes]);
  void append([List<Object>? nodes]);
  void replaceChildren([List<Object>? nodes]);
  Element? querySelector(String selectors);
  NodeList querySelectorAll(String selectors);
  Element? get previousElementSibling;
  Element? get nextElementSibling;
  void before([List<Object>? nodes]);
  void after([List<Object>? nodes]);
  void replaceWith([List<Object>? nodes]);
  void remove();
  HTMLSlotElement? get assignedSlot;
  String? get role;
   set role(String? value);
  Element? get ariaActiveDescendantElement;
   set ariaActiveDescendantElement(Element? value);
  String? get ariaAtomic;
   set ariaAtomic(String? value);
  String? get ariaAutoComplete;
   set ariaAutoComplete(String? value);
  String? get ariaBrailleLabel;
   set ariaBrailleLabel(String? value);
  String? get ariaBrailleRoleDescription;
   set ariaBrailleRoleDescription(String? value);
  String? get ariaBusy;
   set ariaBusy(String? value);
  String? get ariaChecked;
   set ariaChecked(String? value);
  String? get ariaColCount;
   set ariaColCount(String? value);
  String? get ariaColIndex;
   set ariaColIndex(String? value);
  String? get ariaColIndexText;
   set ariaColIndexText(String? value);
  String? get ariaColSpan;
   set ariaColSpan(String? value);
  List<Element>? get ariaControlsElements;
   set ariaControlsElements(List<Element>? value);
  String? get ariaCurrent;
   set ariaCurrent(String? value);
  List<Element>? get ariaDescribedByElements;
   set ariaDescribedByElements(List<Element>? value);
  String? get ariaDescription;
   set ariaDescription(String? value);
  List<Element>? get ariaDetailsElements;
   set ariaDetailsElements(List<Element>? value);
  String? get ariaDisabled;
   set ariaDisabled(String? value);
  List<Element>? get ariaErrorMessageElements;
   set ariaErrorMessageElements(List<Element>? value);
  String? get ariaExpanded;
   set ariaExpanded(String? value);
  List<Element>? get ariaFlowToElements;
   set ariaFlowToElements(List<Element>? value);
  String? get ariaHasPopup;
   set ariaHasPopup(String? value);
  String? get ariaHidden;
   set ariaHidden(String? value);
  String? get ariaInvalid;
   set ariaInvalid(String? value);
  String? get ariaKeyShortcuts;
   set ariaKeyShortcuts(String? value);
  String? get ariaLabel;
   set ariaLabel(String? value);
  List<Element>? get ariaLabelledByElements;
   set ariaLabelledByElements(List<Element>? value);
  String? get ariaLevel;
   set ariaLevel(String? value);
  String? get ariaLive;
   set ariaLive(String? value);
  String? get ariaModal;
   set ariaModal(String? value);
  String? get ariaMultiLine;
   set ariaMultiLine(String? value);
  String? get ariaMultiSelectable;
   set ariaMultiSelectable(String? value);
  String? get ariaOrientation;
   set ariaOrientation(String? value);
  List<Element>? get ariaOwnsElements;
   set ariaOwnsElements(List<Element>? value);
  String? get ariaPlaceholder;
   set ariaPlaceholder(String? value);
  String? get ariaPosInSet;
   set ariaPosInSet(String? value);
  String? get ariaPressed;
   set ariaPressed(String? value);
  String? get ariaReadOnly;
   set ariaReadOnly(String? value);
  String? get ariaRequired;
   set ariaRequired(String? value);
  String? get ariaRoleDescription;
   set ariaRoleDescription(String? value);
  String? get ariaRowCount;
   set ariaRowCount(String? value);
  String? get ariaRowIndex;
   set ariaRowIndex(String? value);
  String? get ariaRowIndexText;
   set ariaRowIndexText(String? value);
  String? get ariaRowSpan;
   set ariaRowSpan(String? value);
  String? get ariaSelected;
   set ariaSelected(String? value);
  String? get ariaSetSize;
   set ariaSetSize(String? value);
  String? get ariaSort;
   set ariaSort(String? value);
  String? get ariaValueMax;
   set ariaValueMax(String? value);
  String? get ariaValueMin;
   set ariaValueMin(String? value);
  String? get ariaValueNow;
   set ariaValueNow(String? value);
  String? get ariaValueText;
   set ariaValueText(String? value);
  Animation animate(Object? keyframes, [Object? options]);
  List<Animation> getAnimations([GetAnimationsOptions? options]);
  DOMTokenList get part_;
  StylePropertyMapReadOnly computedStyleMap();
  DOMRectList getClientRects();
  DOMRect getBoundingClientRect();
  bool checkVisibility([CheckVisibilityOptions? options]);
  void scrollIntoView([Object? arg]);
  void scroll(double x, double y);
  void scrollTo(double x, double y);
  void scrollBy(double x, double y);
  double get scrollTop;
   set scrollTop(double value);
  double get scrollLeft;
   set scrollLeft(double value);
  int get scrollWidth;
  int get scrollHeight;
  int get clientTop;
  int get clientLeft;
  int get clientWidth;
  int get clientHeight;
  String? get namespaceURI;
  String? get prefix;
  String get localName;
  String get tagName;
  String get id;
   set id(String value);
  String get className;
   set className(String value);
  DOMTokenList get classList;
  String get slot;
   set slot(String value);
  bool hasAttributes();
  NamedNodeMap get attributes;
  List<String> getAttributeNames();
  String? getAttribute(String qualifiedName);
  String? getAttributeNS(String? namespace, String localName);
  void setAttribute(String qualifiedName, String value);
  void setAttributeNS(String? namespace, String qualifiedName, String value);
  void removeAttribute(String qualifiedName);
  void removeAttributeNS(String? namespace, String localName);
  bool toggleAttribute(String qualifiedName, [bool? force]);
  bool hasAttribute(String qualifiedName);
  bool hasAttributeNS(String? namespace, String localName);
  Attr? getAttributeNode(String qualifiedName);
  Attr? getAttributeNodeNS(String? namespace, String localName);
  Attr? setAttributeNode(Attr attr);
  Attr? setAttributeNodeNS(Attr attr);
  Attr removeAttributeNode(Attr attr);
  ShadowRoot attachShadow(ShadowRootInit init);
  ShadowRoot? get shadowRoot;
  Element? closest(String selectors);
  bool matches(String selectors);
  HTMLCollection getElementsByTagName(String qualifiedName);
  HTMLCollection getElementsByTagNameNS(String? namespace, String localName);
  HTMLCollection getElementsByClassName(String classNames);
  Element? insertAdjacentElement(String where, Element element);
  void insertAdjacentText(String where, String data);
  Future<void> requestFullscreen([FullscreenOptions? options]);
  EventHandler get onfullscreenchange;
   set onfullscreenchange(EventHandler value);
  EventHandler get onfullscreenerror;
   set onfullscreenerror(EventHandler value);
  void setHTMLUnsafe(Object html);
  String getHTML([GetHTMLOptions? options]);
  Object get innerHTML;
   set innerHTML(Object value);
  Object get outerHTML;
   set outerHTML(Object value);
  void insertAdjacentHTML(String position, Object string);
  void setPointerCapture(int pointerId);
  void releasePointerCapture(int pointerId);
  bool hasPointerCapture(int pointerId);
  Future<void> requestPointerLock([PointerLockOptions? options]);
}

typedef FocusableAreaSearchMode = String;

abstract interface class FocusableAreasOption {
  FocusableAreaSearchMode? get mode;
  set mode(FocusableAreaSearchMode? value);
}

final class FocusableAreasOptionValue implements FocusableAreasOption {
  @override
  FocusableAreaSearchMode? mode;

  FocusableAreasOptionValue({
    this.mode,
  });
}

abstract interface class NavigationEventInit {
  SpatialNavigationDirection? get dir;
  set dir(SpatialNavigationDirection? value);
  EventTarget? get relatedTarget;
  set relatedTarget(EventTarget? value);
}

final class NavigationEventInitValue implements NavigationEventInit {
  @override
  SpatialNavigationDirection? dir;
  @override
  EventTarget? relatedTarget;

  NavigationEventInitValue({
    this.dir,
    this.relatedTarget,
  });
}

typedef SpatialNavigationDirection = String;

abstract interface class SpatialNavigationSearchOptions {
  List<Node>? get candidates;
  set candidates(List<Node>? value);
  Node? get container;
  set container(Node? value);
}

final class SpatialNavigationSearchOptionsValue implements SpatialNavigationSearchOptions {
  @override
  List<Node>? candidates;
  @override
  Node? container;

  SpatialNavigationSearchOptionsValue({
    this.candidates,
    this.container,
  });
}

