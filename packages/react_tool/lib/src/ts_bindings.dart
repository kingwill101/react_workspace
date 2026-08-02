import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'ts_bindings.g.dart';

/// Thrown when TypeScript extraction or binding generation fails.
final class TsBindingException implements Exception {
  final String message;
  const TsBindingException(this.message);

  @override
  String toString() => 'TsBindingException: $message';
}

/// A serialized TypeScript type, as produced by the native extractor.
final class TsIrType {
  final String kind;

  /// Resolved declaration name when this type came from a named TS
  /// interface/alias (e.g. `FutureConfig`); null for anonymous objects.
  final String? name;
  final TsIrType? element;
  final List<TsIrProp>? members;
  final List<TsIrProp>? params;
  final TsIrType? returns;
  final List<String>? literals;

  /// Tuple member types (kind == "tuple").
  final List<TsIrType>? elements;

  const TsIrType({
    required this.kind,
    this.name,
    this.element,
    this.members,
    this.params,
    this.returns,
    this.literals,
    this.elements,
  });

  factory TsIrType.fromJson(Map<String, dynamic> json) => TsIrType(
    kind: json['kind'] as String,
    name: json['name'] as String?,
    element: json['element'] == null
        ? null
        : TsIrType.fromJson(json['element'] as Map<String, dynamic>),
    members: (json['members'] as List<dynamic>?)
        ?.map((m) => TsIrProp.fromJson(m as Map<String, dynamic>))
        .toList(),
    params: (json['params'] as List<dynamic>?)
        ?.map((m) => TsIrProp.fromJson(m as Map<String, dynamic>))
        .toList(),
    returns: json['returns'] == null
        ? null
        : TsIrType.fromJson(json['returns'] as Map<String, dynamic>),
    literals: (json['literals'] as List<dynamic>?)
        ?.map((l) => l as String)
        .toList(),
    elements: (json['elements'] as List<dynamic>?)
        ?.map((e) => TsIrType.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A single property of an interface, alias, or component props type.
final class TsIrProp {
  final String name;
  final bool required;
  final TsIrType type;

  const TsIrProp({required this.name, required this.required, required this.type});

  factory TsIrProp.fromJson(Map<String, dynamic> json) => TsIrProp(
    name: json['name'] as String,
    required: json['required'] as bool,
    type: TsIrType.fromJson(json['ty'] as Map<String, dynamic>),
  );
}

/// One requested exported declaration.
final class TsIrDeclaration {
  final String name;
  final String kind; // "component" | "interface" | "alias" | "hook"
  final List<TsIrProp> props;

  /// Hook formal parameters (kind == "hook").
  final List<TsIrProp> params;

  /// Hook return type (kind == "hook").
  final TsIrType? returns;

  const TsIrDeclaration({
    required this.name,
    required this.kind,
    required this.props,
    this.params = const [],
    this.returns,
  });

  factory TsIrDeclaration.fromJson(Map<String, dynamic> json) =>
      TsIrDeclaration(
        name: json['name'] as String,
        kind: json['kind'] as String,
        props: (json['props'] as List<dynamic>)
            .map((p) => TsIrProp.fromJson(p as Map<String, dynamic>))
            .toList(),
        params: (json['params'] as List<dynamic>?)
            ?.map((p) => TsIrProp.fromJson(p as Map<String, dynamic>))
            .toList() ??
            const [],
        returns: json['returns'] == null
            ? null
            : TsIrType.fromJson(json['returns'] as Map<String, dynamic>),
      );
}

/// The result of a successful extraction run.
final class TsBindingsResult {
  final String entry;
  final int files;
  final List<TsIrDeclaration> declarations;

  const TsBindingsResult({
    required this.entry,
    required this.files,
    required this.declarations,
  });

  factory TsBindingsResult.fromJson(Map<String, dynamic> json) =>
      TsBindingsResult(
        entry: json['entry'] as String,
        files: json['files'] as int,
        declarations: (json['declarations'] as List<dynamic>)
            .map((d) => TsIrDeclaration.fromJson(d as Map<String, dynamic>))
            .toList(),
      );
}

/// Runs the native oxc extractor over the managed npm environment.
final class TsBindingExtractor {
  final String npmRoot;

  const TsBindingExtractor(this.npmRoot);

  /// Extracts [names] exported by [specifier] and returns the parsed IR.
  Future<TsBindingsResult> extract({
    required String specifier,
    required List<String> names,
  }) async {
    final request = jsonEncode({'specifier': specifier, 'names': names});
    final requestC = request.toNativeUtf8();
    final rootC = npmRoot.toNativeUtf8();
    try {
      final ptr = tsb_extract(requestC.cast(), rootC.cast());
      if (ptr == nullptr) {
        throw const TsBindingException('native extractor returned null.');
      }
      try {
        final text = ptr.cast<Utf8>().toDartString();
        final decoded = jsonDecode(text) as Map<String, dynamic>;
        final error = decoded['error'];
        if (error != null) {
          throw TsBindingException(error as String);
        }
        return TsBindingsResult.fromJson(
          decoded['ok'] as Map<String, dynamic>,
        );
      } finally {
        tsb_free_string(ptr);
      }
    } finally {
      malloc.free(requestC);
      malloc.free(rootC);
    }
  }
}

// ---------------------------------------------------------------------------
// Dart code generation
// ---------------------------------------------------------------------------

const _kReservedWords = {
  'assert', 'break', 'case', 'catch', 'class', 'const', 'continue', 'default',
  'do', 'else', 'enum', 'extends', 'false', 'final', 'finally', 'for', 'if',
  'in', 'is', 'new', 'null', 'rethrow', 'return', 'super', 'switch', 'this',
  'throw', 'true', 'try', 'var', 'void', 'while', 'with', 'yield',
};

/// Camel-cases a declaration name: `MemoryRouter` → `memoryRouter`.
String lowerCamel(String name) {
  final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9]'), ' ');
  final words = cleaned
      .split(' ')
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'x';
  final buffer = StringBuffer(words.first[0].toLowerCase());
  buffer.write(words.first.substring(1));
  for (final word in words.skip(1)) {
    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }
  return buffer.toString();
}

/// Pascal-cases a name: `react-router-dom` → `ReactRouterDom`.
String upperCamel(String name) {
  final camel = lowerCamel(name);
  if (camel.isEmpty) return 'X';
  return camel[0].toUpperCase() + camel.substring(1);
}

/// Registry of named Dart types (classes, enums, callback typedefs) that the
/// generator discovers while walking the IR. Deduplicated so identical types
/// emit once, deterministically.
final class _TypeRegistry {
  final String typePrefix;

  /// Top-level type names that live in a sibling generated file the hooks
  /// file imports (e.g. the bindings file's `RelativeRoutingType`); the
  /// hooks generator references them instead of redeclaring them.
  final Set<String> reusedTypeNames;

  final Map<String, String> _nameByKey = {};
  final Map<String, _ClassDef> classes = {};
  final Map<String, _EnumDef> enums = {};
  final Map<String, _TypedefDef> typedefs = {};

  _TypeRegistry({this.typePrefix = '', Set<String>? reusedTypeNames})
      : reusedTypeNames = reusedTypeNames ?? <String>{};

  /// Prefix applied to every generated type name, used to namespace the
  /// types of a second extraction run (e.g. `--type-prefix Server` keeps the
  /// server subpath bindings' `FutureConfig` distinct from the main file's).
  String _typed(String name) => '$typePrefix$name';

  /// Resolves the Dart class name for an object type, registering it (and
  /// walking its members) if unseen. [declName] + [path] synthesize names for
  /// anonymous objects.
  String objectName(TsIrType type, String declName, List<String> path) {
    final key = type.name != null ? 'named:${type.name}' : 'anon:${_signature(type)}';
    final existing = _nameByKey[key];
    if (existing != null) return existing;

    final name = type.name != null
        ? _typed(_uniqueName(upperCamel(type.name!)))
        : _typed(_uniqueName('${upperCamel(declName)}${path.map(upperCamel).join()}'));
    if (reusedTypeNames.contains(name)) return name;
    _nameByKey[key] = name;
    final def = _ClassDef(name, type);
    classes[name] = def;
    return name;
  }

  String enumName(TsIrType type, String declName, List<String> path) {
    final key = 'literal:${_uniqueLiterals(type.literals ?? const []).join('|')}';
    final existing = _nameByKey[key];
    if (existing != null) return existing;
    final name = type.name != null
        ? _typed(_uniqueName(upperCamel(type.name!)))
        : _typed(
            _uniqueName('${upperCamel(declName)}${path.map(upperCamel).join()}'),
          );
    if (reusedTypeNames.contains(name)) return name;
    _nameByKey[key] = name;
    enums[name] = _EnumDef(name, type.literals ?? const []);
    return name;
  }

  String typedefName(TsIrType type, String declName, List<String> path) {
    final key = 'function:${_signature(type)}';
    final existing = _nameByKey[key];
    if (existing != null) return existing;
    final name = _typed(
      _uniqueName('${upperCamel(declName)}${path.map(upperCamel).join()}Callback'),
    );
    _nameByKey[key] = name;
    typedefs[name] = _TypedefDef(name, type);
    return name;
  }

  /// Registers a class for an interface/alias declaration so component props
  /// that reference the same named type share it.
  String declarationClass(String declName, List<TsIrProp> props) {
    final key = 'named:$declName';
    final existing = _nameByKey[key];
    if (existing != null) return existing;
    final name = _typed(_uniqueName(upperCamel(declName)));
    _nameByKey[key] = name;
    final def = _ClassDef(name, TsIrType(kind: 'object', name: declName, members: props));
    classes[name] = def;
    return name;
  }

  /// Registers a plain typedef for a prim/array alias (`type ID = string`).
  String declarationTypedef(String declName, TsIrProp valueProp) {
    final key = 'alias:$declName';
    final existing = _nameByKey[key];
    if (existing != null) return existing;
    final name = _typed(_uniqueName(upperCamel(declName)));
    _nameByKey[key] = name;
    typedefs[name] = _TypedefDef(name, valueProp.type, isPlainAlias: true);
    return name;
  }

  String _uniqueName(String base) {
    var candidate = base;
    var i = 2;
    while (_nameByKey.containsValue(candidate)) {
      candidate = '$base$i';
      i++;
    }
    return candidate;
  }

  List<String> sortedClassNames() => classes.keys.toList()..sort();
  List<String> sortedEnumNames() => enums.keys.toList()..sort();
  List<String> sortedTypedefNames() => typedefs.keys.toList()..sort();
}

String _signature(TsIrType type) {
  final buffer = StringBuffer(type.kind);
  if (type.name != null) buffer.write('@${type.name}');
  if (type.element != null) buffer.write('<${_signature(type.element!)}>');
  if (type.members != null) {
    buffer.write('{');
    for (final m in type.members!) {
      buffer.write('${m.name}${m.required ? '' : '?'}:${_signature(m.type)};');
    }
    buffer.write('}');
  }
  if (type.params != null) {
    buffer.write('(');
    for (final p in type.params!) {
      buffer.write('${p.name}:${_signature(p.type)};');
    }
    buffer.write(')');
  }
  if (type.returns != null) buffer.write('->${_signature(type.returns!)}');
  if (type.literals != null) {
    final lits = [...type.literals!]..sort();
    buffer.write(lits.join('|'));
  }
  return buffer.toString();
}

final class _ClassDef {
  final String name;
  final TsIrType type;
  const _ClassDef(this.name, this.type);
}

final class _EnumDef {
  final String name;
  final List<String> literals;
  const _EnumDef(this.name, this.literals);
}

final class _TypedefDef {
  final String name;
  final TsIrType type;

  /// A plain value alias (`typedef X = String;`) vs a callback typedef with a
  /// [ReactCallback] factory.
  final bool isPlainAlias;
  const _TypedefDef(this.name, this.type, {this.isPlainAlias = false});
}

/// Maps an IR type to a Dart type name (nullability applied by the caller).
String _dartType(TsIrType type, _TypeRegistry registry, {int depth = 0}) {
  switch (type.kind) {
    case 'string':
      return 'String';
    case 'number':
      return 'num';
    case 'boolean':
      return 'bool';
    case 'reactNode':
      return 'ReactNode';
    case 'hostValue':
    case 'any':
    case 'unknown':
    case 'void':
    case 'null':
    case 'union':
      return 'Object';
    case 'function':
      return _typedefNameFor(type, registry);
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) return 'Object';
      return _objectNameFor(type, registry);
    case 'array':
      if (depth >= 3) return 'List<Object?>';
      final inner = _dartType(
        type.element ?? const TsIrType(kind: 'any'),
        registry,
        depth: depth + 1,
      );
      if (inner == 'Object?' || inner == 'Object') return 'List<Object?>';
      return 'List<$inner>';
    case 'literal':
      final literals = _uniqueLiterals(type.literals ?? const []);
      if (_isBoolUnion(literals)) return 'bool';
      if (literals.length >= 2) return _enumNameFor(type, registry);
      return _literalDartType(literals);
    default:
      return 'Object?';
  }
}

/// Looks up (or registers on demand) the Dart name for a referenced type.
/// On-demand registration uses a synthetic declaration/path context; the
/// registry key ensures dedup against the real registration.
String _objectNameFor(TsIrType type, _TypeRegistry registry) {
  final key = type.name != null ? 'named:${type.name}' : 'anon:${_signature(type)}';
  final existing = registry._nameByKey[key];
  if (existing != null) return existing;
  // Referenced before the walk saw it (should not happen): register with a
  // synthetic name derived from the type name or its signature hash.
  final name = type.name != null
      ? registry._uniqueName(upperCamel(type.name!))
      : registry._uniqueName('Anon${type.kind}${_signature(type).hashCode.abs()}');
  if (registry.reusedTypeNames.contains(name)) return name;
  registry._nameByKey[key] = name;
  registry.classes[name] = _ClassDef(name, type);
  return name;
}

String _enumNameFor(TsIrType type, _TypeRegistry registry) {
  final key = 'literal:${_uniqueLiterals(type.literals ?? const []).join('|')}';
  final existing = registry._nameByKey[key];
  if (existing != null) return existing;
  final name = type.name != null
      ? registry._uniqueName(upperCamel(type.name!))
      : registry._uniqueName('Literal${type.kind}${_signature(type).hashCode.abs()}');
  if (registry.reusedTypeNames.contains(name)) return name;
  registry._nameByKey[key] = name;
  registry.enums[name] = _EnumDef(name, type.literals ?? const []);
  return name;
}

String _typedefNameFor(TsIrType type, _TypeRegistry registry) {
  final key = 'function:${_signature(type)}';
  final existing = registry._nameByKey[key];
  if (existing != null) return existing;
  final name = registry._uniqueName('Callback${_signature(type).hashCode.abs()}');
  if (registry.reusedTypeNames.contains(name)) return name;
  registry._nameByKey[key] = name;
  registry.typedefs[name] = _TypedefDef(name, type);
  return name;
}

/// Deduplicates serialized literals (`"a" | "a" | "b"` collapses to
/// `"a" | "b"`).
List<String> _uniqueLiterals(List<String> literals) =>
    <String>{...literals}.toList();

/// Whether every literal is `true`/`false` — such unions are plain booleans
/// at runtime, so they map to `bool` instead of a string-valued enum.
bool _isBoolUnion(List<String> literals) =>
    literals.isNotEmpty && literals.every((l) => l == 'true' || l == 'false');

String _literalDartType(List<String> literals) {
  if (literals.isEmpty) return 'Object';
  var allString = true;
  var allNum = true;
  var allBool = true;
  for (final literal in literals) {
    final value = _literalValue(literal);
    if (value is String) {
      allNum = false;
      allBool = false;
    } else if (value is num) {
      allString = false;
      allBool = false;
    } else if (value is bool) {
      allString = false;
      allNum = false;
    } else {
      return 'Object';
    }
  }
  if (allString) return 'String';
  if (allNum) return 'num';
  if (allBool) return 'bool';
  return 'Object';
}

/// Parses a serialized TS literal (`"foo"`, `3`, `true`) to a Dart value.
Object? _literalValue(String literal) {
  if (literal.length >= 2 &&
      literal.startsWith('"') &&
      literal.endsWith('"')) {
    return literal.substring(1, literal.length - 1);
  }
  if (literal == 'true') return true;
  if (literal == 'false') return false;
  final num = int.tryParse(literal) ?? double.tryParse(literal);
  return num;
}

/// Generates a Dart source file with typed foreign-component helpers.
String generateBindings({
  required String specifier,
  required List<TsIrDeclaration> declarations,
  required String commandLine,
  String? prefix,
  String? entryComment,
  String typePrefix = '',
}) {
  final resolvedPrefix = prefix ?? lowerCamel(specifier);
  final registry = _TypeRegistry(typePrefix: typePrefix);

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE — DO NOT EDIT.')
    ..writeln('// Generated by: $commandLine')
    ..writeln('// Source: $specifier')
    ..writeln('// (extracted from ${entryComment ?? 'the package types entry'})')
    ..writeln('// ignore_for_file: type=lint')
    ..writeln()
    ..writeln("import 'package:react/react.dart';")
    ..writeln();

  // First pass: emit helpers and register all referenced types.
  final helperText = StringBuffer();
  for (final declaration in declarations) {
    _emitDeclaration(helperText, declaration, resolvedPrefix, registry);
    helperText.writeln();
  }
  buffer.write(helperText);

  // Second pass: typedefs, enums, classes (sorted for determinism).
  for (final name in registry.sortedTypedefNames()) {
    buffer.write(_emitTypedef(registry.typedefs[name]!));
    buffer.writeln();
  }
  for (final name in registry.sortedEnumNames()) {
    buffer.write(_emitEnum(registry.enums[name]!));
    buffer.writeln();
  }
  for (final name in registry.sortedClassNames()) {
    buffer.write(_emitClass(registry.classes[name]!, registry));
    buffer.writeln();
  }
  return buffer.toString();
}

void _emitDeclaration(
  StringBuffer buffer,
  TsIrDeclaration declaration,
  String prefix,
  _TypeRegistry registry,
) {
  final foreignName = '$prefix.${declaration.name}';
  // Dart helpers keep the bare component name (lowerCamel); the prefix only
  // namespaces the JS registration key used by the shim, so generated APIs
  // read like `outlet()` / `memoryRouter(...)` instead of `xOutlet()`.
  final functionName = lowerCamel(declaration.name);
  final props = declaration.props;

  // A `children` prop becomes the node children parameter, except when it
  // is exclusively a function (a render-prop). ReactNode, `any`, unions of
  // node types, etc. all funnel into the typed children list.
  final hasChildren = props.any(
    (p) => p.name == 'children' && p.type.kind != 'function',
  );
  final propParams = props.where((p) => !(hasChildren && p.name == 'children'));

  // Register nested types before emitting so type names resolve.
  for (final prop in propParams) {
    _collectTypes(prop.type, declaration.name, [prop.name], registry);
  }

  switch (declaration.kind) {
    case 'hook':
      // Hooks live in the separate hooks file (generateHooks); nothing is
      // emitted into the component bindings.
      return;
    case 'component':
      final childrenRequired = hasChildren &&
          props.firstWhere((p) => p.name == 'children').required;
      buffer
        ..writeln('/// Typed helper for the `$foreignName` foreign component.')
        ..writeln('///')
        ..writeln('/// Props from `${declaration.name}`:')
        ..writeln('///')
        ..writeln('/// ${_propsDoc(props)}')
        ..writeln('ReactNode $functionName({')
        ..writeln('  String? key,');
      if (hasChildren) {
        buffer.writeln(
          childrenRequired
              ? '  required List<ReactNode> children,'
              : '  List<ReactNode> children = const [],',
        );
      }
      for (final prop in propParams) {
        _emitParam(buffer, prop, declaration.name, registry);
      }
      buffer
        ..writeln('}) => foreignComponent(')
        ..writeln("  '$foreignName',")
        ..writeln('  key: key,')
        ..writeln('  props: {');
      for (final prop in propParams) {
        buffer.writeln('    ${_propsMapEntry(prop)}');
      }
      buffer.writeln('  },');
      if (hasChildren) {
        buffer.writeln('  children: children,');
      }
      buffer.writeln(');');
    case 'interface':
      // Registers the class; the second pass emits all classes once.
      registry.declarationClass(declaration.name, declaration.props);
    case 'alias':
      if (props.length == 1 && props.single.name == 'value') {
        // `type X = string` style alias → plain Dart typedef.
        final typedefName = registry.declarationTypedef(
          declaration.name,
          props.single,
        );
        // Register types referenced by the alias target (e.g. arrays).
        _collectTypes(
          props.single.type,
          declaration.name,
          const ['value'],
          registry,
        );
        buffer
          ..writeln('/// Typed alias for `${declaration.name}`.')
          ..writeln('///')
          ..writeln('/// ${_tsTypeDoc(props.single.type)}')
          ..writeln('typedef $typedefName = ${_typedefTargetType(props.single.type, registry)};');
      } else {
        registry.declarationClass(declaration.name, declaration.props);
      }
  }
}

/// Walks a type tree registering classes/enums/typedefs. Callback params and
/// returns are NOT walked: their object values arrive as raw host values.
void _collectTypes(
  TsIrType type,
  String declName,
  List<String> path,
  _TypeRegistry registry,
) {
  switch (type.kind) {
    case 'object':
      // Call-signature / opaque interfaces have no members; they behave as
      // opaque values (e.g. LazyRouteFunction) rather than props classes.
      if ((type.members ?? const <TsIrProp>[]).isEmpty) break;
      registry.objectName(type, declName, path);
      for (final member in type.members ?? const <TsIrProp>[]) {
        _collectTypes(member.type, declName, [...path, member.name], registry);
      }
    case 'function':
      registry.typedefName(type, declName, path);
    case 'array':
      _collectTypes(
        type.element ?? const TsIrType(kind: 'any'),
        declName,
        path,
        registry,
      );
    case 'literal':
      if (_isBoolUnion(_uniqueLiterals(type.literals ?? const []))) break;
      if ((type.literals ?? const []).length >= 2) {
        registry.enumName(type, declName, path);
      }
    default:
      break;
  }
}

void _emitParam(
  StringBuffer buffer,
  TsIrProp prop,
  String declName,
  _TypeRegistry registry,
) {
  final dartName = _safeParamName(prop.name);
  final type = _dartType(prop.type, registry);
  final nullable = prop.required ? '' : '?';
  final requiredPrefix = prop.required ? 'required ' : '';
  if (prop.type.kind == 'function') {
    buffer
      ..writeln('    /// TS: ${_functionDoc(prop.type)}')
      ..writeln('    $requiredPrefix$type$nullable $dartName,');
  } else {
    buffer.writeln('    $requiredPrefix$type$nullable $dartName,');
  }
}

String _propsMapEntry(TsIrProp prop) {
  final name = _safeParamName(prop.name);
  final value = _jsonExpr(name, prop.type);
  return prop.required ? "'${prop.name}': $value," : "if ($name != null) '${prop.name}': $value,";
}

/// The expression that encodes [source] (a Dart variable or member) into a
/// JSON-safe value for the props map / toJson.
String _jsonExpr(String source, TsIrType type) {
  switch (type.kind) {
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) return source;
      return '$source.toJson()';
    case 'array':
      final element = type.element;
      if (element == null) return source;
      if (element.kind == 'object') {
        return '$source.map((e) => e.toJson()).toList()';
      }
      if (element.kind == 'literal' &&
          _isBoolUnion(_uniqueLiterals(element.literals ?? const []))) {
        return source;
      }
      if (element.kind == 'literal' && (element.literals ?? const []).length >= 2) {
        return '$source.map((e) => e.value).toList()';
      }
      return source;
    case 'literal': {
      final literals = _uniqueLiterals(type.literals ?? const []);
      if (_isBoolUnion(literals)) return source;
      if (literals.length >= 2) return '$source.value';
      return source;
    }
    default:
      return source;
  }
}

