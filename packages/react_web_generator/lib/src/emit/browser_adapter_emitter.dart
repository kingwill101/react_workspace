/// Emits the browser backend for the complete neutral surface:
/// `generated/browser_adapter.dart`.
///
/// Every neutral interface in the wrapper closure (DOM elements, the `Window`/
/// `Document`/`Navigator` runtime objects, and every interface they reference)
/// gets a thin `Browser<Name>` proxy that forwards reads, writes and method
/// calls to the underlying JS object through [BrowserObjectAdapter]'s
/// `noSuchMethod`. JS property names are driven by the same IDL member names
/// the neutral surface uses, so delegation stays 1:1 with the surface.
library;

import 'dart:io';

import '../complete/definition.dart';
import '../complete/member.dart';
import '../complete/members.dart';
import '../complete/model.dart';
import '../model/type_ref.dart';
import 'react_event_defs.dart';

final class BrowserAdapterEmitter {
  final CompleteWebModel model;

  /// Top-level type names present in the installed `package:web`; when a name
  /// is present the generated proxy also exposes an `inner` accessor typed with
  /// the `package:web` extension type.
  final Set<String> packageWebNames;

  late final Set<String> _wrapperNames;
  late final Map<String, String> _kinds;
  late final Map<String, String> _jsNames;

  BrowserAdapterEmitter(
    this.model, {
    this.packageWebNames = const {},
  }) {
    _compute();
  }

  static const _reservedTypeNames = <String>{
    'Function', 'Object', 'String', 'int', 'double', 'bool', 'dynamic',
    'void', 'num', 'Null', 'Never', 'Future', 'List', 'Map', 'Set',
    'Iterable', 'Type',
  };

  /// Interface names that anchor the wrapper closure even though they are not
  /// `HTML`/`SVG`/`MathML` prefixed.
  static const _elementSeeds = <String>{
    'EventTarget', 'Node', 'Element', 'HTMLElement', 'SVGElement',
    'MathMLElement', 'Window', 'Document', 'Navigator',
  };

  /// Computes the wrapper set: element-like interfaces plus constructible
  /// interfaces, plus the transitive closure of interface types they
  /// reference. Constructible interfaces (e.g. [BroadcastChannel]) gain a
  /// `Browser*` proxy and a JS constructor entry so the neutral factory
  /// constructors dispatched through [WebRuntime] can instantiate them.
  void _compute() {
    final wrapNames = <String>{};
    final queue = <String>[
      for (final name in model.interfaces.keys)
        if (_isElementLike(name) || _isConstructible(name)) name,
    ];
    while (queue.isNotEmpty) {
      final name = queue.removeLast();
      if (!wrapNames.add(name)) continue;
      final iface = model.interfaces[name];
      if (iface == null) continue;
      for (final m in flattenMembers(model, iface)) {
        for (final refName in _referencedTypeNames(m)) {
          if (model.interfaces.containsKey(refName)) queue.add(refName);
        }
      }
    }
    _wrapperNames = wrapNames;

    _kinds = {};
    _jsNames = {};
    for (final name in _wrapperNames.toList()..sort()) {
      _collectMemberTable('Browser$name', model.interfaces[name]!);
    }
    for (final def in reactEventDefs) {
      _collectEventTable(def);
    }
  }

  bool _isElementLike(String name) =>
      name.startsWith('HTML') ||
      name.startsWith('SVG') ||
      name.startsWith('MathML') ||
      _elementSeeds.contains(name);

  /// Whether the interface declares an IDL constructor and can therefore be
  /// instantiated through the neutral factory + [WebRuntime] dispatch.
  bool _isConstructible(String name) =>
      model.interfaces[name]?.members.any((m) => m is IdlConstructor) ?? false;

  /// Constructible interface names that get a JS constructor entry (the
  /// primary IDL constructor; secondary named constructors are ignored).
  late final List<String> _constructibleNames = [
    for (final name in model.interfaces.keys)
      if (_isConstructible(name) && !_reservedTypeNames.contains(name)) name,
  ]..sort();

