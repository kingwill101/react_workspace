import 'dart:convert';

/// Page-level metadata emitted into an SSR document head.
final class ReactPageMetadata {
  const ReactPageMetadata({
    this.title,
    this.description,
    this.canonical,
    this.openGraph = const <String, String>{},
    this.meta = const <ReactMetaTag>[],
    this.links = const <ReactLinkTag>[],
    this.jsonLd,
  });

  final String? title;
  final String? description;
  final String? canonical;
  final Map<String, String> openGraph;
  final List<ReactMetaTag> meta;
  final List<ReactLinkTag> links;
  final Object? jsonLd;

  /// Serializes metadata as safe HTML elements for a document head.
  String toHtml() {
    final output = StringBuffer();
    if (title != null) output.write('<title>${_text(title!)}</title>');
    if (description != null) {
      output.write(
        '<meta name="description" content="${_attribute(description!)}">',
      );
    }
    if (canonical != null) {
      output.write('<link rel="canonical" href="${_attribute(canonical!)}">');
    }
    for (final entry in openGraph.entries) {
      output.write(
        '<meta property="${_attribute(entry.key)}" '
        'content="${_attribute(entry.value)}">',
      );
    }
    for (final entry in meta) {
      output.write(entry.toHtml());
    }
    for (final entry in links) {
      output.write(entry.toHtml());
    }
    if (jsonLd != null) {
      output.write(
        '<script type="application/ld+json">'
        '${_jsonForHtml(jsonEncode(jsonLd))}</script>',
      );
    }
    return output.toString();
  }
}

/// An additional page-level meta tag.
final class ReactMetaTag {
  const ReactMetaTag({this.name, this.property, required this.content})
    : assert(name != null || property != null);

  final String? name;
  final String? property;
  final String content;

  String toHtml() {
    final key = name != null ? 'name' : 'property';
    final value = name ?? property!;
    return '<meta $key="${_attribute(value)}" '
        'content="${_attribute(content)}">';
  }
}

/// An additional page-level link tag.
final class ReactLinkTag {
  const ReactLinkTag({required this.rel, required this.href, this.type});

  final String rel;
  final String href;
  final String? type;

  String toHtml() {
    final typeAttribute = type == null ? '' : ' type="${_attribute(type!)}"';
    return '<link rel="${_attribute(rel)}" '
        'href="${_attribute(href)}"$typeAttribute>';
  }
}

/// Injects metadata at `{{HEAD}}` or immediately before `</head>`.
String injectReactPageMetadata(String template, ReactPageMetadata? metadata) {
  if (metadata == null) return template;
  final head = metadata.toHtml();
  if (template.contains('{{HEAD}}')) {
    return template.replaceAll('{{HEAD}}', head);
  }
  final closingHead = template.toLowerCase().indexOf('</head>');
  if (closingHead < 0) return template;
  return '${template.substring(0, closingHead)}$head'
      '${template.substring(closingHead)}';
}

String _text(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _attribute(String value) =>
    _text(value).replaceAll('"', '&quot;').replaceAll("'", '&#39;');

String _jsonForHtml(String value) => value
    .replaceAll('<', '\\u003c')
    .replaceAll('>', '\\u003e')
    .replaceAll('&', '\\u0026');
