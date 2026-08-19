import 'dart:convert';
import 'dart:io';

final class ElementSnapshot {
  final Map<String, String> htmlTagToInterface;
  final Map<String, String> svgTagToInterface;
  final Set<String> htmlTags;
  final Set<String> svgTags;

  const ElementSnapshot({
    required this.htmlTagToInterface,
    required this.svgTagToInterface,
    required this.htmlTags,
    required this.svgTags,
  });

  String? interfaceFor(String tag, {required bool svg}) =>
      svg ? svgTagToInterface[tag] : htmlTagToInterface[tag];

  static ElementSnapshot load(String path) {
    final file = File(path);
    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final elements = data['elements'] as Map<String, dynamic>? ?? {};

    final htmlTagToInterface = <String, String>{};
    final svgTagToInterface = <String, String>{};
    final htmlTags = <String>{};
    final svgTags = <String>{};

    for (final specEntry in elements.entries) {
      for (final entry
          in (specEntry.value['elements'] as List<dynamic>? ?? [])) {
        final e = entry as Map<String, dynamic>;
        final name = e['name'] as String?;
        final interface = e['interface'] as String?;
        if (name != null && interface != null) {
          if (specEntry.key == 'html') {
            htmlTagToInterface[name] = interface;
            htmlTags.add(name);
          } else if (interface.startsWith('SVG')) {
            svgTagToInterface[name] = interface;
            svgTags.add(name);
          }
        }
      }
    }

    return ElementSnapshot(
      htmlTagToInterface: htmlTagToInterface,
      svgTagToInterface: svgTagToInterface,
      htmlTags: htmlTags,
      svgTags: svgTags,
    );
  }
}
