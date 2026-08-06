// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: html
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'media_source.dart';
import 'fileapi.dart';
import 'webcodecs.dart';
import 'geometry.dart';
import 'css_nav.dart';
import 'dom.dart';
import 'svg.dart';
import 'trusted_types.dart';
import 'entries_api.dart';
import 'pointerlock.dart';
import 'xhr.dart';
import 'cssom_view.dart';
import 'hr_time.dart';
import 'mediacapture_streams.dart';
import 'cssom.dart';
import 'media_playback_quality.dart';
import 'picture_in_picture.dart';
import 'video_rvfc.dart';
import 'service_workers.dart';
import 'webgl1.dart';
import 'webgl2.dart';
import 'css_view_transitions_2.dart';
import 'webidl.dart';
import 'css_font_loading.dart';
import 'indexeddb.dart';
import 'webcryptoapi.dart';
import 'fetch.dart';
import 'attribution_reporting_api.dart';
import 'event_timing.dart';
import 'scheduling_apis.dart';
import 'netinfo.dart';
import 'fs.dart';
import 'web_locks.dart';
import 'media_capabilities.dart';
import 'permissions_request.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class AbstractWorker {
  EventHandler get onerror;
   set onerror(EventHandler value);
}

abstract interface class AnimationFrameProvider {
  int requestAnimationFrame(FrameRequestCallback callback);
  void cancelAnimationFrame(int handle);
}

abstract interface class AssignedNodesOptions {
  bool? get flatten;
  set flatten(bool? value);
}

final class AssignedNodesOptionsValue implements AssignedNodesOptions {
  @override
  bool? flatten;

  AssignedNodesOptionsValue({
    this.flatten,
  });
}

abstract interface class AudioTrack {
  String get id;
  String get kind;
  String get label;
  String get language;
  bool get enabled;
   set enabled(bool value);
  SourceBuffer? get sourceBuffer;
}

abstract interface class AudioTrackList {
  int get length;
  AudioTrack? getTrackById(String id);
  EventHandler get onchange;
   set onchange(EventHandler value);
  EventHandler get onaddtrack;
   set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
   set onremovetrack(EventHandler value);
}

abstract interface class BarProp {
  bool get visible;
}

abstract interface class BeforeUnloadEvent {
  String get returnValue;
   set returnValue(String value);
}

typedef BlobCallback = void Function(Blob? blob,);

abstract interface class BroadcastChannel {
  factory BroadcastChannel(String name) =>
      WebRuntime.current.createWebObject<BroadcastChannel>(
        'BroadcastChannel',
        [name],
      );
  String get name;
  void postMessage(Object message);
  void close();
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

typedef CanPlayTypeResult = String;

abstract interface class CanvasCompositing {
  double get globalAlpha;
   set globalAlpha(double value);
  String get globalCompositeOperation;
   set globalCompositeOperation(String value);
}

typedef CanvasDirection = String;

abstract interface class CanvasDrawImage {
  void drawImage(CanvasImageSource image, double sx, double sy, double sw, double sh, double dx, double dy, double dw, double dh);
}

abstract interface class CanvasDrawPath {
  void beginPath();
  void fill(Path2D path, [CanvasFillRule? fillRule]);
  void stroke(Path2D path);
  void clip(Path2D path, [CanvasFillRule? fillRule]);
  bool isPointInPath(Path2D path, double x, double y, [CanvasFillRule? fillRule]);
  bool isPointInStroke(Path2D path, double x, double y);
}

typedef CanvasFillRule = String;

abstract interface class CanvasFillStrokeStyles {
  Object get strokeStyle;
   set strokeStyle(Object value);
  Object get fillStyle;
   set fillStyle(Object value);
  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1);
  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1);
  CanvasGradient createConicGradient(double startAngle, double x, double y);
  CanvasPattern? createPattern(CanvasImageSource image, String repetition);
}

abstract interface class CanvasFilters {
  String get filter;
   set filter(String value);
}

typedef CanvasFontKerning = String;

typedef CanvasFontStretch = String;

typedef CanvasFontVariantCaps = String;

abstract interface class CanvasGradient {
  void addColorStop(double offset, String color);
}

abstract interface class CanvasImageData {
  ImageData createImageData(int sw, int sh, [ImageDataSettings? settings]);
  ImageData getImageData(int sx, int sy, int sw, int sh, [ImageDataSettings? settings]);
  void putImageData(ImageData imagedata, int dx, int dy, int dirtyX, int dirtyY, int dirtyWidth, int dirtyHeight);
}

abstract interface class CanvasImageSmoothing {
  bool get imageSmoothingEnabled;
   set imageSmoothingEnabled(bool value);
  ImageSmoothingQuality get imageSmoothingQuality;
   set imageSmoothingQuality(ImageSmoothingQuality value);
}

typedef CanvasImageSource = Object;

typedef CanvasLineCap = String;

typedef CanvasLineJoin = String;

abstract interface class CanvasPath {
  void closePath();
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  void rect(double x, double y, double w, double h);
  void roundRect(double x, double y, double w, double h, [Object? radii]);
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool? counterclockwise]);
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool? counterclockwise]);
}

abstract interface class CanvasPathDrawingStyles {
  double get lineWidth;
   set lineWidth(double value);
  CanvasLineCap get lineCap;
   set lineCap(CanvasLineCap value);
  CanvasLineJoin get lineJoin;
   set lineJoin(CanvasLineJoin value);
  double get miterLimit;
   set miterLimit(double value);
  void setLineDash(List<double> segments);
  List<double> getLineDash();
  double get lineDashOffset;
   set lineDashOffset(double value);
}

abstract interface class CanvasPattern {
  void setTransform([DOMMatrix2DInit? transform]);
}

abstract interface class CanvasRect {
  void clearRect(double x, double y, double w, double h);
  void fillRect(double x, double y, double w, double h);
  void strokeRect(double x, double y, double w, double h);
}

abstract interface class CanvasRenderingContext2D {
  void save();
  void restore();
  void reset();
  bool isContextLost();
  void scale(double x, double y);
  void rotate(double angle);
  void translate(double x, double y);
  void transform(double a, double b, double c, double d, double e, double f);
  DOMMatrix getTransform();
  void setTransform(double a, double b, double c, double d, double e, double f);
  void resetTransform();
  double get globalAlpha;
   set globalAlpha(double value);
  String get globalCompositeOperation;
   set globalCompositeOperation(String value);
  bool get imageSmoothingEnabled;
   set imageSmoothingEnabled(bool value);
  ImageSmoothingQuality get imageSmoothingQuality;
   set imageSmoothingQuality(ImageSmoothingQuality value);
  Object get strokeStyle;
   set strokeStyle(Object value);
  Object get fillStyle;
   set fillStyle(Object value);
  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1);
  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1);
  CanvasGradient createConicGradient(double startAngle, double x, double y);
  CanvasPattern? createPattern(CanvasImageSource image, String repetition);
  double get shadowOffsetX;
   set shadowOffsetX(double value);
  double get shadowOffsetY;
   set shadowOffsetY(double value);
  double get shadowBlur;
   set shadowBlur(double value);
  String get shadowColor;
   set shadowColor(String value);
  String get filter;
   set filter(String value);
  void clearRect(double x, double y, double w, double h);
  void fillRect(double x, double y, double w, double h);
  void strokeRect(double x, double y, double w, double h);
  void beginPath();
  void fill(Path2D path, [CanvasFillRule? fillRule]);
  void stroke(Path2D path);
  void clip(Path2D path, [CanvasFillRule? fillRule]);
  bool isPointInPath(Path2D path, double x, double y, [CanvasFillRule? fillRule]);
  bool isPointInStroke(Path2D path, double x, double y);
  void drawFocusIfNeeded(Path2D path, Element element);
  void scrollPathIntoView(Path2D path);
  void fillText(String text, double x, double y, [double? maxWidth]);
  void strokeText(String text, double x, double y, [double? maxWidth]);
  TextMetrics measureText(String text);
  void drawImage(CanvasImageSource image, double sx, double sy, double sw, double sh, double dx, double dy, double dw, double dh);
  ImageData createImageData(int sw, int sh, [ImageDataSettings? settings]);
  ImageData getImageData(int sx, int sy, int sw, int sh, [ImageDataSettings? settings]);
  void putImageData(ImageData imagedata, int dx, int dy, int dirtyX, int dirtyY, int dirtyWidth, int dirtyHeight);
  double get lineWidth;
   set lineWidth(double value);
  CanvasLineCap get lineCap;
   set lineCap(CanvasLineCap value);
  CanvasLineJoin get lineJoin;
   set lineJoin(CanvasLineJoin value);
  double get miterLimit;
   set miterLimit(double value);
  void setLineDash(List<double> segments);
  List<double> getLineDash();
  double get lineDashOffset;
   set lineDashOffset(double value);
  String get font;
   set font(String value);
  CanvasTextAlign get textAlign;
   set textAlign(CanvasTextAlign value);
  CanvasTextBaseline get textBaseline;
   set textBaseline(CanvasTextBaseline value);
  CanvasDirection get direction;
   set direction(CanvasDirection value);
  String get letterSpacing;
   set letterSpacing(String value);
  CanvasFontKerning get fontKerning;
   set fontKerning(CanvasFontKerning value);
  CanvasFontStretch get fontStretch;
   set fontStretch(CanvasFontStretch value);
  CanvasFontVariantCaps get fontVariantCaps;
   set fontVariantCaps(CanvasFontVariantCaps value);
  CanvasTextRendering get textRendering;
   set textRendering(CanvasTextRendering value);
  String get wordSpacing;
   set wordSpacing(String value);
  void closePath();
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  void rect(double x, double y, double w, double h);
  void roundRect(double x, double y, double w, double h, [Object? radii]);
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool? counterclockwise]);
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool? counterclockwise]);
  HTMLCanvasElement get canvas;
  CanvasRenderingContext2DSettings getContextAttributes();
}

abstract interface class CanvasRenderingContext2DSettings {
  bool? get alpha;
  set alpha(bool? value);
  bool? get desynchronized;
  set desynchronized(bool? value);
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
  bool? get willReadFrequently;
  set willReadFrequently(bool? value);
}

final class CanvasRenderingContext2DSettingsValue implements CanvasRenderingContext2DSettings {
  @override
  bool? alpha;
  @override
  bool? desynchronized;
  @override
  PredefinedColorSpace? colorSpace;
  @override
  bool? willReadFrequently;

