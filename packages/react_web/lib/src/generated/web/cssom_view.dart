// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: cssom-view
// ignore_for_file: type=lint

import 'dom.dart';
import 'css_nav.dart';
import 'svg.dart';
import 'geometry.dart';
import 'css_typed_om.dart';
import 'cssom.dart';
import 'html.dart';
import 'pointerlock.dart';
import 'anonymous_iframe.dart';
import 'trusted_types.dart';
import 'screen_orientation.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class BoxQuadOptions {
  CSSBoxType? get box;
  set box(CSSBoxType? value);
  GeometryNode? get relativeTo;
  set relativeTo(GeometryNode? value);
}

final class BoxQuadOptionsValue implements BoxQuadOptions {
  @override
  CSSBoxType? box;
  @override
  GeometryNode? relativeTo;

  BoxQuadOptionsValue({
    this.box,
    this.relativeTo,
  });
}

typedef CSSBoxType = String;

abstract interface class CaretPositionFromPointOptions {
  List<ShadowRoot>? get shadowRoots;
  set shadowRoots(List<ShadowRoot>? value);
}

final class CaretPositionFromPointOptionsValue implements CaretPositionFromPointOptions {
  @override
  List<ShadowRoot>? shadowRoots;

  CaretPositionFromPointOptionsValue({
    this.shadowRoots,
  });
}

abstract interface class CheckVisibilityOptions {
  bool? get checkOpacity;
  set checkOpacity(bool? value);
  bool? get checkVisibilityCSS;
  set checkVisibilityCSS(bool? value);
  bool? get contentVisibilityAuto;
  set contentVisibilityAuto(bool? value);
  bool? get opacityProperty;
  set opacityProperty(bool? value);
  bool? get visibilityProperty;
  set visibilityProperty(bool? value);
}

final class CheckVisibilityOptionsValue implements CheckVisibilityOptions {
  @override
  bool? checkOpacity;
  @override
  bool? checkVisibilityCSS;
  @override
  bool? contentVisibilityAuto;
  @override
  bool? opacityProperty;
  @override
  bool? visibilityProperty;

  CheckVisibilityOptionsValue({
    this.checkOpacity,
    this.checkVisibilityCSS,
    this.contentVisibilityAuto,
    this.opacityProperty,
    this.visibilityProperty,
  });
}

abstract interface class ConvertCoordinateOptions {
  CSSBoxType? get fromBox;
  set fromBox(CSSBoxType? value);
  CSSBoxType? get toBox;
  set toBox(CSSBoxType? value);
}

final class ConvertCoordinateOptionsValue implements ConvertCoordinateOptions {
  @override
  CSSBoxType? fromBox;
  @override
  CSSBoxType? toBox;

  ConvertCoordinateOptionsValue({
    this.fromBox,
    this.toBox,
  });
}

typedef GeometryNode = Object;

