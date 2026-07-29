import 'package:react_web_generator/src/web_host_ir.dart';

final class AdapterEmitter {
  final List<WebHostElementIR> elements;
  final Map<String, dynamic> _interfaceModel;

  const AdapterEmitter(this.elements, this._interfaceModel);

  Set<String> get _elementTypes =>
      elements.map((e) => _baseName(e.elementType.symbol)).toSet();

  Set<String> get _eventTypes {
    final s = <String>{};
    for (final el in elements) {
      for (final ev in el.events) {
        s.add(_baseName(ev.reactEventType.symbol));
      }
    }
    return s;
  }

  String emit() {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln();
    buf.writeln("import 'dart:js_interop';");
    buf.writeln("import 'dart:js_interop_unsafe';");
    buf.writeln();
    buf.writeln("import 'package:react_js/react_js.dart';");
    buf.writeln("import 'package:react_web/src/event_interfaces.dart';");
    buf.writeln("import 'package:react_web/src/types/html_interfaces.dart';");
    buf.writeln("import 'package:web/web.dart' as web;");
    buf.writeln();

    _emitElementAdapter(buf);
    _emitEventAdapters(buf);
    _emitWrapHelpers(buf);
    _emitRegistration(buf);

    return buf.toString();
  }

  Map<String, dynamic> _eventModel(String name) =>
      _interfaceModel['eventTypes'][name] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> _elementModel(String name) =>
      _interfaceModel['elementTypes'][name] as Map<String, dynamic>? ?? {};

  List<Map<String, dynamic>> _members(String typeName, String category) {
    final model = category == 'eventTypes'
        ? _eventModel(typeName)
        : _elementModel(typeName);
    final members =
        List<Map<String, dynamic>>.from(model['members'] as List? ?? []);
    final parent = model['parent'] as String?;
    if (parent != null) {
      members.insertAll(0, _members(parent, category));
    }
    return members;
  }

