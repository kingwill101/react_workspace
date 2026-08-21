/// Browser placeholder for the native SSR worker response.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
}

/// Browser placeholder for the native SSR worker client.
final class ReactSsrClient {
  ReactSsrClient({required Uri endpoint});

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
  }) => throw UnsupportedError(
    'ReactSsrClient is only available on native Dart.',
  );

  void close() {}
}