/// Like [_jsonExpr] but promotes the receiver for method calls, for use on
/// non-promotable public fields inside `if (x != null)` collection entries.
String _jsonExprPromoted(String source, TsIrType type) {
  switch (type.kind) {
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) return source;
      return '$source!.toJson()';
    case 'array':
      final element = type.element;
      if (element == null) return source;
      if (element.kind == 'object') {
        return '$source!.map((e) => e.toJson()).toList()';
      }
      if (element.kind == 'literal' &&
          _isBoolUnion(_uniqueLiterals(element.literals ?? const []))) {
        return source;
      }
      if (element.kind == 'literal' && (element.literals ?? const []).length >= 2) {
        return '$source!.map((e) => e.value).toList()';
      }
      return source;
    case 'literal': {
      final literals = _uniqueLiterals(type.literals ?? const []);
      if (_isBoolUnion(literals)) return source;
      if (literals.length >= 2) return '$source!.value';
      return source;
    }
    default:
      return source;
  }
}

String _safeParamName(String name) {
  if (_kReservedWords.contains(name)) return '${name}_';
  if (name == 'key') return 'elementKey';
  return name;
}

String _propsDoc(List<TsIrProp> props) {
  if (props.isEmpty) return 'No props.';
  final parts = props.map((p) {
    final tsType = _tsTypeDoc(p.type);
    return '${p.name}${p.required ? '' : '?'}: $tsType';
  });
  final lines = <String>[];
  var line = '';
  for (final part in parts) {
    if (line.isNotEmpty && line.length + part.length + 2 > 76) {
      lines.add(line);
      line = part;
    } else {
      line = line.isEmpty ? part : '$line; $part';
    }
  }
  if (line.isNotEmpty) lines.add(line);
  return lines.join('\n/// ');
}

