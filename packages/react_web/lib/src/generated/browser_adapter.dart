// GENERATED CODE — DO NOT EDIT

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_js/react_js.dart';
import 'package:react_web/src/events.dart';
import 'package:react_web/src/types/html.dart';
import 'package:web/web.dart' as web;

final class GeneratedElement implements HTMLDivElement, HTMLSpanElement, HTMLButtonElement, HTMLInputElement, HTMLFormElement, HTMLLabelElement, HTMLTextAreaElement, HTMLSelectElement, HTMLOptionElement, HTMLAnchorElement, HTMLImageElement {
  final web.HTMLElement _inner;
  GeneratedElement(this._inner);

  @override
  String? get id => (_inner as dynamic).id as String?;
  @override
  void focus() => (_inner as dynamic).focus();
  @override
  String? get title => (_inner as dynamic).title as String?;
  @override
  String? get lang => (_inner as dynamic).lang as String?;
  @override
  bool? get hidden => (_inner as dynamic).hidden as bool?;
  @override
  int? get tabIndex => (_inner as dynamic).tabIndex as int?;
  @override
  String? get dir => (_inner as dynamic).dir as String?;
  @override
  bool? get disabled => (_inner as dynamic).disabled as bool?;
  @override
  String? get type => (_inner as dynamic).type as String?;
  @override
  String? get value => (_inner as dynamic).value as String?;
  @override
  String? get placeholder => (_inner as dynamic).placeholder as String?;
  @override
  String? get action => (_inner as dynamic).action as String?;
  @override
  String? get method => (_inner as dynamic).method as String?;
  @override
  String? get htmlFor => (_inner as dynamic).htmlFor as String?;
  @override
  bool? get selected => (_inner as dynamic).selected as bool?;
  @override
  String? get href => (_inner as dynamic).href as String?;
  @override
  String? get target => (_inner as dynamic).target as String?;
  @override
  String? get rel => (_inner as dynamic).rel as String?;
  @override
  String? get src => (_inner as dynamic).src as String?;
  @override
  String? get alt => (_inner as dynamic).alt as String?;
  @override
  int? get width => (_inner as dynamic).width as int?;
  @override
  int? get height => (_inner as dynamic).height as int?;
}

mixin SyntheticEventBaseMixin<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {
  JSObject get _jsEvent;

  @override
  bool get bubbles => _getBool('bubbles');
  @override
  bool get cancelable => _getBool('cancelable');
  @override
  bool get defaultPrevented => _getBool('defaultPrevented');
  @override
  void preventDefault() => _jsEvent.callMethod('preventDefault'.toJS);
  @override
  void stopPropagation() => _jsEvent.callMethod('stopPropagation'.toJS);
  @override
  T get currentTarget => _wrapEventTarget<T>(_jsEvent);
  @override
  WebEventTarget get target => _wrapTarget(_jsEvent);

  bool _getBool(String prop) =>
      (_jsEvent.getProperty(prop.toJS) as JSBoolean?)?.toDart ?? false;
}

mixin RelatedTargetMixin<T extends WebEventTarget> {
  JSObject get _jsEvent;
  WebEventTarget? get relatedTarget {
    final v = _jsEvent.getProperty('relatedTarget'.toJS);
    if (v == null || _isUndefinedOrNull(v)) return null;
    return _wrapOne(v) as WebEventTarget?;
  }
}

final class GeneratedReactSyntheticEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactSyntheticEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactSyntheticEvent(this._jsEvent);
}

final class GeneratedReactMouseEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactMouseEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactMouseEvent(this._jsEvent);

  @override
  double get clientX => (_jsEvent.getProperty('clientX'.toJS) as JSNumber).toDartDouble;
  @override
  double get clientY => (_jsEvent.getProperty('clientY'.toJS) as JSNumber).toDartDouble;
  @override
  int get button => (_jsEvent.getProperty('button'.toJS) as JSNumber).toDartInt;
  @override
  bool get altKey => _getBool('altKey');
  @override
  bool get ctrlKey => _getBool('ctrlKey');
  @override
  bool get shiftKey => _getBool('shiftKey');
}

