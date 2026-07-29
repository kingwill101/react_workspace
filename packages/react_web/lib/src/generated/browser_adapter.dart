// GENERATED CODE — DO NOT EDIT

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_js/react_js.dart';
import 'package:react_web/src/event_interfaces.dart';
import 'package:react_web/src/types/html_interfaces.dart';
import 'package:web/web.dart' as web;

final class GeneratedElement implements EventTarget {
  final web.HTMLElement _inner;
  GeneratedElement(this._inner);

  @override
  void addEventListener() => (_inner as dynamic).addEventListener();
  @override
  void removeEventListener() => (_inner as dynamic).removeEventListener();
  @override
  bool dispatchEvent() => (_inner as dynamic).dispatchEvent();
}

mixin SyntheticEventBaseMixin<T extends EventTarget>
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
  EventTarget get target => _wrapTarget(_jsEvent);

  bool _getBool(String prop) =>
      (_jsEvent.getProperty(prop.toJS) as JSBoolean?)?.toDart ?? false;
}

mixin RelatedTargetMixin<T extends EventTarget> {
  JSObject get _jsEvent;
  EventTarget? get relatedTarget {
    final v = _jsEvent.getProperty('relatedTarget'.toJS);
    if (v == null || _isUndefinedOrNull(v)) return null;
    return _wrapOne(v) as EventTarget?;
  }
}

final class GeneratedReactSyntheticEvent<T extends EventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactSyntheticEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactSyntheticEvent(this._jsEvent);
}

final class GeneratedReactMouseEvent<T extends EventTarget>
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

final class GeneratedReactInputEvent<T extends EventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactInputEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactInputEvent(this._jsEvent);

  @override
  String get data => (_jsEvent.getProperty('data'.toJS) as JSString).toDart;
}

final class GeneratedReactChangeEvent<T extends EventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactChangeEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactChangeEvent(this._jsEvent);

}

final class GeneratedReactFormEvent<T extends EventTarget>
    with SyntheticEventBaseMixin<T>
    implements ReactFormEvent<T> {
  @override
  final JSObject _jsEvent;
  GeneratedReactFormEvent(this._jsEvent);

}

final class GeneratedReactKeyboardEvent<T extends EventTarget>
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

final class GeneratedReactFocusEvent<T extends EventTarget>
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
    'ReactMouseEvent' => GeneratedReactMouseEvent<EventTarget>(js),
    'ReactInputEvent' => GeneratedReactInputEvent<EventTarget>(js),
    'ReactChangeEvent' => GeneratedReactChangeEvent<EventTarget>(js),
    'ReactFormEvent' => GeneratedReactFormEvent<EventTarget>(js),
    'ReactKeyboardEvent' => GeneratedReactKeyboardEvent<EventTarget>(js),
    'ReactFocusEvent' => GeneratedReactFocusEvent<EventTarget>(js),
    _ => GeneratedReactSyntheticEvent<EventTarget>(js),
  };
}

T _wrapEventTarget<T extends EventTarget>(JSObject js) {
  final el = js.getProperty('currentTarget'.toJS);
  return _wrapOne(el) as T;
}

EventTarget _wrapTarget(JSObject js) {
  final el = js.getProperty('target'.toJS);
  return _wrapOne(el) as EventTarget;
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
    'web', 'ReactMouseEvent<EventTarget>',
    decoder: (value) => GeneratedReactMouseEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactInputEvent<EventTarget>',
    decoder: (value) => GeneratedReactInputEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactChangeEvent<EventTarget>',
    decoder: (value) => GeneratedReactChangeEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFormEvent<EventTarget>',
    decoder: (value) => GeneratedReactFormEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactKeyboardEvent<EventTarget>',
    decoder: (value) => GeneratedReactKeyboardEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFocusEvent<EventTarget>',
    decoder: (value) => GeneratedReactFocusEvent(value as JSObject),
  );
}