String _tsTypeDoc(TsIrType type) {
  switch (type.kind) {
    case 'string':
      return 'string';
    case 'number':
      return 'number';
    case 'boolean':
      return 'boolean';
    case 'reactNode':
      return 'React.ReactNode';
    case 'hostValue':
      return 'host value';
    case 'any':
      return 'any';
    case 'void':
      return 'void';
    case 'unknown':
      return 'unknown';
    case 'null':
      return 'null';
    case 'array':
      return '${_tsTypeDoc(type.element ?? const TsIrType(kind: 'any'))}[]';
    case 'object':
      final members = type.members ?? const <TsIrProp>[];
      if (members.isEmpty) return 'Record<string, unknown>';
      final parts = members
          .map((p) => '${p.name}${p.required ? '' : '?'}: ${_tsTypeDoc(p.type)}')
          .join('; ');
      return '{ $parts }';
    case 'function':
      return _functionDoc(type);
    case 'literal':
      return (type.literals ?? const []).join(' | ');
    case 'union':
      return 'union';
    default:
      return 'unknown';
  }
}

String _functionDoc(TsIrType type) {
  final params = (type.params ?? const <TsIrProp>[])
      .map((p) => '${p.name}: ${_tsTypeDoc(p.type)}')
      .join(', ');
  final returns = type.returns == null
      ? 'void'
      : _tsTypeDoc(type.returns!);
  return '($params) => $returns';
}

