import 'ssr_types.dart';

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