  List<Map<String, dynamic>> _collectedMembers(
      String typeName, String category) {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];
    for (final m in _members(typeName, category)) {
      final name = m['name'] as String;
      if (seen.add(name)) result.add(m);
    }
    return result;
  }

  /// Maps a neutral interface property name to the web property name
  /// (different casing conventions, etc.)
  String _webProp(String neutralName) => switch (neutralName) {
    'htmlFor' => 'htmlFor',
    'tabIndex' => 'tabIndex',
    _ => neutralName,
  };

  String _jsReadExpr(String prop, String returnType) => switch (returnType) {
    'bool' => "_getBool('$prop')",
    'int' => "(_jsEvent.getProperty('$prop'.toJS) as JSNumber).toDartInt",
    'double' =>
      "(_jsEvent.getProperty('$prop'.toJS) as JSNumber).toDartDouble",
    'String' => "(_jsEvent.getProperty('$prop'.toJS) as JSString).toDart",
    _ =>
      "(_jsEvent.getProperty('$prop'.toJS) as ${returnType.contains('?') ? returnType : '$returnType?'})",
  };

  void _emitElementAdapter(StringBuffer buf) {
    buf.writeln('final class GeneratedElement implements EventTarget {');
    buf.writeln('  final web.HTMLElement _inner;');
    buf.writeln('  GeneratedElement(this._inner);');
    buf.writeln();
    buf.writeln('  @override');
    buf.writeln("  void addEventListener() => (_inner as dynamic).addEventListener();");
    buf.writeln('  @override');
    buf.writeln("  void removeEventListener() => (_inner as dynamic).removeEventListener();");
    buf.writeln('  @override');
    buf.writeln("  bool dispatchEvent() => (_inner as dynamic).dispatchEvent();");
    buf.writeln('}');
    buf.writeln();
  }

  void _emitEventAdapters(StringBuffer buf) {
    final events = _eventTypes;
    if (events.isEmpty) return;

    final typeArg = 'T extends EventTarget';

    // Shared synthetic event base mixin
    buf.writeln('mixin SyntheticEventBaseMixin<$typeArg>');
    buf.writeln('    implements ReactSyntheticEvent<T> {');
    buf.writeln('  JSObject get _jsEvent;');
    buf.writeln();

    final baseMembers = _collectedMembers('ReactSyntheticEvent', 'eventTypes');
    for (final m in baseMembers) {
      final name = m['name'] as String;
      final returnType = m['returnType'] as String;
      final kind = m['kind'] as String;
      if (kind == 'method') {
        buf.writeln('  @override');
        buf.writeln("  void $name() => _jsEvent.callMethod('$name'.toJS);");
      } else {
        buf.writeln('  @override');
        buf.writeln('  $returnType get $name => ${_jsReadExpr(name, returnType)};');
      }
    }

    // currentTarget and target need element wrapping
    buf.writeln('  @override');
    buf.writeln('  T get currentTarget => _wrapEventTarget<T>(_jsEvent);');
    buf.writeln('  @override');
    buf.writeln("  EventTarget get target => _wrapTarget(_jsEvent);");

    buf.writeln();
    buf.writeln("  bool _getBool(String prop) =>");
    buf.writeln("      (_jsEvent.getProperty(prop.toJS) as JSBoolean?)?.toDart ?? false;");
    buf.writeln('}');
    buf.writeln();

    // Focus event mixin for relatedTarget
    if (events.contains('ReactFocusEvent')) {
      buf.writeln('mixin RelatedTargetMixin<$typeArg> {');
      buf.writeln('  JSObject get _jsEvent;');
    buf.writeln("  EventTarget? get relatedTarget {");
    buf.writeln("    final v = _jsEvent.getProperty('relatedTarget'.toJS);");
    buf.writeln('    if (v == null || _isUndefinedOrNull(v)) return null;');
    buf.writeln('    return _wrapOne(v) as EventTarget?;');
    buf.writeln('  }');
      buf.writeln('}');
      buf.writeln();
    }

    // Always generate a fallback synthetic event adapter
    buf.writeln('final class GeneratedReactSyntheticEvent<$typeArg>');
    buf.writeln('    with SyntheticEventBaseMixin<T>');
    buf.writeln('    implements ReactSyntheticEvent<T> {');
    buf.writeln('  @override');
    buf.writeln('  final JSObject _jsEvent;');
    buf.writeln('  GeneratedReactSyntheticEvent(this._jsEvent);');
    buf.writeln('}');
    buf.writeln();

    for (final eventType in events) {
      _emitEventAdapter(buf, eventType, typeArg);
    }
  }

  void _emitEventAdapter(
      StringBuffer buf, String eventType, String typeArg) {
    final extra = _collectedMembers(eventType, 'eventTypes');
    final baseExtra = _collectedMembers('ReactSyntheticEvent', 'eventTypes');
    final onlySpecific = extra
        .where((m) => !baseExtra.any((b) => b['name'] == m['name']))
        .toList();

    buf.writeln('final class Generated$eventType<$typeArg>');
    buf.writeln('    with SyntheticEventBaseMixin<T>');
    if (eventType == 'ReactFocusEvent') {
      buf.writeln('    , RelatedTargetMixin<T>');
    }
    buf.writeln('    implements $eventType<T> {');
    buf.writeln('  @override');
    buf.writeln('  final JSObject _jsEvent;');
    buf.writeln('  Generated$eventType(this._jsEvent);');
    buf.writeln();

    for (final m in onlySpecific) {
      final name = m['name'] as String;
      final returnType = m['returnType'] as String;
      final kind = m['kind'] as String;
      buf.writeln('  @override');
      if (kind == 'method') {
        if (returnType == 'void') {
          buf.writeln("  void $name() => _jsEvent.callMethod('$name'.toJS);");
        } else {
          buf.writeln("  $returnType $name() => (_jsEvent.callMethod('$name'.toJS, '' .toJS) as JSNumber).toDartInt;");
        }
      } else {
        buf.writeln('  $returnType get $name => ${_jsReadExpr(name, returnType)};');
      }
    }

    buf.writeln('}');
    buf.writeln();
  }

  void _emitWrapHelpers(StringBuffer buf) {


    // Wrap JS value based on tag name for elements, or type for events
    buf.writeln('Object? wrapJSValue(JSAny? value) {');
    buf.writeln('  if (value == null || _isUndefinedOrNull(value)) return null;');
    buf.writeln('  final jsObject = value as JSObject;');
    buf.writeln("  if (_hasProperty(jsObject, 'tagName')) return _wrapElement(jsObject);");
    buf.writeln("  if (_hasProperty(jsObject, 'type')) return _wrapEventByType(jsObject);");
    buf.writeln('  return jsObject;');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('GeneratedElement _wrapElement(JSObject js) {');
    buf.writeln("  final el = js as web.HTMLElement;");
    buf.writeln('  return GeneratedElement(el);');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('Object? _wrapEventByType(JSObject js) {');
    buf.writeln("  final type = (js.getProperty('type'.toJS) as JSString).toDart;");
    buf.writeln('  return switch (type) {');
    for (final eventType in _eventTypes) {
      buf.writeln("    '$eventType' => Generated$eventType<EventTarget>(js),");
    }
    buf.writeln("    _ => GeneratedReactSyntheticEvent<EventTarget>(js),");
    buf.writeln('  };');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('T _wrapEventTarget<T extends EventTarget>(JSObject js) {');
    buf.writeln("  final el = js.getProperty('currentTarget'.toJS);");
    buf.writeln('  return _wrapOne(el) as T;');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('EventTarget _wrapTarget(JSObject js) {');
    buf.writeln("  final el = js.getProperty('target'.toJS);");
    buf.writeln('  return _wrapOne(el) as EventTarget;');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('Object? _wrapOne(JSAny? value) {');
    buf.writeln('  if (value == null || _isUndefinedOrNull(value)) return null;');
    buf.writeln('  final js = value as JSObject;');
    buf.writeln("  if (_hasProperty(js, 'tagName')) return _wrapElement(js);");
    buf.writeln("  if (_hasProperty(js, 'type')) return _wrapEventByType(js);");
    buf.writeln('  return js;');
    buf.writeln('}');
    buf.writeln();

    buf.writeln('bool _isUndefinedOrNull(JSAny? value) =>');
    buf.writeln('    value.isUndefined || value.isNull;');
    buf.writeln();
    buf.writeln('bool _hasProperty(JSObject obj, String prop) =>');
    buf.writeln('    obj.hasProperty(prop.toJS).toDart;');
    buf.writeln();
  }

  void _emitRegistration(StringBuffer buf) {
    buf.writeln('void registerBrowserAdapters() {');
    for (final et in _elementTypes) {
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$et',");
      buf.writeln('    decoder: (value) => GeneratedElement(value as web.HTMLElement),');
      buf.writeln('    encoder: (value) => (value as GeneratedElement)._inner as JSAny?,');
      buf.writeln('  );');
    }
    for (final et in _eventTypes) {
      buf.writeln("  ReactCodecRegistry.registerHostValue(");
      buf.writeln("    'web', '$et<EventTarget>',");
      buf.writeln('    decoder: (value) => Generated$et(value as JSObject),');
      buf.writeln('  );');
    }
    buf.writeln('}');
    buf.writeln();
  }

  String _baseName(String symbol) =>
      symbol.contains('<') ? symbol.substring(0, symbol.indexOf('<')) : symbol;
}