// ---------------------------------------------------------------------------
// Typedef / enum / class emission
// ---------------------------------------------------------------------------

String _emitTypedef(_TypedefDef def) {
  if (def.isPlainAlias) {
    final target = _typedefTargetType(def.type, _emptyRegistryFor(def));
    return '/// Typed alias.\n'
        'typedef ${def.name} = $target;\n';
  }
  final type = def.type;
  final params = type.params ?? const <TsIrProp>[];
  final paramSpecs = <String>[];
  final paramCasts = <String>[];
  for (var i = 0; i < params.length; i++) {
    final p = params[i];
    paramSpecs.add(_callbackSpec(p.type));
    paramCasts.add(_callbackArg(p.name, p.type, i));
  }
  final returns = type.returns;
  final resultSpec = returns == null || returns.kind == 'void' ? 'reactVoid' : 'reactAny';
  final factoryName = lowerCamel(def.name);

  final buffer = StringBuffer()
    ..writeln('/// TS: ${_functionDoc(type)}')
    ..writeln(
      'typedef ${def.name} = ${_callbackReturnType(returns)} Function('
      '${params.map((p) => '${_callbackParamType(p.type)} ${_safeParamName(p.name)}').join(', ')});',
    )
    ..writeln()
    ..writeln('/// Wraps a [${def.name}] into a [ReactCallback] for prop encoding.')
    ..writeln('ReactCallback $factoryName(${def.name} fn) => ReactCallback(')
    ..writeln("  debugName: '${def.name}',")
    ..writeln('  signature: const (')
    ..writeln('    positional: [${paramSpecs.join(', ')}],')
    ..writeln('    result: $resultSpec,')
    ..writeln('    asynchronous: false,')
    ..writeln('  ),')
    ..writeln('  invoke: (arguments) {');
  if (returns == null || returns.kind == 'void') {
    buffer
      ..writeln('    fn(${paramCasts.join(', ')});')
      ..writeln('    return null;');
  } else {
    buffer.writeln('    return fn(${paramCasts.join(', ')});');
  }
  buffer
    ..writeln('  },')
    ..writeln(');');
  return buffer.toString();
}

/// Registry used to resolve names in a plain-alias typedef without mutating
/// the main registry (the alias target was already collected).
_TypeRegistry _emptyRegistryFor(_TypedefDef def) => _TypeRegistry();

String _typedefTargetType(TsIrType type, _TypeRegistry registry) {
  final base = _dartType(type, registry);
  if (base == 'Object?' && type.kind != 'array') return 'Object';
  return base;
}

String _callbackParamType(TsIrType type) {
  switch (type.kind) {
    case 'string':
      return 'String';
    case 'number':
      return 'num';
    case 'boolean':
      return 'bool';
    default:
      return 'Object?';
  }
}

String _callbackReturnType(TsIrType? returns) {
  if (returns == null || returns.kind == 'void') return 'void';
  switch (returns.kind) {
    case 'string':
      return 'String';
    case 'number':
      return 'num';
    case 'boolean':
      return 'bool';
    case 'reactNode':
      return 'ReactNode';
    default:
      return 'Object?';
  }
}

String _callbackSpec(TsIrType type) {
  switch (type.kind) {
    case 'string':
      return 'reactString';
    case 'number':
    case 'boolean':
    case 'literal':
      return 'reactAny';
    default:
      return 'reactAny';
  }
}

String _callbackArg(String name, TsIrType type, int index) {
  final arg = 'arguments[$index]';
  switch (type.kind) {
    case 'string':
      return '$arg as String';
    case 'number':
      return '$arg as num';
    case 'boolean':
      return '$arg as bool';
    default:
      return arg;
  }
}