  /// Callback-typedef names (e.g. `EventHandler`, `BlobCallback`): members
  /// typed with these are JS functions and need the `jsfunction` kind.
  late final Set<String> _callbackNames = () {
    final names = <String>{for (final c in model.callbacks.values) c.name};
    var changed = true;
    while (changed) {
      changed = false;
      for (final t in model.typedefs.entries) {
        if (names.contains(t.key)) continue;
        final target = _typeName(t.value.type);
        if (target != null && names.contains(target) && names.add(t.key)) {
          changed = true;
        }
      }
    }
    return names;
  }();

  String? _typeName(TypeRef t) => switch (t) {
    NamedTypeRef() =>
      t.typeId.contains('.') ? t.typeId.split('.').last : t.typeId,
    _ => null,
  };

  Iterable<String> _referencedTypeNames(IdlMember m) sync* {
    switch (m) {
      case IdlAttribute():
        yield* _namesOf(m.type);
      case IdlOperation():
        yield* _namesOf(m.returnType);
        for (final p in m.parameters) {
          yield* _namesOf(p.type);
        }
      case IdlIterable():
        for (final t in m.types) {
          yield* _namesOf(t);
        }
      case IdlMaplike():
        yield* _namesOf(m.keyType);
        yield* _namesOf(m.valueType);
      case IdlSetlike():
        yield* _namesOf(m.valueType);
      case IdlConstant():
        yield* _namesOf(m.type);
      case IdlConstructor() || IdlField():
        break;
    }
  }

  Iterable<String> _namesOf(TypeRef t) sync* {
    switch (t) {
      case NamedTypeRef():
        final id = t.typeId;
        if (id.startsWith('core.')) return;
        final name = id.contains('.') ? id.substring(id.indexOf('.') + 1) : id;
        yield name;
        for (final a in t.arguments) {
          yield* _namesOf(a);
        }
      case UnionTypeRef():
        for (final o in t.options) {
          yield* _namesOf(o);
        }
      case TypeParameterRef():
        break;
    }
  }

  void _collectMemberTable(String className, IdlInterface iface) {
    for (final m in flattenMembers(model, iface)) {
      switch (m) {
        case IdlAttribute():
          final dartName = escapeIdentifier(m.name);
          _kinds['$className.$dartName'] = _kindOf(m.type);
          if (dartName != m.name) _jsNames['$className.$dartName'] = m.name;
        case IdlOperation():
          if (m.name.isEmpty) continue;
          final dartName = escapeIdentifier(m.name);
          _kinds['$className.$dartName'] = _kindOf(m.returnType);
          if (dartName != m.name) _jsNames['$className.$dartName'] = m.name;
        default:
          break;
      }
    }
  }

  void _collectEventTable(ReactEventDef def) {
    final className = 'Browser${def.name}';
    final base = reactEventDefs.first;
    for (final m in [...base.members, ...base.methods, ...def.members, ...def.methods]) {
      _kinds['$className.${m.name}'] = _kindFromReturnType(m.returnType);
    }
  }

  String _kindOf(TypeRef ref) {
    switch (ref) {
      case NamedTypeRef():
        final id = ref.typeId;
        final name = id.contains('.') ? id.substring(id.indexOf('.') + 1) : id;
        if (_callbackNames.contains(name)) return 'jsfunction';
        return switch (name) {
          'bool' => 'bool',
          'int' => 'int',
          'double' => 'double',
          'num' => 'double',
          'String' => 'string',
          'void' => 'void',
          _ => 'wrap',
        };
      case UnionTypeRef() || TypeParameterRef():
        return 'wrap';
    }
  }

