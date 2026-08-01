import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;

/// The result of compiling a stylesheet, including optional CSS Module names.
final class ReactStyleResult {
  final String css;
  final Map<String, String> classes;

  const ReactStyleResult({required this.css, this.classes = const {}});

  bool get isModule => classes.isNotEmpty;
}

/// Compiles Sass/CSS and applies the small, deterministic CSS Modules ABI used
/// by the React Dart CLI. The ABI intentionally mirrors the useful common
/// subset of CSS Modules: local class selectors become stable scoped names and
/// a generated Dart class exposes those names to components.
final class ReactStyleCompiler {
  final bool release;
  final String identity;

  const ReactStyleCompiler({required this.release, required this.identity});

  ReactStyleResult compile(String inputPath) {
    final result = sass.compileToResult(
      inputPath,
      style: release ? sass.OutputStyle.compressed : sass.OutputStyle.expanded,
    );
    final isModule = p.basename(inputPath).contains('.module.');
    if (!isModule) return ReactStyleResult(css: result.css);

    final classes = _classes(result.css);
    final scoped = {
      for (final className in classes)
        className: '${className}__${_hash('$identity:$className')}',
    };
    var css = result.css;
    for (final entry in scoped.entries) {
      css = css.replaceAll(
        RegExp(r'\.' + RegExp.escape(entry.key) + r'\b'),
        '.${entry.value}',
      );
    }
    return ReactStyleResult(css: css, classes: scoped);
  }

  static Set<String> _classes(String css) {
    final names = <String>{};
    final pattern = RegExp(r'\.([_a-zA-Z][\w-]*)');
    for (final match in pattern.allMatches(css)) {
      final name = match.group(1);
      if (name != null) names.add(name);
    }
    return names;
  }

  static String _hash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0').substring(0, 6);
  }
}

/// Writes a Dart binding for the classes exported by a CSS Module.
String emitCssModuleBindings({
  required String sourcePath,
  required Map<String, String> classes,
}) {
  final basename = p.basenameWithoutExtension(sourcePath);
  final className = '${_dartTypeIdentifier(basename)}Styles';
  final names = <String, String>{};
  for (final original in classes.keys) {
    var name = _dartIdentifier(original);
    if (name.isEmpty) name = 'className';
    var candidate = name;
    var suffix = 2;
    while (names.containsKey(candidate)) {
      candidate = '$name$suffix';
      suffix++;
    }
    names[candidate] = original;
  }

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: ${p.basename(sourcePath)}')
    ..writeln()
    ..writeln('final class $className {')
    ..writeln('  $className._();');
  for (final entry in names.entries) {
    buffer.writeln("  static const ${entry.key} = '${classes[entry.value]}';");
  }
  buffer.writeln('}');
  return buffer.toString();
}

String _dartTypeIdentifier(String value) {
  final words = value.split(RegExp(r'[^a-zA-Z0-9]+'))
    ..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return 'Styles';
  final result = words
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join();
  return RegExp(r'^[0-9]').hasMatch(result) ? '_$result' : result;
}

String _dartIdentifier(String value) {
  final words = value.split(RegExp(r'[^a-zA-Z0-9]+'))
    ..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return '';
  final first = words.first;
  final result =
      first[0].toLowerCase() +
      first.substring(1) +
      words
          .skip(1)
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join();
  return RegExp(r'^[0-9]').hasMatch(result) ? '_$result' : result;
}
