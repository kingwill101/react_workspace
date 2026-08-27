import 'dart:convert';
import 'dart:io';

/// A rendered HTML document returned by the SSR worker.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
}

/// A chunk emitted by the generated streaming SSR worker.
final class ReactSsrStreamChunk {
  const ReactSsrStreamChunk._({
    this.html = '',
    this.props = const <String, dynamic>{},
    this.done = false,
  });

  /// An HTML chunk. Empty for the terminal event.
  final String html;

  /// Serialized props included by the terminal event.
  final Map<String, dynamic> props;

  /// Whether this is the terminal event.
  final bool done;

  factory ReactSsrStreamChunk.html(String html) =>
      ReactSsrStreamChunk._(html: html);

  factory ReactSsrStreamChunk.complete(Map<String, dynamic> props) =>
      ReactSsrStreamChunk._(props: props, done: true);
}

/// Native client for the generated Node SSR worker.
final class ReactSsrClient {
  final Uri endpoint;
  final HttpClient _client;

  ReactSsrClient({required this.endpoint, HttpClient? client})
    : _client = client ?? HttpClient();

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) async {
    final resolvedEndpoint = _resolveEndpoint(baseUri);
    final request = await _client.postUrl(resolvedEndpoint);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'component': component, 'props': props}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'SSR worker returned HTTP ${response.statusCode}: $body',
        uri: resolvedEndpoint,
      );
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map || decoded['html'] is! String) {
      throw const FormatException('Invalid SSR worker response.');
    }
    final rawProps = decoded['props'];
    return ReactSsrDocument(
      html: decoded['html'] as String,
      props: rawProps is Map
          ? Map<String, dynamic>.from(rawProps)
          : <String, dynamic>{},
    );
  }

  /// Streams HTML chunks from the generated Node SSR worker.
  ///
  /// The worker emits the shell as soon as React's streaming renderer is
  /// ready, followed by progressively rendered HTML and a terminal chunk
  /// containing the serialized props. The stream must be consumed to release
  /// the underlying HTTP response.
  Stream<ReactSsrStreamChunk> renderStream({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) async* {
    final resolvedEndpoint = _resolveEndpoint(baseUri);
    final request = await _client.postUrl(resolvedEndpoint);
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({'component': component, 'props': props, 'mode': 'stream'}),
    );
    final response = await request.close();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.transform(utf8.decoder).join();
      throw HttpException(
        'SSR worker returned HTTP ${response.statusCode}: $body',
        uri: resolvedEndpoint,
      );
    }

    await for (final line
        in response.transform(utf8.decoder).transform(const LineSplitter())) {
      if (line.isEmpty) continue;
      final decoded = jsonDecode(line);
      if (decoded is! Map || decoded['type'] is! String) {
        throw const FormatException('Invalid streaming SSR response.');
      }
      switch (decoded['type']) {
        case 'start':
          continue;
        case 'chunk':
          final html = decoded['html'];
          if (html is! String) {
            throw const FormatException('Invalid streaming SSR HTML chunk.');
          }
          yield ReactSsrStreamChunk.html(html);
        case 'end':
          final rawProps = decoded['props'];
          yield ReactSsrStreamChunk.complete(
            rawProps is Map
                ? Map<String, dynamic>.from(rawProps)
                : <String, dynamic>{},
          );
        case 'error':
          throw HttpException(
            'SSR worker stream failed: ${decoded['error'] ?? 'unknown error'}',
            uri: endpoint,
          );
        default:
          throw const FormatException('Unknown streaming SSR event.');
      }
    }
  }

  void close() => _client.close(force: true);

  Uri _resolveEndpoint(Uri? baseUri) => endpoint.isAbsolute || baseUri == null
      ? endpoint
      : baseUri.resolveUri(endpoint);
}
