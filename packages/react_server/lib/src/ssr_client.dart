import 'dart:convert';
import 'dart:io';

/// A rendered HTML document returned by the SSR worker.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
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
  }) async {
    final request = await _client.postUrl(endpoint);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'component': component, 'props': props}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'SSR worker returned HTTP ${response.statusCode}: $body',
        uri: endpoint,
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

  void close() => _client.close(force: true);
}