String _emitEnum(_EnumDef def) {
  final members = <String>[];
  final used = <String>{};
  for (final literal in _uniqueLiterals(def.literals)) {
    var memberName = _enumConstantName(_literalValue(literal));
    if (memberName.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(memberName)) {
      memberName = 'v$memberName';
    }
    if (memberName.isEmpty || memberName == 'v') {
      memberName = 'v${used.length}';
    }
    var candidate = memberName;
    var i = 2;
    while (used.contains(candidate)) {
      candidate = '$memberName$i';
      i++;
    }
    used.add(candidate);
    // Decode the serialized literal ("route" → route) so `.value` carries
    // the actual value the JS side expects.
    members.add("$candidate('${_literalValue(literal)}')");
  }
  final buffer = StringBuffer()
    ..writeln('/// Literal union: ${def.literals.join(' | ')}')
    ..writeln('enum ${def.name} {')
    ..writeln('  ${members.join(',\n  ')};')
    ..writeln('  const ${def.name}(this.value);')
    ..writeln('  final String value;')
    ..writeln()
    ..writeln('  /// Decodes a JS string value into this enum.')
    ..writeln('  static ${def.name} fromValue(String value) => values.firstWhere(')
    ..writeln('    (e) => e.value == value,')
    ..writeln("    orElse: () => throw ArgumentError.value(value, 'value', 'Unknown ${def.name}'),")
    ..writeln('  );')
    ..writeln('}');
  return buffer.toString();
}

/// Dart constant name for an enum value. All-uppercase values ("POP", "PUSH")
/// become lowercase (pop, push) instead of lowerCamel's awkward "pOP".
String _enumConstantName(Object? value) {
  final s = value.toString();
  if (s.isNotEmpty && s == s.toUpperCase() && s != s.toLowerCase()) {
    return s.toLowerCase();
  }
  return lowerCamel(s);
}

String _emitClass(_ClassDef def, _TypeRegistry registry) {
  final props = def.type.members ?? const <TsIrProp>[];
  final buffer = StringBuffer()
    ..writeln('/// Typed props for `${def.type.name ?? def.name}`.')
    ..writeln('///')
    ..writeln('/// ${_propsDoc(props)}')
    ..writeln('class ${def.name} {')
    ..writeln('  const ${def.name}({');
  for (final prop in props) {
    final name = _safeParamName(prop.name);
    buffer.writeln(
      '    ${prop.required ? 'required ' : ''}${_dartType(prop.type, registry)}${prop.required ? '' : '?'} this.$name,',
    );
  }
  if (props.isEmpty) {
    buffer.writeln('  });'.replaceFirst('({', ''));
  } else {
    buffer.writeln('  });');
  }
  for (final prop in props) {
    final name = _safeParamName(prop.name);
    buffer
      ..writeln()
      ..writeln('  /// TS: ${_tsTypeDoc(prop.type)}')
      ..writeln('  final ${_dartType(prop.type, registry)}${prop.required ? '' : '?'} $name;');
  }
  buffer
    ..writeln()
    ..writeln('  /// JSON-safe map for prop encoding through the JS bridge.')
    ..writeln('  Map<String, Object?> toJson() => {');
  for (final prop in props) {
    final name = _safeParamName(prop.name);
    // Public fields don't promote after a null check, so method calls in
    // optional entries promote the receiver with `!`.
    final value = prop.required
        ? _jsonExpr(name, prop.type)
        : _jsonExprPromoted(name, prop.type);
    buffer.writeln(
      '    ${prop.required ? "'${prop.name}': $value" : "if ($name != null) '${prop.name}': $value"},',
    );
  }
  buffer
    ..writeln('  };')
    ..writeln('}');
  return buffer.toString();
}

// ---------------------------------------------------------------------------
// Hook binding generation
//
// `use*` declarations carry per-hook params + a return type. Hooks run inside
// React's render call stack, so each generated Dart hook calls a bridge
// member on `globalThis.__reactDartHooks` or `globalThis.__reactDartBindings[namespace]` (registered by the generated shim)
// and decodes the shim's primitives/arrays into typed Dart values:
//
//   - primitives → direct casts (the external's return type is already JSX)
//   - literal unions → enums with `fromValue`
//   - records / URLSearchParams → `Map<String, String>` pairs
//   - tuples → Dart records (useSearchParams → (pairs, setter))
//   - objects → generated extension types + value classes with `fromJs(JSObject)` factories
//   - functions → closures over a JSFunction captured *during render*, so
//     navigating later from an event handler never calls the hook again
// ---------------------------------------------------------------------------

/// Generates a Dart hooks file for the extracted `use*` hooks.
///
/// [reuseTypeNames] lists top-level type names that live in a sibling
/// generated file ([bindingsImport], a Dart `import` path) the hooks file
/// references instead of redeclaring (e.g. the bindings file's enums).
String generateHooks({
  required String specifier,
  required List<TsIrDeclaration> declarations,
  required String commandLine,
  String? entryComment,
  String typePrefix = '',
  String? bindingsImport,
  Set<String>? reuseTypeNames,
  String namespace = '',
}) {
  final hooks = declarations.where((d) => d.kind == 'hook').toList();
  final registry = _TypeRegistry(
    typePrefix: typePrefix,
    reusedTypeNames: reuseTypeNames,
  );

  // First pass: register every value type referenced by return values.
  // Param types are inputs (encoded with jsify), so only their literals are
  // registered on demand while emitting the signatures.
  for (final hook in hooks) {
    final declBase = hook.name.startsWith('use')
        ? hook.name.substring(3)
        : hook.name;
    if (hook.returns != null) {
      _collectHookTypes(hook.returns!, declBase, const ['return'], registry);
    }
  }

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE — DO NOT EDIT.')
    ..writeln('// Generated by: $commandLine')
    ..writeln('// Source: $specifier')
    ..writeln('// (extracted from ${entryComment ?? 'the package types entry'})')
    ..writeln('// ignore_for_file: type=lint')
    ..writeln()
    ..writeln("import 'dart:js_interop';");
  if (bindingsImport != null) {
    buffer.writeln("import '$bindingsImport';");
  }
  buffer
    ..writeln()
    ..writeln('// Hook bindings for `$specifier`. Each hook is only available')
    ..writeln('// in JavaScript targets (browser client and Node SSR worker);')
    ..writeln('// it calls into the shim bridge (`$bridgeTarget`)')
    ..writeln('// and runs inside React\'s render call stack.')
    ..writeln();

  buffer.write(_hookHelpers());

  for (final hook in hooks) {
    buffer.write(_emitHook(hook, registry));
    buffer.writeln();
  }

  for (final name in registry.sortedClassNames()) {
    buffer.write(_emitHookClass(registry.classes[name]!, registry));
    buffer.writeln();
  }
  for (final name in registry.sortedEnumNames()) {
    buffer.write(_emitEnum(registry.enums[name]!));
    buffer.writeln();
  }
  return buffer.toString();
}

String _hookHelpers() {
  return '''// Shared decode helpers for hook return values.
// Primitives and literals are decoded directly by the external's
// return type; objects with known shape use generated extension
// types (see below) for direct property access instead of
// converting to/from [[key, value]] pairs.
List<T> _decodeList<T>(JSArray raw, T Function(JSAny? item) decode) {
  final result = <T>[];
  for (var i = 0; i < raw.length; i++) {
    result.add(decode(raw[i]));
  }
  return result;
}
''';
}

