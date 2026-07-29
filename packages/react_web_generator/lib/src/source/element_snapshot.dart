import 'dart:convert';
import 'dart:io';

final class ElementSnapshot {
  final Map<String, String> tagToInterface;
  final Set<String> htmlTags;

  const ElementSnapshot({
    required this.tagToInterface,
    required this.htmlTags,
  });

  String? interfaceFor(String tag) => tagToInterface[tag];

  static ElementSnapshot load(String path) {
    final file = File(path);
    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final elements = data['elements'] as Map<String, dynamic>? ?? {};

    final tagToInterface = <String, String>{};
    final htmlTags = <String>{};

    for (final specEntry in elements.entries) {
      for (final entry in (specEntry.value['elements'] as List<dynamic>? ?? [])) {
        final e = entry as Map<String, dynamic>;
        final name = e['name'] as String?;
        final interface = e['interface'] as String?;
        if (name != null && interface != null) {
          tagToInterface[name] = interface;
          if (specEntry.key == 'html') {
            htmlTags.add(name);
          }
        }
      }
    }

    return ElementSnapshot(
      tagToInterface: tagToInterface,
      htmlTags: htmlTags,
    );
  }
}
