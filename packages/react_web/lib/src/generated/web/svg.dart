// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: SVG
// ignore_for_file: type=lint

import 'css_font_loading.dart';
import 'geometry.dart';
import 'cssom_view.dart';
import 'css_nav.dart';
import 'cssom.dart';
import 'web_animations_2.dart';
import 'dom.dart';
import 'trusted_types.dart';
import 'html.dart';
import 'css_view_transitions_2.dart';
import 'css_view_transitions.dart';
import 'selection_api.dart';
import 'web_animations.dart';
import 'css_typed_om.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Document {
  factory Document() =>
      WebRuntime.current.createWebObject<Document>(
        'Document',
        [],
      );
  FontFaceSet get fonts;
  List<DOMQuad> getBoxQuads([BoxQuadOptions? options]);
  DOMQuad convertQuadFromNode(DOMQuadInit quad, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMQuad convertRectFromNode(DOMRectReadOnly rect, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMPoint convertPointFromNode(DOMPointInit point, GeometryNode from, [ConvertCoordinateOptions? options]);
  Element? getElementById(String elementId);
  StyleSheetList get styleSheets;
  List<CSSStyleSheet> get adoptedStyleSheets;
   set adoptedStyleSheets(List<CSSStyleSheet> value);
  Element? get fullscreenElement;
  Element? get activeElement;
  Element? get pictureInPictureElement;
  Element? get pointerLockElement;
  List<Animation> getAnimations();
  HTMLCollection get children;
  Element? get firstElementChild;
  Element? get lastElementChild;
  int get childElementCount;
  void prepend([List<Object>? nodes]);
  void append([List<Object>? nodes]);
  void replaceChildren([List<Object>? nodes]);
  Element? querySelector(String selectors);
  NodeList querySelectorAll(String selectors);
  XPathExpression createExpression(String expression, [XPathNSResolver? resolver]);
  Node createNSResolver(Node nodeResolver);
  XPathResult evaluate(String expression, Node contextNode, [XPathNSResolver? resolver, int? type, XPathResult? result]);
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
  SVGSVGElement? get rootElement;
  ViewTransition startViewTransition([Object? callbackOptions]);
  Element? elementFromPoint(double x, double y);
  List<Element> elementsFromPoint(double x, double y);
  Object caretPositionFromPoint(double x, double y, [CaretPositionFromPointOptions? options]);
  Element? get scrollingElement;
  DOMImplementation get implementation;
  String get url;
  String get documentURI;
  String get compatMode;
  String get characterSet;
  String get contentType;
  DocumentType? get doctype;
  Element? get documentElement;
  HTMLCollection getElementsByTagName(String qualifiedName);
  HTMLCollection getElementsByTagNameNS(String? namespace, String localName);
  HTMLCollection getElementsByClassName(String classNames);
  Element createElement(String localName, [Object? options]);
  Element createElementNS(String? namespace, String qualifiedName, [Object? options]);
  DocumentFragment createDocumentFragment();
  Text createTextNode(String data);
  CDATASection createCDATASection(String data);
  Comment createComment(String data);
  ProcessingInstruction createProcessingInstruction(String target, String data);
  Node importNode(Node node, [bool? deep]);
  Node adoptNode(Node node);
  Attr createAttribute(String localName);
  Attr createAttributeNS(String? namespace, String qualifiedName);
  Event createEvent(String interface_);
  Range createRange();
  NodeIterator createNodeIterator(Node root, [int? whatToShow, NodeFilter? filter]);
  TreeWalker createTreeWalker(Node root, [int? whatToShow, NodeFilter? filter]);
  bool get fullscreenEnabled;
  bool get fullscreen;
  Future<void> exitFullscreen();
  EventHandler get onfullscreenchange;
   set onfullscreenchange(EventHandler value);
  EventHandler get onfullscreenerror;
   set onfullscreenerror(EventHandler value);
  Location? get location;
  String get domain;
   set domain(String value);
  String get referrer;
  String get cookie;
   set cookie(String value);
  String get lastModified;
  DocumentReadyState get readyState;
  String get title;
   set title(String value);
  String get dir;
   set dir(String value);
  HTMLElement? get body;
   set body(HTMLElement? value);
  HTMLHeadElement? get head;
  HTMLCollection get images;
  HTMLCollection get embeds;
  HTMLCollection get plugins;
  HTMLCollection get links;
  HTMLCollection get forms;
  HTMLCollection get scripts;
  NodeList getElementsByName(String elementName);
  HTMLOrSVGScriptElement? get currentScript;
  Object open(String url, String name, String features);
  void close();
  void write([List<Object>? text]);
  void writeln([List<Object>? text]);
  Object get defaultView;
  bool hasFocus();
  String get designMode;
   set designMode(String value);
  bool execCommand(String commandId, [bool? showUI, String? value]);
  bool queryCommandIndeterm(String commandId);
  String queryCommandValue(String commandId);
  bool get hidden;
  DocumentVisibilityState get visibilityState;
  EventHandler get onreadystatechange;
   set onreadystatechange(EventHandler value);
  EventHandler get onvisibilitychange;
   set onvisibilitychange(EventHandler value);
  String get fgColor;
   set fgColor(String value);
  String get linkColor;
   set linkColor(String value);
  String get vlinkColor;
   set vlinkColor(String value);
  String get alinkColor;
   set alinkColor(String value);
  String get bgColor;
   set bgColor(String value);
  HTMLCollection get anchors;
  HTMLCollection get applets;
  void clear();
  void captureEvents();
  void releaseEvents();
  HTMLAllCollection get all;
  EventHandler get onresume;
   set onresume(EventHandler value);
  bool get pictureInPictureEnabled;
  Future<void> exitPictureInPicture();
  EventHandler get onpointerlockchange;
   set onpointerlockchange(EventHandler value);
  EventHandler get onpointerlockerror;
   set onpointerlockerror(EventHandler value);
  void exitPointerLock();
  Future<bool> hasUnpartitionedCookieAccess();
  Selection? getSelection();
  Future<bool> hasStorageAccess();
  Future<void> requestStorageAccess();
  DocumentTimeline get timeline;
}

abstract interface class GetSVGDocument {
  Document getSVGDocument();
}

abstract interface class SVGAElement {
  SVGAnimatedString get href;
  SVGAnimatedString get target;
  String get download;
   set download(String value);
  String get ping;
   set ping(String value);
  String get rel;
   set rel(String value);
  DOMTokenList get relList;
  String get hreflang;
   set hreflang(String value);
  String get type;
   set type(String value);
  String get text;
   set text(String value);
  String get referrerPolicy;
   set referrerPolicy(String value);
}

abstract interface class SVGAngle {
  int get unitType;
  double get value;
   set value(double value);
  double get valueInSpecifiedUnits;
   set valueInSpecifiedUnits(double value);
  String get valueAsString;
   set valueAsString(String value);
  void newValueSpecifiedUnits(int unitType, double valueInSpecifiedUnits);
  void convertToSpecifiedUnits(int unitType);
}

abstract interface class SVGAnimatedAngle {
  SVGAngle get baseVal;
  SVGAngle get animVal;
}

abstract interface class SVGAnimatedBoolean {
  bool get baseVal;
   set baseVal(bool value);
  bool get animVal;
}

abstract interface class SVGAnimatedEnumeration {
  int get baseVal;
   set baseVal(int value);
  int get animVal;
}

abstract interface class SVGAnimatedInteger {
  int get baseVal;
   set baseVal(int value);
  int get animVal;
}

abstract interface class SVGAnimatedLength {
  SVGLength get baseVal;
  SVGLength get animVal;
}

abstract interface class SVGAnimatedLengthList {
  SVGLengthList get baseVal;
  SVGLengthList get animVal;
}

abstract interface class SVGAnimatedNumber {
  double get baseVal;
   set baseVal(double value);
  double get animVal;
}

abstract interface class SVGAnimatedNumberList {
  SVGNumberList get baseVal;
  SVGNumberList get animVal;
}

abstract interface class SVGAnimatedPoints {
  SVGPointList get points;
  SVGPointList get animatedPoints;
}

abstract interface class SVGAnimatedPreserveAspectRatio {
  SVGPreserveAspectRatio get baseVal;
  SVGPreserveAspectRatio get animVal;
}

abstract interface class SVGAnimatedRect {
  DOMRect get baseVal;
  DOMRectReadOnly get animVal;
}

abstract interface class SVGAnimatedString {
  String get baseVal;
   set baseVal(String value);
  String get animVal;
}

abstract interface class SVGAnimatedTransformList {
  SVGTransformList get baseVal;
  SVGTransformList get animVal;
}

abstract interface class SVGBoundingBoxOptions {
  bool? get fill;
  set fill(bool? value);
  bool? get stroke;
  set stroke(bool? value);
  bool? get markers;
  set markers(bool? value);
  bool? get clipped;
  set clipped(bool? value);
}

final class SVGBoundingBoxOptionsValue implements SVGBoundingBoxOptions {
  @override
  bool? fill;
  @override
  bool? stroke;
  @override
  bool? markers;
  @override
  bool? clipped;

  SVGBoundingBoxOptionsValue({
    this.fill,
    this.stroke,
    this.markers,
    this.clipped,
  });
}

abstract interface class SVGCircleElement {
  SVGAnimatedLength get cx;
  SVGAnimatedLength get cy;
  SVGAnimatedLength get r;
}

abstract interface class SVGDefsElement {
}

abstract interface class SVGDescElement {
}

abstract interface class SVGElement {
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
  SVGElement? get correspondingElement;
  SVGUseElement? get correspondingUseElement;
  DOMStringMap get dataset;
  String get nonce;
   set nonce(String value);
  bool get autofocus;
   set autofocus(bool value);
  int get tabIndex;
   set tabIndex(int value);
  void focus([FocusOptions? options]);
  void blur();
  StylePropertyMap get attributeStyleMap;
  CSSStyleDeclaration get style;
  SVGAnimatedString get className;
  SVGSVGElement? get ownerSVGElement;
  SVGElement? get viewportElement;
}

abstract interface class SVGElementInstance {
  SVGElement? get correspondingElement;
  SVGUseElement? get correspondingUseElement;
}

abstract interface class SVGEllipseElement {
  SVGAnimatedLength get cx;
  SVGAnimatedLength get cy;
  SVGAnimatedLength get rx;
  SVGAnimatedLength get ry;
}

abstract interface class SVGFitToViewBox {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
}

abstract interface class SVGForeignObjectElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
}