  CanvasRenderingContext2DSettingsValue({
    this.alpha,
    this.desynchronized,
    this.colorSpace,
    this.willReadFrequently,
  });
}

abstract interface class CanvasShadowStyles {
  double get shadowOffsetX;
   set shadowOffsetX(double value);
  double get shadowOffsetY;
   set shadowOffsetY(double value);
  double get shadowBlur;
   set shadowBlur(double value);
  String get shadowColor;
   set shadowColor(String value);
}

abstract interface class CanvasState {
  void save();
  void restore();
  void reset();
  bool isContextLost();
}

abstract interface class CanvasText {
  void fillText(String text, double x, double y, [double? maxWidth]);
  void strokeText(String text, double x, double y, [double? maxWidth]);
  TextMetrics measureText(String text);
}

typedef CanvasTextAlign = String;

typedef CanvasTextBaseline = String;

abstract interface class CanvasTextDrawingStyles {
  String get font;
   set font(String value);
  CanvasTextAlign get textAlign;
   set textAlign(CanvasTextAlign value);
  CanvasTextBaseline get textBaseline;
   set textBaseline(CanvasTextBaseline value);
  CanvasDirection get direction;
   set direction(CanvasDirection value);
  String get letterSpacing;
   set letterSpacing(String value);
  CanvasFontKerning get fontKerning;
   set fontKerning(CanvasFontKerning value);
  CanvasFontStretch get fontStretch;
   set fontStretch(CanvasFontStretch value);
  CanvasFontVariantCaps get fontVariantCaps;
   set fontVariantCaps(CanvasFontVariantCaps value);
  CanvasTextRendering get textRendering;
   set textRendering(CanvasTextRendering value);
  String get wordSpacing;
   set wordSpacing(String value);
}

typedef CanvasTextRendering = String;

abstract interface class CanvasTransform {
  void scale(double x, double y);
  void rotate(double angle);
  void translate(double x, double y);
  void transform(double a, double b, double c, double d, double e, double f);
  DOMMatrix getTransform();
  void setTransform(double a, double b, double c, double d, double e, double f);
  void resetTransform();
}

abstract interface class CanvasUserInterface {
  void drawFocusIfNeeded(Path2D path, Element element);
  void scrollPathIntoView(Path2D path);
}

abstract interface class CloseWatcherOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
}

final class CloseWatcherOptionsValue implements CloseWatcherOptions {
  @override
  AbortSignal? signal;

  CloseWatcherOptionsValue({
    this.signal,
  });
}

typedef ColorSpaceConversion = String;

typedef CustomElementConstructor = HTMLElement Function();

abstract interface class CustomElementRegistry {
  void define(String name, CustomElementConstructor constructor, [ElementDefinitionOptions? options]);
  CustomElementConstructor get_(String name);
  String? getName(CustomElementConstructor constructor);
  Future<CustomElementConstructor> whenDefined(String name);
  void upgrade(Node root);
}

abstract interface class CustomStateSet {
}

abstract interface class DOMParser {
  factory DOMParser() =>
      WebRuntime.current.createWebObject<DOMParser>(
        'DOMParser',
        [],
      );
  Document parseFromString(Object string, DOMParserSupportedType type);
}

typedef DOMParserSupportedType = String;

abstract interface class DOMStringList {
  int get length;
  String? item(int index);
  bool contains(String string);
}

abstract interface class DOMStringMap {
}

abstract interface class DataTransfer {
  factory DataTransfer() =>
      WebRuntime.current.createWebObject<DataTransfer>(
        'DataTransfer',
        [],
      );
  String get dropEffect;
   set dropEffect(String value);
  String get effectAllowed;
   set effectAllowed(String value);
  DataTransferItemList get items;
  void setDragImage(Element image, int x, int y);
  List<String> get types;
  String getData(String format);
  void setData(String format, String data);
  void clearData([String? format]);
  FileList get files;
}

abstract interface class DataTransferItemList {
  int get length;
  DataTransferItem? add(String data, String type);
  void remove(int index);
  void clear();
}

abstract interface class DedicatedWorkerGlobalScope {
  int requestAnimationFrame(FrameRequestCallback callback);
  void cancelAnimationFrame(int handle);
  String get name;
  void postMessage(Object message, List<Object> transfer);
  void close();
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
  EventHandler get onrtctransform;
   set onrtctransform(EventHandler value);
}

typedef DocumentReadyState = String;

typedef DocumentVisibilityState = String;

