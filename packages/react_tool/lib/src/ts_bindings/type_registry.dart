part of '../ts_bindings.dart';

// ---------------------------------------------------------------------------
// Dart code generation
// ---------------------------------------------------------------------------

const _kReservedWords = {
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
  'yield',
};

/// Camel-cases a declaration name: `MemoryRouter` → `memoryRouter`.
String lowerCamel(String name) {
  final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9]'), ' ');
  final words = cleaned.split(' ').where((w) => w.isNotEmpty).toList();
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
    final key = type.name != null
        ? 'named:${type.name}'
        : 'anon:${_signature(type)}';
    final existing = _nameByKey[key];
    if (existing != null) return existing;

    final name = type.name != null
        ? _typed(_uniqueName(upperCamel(type.name!)))
        : _typed(
            _uniqueName(
              '${upperCamel(declName)}${path.map(upperCamel).join()}',
            ),
          );
    if (reusedTypeNames.contains(name)) return name;
    _nameByKey[key] = name;
    final def = _ClassDef(name, type);
    classes[name] = def;
    return name;
  }

  String enumName(TsIrType type, String declName, List<String> path) {
    final key =
        'literal:${_uniqueLiterals(type.literals ?? const []).join('|')}';
    final existing = _nameByKey[key];
    if (existing != null) return existing;
    final name = type.name != null
        ? _typed(_uniqueName(upperCamel(type.name!)))
        : _typed(
            _uniqueName(
              '${upperCamel(declName)}${path.map(upperCamel).join()}',
            ),
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
      _uniqueName(
        '${upperCamel(declName)}${path.map(upperCamel).join()}Callback',
      ),
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
    final def = _ClassDef(
      name,
      TsIrType(kind: 'object', name: declName, members: props),
    );
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
      return 'Object?';
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
  final key = type.name != null
      ? 'named:${type.name}'
      : 'anon:${_signature(type)}';
  final existing = registry._nameByKey[key];
  if (existing != null) return existing;
  // Referenced before the walk saw it (should not happen): register with a
  // synthetic name derived from the type name or its signature hash.
  final name = type.name != null
      ? registry._uniqueName(upperCamel(type.name!))
      : registry._uniqueName(
          'Anon${type.kind}${_signature(type).hashCode.abs()}',
        );
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
      : registry._uniqueName(
          'Literal${type.kind}${_signature(type).hashCode.abs()}',
        );
  if (registry.reusedTypeNames.contains(name)) return name;
  registry._nameByKey[key] = name;
  registry.enums[name] = _EnumDef(name, type.literals ?? const []);
  return name;
}

String _typedefNameFor(TsIrType type, _TypeRegistry registry) {
  final key = 'function:${_signature(type)}';
  final existing = registry._nameByKey[key];
  if (existing != null) return existing;
  final name = registry._uniqueName(
    'Callback${_signature(type).hashCode.abs()}',
  );
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
  if (literal.length >= 2 && literal.startsWith('"') && literal.endsWith('"')) {
    return literal.substring(1, literal.length - 1);
  }
  if (literal == 'true') return true;
  if (literal == 'false') return false;
  final num = int.tryParse(literal) ?? double.tryParse(literal);
  return num;
}