abstract interface class SVGGElement {
}

abstract interface class SVGGeometryElement {
  SVGAnimatedNumber get pathLength;
  bool isPointInFill([DOMPointInit? point]);
  bool isPointInStroke([DOMPointInit? point]);
  double getTotalLength();
  DOMPoint getPointAtLength(double distance);
}

abstract interface class SVGGradientElement {
  SVGAnimatedString get href;
  SVGAnimatedEnumeration get gradientUnits;
  SVGAnimatedTransformList get gradientTransform;
  SVGAnimatedEnumeration get spreadMethod;
}

abstract interface class SVGGraphicsElement {
  SVGStringList get requiredExtensions;
  SVGStringList get systemLanguage;
  SVGAnimatedTransformList get transform;
  DOMRect getBBox([SVGBoundingBoxOptions? options]);
  DOMMatrix? getCTM();
  DOMMatrix? getScreenCTM();
}

abstract interface class SVGImageElement {
  SVGAnimatedString get href;
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
  String? get crossOrigin;
   set crossOrigin(String? value);
}

abstract interface class SVGLength {
  int get unitType;
  double get value;
   set value(double value);
  double get valueInSpecifiedUnits;
   set valueInSpecifiedUnits(double value);
  String get valueAsString;
   set valueAsString(String value);
  void newValueSpecifiedUnits(int unitType, double valueInSpecifiedUnits);
  void convertToSpecifiedUnits(int unitType);
}