final class GeneratedReactInputEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactInputEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactInputEvent(this._jsEvent);

  @override
  String get data => (_jsEvent.getProperty('data'.toJS) as JSString).toDart;
}

final class GeneratedReactChangeEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactChangeEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactChangeEvent(this._jsEvent);

}

final class GeneratedReactFormEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactFormEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactFormEvent(this._jsEvent);

}

final class GeneratedReactKeyboardEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactKeyboardEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactKeyboardEvent(this._jsEvent);

  @override
  String get key => (_jsEvent.getProperty('key'.toJS) as JSString).toDart;
  @override
  int get keyCode => (_jsEvent.getProperty('keyCode'.toJS) as JSNumber).toDartInt;
  @override
  bool get altKey => _getBool('altKey');
  @override
  bool get ctrlKey => _getBool('ctrlKey');
  @override
  bool get shiftKey => _getBool('shiftKey');
}

final class GeneratedReactFocusEvent<T extends WebEventTarget>
    with SyntheticEventBaseMixin<T>
    , RelatedTargetMixin<T>
    implements ReactFocusEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactFocusEvent(this._jsEvent);

}

Object? wrapJSValue(JSAny? value) {
  if (value == null || _isUndefinedOrNull(value)) return null;
  final jsObject = value as JSObject;
  if (_hasProperty(jsObject, 'tagName')) return _wrapElement(jsObject);
  if (_hasProperty(jsObject, 'type')) return _wrapEventByType(jsObject);
  return jsObject;
}

GeneratedElement _wrapElement(JSObject js) {
  final el = js as web.HTMLElement;
  return GeneratedElement(el);
}

Object? _wrapEventByType(JSObject js) {
  final type = (js.getProperty('type'.toJS) as JSString).toDart;
  return switch (type) {
    'ReactMouseEvent' => GeneratedReactMouseEvent<HTMLDivElement>(js),
    'ReactInputEvent' => GeneratedReactInputEvent<HTMLDivElement>(js),
    'ReactChangeEvent' => GeneratedReactChangeEvent<HTMLDivElement>(js),
    'ReactFormEvent' => GeneratedReactFormEvent<HTMLDivElement>(js),
    'ReactKeyboardEvent' => GeneratedReactKeyboardEvent<HTMLDivElement>(js),
    'ReactFocusEvent' => GeneratedReactFocusEvent<HTMLDivElement>(js),
    _ => GeneratedReactSyntheticEvent<WebEventTarget>(js),
  };
}

T _wrapEventTarget<T extends WebEventTarget>(JSObject js) {
  final el = js.getProperty('currentTarget'.toJS);
  return _wrapOne(el) as T;
}

WebEventTarget _wrapTarget(JSObject js) {
  final el = js.getProperty('target'.toJS);
  return _wrapOne(el) as WebEventTarget;
}

Object? _wrapOne(JSAny? value) {
  if (value == null || _isUndefinedOrNull(value)) return null;
  final js = value as JSObject;
  if (_hasProperty(js, 'tagName')) return _wrapElement(js);
  if (_hasProperty(js, 'type')) return _wrapEventByType(js);
  return js;
}

bool _isUndefinedOrNull(JSAny? value) =>
    value.isUndefined || value.isNull;

bool _hasProperty(JSObject obj, String prop) =>
    obj.hasProperty(prop.toJS).toDart;

void registerBrowserAdapters() {
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDivElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSpanElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLButtonElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLInputElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFormElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLLabelElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTextAreaElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSelectElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOptionElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLAnchorElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLImageElement',
    decoder: (value) => GeneratedElement(value as web.HTMLElement),
    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactMouseEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactMouseEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactInputEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactInputEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactChangeEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactChangeEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFormEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactFormEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactKeyboardEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactKeyboardEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFocusEvent<HTMLDivElement>',
    decoder: (value) => GeneratedReactFocusEvent(value as JSObject),
  );
}