/// Registers value types (classes/enums) referenced by hook params/returns.
/// Function types are skipped: their options objects become Dart named
/// parameters, not classes.
void _collectHookTypes(
  TsIrType type,
  String declName,
  List<String> path,
  _TypeRegistry registry,
) {
  switch (type.kind) {
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) break;
      registry.objectName(type, declName, path);
      for (final member in type.members ?? const <TsIrProp>[]) {
        _collectHookTypes(
          member.type,
          declName,
          [...path, member.name],
          registry,
        );
      }
    case 'literal':
      if (_isBoolUnion(_uniqueLiterals(type.literals ?? const []))) break;
      if ((type.literals ?? const []).length >= 2) {
        registry.enumName(type, declName, path);
      }
    case 'array':
      _collectHookTypes(
        type.element ?? const TsIrType(kind: 'any'),
        declName,
        [...path, 'element'],
        registry,
      );
    case 'record':
      _collectHookTypes(
        type.element ?? const TsIrType(kind: 'any'),
        declName,
        [...path, 'value'],
        registry,
      );
    case 'tuple':
      final elements = type.elements ?? const <TsIrType>[];
      for (var i = 0; i < elements.length; i++) {
        _collectHookTypes(
          elements[i],
          declName,
          [...path, 'item$i'],
          registry,
        );
      }
    default:
      break;
  }
}

/// The Dart type for a hook param or decode target.
String _hookDartType(TsIrType type, _TypeRegistry registry) {
  switch (type.kind) {
    case 'string':
      return 'String';
    case 'number':
      return 'num';
    case 'boolean':
      return 'bool';
    case 'any':
    case 'unknown':
    case 'void':
    case 'null':
    case 'reactNode':
    case 'hostValue':
    case 'union':
    case 'indexedAccess':
      return 'Object?';
    case 'literal':
      final literals = _uniqueLiterals(type.literals ?? const []);
      if (_isBoolUnion(literals)) return 'bool';
      if (literals.length >= 2) return _enumNameFor(type, registry);
      return _literalDartType(literals);
    case 'record':
    case 'urlSearchParams':
      if (type.kind == 'urlSearchParams') return 'Map<String, String>';
      final value = _hookDartType(
        type.element ?? const TsIrType(kind: 'any'),
        registry,
      );
      if (value == 'String' || value == 'num' || value == 'bool') {
        return 'Map<String, $value>';
      }
      return 'Map<String, Object?>';
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) return 'Object?';
      return _objectNameFor(type, registry);
    case 'array':
      final inner = _hookDartType(
        type.element ?? const TsIrType(kind: 'any'),
        registry,
      );
      if (inner == 'Object?') return 'List<Object?>';
      return 'List<$inner>';
    case 'function':
      return _hookFnSignature(type, registry);
    case 'tuple':
      final elements = type.elements ?? const <TsIrType>[];
      return '(${elements.map((e) => _hookDartType(e, registry)).join(', ')})';
    default:
      return 'Object?';
  }
}

/// Whether the last parameter is an object (an options bag). Such a param
/// becomes named Dart parameters instead of a positional object.
int _optionsSpreadIndex(List<TsIrProp> params) {
  if (params.isEmpty) return -1;
  final last = params.last;
  if (last.type.kind == 'object' &&
      (last.type.members ?? const <TsIrProp>[]).isNotEmpty) {
    return params.length - 1;
  }
  return -1;
}

/// Dart type for a function-type parameter. [required] distinguishes the
/// nullable/optional forms (`String? action` vs `String href`).
String _fnParamType(TsIrType type, {bool required = false}) {
  final base = switch (type.kind) {
    'string' => 'String',
    'number' => 'num',
    'boolean' => 'bool',
    _ => 'Object',
  };
  if (required && base == 'Object') return 'Object?';
  return required ? base : '$base?';
}

/// Loose Dart type for a hook's positional input parameters: inputs are
/// encoded with `jsify`, so structured values stay generic (`List<Object?>`)
/// rather than forcing generated value classes on the caller.
String _paramDartType(TsIrType type) {
  switch (type.kind) {
    case 'string':
      return 'String';
    case 'number':
      return 'num';
    case 'boolean':
      return 'bool';
    case 'array':
      return 'List<Object?>';
    default:
      return 'Object?';
  }
}

/// The inline Dart signature for a function type, e.g.
/// `void Function(Object? to, {bool? replace})`.
String _hookFnSignature(TsIrType type, _TypeRegistry registry) {
  final params = type.params ?? const <TsIrProp>[];
  final spreadIdx = _optionsSpreadIndex(params);
  final parts = <String>[];
  for (var i = 0; i < params.length; i++) {
    if (i == spreadIdx) continue;
    final p = params[i];
    final n = _safeParamName(p.name);
    // Function *types* cannot carry optional positional parameters in Dart,
    // so they are emitted as required-nullable instead of `[T? x]`.
    parts.add('${_fnParamType(p.type, required: p.required)} $n');
  }
  if (spreadIdx >= 0) {
    final members = params[spreadIdx].type.members ?? const <TsIrProp>[];
    final named = members
        .map((m) =>
            '${_nullableType(_hookDartType(m.type, registry), false)} ${_safeParamName(m.name)}')
        .join(', ');
    if (named.isNotEmpty) parts.add('{$named}');
  }
  final ret = type.returns == null || type.returns!.kind == 'void'
      ? 'void'
      : _hookDartType(type.returns!, registry);
  return '$ret Function(${parts.join(', ')})';
}

/// JS expression encoding a Dart argument before `callAsFunction`.
String _fnArg(String name, TsIrType type) {
  switch (type.kind) {
    case 'string':
    case 'number':
    case 'boolean':
      return '$name.toJS';
    default:
      return '$name.jsify()';
  }
}

/// Value expression for an options-map entry (enum values use `.value`).
String _fnArgValue(String name, TsIrType type) {
  if (type.kind == 'literal' && (type.literals ?? const []).length >= 2) {
    return '$name.value';
  }
  return name;
}

/// Builds `{'key': value, ...}` from non-null named options.
String _optionsMapLiteral(List<TsIrProp> members) {
  final entries = <String>[];
  for (final m in members) {
    final n = _safeParamName(m.name);
    entries.add("if ($n != null) '${m.name}': ${_fnArgValue(n, m.type)}");
  }
  return '<String, Object?>{${entries.join(', ')}}';
}

/// The JS return type declared on the per-hook external.
String _hookExternalReturn(TsIrType? returns) {
  switch (returns?.kind) {
    case 'string':
    case 'literal':
      final literals = _uniqueLiterals(returns?.literals ?? const []);
      if (_isBoolUnion(literals)) return 'JSBoolean';
      return 'JSString';
    case 'number':
      return 'JSNumber';
    case 'boolean':
      return 'JSBoolean';
    case 'record':
    case 'urlSearchParams':
    case 'object':
    case 'array':
    case 'tuple':
      return 'JSArray';
    case 'function':
      return 'JSFunction';
    default:
      return 'JSAny?';
  }
}

/// Decodes a JSAny? expression (a raw `callAsFunction`/array element result)
/// into a typed Dart expression.
String _elemDecode(TsIrType type, String expr, _TypeRegistry registry) {
  switch (type.kind) {
    case 'string':
      return '($expr as JSString).toDart';
    case 'number':
      return '($expr as JSNumber).toDart';
    case 'boolean':
      return '($expr as JSBoolean).toDart';
    case 'literal':
      final literals = _uniqueLiterals(type.literals ?? const []);
      if (_isBoolUnion(literals)) return '($expr as JSBoolean).toDart';
      if (literals.length >= 2) {
        return '${_enumNameFor(type, registry)}.fromValue(($expr as JSString).toDart)';
      }
      return _literalDartType(literals) == 'String'
          ? '($expr as JSString).toDart'
          : '($expr as JSNumber).toDart';
    case 'record':
    case 'urlSearchParams':
      return '_decodePairs($expr as JSArray)';
    case 'object':
      if ((type.members ?? const <TsIrProp>[]).isEmpty) return expr;
      return '${_objectNameFor(type, registry)}.fromJs($expr)';
    case 'array':
      final element = type.element ?? const TsIrType(kind: 'any');
      return '_decodeList($expr as JSArray, (e) => ${_elemDecode(element, 'e', registry)})';
    case 'function':
      return _fnClosure(type, '($expr as JSFunction)', registry);
    default:
      return expr;
  }
}

