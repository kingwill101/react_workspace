import 'dart:convert';

import 'project_config.dart';

/// Merges the debug runtime into an existing map without losing app aliases,
/// scopes, or integrity metadata. React's runtime entries intentionally win.
String updateDebugImportMap(String source, Map<String, String> imports) {
  const start = '<!-- react_tool:debug-importmap:start -->';
  const end = '<!-- react_tool:debug-importmap:end -->';
  final startAt = source.indexOf(start);
  final endAt = source.indexOf(end);
  final marked = startAt >= 0 && endAt >= startAt;
  final region = marked ? source.substring(startAt, endAt) : source;
  final match = RegExp(
    r'''<script\b[^>]*\btype\s*=\s*["']importmap["'][^>]*>([\s\S]*?)</script\s*>''',
    caseSensitive: false,
  ).firstMatch(region);
  final document = <String, dynamic>{};
  if (match != null) {
    try {
      final value = jsonDecode(match.group(1)!);
      if (value is! Map<String, dynamic> ||
          (value['imports'] != null && value['imports'] is! Map)) {
        throw const FormatException('Expected an import map object.');
      }
      document.addAll(value);
    } on FormatException catch (error) {
      throw ReactToolException('Invalid authored import map: $error');
    }
  }
  document['imports'] = {...?document['imports'] as Map?, ...imports};
  final openingTag = match == null
      ? '<script type="importmap">'
      : match.group(0)!.substring(0, match.group(0)!.indexOf('>') + 1);
  final block =
      '''$start
$openingTag
${const JsonEncoder.withIndent('  ').convert(document)}
</script>
$end''';
  if (marked) {
    return source.replaceRange(startAt, endAt + end.length, block);
  }
  if (match != null) return source.replaceRange(match.start, match.end, block);
  final headEnd = RegExp(
    r'</head\s*>',
    caseSensitive: false,
  ).firstMatch(source);
  final doctypeEnd = RegExp(
    r'<!doctype\s+html\s*>',
    caseSensitive: false,
  ).firstMatch(source);
  final insertion = headEnd?.start ?? doctypeEnd?.end ?? 0;
  return source.replaceRange(insertion, insertion, '$block\n');
}
