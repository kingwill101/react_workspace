// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: dom
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'css_nav.dart';
import 'trusted_types.dart';
import 'svg.dart';
import 'hr_time.dart';
import 'cssom.dart';
import 'web_animations_2.dart';
import 'geometry.dart';
import 'cssom_view.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class AbortController {
  factory AbortController() =>
      WebRuntime.current.createWebObject<AbortController>(
        'AbortController',
        [],
      );
  AbortSignal get signal;
  void abort([Object? reason]);
}

abstract interface class AbortSignal {
  bool get aborted;
  Object get reason;
  void throwIfAborted();
  EventHandler get onabort;
   set onabort(EventHandler value);
}

abstract interface class AbstractRange {
  Node get startContainer;
  int get startOffset;
  Node get endContainer;
  int get endOffset;
  bool get collapsed;
}

abstract interface class AddEventListenerOptions {
  bool get passive;
  set passive(bool value);
  bool get once;
  set once(bool value);
  AbortSignal get signal;
  set signal(AbortSignal value);
}

abstract interface class Attr {
  String? get namespaceURI;
  String? get prefix;
  String get localName;
  String get name;
  String get value;
   set value(String value);
  Element? get ownerElement;
  bool get specified;
}

abstract interface class CDATASection {
}

abstract interface class CharacterData {
  Element? get previousElementSibling;
  Element? get nextElementSibling;
  void before([List<Object>? nodes]);
  void after([List<Object>? nodes]);
  void replaceWith([List<Object>? nodes]);
  void remove();
  String get data;
   set data(String value);
  int get length;
  String substringData(int offset, int count);
  void appendData(String data);
  void insertData(int offset, String data);
  void deleteData(int offset, int count);
  void replaceData(int offset, int count, String data);
}

abstract interface class ChildNode {
  void before([List<Object>? nodes]);
  void after([List<Object>? nodes]);
  void replaceWith([List<Object>? nodes]);
  void remove();
}

abstract interface class Comment {
  factory Comment([String? data]) =>
      WebRuntime.current.createWebObject<Comment>(
        'Comment',
        [data],
      );
}