abstract interface class SVGLengthList {
  int get length;
  int get numberOfItems;
  void clear();
  SVGLength initialize(SVGLength newItem);
  SVGLength getItem(int index);
  SVGLength insertItemBefore(SVGLength newItem, int index);
  SVGLength replaceItem(SVGLength newItem, int index);
  SVGLength removeItem(int index);
  SVGLength appendItem(SVGLength newItem);
}

abstract interface class SVGLineElement {
  SVGAnimatedLength get x1;
  SVGAnimatedLength get y1;
  SVGAnimatedLength get x2;
  SVGAnimatedLength get y2;
}

abstract interface class SVGLinearGradientElement {
  SVGAnimatedLength get x1;
  SVGAnimatedLength get y1;
  SVGAnimatedLength get x2;
  SVGAnimatedLength get y2;
}

abstract interface class SVGMarkerElement {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
  SVGAnimatedLength get refX;
  SVGAnimatedLength get refY;
  SVGAnimatedEnumeration get markerUnits;
  SVGAnimatedLength get markerWidth;
  SVGAnimatedLength get markerHeight;
  SVGAnimatedEnumeration get orientType;
  SVGAnimatedAngle get orientAngle;
  String get orient;
   set orient(String value);
  void setOrientToAuto();
  void setOrientToAngle(SVGAngle angle);
}

