/// A rendered HTML document returned by an SSR service.
final class ReactSsrDocument {
  const ReactSsrDocument({required this.html, required this.props});

  final String html;
  final Map<String, dynamic> props;
}

/// A chunk emitted by a streaming SSR service.
final class ReactSsrStreamChunk {
  const ReactSsrStreamChunk._({
    this.html = '',
    this.props = const <String, dynamic>{},
    this.done = false,
  });

  final String html;
  final Map<String, dynamic> props;
  final bool done;

  factory ReactSsrStreamChunk.html(String html) =>
      ReactSsrStreamChunk._(html: html);

  factory ReactSsrStreamChunk.complete(Map<String, dynamic> props) =>
      ReactSsrStreamChunk._(props: props, done: true);
}