  String _kindFromReturnType(String returnType) {
    final clean = returnType.endsWith('?')
        ? returnType.substring(0, returnType.length - 1)
        : returnType;
    return switch (clean) {
      'bool' => 'bool',
      'int' => 'int',
      'double' => 'double',
      'String' => 'string',
      'void' => 'void',
      _ => 'wrap',
    };
  }

  void emitToDirectory(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln(
      '// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_renaming_method_parameters, invalid_runtime_check_with_js_interop_types',
    );
    buf.writeln();
    buf.writeln("import 'dart:js_interop';");
    buf.writeln("import 'dart:js_interop_unsafe';");
    buf.writeln();
    buf.writeln("import 'package:react_js/react_js.dart' show ReactCodecRegistry;");
    buf.writeln(
      "import 'package:react_web/src/generated/react_events.dart';",
    );
    buf.writeln("import 'package:react_web/src/generated/web/web.dart';");
    buf.writeln("import 'package:react_web/src/web_runtime.dart';");
    buf.writeln("import 'package:web/web.dart' as web;");
    buf.writeln();

    _emitBase(buf);
    _emitKindTable(buf);
    _emitWrappers(buf);
    _emitRuntime(buf);
    _emitRegistration(buf);

    final file = File('$outputDir/browser_adapter.dart');
    file.createSync(recursive: true);
    file.writeAsStringSync(buf.toString());
  }