abstract interface class SVGMetadataElement {
}

abstract interface class SVGNumber {
  double get value;
   set value(double value);
}

abstract interface class SVGNumberList {
  int get length;
  int get numberOfItems;
  void clear();
  SVGNumber initialize(SVGNumber newItem);
  SVGNumber getItem(int index);
  SVGNumber insertItemBefore(SVGNumber newItem, int index);
  SVGNumber replaceItem(SVGNumber newItem, int index);
  SVGNumber removeItem(int index);
  SVGNumber appendItem(SVGNumber newItem);
}

abstract interface class SVGPathElement {
}

abstract interface class SVGPatternElement {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
  SVGAnimatedString get href;
  SVGAnimatedEnumeration get patternUnits;
  SVGAnimatedEnumeration get patternContentUnits;
  SVGAnimatedTransformList get patternTransform;
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
}

abstract interface class SVGPointList {
  int get length;
  int get numberOfItems;
  void clear();
  DOMPoint initialize(DOMPoint newItem);
  DOMPoint getItem(int index);
  DOMPoint insertItemBefore(DOMPoint newItem, int index);
  DOMPoint replaceItem(DOMPoint newItem, int index);
  DOMPoint removeItem(int index);
  DOMPoint appendItem(DOMPoint newItem);
}

abstract interface class SVGPolygonElement {
  SVGPointList get points;
  SVGPointList get animatedPoints;
}

abstract interface class SVGPolylineElement {
  SVGPointList get points;
  SVGPointList get animatedPoints;
}

abstract interface class SVGPreserveAspectRatio {
  int get align;
   set align(int value);
  int get meetOrSlice;
   set meetOrSlice(int value);
}

abstract interface class SVGRadialGradientElement {
  SVGAnimatedLength get cx;
  SVGAnimatedLength get cy;
  SVGAnimatedLength get r;
  SVGAnimatedLength get fx;
  SVGAnimatedLength get fy;
  SVGAnimatedLength get fr;
}

abstract interface class SVGRectElement {
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  SVGAnimatedLength get rx;
  SVGAnimatedLength get ry;
}