abstract interface class CustomEvent {
  factory CustomEvent(String type, [CustomEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<CustomEvent>(
        'CustomEvent',
        [type, eventInitDict],
      );
  Object get detail;
  void initCustomEvent(String type, [bool? bubbles, bool? cancelable, Object? detail]);
}

abstract interface class CustomEventInit {
  Object get detail;
  set detail(Object value);
}

abstract interface class DOMImplementation {
  DocumentType createDocumentType(String qualifiedName, String publicId, String systemId);
  XMLDocument createDocument(String? namespace, String qualifiedName, [DocumentType? doctype]);
  Document createHTMLDocument([String? title]);
  bool hasFeature();
}

abstract interface class DOMTokenList {
  int get length;
  String? item(int index);
  bool contains(String token);
  void add([List<String>? tokens]);
  void remove([List<String>? tokens]);
  bool toggle(String token, [bool? force]);
  bool replace(String token, String newToken);
  bool supports(String token);
  String get value;
   set value(String value);
}

abstract interface class DocumentFragment {
  factory DocumentFragment() =>
      WebRuntime.current.createWebObject<DocumentFragment>(
        'DocumentFragment',
        [],
      );
  Element? getElementById(String elementId);
  HTMLCollection get children;
  Element? get firstElementChild;
  Element? get lastElementChild;
  int get childElementCount;
  void prepend([List<Object>? nodes]);
  void append([List<Object>? nodes]);
  void replaceChildren([List<Object>? nodes]);
  Element? querySelector(String selectors);
  NodeList querySelectorAll(String selectors);
}

abstract interface class DocumentType {
  void before([List<Object>? nodes]);
  void after([List<Object>? nodes]);
  void replaceWith([List<Object>? nodes]);
  void remove();
  String get name;
  String get publicId;
  String get systemId;
}

abstract interface class ElementCreationOptions {
  String get is_;
  set is_(String value);
}

abstract interface class Event {
  factory Event(String type, [EventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<Event>(
        'Event',
        [type, eventInitDict],
      );
  String get type;
  EventTarget? get target;
  EventTarget? get srcElement;
  EventTarget? get currentTarget;
  List<EventTarget> composedPath();
  int get eventPhase;
  void stopPropagation();
  bool get cancelBubble;
   set cancelBubble(bool value);
  void stopImmediatePropagation();
  bool get bubbles;
  bool get cancelable;
  bool get returnValue;
   set returnValue(bool value);
  void preventDefault();
  bool get defaultPrevented;
  bool get composed;
  bool get isTrusted;
  DOMHighResTimeStamp get timeStamp;
  void initEvent(String type, [bool? bubbles, bool? cancelable]);
}

abstract interface class EventInit {
  bool get bubbles;
  set bubbles(bool value);
  bool get cancelable;
  set cancelable(bool value);
  bool get composed;
  set composed(bool value);
}

abstract interface class EventListener {
  void handleEvent(Event event);
}

abstract interface class EventListenerOptions {
  bool get capture;
  set capture(bool value);
}

abstract interface class EventTarget {
  factory EventTarget() =>
      WebRuntime.current.createWebObject<EventTarget>(
        'EventTarget',
        [],
      );
  void addEventListener(String type, EventListener? callback, [Object? options]);
  void removeEventListener(String type, EventListener? callback, [Object? options]);
  bool dispatchEvent(Event event);
}

abstract interface class GetRootNodeOptions {
  bool get composed;
  set composed(bool value);
}

abstract interface class HTMLCollection {
  int get length;
  Element? item(int index);
  Element? namedItem(String name);
}

typedef MutationCallback = void Function(List<MutationRecord> mutations, MutationObserver observer,);

abstract interface class MutationObserver {
  factory MutationObserver(MutationCallback callback) =>
      WebRuntime.current.createWebObject<MutationObserver>(
        'MutationObserver',
        [callback],
      );
  void observe(Node target, [MutationObserverInit? options]);
  void disconnect();
  List<MutationRecord> takeRecords();
}

abstract interface class MutationObserverInit {
  bool get childList;
  set childList(bool value);
  bool get attributes;
  set attributes(bool value);
  bool get characterData;
  set characterData(bool value);
  bool get subtree;
  set subtree(bool value);
  bool get attributeOldValue;
  set attributeOldValue(bool value);
  bool get characterDataOldValue;
  set characterDataOldValue(bool value);
  List<String> get attributeFilter;
  set attributeFilter(List<String> value);
}

abstract interface class MutationRecord {
  String get type;
  Node get target;
  NodeList get addedNodes;
  NodeList get removedNodes;
  Node? get previousSibling;
  Node? get nextSibling;
  String? get attributeName;
  String? get attributeNamespace;
  String? get oldValue;
}

abstract interface class NamedNodeMap {
  int get length;
  Attr? item(int index);
  Attr? getNamedItem(String qualifiedName);
  Attr? getNamedItemNS(String? namespace, String localName);
  Attr? setNamedItem(Attr attr);
  Attr? setNamedItemNS(Attr attr);
  Attr removeNamedItem(String qualifiedName);
  Attr removeNamedItemNS(String? namespace, String localName);
}

abstract interface class Node {
  int get nodeType;
  String get nodeName;
  String get baseURI;
  bool get isConnected;
  Document? get ownerDocument;
  Node getRootNode([GetRootNodeOptions? options]);
  Node? get parentNode;
  Element? get parentElement;
  bool hasChildNodes();
  NodeList get childNodes;
  Node? get firstChild;
  Node? get lastChild;
  Node? get previousSibling;
  Node? get nextSibling;
  String? get nodeValue;
   set nodeValue(String? value);
  String? get textContent;
   set textContent(String? value);
  void normalize();
  Node cloneNode([bool? deep]);
  bool isEqualNode(Node? otherNode);
  bool isSameNode(Node? otherNode);
  int compareDocumentPosition(Node other);
  bool contains(Node? other);
  String? lookupPrefix(String? namespace);
  String? lookupNamespaceURI(String? prefix);
  bool isDefaultNamespace(String? namespace);
  Node insertBefore(Node node, Node? child);
  Node appendChild(Node node);
  Node replaceChild(Node node, Node child);
  Node removeChild(Node child);
}

abstract interface class NodeFilter {
   static const int FILTER_ACCEPT =
      1;
   static const int FILTER_REJECT =
      2;
   static const int FILTER_SKIP =
      3;
   static const int SHOW_ALL =
      0xFFFFFFFF;
   static const int SHOW_ELEMENT =
      0x1;
   static const int SHOW_ATTRIBUTE =
      0x2;
   static const int SHOW_TEXT =
      0x4;
   static const int SHOW_CDATA_SECTION =
      0x8;
   static const int SHOW_ENTITY_REFERENCE =
      0x10;
   static const int SHOW_ENTITY =
      0x20;
   static const int SHOW_PROCESSING_INSTRUCTION =
      0x40;
   static const int SHOW_COMMENT =
      0x80;
   static const int SHOW_DOCUMENT =
      0x100;
   static const int SHOW_DOCUMENT_TYPE =
      0x200;
   static const int SHOW_DOCUMENT_FRAGMENT =
      0x400;
   static const int SHOW_NOTATION =
      0x800;
  int acceptNode(Node node);
}

abstract interface class NodeIterator {
  Node get root;
  Node get referenceNode;
  bool get pointerBeforeReferenceNode;
  int get whatToShow;
  NodeFilter? get filter;
  Node? nextNode();
  Node? previousNode();
  void detach();
}

abstract interface class NodeList {
  Node? item(int index);
  int get length;
}

abstract interface class NonDocumentTypeChildNode {
  Element? get previousElementSibling;
  Element? get nextElementSibling;
}

abstract interface class NonElementParentNode {
  Element? getElementById(String elementId);
}

abstract interface class ParentNode {
  HTMLCollection get children;
  Element? get firstElementChild;
  Element? get lastElementChild;
  int get childElementCount;
  void prepend([List<Object>? nodes]);
  void append([List<Object>? nodes]);
  void replaceChildren([List<Object>? nodes]);
  Element? querySelector(String selectors);
  NodeList querySelectorAll(String selectors);
}

abstract interface class ProcessingInstruction {
  CSSStyleSheet? get sheet;
  String get target;
}

abstract interface class ShadowRoot {
  StyleSheetList get styleSheets;
  List<CSSStyleSheet> get adoptedStyleSheets;
   set adoptedStyleSheets(List<CSSStyleSheet> value);
  Element? get fullscreenElement;
  Element? get activeElement;
  Element? get pictureInPictureElement;
  Element? get pointerLockElement;
  List<Animation> getAnimations();
  ShadowRootMode get mode;
  bool get delegatesFocus;
  SlotAssignmentMode get slotAssignment;
  bool get clonable;
  bool get serializable;
  Element get host;
  void setHTMLUnsafe(Object html);
  String getHTML([GetHTMLOptions? options]);
  Object get innerHTML;
   set innerHTML(Object value);
}

abstract interface class ShadowRootInit {
  ShadowRootMode get mode;
  set mode(ShadowRootMode value);
  bool get delegatesFocus;
  set delegatesFocus(bool value);
  SlotAssignmentMode get slotAssignment;
  set slotAssignment(SlotAssignmentMode value);
  bool get clonable;
  set clonable(bool value);
  bool get serializable;
  set serializable(bool value);
}

typedef ShadowRootMode = String;

typedef SlotAssignmentMode = String;

abstract interface class Slottable {
  HTMLSlotElement? get assignedSlot;
}

abstract interface class StaticRange {
  factory StaticRange(StaticRangeInit init) =>
      WebRuntime.current.createWebObject<StaticRange>(
        'StaticRange',
        [init],
      );
}

abstract interface class StaticRangeInit {
  Node get startContainer;
  set startContainer(Node value);
  int get startOffset;
  set startOffset(int value);
  Node get endContainer;
  set endContainer(Node value);
  int get endOffset;
  set endOffset(int value);
}

abstract interface class Text {
  factory Text([String? data]) =>
      WebRuntime.current.createWebObject<Text>(
        'Text',
        [data],
      );
  List<DOMQuad> getBoxQuads([BoxQuadOptions? options]);
  DOMQuad convertQuadFromNode(DOMQuadInit quad, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMQuad convertRectFromNode(DOMRectReadOnly rect, GeometryNode from, [ConvertCoordinateOptions? options]);
  DOMPoint convertPointFromNode(DOMPointInit point, GeometryNode from, [ConvertCoordinateOptions? options]);
  HTMLSlotElement? get assignedSlot;
  Text splitText(int offset);
  String get wholeText;
}

abstract interface class TreeWalker {
  Node get root;
  int get whatToShow;
  NodeFilter? get filter;
  Node get currentNode;
   set currentNode(Node value);
  Node? parentNode();
  Node? firstChild();
  Node? lastChild();
  Node? previousSibling();
  Node? nextSibling();
  Node? previousNode();
  Node? nextNode();
}

abstract interface class XMLDocument {
}

abstract interface class XPathEvaluator {
  factory XPathEvaluator() =>
      WebRuntime.current.createWebObject<XPathEvaluator>(
        'XPathEvaluator',
        [],
      );
  XPathExpression createExpression(String expression, [XPathNSResolver? resolver]);
  Node createNSResolver(Node nodeResolver);
  XPathResult evaluate(String expression, Node contextNode, [XPathNSResolver? resolver, int? type, XPathResult? result]);
}

abstract interface class XPathEvaluatorBase {
  XPathExpression createExpression(String expression, [XPathNSResolver? resolver]);
  Node createNSResolver(Node nodeResolver);
  XPathResult evaluate(String expression, Node contextNode, [XPathNSResolver? resolver, int? type, XPathResult? result]);
}

abstract interface class XPathExpression {
  XPathResult evaluate(Node contextNode, [int? type, XPathResult? result]);
}

abstract interface class XPathNSResolver {
  String? lookupNamespaceURI(String? prefix);
}

abstract interface class XPathResult {
  int get resultType;
  double get numberValue;
  String get stringValue;
  bool get booleanValue;
  Node? get singleNodeValue;
  bool get invalidIteratorState;
  int get snapshotLength;
  Node? iterateNext();
  Node? snapshotItem(int index);
}

abstract interface class XSLTProcessor {
  factory XSLTProcessor() =>
      WebRuntime.current.createWebObject<XSLTProcessor>(
        'XSLTProcessor',
        [],
      );
  void importStylesheet(Node style);
  DocumentFragment transformToFragment(Node source, Document output);
  Document transformToDocument(Node source);
  void setParameter(String namespaceURI, String localName, Object value);
  Object getParameter(String namespaceURI, String localName);
  void removeParameter(String namespaceURI, String localName);
  void clearParameters();
  void reset();
}