  void _emitBase(StringBuffer buf) {
    buf.writeln('/// Browser proxy base: forwards interface members to the');
    buf.writeln('/// underlying JS object via [noSuchMethod].');
    buf.writeln('abstract class BrowserObjectAdapter {');
    buf.writeln('  BrowserObjectAdapter(this._element);');
    buf.writeln();
    buf.writeln('  /// The underlying JS object.');
    buf.writeln('  final JSObject _element;');
    buf.writeln();
    buf.writeln('  @override');
    buf.writeln('  dynamic noSuchMethod(Invocation invocation) {');
    buf.writeln('    final className = _baseClassName(runtimeType.toString());');
    buf.writeln('    final name = _memberName(invocation);');
    buf.writeln("    final key = '\$className.\$name';");
    buf.writeln('    final jsName = _jsNames[key] ?? name;');
    buf.writeln('    if (invocation.isGetter) {');
    buf.writeln(
      "      return _convert(_element.getProperty(jsName.toJS), _kinds[key] ?? 'wrap');",
    );
    buf.writeln('    }');
    buf.writeln('    if (invocation.isSetter) {');
    buf.writeln('      final arg = invocation.positionalArguments.first;');
    buf.writeln('      _element.setProperty(');
    buf.writeln('        jsName.toJS,');
    buf.writeln('        arg is Function ? _handlerToJs(arg) : _toJs(arg),');
    buf.writeln('      );');
    buf.writeln('      return null;');
    buf.writeln('    }');
    buf.writeln('    if (invocation.isMethod) {');
    buf.writeln('      final args = [');
    buf.writeln('        for (final a in invocation.positionalArguments)');
    buf.writeln('          a is Function ? _handlerToJs(a) : _toJs(a),');
    buf.writeln('      ];');
    buf.writeln('      return _convert(');
    buf.writeln('        _element.callMethodVarArgs(jsName.toJS, args),');
    buf.writeln("        _kinds[key] ?? 'wrap',");
    buf.writeln('      );');
    buf.writeln('    }');
    buf.writeln('    return super.noSuchMethod(invocation);');
    buf.writeln('  }');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('final class _UnknownObject extends BrowserObjectAdapter {');
    buf.writeln('  _UnknownObject(super.element);');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('/// Strips type arguments from `runtimeType` string forms so');
    buf.writeln('/// generic proxies (e.g. `BrowserReactMouseEvent<EventTarget>`)');
    buf.writeln('/// still hit their kind-table entries.');
    buf.writeln('String _baseClassName(String runtimeTypeName) {');
    buf.writeln("  final i = runtimeTypeName.indexOf('<');");
    buf.writeln(
      '  return i < 0 ? runtimeTypeName : runtimeTypeName.substring(0, i);',
    );
    buf.writeln('}');
    buf.writeln();
    buf.writeln('String _memberName(Invocation invocation) {');
    buf.writeln('  final symbol = invocation.memberName.toString();');
    buf.writeln('  final open = symbol.indexOf(\'"\');');
    buf.writeln('  final close = symbol.lastIndexOf(\'"\');');
    buf.writeln(
      '  var name = open < 0 ? symbol : symbol.substring(open + 1, close);',
    );
    buf.writeln("  if (name.endsWith('=')) name = name.substring(0, name.length - 1);");
    buf.writeln('  return name;');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('JSAny? _toJs(Object? value) {');
    buf.writeln('  if (value == null) return null;');
    buf.writeln('  if (value is BrowserObjectAdapter) return value._element;');
    buf.writeln('  if (value is JSAny) return value;');
    buf.writeln('  if (value is String) return value.toJS;');
    buf.writeln('  if (value is bool) return value.toJS;');
    buf.writeln('  if (value is int) return value.toJS;');
    buf.writeln('  if (value is double) return value.toJS;');
    buf.writeln('  if (value is List)');
    buf.writeln('    return [for (final e in value) _toJs(e)].toJS;');
    buf.writeln('  if (value is Function) return _handlerToJs(value);');
    buf.writeln(
      '  throw ArgumentError(\'Unsupported JS argument type: \${value.runtimeType}.\');',
    );
    buf.writeln('}');
    buf.writeln();
    buf.writeln('/// Creates a JS function that invokes the Dart handler [reference]');
    buf.writeln('/// through the module-level [_dispatchDartHandler] trampoline.');
    buf.writeln('/// Uses the same `__dartReactCallbacks.create` machinery as the React');
    buf.writeln('/// callback bridge (see `package:react_js`), which dart2js always');
    buf.writeln('/// compiles into a real JS function.');
    buf.writeln('@JS(\'__dartReactCallbacks.create\')');
    buf.writeln('external JSFunction _createDartHandler(');
    buf.writeln('  ExternalDartReference<Function> reference,');
    buf.writeln('  JSExportedDartFunction dispatcher,');
    buf.writeln(');');
    buf.writeln();
    buf.writeln('/// Module-level trampoline: decodes the raw JS arguments, wraps the');
    buf.writeln('/// event object in a `Browser*` proxy, and forwards it to the');
    buf.writeln('/// Dart handler. Top-level (not a closure) so that `.toJS` compiles');
    buf.writeln('/// into a real JS function, exactly like `_dispatchReactCallback`.');
    buf.writeln('JSAny? _dispatchDartHandler(');
    buf.writeln('  ExternalDartReference<Function> reference,');
    buf.writeln('  JSArray<JSAny?> rawArguments,');
    buf.writeln(') {');
    buf.writeln('  final handler = reference.toDartObject;');
    buf.writeln('  Object? event;');
    buf.writeln('  final raw = rawArguments.length > 0 ? rawArguments[0] : null;');
    buf.writeln('  if (raw != null && !raw.isNull && !raw.isUndefined) {');
    buf.writeln('    if (raw is JSString) {');
    buf.writeln('      event = raw.toDart;');
    buf.writeln('    } else if (raw is JSBoolean) {');
    buf.writeln('      event = raw.toDart;');
    buf.writeln('    } else if (raw is JSNumber) {');
    buf.writeln('      event = raw.toDartDouble;');
    buf.writeln('    } else {');
    buf.writeln('      event = _wrapObject(raw as JSObject);');
    buf.writeln('    }');
    buf.writeln('  }');
    buf.writeln('  final result = handler(event);');
    buf.writeln('  if (result == null) return null;');
    buf.writeln('  if (result is JSAny) return result;');
    buf.writeln('  return _toJs(result);');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('final JSExportedDartFunction _dispatchDartHandlerJS =');
    buf.writeln('    _dispatchDartHandler.toJS;');
    buf.writeln();
    buf.writeln('/// Bridges a Dart callback (e.g. an `onmessage` handler) into a');
    buf.writeln('/// JS function. The callback travels to JS as an opaque');
    buf.writeln('/// [ExternalDartReference]; the actual JS function is created by the');
    buf.writeln('/// `__dartReactCallbacks.create` trampoline.');
    buf.writeln('JSFunction? _handlerToJs(Object? value) {');
    buf.writeln('  if (value == null) return null;');
    buf.writeln('  return _createDartHandler(');
    buf.writeln('    (value as Function).toExternalReference,');
    buf.writeln('    _dispatchDartHandlerJS,');
    buf.writeln('  );');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('dynamic _convert(JSAny? value, String kind) {');
    buf.writeln('  if (value == null || value.isNull || value.isUndefined) return null;');
    buf.writeln('  return switch (kind) {');
    buf.writeln("    'bool' => (value as JSBoolean).toDart,");
    buf.writeln("    'int' => (value as JSNumber).toDartInt,");
    buf.writeln("    'double' => (value as JSNumber).toDartDouble,");
    buf.writeln("    'string' => (value as JSString).toDart,");
    buf.writeln("    'void' => null,");
    buf.writeln("    'jsfunction' => value,");
    buf.writeln('    _ => value is JSString');
    buf.writeln('        ? (value as JSString).toDart');
    buf.writeln('        : value is JSBoolean');
    buf.writeln('            ? (value as JSBoolean).toDart');
    buf.writeln('            : value is JSNumber');
    buf.writeln('                ? (value as JSNumber).toDartDouble');
    buf.writeln('                : _wrapObject(value as JSObject),');
    buf.writeln('  };');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('/// Wraps a JS object in the proxy matching its constructor');
    buf.writeln('/// name, or an opaque fallback proxy when unknown.');
    buf.writeln('BrowserObjectAdapter _wrapObject(JSObject object) {');
    buf.writeln('  final factory = _wrapFactories[_ctorName(object)];');
    buf.writeln('  return factory != null ? factory(object) : _UnknownObject(object);');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('String _ctorName(JSObject object) {');
    buf.writeln('  try {');
    buf.writeln("    final constructor = object.getProperty('constructor'.toJS);");
    buf.writeln('    if (constructor is JSObject) {');
    buf.writeln("      final name = constructor.getProperty('name'.toJS);");
    buf.writeln('      if (name is JSString) return name.toDart;');
    buf.writeln('    }');
    buf.writeln('  } on Object {');
    buf.writeln('    // Exotic prototypes wrap opaquely.');
    buf.writeln('  }');
    buf.writeln("  return '';");
    buf.writeln('}');
    buf.writeln();
  }