abstract interface class GeometryUtils {
  List<DOMQuad> getBoxQuads([BoxQuadOptions? options]);
  DOMQuad convertQuadFromNode(DOMQuadInit quad, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMQuad convertRectFromNode(DOMRectReadOnly rect, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMPoint convertPointFromNode(DOMPointInit point, GeometryNode from, [ConvertCoordinateOptions? options]);
}

abstract interface class HTMLElement {
  factory HTMLElement() =>
      WebRuntime.current.createWebObject<HTMLElement>(
        'HTMLElement',
        [],
      );
  StylePropertyMap get attributeStyleMap;
  CSSStyleDeclaration get style;
  EventHandler get onanimationstart;
   set onanimationstart(EventHandler value);
  EventHandler get onanimationiteration;
   set onanimationiteration(EventHandler value);
  EventHandler get onanimationend;
   set onanimationend(EventHandler value);
  EventHandler get onanimationcancel;
   set onanimationcancel(EventHandler value);
  EventHandler get onsnapchanged;
   set onsnapchanged(EventHandler value);
  EventHandler get onsnapchanging;
   set onsnapchanging(EventHandler value);
  EventHandler get ontransitionrun;
   set ontransitionrun(EventHandler value);
  EventHandler get ontransitionstart;
   set ontransitionstart(EventHandler value);
  EventHandler get ontransitionend;
   set ontransitionend(EventHandler value);
  EventHandler get ontransitioncancel;
   set ontransitioncancel(EventHandler value);
  EventHandler get onabort;
   set onabort(EventHandler value);
  EventHandler get onauxclick;
   set onauxclick(EventHandler value);
  EventHandler get onbeforeinput;
   set onbeforeinput(EventHandler value);
  EventHandler get onbeforematch;
   set onbeforematch(EventHandler value);
  EventHandler get onbeforetoggle;
   set onbeforetoggle(EventHandler value);
  EventHandler get onblur;
   set onblur(EventHandler value);
  EventHandler get oncancel;
   set oncancel(EventHandler value);
  EventHandler get oncanplay;
   set oncanplay(EventHandler value);
  EventHandler get oncanplaythrough;
   set oncanplaythrough(EventHandler value);
  EventHandler get onchange;
   set onchange(EventHandler value);
  EventHandler get onclick;
   set onclick(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
  EventHandler get oncontextlost;
   set oncontextlost(EventHandler value);
  EventHandler get oncontextmenu;
   set oncontextmenu(EventHandler value);
  EventHandler get oncontextrestored;
   set oncontextrestored(EventHandler value);
  EventHandler get oncopy;
   set oncopy(EventHandler value);
  EventHandler get oncuechange;
   set oncuechange(EventHandler value);
  EventHandler get oncut;
   set oncut(EventHandler value);
  EventHandler get ondblclick;
   set ondblclick(EventHandler value);
  EventHandler get ondrag;
   set ondrag(EventHandler value);
  EventHandler get ondragend;
   set ondragend(EventHandler value);
  EventHandler get ondragenter;
   set ondragenter(EventHandler value);
  EventHandler get ondragleave;
   set ondragleave(EventHandler value);
  EventHandler get ondragover;
   set ondragover(EventHandler value);
  EventHandler get ondragstart;
   set ondragstart(EventHandler value);
  EventHandler get ondrop;
   set ondrop(EventHandler value);
  EventHandler get ondurationchange;
   set ondurationchange(EventHandler value);
  EventHandler get onemptied;
   set onemptied(EventHandler value);
  EventHandler get onended;
   set onended(EventHandler value);
  OnErrorEventHandler get onerror;
   set onerror(OnErrorEventHandler value);
  EventHandler get onfocus;
   set onfocus(EventHandler value);
  EventHandler get onformdata;
   set onformdata(EventHandler value);
  EventHandler get oninput;
   set oninput(EventHandler value);
  EventHandler get oninvalid;
   set oninvalid(EventHandler value);
  EventHandler get onkeydown;
   set onkeydown(EventHandler value);
  EventHandler get onkeypress;
   set onkeypress(EventHandler value);
  EventHandler get onkeyup;
   set onkeyup(EventHandler value);
  EventHandler get onload;
   set onload(EventHandler value);
  EventHandler get onloadeddata;
   set onloadeddata(EventHandler value);
  EventHandler get onloadedmetadata;
   set onloadedmetadata(EventHandler value);
  EventHandler get onloadstart;
   set onloadstart(EventHandler value);
  EventHandler get onmousedown;
   set onmousedown(EventHandler value);
  EventHandler get onmouseenter;
   set onmouseenter(EventHandler value);
  EventHandler get onmouseleave;
   set onmouseleave(EventHandler value);
  EventHandler get onmousemove;
   set onmousemove(EventHandler value);
  EventHandler get onmouseout;
   set onmouseout(EventHandler value);
  EventHandler get onmouseover;
   set onmouseover(EventHandler value);
  EventHandler get onmouseup;
   set onmouseup(EventHandler value);
  EventHandler get onpaste;
   set onpaste(EventHandler value);
  EventHandler get onpause;
   set onpause(EventHandler value);
  EventHandler get onplay;
   set onplay(EventHandler value);
  EventHandler get onplaying;
   set onplaying(EventHandler value);
  EventHandler get onprogress;
   set onprogress(EventHandler value);
  EventHandler get onratechange;
   set onratechange(EventHandler value);
  EventHandler get onreset;
   set onreset(EventHandler value);
  EventHandler get onresize;
   set onresize(EventHandler value);
  EventHandler get onscroll;
   set onscroll(EventHandler value);
  EventHandler get onscrollend;
   set onscrollend(EventHandler value);
  EventHandler get onsecuritypolicyviolation;
   set onsecuritypolicyviolation(EventHandler value);
  EventHandler get onseeked;
   set onseeked(EventHandler value);
  EventHandler get onseeking;
   set onseeking(EventHandler value);
  EventHandler get onselect;
   set onselect(EventHandler value);
  EventHandler get onslotchange;
   set onslotchange(EventHandler value);
  EventHandler get onstalled;
   set onstalled(EventHandler value);
  EventHandler get onsubmit;
   set onsubmit(EventHandler value);
  EventHandler get onsuspend;
   set onsuspend(EventHandler value);
  EventHandler get ontimeupdate;
   set ontimeupdate(EventHandler value);
  EventHandler get ontoggle;
   set ontoggle(EventHandler value);
  EventHandler get onvolumechange;
   set onvolumechange(EventHandler value);
  EventHandler get onwaiting;
   set onwaiting(EventHandler value);
  EventHandler get onwebkitanimationend;
   set onwebkitanimationend(EventHandler value);
  EventHandler get onwebkitanimationiteration;
   set onwebkitanimationiteration(EventHandler value);
  EventHandler get onwebkitanimationstart;
   set onwebkitanimationstart(EventHandler value);
  EventHandler get onwebkittransitionend;
   set onwebkittransitionend(EventHandler value);
  EventHandler get onwheel;
   set onwheel(EventHandler value);
  EventHandler get onpointerover;
   set onpointerover(EventHandler value);
  EventHandler get onpointerenter;
   set onpointerenter(EventHandler value);
  EventHandler get onpointerdown;
   set onpointerdown(EventHandler value);
  EventHandler get onpointermove;
   set onpointermove(EventHandler value);
  EventHandler get onpointerrawupdate;
   set onpointerrawupdate(EventHandler value);
  EventHandler get onpointerup;
   set onpointerup(EventHandler value);
  EventHandler get onpointercancel;
   set onpointercancel(EventHandler value);
  EventHandler get onpointerout;
   set onpointerout(EventHandler value);
  EventHandler get onpointerleave;
   set onpointerleave(EventHandler value);
  EventHandler get ongotpointercapture;
   set ongotpointercapture(EventHandler value);
  EventHandler get onlostpointercapture;
   set onlostpointercapture(EventHandler value);
  EventHandler get onselectstart;
   set onselectstart(EventHandler value);
  EventHandler get onselectionchange;
   set onselectionchange(EventHandler value);
  EventHandler get ontouchstart;
   set ontouchstart(EventHandler value);
  EventHandler get ontouchend;
   set ontouchend(EventHandler value);
  EventHandler get ontouchmove;
   set ontouchmove(EventHandler value);
  EventHandler get ontouchcancel;
   set ontouchcancel(EventHandler value);
  EventHandler get onbeforexrselect;
   set onbeforexrselect(EventHandler value);
  String get contentEditable;
   set contentEditable(String value);
  String get enterKeyHint;
   set enterKeyHint(String value);
  bool get isContentEditable;
  String get inputMode;
   set inputMode(String value);
  String get virtualKeyboardPolicy;
   set virtualKeyboardPolicy(String value);
  DOMStringMap get dataset;
  String get nonce;
   set nonce(String value);
  bool get autofocus;
   set autofocus(bool value);
  int get tabIndex;
   set tabIndex(int value);
  void focus([FocusOptions? options]);
  void blur();
  Element? get offsetParent;
  int get offsetTop;
  int get offsetLeft;
  int get offsetWidth;
  int get offsetHeight;
  String get title;
   set title(String value);
  String get lang;
   set lang(String value);
  bool get translate;
   set translate(bool value);
  String get dir;
   set dir(String value);
  Object get hidden;
   set hidden(Object value);
  bool get inert;
   set inert(bool value);
  void click();
  String get accessKey;
   set accessKey(String value);
  String get accessKeyLabel;
  bool get draggable;
   set draggable(bool value);
  bool get spellcheck;
   set spellcheck(bool value);
  String get autocapitalize;
   set autocapitalize(String value);
  String get innerText;
   set innerText(String value);
  String get outerText;
   set outerText(String value);
  ElementInternals attachInternals();
  void showPopover();
  void hidePopover();
  bool togglePopover([bool? force]);
  String? get popover;
   set popover(String? value);
}

abstract interface class HTMLImageElement {
  factory HTMLImageElement() =>
      WebRuntime.current.createWebObject<HTMLImageElement>(
        'HTMLImageElement',
        [],
      );
  String get attributionSrc;
   set attributionSrc(String value);
  bool get sharedStorageWritable;
   set sharedStorageWritable(bool value);
  int get x;
  int get y;
  String get alt;
   set alt(String value);
  String get src;
   set src(String value);
  String get srcset;
   set srcset(String value);
  String get sizes;
   set sizes(String value);
  String? get crossOrigin;
   set crossOrigin(String? value);
  String get useMap;
   set useMap(String value);
  bool get isMap;
   set isMap(bool value);
  int get width;
   set width(int value);
  int get height;
   set height(int value);
  int get naturalWidth;
  int get naturalHeight;
  bool get complete;
  String get currentSrc;
  String get referrerPolicy;
   set referrerPolicy(String value);
  String get decoding;
   set decoding(String value);
  String get loading;
   set loading(String value);
  String get fetchPriority;
   set fetchPriority(String value);
  Future<void> decode();
  String get name;
   set name(String value);
  String get lowsrc;
   set lowsrc(String value);
  String get align;
   set align(String value);
  int get hspace;
   set hspace(int value);
  int get vspace;
   set vspace(int value);
  String get longDesc;
   set longDesc(String value);
  String get border;
   set border(String value);
}

abstract interface class MediaQueryList {
  Object get media;
  bool get matches;
  void addListener(EventListener? callback);
  void removeListener(EventListener? callback);
  EventHandler get onchange;
   set onchange(EventHandler value);
}

abstract interface class MediaQueryListEvent {
  factory MediaQueryListEvent(Object type, [MediaQueryListEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<MediaQueryListEvent>(
        'MediaQueryListEvent',
        [type, eventInitDict],
      );
  Object get media;
  bool get matches;
}

abstract interface class MediaQueryListEventInit {
  Object? get media;
  set media(Object? value);
  bool? get matches;
  set matches(bool? value);
}

final class MediaQueryListEventInitValue implements MediaQueryListEventInit {
  @override
  Object? media;
  @override
  bool? matches;

  MediaQueryListEventInitValue({
    this.media,
    this.matches,
  });
}

abstract interface class MouseEvent {
  factory MouseEvent(String type, [MouseEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<MouseEvent>(
        'MouseEvent',
        [type, eventInitDict],
      );
  double get pageX;
  double get pageY;
  double get x;
  double get y;
  double get offsetX;
  double get offsetY;
  double get movementX;
  double get movementY;
  int get screenX;
  int get screenY;
  int get clientX;
  int get clientY;
  bool get ctrlKey;
  bool get shiftKey;
  bool get altKey;
  bool get metaKey;
  int get button;
  int get buttons;
  EventTarget? get relatedTarget;
  bool getModifierState(String keyArg);
  void initMouseEvent(String typeArg, [bool? bubblesArg, bool? cancelableArg, Window? viewArg, int? detailArg, int? screenXArg, int? screenYArg, int? clientXArg, int? clientYArg, bool? ctrlKeyArg, bool? altKeyArg, bool? shiftKeyArg, bool? metaKeyArg, int? buttonArg, EventTarget? relatedTargetArg]);
}

abstract interface class Range {
  factory Range() =>
      WebRuntime.current.createWebObject<Range>(
        'Range',
        [],
      );
  DOMRectList getClientRects();
  DOMRect getBoundingClientRect();
  Node get commonAncestorContainer;
  void setStart(Node node, int offset);
  void setEnd(Node node, int offset);
  void setStartBefore(Node node);
  void setStartAfter(Node node);
  void setEndBefore(Node node);
  void setEndAfter(Node node);
  void collapse([bool? toStart]);
  void selectNode(Node node);
  void selectNodeContents(Node node);
  int compareBoundaryPoints(int how, Range sourceRange);
  void deleteContents();
  DocumentFragment extractContents();
  DocumentFragment cloneContents();
  void insertNode(Node node);
  void surroundContents(Node newParent);
  Range cloneRange();
  void detach();
  bool isPointInRange(Node node, int offset);
  int comparePoint(Node node, int offset);
  bool intersectsNode(Node node);
  DocumentFragment createContextualFragment(Object string);
}

abstract interface class Screen {
  int get availWidth;
  int get availHeight;
  int get width;
  int get height;
  int get colorDepth;
  int get pixelDepth;
  ScreenOrientation get orientation;
  EventHandler get onchange;
   set onchange(EventHandler value);
}

typedef ScrollBehavior = String;

abstract interface class ScrollIntoViewOptions {
  ScrollLogicalPosition? get block;
  set block(ScrollLogicalPosition? value);
  ScrollLogicalPosition? get inline;
  set inline(ScrollLogicalPosition? value);
}

final class ScrollIntoViewOptionsValue implements ScrollIntoViewOptions {
  @override
  ScrollLogicalPosition? block;
  @override
  ScrollLogicalPosition? inline;

  ScrollIntoViewOptionsValue({
    this.block,
    this.inline,
  });
}

typedef ScrollLogicalPosition = String;

abstract interface class ScrollOptions {
  ScrollBehavior? get behavior;
  set behavior(ScrollBehavior? value);
}

final class ScrollOptionsValue implements ScrollOptions {
  @override
  ScrollBehavior? behavior;

  ScrollOptionsValue({
    this.behavior,
  });
}

abstract interface class ScrollToOptions {
  double? get left;
  set left(double? value);
  double? get top;
  set top(double? value);
}

final class ScrollToOptionsValue implements ScrollToOptions {
  @override
  double? left;
  @override
  double? top;

  ScrollToOptionsValue({
    this.left,
    this.top,
  });
}

abstract interface class VisualViewport {
  double get offsetLeft;
  double get offsetTop;
  double get pageLeft;
  double get pageTop;
  double get width;
  double get height;
  double get scale;
  EventHandler get onresize;
   set onresize(EventHandler value);
  EventHandler get onscroll;
   set onscroll(EventHandler value);
  EventHandler get onscrollend;
   set onscrollend(EventHandler value);
}