abstract interface class SVGSVGElement {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
  EventHandler get ongamepadconnected;
   set ongamepadconnected(EventHandler value);
  EventHandler get ongamepaddisconnected;
   set ongamepaddisconnected(EventHandler value);
  EventHandler get onafterprint;
   set onafterprint(EventHandler value);
  EventHandler get onbeforeprint;
   set onbeforeprint(EventHandler value);
  OnBeforeUnloadEventHandler get onbeforeunload;
   set onbeforeunload(OnBeforeUnloadEventHandler value);
  EventHandler get onhashchange;
   set onhashchange(EventHandler value);
  EventHandler get onlanguagechange;
   set onlanguagechange(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
  EventHandler get onoffline;
   set onoffline(EventHandler value);
  EventHandler get ononline;
   set ononline(EventHandler value);
  EventHandler get onpagehide;
   set onpagehide(EventHandler value);
  EventHandler get onpagereveal;
   set onpagereveal(EventHandler value);
  EventHandler get onpageshow;
   set onpageshow(EventHandler value);
  EventHandler get onpageswap;
   set onpageswap(EventHandler value);
  EventHandler get onpopstate;
   set onpopstate(EventHandler value);
  EventHandler get onrejectionhandled;
   set onrejectionhandled(EventHandler value);
  EventHandler get onstorage;
   set onstorage(EventHandler value);
  EventHandler get onunhandledrejection;
   set onunhandledrejection(EventHandler value);
  EventHandler get onunload;
   set onunload(EventHandler value);
  EventHandler get onportalactivate;
   set onportalactivate(EventHandler value);
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
  double get currentScale;
   set currentScale(double value);
  DOMPointReadOnly get currentTranslate;
  NodeList getIntersectionList(DOMRectReadOnly rect, SVGElement? referenceElement);
  NodeList getEnclosureList(DOMRectReadOnly rect, SVGElement? referenceElement);
  bool checkIntersection(SVGElement element, DOMRectReadOnly rect);
  bool checkEnclosure(SVGElement element, DOMRectReadOnly rect);
  void deselectAll();
  SVGNumber createSVGNumber();
  SVGLength createSVGLength();
  SVGAngle createSVGAngle();
  DOMPoint createSVGPoint();
  DOMMatrix createSVGMatrix();
  DOMRect createSVGRect();
  SVGTransform createSVGTransform();
  SVGTransform createSVGTransformFromMatrix([DOMMatrix2DInit? matrix]);
  Element getElementById(String elementId);
  int suspendRedraw(int maxWaitMilliseconds);
  void unsuspendRedraw(int suspendHandleID);
  void unsuspendRedrawAll();
  void forceRedraw();
  void pauseAnimations();
  void unpauseAnimations();
  bool animationsPaused();
  double getCurrentTime();
  void setCurrentTime(double seconds);
}

abstract interface class SVGScriptElement {
  SVGAnimatedString get href;
  String get type;
   set type(String value);
  String? get crossOrigin;
   set crossOrigin(String? value);
}

abstract interface class SVGStopElement {
  SVGAnimatedNumber get offset;
}

abstract interface class SVGStringList {
  int get numberOfItems;
  void clear();
  String initialize(String newItem);
  String getItem(int index);
  String insertItemBefore(String newItem, int index);
  String replaceItem(String newItem, int index);
  String removeItem(int index);
  String appendItem(String newItem);
}

abstract interface class SVGStyleElement {
  CSSStyleSheet? get sheet;
  String get type;
   set type(String value);
  String get media;
   set media(String value);
  String get title;
   set title(String value);
}

abstract interface class SVGSwitchElement {
}

abstract interface class SVGSymbolElement {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
}

abstract interface class SVGTSpanElement {
}

abstract interface class SVGTests {
  SVGStringList get requiredExtensions;
  SVGStringList get systemLanguage;
}

abstract interface class SVGTextContentElement {
  SVGAnimatedLength get textLength;
  SVGAnimatedEnumeration get lengthAdjust;
  int getNumberOfChars();
  double getComputedTextLength();
  double getSubStringLength(int charnum, int nchars);
  DOMPoint getStartPositionOfChar(int charnum);
  DOMPoint getEndPositionOfChar(int charnum);
  DOMRect getExtentOfChar(int charnum);
  double getRotationOfChar(int charnum);
  int getCharNumAtPosition([DOMPointInit? point]);
  void selectSubString(int charnum, int nchars);
}

abstract interface class SVGTextElement {
}

abstract interface class SVGTextPathElement {
  SVGAnimatedString get href;
  SVGAnimatedLength get startOffset;
  SVGAnimatedEnumeration get method;
  SVGAnimatedEnumeration get spacing;
}

abstract interface class SVGTextPositioningElement {
  SVGAnimatedLengthList get x;
  SVGAnimatedLengthList get y;
  SVGAnimatedLengthList get dx;
  SVGAnimatedLengthList get dy;
  SVGAnimatedNumberList get rotate;
}

abstract interface class SVGTitleElement {
}

abstract interface class SVGTransform {
  int get type;
  DOMMatrix get matrix;
  double get angle;
  void setMatrix([DOMMatrix2DInit? matrix]);
  void setTranslate(double tx, double ty);
  void setScale(double sx, double sy);
  void setRotate(double angle, double cx, double cy);
  void setSkewX(double angle);
  void setSkewY(double angle);
}

abstract interface class SVGTransformList {
  int get numberOfItems;
  void clear();
  SVGTransform initialize(SVGTransform newItem);
  SVGTransform getItem(int index);
  SVGTransform insertItemBefore(SVGTransform newItem, int index);
  SVGTransform replaceItem(SVGTransform newItem, int index);
  SVGTransform removeItem(int index);
  SVGTransform appendItem(SVGTransform newItem);
  SVGTransform createSVGTransformFromMatrix([DOMMatrix2DInit? matrix]);
  SVGTransform? consolidate();
}

abstract interface class SVGURIReference {
  SVGAnimatedString get href;
}

abstract interface class SVGUnitTypes {
}

abstract interface class SVGUseElement {
  SVGAnimatedString get href;
  SVGAnimatedLength get x;
  SVGAnimatedLength get y;
  SVGAnimatedLength get width;
  SVGAnimatedLength get height;
}

abstract interface class SVGViewElement {
  SVGAnimatedRect get viewBox;
  SVGAnimatedPreserveAspectRatio get preserveAspectRatio;
}