/// A closure that invokes the captured [fnExpr] later, with the function
/// type's Dart signature. Options bags spread into named parameters.
String _fnClosure(TsIrType type, String fnExpr, _TypeRegistry registry) {
  final params = type.params ?? const <TsIrProp>[];
  final returns = type.returns;
  final spreadIdx = _optionsSpreadIndex(params);
  final sig = <String>[];
  final callArgs = <String>[];
  for (var i = 0; i < params.length; i++) {
    if (i == spreadIdx) continue;
    final p = params[i];
    final n = _safeParamName(p.name);
    // Function *types* cannot carry optional positional parameters in Dart,
    // so they are emitted as required-nullable instead of `[T? x]`.
    final t = _fnParamType(p.type, required: p.required);
    sig.add('$t $n');
    callArgs.add(_fnArg(n, p.type));
  }
  if (spreadIdx >= 0) {
    final members = params[spreadIdx].type.members ?? const <TsIrProp>[];
    final named = members
        .map((m) =>
            '${_nullableType(_hookDartType(m.type, registry), false)} ${_safeParamName(m.name)}')
        .join(', ');
    if (named.isNotEmpty) sig.add('{$named}');
    callArgs.add('${_optionsMapLiteral(members)}.jsify()');
  }
  final invocation =
      '$fnExpr.callAsFunction(null${callArgs.isEmpty ? '' : ', ${callArgs.join(', ')}'})';
  if (returns == null || returns.kind == 'void') {
    return '(${sig.join(', ')}) { $invocation; }';
  }
  return '(${sig.join(', ')}) => ${_elemDecode(returns, invocation, registry)}';
}

/// Emits one hook: the `@JS` external + the typed public function.
String _emitHook(TsIrDeclaration hook, _TypeRegistry registry) {
  final name = hook.name;
  final rawName = '_${name}Raw';
  final params = hook.params;
  final returns = hook.returns;
  final spreadIdx = _optionsSpreadIndex(params);
  final hasOptions = spreadIdx >= 0;
  final positional = <TsIrProp>[];
  TsIrProp? options;
  for (var i = 0; i < params.length; i++) {
    if (i == spreadIdx) {
      options = params[i];
    } else {
      positional.add(params[i]);
    }
  }

  // External declaration — every arg is JSAny?, the return is typed so
  // dart2js never has to cast a raw callAsFunction result.
  final extArgs = [
    for (var i = 0; i < positional.length + (hasOptions ? 1 : 0); i++) 'JSAny? a$i',
  ].join(', ');
  final external = StringBuffer()
    ..writeln("@JS('globalThis.$bridgeTarget.$name')")
    ..writeln('external ${_hookExternalReturn(returns)} $rawName($extArgs);')
    ..writeln();

  // Public signature — inputs use the loose [_paramDartType] (they are
  // encoded with `jsify`), options members stay typed so enums encode via
  // `.value`.
  final sig = <String>[];
  for (final p in positional) {
    final n = _safeParamName(p.name);
    if (p.required) {
      sig.add('${_paramDartType(p.type)} $n');
    } else if (hasOptions) {
      // Dart cannot mix optional positional with named parameters, so
      // optional inputs become required-nullable when options are present.
      sig.add('${_nullableType(_paramDartType(p.type), false)} $n');
    } else {
      sig.add('[${_nullableType(_paramDartType(p.type), false)} $n]');
    }
  }
  if (hasOptions) {
    final members = options!.type.members ?? const <TsIrProp>[];
    final named = members
        .map((m) =>
            '${_nullableType(_hookDartType(m.type, registry), false)} ${_safeParamName(m.name)}')
        .join(', ');
    if (named.isNotEmpty) sig.add('{$named}');
  }
  final returnType = returns == null ? 'Object?' : _hookDartType(returns, registry);

  final buffer = StringBuffer()
    ..writeln('/// ${_hookDoc(hook)}')
    ..writeln('///')
    ..writeln('/// See https://reactrouter.com/hooks/${_hookUrl(name)}.')
    ..write(external.toString())
    ..writeln('$returnType $name(${sig.join(', ')}) {');

  // Options local (shared by the hook call and closure capture).
  if (hasOptions) {
    final members = options!.type.members ?? const <TsIrProp>[];
    buffer.writeln('  final options = ${_optionsMapLiteral(members)};');
  }
  final callArgs = <String>[
    for (final p in positional) '${_safeParamName(p.name)}.jsify()',
    if (hasOptions) 'options.jsify()',
  ];
  final call = '$rawName(${callArgs.join(', ')})';

  if (returns != null && returns.kind == 'function') {
    buffer
      ..writeln('  final fn = $call;')
      ..writeln('  return ${_fnClosure(returns, 'fn', registry)};');
  } else if (returns != null && returns.kind == 'tuple') {
    final elements = returns.elements ?? const <TsIrType>[];
    buffer.writeln('  final raw = $call;');
    final parts = <String>[];
    for (var i = 0; i < elements.length; i++) {
      parts.add(_elemDecode(elements[i], 'raw[$i]', registry));
    }
    buffer.writeln('  return (${parts.join(', ')});');
  } else {
    buffer.writeln('  return ${_topDecode(returns, call, registry)};');
  }
  buffer.writeln('}');
  return buffer.toString();
}

/// Decode for the top-level external call (whose return is already JSX).
String _topDecode(TsIrType? returns, String call, _TypeRegistry registry) {
  switch (returns?.kind) {
    case 'string':
    case 'number':
    case 'boolean':
      return '$call.toDart';
    case 'literal':
      final literals = _uniqueLiterals(returns!.literals ?? const []);
      if (_isBoolUnion(literals)) return '$call.toDart';
      if (literals.length >= 2) {
        return '${_enumNameFor(returns, registry)}.fromValue($call.toDart)';
      }
      return '$call.toDart';
    case 'record':
    case 'urlSearchParams':
      return '_decodePairs($call)';
    case 'object':
      if ((returns!.members ?? const <TsIrProp>[]).isEmpty) return call;
      return '${_objectNameFor(returns, registry)}.fromJs($call)';
    case 'array':
      final element = returns!.element ?? const TsIrType(kind: 'any');
      return '_decodeList($call, (e) => ${_elemDecode(element, 'e', registry)})';
    default:
      return call;
  }
}

String _hookDoc(TsIrDeclaration hook) {
  final params = hook.params
      .map((p) => '${p.name}${p.required ? '' : '?'}: ${_tsTypeDoc(p.type)}')
      .join(', ');
  final returns = hook.returns == null
      ? 'void'
      : _tsTypeDoc(hook.returns!);
  return '${hook.name}($params) => $returns';
}

String _hookUrl(String name) =>
    name.replaceFirst('use', '').toLowerCase().replaceAll(' ', '-');