abstract interface class DragEvent {
  factory DragEvent(String type, [DragEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<DragEvent>(
        'DragEvent',
        [type, eventInitDict],
      );
  DataTransfer? get dataTransfer;
}

abstract interface class DragEventInit {
  DataTransfer? get dataTransfer;
  set dataTransfer(DataTransfer? value);
}

final class DragEventInitValue implements DragEventInit {
  @override
  DataTransfer? dataTransfer;

  DragEventInitValue({
    this.dataTransfer,
  });
}

abstract interface class ElementContentEditable {
  String get contentEditable;
   set contentEditable(String value);
  String get enterKeyHint;
   set enterKeyHint(String value);
  bool get isContentEditable;
  String get inputMode;
   set inputMode(String value);
  String get virtualKeyboardPolicy;
   set virtualKeyboardPolicy(String value);
}

abstract interface class ElementDefinitionOptions {
  String? get extends_;
  set extends_(String? value);
}

final class ElementDefinitionOptionsValue implements ElementDefinitionOptions {
  @override
  String? extends_;

  ElementDefinitionOptionsValue({
    this.extends_,
  });
}

abstract interface class ElementInternals {
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
  ShadowRoot? get shadowRoot;
  void setFormValue(Object value, [Object? state]);
  HTMLFormElement? get form;
  void setValidity([ValidityStateFlags? flags, String? message, HTMLElement? anchor]);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  NodeList get labels;
  CustomStateSet get states;
}

abstract interface class ErrorEvent {
  factory ErrorEvent(String type, [ErrorEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ErrorEvent>(
        'ErrorEvent',
        [type, eventInitDict],
      );
  String get message;
  String get filename;
  int get lineno;
  int get colno;
  Object get error;
}

abstract interface class ErrorEventInit {
  String? get message;
  set message(String? value);
  String? get filename;
  set filename(String? value);
  int? get lineno;
  set lineno(int? value);
  int? get colno;
  set colno(int? value);
  Object? get error;
  set error(Object? value);
}

final class ErrorEventInitValue implements ErrorEventInit {
  @override
  String? message;
  @override
  String? filename;
  @override
  int? lineno;
  @override
  int? colno;
  @override
  Object? error;

  ErrorEventInitValue({
    this.message,
    this.filename,
    this.lineno,
    this.colno,
    this.error,
  });
}

typedef EventHandler = EventHandlerNonNull?;

typedef EventHandlerNonNull = Object Function(Event event,);

abstract interface class EventSource {
  factory EventSource(String url, [EventSourceInit? eventSourceInitDict]) =>
      WebRuntime.current.createWebObject<EventSource>(
        'EventSource',
        [url, eventSourceInitDict],
      );
  String get url;
  bool get withCredentials;
  int get readyState;
  EventHandler get onopen;
   set onopen(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  void close();
}

abstract interface class EventSourceInit {
  bool? get withCredentials;
  set withCredentials(bool? value);
}

final class EventSourceInitValue implements EventSourceInit {
  @override
  bool? withCredentials;

  EventSourceInitValue({
    this.withCredentials,
  });
}

abstract interface class External {
  void addSearchProvider();
  void isSearchProviderInstalled();
}

abstract interface class FocusOptions {
  bool? get preventScroll;
  set preventScroll(bool? value);
  bool? get focusVisible;
  set focusVisible(bool? value);
}

final class FocusOptionsValue implements FocusOptions {
  @override
  bool? preventScroll;
  @override
  bool? focusVisible;

  FocusOptionsValue({
    this.preventScroll,
    this.focusVisible,
  });
}

abstract interface class FormDataEvent {
  factory FormDataEvent(String type, FormDataEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<FormDataEvent>(
        'FormDataEvent',
        [type, eventInitDict],
      );
  FormData get formData;
}

abstract interface class FormDataEventInit {
  FormData get formData;
  set formData(FormData value);
}

final class FormDataEventInitValue implements FormDataEventInit {
  @override
  FormData formData;

  FormDataEventInitValue({
    required this.formData,
  });
}

typedef FrameRequestCallback = void Function(DOMHighResTimeStamp time,);

typedef FunctionStringCallback = void Function(String data,);

abstract interface class GetHTMLOptions {
  bool? get serializableShadowRoots;
  set serializableShadowRoots(bool? value);
  List<ShadowRoot>? get shadowRoots;
  set shadowRoots(List<ShadowRoot>? value);
}

final class GetHTMLOptionsValue implements GetHTMLOptions {
  @override
  bool? serializableShadowRoots;
  @override
  List<ShadowRoot>? shadowRoots;

  GetHTMLOptionsValue({
    this.serializableShadowRoots,
    this.shadowRoots,
  });
}

abstract interface class HTMLAllCollection {
  int get length;
  Object namedItem(String name);
  Object item([String? nameOrIndex]);
}

abstract interface class HTMLAnchorElement {
  factory HTMLAnchorElement() =>
      WebRuntime.current.createWebObject<HTMLAnchorElement>(
        'HTMLAnchorElement',
        [],
      );
  String get attributionSrc;
   set attributionSrc(String value);
  String get href;
   set href(String value);
  String get origin;
  String get protocol;
   set protocol(String value);
  String get username;
   set username(String value);
  String get password;
   set password(String value);
  String get host;
   set host(String value);
  String get hostname;
   set hostname(String value);
  String get port;
   set port(String value);
  String get pathname;
   set pathname(String value);
  String get search;
   set search(String value);
  String get hash;
   set hash(String value);
  String get target;
   set target(String value);
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
  String get coords;
   set coords(String value);
  String get charset;
   set charset(String value);
  String get name;
   set name(String value);
  String get rev;
   set rev(String value);
  String get shape;
   set shape(String value);
}

abstract interface class HTMLAreaElement {
  factory HTMLAreaElement() =>
      WebRuntime.current.createWebObject<HTMLAreaElement>(
        'HTMLAreaElement',
        [],
      );
  String get href;
   set href(String value);
  String get origin;
  String get protocol;
   set protocol(String value);
  String get username;
   set username(String value);
  String get password;
   set password(String value);
  String get host;
   set host(String value);
  String get hostname;
   set hostname(String value);
  String get port;
   set port(String value);
  String get pathname;
   set pathname(String value);
  String get search;
   set search(String value);
  String get hash;
   set hash(String value);
  String get alt;
   set alt(String value);
  String get coords;
   set coords(String value);
  String get shape;
   set shape(String value);
  String get target;
   set target(String value);
  String get download;
   set download(String value);
  String get ping;
   set ping(String value);
  String get rel;
   set rel(String value);
  DOMTokenList get relList;
  String get referrerPolicy;
   set referrerPolicy(String value);
  bool get noHref;
   set noHref(bool value);
}

abstract interface class HTMLAudioElement {
  factory HTMLAudioElement() =>
      WebRuntime.current.createWebObject<HTMLAudioElement>(
        'HTMLAudioElement',
        [],
      );
}

abstract interface class HTMLBRElement {
  factory HTMLBRElement() =>
      WebRuntime.current.createWebObject<HTMLBRElement>(
        'HTMLBRElement',
        [],
      );
  String get clear;
   set clear(String value);
}

abstract interface class HTMLBaseElement {
  factory HTMLBaseElement() =>
      WebRuntime.current.createWebObject<HTMLBaseElement>(
        'HTMLBaseElement',
        [],
      );
  String get href;
   set href(String value);
  String get target;
   set target(String value);
}

abstract interface class HTMLButtonElement {
  factory HTMLButtonElement() =>
      WebRuntime.current.createWebObject<HTMLButtonElement>(
        'HTMLButtonElement',
        [],
      );
  Element? get popoverTargetElement;
   set popoverTargetElement(Element? value);
  String get popoverTargetAction;
   set popoverTargetAction(String value);
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  String get formAction;
   set formAction(String value);
  String get formEnctype;
   set formEnctype(String value);
  String get formMethod;
   set formMethod(String value);
  bool get formNoValidate;
   set formNoValidate(bool value);
  String get formTarget;
   set formTarget(String value);
  String get name;
   set name(String value);
  String get type;
   set type(String value);
  String get value;
   set value(String value);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  NodeList get labels;
}

abstract interface class HTMLCanvasElement {
  factory HTMLCanvasElement() =>
      WebRuntime.current.createWebObject<HTMLCanvasElement>(
        'HTMLCanvasElement',
        [],
      );
  int get width;
   set width(int value);
  int get height;
   set height(int value);
  RenderingContext? getContext(String contextId, [Object? options]);
  String toDataURL([String? type, Object? quality]);
  void toBlob(BlobCallback callback, [String? type, Object? quality]);
  OffscreenCanvas transferControlToOffscreen();
  MediaStream captureStream([double? frameRequestRate]);
}

abstract interface class HTMLDListElement {
  factory HTMLDListElement() =>
      WebRuntime.current.createWebObject<HTMLDListElement>(
        'HTMLDListElement',
        [],
      );
  bool get compact;
   set compact(bool value);
}

abstract interface class HTMLDataElement {
  factory HTMLDataElement() =>
      WebRuntime.current.createWebObject<HTMLDataElement>(
        'HTMLDataElement',
        [],
      );
  String get value;
   set value(String value);
}

abstract interface class HTMLDataListElement {
  factory HTMLDataListElement() =>
      WebRuntime.current.createWebObject<HTMLDataListElement>(
        'HTMLDataListElement',
        [],
      );
  HTMLCollection get options;
}

abstract interface class HTMLDetailsElement {
  factory HTMLDetailsElement() =>
      WebRuntime.current.createWebObject<HTMLDetailsElement>(
        'HTMLDetailsElement',
        [],
      );
  String get name;
   set name(String value);
  bool get open;
   set open(bool value);
}

abstract interface class HTMLDialogElement {
  factory HTMLDialogElement() =>
      WebRuntime.current.createWebObject<HTMLDialogElement>(
        'HTMLDialogElement',
        [],
      );
  bool get open;
   set open(bool value);
  String get returnValue;
   set returnValue(String value);
  void show_();
  void showModal();
  void close([String? returnValue]);
}

abstract interface class HTMLDirectoryElement {
  factory HTMLDirectoryElement() =>
      WebRuntime.current.createWebObject<HTMLDirectoryElement>(
        'HTMLDirectoryElement',
        [],
      );
  bool get compact;
   set compact(bool value);
}

abstract interface class HTMLDivElement {
  factory HTMLDivElement() =>
      WebRuntime.current.createWebObject<HTMLDivElement>(
        'HTMLDivElement',
        [],
      );
  String get align;
   set align(String value);
}

abstract interface class HTMLEmbedElement {
  factory HTMLEmbedElement() =>
      WebRuntime.current.createWebObject<HTMLEmbedElement>(
        'HTMLEmbedElement',
        [],
      );
  String get src;
   set src(String value);
  String get type;
   set type(String value);
  String get width;
   set width(String value);
  String get height;
   set height(String value);
  Document? getSVGDocument();
  String get align;
   set align(String value);
  String get name;
   set name(String value);
}

abstract interface class HTMLFieldSetElement {
  factory HTMLFieldSetElement() =>
      WebRuntime.current.createWebObject<HTMLFieldSetElement>(
        'HTMLFieldSetElement',
        [],
      );
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  String get name;
   set name(String value);
  String get type;
  HTMLCollection get elements;
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
}

abstract interface class HTMLFontElement {
  factory HTMLFontElement() =>
      WebRuntime.current.createWebObject<HTMLFontElement>(
        'HTMLFontElement',
        [],
      );
  String get color;
   set color(String value);
  String get face;
   set face(String value);
  String get size;
   set size(String value);
}

abstract interface class HTMLFormControlsCollection {
  Object namedItem(String name);
}

abstract interface class HTMLFormElement {
  factory HTMLFormElement() =>
      WebRuntime.current.createWebObject<HTMLFormElement>(
        'HTMLFormElement',
        [],
      );
  String get acceptCharset;
   set acceptCharset(String value);
  String get action;
   set action(String value);
  String get autocomplete;
   set autocomplete(String value);
  String get enctype;
   set enctype(String value);
  String get encoding;
   set encoding(String value);
  String get method;
   set method(String value);
  String get name;
   set name(String value);
  bool get noValidate;
   set noValidate(bool value);
  String get target;
   set target(String value);
  String get rel;
   set rel(String value);
  DOMTokenList get relList;
  HTMLFormControlsCollection get elements;
  int get length;
  void submit();
  void requestSubmit([HTMLElement? submitter]);
  void reset();
  bool checkValidity();
  bool reportValidity();
}

abstract interface class HTMLFrameElement {
  factory HTMLFrameElement() =>
      WebRuntime.current.createWebObject<HTMLFrameElement>(
        'HTMLFrameElement',
        [],
      );
  String get name;
   set name(String value);
  String get scrolling;
   set scrolling(String value);
  String get src;
   set src(String value);
  String get frameBorder;
   set frameBorder(String value);
  String get longDesc;
   set longDesc(String value);
  bool get noResize;
   set noResize(bool value);
  Document? get contentDocument;
  Object get contentWindow;
  String get marginHeight;
   set marginHeight(String value);
  String get marginWidth;
   set marginWidth(String value);
}

abstract interface class HTMLFrameSetElement {
  factory HTMLFrameSetElement() =>
      WebRuntime.current.createWebObject<HTMLFrameSetElement>(
        'HTMLFrameSetElement',
        [],
      );
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
  String get cols;
   set cols(String value);
  String get rows;
   set rows(String value);
}

abstract interface class HTMLHRElement {
  factory HTMLHRElement() =>
      WebRuntime.current.createWebObject<HTMLHRElement>(
        'HTMLHRElement',
        [],
      );
  String get align;
   set align(String value);
  String get color;
   set color(String value);
  bool get noShade;
   set noShade(bool value);
  String get size;
   set size(String value);
  String get width;
   set width(String value);
}

abstract interface class HTMLHeadElement {
  factory HTMLHeadElement() =>
      WebRuntime.current.createWebObject<HTMLHeadElement>(
        'HTMLHeadElement',
        [],
      );
}

abstract interface class HTMLHeadingElement {
  factory HTMLHeadingElement() =>
      WebRuntime.current.createWebObject<HTMLHeadingElement>(
        'HTMLHeadingElement',
        [],
      );
  String get align;
   set align(String value);
}

abstract interface class HTMLHtmlElement {
  factory HTMLHtmlElement() =>
      WebRuntime.current.createWebObject<HTMLHtmlElement>(
        'HTMLHtmlElement',
        [],
      );
  String get version;
   set version(String value);
}

abstract interface class HTMLHyperlinkElementUtils {
  String get href;
   set href(String value);
  String get origin;
  String get protocol;
   set protocol(String value);
  String get username;
   set username(String value);
  String get password;
   set password(String value);
  String get host;
   set host(String value);
  String get hostname;
   set hostname(String value);
  String get port;
   set port(String value);
  String get pathname;
   set pathname(String value);
  String get search;
   set search(String value);
  String get hash;
   set hash(String value);
}

abstract interface class HTMLLIElement {
  factory HTMLLIElement() =>
      WebRuntime.current.createWebObject<HTMLLIElement>(
        'HTMLLIElement',
        [],
      );
  int get value;
   set value(int value);
  String get type;
   set type(String value);
}

abstract interface class HTMLLabelElement {
  factory HTMLLabelElement() =>
      WebRuntime.current.createWebObject<HTMLLabelElement>(
        'HTMLLabelElement',
        [],
      );
  HTMLFormElement? get form;
  String get htmlFor;
   set htmlFor(String value);
  HTMLElement? get control;
}

abstract interface class HTMLLegendElement {
  factory HTMLLegendElement() =>
      WebRuntime.current.createWebObject<HTMLLegendElement>(
        'HTMLLegendElement',
        [],
      );
  HTMLFormElement? get form;
  String get align;
   set align(String value);
}

abstract interface class HTMLLinkElement {
  factory HTMLLinkElement() =>
      WebRuntime.current.createWebObject<HTMLLinkElement>(
        'HTMLLinkElement',
        [],
      );
  CSSStyleSheet? get sheet;
  String get href;
   set href(String value);
  String? get crossOrigin;
   set crossOrigin(String? value);
  String get rel;
   set rel(String value);
  String get as_;
   set as_(String value);
  DOMTokenList get relList;
  String get media;
   set media(String value);
  String get integrity;
   set integrity(String value);
  String get hreflang;
   set hreflang(String value);
  String get type;
   set type(String value);
  DOMTokenList get sizes;
  String get imageSrcset;
   set imageSrcset(String value);
  String get imageSizes;
   set imageSizes(String value);
  String get referrerPolicy;
   set referrerPolicy(String value);
  bool get disabled;
   set disabled(bool value);
  String get fetchPriority;
   set fetchPriority(String value);
  String get charset;
   set charset(String value);
  String get rev;
   set rev(String value);
  String get target;
   set target(String value);
}

abstract interface class HTMLMapElement {
  factory HTMLMapElement() =>
      WebRuntime.current.createWebObject<HTMLMapElement>(
        'HTMLMapElement',
        [],
      );
  String get name;
   set name(String value);
  HTMLCollection get areas;
}

abstract interface class HTMLMarqueeElement {
  factory HTMLMarqueeElement() =>
      WebRuntime.current.createWebObject<HTMLMarqueeElement>(
        'HTMLMarqueeElement',
        [],
      );
  String get behavior;
   set behavior(String value);
  String get bgColor;
   set bgColor(String value);
  String get direction;
   set direction(String value);
  String get height;
   set height(String value);
  int get hspace;
   set hspace(int value);
  int get loop;
   set loop(int value);
  int get scrollAmount;
   set scrollAmount(int value);
  int get scrollDelay;
   set scrollDelay(int value);
  bool get trueSpeed;
   set trueSpeed(bool value);
  int get vspace;
   set vspace(int value);
  String get width;
   set width(String value);
  void start();
  void stop();
}

abstract interface class HTMLMenuElement {
  factory HTMLMenuElement() =>
      WebRuntime.current.createWebObject<HTMLMenuElement>(
        'HTMLMenuElement',
        [],
      );
  bool get compact;
   set compact(bool value);
}

abstract interface class HTMLMetaElement {
  factory HTMLMetaElement() =>
      WebRuntime.current.createWebObject<HTMLMetaElement>(
        'HTMLMetaElement',
        [],
      );
  String get name;
   set name(String value);
  String get httpEquiv;
   set httpEquiv(String value);
  String get content;
   set content(String value);
  String get media;
   set media(String value);
  String get scheme;
   set scheme(String value);
}

abstract interface class HTMLMeterElement {
  factory HTMLMeterElement() =>
      WebRuntime.current.createWebObject<HTMLMeterElement>(
        'HTMLMeterElement',
        [],
      );
  double get value;
   set value(double value);
  double get min;
   set min(double value);
  double get max;
   set max(double value);
  double get low;
   set low(double value);
  double get high;
   set high(double value);
  double get optimum;
   set optimum(double value);
  NodeList get labels;
}

abstract interface class HTMLModElement {
  factory HTMLModElement() =>
      WebRuntime.current.createWebObject<HTMLModElement>(
        'HTMLModElement',
        [],
      );
  String get cite;
   set cite(String value);
  String get dateTime;
   set dateTime(String value);
}

abstract interface class HTMLOListElement {
  factory HTMLOListElement() =>
      WebRuntime.current.createWebObject<HTMLOListElement>(
        'HTMLOListElement',
        [],
      );
  bool get reversed;
   set reversed(bool value);
  int get start;
   set start(int value);
  String get type;
   set type(String value);
  bool get compact;
   set compact(bool value);
}

abstract interface class HTMLObjectElement {
  factory HTMLObjectElement() =>
      WebRuntime.current.createWebObject<HTMLObjectElement>(
        'HTMLObjectElement',
        [],
      );
  String get data;
   set data(String value);
  String get type;
   set type(String value);
  String get name;
   set name(String value);
  HTMLFormElement? get form;
  String get width;
   set width(String value);
  String get height;
   set height(String value);
  Document? get contentDocument;
  Object get contentWindow;
  Document? getSVGDocument();
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  String get align;
   set align(String value);
  String get archive;
   set archive(String value);
  String get code;
   set code(String value);
  bool get declare;
   set declare(bool value);
  int get hspace;
   set hspace(int value);
  String get standby;
   set standby(String value);
  int get vspace;
   set vspace(int value);
  String get codeBase;
   set codeBase(String value);
  String get codeType;
   set codeType(String value);
  String get useMap;
   set useMap(String value);
  String get border;
   set border(String value);
}

abstract interface class HTMLOptGroupElement {
  factory HTMLOptGroupElement() =>
      WebRuntime.current.createWebObject<HTMLOptGroupElement>(
        'HTMLOptGroupElement',
        [],
      );
  bool get disabled;
   set disabled(bool value);
  String get label;
   set label(String value);
}

abstract interface class HTMLOptionElement {
  factory HTMLOptionElement() =>
      WebRuntime.current.createWebObject<HTMLOptionElement>(
        'HTMLOptionElement',
        [],
      );
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  String get label;
   set label(String value);
  bool get defaultSelected;
   set defaultSelected(bool value);
  bool get selected;
   set selected(bool value);
  String get value;
   set value(String value);
  String get text;
   set text(String value);
  int get index;
}

abstract interface class HTMLOptionsCollection {
  int get length;
   set length(int value);
  void add(Object element, [Object? before]);
  void remove(int index);
  int get selectedIndex;
   set selectedIndex(int value);
}

abstract interface class HTMLOrSVGElement {
  DOMStringMap get dataset;
  String get nonce;
   set nonce(String value);
  bool get autofocus;
   set autofocus(bool value);
  int get tabIndex;
   set tabIndex(int value);
  void focus([FocusOptions? options]);
  void blur();
}

typedef HTMLOrSVGImageElement = Object;

typedef HTMLOrSVGScriptElement = Object;

abstract interface class HTMLOutputElement {
  factory HTMLOutputElement() =>
      WebRuntime.current.createWebObject<HTMLOutputElement>(
        'HTMLOutputElement',
        [],
      );
  DOMTokenList get htmlFor;
  HTMLFormElement? get form;
  String get name;
   set name(String value);
  String get type;
  String get defaultValue;
   set defaultValue(String value);
  String get value;
   set value(String value);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  NodeList get labels;
}

abstract interface class HTMLParagraphElement {
  factory HTMLParagraphElement() =>
      WebRuntime.current.createWebObject<HTMLParagraphElement>(
        'HTMLParagraphElement',
        [],
      );
  String get align;
   set align(String value);
}

abstract interface class HTMLParamElement {
  factory HTMLParamElement() =>
      WebRuntime.current.createWebObject<HTMLParamElement>(
        'HTMLParamElement',
        [],
      );
  String get name;
   set name(String value);
  String get value;
   set value(String value);
  String get type;
   set type(String value);
  String get valueType;
   set valueType(String value);
}

abstract interface class HTMLPictureElement {
  factory HTMLPictureElement() =>
      WebRuntime.current.createWebObject<HTMLPictureElement>(
        'HTMLPictureElement',
        [],
      );
}

abstract interface class HTMLPreElement {
  factory HTMLPreElement() =>
      WebRuntime.current.createWebObject<HTMLPreElement>(
        'HTMLPreElement',
        [],
      );
  int get width;
   set width(int value);
}

abstract interface class HTMLProgressElement {
  factory HTMLProgressElement() =>
      WebRuntime.current.createWebObject<HTMLProgressElement>(
        'HTMLProgressElement',
        [],
      );
  double get value;
   set value(double value);
  double get max;
   set max(double value);
  double get position;
  NodeList get labels;
}

abstract interface class HTMLQuoteElement {
  factory HTMLQuoteElement() =>
      WebRuntime.current.createWebObject<HTMLQuoteElement>(
        'HTMLQuoteElement',
        [],
      );
  String get cite;
   set cite(String value);
}

abstract interface class HTMLScriptElement {
  factory HTMLScriptElement() =>
      WebRuntime.current.createWebObject<HTMLScriptElement>(
        'HTMLScriptElement',
        [],
      );
  String get attributionSrc;
   set attributionSrc(String value);
  String get src;
   set src(String value);
  String get type;
   set type(String value);
  bool get noModule;
   set noModule(bool value);
  bool get async_;
   set async_(bool value);
  bool get defer;
   set defer(bool value);
  String? get crossOrigin;
   set crossOrigin(String? value);
  String get text;
   set text(String value);
  String get integrity;
   set integrity(String value);
  String get referrerPolicy;
   set referrerPolicy(String value);
  String get fetchPriority;
   set fetchPriority(String value);
  String get charset;
   set charset(String value);
  String get event;
   set event(String value);
  String get htmlFor;
   set htmlFor(String value);
}

abstract interface class HTMLSelectElement {
  factory HTMLSelectElement() =>
      WebRuntime.current.createWebObject<HTMLSelectElement>(
        'HTMLSelectElement',
        [],
      );
  String get autocomplete;
   set autocomplete(String value);
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  bool get multiple;
   set multiple(bool value);
  String get name;
   set name(String value);
  bool get required_;
   set required_(bool value);
  int get size;
   set size(int value);
  String get type;
  HTMLOptionsCollection get options;
  int get length;
   set length(int value);
  HTMLOptionElement? item(int index);
  HTMLOptionElement? namedItem(String name);
  void add(Object element, [Object? before]);
  void remove(int index);
  HTMLCollection get selectedOptions;
  int get selectedIndex;
   set selectedIndex(int value);
  String get value;
   set value(String value);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  void showPicker();
  NodeList get labels;
}

abstract interface class HTMLSlotElement {
  factory HTMLSlotElement() =>
      WebRuntime.current.createWebObject<HTMLSlotElement>(
        'HTMLSlotElement',
        [],
      );
  String get name;
   set name(String value);
  List<Node> assignedNodes([AssignedNodesOptions? options]);
  List<Element> assignedElements([AssignedNodesOptions? options]);
  void assign([List<Object>? nodes]);
}

abstract interface class HTMLSourceElement {
  factory HTMLSourceElement() =>
      WebRuntime.current.createWebObject<HTMLSourceElement>(
        'HTMLSourceElement',
        [],
      );
  String get src;
   set src(String value);
  String get type;
   set type(String value);
  String get srcset;
   set srcset(String value);
  String get sizes;
   set sizes(String value);
  String get media;
   set media(String value);
  int get width;
   set width(int value);
  int get height;
   set height(int value);
}

abstract interface class HTMLSpanElement {
  factory HTMLSpanElement() =>
      WebRuntime.current.createWebObject<HTMLSpanElement>(
        'HTMLSpanElement',
        [],
      );
}

abstract interface class HTMLStyleElement {
  factory HTMLStyleElement() =>
      WebRuntime.current.createWebObject<HTMLStyleElement>(
        'HTMLStyleElement',
        [],
      );
  CSSStyleSheet? get sheet;
  bool get disabled;
   set disabled(bool value);
  String get media;
   set media(String value);
  String get type;
   set type(String value);
}

abstract interface class HTMLTableCaptionElement {
  factory HTMLTableCaptionElement() =>
      WebRuntime.current.createWebObject<HTMLTableCaptionElement>(
        'HTMLTableCaptionElement',
        [],
      );
  String get align;
   set align(String value);
}

abstract interface class HTMLTableCellElement {
  factory HTMLTableCellElement() =>
      WebRuntime.current.createWebObject<HTMLTableCellElement>(
        'HTMLTableCellElement',
        [],
      );
  int get colSpan;
   set colSpan(int value);
  int get rowSpan;
   set rowSpan(int value);
  String get headers;
   set headers(String value);
  int get cellIndex;
  String get scope;
   set scope(String value);
  String get abbr;
   set abbr(String value);
  String get align;
   set align(String value);
  String get axis;
   set axis(String value);
  String get height;
   set height(String value);
  String get width;
   set width(String value);
  String get ch;
   set ch(String value);
  String get chOff;
   set chOff(String value);
  bool get noWrap;
   set noWrap(bool value);
  String get vAlign;
   set vAlign(String value);
  String get bgColor;
   set bgColor(String value);
}

abstract interface class HTMLTableColElement {
  factory HTMLTableColElement() =>
      WebRuntime.current.createWebObject<HTMLTableColElement>(
        'HTMLTableColElement',
        [],
      );
  int get span;
   set span(int value);
  String get align;
   set align(String value);
  String get ch;
   set ch(String value);
  String get chOff;
   set chOff(String value);
  String get vAlign;
   set vAlign(String value);
  String get width;
   set width(String value);
}

abstract interface class HTMLTableElement {
  factory HTMLTableElement() =>
      WebRuntime.current.createWebObject<HTMLTableElement>(
        'HTMLTableElement',
        [],
      );
  HTMLTableCaptionElement? get caption;
   set caption(HTMLTableCaptionElement? value);
  HTMLTableCaptionElement createCaption();
  void deleteCaption();
  HTMLTableSectionElement? get tHead;
   set tHead(HTMLTableSectionElement? value);
  HTMLTableSectionElement createTHead();
  void deleteTHead();
  HTMLTableSectionElement? get tFoot;
   set tFoot(HTMLTableSectionElement? value);
  HTMLTableSectionElement createTFoot();
  void deleteTFoot();
  HTMLCollection get tBodies;
  HTMLTableSectionElement createTBody();
  HTMLCollection get rows;
  HTMLTableRowElement insertRow([int? index]);
  void deleteRow(int index);
  String get align;
   set align(String value);
  String get border;
   set border(String value);
  String get frame;
   set frame(String value);
  String get rules;
   set rules(String value);
  String get summary;
   set summary(String value);
  String get width;
   set width(String value);
  String get bgColor;
   set bgColor(String value);
  String get cellPadding;
   set cellPadding(String value);
  String get cellSpacing;
   set cellSpacing(String value);
}

abstract interface class HTMLTableRowElement {
  factory HTMLTableRowElement() =>
      WebRuntime.current.createWebObject<HTMLTableRowElement>(
        'HTMLTableRowElement',
        [],
      );
  int get rowIndex;
  int get sectionRowIndex;
  HTMLCollection get cells;
  HTMLTableCellElement insertCell([int? index]);
  void deleteCell(int index);
  String get align;
   set align(String value);
  String get ch;
   set ch(String value);
  String get chOff;
   set chOff(String value);
  String get vAlign;
   set vAlign(String value);
  String get bgColor;
   set bgColor(String value);
}

abstract interface class HTMLTableSectionElement {
  factory HTMLTableSectionElement() =>
      WebRuntime.current.createWebObject<HTMLTableSectionElement>(
        'HTMLTableSectionElement',
        [],
      );
  HTMLCollection get rows;
  HTMLTableRowElement insertRow([int? index]);
  void deleteRow(int index);
  String get align;
   set align(String value);
  String get ch;
   set ch(String value);
  String get chOff;
   set chOff(String value);
  String get vAlign;
   set vAlign(String value);
}

abstract interface class HTMLTemplateElement {
  factory HTMLTemplateElement() =>
      WebRuntime.current.createWebObject<HTMLTemplateElement>(
        'HTMLTemplateElement',
        [],
      );
  DocumentFragment get content;
  String get shadowRootMode;
   set shadowRootMode(String value);
  bool get shadowRootDelegatesFocus;
   set shadowRootDelegatesFocus(bool value);
  bool get shadowRootClonable;
   set shadowRootClonable(bool value);
  bool get shadowRootSerializable;
   set shadowRootSerializable(bool value);
}

abstract interface class HTMLTextAreaElement {
  factory HTMLTextAreaElement() =>
      WebRuntime.current.createWebObject<HTMLTextAreaElement>(
        'HTMLTextAreaElement',
        [],
      );
  String get autocomplete;
   set autocomplete(String value);
  int get cols;
   set cols(int value);
  String get dirName;
   set dirName(String value);
  bool get disabled;
   set disabled(bool value);
  HTMLFormElement? get form;
  int get maxLength;
   set maxLength(int value);
  int get minLength;
   set minLength(int value);
  String get name;
   set name(String value);
  String get placeholder;
   set placeholder(String value);
  bool get readOnly;
   set readOnly(bool value);
  bool get required_;
   set required_(bool value);
  int get rows;
   set rows(int value);
  String get wrap;
   set wrap(String value);
  String get type;
  String get defaultValue;
   set defaultValue(String value);
  String get value;
   set value(String value);
  int get textLength;
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity(String error);
  NodeList get labels;
  void select();
  int get selectionStart;
   set selectionStart(int value);
  int get selectionEnd;
   set selectionEnd(int value);
  String get selectionDirection;
   set selectionDirection(String value);
  void setRangeText(String replacement, int start, int end, [SelectionMode? selectionMode]);
  void setSelectionRange(int start, int end, [String? direction]);
}

abstract interface class HTMLTimeElement {
  factory HTMLTimeElement() =>
      WebRuntime.current.createWebObject<HTMLTimeElement>(
        'HTMLTimeElement',
        [],
      );
  String get dateTime;
   set dateTime(String value);
}

abstract interface class HTMLTitleElement {
  factory HTMLTitleElement() =>
      WebRuntime.current.createWebObject<HTMLTitleElement>(
        'HTMLTitleElement',
        [],
      );
  String get text;
   set text(String value);
}

abstract interface class HTMLTrackElement {
  factory HTMLTrackElement() =>
      WebRuntime.current.createWebObject<HTMLTrackElement>(
        'HTMLTrackElement',
        [],
      );
  String get kind;
   set kind(String value);
  String get src;
   set src(String value);
  String get srclang;
   set srclang(String value);
  String get label;
   set label(String value);
  bool get default_;
   set default_(bool value);
  int get readyState;
  TextTrack get track;
}

abstract interface class HTMLUListElement {
  factory HTMLUListElement() =>
      WebRuntime.current.createWebObject<HTMLUListElement>(
        'HTMLUListElement',
        [],
      );
  bool get compact;
   set compact(bool value);
  String get type;
   set type(String value);
}

abstract interface class HTMLUnknownElement {
}

abstract interface class HTMLVideoElement {
  factory HTMLVideoElement() =>
      WebRuntime.current.createWebObject<HTMLVideoElement>(
        'HTMLVideoElement',
        [],
      );
  int get width;
   set width(int value);
  int get height;
   set height(int value);
  int get videoWidth;
  int get videoHeight;
  String get poster;
   set poster(String value);
  bool get playsInline;
   set playsInline(bool value);
  VideoPlaybackQuality getVideoPlaybackQuality();
  Future<PictureInPictureWindow> requestPictureInPicture();
  EventHandler get onenterpictureinpicture;
   set onenterpictureinpicture(EventHandler value);
  EventHandler get onleavepictureinpicture;
   set onleavepictureinpicture(EventHandler value);
  bool get disablePictureInPicture;
   set disablePictureInPicture(bool value);
  int requestVideoFrameCallback(VideoFrameRequestCallback callback);
  void cancelVideoFrameCallback(int handle);
}

abstract interface class HashChangeEvent {
  factory HashChangeEvent(String type, [HashChangeEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<HashChangeEvent>(
        'HashChangeEvent',
        [type, eventInitDict],
      );
  String get oldURL;
  String get newURL;
}

abstract interface class HashChangeEventInit {
  String? get oldURL;
  set oldURL(String? value);
  String? get newURL;
  set newURL(String? value);
}

final class HashChangeEventInitValue implements HashChangeEventInit {
  @override
  String? oldURL;
  @override
  String? newURL;

  HashChangeEventInitValue({
    this.oldURL,
    this.newURL,
  });
}

abstract interface class History {
  int get length;
  ScrollRestoration get scrollRestoration;
   set scrollRestoration(ScrollRestoration value);
  Object get state;
  void go([int? delta]);
  void back();
  void forward();
  void pushState(Object data, String unused, [String? url]);
  void replaceState(Object data, String unused, [String? url]);
}

abstract interface class ImageBitmap {
  int get width;
  int get height;
  void close();
}

abstract interface class ImageBitmapOptions {
  ImageOrientation? get imageOrientation;
  set imageOrientation(ImageOrientation? value);
  PremultiplyAlpha? get premultiplyAlpha;
  set premultiplyAlpha(PremultiplyAlpha? value);
  ColorSpaceConversion? get colorSpaceConversion;
  set colorSpaceConversion(ColorSpaceConversion? value);
  int? get resizeWidth;
  set resizeWidth(int? value);
  int? get resizeHeight;
  set resizeHeight(int? value);
  ResizeQuality? get resizeQuality;
  set resizeQuality(ResizeQuality? value);
}

final class ImageBitmapOptionsValue implements ImageBitmapOptions {
  @override
  ImageOrientation? imageOrientation;
  @override
  PremultiplyAlpha? premultiplyAlpha;
  @override
  ColorSpaceConversion? colorSpaceConversion;
  @override
  int? resizeWidth;
  @override
  int? resizeHeight;
  @override
  ResizeQuality? resizeQuality;

  ImageBitmapOptionsValue({
    this.imageOrientation,
    this.premultiplyAlpha,
    this.colorSpaceConversion,
    this.resizeWidth,
    this.resizeHeight,
    this.resizeQuality,
  });
}

abstract interface class ImageBitmapRenderingContext {
  Object get canvas;
  void transferFromImageBitmap(ImageBitmap? bitmap);
}

abstract interface class ImageBitmapRenderingContextSettings {
  bool? get alpha;
  set alpha(bool? value);
}

final class ImageBitmapRenderingContextSettingsValue implements ImageBitmapRenderingContextSettings {
  @override
  bool? alpha;

  ImageBitmapRenderingContextSettingsValue({
    this.alpha,
  });
}

typedef ImageBitmapSource = Object;

abstract interface class ImageData {
  factory ImageData(int sw, int sh, [ImageDataSettings? settings]) =>
      WebRuntime.current.createWebObject<ImageData>(
        'ImageData',
        [sw, sh, settings],
      );
  factory ImageData.named1(Object data, int sw, [int? sh, ImageDataSettings? settings]) =>
      WebRuntime.current.createWebObject<ImageData>(
        'ImageData',
        [data, sw, sh, settings],
      );
  int get width;
  int get height;
  Object get data;
  PredefinedColorSpace get colorSpace;
}

abstract interface class ImageDataSettings {
  PredefinedColorSpace? get colorSpace;
  set colorSpace(PredefinedColorSpace? value);
}

final class ImageDataSettingsValue implements ImageDataSettings {
  @override
  PredefinedColorSpace? colorSpace;

  ImageDataSettingsValue({
    this.colorSpace,
  });
}

abstract interface class ImageEncodeOptions {
  String? get type;
  set type(String? value);
  double? get quality;
  set quality(double? value);
}

final class ImageEncodeOptionsValue implements ImageEncodeOptions {
  @override
  String? type;
  @override
  double? quality;

  ImageEncodeOptionsValue({
    this.type,
    this.quality,
  });
}

typedef ImageOrientation = String;

typedef ImageSmoothingQuality = String;

abstract interface class Location {
  String get href;
   set href(String value);
  String get origin;
  String get protocol;
   set protocol(String value);
  String get host;
   set host(String value);
  String get hostname;
   set hostname(String value);
  String get port;
   set port(String value);
  String get pathname;
   set pathname(String value);
  String get search;
   set search(String value);
  String get hash;
   set hash(String value);
  void assign(String url);
  void replace(String url);
  void reload();
  DOMStringList get ancestorOrigins;
}

abstract interface class MediaError {
  int get code;
  String get message;
}

typedef MediaProvider = Object;

abstract interface class MessageChannel {
  factory MessageChannel() =>
      WebRuntime.current.createWebObject<MessageChannel>(
        'MessageChannel',
        [],
      );
  MessagePort get port1;
  MessagePort get port2;
}

abstract interface class MessageEvent {
  factory MessageEvent(String type, [MessageEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<MessageEvent>(
        'MessageEvent',
        [type, eventInitDict],
      );
  Object get data;
  String get origin;
  String get lastEventId;
  MessageEventSource? get source;
  List<MessagePort> get ports;
  void initMessageEvent(String type, [bool? bubbles, bool? cancelable, Object? data, String? origin, String? lastEventId, MessageEventSource? source, List<MessagePort>? ports]);
}

abstract interface class MessageEventInit {
  Object? get data;
  set data(Object? value);
  String? get origin;
  set origin(String? value);
  String? get lastEventId;
  set lastEventId(String? value);
  MessageEventSource? get source;
  set source(MessageEventSource? value);
  List<MessagePort>? get ports;
  set ports(List<MessagePort>? value);
}

final class MessageEventInitValue implements MessageEventInit {
  @override
  Object? data;
  @override
  String? origin;
  @override
  String? lastEventId;
  @override
  MessageEventSource? source;
  @override
  List<MessagePort>? ports;

  MessageEventInitValue({
    this.data,
    this.origin,
    this.lastEventId,
    this.source,
    this.ports,
  });
}

typedef MessageEventSource = Object;

abstract interface class MessagePort {
  void postMessage(Object message, List<Object> transfer);
  void start();
  void close();
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
  EventHandler get onclose;
   set onclose(EventHandler value);
}

abstract interface class MimeType {
  String get type;
  String get description;
  String get suffixes;
  Plugin get enabledPlugin;
}

abstract interface class MimeTypeArray {
  int get length;
  MimeType? item(int index);
  MimeType? namedItem(String name);
}

abstract interface class NavigateEventInit {
  NavigationType? get navigationType;
  set navigationType(NavigationType? value);
  Object get destination;
  set destination(Object value);
  bool? get canIntercept;
  set canIntercept(bool? value);
  bool? get userInitiated;
  set userInitiated(bool? value);
  bool? get hashChange;
  set hashChange(bool? value);
  AbortSignal get signal;
  set signal(AbortSignal value);
  FormData? get formData;
  set formData(FormData? value);
  String? get downloadRequest;
  set downloadRequest(String? value);
  Object? get info;
  set info(Object? value);
  bool? get hasUAVisualTransition;
  set hasUAVisualTransition(bool? value);
}

final class NavigateEventInitValue implements NavigateEventInit {
  @override
  NavigationType? navigationType;
  @override
  Object destination;
  @override
  bool? canIntercept;
  @override
  bool? userInitiated;
  @override
  bool? hashChange;
  @override
  AbortSignal signal;
  @override
  FormData? formData;
  @override
  String? downloadRequest;
  @override
  Object? info;
  @override
  bool? hasUAVisualTransition;

  NavigateEventInitValue({
    this.navigationType,
    required this.destination,
    this.canIntercept,
    this.userInitiated,
    this.hashChange,
    required this.signal,
    this.formData,
    this.downloadRequest,
    this.info,
    this.hasUAVisualTransition,
  });
}

abstract interface class NavigationCurrentEntryChangeEventInit {
  NavigationType? get navigationType;
  set navigationType(NavigationType? value);
  Object get from;
  set from(Object value);
}

final class NavigationCurrentEntryChangeEventInitValue implements NavigationCurrentEntryChangeEventInit {
  @override
  NavigationType? navigationType;
  @override
  Object from;

  NavigationCurrentEntryChangeEventInitValue({
    this.navigationType,
    required this.from,
  });
}

typedef NavigationFocusReset = String;

typedef NavigationHistoryBehavior = String;

typedef NavigationInterceptHandler = Future<void> Function();

abstract interface class NavigationInterceptOptions {
  NavigationInterceptHandler? get handler;
  set handler(NavigationInterceptHandler? value);
  NavigationFocusReset? get focusReset;
  set focusReset(NavigationFocusReset? value);
  NavigationScrollBehavior? get scroll;
  set scroll(NavigationScrollBehavior? value);
}

final class NavigationInterceptOptionsValue implements NavigationInterceptOptions {
  @override
  NavigationInterceptHandler? handler;
  @override
  NavigationFocusReset? focusReset;
  @override
  NavigationScrollBehavior? scroll;

  NavigationInterceptOptionsValue({
    this.handler,
    this.focusReset,
    this.scroll,
  });
}

abstract interface class NavigationNavigateOptions {
  Object? get state;
  set state(Object? value);
  NavigationHistoryBehavior? get history;
  set history(NavigationHistoryBehavior? value);
}

final class NavigationNavigateOptionsValue implements NavigationNavigateOptions {
  @override
  Object? state;
  @override
  NavigationHistoryBehavior? history;

  NavigationNavigateOptionsValue({
    this.state,
    this.history,
  });
}

abstract interface class NavigationOptions {
  Object? get info;
  set info(Object? value);
}

final class NavigationOptionsValue implements NavigationOptions {
  @override
  Object? info;

  NavigationOptionsValue({
    this.info,
  });
}

abstract interface class NavigationReloadOptions {
  Object? get state;
  set state(Object? value);
}

final class NavigationReloadOptionsValue implements NavigationReloadOptions {
  @override
  Object? state;

  NavigationReloadOptionsValue({
    this.state,
  });
}

abstract interface class NavigationResult {
  Future<Object>? get committed;
  set committed(Future<Object>? value);
  Future<Object>? get finished;
  set finished(Future<Object>? value);
}

final class NavigationResultValue implements NavigationResult {
  @override
  Future<Object>? committed;
  @override
  Future<Object>? finished;

  NavigationResultValue({
    this.committed,
    this.finished,
  });
}

typedef NavigationScrollBehavior = String;

typedef NavigationType = String;

abstract interface class NavigationUpdateCurrentEntryOptions {
  Object get state;
  set state(Object value);
}

final class NavigationUpdateCurrentEntryOptionsValue implements NavigationUpdateCurrentEntryOptions {
  @override
  Object state;

  NavigationUpdateCurrentEntryOptionsValue({
    required this.state,
  });
}

abstract interface class NavigatorConcurrentHardware {
  int get hardwareConcurrency;
}

abstract interface class NavigatorContentUtils {
  void registerProtocolHandler(String scheme, String url);
  void unregisterProtocolHandler(String scheme, String url);
}

abstract interface class NavigatorCookies {
  bool get cookieEnabled;
}

abstract interface class NavigatorID {
  String get appCodeName;
  String get appName;
  String get appVersion;
  String get platform;
  String get product;
  String get productSub;
  String get userAgent;
  String get vendor;
  String get vendorSub;
  bool taintEnabled();
  String get oscpu;
}

abstract interface class NavigatorLanguage {
  String get language;
  List<String> get languages;
}

abstract interface class NavigatorOnLine {
  bool get onLine;
}

abstract interface class NavigatorPlugins {
  PluginArray get plugins;
  MimeTypeArray get mimeTypes;
  bool javaEnabled();
  bool get pdfViewerEnabled;
}

abstract interface class OffscreenCanvas {
  factory OffscreenCanvas(int width, int height) =>
      WebRuntime.current.createWebObject<OffscreenCanvas>(
        'OffscreenCanvas',
        [width, height],
      );
  int get width;
   set width(int value);
  int get height;
   set height(int value);
  OffscreenRenderingContext? getContext(OffscreenRenderingContextId contextId, [Object? options]);
  ImageBitmap transferToImageBitmap();
  Future<Blob> convertToBlob([ImageEncodeOptions? options]);
  EventHandler get oncontextlost;
   set oncontextlost(EventHandler value);
  EventHandler get oncontextrestored;
   set oncontextrestored(EventHandler value);
}

abstract interface class OffscreenCanvasRenderingContext2D {
  void save();
  void restore();
  void reset();
  bool isContextLost();
  void scale(double x, double y);
  void rotate(double angle);
  void translate(double x, double y);
  void transform(double a, double b, double c, double d, double e, double f);
  DOMMatrix getTransform();
  void setTransform(double a, double b, double c, double d, double e, double f);
  void resetTransform();
  double get globalAlpha;
   set globalAlpha(double value);
  String get globalCompositeOperation;
   set globalCompositeOperation(String value);
  bool get imageSmoothingEnabled;
   set imageSmoothingEnabled(bool value);
  ImageSmoothingQuality get imageSmoothingQuality;
   set imageSmoothingQuality(ImageSmoothingQuality value);
  Object get strokeStyle;
   set strokeStyle(Object value);
  Object get fillStyle;
   set fillStyle(Object value);
  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1);
  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1);
  CanvasGradient createConicGradient(double startAngle, double x, double y);
  CanvasPattern? createPattern(CanvasImageSource image, String repetition);
  double get shadowOffsetX;
   set shadowOffsetX(double value);
  double get shadowOffsetY;
   set shadowOffsetY(double value);
  double get shadowBlur;
   set shadowBlur(double value);
  String get shadowColor;
   set shadowColor(String value);
  String get filter;
   set filter(String value);
  void clearRect(double x, double y, double w, double h);
  void fillRect(double x, double y, double w, double h);
  void strokeRect(double x, double y, double w, double h);
  void beginPath();
  void fill(Path2D path, [CanvasFillRule? fillRule]);
  void stroke(Path2D path);
  void clip(Path2D path, [CanvasFillRule? fillRule]);
  bool isPointInPath(Path2D path, double x, double y, [CanvasFillRule? fillRule]);
  bool isPointInStroke(Path2D path, double x, double y);
  void fillText(String text, double x, double y, [double? maxWidth]);
  void strokeText(String text, double x, double y, [double? maxWidth]);
  TextMetrics measureText(String text);
  void drawImage(CanvasImageSource image, double sx, double sy, double sw, double sh, double dx, double dy, double dw, double dh);
  ImageData createImageData(int sw, int sh, [ImageDataSettings? settings]);
  ImageData getImageData(int sx, int sy, int sw, int sh, [ImageDataSettings? settings]);
  void putImageData(ImageData imagedata, int dx, int dy, int dirtyX, int dirtyY, int dirtyWidth, int dirtyHeight);
  double get lineWidth;
   set lineWidth(double value);
  CanvasLineCap get lineCap;
   set lineCap(CanvasLineCap value);
  CanvasLineJoin get lineJoin;
   set lineJoin(CanvasLineJoin value);
  double get miterLimit;
   set miterLimit(double value);
  void setLineDash(List<double> segments);
  List<double> getLineDash();
  double get lineDashOffset;
   set lineDashOffset(double value);
  String get font;
   set font(String value);
  CanvasTextAlign get textAlign;
   set textAlign(CanvasTextAlign value);
  CanvasTextBaseline get textBaseline;
   set textBaseline(CanvasTextBaseline value);
  CanvasDirection get direction;
   set direction(CanvasDirection value);
  String get letterSpacing;
   set letterSpacing(String value);
  CanvasFontKerning get fontKerning;
   set fontKerning(CanvasFontKerning value);
  CanvasFontStretch get fontStretch;
   set fontStretch(CanvasFontStretch value);
  CanvasFontVariantCaps get fontVariantCaps;
   set fontVariantCaps(CanvasFontVariantCaps value);
  CanvasTextRendering get textRendering;
   set textRendering(CanvasTextRendering value);
  String get wordSpacing;
   set wordSpacing(String value);
  void closePath();
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  void rect(double x, double y, double w, double h);
  void roundRect(double x, double y, double w, double h, [Object? radii]);
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool? counterclockwise]);
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool? counterclockwise]);
  OffscreenCanvas get canvas;
}

typedef OffscreenRenderingContext = Object;

typedef OffscreenRenderingContextId = String;

typedef OnBeforeUnloadEventHandler = OnBeforeUnloadEventHandlerNonNull?;

typedef OnBeforeUnloadEventHandlerNonNull = String? Function(Event event,);

typedef OnErrorEventHandler = OnErrorEventHandlerNonNull?;

typedef OnErrorEventHandlerNonNull = Object Function(Object event, String source, int lineno, int colno, Object error,);

abstract interface class PageRevealEventInit {
  ViewTransition? get viewTransition;
  set viewTransition(ViewTransition? value);
}

final class PageRevealEventInitValue implements PageRevealEventInit {
  @override
  ViewTransition? viewTransition;

  PageRevealEventInitValue({
    this.viewTransition,
  });
}

abstract interface class PageSwapEventInit {
  Object? get activation;
  set activation(Object? value);
  ViewTransition? get viewTransition;
  set viewTransition(ViewTransition? value);
}

final class PageSwapEventInitValue implements PageSwapEventInit {
  @override
  Object? activation;
  @override
  ViewTransition? viewTransition;

  PageSwapEventInitValue({
    this.activation,
    this.viewTransition,
  });
}

abstract interface class PageTransitionEvent {
  factory PageTransitionEvent(String type, [PageTransitionEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PageTransitionEvent>(
        'PageTransitionEvent',
        [type, eventInitDict],
      );
  bool get persisted;
}

abstract interface class PageTransitionEventInit {
  bool? get persisted;
  set persisted(bool? value);
}

final class PageTransitionEventInitValue implements PageTransitionEventInit {
  @override
  bool? persisted;

  PageTransitionEventInitValue({
    this.persisted,
  });
}

abstract interface class Path2D {
  factory Path2D([Object? path]) =>
      WebRuntime.current.createWebObject<Path2D>(
        'Path2D',
        [path],
      );
  void closePath();
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  void rect(double x, double y, double w, double h);
  void roundRect(double x, double y, double w, double h, [Object? radii]);
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool? counterclockwise]);
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool? counterclockwise]);
  void addPath(Path2D path, [DOMMatrix2DInit? transform]);
}

abstract interface class Plugin {
  String get name;
  String get description;
  String get filename;
  int get length;
  MimeType? item(int index);
  MimeType? namedItem(String name);
}

abstract interface class PluginArray {
  void refresh();
  int get length;
  Plugin? item(int index);
  Plugin? namedItem(String name);
}

abstract interface class PopStateEvent {
  factory PopStateEvent(String type, [PopStateEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<PopStateEvent>(
        'PopStateEvent',
        [type, eventInitDict],
      );
  Object get state;
  bool get hasUAVisualTransition;
}

abstract interface class PopStateEventInit {
  Object? get state;
  set state(Object? value);
  bool? get hasUAVisualTransition;
  set hasUAVisualTransition(bool? value);
}

final class PopStateEventInitValue implements PopStateEventInit {
  @override
  Object? state;
  @override
  bool? hasUAVisualTransition;

  PopStateEventInitValue({
    this.state,
    this.hasUAVisualTransition,
  });
}

abstract interface class PopoverInvokerElement {
  Element? get popoverTargetElement;
   set popoverTargetElement(Element? value);
  String get popoverTargetAction;
   set popoverTargetAction(String value);
}

typedef PredefinedColorSpace = String;

typedef PremultiplyAlpha = String;

abstract interface class PromiseRejectionEvent {
  factory PromiseRejectionEvent(String type, PromiseRejectionEventInit eventInitDict) =>
      WebRuntime.current.createWebObject<PromiseRejectionEvent>(
        'PromiseRejectionEvent',
        [type, eventInitDict],
      );
  Object get promise;
  Object get reason;
}

abstract interface class PromiseRejectionEventInit {
  Object get promise;
  set promise(Object value);
  Object? get reason;
  set reason(Object? value);
}

final class PromiseRejectionEventInitValue implements PromiseRejectionEventInit {
  @override
  Object promise;
  @override
  Object? reason;

  PromiseRejectionEventInitValue({
    required this.promise,
    this.reason,
  });
}

abstract interface class RadioNodeList {
  String get value;
   set value(String value);
}

typedef RenderingContext = Object;

typedef ResizeQuality = String;

typedef ScrollRestoration = String;

typedef SelectionMode = String;

abstract interface class SharedWorker {
  factory SharedWorker(Object scriptURL, [Object? options]) =>
      WebRuntime.current.createWebObject<SharedWorker>(
        'SharedWorker',
        [scriptURL, options],
      );
  EventHandler get onerror;
   set onerror(EventHandler value);
  MessagePort get port;
}

abstract interface class SharedWorkerGlobalScope {
  String get name;
  void close();
  EventHandler get onconnect;
   set onconnect(EventHandler value);
}

abstract interface class Storage {
  int get length;
  String? key(int index);
  String? getItem(String key);
  void setItem(String key, String value);
  void removeItem(String key);
  void clear();
}

abstract interface class StorageEvent {
  factory StorageEvent(String type, [StorageEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<StorageEvent>(
        'StorageEvent',
        [type, eventInitDict],
      );
  String? get key;
  String? get oldValue;
  String? get newValue;
  String get url;
  Storage? get storageArea;
  void initStorageEvent(String type, [bool? bubbles, bool? cancelable, String? key, String? oldValue, String? newValue, String? url, Storage? storageArea]);
}

abstract interface class StorageEventInit {
  String? get key;
  set key(String? value);
  String? get oldValue;
  set oldValue(String? value);
  String? get newValue;
  set newValue(String? value);
  String? get url;
  set url(String? value);
  Storage? get storageArea;
  set storageArea(Storage? value);
}

final class StorageEventInitValue implements StorageEventInit {
  @override
  String? key;
  @override
  String? oldValue;
  @override
  String? newValue;
  @override
  String? url;
  @override
  Storage? storageArea;

  StorageEventInitValue({
    this.key,
    this.oldValue,
    this.newValue,
    this.url,
    this.storageArea,
  });
}

abstract interface class StructuredSerializeOptions {
  List<Object>? get transfer;
  set transfer(List<Object>? value);
}

final class StructuredSerializeOptionsValue implements StructuredSerializeOptions {
  @override
  List<Object>? transfer;

  StructuredSerializeOptionsValue({
    this.transfer,
  });
}

abstract interface class SubmitEvent {
  factory SubmitEvent(String type, [SubmitEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<SubmitEvent>(
        'SubmitEvent',
        [type, eventInitDict],
      );
  HTMLElement? get submitter;
}

abstract interface class SubmitEventInit {
  HTMLElement? get submitter;
  set submitter(HTMLElement? value);
}

final class SubmitEventInitValue implements SubmitEventInit {
  @override
  HTMLElement? submitter;

  SubmitEventInitValue({
    this.submitter,
  });
}

abstract interface class TextMetrics {
  double get width;
  double get actualBoundingBoxLeft;
  double get actualBoundingBoxRight;
  double get fontBoundingBoxAscent;
  double get fontBoundingBoxDescent;
  double get actualBoundingBoxAscent;
  double get actualBoundingBoxDescent;
  double get emHeightAscent;
  double get emHeightDescent;
  double get hangingBaseline;
  double get alphabeticBaseline;
  double get ideographicBaseline;
}

abstract interface class TextTrack {
  TextTrackKind get kind;
  String get label;
  String get language;
  String get id;
  String get inBandMetadataTrackDispatchType;
  TextTrackMode get mode;
   set mode(TextTrackMode value);
  TextTrackCueList? get cues;
  TextTrackCueList? get activeCues;
  void addCue(TextTrackCue cue);
  void removeCue(TextTrackCue cue);
  EventHandler get oncuechange;
   set oncuechange(EventHandler value);
  SourceBuffer? get sourceBuffer;
}

abstract interface class TextTrackCue {
  TextTrack? get track;
  String get id;
   set id(String value);
  double get startTime;
   set startTime(double value);
  double get endTime;
   set endTime(double value);
  bool get pauseOnExit;
   set pauseOnExit(bool value);
  EventHandler get onenter;
   set onenter(EventHandler value);
  EventHandler get onexit;
   set onexit(EventHandler value);
}

abstract interface class TextTrackCueList {
  int get length;
  TextTrackCue? getCueById(String id);
}

typedef TextTrackKind = String;

abstract interface class TextTrackList {
  int get length;
  TextTrack? getTrackById(String id);
  EventHandler get onchange;
   set onchange(EventHandler value);
  EventHandler get onaddtrack;
   set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
   set onremovetrack(EventHandler value);
}

typedef TextTrackMode = String;

abstract interface class TimeRanges {
  int get length;
  double start(int index);
  double end(int index);
}

typedef TimerHandler = Object;

abstract interface class ToggleEvent {
  factory ToggleEvent(String type, [ToggleEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ToggleEvent>(
        'ToggleEvent',
        [type, eventInitDict],
      );
  String get oldState;
  String get newState;
}

abstract interface class ToggleEventInit {
  String? get oldState;
  set oldState(String? value);
  String? get newState;
  set newState(String? value);
}

final class ToggleEventInitValue implements ToggleEventInit {
  @override
  String? oldState;
  @override
  String? newState;

  ToggleEventInitValue({
    this.oldState,
    this.newState,
  });
}

abstract interface class TrackEvent {
  factory TrackEvent(String type, [TrackEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<TrackEvent>(
        'TrackEvent',
        [type, eventInitDict],
      );
  Object get track;
}

abstract interface class TrackEventInit {
  Object? get track;
  set track(Object? value);
}

final class TrackEventInitValue implements TrackEventInit {
  @override
  Object? track;

  TrackEventInitValue({
    this.track,
  });
}

abstract interface class UserActivation {
  bool get hasBeenActive;
  bool get isActive;
}

abstract interface class ValidityState {
  bool get valueMissing;
  bool get typeMismatch;
  bool get patternMismatch;
  bool get tooLong;
  bool get tooShort;
  bool get rangeUnderflow;
  bool get rangeOverflow;
  bool get stepMismatch;
  bool get badInput;
  bool get customError;
  bool get valid;
}

abstract interface class ValidityStateFlags {
  bool? get valueMissing;
  set valueMissing(bool? value);
  bool? get typeMismatch;
  set typeMismatch(bool? value);
  bool? get patternMismatch;
  set patternMismatch(bool? value);
  bool? get tooLong;
  set tooLong(bool? value);
  bool? get tooShort;
  set tooShort(bool? value);
  bool? get rangeUnderflow;
  set rangeUnderflow(bool? value);
  bool? get rangeOverflow;
  set rangeOverflow(bool? value);
  bool? get stepMismatch;
  set stepMismatch(bool? value);
  bool? get badInput;
  set badInput(bool? value);
  bool? get customError;
  set customError(bool? value);
}

final class ValidityStateFlagsValue implements ValidityStateFlags {
  @override
  bool? valueMissing;
  @override
  bool? typeMismatch;
  @override
  bool? patternMismatch;
  @override
  bool? tooLong;
  @override
  bool? tooShort;
  @override
  bool? rangeUnderflow;
  @override
  bool? rangeOverflow;
  @override
  bool? stepMismatch;
  @override
  bool? badInput;
  @override
  bool? customError;

  ValidityStateFlagsValue({
    this.valueMissing,
    this.typeMismatch,
    this.patternMismatch,
    this.tooLong,
    this.tooShort,
    this.rangeUnderflow,
    this.rangeOverflow,
    this.stepMismatch,
    this.badInput,
    this.customError,
  });
}

abstract interface class VideoTrack {
  String get id;
  String get kind;
  String get label;
  String get language;
  bool get selected;
   set selected(bool value);
  SourceBuffer? get sourceBuffer;
}

abstract interface class VideoTrackList {
  int get length;
  VideoTrack? getTrackById(String id);
  int get selectedIndex;
  EventHandler get onchange;
   set onchange(EventHandler value);
  EventHandler get onaddtrack;
   set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
   set onremovetrack(EventHandler value);
}

abstract interface class WindowLocalStorage {
  Storage get localStorage;
}

abstract interface class WindowPostMessageOptions {
  String? get targetOrigin;
  set targetOrigin(String? value);
}

final class WindowPostMessageOptionsValue implements WindowPostMessageOptions {
  @override
  String? targetOrigin;

  WindowPostMessageOptionsValue({
    this.targetOrigin,
  });
}

abstract interface class WindowSessionStorage {
  Storage get sessionStorage;
}

abstract interface class Worker {
  factory Worker(Object scriptURL, [WorkerOptions? options]) =>
      WebRuntime.current.createWebObject<Worker>(
        'Worker',
        [scriptURL, options],
      );
  EventHandler get onerror;
   set onerror(EventHandler value);
  void terminate();
  void postMessage(Object message, List<Object> transfer);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  EventHandler get onmessageerror;
   set onmessageerror(EventHandler value);
}

abstract interface class WorkerGlobalScope {
  FontFaceSet get fonts;
  IDBFactory get indexedDB;
  Crypto get crypto;
  Future<Response> fetch(RequestInfo input, [RequestInit? init]);
  Performance get performance;
  String get origin;
  bool get isSecureContext;
  bool get crossOriginIsolated;
  void reportError(Object e);
  String btoa(String data);
  String atob(String data);
  int setTimeout(TimerHandler handler, [int? timeout, List<Object>? arguments]);
  void clearTimeout([int? id]);
  int setInterval(TimerHandler handler, [int? timeout, List<Object>? arguments]);
  void clearInterval([int? id]);
  void queueMicrotask(VoidFunction callback);
  Future<ImageBitmap> createImageBitmap(ImageBitmapSource image, int sx, int sy, int sw, int sh, [ImageBitmapOptions? options]);
  Object structuredClone(Object value, [StructuredSerializeOptions? options]);
  Scheduler get scheduler;
  CacheStorage get caches;
  TrustedTypePolicyFactory get trustedTypes;
  WorkerGlobalScope get self;
  WorkerLocation get location;
  WorkerNavigator get navigator;
  void importScripts([List<Object>? urls]);
  OnErrorEventHandler get onerror;
   set onerror(OnErrorEventHandler value);
  EventHandler get onlanguagechange;
   set onlanguagechange(EventHandler value);
  EventHandler get onoffline;
   set onoffline(EventHandler value);
  EventHandler get ononline;
   set ononline(EventHandler value);
  EventHandler get onrejectionhandled;
   set onrejectionhandled(EventHandler value);
  EventHandler get onunhandledrejection;
   set onunhandledrejection(EventHandler value);
}

abstract interface class WorkerLocation {
  String get href;
  String get origin;
  String get protocol;
  String get host;
  String get hostname;
  String get port;
  String get pathname;
  String get search;
  String get hash;
}

abstract interface class WorkerNavigator {
  Future<void> setAppBadge([int? contents]);
  Future<void> clearAppBadge();
  double get deviceMemory;
  String get appCodeName;
  String get appName;
  String get appVersion;
  String get platform;
  String get product;
  String get productSub;
  String get userAgent;
  String get vendor;
  String get vendorSub;
  bool taintEnabled();
  String get oscpu;
  String get language;
  List<String> get languages;
  bool get onLine;
  int get hardwareConcurrency;
  NetworkInformation get connection;
  Object get storageBuckets;
  StorageManager get storage;
  Object get userAgentData;
  LockManager get locks;
  Object get gpu;
  Object get ml;
  MediaCapabilities get mediaCapabilities;
  Permissions get permissions;
  ServiceWorkerContainer get serviceWorker;
  Object get usb;
}

abstract interface class WorkerOptions {
  WorkerType? get type;
  set type(WorkerType? value);
  RequestCredentials? get credentials;
  set credentials(RequestCredentials? value);
  String? get name;
  set name(String? value);
}

final class WorkerOptionsValue implements WorkerOptions {
  @override
  WorkerType? type;
  @override
  RequestCredentials? credentials;
  @override
  String? name;

  WorkerOptionsValue({
    this.type,
    this.credentials,
    this.name,
  });
}

typedef WorkerType = String;

abstract interface class Worklet {
  Future<void> addModule(String moduleURL, [WorkletOptions? options]);
}

abstract interface class WorkletGlobalScope {
}

abstract interface class WorkletOptions {
  RequestCredentials? get credentials;
  set credentials(RequestCredentials? value);
}

final class WorkletOptionsValue implements WorkletOptions {
  @override
  RequestCredentials? credentials;

  WorkletOptionsValue({
    this.credentials,
  });
}