  /// Computes the `implements` list for the `Browser<Name>` wrapper:
  /// the direct interface plus the transitive `inherits` chain, dropping
  /// any ancestor whose declared members conflict with ones already covered
  /// (the flat neutral surface lets ancestors disagree — e.g.
  /// `SVGElement.className` returning `SVGAnimatedString` vs `Element.className`
  /// returning `String` — which no single class can satisfy).
  /// Mirrors the neutral surface's overload resolution: per interface,
  /// operations sharing a name collapse to the declaration with the most
  /// parameters (see `neutral_surface_emitter.dart`).
  /// Resolved instance contract of [ifaceName] exactly as the neutral
  /// surface emits it: flattened own + included mixin members, operations
  /// sharing a name collapsed to the max-parameter declaration
  /// (see `neutral_surface_emitter.dart`).
  Map<String, IdlMember> _resolvedMembers(String ifaceName) {
    final iface = model.interfaces[ifaceName];
    if (iface == null) return const {};
    final ops = <String, IdlOperation>{};
    final seenNames = <String>{};
    final out = <IdlMember>[];
    for (final m in flattenMembers(model, iface)) {
      if (m is IdlOperation) {
        final existing = ops[m.name];
        if (existing == null || m.parameters.length > existing.parameters.length) {
          ops[m.name] = m;
        }
        if (seenNames.add(m.name)) out.add(m);
      } else if (m is IdlAttribute) {
        if (seenNames.add(m.name)) out.add(m);
      }
    }
    return {
      for (final m in out) m.name: m is IdlOperation ? ops[m.name]! : m,
    };
  }