/// Emits an extension type for direct JS property access and a value
/// class that wraps it for hook decode. The extension type provides
/// typed getters on the raw JS object, avoiding the generic
/// [[key, value]] pairs conversion.
String _emitHookClass(_ClassDef def, _TypeRegistry registry) {
  final props = def.type.members ?? const <TsIrProp>[];
  final className = def.name;
  final extName = '_${className}Js';
  final buffer = StringBuffer()
    ..writeln('/// Typed JS interop extension for `$className` hook return values.')
    ..writeln('///')
    ..writeln('/// Direct property access on the raw JS object avoids the')
    ..writeln('/// generic [[key, value]] pairs conversion used by')
    ..writeln('/// `_pairsMap` (removed in this generation).')
    ..writeln('extension type $extName(JSObject _) implements JSObject {')
    for (final prop in props) {
      final n = _safeParamName(prop.name);
      final dartType = _hookDartType(prop.type, registry);
      if (prop.type.kind == 'function') {
        buffer.writeln('  external JSFunction get $n;');
      } else {
        buffer.writeln('  external ${_nullableType(dartType, prop.required)} get $n;');
      }
    }
    buffer.writeln('}')
    ..writeln()
    ..writeln('/// Value class for `$className` (decoded from the hook shim).')
    ..writeln('///')
    ..writeln('/// ${_propsDoc(props)}')
    ..writeln('final class $className {')
    ..writeln('  const $className._(this._value);')
    ..writeln()
    ..writeln('  final $extName _value;')
    ..writeln();

  for (final prop in props) {
    final n = _safeParamName(prop.name);
    buffer
      ..writeln('  /// TS: ${_tsTypeDoc(prop.type)}')
      ..writeln(
        '  final ${_nullableType(_hookDartType(prop.type, registry), prop.required)} $n;',
      );
  }

  // Constructor that decodes from the extension type
  buffer.writeln()
    ..writeln('  $className($extName value) : this._(value);')
    ..writeln();

  // Factory from raw JSObject (for use with extension type)
  buffer.writeln("  /// Decodes the shim's raw JS object.")
    ..writeln('  factory $className.fromJs(JSObject js) => $className($extName(js));')
    ..writeln();

  // Generate getters that delegate to the extension type
  for (final prop in props) {
    final n = _safeParamName(prop.name);
    final dartType = _hookDartType(prop.type, registry);
    if (prop.type.kind == 'function') {
      buffer.writeln('  /// TS: ${_tsTypeDoc(prop.type)}')
        ..writeln('  ${_nullableType(dartType, prop.required)} get $n => _value.$n;')
        ..writeln();
    } else {
      buffer.writeln('  /// TS: ${_tsTypeDoc(prop.type)}')
        ..writeln('  ${_nullableType(dartType, prop.required)} get $n => _value.$n.toDart;')
        ..writeln();
    }
  }

  if (def.type.name == 'Location') {
    buffer
      ..writeln('  /// The full path including the query string.')
      ..writeln("  String get fullPath => '\$pathname\$search\$hash';")
      ..writeln()
      ..writeln('  @override')
      ..writeln('  String toString() => fullPath;');
  }
  buffer.writeln('}');
  return buffer.toString();
}

/// Adds `?` to [type] unless it is already nullable; required props keep
/// their declared type (`Object? state` stays `Object? state`, `String key`
/// stays `String key`).
String _nullableType(String type, bool required) =>
    required || type.endsWith('?') ? type : '$type?';

/// Decode for one class member (from the pairs map).
String _hookMemberDecode(
  TsIrProp prop,
  String source,
  String fnVar,
  _TypeRegistry registry,
) {
  if (prop.type.kind == 'function') {
    if (prop.required) {
      return _fnClosure(prop.type, fnVar, registry);
    }
    return '$source == null ? null : ${_fnClosure(prop.type, '($fnVar as JSFunction)', registry)}';
  }
  final decode = _elemDecode(prop.type, '$source!', registry);
  if (prop.required) return decode;
  return '$source == null ? null : $decode';
}

/// Generates a JS shim module that registers the bound components for the
/// foreign-component bridge (`__reactDartRegisterComponent`), so
/// `foreignComponent('prefix.Name', ...)` resolves at runtime.
///
/// When [declarations] contains `use*` hooks, the module also registers the
/// hook bridge under [namespace] (`globalThis.__reactDartBindings[namespace]`)
/// that the generated hooks file calls during render. When [namespace] is
/// empty, hooks register at `globalThis.__reactDartHooks` (legacy).
///
/// The module imports [specifier] from the managed npm environment and must be
/// wired into `react.yaml`:
///
/// ```yaml
/// foreign:
///   modules:
///     - path/to/generated_shim.mjs
/// ```
String generateShim({
  required String specifier,
  required String prefix,
  required List<TsIrDeclaration> declarations,
  String? commandLine,
  String namespace = '',
}) {
  final components = declarations.where((d) => d.kind == 'component');
  final hooks = declarations.where((d) => d.kind == 'hook').toList();
  final importName = upperCamel(specifier);
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE — DO NOT EDIT.')
    ..writeln('// Generated by: ${commandLine ?? 'react ts bind --shim'}')
    ..writeln('//')
    ..writeln('// Registers the bound `$specifier` components under the')
    ..writeln('// `$prefix.*` names used by the generated Dart helpers.')
    ..writeln('// Wire this module into react.yaml under `foreign.modules`.')
    ..writeln()
    ..writeln("import * as $importName from '$specifier';")
    ..writeln()
    ..writeln('const components = {');
  for (final declaration in components) {
    buffer.writeln("  '$prefix.${declaration.name}': $importName.${declaration.name},");
  }
  buffer
    ..writeln('};')
    ..writeln()
    ..writeln('for (const [name, component] of Object.entries(components)) {')
    ..writeln('  globalThis.__reactDartRegisterComponent?.(name, component);')
    ..writeln('}');

  if (hooks.isNotEmpty) {
    final bridgeTarget = namespace.isNotEmpty
        ? '__reactDartBindings.$namespace'
        : '__reactDartHooks';
    buffer
      ..writeln()
      ..writeln('// Hook bridge: the generated Dart hooks (`--hooks` output) call')
      ..writeln('// these members during render. Results are decoded into')
      ..writeln('// primitives or `[[key, value], ...]` pairs (via `toPairs`)')
      ..writeln('// because dart2js cannot cast a raw callAsFunction result.')
      ..writeln('const toPairs = (v) => {')
      ..writeln('  if (v == null) return v;')
      ..writeln('  if (Array.isArray(v)) return v.map(toPairs);')
      ..writeln("  if (typeof v === 'object') {")
      ..writeln("    if (typeof v.entries === 'function') return [...v.entries()];")
      ..writeln("    return Object.entries(v).map(([k, val]) => [k, toPairs(val)]);")
      ..writeln('  }')
      ..writeln('  return v;')
      ..writeln('};')
      ..writeln()
      ..writeln('const hooks = {');
    for (final hook in hooks) {
      buffer.writeln('  ${hook.name}: ${_jsHookBody(hook, importName)},');
    }
    buffer
      ..writeln('};')
      ..writeln();
    if (namespace.isNotEmpty) {
      buffer
        ..writeln('globalThis.__reactDartBindings ??= Object.create(null);')
        ..writeln('globalThis.__reactDartBindings.$namespace = hooks;')
        ..writeln();
    } else {
      buffer.writeln('globalThis.__reactDartHooks = hooks;');
    }
  }
  return buffer.toString();
}

/// The JS body for one hook bridge member.
String _jsHookBody(TsIrDeclaration hook, String mod) {
  final args = [for (var i = 0; i < hook.params.length; i++) 'a$i'].join(', ');
  final call = '$mod.${hook.name}($args)';
  final returns = hook.returns;
  const simple = {
    'string', 'number', 'boolean', 'any', 'unknown', 'void', 'null',
    'reactNode', 'hostValue', 'literal', 'function',
  };
  if (returns == null || simple.contains(returns.kind)) {
    return '($args) => $call';
  }
  final decode = _jsDecodeExpr(returns, 'v');
  return '($args) => { const v = $call; return $decode; }';
}

/// JS decode expression for a shim bridge return value.
String _jsDecodeExpr(TsIrType type, String expr) {
  switch (type.kind) {
    case 'record':
      return 'toPairs($expr ?? {})';
    case 'urlSearchParams':
      return 'toPairs($expr)';
    case 'object':
      // Known-shape objects are passed as raw JS objects; the
      // generated extension type provides typed property access.
      return expr;
    case 'array':
      return '($expr ?? []).map((x) => toPairs(x))';
    case 'tuple':
      final elements = type.elements ?? const <TsIrType>[];
      final parts = <String>[];
      for (var i = 0; i < elements.length; i++) {
        parts.add(_jsDecodeExpr(elements[i], '$expr[$i]'));
      }
      return '[${parts.join(', ')}]';
    default:
      return expr;
  }
}
