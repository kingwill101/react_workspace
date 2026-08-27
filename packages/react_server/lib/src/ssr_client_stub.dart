/// Placeholder for runtimes without a supported SSR transport.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
}

/// Browser placeholder for a native streaming SSR chunk.
final class ReactSsrStreamChunk {
  const ReactSsrStreamChunk({
    this.html = '',
    this.props = const <String, dynamic>{},
    this.done = false,
  });

  final String html;
  final Map<String, dynamic> props;
  final bool done;
}

/// Browser placeholder for the native SSR worker client.
final class ReactSsrClient {
  ReactSsrClient({required Uri endpoint});

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) => throw UnsupportedError(
    'ReactSsrClient is only available on native Dart.',
  );

  Stream<ReactSsrStreamChunk> renderStream({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) => throw UnsupportedError(
    'ReactSsrClient is only available on native Dart.',
  );

  void close() {}
}