  List<String> _implementsNames(String name) {
    final out = <String>[name];
    final covered = _resolvedMembers(name);
    final seen = <String>{name};
    var current = model.interfaces[name]?.inheritance;
    while (current != null && seen.add(current)) {
      final parent = model.interfaces[current];
      if (parent == null || _reservedTypeNames.contains(current)) break;
      final resolved = _resolvedMembers(current);
      var conflicts = false;
      for (final m in resolved.values) {
        final prior = covered[m.name];
        if (prior != null && _memberSignature(prior) != _memberSignature(m)) {
          conflicts = true;
          break;
        }
      }
      if (conflicts) {
        current = parent.inheritance;
        continue;
      }
      out.add(current);
      covered.addAll(resolved);
      current = parent.inheritance;
    }
    return out;
  }

  /// Signature key for an IDL member, used to detect conflicting
  /// declarations of the same name across implemented interfaces.
  String _memberSignature(IdlMember m) {
    return switch (m) {
      IdlAttribute() => 'attr:${m.readonly}:${m.type}',
      IdlOperation() => 'op:${m.returnType}:${m.parameters.map((p) => '${p.name}:${p.type}').join(',')}',
      _ => 'other',
    };
  }

  void _emitKindTable(StringBuffer buf) {
    buf.writeln('/// Member kinds by `ClassName.member`, mirroring the neutral');
    buf.writeln('/// surface member types for [BrowserObjectAdapter] delegation.');
    buf.writeln('const Map<String, String> _kinds = {');
    final kinds = _kinds.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final e in kinds) {
      buf.writeln("  '${e.key}': '${e.value}',");
    }
    buf.writeln('};');
    buf.writeln();
    buf.writeln('/// JS property renames for IDL members whose escaped Dart name');
    buf.writeln('/// differs from the actual JS name.');
    buf.writeln('const Map<String, String> _jsNames = {');
    final jsNames = _jsNames.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final e in jsNames) {
      buf.writeln("  '${e.key}': '${e.value}',");
    }
    buf.writeln('};');
    buf.writeln();
  }

  void _emitWrappers(StringBuffer buf) {
    for (final name in _wrapperNames.toList()..sort()) {
      if (_reservedTypeNames.contains(name)) continue;
      final hasWeb = packageWebNames.contains(name);
      final implementsNames = _implementsNames(name);
      final ancestors = implementsNames.skip(1).toList();
      buf.writeln('final class Browser$name extends BrowserObjectAdapter');
      if (ancestors.isEmpty) {
        buf.writeln('    implements $name {');
      } else {
        buf.writeln(
          '    implements $name, ${ancestors.join(', ')} {',
        );
      }
      buf.writeln('  Browser$name(super.element);');
      buf.writeln();
      if (hasWeb) {
        buf.writeln('  web.$name get inner => _element as web.$name;');
        buf.writeln('}');
      } else {
        buf.writeln('}');
      }
      buf.writeln();
    }

    buf.writeln('final Map<String, BrowserObjectAdapter Function(JSObject)>');
    buf.writeln('    _wrapFactories = {');
    for (final name in _wrapperNames.toList()..sort()) {
      if (_reservedTypeNames.contains(name)) continue;
      buf.writeln("  '$name': (o) => Browser$name(o),");
    }
    buf.writeln('};');
    buf.writeln();

    buf.writeln('/// JS constructors for neutral constructible interfaces, keyed');
    buf.writeln('/// by interface name. Each entry invokes the global JS');
    buf.writeln('/// constructor with the IDL arguments converted to JS and');
    buf.writeln('/// returns the wrapped `Browser*` proxy.');
    buf.writeln('final Map<String, BrowserObjectAdapter Function(List<Object?>)>');
    buf.writeln('    _webConstructors = {');
    for (final name in _constructibleNames) {
      buf.writeln("  '$name': (arguments) => Browser$name((globalContext");
      buf.writeln("      .getProperty('$name'.toJS) as JSFunction)");
      buf.writeln('      .callAsConstructorVarArgs<JSObject>([');
      final ctors = model.interfaces[name]!.members.whereType<IdlConstructor>();
      final primary = ctors.first;
      for (var i = 0; i < primary.parameters.length; i++) {
        buf.writeln('        _toJs(arguments[$i]),');
      }
      buf.writeln('      ])),');
    }
    buf.writeln('};');
    buf.writeln();

    for (final def in reactEventDefs) {
      buf.writeln(
        'final class Browser${def.name}<T extends EventTarget>',
      );
      buf.writeln('    extends BrowserObjectAdapter');
      buf.writeln('    implements ${def.name}<T> {');
      buf.writeln('  Browser${def.name}(super.element);');
      buf.writeln();
      buf.writeln('  JSObject get inner => _element;');
      buf.writeln('}');
      buf.writeln();
    }
  }

  void _emitRuntime(StringBuffer buf) {
    buf.writeln('/// Browser [WebRuntime] backend backed by the `package:web`');
    buf.writeln('/// global objects (`window`, `document`, `navigator`).');
    buf.writeln('final class BrowserWebRuntime implements WebRuntime {');
    buf.writeln('  @override');
    buf.writeln('  Window get window => BrowserWindow(web.window);');
    buf.writeln('  @override');
    buf.writeln('  Document get document => BrowserDocument(web.document);');
    buf.writeln('  @override');
    buf.writeln('  Navigator get navigator =>');
    buf.writeln('      BrowserNavigator(web.window.navigator);');
    buf.writeln('  @override');
    buf.writeln(
      '  T createWebObject<T extends Object>(String name, List<Object?> arguments) {',
    );
    buf.writeln('    final ctor = _webConstructors[name];');
    buf.writeln('    if (ctor == null) {');
    buf.writeln("      throw UnsupportedWebApiError('\$name constructor');");
    buf.writeln('    }');
    buf.writeln('    return ctor(arguments) as T;');
    buf.writeln('  }');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('/// Installs the browser [WebRuntime]. Safe to call repeatedly.');
    buf.writeln('void installBrowserWebRuntime() =>');
    buf.writeln('    WebRuntime.install(BrowserWebRuntime());');
    buf.writeln();
  }

  void _emitRegistration(StringBuffer buf) {
    buf.writeln('/// Registers browser host-value codecs for elements and React');
    buf.writeln('/// synthetic events. Safe to call repeatedly.');
    buf.writeln('void registerBrowserAdapters() {');
    for (final name in _wrapperNames.toList()..sort()) {
      if (_reservedTypeNames.contains(name)) continue;
      if (!_isElementLike(name)) continue;
      buf.writeln('  ReactCodecRegistry.registerHostValue(');
      buf.writeln("    'web', '$name',");
      buf.writeln(
        '    decoder: (value) => Browser$name(value as JSObject),',
      );
      buf.writeln(
        '    encoder: (value) => (value as Browser$name)._element as JSAny?,',
      );
      buf.writeln('  );');
    }
    for (final def in reactEventDefs) {
      buf.writeln('  ReactCodecRegistry.registerHostValue(');
      buf.writeln("    'web', '${def.name}',");
      buf.writeln(
        '    decoder: (value) => Browser${def.name}(value as JSObject),',
      );
      buf.writeln('  );');
    }
    buf.writeln('}');
    buf.writeln();
  }
}
